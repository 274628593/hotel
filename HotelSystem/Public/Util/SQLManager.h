//
//  SQLManager.h
//  HotelSystem
//
//  Created by hancj on 15/11/17.
//  Copyright © 2015年 hancj. All rights reserved.
//

#import <Foundation/Foundation.h>

/** SQL数据库管理器 */
@interface SQLManager : NSObject

// ==============================================================================================
#pragma mark -  外部调用方法
/** 获取数据表的所有数据 */
- (NSArray*) getTableAllData:(NSString*)v_strTableName;

/** 根据条件搜索符合的数据 */
- (NSArray*) getTableRowData:(NSString*)v_strTableName _condition:(NSDictionary*)v_dicCondition;

/** 插入数据库数据，如果存在则覆盖 */
- (BOOL) updateTable:(NSString*)v_strTableName _data:(NSDictionary*)v_dicData _uniqueKey:(NSString*)v_strUniqueKey;

/** 关闭数据库 */
- (void) closeSQL;

/** 删除数据库表 */
- (BOOL) deleteTable:(NSString*)v_strTableName;

/** 删除数据的某一行数据 */
- (BOOL) deleteData:(NSString*)v_strTableName _key:(NSString*)v_strKey _value:(NSString*)v_strValue;

// ==============================================================================================
#pragma mark -  外部变量
/** 数据库文件名，调用数据库操作前必须初始化这个参数 */
@property(nonatomic, copy, setter=setSQLiteFileName:, getter=getSQLiteFileName) NSString *m_strSQLiteFileName;

@end