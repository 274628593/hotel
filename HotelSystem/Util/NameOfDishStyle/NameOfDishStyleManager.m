//
//  NameOfDishStyleManager.m
//  HotelSystem
//
//  Created by LHJ on 16/3/20.
//  Copyright © 2016年 hancj. All rights reserved.
//

#import "NameOfDishStyleManager.h"
#import "DishStyleNameItem.h"
#import "SQLManager.h"
#import "CPublic.h"

#define SQLiteFileName_DishStyle        @"NameOfDishStyleManager"
#define NameOfDishStyleTableName        @"NameOfDishStyleTableName"

@implementation NameOfDishStyleManager
{
    SQLManager  *m_SQLManager;
}
// ==============================================================================================
#pragma mark 基类方法
- (instancetype)init
{
    m_SQLManager = [SQLManager new];
    [m_SQLManager setSQLiteFileName:SQLiteFileName_DishStyle];
    return [super init];
}
- (void) dealloc
{
    [m_SQLManager closeSQL];
    m_SQLManager = nil;
}
// ==============================================================================================
#pragma mark 内部使用方法
/** 用菜系名称生成对应的ID */
- (NSString*) getDishStyleNameItemID
{
//    return [NSString stringWithFormat:@"dishStyleNameID_%@", v_strName];
    return [NSString stringWithFormat:@"dishStyleNameID_%@", [CPublic getUniqueName]];
}

// ==============================================================================================
#pragma mark 外部调用方法
/** 初始化对象 */
+ (NSDictionary*) InitDataWithDishStyleNameItem:(DishStyleNameItem*)v_dishStyleNameItem
{
    NSMutableDictionary *muDicRS = [NSMutableDictionary new];
    [muDicRS setObject:[v_dishStyleNameItem getDishStyleNameItemID] forKey:NameOfDishStyleManager_ColName_DishStyleID];
    [muDicRS setObject:[v_dishStyleNameItem getDishStyleNameItemName] forKey:NameOfDishStyleManager_ColName_DishStyleName];
    return muDicRS;
}

/** 初始化对象 */
+ (DishStyleNameItem*) InitDishStyleNameItemWithData:(NSDictionary*)v_dic
{

    DishStyleNameItem *dishStyleItemRS = [DishStyleNameItem new];
    [dishStyleItemRS setDishStyleNameItemID:[v_dic objectForKey:NameOfDishStyleManager_ColName_DishStyleID]];
    [dishStyleItemRS setDishStyleNameItemName:[v_dic objectForKey:NameOfDishStyleManager_ColName_DishStyleName]];
    return dishStyleItemRS;}

/** 全局对象 - 菜系管理器对象 */
+ (NameOfDishStyleManager*) SharedNameOfDishStyleManagerObj
{
    static NameOfDishStyleManager *dishStyleManagerObj = nil;
    if(dishStyleManagerObj == nil){
        dishStyleManagerObj = [NameOfDishStyleManager new];
    }
    return dishStyleManagerObj;
}

/** 获取所有菜系 */
- (NSArray<NSDictionary*>*) getNameOfDishStyleList;
{
    return [m_SQLManager getTableAllData:NameOfDishStyleTableName];
}

/** 获取所有菜系 */
- (NSArray<DishStyleNameItem*>*) getNameOfDishStyleItemList
{
    NSArray<NSDictionary*> *aryListData = [self getNameOfDishStyleList];
    NSMutableArray<DishStyleNameItem*> *muAryRS = [NSMutableArray<DishStyleNameItem*> new];
    for(NSDictionary *dicData in aryListData){
        [muAryRS addObject:[NameOfDishStyleManager InitDishStyleNameItemWithData:dicData]];
    }
    return muAryRS;
}
/** 判断是否已经有了这个菜系名 */
- (BOOL) isHaveThisNameOfDishStyle:(NSString*)v_strName
{
//    NSString *strDishID = [self getDishStyleNameItemID];
    NSDictionary *dicCondition = @{NameOfDishStyleManager_ColName_DishStyleName : v_strName};
    NSArray *ary = [m_SQLManager getTableRowData:NameOfDishStyleTableName _condition:dicCondition];
    
    BOOL bRS = YES;
    if(ary.count > 0){
        bRS = YES;
    } else {
        bRS = NO;
    }
    return bRS;
}
/** 添加菜系 */
- (BOOL) addDishStyleName_id:(NSString*)v_strNameOfDishStyleItemID
                       _name:(NSString*)v_strNameOfDishStyleItemName
{
    NSDictionary *dicData = @{NameOfDishStyleManager_ColName_DishStyleID : v_strNameOfDishStyleItemID,
                              NameOfDishStyleManager_ColName_DishStyleName : v_strNameOfDishStyleItemName};
    return [self addDishStyleName:dicData];
}

/** 添加菜系 */
- (BOOL) addDishStyleName:(NSDictionary*)v_dicNameOfDishStyleItem
{
    return [m_SQLManager updateTable:NameOfDishStyleTableName
                               _data:v_dicNameOfDishStyleItem
                          _uniqueKey:NameOfDishStyleManager_ColName_DishStyleID];
}
/** 添加菜系 */
- (BOOL) addDishStyleName_name:(NSString*)v_strNameOfDishStyleItemName
{
    NSString *strID = [self getDishStyleNameItemID];
    return [self addDishStyleName_id:strID _name:v_strNameOfDishStyleItemName];
}

/** 添加菜系 */
- (BOOL) addDishStyleNameWithItem:(DishStyleNameItem*)v_deskItem
{
    NSDictionary *dicData = [NameOfDishStyleManager InitDataWithDishStyleNameItem:v_deskItem];
    return [self addDishStyleName:dicData];
}

/** 删除菜系 */
- (BOOL) deleteDishStyleName:(NSString*)v_strNameOfDishStyleItemID
{
    return [m_SQLManager deleteData:NameOfDishStyleTableName
                               _key:NameOfDishStyleManager_ColName_DishStyleID
                             _value:v_strNameOfDishStyleItemID];
}

@end
