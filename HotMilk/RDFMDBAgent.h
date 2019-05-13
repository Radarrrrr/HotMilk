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


//增删改查   
//PS: 数据字典，key为字段关键字，value为内容，interger格式转为NSNumber格式录入字典

- (BOOL)insertDataToSQLite:(NSString *)name table:(NSString *)tableName useParameters:(NSDictionary *)paramsDic;  //插入一行数据

- (BOOL)deleteDataFromSQLite:(NSString *)name table:(NSString *)tableName byParameters:(NSDictionary *)paramsDic; //删除一行数据， PS:只处理 key1=value1 and key2=value2 这种形式， 暂不支持大于号和小于号的形式

- (BOOL)updateDataForSQLite:(NSString *)name table:(NSString *)tableName        //更新某一列的值，目前只做更新一列并且条件也只有一列，如需组合，就使用纯SQL语句的纯SQL方法
                  setColumn:(NSString *)column toValue:(id)value                //PS:value和conditionValue只允许NSString和NSNumber两种类型
                      where:(NSString *)conditionColumn isValue:(id)conditionValue;

- (NSArray *)selectDataFormSQLite:(NSString *)name table:(NSString *)tableName     //查询paramsDic条件下colmns列对应的数据，返回字典结构
                       getColumns:(NSArray *)columns                               //本方法中，columns不能为nil
                     byParameters:(NSDictionary *)paramsDic;



//走纯SQL语句的方法，用于处理前面简易方法处理不了的地方
//PS:如果是增删改，返回NSNumber格式的BOOL值表示是否成功
//   如果是查询，返回FMResultSet格式的数据
- (id)executeSQL:(NSString *)sql onSQLite:(NSString *)name;  


@end

