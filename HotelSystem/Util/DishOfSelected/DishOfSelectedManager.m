//
//  DishOfSelectedManager.m
//  HotelSystem
//
//  Created by LHJ on 16/3/26.
//  Copyright © 2016年 hancj. All rights reserved.
//

#import "DishOfSelectedManager.h"
#import "DishItemOfSelected.h"
#import "SQLManager.h"
#import "CPublic.h"

#define SQLiteFileName_DishOfSelected     @"DishOfSelectedManager"

@implementation DishOfSelectedManager
{
    SQLManager  *m_SQLManager;
}
// ==============================================================================================
#pragma mark - 基类方法
- (instancetype)init
{
    m_SQLManager = [SQLManager new];
    [m_SQLManager setSQLiteFileName:SQLiteFileName_DishOfSelected];
    return [super init];
}
- (void) dealloc
{
    [m_SQLManager closeSQL];
    m_SQLManager = nil;
}
// ==============================================================================================
#pragma mark - 外部调用方法
/** 初始化对象 */
+ (NSDictionary*) InitDataWithDishItemOfSelected:(DishItemOfSelected*)v_dishItemOfSelected
{
    NSMutableDictionary *muDicRS = [NSMutableDictionary new];
    [muDicRS setObject:[v_dishItemOfSelected getDishID] forKey:DishOfSelectedManager_ColName_DishID];
    [muDicRS setObject:[v_dishItemOfSelected getDishName] forKey:DishOfSelectedManager_ColName_DishName];
    [muDicRS setObject:[v_dishItemOfSelected getDishIconImgPath] forKey:DishOfSelectedManager_ColName_DishImgPath];
    [muDicRS setObject:[v_dishItemOfSelected getDishDescrition] forKey:DishOfSelectedManager_ColName_DishDescrition];
    [muDicRS setObject:[v_dishItemOfSelected getDishStyleID] forKey:DishOfSelectedManager_ColName_DishStyleID];
    [muDicRS setObject:[v_dishItemOfSelected getDishStyleName] forKey:DishOfSelectedManager_ColName_DishStyleName];
    [muDicRS setObject:[NSString stringWithFormat:@"%.02f", [v_dishItemOfSelected getDishPrice]] forKey:DishOfSelectedManager_ColName_DishPrice];
    [muDicRS setObject:[NSString stringWithFormat:@"%i", [v_dishItemOfSelected getIsDishRecommend]] forKey:DishOfSelectedManager_ColName_DishIsRecommend];
    [muDicRS setObject:[NSString stringWithFormat:@"%i", [v_dishItemOfSelected getDishSelectNum]] forKey:DishOfSelectedManager_ColName_NumOfSelected];
    [muDicRS setObject:[NSString stringWithFormat:@"%.02f", [v_dishItemOfSelected getDishPriceDiscount]] forKey:DishOfSelectedManager_ColName_DishPriceDiscount];
    
    return muDicRS;
}

/** 初始化对象 */
+ (DishItemOfSelected*) InitDishItemOfSelectedWithData:(NSDictionary*)v_dic
{
    DishItemOfSelected *itemRS = [DishItemOfSelected new];
    [itemRS setDishID:[v_dic objectForKey:DishOfSelectedManager_ColName_DishID]];
    [itemRS setDishName:[v_dic objectForKey:DishOfSelectedManager_ColName_DishName]];
    [itemRS setDishIconImgPath:[v_dic objectForKey:DishOfSelectedManager_ColName_DishImgPath]];
    [itemRS setDishDescrition:[v_dic objectForKey:DishOfSelectedManager_ColName_DishDescrition]];
    [itemRS setDishStyleID:[v_dic objectForKey:DishOfSelectedManager_ColName_DishStyleID]];
    [itemRS setDishStyleName:[v_dic objectForKey:DishOfSelectedManager_ColName_DishStyleName]];
    
    NSString *strObj = [v_dic objectForKey:DishOfSelectedManager_ColName_DishPrice];
    if(strObj != nil){
        [itemRS setDishPrice:[strObj floatValue]];
    }
    strObj = [v_dic objectForKey:DishOfSelectedManager_ColName_DishPriceDiscount];
    if(strObj != nil){
        [itemRS setDishPriceDiscount:[strObj floatValue]];
    }
    
    strObj = [v_dic objectForKey:DishOfSelectedManager_ColName_DishIsRecommend];
    if(strObj != nil){
        [itemRS setIsDishRecommend:[strObj boolValue]];
    }
    strObj = [v_dic objectForKey:DishOfSelectedManager_ColName_NumOfSelected];
    if(strObj != nil){
        [itemRS setDishSelectNum:[strObj intValue]];
    }
    return itemRS;
}

/** 全局对象 - 菜系管理器对象 */
+ (DishOfSelectedManager*) SharedDishOfSelectedManagerObj
{
    static DishOfSelectedManager *managerObj = nil;
    if(managerObj == nil){
        managerObj = [DishOfSelectedManager new];
    }
    return managerObj;
}

/** 获取所有已选菜 */
- (NSArray<NSDictionary*>*) getAllDishListOfSelectedWithDeskId:(NSString*)v_strDeskID
{
    return [m_SQLManager getTableAllData:v_strDeskID];
}

/** 获取所有已选菜 */
- (NSArray<DishItemOfSelected*>*) getAllDishItemListOfSelectedWithDeskId:(NSString*)v_strDeskID
{
    NSArray<NSDictionary*> *aryList = [self getAllDishListOfSelectedWithDeskId:v_strDeskID];
    NSMutableArray<DishItemOfSelected*> *muAryRS = [NSMutableArray<DishItemOfSelected*> new];
    for(NSDictionary *dic in aryList){
        [muAryRS addObject:[DishOfSelectedManager InitDishItemOfSelectedWithData:dic]];
    }
    return muAryRS;
}

/** 判断某道菜是否已经选择 */
- (BOOL) isSelectedOfDishItem:(DishItem*)v_dishItem _deskID:(NSString*)v_strDeskID
{
    NSDictionary *dicCondition = @{DishOfSelectedManager_ColName_DishID : [v_dishItem getDishID]};
    NSArray *ary = [m_SQLManager getTableRowData:v_strDeskID _condition:dicCondition];
    
    BOOL bRS = YES;
    if(ary.count > 0){
        bRS = YES;
    } else {
        bRS = NO;
    }
    return bRS;
}

/** 添加已选菜 */
- (BOOL) addDishOfSelectedWithDishItemOfSelected:(DishItemOfSelected*)v_dishItemOfSelected
                                         _deskID:(NSString*)v_strDeskID
{
    NSDictionary *dicData = [DishOfSelectedManager InitDataWithDishItemOfSelected:v_dishItemOfSelected];
    return [self addDishOfSelectedWithData:dicData _deskID:v_strDeskID];
}

/** 添加已选菜 */
- (BOOL) addDishOfSelectedWithData:(NSDictionary*)v_dicDish
                           _deskID:(NSString*)v_strDeskID
{
    return [m_SQLManager updateTable:v_strDeskID
                               _data:v_dicDish
                          _uniqueKey:DishOfSelectedManager_ColName_DishID];
}

/** 添加已选菜 */
- (BOOL) addDishOfSelectedWithDishItem:(DishItem*)v_dishItem
                               _deskID:(NSString*)v_strDeskID
{
    DishItemOfSelected *itemObj = [DishItemOfSelected dishItemOfSelectedWithDishItem:v_dishItem];
    return [self addDishOfSelectedWithDishItemOfSelected:itemObj _deskID:v_strDeskID];
}

/** 修改已经选择的菜数量 */
- (BOOL) updateNumOfSelectedForDishItemSelected:(DishItemOfSelected*)v_dishItemOfSelected
                                        _newNum:(int)v_num
                                        _deskID:(NSString*)v_strDeskID
{
    NSString *strDishID = [v_dishItemOfSelected getDishID];
    return [self updateNumOfSelectedForDishID:strDishID
                                      _newNum:v_num
                                      _deskID:v_strDeskID];
}

/** 更新已选菜 */
- (BOOL) updateDishOfSelectedWithDishItem:(DishItemOfSelected*)v_dishItem
                                  _deskID:(NSString*)v_strDeskID
{
    return [self addDishOfSelectedWithDishItemOfSelected:v_dishItem _deskID:v_strDeskID];
}
/** 修改已经选择的菜数量，如果为0，则从管理器中删除该已选菜 */
- (BOOL) updateNumOfSelectedForDishID:(NSString*)v_strDishId
                              _newNum:(int)v_num
                              _deskID:(NSString*)v_strDeskID
{
    NSDictionary *dicCondition = @{DishOfSelectedManager_ColName_DishID : v_strDishId};
    NSArray *ary = [m_SQLManager getTableRowData:v_strDeskID _condition:dicCondition];
    
    BOOL bRS = YES;
    if(ary.count > 0)
    {
        if(v_num <= 0){
            bRS = [self deleteDishOfSelectedForDishID:v_strDishId _deskID:v_strDeskID];
        
        } else {
            NSDictionary *dicData = [ary objectAtIndex:0];
            DishItemOfSelected *itemObj = [DishOfSelectedManager InitDishItemOfSelectedWithData:dicData];
            [itemObj setDishSelectNum:v_num];
            bRS = [self addDishOfSelectedWithDishItemOfSelected:itemObj _deskID:v_strDeskID];
        }
        
    } else {
        bRS = NO;
    }
    return bRS;
}
/** 删除已选菜 */
- (BOOL) deleteDishOfSelected:(DishItemOfSelected*)v_dishItemOfSelected _deskID:(NSString*)v_strDeskID
{
    NSString *strDishID = [v_dishItemOfSelected getDishID];
    return [self deleteDishOfSelectedForDishID:strDishID
                                       _deskID:v_strDeskID];
}

/** 删除已选菜 */
- (BOOL) deleteDishOfSelectedForDishID:(NSString*)v_strDishId _deskID:(NSString*)v_strDeskID
{
    return [m_SQLManager deleteData:v_strDeskID
                               _key:DishOfSelectedManager_ColName_DishID
                             _value:v_strDishId];
}
/** 删除该已选菜 */
- (BOOL) deleteDishOfSelectedForDishItem:(DishItem*)v_dishItem _deskID:(NSString*)v_strDeskID
{
    NSString *strDishID = [v_dishItem getDishID];
    return [self deleteDishOfSelectedForDishID:strDishID _deskID:v_strDeskID];
}

@end
