//
//  SQLManager.m
//  HotelSystem
//
//  Created by hancj on 15/11/17.
//  Copyright © 2015年 hancj. All rights reserved.
//

#import "SQLManager.h"
#import <sqlite3.h>
#import "CPublic.h"

//#define SQLiteFileName  @"HotelSystemData.sqlite"

@implementation SQLManager
{
    sqlite3     *m_sqlite;
}
@synthesize m_strSQLiteFileName;

// ==============================================================================================
#pragma mark 基类方法
- (instancetype)init
{
    return [super init];
}
- (void) dealloc
{
    [self closeSQL];
}
// ==============================================================================================
#pragma mark 内部使用方法
/** 初始化数据库对象 */
- (void) initSQLite
{
    if(m_sqlite == nil){
        NSArray *aryPaths = NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES);
        NSString *strDocuments = [aryPaths objectAtIndex:0];
        strDocuments = [strDocuments stringByAppendingString:@"\\HotelSystemDataManager\\"];
        [CPublic createLocalFilePathIfNoExit:strDocuments];
        NSString *strPath = [strDocuments stringByAppendingString:m_strSQLiteFileName];
        if(sqlite3_open([strPath UTF8String], &m_sqlite) != SQLITE_OK){
            sqlite3_close(m_sqlite);
            NSLog(@"数据库打开失败");
        }
    }
}
/** 执行SQL指令 */
- (BOOL) execSql:(NSString*)v_strSQL
{
    char *error;
    if(sqlite3_exec(m_sqlite, [v_strSQL UTF8String], NULL, NULL, &error) != SQLITE_OK){
        NSString *encrypted = [[NSString alloc] initWithCString:(const char*)error encoding:NSASCIIStringEncoding];
        NSLog(@"数据库操作数据失败: %@", encrypted);
        return NO;
    }
    return YES;
}
/** 判断是否已经有这条数据 */
- (BOOL) isHaveThisDataAtTable:(NSString*)v_strTable
                          _key:(NSString*)v_strKey
                        _value:(NSString*)v_strValue
{
    BOOL            bResult = NO;
    NSString        *strSQL = [NSString stringWithFormat:@"Select * From %@ Where %@='%@'", v_strTable, v_strKey, v_strValue];
    sqlite3_stmt    *stateMent;
    
    if(sqlite3_prepare(m_sqlite, [strSQL UTF8String], -1, &stateMent, nil) == SQLITE_OK){
        if(sqlite3_step(stateMent) == SQLITE_ROW){
            int count = sqlite3_column_count(stateMent);
            if(count == 0){
                bResult = NO;
            } else {
                bResult = YES;
            }
        }
    }
    sqlite3_finalize(stateMent);
    
    return bResult;
}
/** 获取创建数据库表的参数字段 */
- (NSString*) getParams_createSQLTable:(NSDictionary*)v_dicData
{
    NSString *strRS = @"";
    if(v_dicData == nil) { return strRS; }
    
    BOOL bIsFir = YES;
    NSArray *aryKeys = [v_dicData allKeys];
    for(NSString *strKey in aryKeys)
    {
        if(bIsFir != YES){
            strRS = [strRS stringByAppendingString:@", "];
        }
        bIsFir = NO;
        strRS = [strRS stringByAppendingFormat:@"%@ TEXT", strKey];
    }
    
    return strRS;
}
/** 刷新表数据的参数 */
- (NSString*) getParams:(NSDictionary*)v_dicParams
{
    NSString *strResult = @"";
    if(v_dicParams == NULL) return strResult;
    
    @try{
        BOOL        bFirst = true;
        NSString    *strValue = @"";
        for(NSString *strKey in v_dicParams)
        {
            if(bFirst == false){
                strResult = [NSString stringWithFormat:@"%@%@", strResult, @", "];
            }
            bFirst = false;
            id value = [v_dicParams objectForKey:strKey];
            if([value isKindOfClass:[NSNumber class]] == YES){ // 数字转化成字符串
                strValue = [NSString stringWithFormat:@"%li", [(NSNumber*)value longValue]];
                
            } else {
                strValue = (NSString*)value;
            }
            
            strResult = [NSString stringWithFormat:@"%@%@='%@'", strResult, strKey, strValue];
        }
    }@catch(NSException *e){}

    return strResult;
}
/** 插入数据的参数 */
- (NSString*) getParams_insert:(NSDictionary*)v_dicParams
{
    NSString *strResult = @"(";
    if(v_dicParams == NULL) return strResult;
    
    @try{
        // ---- 列名 ----
        BOOL        bFirst = true;
        for(NSString *strKey in v_dicParams)
        {
            if(bFirst == NO){
                strResult = [NSString stringWithFormat:@"%@%@", strResult, @", "];
            }
            bFirst = NO;
            strResult = [NSString stringWithFormat:@"%@'%@'", strResult, strKey];
        }
        strResult = [NSString stringWithFormat:@"%@%@", strResult, @") VALUES ("];
        
        // ---- 插入值 ----
        NSString *strValue = @"";
        bFirst = YES;
        for(NSString *strKey in v_dicParams)
        {
            if(bFirst == NO){
                strResult = [NSString stringWithFormat:@"%@%@", strResult, @", "];
            }
//            strValue = [v_dicParams objectForKey:strKey];
            id value = [v_dicParams objectForKey:strKey];
            if([value isKindOfClass:[NSNumber class]] == YES){ // 数字转化成字符串
                strValue = [NSString stringWithFormat:@"%li", [(NSNumber*)value longValue]];
                
            } else {
                strValue = (NSString*)value;
            }
            
            bFirst = NO;
            strResult = [NSString stringWithFormat:@"%@'%@'", strResult, strValue];
        }
        strResult = [NSString stringWithFormat:@"%@%@", strResult, @")"];
    }@catch(NSException *e){}
    
    return strResult;
}

// ==============================================================================================
#pragma mark 外部调用方法
/** 关闭数据库 */
- (void) closeSQL
{
    if(m_sqlite == nil) { return; }
    
    sqlite3_close(m_sqlite);
    m_sqlite = nil;
}
/** 插入数据库数据，如果存在则覆盖 */
- (BOOL) updateTable:(NSString*)v_strTableName _data:(NSDictionary*)v_dicData _uniqueKey:(NSString*)v_strUniqueKey
{
    [self initSQLite];
    NSString *strParamsCreate = [self getParams_createSQLTable:v_dicData];
    if([strParamsCreate isEqualToString:@""] == YES){
        return NO;
    }
    NSString *strCreateTable = [NSString stringWithFormat:@"Create Table If Not Exists %@ (%@)", v_strTableName, strParamsCreate];
    [self execSql:strCreateTable];
    
    NSString *strUniqueValue = [v_dicData objectForKey:v_strUniqueKey];
    BOOL bIsExitData = [self isHaveThisDataAtTable:v_strTableName _key:v_strUniqueKey _value:strUniqueValue];
    if(bIsExitData == YES){ // 已经存在这条数据，则覆盖
        NSString *strParams = [self getParams:v_dicData];
        NSString *strSQL_update = [NSString stringWithFormat:@"Update %@ Set %@ Where %@='%@'", v_strTableName, strParams, v_strUniqueKey, strUniqueValue];
        [self execSql:strSQL_update];
  
    } else {
        NSString *strParams = [self getParams_insert:v_dicData];
        NSString *strSQL_insert = [NSString stringWithFormat:@"Insert Into '%@' %@", v_strTableName, strParams];
        [self execSql:strSQL_insert];
    }
    return YES;
}
/** 获取数据表的所有数据 */
- (NSArray*) getTableAllData:(NSString*)v_strTableName
{
    [self initSQLite];
    NSMutableArray  *muAryRS = [NSMutableArray new];
    NSString        *strSQL_search = [NSString stringWithFormat:@"Select * From '%@'", v_strTableName];
    sqlite3_stmt    *stateMent;
    if(sqlite3_prepare(m_sqlite, [strSQL_search UTF8String], -1, &stateMent, nil) == SQLITE_OK){
        while(sqlite3_step(stateMent) == SQLITE_ROW){
            int colCount = sqlite3_column_count(stateMent);
            NSMutableDictionary *muDicRow = [NSMutableDictionary new];
            for(int i=0; i<colCount; i+=1)
            {
                NSString *strKey = [NSString stringWithUTF8String:(char*)sqlite3_column_name(stateMent, i)];
                NSString *strValue = [NSString stringWithUTF8String:(char*)sqlite3_column_text(stateMent, i)];
                [muDicRow setObject:strValue forKey:strKey];
            }
            [muAryRS addObject:muDicRow];
        }
    }
    sqlite3_finalize(stateMent);
    return muAryRS;
}
/** 根据条件搜索符合的数据 */
- (NSArray*) getTableRowData:(NSString*)v_strTableName _condition:(NSDictionary*)v_dicCondition
{
    [self initSQLite];
    NSMutableArray  *muAryRS = [NSMutableArray new];
    NSString        *strParams_find = [self getParams:v_dicCondition];
    NSString        *strSQL_search = [NSString stringWithFormat:@"Select * from '%@' Where %@", v_strTableName, strParams_find];
    sqlite3_stmt    *stateMent;
    if(sqlite3_prepare(m_sqlite, [strSQL_search UTF8String], -1, &stateMent, nil) == SQLITE_OK)
    {
        while(sqlite3_step(stateMent) == SQLITE_ROW){
            int colCount = sqlite3_column_count(stateMent);
            NSMutableDictionary *muDicItem = [NSMutableDictionary new];
            for(int i=0; i<colCount; i+=1)
            {
                NSString *strKey = [NSString stringWithUTF8String:sqlite3_column_name(stateMent, i)];
                NSString *strValue = [NSString stringWithUTF8String:(char*)sqlite3_column_text(stateMent, i)];
                [muDicItem setObject:strValue forKey:strKey];
            }
            [muAryRS addObject:muDicItem];
        }
    }
    sqlite3_finalize(stateMent);
    return muAryRS;
}
/** 删除数据库表 */
- (BOOL) deleteTable:(NSString*)v_strTableName
{
    [self initSQLite];
    NSString *strSQL_deleteTable = [NSString stringWithFormat:@"Drop Table '%@'", v_strTableName];
    return [self execSql:strSQL_deleteTable];
}
/** 删除数据的某一行数据 */
- (BOOL) deleteData:(NSString*)v_strTableName _key:(NSString*)v_strKey _value:(NSString*)v_strValue
{
    [self initSQLite];
    NSString *strSQL_delete = [NSString stringWithFormat:@"Delete From %@ Where %@='%@'", v_strTableName, v_strKey, v_strValue];
    return [self execSql:strSQL_delete];
}

@end
