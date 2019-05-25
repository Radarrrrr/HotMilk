//
//  HMDataCenter.m
//  HotMilk
//
//  Created by radar on 2019/5/21.
//  Copyright © 2019 radar. All rights reserved.
//

#import "HMDataCenter.h"
#import "RDFMDBAgent.h"


@implementation BabyRecord

@end


@implementation HMDataCenter


+ (void)prepareSQLite
{
    //数据库准备工作 包含: create db + open db + create table
    [[RDFMDBAgent sharedAgent] createSQLiteByName:sqlite_dbname];
    [[RDFMDBAgent sharedAgent] openSQLite:sqlite_dbname];
    
    [[RDFMDBAgent sharedAgent] createTableInSQLite:sqlite_dbname 
                                         tableName:sqlite_table_dot 
                                           columns:@"day text not null",    //2019-05-09  
                                                   @"time text not null",   //07:30
                                                   @"count text not null",      //100 / 1 / 0 
                                                   @"type text not null",    //milk / food / vitamin   //PS ad / gai / tie / bian 都算vitamin
                                                   @"subtype text not null", //milk / ad / gai / tie / bian
                                                   nil];
    
    [[RDFMDBAgent sharedAgent] createTableInSQLite:sqlite_dbname 
                                         tableName:sqlite_table_six 
                                           columns:@"day text not null",    //2019-05-09      
                                                   @"time text not null",   //07:30
                                                   @"count text not null",      //100 / 1 / 0 
                                                   @"type text not null",    //milk / food / vitamin   //PS ad / gai / tie / bian 都算vitamin
                                                   @"subtype text not null", //milk / ad / gai / tie / bian
                                                   nil];
}

+ (void)closeSQLite
{
    //关闭数据库
    [[RDFMDBAgent sharedAgent] closeSQLite:sqlite_dbname];
}


+ (NSString *)tableNameForBaby:(NSString *)baby
{
    if(!baby) return nil;
    
    NSString *tableName = nil;
    
    if([baby isEqualToString:@"dot"])
    {
        tableName = sqlite_table_dot;
    }
    else if([baby isEqualToString:@"six"])
    {
        tableName = sqlite_table_six;
    }
    
    return tableName;
}

+ (BOOL)isMyBaby:(NSString *)baby
{
    if(!baby || [baby isEqualToString:@""]) return NO;
    
    if([baby isEqualToString:@"dot"]) return YES;
    if([baby isEqualToString:@"six"]) return YES;
    
    return NO;
}


+ (BOOL)saveRecordForBaby:(NSString*)baby record:(BabyRecord*)record 
{
    if(!MYBABY(baby)) return NO;
    if(!record) return NO;
    
    
    //组装数据
    NSDictionary *params = @{@"day":record.day,
                             @"time":record.time,
                             @"count":record.count,
                             @"type":record.type
                             };
    
    //插入数据
    BOOL ret = [[RDFMDBAgent sharedAgent] insertDataToSQLite:sqlite_dbname table:TABLE(baby) useParameters:params];
    
    return ret;
}

+ (BOOL)updateVitaminForBaby:(NSString*)baby atDay:(NSString*)day atSubtype:(NSString*)subtype useCount:(NSString*)count
{
    //day：2019-05-09  //subtype: ad / gai / tie / bian //count: 0 / 1
    if(!MYBABY(baby)) return NO;
    if(!STRVALID(day)) return NO;
    if(!STRVALID(subtype)) return NO;
    if(!STRVALID(count)) return NO;

    //组装argus
    NSDictionary *argus = @{@"count":count};
    
    //组装params
    NSDictionary *params = @{@"day":day,
                             @"subtype":subtype
                            };
    
    BOOL ret = [[RDFMDBAgent sharedAgent] updateDataForSQLite:sqlite_dbname table:TABLE(baby) 
                                                 setArguments:argus 
                                              whereParameters:params];
    
    return ret;
}


+ (NSArray *)loadVitaminsForBaby:(NSString*)baby atDay:(NSString*)day
{
    //baby: @"dot" or @"six" //day：2019-05-09 //返回BabyRecord数组
    if(!MYBABY(baby)) return nil;
    if(!STRVALID(day)) return nil;
    
//    @"day text not null",  //2019-05-09  
//    @"time text not null", //07:30
//    @"count text not null",      //100 / 1 / 0 
//    @"type text not null",    //milk / food / vitamin   //PS ad / gai / tie / bian 都算vitamin
//    @"subtype text not null", //milk / ad / gai / tie / bian
    
    NSArray *columns = @[@"day", @"time", @"count", @"type", @"subtype"];
    NSDictionary *params = @{@"day":day,
                             @"type":@"vitamin"
                             };
    
    NSArray *datas = [[RDFMDBAgent sharedAgent] selectDataFormSQLite:sqlite_dbname table:TABLE(baby) 
                                                          getColumns:columns 
                                                        byParameters:params];
    
    if(!datas || [datas count] == 0) return nil;
    
    NSMutableArray *records = [[NSMutableArray alloc] init];
    
    for(NSDictionary *dic in datas)
    {
        BabyRecord *reco = [[BabyRecord alloc] init];
        
        reco.day     = [dic objectForKey:@"day"];
        reco.time    = [dic objectForKey:@"time"];
        reco.count   = [dic objectForKey:@"count"];
        reco.type    = [dic objectForKey:@"type"];
        reco.subtype = [dic objectForKey:@"subtype"];

        [records addObject:reco];
    }
    
    return records;
}

+ (NSArray *)loadMilkForBaby:(NSString*)baby atDay:(NSString*)day
{
    //baby: @"dot" or @"six" //day：2019-05-09 //返回BabyRecord数组
    if(!MYBABY(baby)) return nil;
    if(!STRVALID(day)) return nil;
    
    //    @"day text not null",  //2019-05-09  
    //    @"time text not null", //07:30
    //    @"count text not null",      //100 / 1 / 0 
    //    @"type text not null",    //milk / food / vitamin   //PS ad / gai / tie / bian 都算vitamin
    //    @"subtype text not null", //milk / ad / gai / tie / bian
    
    NSArray *columns = @[@"day", @"time", @"count", @"type", @"subtype"];
    NSDictionary *params = @{@"day":day,
                             @"type":@"milk"
                             };
    
    NSArray *datas = [[RDFMDBAgent sharedAgent] selectDataFormSQLite:sqlite_dbname table:TABLE(baby) 
                                                          getColumns:columns 
                                                        byParameters:params];
    
    if(!datas || [datas count] == 0) return nil;
    
    NSMutableArray *records = [[NSMutableArray alloc] init];
    
    for(NSDictionary *dic in datas)
    {
        BabyRecord *reco = [[BabyRecord alloc] init];
        
        reco.day     = [dic objectForKey:@"day"];
        reco.time    = [dic objectForKey:@"time"];
        reco.count   = [dic objectForKey:@"count"];
        reco.type    = [dic objectForKey:@"type"];
        reco.subtype = [dic objectForKey:@"subtype"];
        
        [records addObject:reco];
    }
    
    return records;
}





@end
