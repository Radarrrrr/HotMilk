//
//  RDFMDBAgent.m
//  HotMilk
//
//  Created by radar on 2019/4/29.
//  Copyright © 2019 radar. All rights reserved.
//

#import "RDFMDBAgent.h"


@interface RDFMDBAgent ()

@property (nonatomic, strong) NSMutableDictionary *dbPool;  //hold状态的db池子，根据db名字做标志

@end



@implementation RDFMDBAgent

- (id)init{
    self = [super init];
    if(self){
        
        self.dbPool = [[NSMutableDictionary alloc] init];
    }
    return self;
}
+ (instancetype)sharedAgent
{
    static dispatch_once_t onceToken;
    static RDFMDBAgent *agent;
    dispatch_once(&onceToken, ^{
        agent = [[RDFMDBAgent alloc] init];
    });
    return agent;
}



- (NSString *)pathForDBName:(NSString *)name //name可以带上前续文件夹，斜线分割
{
    if(!name || [name isEqualToString:@""]) return nil;
    
    //创建database路径
    NSString *docuPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *dbPath = [docuPath stringByAppendingPathComponent:name];
    
    return dbPath;
}

- (BOOL)createSQLiteByName:(NSString *)name
{
    if(!name || [name isEqualToString:@""]) return NO;
    
    //创建database路径
    NSString *dbPath = [self pathForDBName:name];
    
    //创建对应路径下数据库,如果这个数据库不存在，就会自动创建
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    
    if(db) 
    {
        NSLog(@"create db success : %@", dbPath);
        
        //开关一次，用以创建文件
        if([db open])
        {
            [db close];
        }
        return YES;
    }
    
    NSLog(@"create db fail : %@", dbPath);
    return NO;
}

- (BOOL)createSQLiteByBundleMigrant:(NSString *)migrantName useName:(NSString *)name;
{
    if(!migrantName || [migrantName isEqualToString:@""]) return NO;
    if(!name || [name isEqualToString:@""]) return NO;
    
    //创建database路径
    NSString *migrantPath = [[NSBundle mainBundle] pathForResource:migrantName ofType:nil];
    NSString *dbPath = [self pathForDBName:name];
    
    //查看是否有移民数据库，有的话，移动过去，就不创建新的了
    NSFileManager *fm = [NSFileManager defaultManager];
    NSError* copyError = nil;
    
    //如果已经存在，就不理了
    if([fm fileExistsAtPath:dbPath]) return YES;
    
    //不存在就复制过去
    [fm copyItemAtPath:migrantPath toPath:dbPath error:&copyError];
    
    if(copyError == nil) 
    {
        NSLog(@"migrant db success : %@", dbPath);
        return YES;
    }
    
    NSLog(@"migrant db fail : %@", dbPath);
    return NO;
}

- (BOOL)removeSQLite:(NSString *)name
{
    if(!name || [name isEqualToString:@""]) return NO;
    
    //先关闭sqlite
    [self closeSQLite:name];
    
    //移除
    NSString *dbPath = [self pathForDBName:name];
    NSError* copyError = nil;
    
    NSFileManager *fm = [NSFileManager defaultManager];
    if(![fm fileExistsAtPath:dbPath]) return YES;
    
    //移除db
    [fm removeItemAtPath:dbPath error:&copyError];
    
    if(copyError == nil) 
    {
        NSLog(@"remove db success : %@", dbPath);
        return YES;
    }
    
    NSLog(@"remove db fail : %@", dbPath);
    return NO;
}


- (FMDatabase *)openSQLite:(NSString *)name
{
    if(!name || [name isEqualToString:@""]) return nil;
    
    //先在dbPool里查看是否已经是打开的了,如果已经打开了，就直接返回了
    FMDatabase *openingDB = [_dbPool objectForKey:name];
    if(openingDB) return openingDB; 
    
    //1.创建database路径
    NSString *dbPath = [self pathForDBName:name];
    
    NSFileManager *fm = [NSFileManager defaultManager];

    //判断是否存在数据库
    if(![fm fileExistsAtPath:dbPath]) return nil;
    
    //找到数据库
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    if(!db) return nil;
    
    //打开数据库
    BOOL ret = [db open];
    if(ret) 
    {
        NSLog(@"db open success: %@", dbPath);
        
        //打开成功，加入dbPool，hold住
        [_dbPool setObject:db forKey:name];
        
        return db;
    }
    else
    {
        NSLog(@"db open fail: %@", dbPath);
        return nil;
    }
}

- (void)closeSQLite:(NSString *)name
{
    if(!name || [name isEqualToString:@""]) return;
    
    //先在dbPool里查看是否已经打开了
    FMDatabase *openingDB = [_dbPool objectForKey:name];
    if(!openingDB) return;
    
    [openingDB close];
    [_dbPool removeObjectForKey:name];
}

- (BOOL)createTableInSQLite:(NSString *)name 
                  tableName:(NSString *)tableName 
                    columns:(NSString*)firstColumn, ...
{
    //column格式: 第一个为字段名，后面跟着类型，空格分开
    /*
    @"id integer primary key autoincrement" 
    @"username text not null, 
    @"phone text not null, 
    @"age integer
    */
    
    //NSString *createTableSql = @"create table if not exists User(id integer primary key autoincrement, username text not null, phone text not null, age integer)";
    
    if(!name || [name isEqualToString:@""]) return NO;
    if(!tableName || [tableName isEqualToString:@""]) return NO;
    
    //找到已经打开了的数据库，前提是必须打开了，本方法不做打开，如果前面没打开，直接返回创建失败
    FMDatabase *openingDB = [_dbPool objectForKey:name];
    if(!openingDB) return NO; 
    
    
    //SQL语句组装
    NSString *createTableSql = nil;
    
    //添加表名
    createTableSql = [NSString stringWithFormat:@"create table if not exists %@(", tableName];

    //循环添加表字段, 此处不做NSString类型校验了
    if(firstColumn) //第一段表字段属性
    {
        id obj;
        va_list args;
        va_start(args, firstColumn); // Start scanning for arguments after firstColumn.
        
        //添加firstOjbect
        createTableSql = [createTableSql stringByAppendingString:firstColumn];
        
        //添加下一个以后的obj
        while((obj = va_arg(args, id)))
        {
            createTableSql = [createTableSql stringByAppendingFormat:@", %@", obj];
        }
        
        //补齐后括弧
        createTableSql = [createTableSql stringByAppendingString:@")"];
        
        va_end(args);
    }
    
    
    //执行更新操作
    BOOL result = [openingDB executeUpdate:createTableSql];
    if(result) 
    {
        NSLog(@"create table success");
        return YES;
    }
    
    return NO;
}

@end
