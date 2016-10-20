//
//  DishItemView.h
//  HotelSystem
//
//  Created by LHJ on 16/3/24.
//  Copyright © 2016年 hancj. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DishItem;

@protocol DishItemViewDelegate;

/** 菜View */
@interface DishItemView : UIView

// ==============================================================================================
#pragma mark - 外部调用方法
/** 设置是否可选，编辑状态下不可选 */
- (void) setIsSelectEnable:(BOOL)v_bIsSelectEnable;

// ==============================================================================================
#pragma mark - 外部变量
/** 委托 */
@property(nonatomic, weak , setter=setDelegate:, getter=getDelegate) id<DishItemViewDelegate> m_delegate;

/** 设置要显示的菜对象，在显示之前设置 */
@property(nonatomic, retain , setter=setDishItem:, getter=getDishItem) DishItem *m_dishItem;

/** 字体 */
@property(nonatomic, retain , setter=setFontTitle:, getter=getFontTitle) UIFont *m_fontTitle;

/** 字体颜色 */
@property(nonatomic, retain, setter=setColorTitle:, getter=getColorTitle) UIColor *m_colorTitle;

/** 字体颜色 */
@property(nonatomic, retain, setter=setColorPrice:, getter=getColorPrice) UIColor *m_colorPrice;

/** 字体 */
@property(nonatomic, retain, setter=setFontPrice:, getter=getFontPrice) UIFont *m_fontPrice;

/** 是否已经选择了这道菜 */
@property(nonatomic, assign, setter=setIsSelected:, getter=getIsSelected) BOOL m_bIsSelected;

@end

// ==============================================================================================
#pragma mark - 委托协议
@protocol DishItemViewDelegate<NSObject>

/** 点击选择按钮 */
- (void) clickSelectBtn_sender:(id)v_sender;

/** 点击打开View详情 */
- (void) clickItemViewDetails_sender:(id)v_sender;

@end
