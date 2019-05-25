//
//  HMDataCenter.h
//  HotMilk
//
//  Created by radar on 2019/5/21.
//  Copyright © 2019 radar. All rights reserved.
//

//数据中转类

#import <Foundation/Foundation.h>


#define sqlite_dbname    @"babys.sqlite"    //数据库名
#define sqlite_table_dot @"dotbaby_records" //表名
#define sqlite_table_six @"sixbaby_records" //表名

#define TABLE(baby)  [HMDataCenter tableNameForBaby:baby]
#define MYBABY(baby) [HMDataCenter isMyBaby:baby]

@interface BabyRecord : NSObject

@property (nonatomic, copy) NSString *day;      //日期    //格式：2019-05-09
@property (nonatomic, copy) NSString *time;     //时间    //格式：07:30
@property (nonatomic, copy) NSString *count;    //量      //100(表示奶量) / 1 / 0  （1和0表示ad钙铁便是否有）
@property (nonatomic, copy) NSString *type;     //数据类型 //milk / food / vitamin   //PS: ad, gai, tie, bian 都算vitamin
@property (nonatomic, copy) NSString *subtype;  //数据类型 //milk / ad / gai / tie / bian / 米糊 / 南瓜 / ...

@end



@interface HMDataCenter : NSObject

+ (void)prepareSQLite;  //数据库准备工作 包含: create db + open db + create table
+ (void)closeSQLite;    //关闭数据库 ...好像用不上...

+ (BOOL)saveRecordForBaby:(NSString*)baby record:(BabyRecord*)record;   //baby: @"dot" or @"six" 
+ (BOOL)updateVitaminForBaby:(NSString*)baby atDay:(NSString*)day atSubtype:(NSString*)subtype useCount:(NSString*)count; //day：2019-05-09  //subtype: ad / gai / tie / bian //count: 0 / 1

+ (NSArray *)loadVitaminsForBaby:(NSString*)baby atDay:(NSString*)day;  //baby: @"dot" or @"six" //day：2019-05-09 //返回BabyRecord数组
+ (NSArray *)loadMilkForBaby:(NSString*)baby atDay:(NSString*)day;  //baby: @"dot" or @"six" //day：2019-05-09 //返回BabyRecord数组



@end


