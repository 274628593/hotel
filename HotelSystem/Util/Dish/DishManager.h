//
//  DishManager.h
//  HotelSystem
//
//  Created by LHJ on 16/3/24.
//  Copyright © 2016年 hancj. All rights reserved.
//

#import <Foundation/Foundation.h>
@class DishItem;

#define DishManager_ColName_DishID             @"DishManager_ColName_DishID" /* 菜ID，唯一识别字段 */
#define DishManager_ColName_DishName           @"DishManager_ColName_DishName" /* 菜名称 */
#define DishManager_ColName_DishImgPath        @"DishManager_ColName_DishImgPath" /* 菜图片路径 */
#define DishManager_ColName_DishDescrition     @"DishManager_ColName_DishDescrition" /* 菜简介 */
#define DishManager_ColName_DishStyleID        @"DishManager_ColName_DishStyleID" /* 菜系ID */
#define DishManager_ColName_DishStyleName      @"DishManager_ColName_DishStyleName" /* 菜系名 */
#define DishManager_ColName_DishPrice          @"DishManager_ColName_DishPrice" /* 菜价格 */
#define DishManager_ColName_DishIsRecommend    @"DishManager_ColName_DishIsRecommend" /* 是否是推荐菜 */

@interface DishManager : NSObject

// ==============================================================================================
#pragma mark - 外部调用方法
/** 初始化对象 */
+ (NSDictionary*) InitDataWithDishItem:(DishItem*)v_dishItem;

/** 初始化对象 */
+ (DishItem*) InitDishItemWithData:(NSDictionary*)v_dic;

/** 全局对象 - 菜系管理器对象 */
+ (DishManager*) SharedDishManagerObj;

/** 获取所有菜 */
- (NSArray<NSDictionary*>*) getAllDishList;

/** 获取所有菜 */
- (NSArray<DishItem*>*) getAllDishItemList;

/** 获取所有标记推荐的菜 */
- (NSArray<DishItem*>*) getAllDishItemListForRecommend;

/** 获取指定菜系的菜 */
- (NSArray<DishItem*>*) getDishItemListForDishStyleID:(NSString*)v_strDishStyleID;

/** 获取以模糊搜索的菜 */
- (NSArray<DishItem*>*) getDishItemListForSearchText:(NSString*)v_strSearchText;

/** 添加菜 */
- (BOOL) addDishWithData:(NSDictionary*)v_dicDish;

/** 添加菜 */
- (BOOL) addDishWithDishItem:(DishItem*)v_dishItem;

/** 添加菜 */
- (BOOL) addDishWithDishName:(NSString*)v_strDishName
                _dishImgPath:(NSString*)v_strDishImgPath
             _dishDescrition:(NSString*)v_strDishDescrition
                _dishStyleID:(NSString*)v_strDishStyleID
              _dishStyleName:(NSString*)v_strDishStyleName
                  _dishPrice:(float)v_dishPrice
                _isRecommend:(BOOL)v_bIsRecommend;

/** 更新菜 */
- (BOOL) updateDishWithData:(NSDictionary*)v_dicDish;

/** 更新菜 */
- (BOOL) updateDishWithDishItem:(DishItem*)v_dishItem;

/** 删除菜 */
- (BOOL) deleteDish:(NSString*)v_strDishID;

@end
