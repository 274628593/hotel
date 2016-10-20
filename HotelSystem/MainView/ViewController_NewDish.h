//
//  ViewController_NewDish.h
//  HotelSystem
//
//  Created by LHJ on 16/3/25.
//  Copyright © 2016年 hancj. All rights reserved.
//

#import "UIViewController_Base.h"
#import "GetPhoto.h"
#import "EditView.h"

@class DishStyleNameItem;
@class DishItem;

@protocol ViewController_NewDishDelegate;

/** 添加或者编辑菜的界面 */
@interface ViewController_NewDish : UIViewController_Base<GetPhotoDelegate, EditViewDelegate>

// ==================================================================================
#pragma mark - 外部调用方法
/** 设置菜系，可通用与编辑菜和新建菜 */
- (void) setDishStyleWithID:(NSString*)v_strDishStyleID _dishStyleName:(NSString*)v_strDishStyleName;

/** 是否默认设置为推荐菜 */
- (void) setIsRecommendDefault:(BOOL)v_bIsRecommend;

/** 设置菜，用于编辑菜的时候设置的，在界面显示之前设置，不然该界面变为新建模式 */
- (void) setDishItemForEdit:(DishItem*)v_dishItem;

// ==================================================================================
#pragma mark - 外部变量
/** 委托 */
@property(nonatomic, weak, setter=setDelegate:, getter=getDelegate) id<ViewController_NewDishDelegate> m_delegate;

/** Tag */
@property(nonatomic, assign, setter=setTag:, getter=getTag) int m_tag;

@end

// ==================================================================================
#pragma mark - 委托协议
@protocol ViewController_NewDishDelegate<NSObject>

/** 打开选择菜系名的下拉选择列表界面 */
- (void) openSelectDropView_newDish:(id)v_sender;

/** 新建菜，返回一个没有ID的DishItem，ID在添加数据库的时候自动创建 */
- (void) addNewDishWithDishItemOfNoID:(DishItem*)v_dishItem;

/** 新建菜，返回一个更新数据之后的DishItem */
- (void) updateDishWithDishItem:(DishItem*)v_dishItem;

@end
