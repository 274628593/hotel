//
//  DishMananger.m
//  HotelSystem
//
//  Created by LHJ on 16/3/24.
//  Copyright © 2016年 hancj. All rights reserved.
//

#import "DishManager.h"
#import "CPublic.h"
#import "SQLManager.h"
#import "DishItem.h"

#define SQLiteFileName_Dish     @"DishManager"
#define DishTableName           @"DishTableName"

@implementation DishManager
{
    SQLManager  *m_SQLManager;
}
// ==============================================================================================
#pragma mark - 基类方法
- (instancetype)init
{
    m_SQLManager = [SQLManager new];
    [m_SQLManager setSQLiteFileName:SQLiteFileName_Dish];
    return [super init];
}
- (void) dealloc
{
    [m_SQLManager closeSQL];
    m_SQLManager = nil;
}
// ==============================================================================================
#pragma mark - 内部使用方法
/** 根据时间戳生成对应的ID */
- (NSString*) getDishID
{
    return [NSString stringWithFormat:@"dishID_%@", [CPublic getUniqueName]];
}
// ==============================================================================================
#pragma mark - 外部调用方法
/** 初始化对象 */
+ (NSDictionary*) InitDataWithDishItem:(DishItem*)v_dishItem
{
    NSMutableDictionary *muDicRS = [NSMutableDictionary new];
    [muDicRS setObject:[v_dishItem getDishID] forKey:DishManager_ColName_DishID];
    [muDicRS setObject:[v_dishItem getDishName] forKey:DishManager_ColName_DishName];
    [muDicRS setObject:[v_dishItem getDishIconImgPath] forKey:DishManager_ColName_DishImgPath];
    [muDicRS setObject:[v_dishItem getDishDescrition] forKey:DishManager_ColName_DishDescrition];
    [muDicRS setObject:[v_dishItem getDishStyleID] forKey:DishManager_ColName_DishStyleID];
    [muDicRS setObject:[v_dishItem getDishStyleName] forKey:DishManager_ColName_DishStyleName];
    [muDicRS setObject:[NSString stringWithFormat:@"%.02f", [v_dishItem getDishPrice]] forKey:DishManager_ColName_DishPrice];
    [muDicRS setObject:[NSString stringWithFormat:@"%i", [v_dishItem getIsDishRecommend]]  forKey:DishManager_ColName_DishIsRecommend];
    return muDicRS;
}

/** 初始化对象 */
+ (DishItem*) InitDishItemWithData:(NSDictionary*)v_dic
{
    DishItem *dishItemRS = [DishItem new];
    [dishItemRS setDishID:[v_dic objectForKey:DishManager_ColName_DishID]];
    [dishItemRS setDishName:[v_dic objectForKey:DishManager_ColName_DishName]];
    [dishItemRS setDishIconImgPath:[v_dic objectForKey:DishManager_ColName_DishImgPath]];
    [dishItemRS setDishDescrition:[v_dic objectForKey:DishManager_ColName_DishDescrition]];
    [dishItemRS setDishStyleID:[v_dic objectForKey:DishManager_ColName_DishStyleID]];
    [dishItemRS setDishStyleName:[v_dic objectForKey:DishManager_ColName_DishStyleName]];
    [dishItemRS setDishPrice:[[v_dic objectForKey:DishManager_ColName_DishPrice] floatValue]];
    [dishItemRS setIsDishRecommend:[[v_dic objectForKey:DishManager_ColName_DishIsRecommend] boolValue]];
    return dishItemRS;
}

/** 全局对象 - 菜系管理器对象 */
+ (DishManager*) SharedDishManagerObj
{
    static DishManager *disManagerObj = nil;
    if(disManagerObj == nil){
        disManagerObj = [DishManager new];
    }
    return disManagerObj;
}

/** 获取所有菜 */
- (NSArray<NSDictionary*>*) getAllDishList
{
    return [m_SQLManager getTableAllData:DishTableName];
}

/** 获取所有菜 */
- (NSArray<DishItem*>*) getAllDishItemList
{
    NSArray<NSDictionary*> *aryListData = [self getAllDishList];
    NSMutableArray<DishItem*> *muAryRS = [NSMutableArray<DishItem*> new];
    for(NSDictionary *dicData in aryListData){
        [muAryRS addObject:[DishManager InitDishItemWithData:dicData]];
    }
    return muAryRS;
}

/** 获取所有标记推荐的菜 */
- (NSArray<DishItem*>*) getAllDishItemListForRecommend
{
    NSArray<NSDictionary*> *aryListData = [self getAllDishList];
    NSMutableArray<DishItem*> *muAryRS = [NSMutableArray<DishItem*> new];
    for(NSDictionary *dicData in aryListData){
        DishItem *dishItem = [DishManager InitDishItemWithData:dicData];
        if([dishItem getIsDishRecommend] == YES){
            [muAryRS addObject:dishItem];
        }
    }
    return muAryRS;
}

/** 获取指定菜系的菜 */
- (NSArray<DishItem*>*) getDishItemListForDishStyleID:(NSString*)v_strDishStyleID
{
    NSArray<NSDictionary*> *aryListData = [self getAllDishList];
    NSMutableArray<DishItem*> *muAryRS = [NSMutableArray<DishItem*> new];
    for(NSDictionary *dicData in aryListData){
        DishItem *dishItem = [DishManager InitDishItemWithData:dicData];
        if([[dishItem getDishStyleID] isEqualToString:v_strDishStyleID] == YES){
            [muAryRS addObject:dishItem];
        }
    }
    return muAryRS;
}

/** 获取以模糊搜索的菜 */
- (NSArray<DishItem*>*) getDishItemListForSearchText:(NSString*)v_strSearchText
{
    v_strSearchText = [CPublic getIndexForName:v_strSearchText];
    
    NSMutableArray<DishItem*> *muAryRS = [NSMutableArray new];
    NSArray<DishItem*> *aryDishItem = [self getAllDishItemList];
    for(DishItem *dishItem in aryDishItem){
        NSString *strName = [dishItem getDishName];
        NSString *strPinYin = [CPublic getIndexForName:strName];
        int indexOfBeginSearch = 0;
        BOOL bIsFor = YES;
        for(int i=0; i<v_strSearchText.length && bIsFor; i+=1){
            NSRange range;
            range.length = 1;
            range.location = i;
            NSString *strTemp = [[v_strSearchText substringWithRange:range] lowercaseString];
            for(int ii=indexOfBeginSearch; ii<strPinYin.length; ii+=1){
                NSRange range_ii;
                range_ii.length = 1;
                range_ii.location = ii;
                NSString *strTemp_ii = [strPinYin substringWithRange:range_ii];
                if([strTemp_ii isEqualToString:strTemp] == YES){
                    bIsFor = YES;
                    indexOfBeginSearch = ii;
                    break;
                } else {
                    bIsFor = NO;
                }
            }
        }
        if(bIsFor == YES){
            [muAryRS addObject:dishItem];
        }
    }
    return muAryRS;
}

/** 添加菜 */
- (BOOL) addDishWithData:(NSDictionary*)v_dicDish
{
    return [m_SQLManager updateTable:DishTableName
                               _data:v_dicDish
                          _uniqueKey:DishManager_ColName_DishID];
}

/** 添加菜 */
- (BOOL) addDishWithDishItem:(DishItem*)v_dishItem
{
    NSDictionary *dicData = [DishManager InitDataWithDishItem:v_dishItem];
    return [self addDishWithData:dicData];
}
/** 添加菜 */
- (BOOL) addDishWithDishName:(NSString*)v_strDishName
                _dishImgPath:(NSString*)v_strDishImgPath
             _dishDescrition:(NSString*)v_strDishDescrition
                _dishStyleID:(NSString*)v_strDishStyleID
              _dishStyleName:(NSString*)v_strDishStyleName
                  _dishPrice:(float)v_dishPrice
                _isRecommend:(BOOL)v_bIsRecommend
{
    NSString *strDishID = [self getDishID];
    NSDictionary *dicData = @{ DishManager_ColName_DishID : strDishID,
                               DishManager_ColName_DishName : v_strDishName,
                               DishManager_ColName_DishImgPath : v_strDishImgPath,
                               DishManager_ColName_DishDescrition : v_strDishDescrition,
                               DishManager_ColName_DishStyleID : v_strDishStyleID,
                               DishManager_ColName_DishStyleName : v_strDishStyleName,
                               DishManager_ColName_DishPrice : [NSString stringWithFormat:@"%.02f", v_dishPrice],
                               DishManager_ColName_DishIsRecommend : [NSString stringWithFormat:@"%i", v_bIsRecommend]
                              };
    return [self addDishWithData:dicData];
}

/** 更新菜 */
- (BOOL) updateDishWithData:(NSDictionary*)v_dicDish
{
    return [m_SQLManager updateTable:DishTableName
                               _data:v_dicDish
                          _uniqueKey:DishManager_ColName_DishID];
}

/** 更新菜 */
- (BOOL) updateDishWithDishItem:(DishItem*)v_dishItem
{
    NSDictionary *dicData = [DishManager InitDataWithDishItem:v_dishItem];
    return [self addDishWithData:dicData];
}

/** 删除菜 */
- (BOOL) deleteDish:(NSString*)v_strDishID
{
    return [m_SQLManager deleteData:DishTableName
                               _key:DishManager_ColName_DishID
                             _value:v_strDishID];
}

@end
