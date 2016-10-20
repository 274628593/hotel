//
//  NameOfDishStyleManager.h
//  HotelSystem
//
//  Created by LHJ on 16/3/20.
//  Copyright © 2016年 hancj. All rights reserved.
//

#import <Foundation/Foundation.h>
@class DishStyleNameItem;

#define NameOfDishStyleManager_ColName_DishStyleID            @"NameOfDishStyleManager_ColName_DishStyleID" /* 菜ID，唯一识别字段 */
#define NameOfDishStyleManager_ColName_DishStyleName          @"NameOfDishStyleManager_ColName_DishStyleName" /* 菜系名称 */

/** 菜系名称管理器 */
@interface NameOfDishStyleManager : NSObject

// ==============================================================================================
#pragma mark - 外部调用方法
/** 初始化对象 */
+ (NSDictionary*) InitDataWithDishStyleNameItem:(DishStyleNameItem*)v_deskItem;

/** 初始化对象 */
+ (DishStyleNameItem*) InitDishStyleNameItemWithData:(NSDictionary*)v_dic;

/** 全局对象 - 菜系管理器对象 */
+ (NameOfDishStyleManager*) SharedNameOfDishStyleManagerObj;

/** 获取所有菜系 */
- (NSArray<NSDictionary*>*) getNameOfDishStyleList;

/** 获取所有菜系 */
- (NSArray<DishStyleNameItem*>*) getNameOfDishStyleItemList;

/** 判断是否已经有了这个菜系名 */
- (BOOL) isHaveThisNameOfDishStyle:(NSString*)v_strName;

/** 添加菜系 */
- (BOOL) addDishStyleName_id:(NSString*)v_strNameOfDishStyleItemID
                       _name:(NSString*)v_strNameOfDishStyleItemName;

/** 添加菜系 */
- (BOOL) addDishStyleName_name:(NSString*)v_strNameOfDishStyleItemName;

/** 添加菜系 */
- (BOOL) addDishStyleName:(NSDictionary*)v_dicNameOfDishStyleItem;

/** 添加菜系 */
- (BOOL) addDishStyleNameWithItem:(DishStyleNameItem*)v_deskItem;

/** 删除菜系 */
- (BOOL) deleteDishStyleName:(NSString*)v_strNameOfDishStyleItemID;

@end

