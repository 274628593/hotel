//
//  FoodManager.m
//  HotelSystem
//
//  Created by hancj on 15/11/18.
//  Copyright © 2015年 hancj. All rights reserved.
//

#import "DishStyleManager.h"
#import "SQLManager.h"
#import "DishStyleItem.h"
#import "CPublic.h"

#define SQLiteFileName_DishStyle    @"DishStyleManager"
#define DishStyleTableName          @"DishStyleTableName"

@implementation DishStyleManager
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
/** 根据时间戳生成对应的ID */
//- (NSString*) getDishStyleIDWithName
//{
//    return [NSString stringWithFormat:@"dishStyleID_%@", [CPublic getUniqueName]];
//}

// ==============================================================================================
#pragma mark 外部调用方法
/** 初始化对象 */
+ (NSDictionary*) InitDataWithDishStyleItem:(DishStyleItem*)v_dishStyleItem
{
    NSMutableDictionary *muDicRS = [NSMutableDictionary new];
    [muDicRS setObject:[v_dishStyleItem getDishStyleID] forKey:DishStyleManager_ColName_DishStyleID];
    [muDicRS setObject:[v_dishStyleItem getDishStyleName] forKey:DishStyleManager_ColName_DishStyleName];
    [muDicRS setObject:[v_dishStyleItem getDishStyleIconImgPath] forKey:DishStyleManager_ColName_DishStyleImgPath];
    return muDicRS;
}

/** 初始化对象 */
+ (DishStyleItem*) InitDishStyleItemWithData:(NSDictionary*)v_dic
{
    DishStyleItem *dishStyleItemRS = [DishStyleItem new];
    [dishStyleItemRS setDishStyleID:[v_dic objectForKey:DishStyleManager_ColName_DishStyleID]];
    [dishStyleItemRS setDishStyleName:[v_dic objectForKey:DishStyleManager_ColName_DishStyleName]];
    [dishStyleItemRS setDishStyleIconImgPath:[v_dic objectForKey:DishStyleManager_ColName_DishStyleImgPath]];
    return dishStyleItemRS;
}
/** 全局对象 - 菜系管理器对象 */
+ (DishStyleManager*) SharedDishStyleManagerObj
{
    static DishStyleManager *dishStyleManagerObj = nil;
    if(dishStyleManagerObj == nil){
        dishStyleManagerObj = [DishStyleManager new];
    }
    return dishStyleManagerObj;
}
/** 获取所有菜系 */
- (NSArray<NSDictionary*>*) getDishStyleList
{
    return [m_SQLManager getTableAllData:DishStyleTableName];
}
/** 获取所有菜系 */
- (NSArray<DishStyleItem*>*) getDishStyleItemList
{
    NSArray<NSDictionary*> *aryListData = [self getDishStyleList];
    NSMutableArray<DishStyleItem*> *muAryRS = [NSMutableArray<DishStyleItem*> new];
    for(NSDictionary *dicData in aryListData){
        [muAryRS addObject:[DishStyleManager InitDishStyleItemWithData:dicData]];
    }
    return muAryRS;
}
/** 添加菜系 */
- (BOOL) addDishStyleWithDishStyleNameID:(NSString*)v_strDishStyleNameItemID
                                   _name:(NSString*)v_strDishStyleName
                 _imgPathOfDishStyleIcon:(NSString*)v_strImgPath
{
//    NSString *strID = [self getDishStyleIDWithName];
    NSDictionary *dicData = @{DishStyleManager_ColName_DishStyleID : v_strDishStyleNameItemID,
                              DishStyleManager_ColName_DishStyleName : v_strDishStyleName,
                              DishStyleManager_ColName_DishStyleImgPath : v_strImgPath};
    return [self addDishStyle:dicData];
}
/** 添加菜系 */
- (BOOL) addDishStyle:(NSDictionary*)v_dicDishStyle
{
    return [m_SQLManager updateTable:DishStyleTableName
                               _data:v_dicDishStyle
                          _uniqueKey:DishStyleManager_ColName_DishStyleID];
}
/** 编辑菜系 */
- (BOOL) updateDishStyle:(NSDictionary*)v_dicDishStyle
{
    return [m_SQLManager updateTable:DishStyleTableName
                               _data:v_dicDishStyle
                          _uniqueKey:DishStyleManager_ColName_DishStyleID];
}
/** 编辑菜系 */
- (BOOL) updateDishStyle:(NSString*)v_strDishStyleID
                   _name:(NSString*)v_strDishStyleName
 _imgPathOfDishStyleIcon:(NSString*)v_strImgPath
{
    NSDictionary *dicData = @{DishStyleManager_ColName_DishStyleID : v_strDishStyleID,
                              DishStyleManager_ColName_DishStyleName : v_strDishStyleName,
                              DishStyleManager_ColName_DishStyleImgPath : v_strImgPath};
    return [self addDishStyle:dicData];
}
/** 编辑菜系 */
- (BOOL) updateDishStyleWithDishStyleItem:(DishStyleItem*)v_dishStyleItem
{
    NSDictionary *dicData = [DishStyleManager InitDataWithDishStyleItem:v_dishStyleItem];
    return [self updateDishStyle:dicData];
}

/** 删除菜系 */
- (BOOL) deleteDishStyle:(NSString*)v_strDishStyleID
{
    return [m_SQLManager deleteData:DishStyleTableName
                               _key:DishStyleManager_ColName_DishStyleID
                             _value:v_strDishStyleID];
}
@end
