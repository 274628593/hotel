//
//  DishOfSelectedManager.h
//  HotelSystem
//
//  Created by LHJ on 16/3/26.
//  Copyright © 2016年 hancj. All rights reserved.
//

#import <Foundation/Foundation.h>
@class DishItemOfSelected;
@class DishItem;

#define DishOfSelectedManager_ColName_DishID             @"DishManager_ColName_DishID" /* 菜ID，唯一识别字段 */
#define DishOfSelectedManager_ColName_DishName           @"DishManager_ColName_DishName" /* 菜名称 */
#define DishOfSelectedManager_ColName_DishImgPath        @"DishManager_ColName_DishImgPath" /* 菜图片路径 */
#define DishOfSelectedManager_ColName_DishDescrition     @"DishManager_ColName_DishDescrition" /* 菜简介 */
#define DishOfSelectedManager_ColName_DishStyleID        @"DishManager_ColName_DishStyleID" /* 菜系ID */
#define DishOfSelectedManager_ColName_DishStyleName      @"DishManager_ColName_DishStyleName" /* 菜系名 */
#define DishOfSelectedManager_ColName_DishPrice          @"DishManager_ColName_DishPrice" /* 菜价格 */
#define DishOfSelectedManager_ColName_DishIsRecommend    @"DishManager_ColName_DishIsRecommend" /* 是否是推荐菜 */
#define DishOfSelectedManager_ColName_NumOfSelected      @"DishOfSelectedManager_ColName_NumOfSelected" /* 选择的菜数量 */
#define DishOfSelectedManager_ColName_DishPriceDiscount  @"DishOfSelectedManager_ColName_DishPriceDiscount" /* 菜单价折扣 */

/** 已选菜的管理器 */
@interface DishOfSelectedManager : NSObject

// ==============================================================================================
#pragma mark - 外部调用方法
/** 初始化对象 */
+ (NSDictionary*) InitDataWithDishItemOfSelected:(DishItemOfSelected*)v_dishItemOfSelected;

/** 初始化对象 */
+ (DishItemOfSelected*) InitDishItemOfSelectedWithData:(NSDictionary*)v_dic;

/** 全局对象 - 菜系管理器对象 */
+ (DishOfSelectedManager*) SharedDishOfSelectedManagerObj;

/** 获取所有已选菜 */
- (NSArray<NSDictionary*>*) getAllDishListOfSelectedWithDeskId:(NSString*)v_strDeskID;

/** 获取所有已选菜 */
- (NSArray<DishItemOfSelected*>*) getAllDishItemListOfSelectedWithDeskId:(NSString*)v_strDeskID;

/** 添加已选菜 */
- (BOOL) addDishOfSelectedWithData:(NSDictionary*)v_dicDish _deskID:(NSString*)v_strDeskID;

/** 判断某道菜是否已经选择 */
- (BOOL) isSelectedOfDishItem:(DishItem*)v_dishItem _deskID:(NSString*)v_strDeskID;;

/** 添加已选菜 */
- (BOOL) addDishOfSelectedWithDishItem:(DishItem*)v_dishItem _deskID:(NSString*)v_strDeskID;

/** 添加已选菜 */
- (BOOL) addDishOfSelectedWithDishItemOfSelected:(DishItemOfSelected*)v_dishItemOfSelected
                                         _deskID:(NSString*)v_strDeskID;

/** 更新已选菜 */
- (BOOL) updateDishOfSelectedWithDishItem:(DishItemOfSelected*)v_dishItem
                                  _deskID:(NSString*)v_strDeskID;

/** 修改已经选择的菜数量 */
- (BOOL) updateNumOfSelectedForDishItemSelected:(DishItemOfSelected*)v_dishItemOfSelected
                                        _newNum:(int)v_num
                                        _deskID:(NSString*)v_strDeskID;

/** 修改已经选择的菜数量，如果为0，则从管理器中删除该已选菜 */
- (BOOL) updateNumOfSelectedForDishID:(NSString*)v_strDishId
                              _newNum:(int)v_num
                              _deskID:(NSString*)v_strDeskID;

/** 删除该已选菜 */
- (BOOL) deleteDishOfSelected:(DishItemOfSelected*)v_dishItemOfSelected _deskID:(NSString*)v_strDeskID;

/** 删除该已选菜 */
- (BOOL) deleteDishOfSelectedForDishID:(NSString*)v_strDishId _deskID:(NSString*)v_strDeskID;

/** 删除该已选菜 */
- (BOOL) deleteDishOfSelectedForDishItem:(DishItem*)v_dishItem _deskID:(NSString*)v_strDeskID;

@end
