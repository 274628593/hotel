//
//  ViewController_DishDetails.h
//  HotelSystem
//
//  Created by LHJ on 16/3/26.
//  Copyright © 2016年 hancj. All rights reserved.
//

#import "UIViewController_Base.h"
@class DeskItem;
@class DishItem;

@protocol ViewController_DishDetailsDelegate;

// ==================================================================================
#pragma mark - 外部调用方法
/** 菜详情页面 */
@interface ViewController_DishDetails : UIViewController_Base<UIScrollViewDelegate>

/** 设置菜列表，用于显示菜的详情，在界面显示之前设置，需要传入当前要显示的菜的列表索引 */
- (void) setDishItemList:(NSArray<DishItem*>*)v_aryDishItemList _curIndex:(int)v_index;

// ==================================================================================
#pragma mark - 外部变量
/** 委托 */
@property(nonatomic, weak, setter=setDelegate:, getter=getDelegate) id<ViewController_DishDetailsDelegate> m_delegate;

/** Tag */
@property(nonatomic, assign, setter=setTag:, getter=getTag) int m_tag;

/** 要展示的桌子号，在界面显示之前显示 */
@property(nonatomic, retain, setter=setDeskItem:, getter=getDeskItem) DeskItem *m_deskItem;

@end

// ==================================================================================
#pragma mark - 委托协议
@protocol ViewController_DishDetailsDelegate<NSObject>


@end