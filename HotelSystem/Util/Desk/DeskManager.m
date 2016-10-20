//
//  DeskManager.m
//  HotelSystem
//
//  Created by hancj on 15/11/17.
//  Copyright © 2015年 hancj. All rights reserved.
//

#import "DeskManager.h"
#import "SQLManager.h"
#import "DeskItem.h"

#define SQLiteFileName_Desk     @"DeskManager"
#define DeskListTableName       @"DeskManagerTableName"

//#define DeskManager_ColName_DeskMenu        @"DeskManager_ColName_DeskMenu" /* 桌子对应的菜单数据库表名 */

@implementation DeskManager
{
    SQLManager  *m_SQLManager;
}
// ==============================================================================================
#pragma mark 基类方法
- (instancetype)init
{
    m_SQLManager = [SQLManager new];
    [m_SQLManager setSQLiteFileName:SQLiteFileName_Desk];
    return [super init];
}
- (void) dealloc
{
    [m_SQLManager closeSQL];
    m_SQLManager = nil;
}
// ==============================================================================================
#pragma mark 内部使用方法
/** 用桌子号生成对应的桌子ID */
- (NSString*) getDeskIDWithDeskNum:(int)v_deskNum
{
    return [NSString stringWithFormat:@"deskid_%i", v_deskNum];
}

// ==============================================================================================
#pragma mark 外部调用方法
/** 初始化对象 */
+ (DeskItem*) InitDeskItemWithData:(NSDictionary*)v_dic
{
    DeskItem *deskItemRS = [DeskItem new];
    [deskItemRS setDeskID:[v_dic objectForKey:DeskManager_ColName_DeskID]];
    [deskItemRS setDeskNum:[[v_dic objectForKey:DeskManager_ColName_DeskNumber] intValue]];
    return deskItemRS;
}
/** 初始化对象 */
+ (NSDictionary*) InitDataWithDeskItem:(DeskItem*)v_deskItem
{
    NSMutableDictionary *muDicRS = [NSMutableDictionary new];
    [muDicRS setObject:[NSString stringWithFormat:@"%i", [v_deskItem getDeskNum]] forKey:DeskManager_ColName_DeskNumber];
    [muDicRS setObject:[v_deskItem getDeskID] forKey:DeskManager_ColName_DeskID];
    return muDicRS;
}
/** 全局对象 - 用餐桌子数据管理对象 */
+ (DeskManager*) SharedDeskManagerObj
{
    static DeskManager *deskManagerObj = nil;
    if(deskManagerObj == nil){
        deskManagerObj = [DeskManager new];
    }
    return deskManagerObj;
}
/** 获取所有已订餐的桌子 */
- (NSArray<NSDictionary*>*) getDeskList
{
    return [m_SQLManager getTableAllData:DeskListTableName];
}
/** 获取所有已订餐的桌子 */
- (NSArray<DeskItem*>*) getDeskItemList
{
    NSArray<NSDictionary*> *aryObj = [m_SQLManager getTableAllData:DeskListTableName];
    NSMutableArray *muAryRS = [NSMutableArray new];
    for(NSDictionary *dicData in aryObj){
        DeskItem *deskItem = [DeskManager InitDeskItemWithData:dicData];
        [muAryRS addObject:deskItem];
    }
    // ---- 按照桌子号顺序从小到大排序 ----
    [muAryRS sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        DeskItem *deskItem1 = obj1;
        DeskItem *deskItem2 = obj2;
        if([deskItem1 getDeskNum] > [deskItem2 getDeskNum]){
            return  YES;
        } else {
            return NO;
        }
    }];
    
    return muAryRS;
}
/** 删除指定ID的桌子 */
- (BOOL) deleteDesk:(NSString*)v_strDeskID
{
    [m_SQLManager deleteTable:v_strDeskID];
    
    return [m_SQLManager deleteData:DeskListTableName _key:DeskManager_ColName_DeskID _value:v_strDeskID];
}
/** 删除指定ID的桌子 */
- (BOOL) deleteDeskWithDeskNum:(int)v_deskNum
{
    NSString *strDeskID = [self getDeskIDWithDeskNum:v_deskNum];
    
    return [self deleteDesk:strDeskID];
}
/** 是否已经存在这个桌子 */
- (BOOL) isHaveTheDeskOfDeskNum:(int)v_deskNum
{
    NSString *strDeskID = [self getDeskIDWithDeskNum:v_deskNum];
    NSDictionary *dicCondition = @{DeskManager_ColName_DeskID : strDeskID};
    NSArray *ary = [m_SQLManager getTableRowData:DeskListTableName _condition:dicCondition];
    
    BOOL bRS = YES;
    if(ary.count > 0){
        bRS = YES;
    } else {
        bRS = NO;
    }
    return bRS;
}
/** 添加订餐桌子，入参：桌子号 */
- (BOOL) addDeskWithDeskNum:(int)v_deskNum
{
    NSMutableDictionary *muDic = [NSMutableDictionary new];
    [muDic setObject:[NSString stringWithFormat:@"%i", v_deskNum] forKey:DeskManager_ColName_DeskNumber];
    [muDic setObject:[self getDeskIDWithDeskNum:v_deskNum] forKey:DeskManager_ColName_DeskID];
    return [self addDesk:muDic];
}
/** 添加订餐桌子 */
- (BOOL) addDeskWithDeskItem:(DeskItem*)v_deskItem
{
    NSDictionary *dic = [DeskManager InitDataWithDeskItem:v_deskItem];
    return [self addDesk:dic];
}
/** 添加订餐桌子 */
- (BOOL) addDesk:(NSDictionary*)v_dicData
{
    return [m_SQLManager updateTable:DeskListTableName _data:v_dicData _uniqueKey:DeskManager_ColName_DeskID];
}

///** 添加指定食物到某个桌子 */
//- (BOOL) addFoodToDesk:(NSString*)v_strDeskID _foodData:(NSDictionary*)v_dicFoodData
//{
//    return [m_SQLManager updateTable:strMenuName _data:v_dicFoodData _uniqueKey:DeskManager_ColName_FoodID];
//}
///** 删除某道菜 */
//- (BOOL) deleteFoodFromDesk:(NSString*)v_strDeskID _foodID:(NSString*)v_strFoodID
//{
//    NSString *strMenuName = [self getMenuNameWithDeskID:v_strDeskID];
//    return [m_SQLManager deleteData:strMenuName _key:DeskManager_ColName_FoodID _value:v_strFoodID];
//}
///** 编辑某道菜 */
//- (BOOL) editFoodFromDesk:(NSString*)v_strDeskID _foodData:(NSDictionary*)v_dicFoodData
//{
//    return [self addFoodToDesk:v_strDeskID _foodData:v_dicFoodData];
//}
///** 获取指定桌子的订餐菜列表 */
//- (NSArray*) getFoodMenuOfDesk:(NSString*)v_strDeskID
//{
//    NSString *strMenuName = [self getMenuNameWithDeskID:v_strDeskID];
//    return [m_SQLManager getTableAllData:strMenuName];
//}
///** 获取指定桌子的某道菜信息 */
//- (NSDictionary*) getFoodOfDesk:(NSString*)v_strDeskID _foodID:(NSString*)v_strFoodID
//{
//    NSString *strMenuName = [self getMenuNameWithDeskID:v_strDeskID];
//    NSDictionary *dicCondition = @{DeskManager_ColName_FoodID : v_strFoodID};
//    NSArray *aryFood = [m_SQLManager getTableRowData:strMenuName _condition:dicCondition];
//    NSDictionary *dicRS = nil;
//    if(aryFood.count > 0){
//        dicRS = [aryFood objectAtIndex:0];
//    }
//    return dicRS;
//}
///** 编辑已经点的菜的数量 */
//- (BOOL) editFoodNum:(NSString*)v_strDeskID _foodID:(NSString*)v_strFoodID _foodNum:(int)v_num
//{
//    NSDictionary *dicFood = [self getFoodOfDesk:v_strDeskID _foodID:v_strFoodID];
//    NSMutableDictionary *dicUpdate = [[NSMutableDictionary alloc] initWithDictionary:dicFood];
//    [dicUpdate setObject:[NSString stringWithFormat:@"%i", v_num] forKey:DeskManager_ColName_FoodNumber];
//    return [self editFoodFromDesk:v_strDeskID _foodData:dicUpdate];
//}

@end
