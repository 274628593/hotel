//
//  DeskManager.h
//  HotelSystem
//
//  Created by hancj on 15/11/17.
//  Copyright © 2015年 hancj. All rights reserved.
//

#import <Foundation/Foundation.h>
@class DeskItem;

#define DeskManager_ColName_DeskID          @"DeskManager_ColName_DeskID" /* 桌子ID，唯一识别字段 */
#define DeskManager_ColName_DeskNumber      @"DeskManager_ColName_DeskNumber" /* 桌子数字，唯一识别字段 */

//#define DeskManager_ColName_FoodID          @"DeskManager_ColName_FoodID" /* 已经选择的菜ID */
//#define DeskManager_ColName_FoodName        @"DeskManager_ColName_FoodName" /* 已经选择的菜名称 */
//#define DeskManager_ColName_FoodNumber      @"DeskManager_ColName_FoodNumber" /* 已经选择的菜数量 */
//#define DeskManager_ColName_FoodPrice       @"DeskManager_ColName_FoodPrice" /* 单菜价 */

/** 桌子数据管理器 */
@interface DeskManager : NSObject

// ==============================================================================================
#pragma mark 外部调用方法
/** 初始化对象 */
+ (NSDictionary*) InitDataWithDeskItem:(DeskItem*)v_deskItem;

/** 初始化对象 */
+ (DeskItem*) InitDeskItemWithData:(NSDictionary*)v_dic;

/** 全局对象 - 用餐桌子数据管理对象 */
+ (DeskManager*) SharedDeskManagerObj;

/** 获取所有已订餐的桌子 */
- (NSArray<DeskItem*>*) getDeskItemList;

/** 获取所有已订餐的桌子 */
- (NSArray<NSDictionary*>*) getDeskList;

/** 删除指定ID的桌子 */
- (BOOL) deleteDesk:(NSString*)v_strDeskID;

/** 删除指定ID的桌子 */
- (BOOL) deleteDeskWithDeskNum:(int)v_deskNum;

/** 添加订餐桌子，入参：桌子号 */
- (BOOL) addDeskWithDeskNum:(int)v_deskNum;

/** 是否已经存在这个桌子 */
- (BOOL) isHaveTheDeskOfDeskNum:(int)v_deskNum;

/** 添加订餐桌子 */
- (BOOL) addDeskWithDeskItem:(DeskItem*)v_deskItem;

/** 添加订餐桌子 */
- (BOOL) addDesk:(NSDictionary*)v_dicData;

@end
