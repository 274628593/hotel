//
//  ViewController_selectDishTypeName.h
//  HotelSystem
//
//  Created by LHJ on 16/3/19.
//  Copyright © 2016年 hancj. All rights reserved.
//

#import "UIViewController_Base.h"
#import "DishStyleNameItem.h"

@protocol ViewController_selectDishTypeNameDelegate;

/** 选择现有的菜系，也可以新建菜系 */
@interface ViewController_selectDishTypeName : UIViewController_Base

// ==================================================================================
#pragma mark - 外部调用方法
/** 更新菜系名 */
- (BOOL) updateDishStyleNameItem:(DishStyleNameItem*)v_item;

/** 添加菜系名 */
- (BOOL) addDishStyleNameItem:(NSString*)v_strName;

// ==================================================================================
#pragma mark - 外部变量
/** 委托 */
@property(nonatomic, weak, setter=setDelegate:, getter=getDelegate) id<ViewController_selectDishTypeNameDelegate> m_delegate;

/** Tag */
@property(nonatomic, assign, setter=setTag:, getter=getTag) int m_tag;

@end

// ==================================================================================
#pragma mark - 委托协议
@protocol ViewController_selectDishTypeNameDelegate<NSObject>

/** 编辑菜系名的界面 */
- (void) openViewControllerOfEditDishStyleName:(DishStyleNameItem*)v_strDishStyleName;

/** 添加菜系名的界面 */
- (void) openViewControllerOfAddDishStyleName;

/** 返回选择的菜系名对象 */
- (void) getDishStyleNameItemOfSelectResult:(DishStyleNameItem*)v_dishStyleNameItem _sender:(id)v_sender;

@end