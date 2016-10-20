//
//  FoodManager.h
//  HotelSystem
//
//  Created by hancj on 15/11/18.
//  Copyright © 2015年 hancj. All rights reserved.
//

#import <Foundation/Foundation.h>
@class DishStyleItem;

#define DishStyleManager_ColName_DishStyleID            @"DishStyleManager_ColName_DishStyleID" /* 菜ID，唯一识别字段 */
#define DishStyleManager_ColName_DishStyleName          @"DishStyleManager_ColName_DishStyleName" /* 菜系名称 */
#define DishStyleManager_ColName_DishStyleImgPath       @"DishStyleManager_ColName_DishStyleImgPath" /* 菜系ID*/

/** 菜系管理器 */
@interface DishStyleManager : NSObject

// ==============================================================================================
#pragma mark 外部调用方法
/** 初始化对象 */
+ (NSDictionary*) InitDataWithDishStyleItem:(DishStyleItem*)v_deskItem;

/** 初始化对象 */
+ (DishStyleItem*) InitDishStyleItemWithData:(NSDictionary*)v_dic;

/** 全局对象 - 菜系管理器对象 */
+ (DishStyleManager*) SharedDishStyleManagerObj;

/** 获取所有菜系 */
- (NSArray<NSDictionary*>*) getDishStyleList;

/** 获取所有菜系 */
- (NSArray<DishStyleItem*>*) getDishStyleItemList;

/** 添加菜系 */
- (BOOL) addDishStyleWithDishStyleNameID:(NSString*)v_strDishStyleNameItemID
                                   _name:(NSString*)v_strDishStyleName
                 _imgPathOfDishStyleIcon:(NSString*)v_strImgPath;

/** 添加菜系 */
- (BOOL) addDishStyle:(NSDictionary*)v_dicDishStyle;

/** 编辑菜系 */
- (BOOL) updateDishStyle:(NSDictionary*)v_dicDishStyle;

/** 编辑菜系 */
- (BOOL) updateDishStyle:(NSString*)v_strDishStyleID
                   _name:(NSString*)v_strDishStyleName
 _imgPathOfDishStyleIcon:(NSString*)v_strImgPath;

/** 编辑菜系 */
- (BOOL) updateDishStyleWithDishStyleItem:(DishStyleItem*)v_dishStyleItem;

/** 删除菜系 */
- (BOOL) deleteDishStyle:(NSString*)v_strDishStyleID;

@end
