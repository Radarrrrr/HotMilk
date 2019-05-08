//
//  RDFMDBAgent.h
//  HotMilk
//
//  Created by radar on 2019/4/29.
//  Copyright © 2019 radar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"

@interface RDFMDBAgent : NSObject

+ (instancetype)sharedAgent; //单实例

//[注意，create方法必须实现两种之一，否则后面不能打开数据库]

//根据名称直接创建sqlie，返回是否创建成功  
//PS:name格式为 name.sqlite 或者 DOC/SQL/name.sqlite ，本方法只到document文件夹根路径，具体文件夹路径自己写宏即可
- (BOOL)createSQLiteByName:(NSString *)name; 

//从bundle里边直接复制一份sqlite过去，返回是否创建成功，如果sqlite已经存在，就不复制了
//PS:name格式为 name.sqlite 或者 DOC/SQL/name.sqlite ，本方法只到document文件夹根路径，具体文件夹路径自己写宏即可
- (BOOL)createSQLiteByBundleMigrant:(NSString *)migrantName useName:(NSString *)name;


- (BOOL)removeSQLite:(NSString *)name;  //删除现有的sqlite，用于从bundle里边更新一个新的sqlite进去, 或者清空缓存等


//PS: 这俩方法必做，为了仪式感
- (FMDatabase *)openSQLite:(NSString *)name; //打开sqlite文件 PS:本方法只负责打开，不管创建，如果之前没有创建过就打不开
- (void)closeSQLite:(NSString *)name; //关闭name对应的sqlite文件


//创建表，columns格式如下：
//column格式: 第一个为字段名，后面跟着类型，空格分开
/*
 @"id integer primary key autoincrement" 
 @"username text not null, 
 @"phone text not null, 
 @"age integer
*/
- (BOOL)createTableInSQLite:(NSString *)name 
                  tableName:(NSString *)tableName 
                    columns:(NSString*)firstColumn, ... NS_REQUIRES_NIL_TERMINATION;


//- (void)openSQLite:(NSString *)name completion:(void (^)(FMDatabase *db))completion; 
@end

