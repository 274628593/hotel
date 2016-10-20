//
//  MenuTypeItemView.h
//  HotelSystem
//
//  Created by hancj on 15/11/20.
//  Copyright © 2015年 hancj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CPublic.h"
#import "View_Toast.h"

@protocol DishStyleItemViewDelegate;

/** 菜单项View */
@interface DishStyleItemView : UIView
// ==============================================================================================
#pragma mark - 外部方法

// ==============================================================================================
#pragma mark - 外部变量
/** 委托 */
@property(nonatomic, weak, setter=setDelegate:, getter=getDelegate) id<DishStyleItemViewDelegate> m_delegate;

/** 菜系名 */
@property(nonatomic, copy, setter=setDishStyleName:, getter=getDishStyleName) NSString *m_strDishStyleName;

/** 菜系图名称 */
@property(nonatomic, copy, setter=setDishStyleImgPath:, getter=getDishStyleImgPath) NSString *m_strDishStyleImgPath;

/** 圆角值 */
@property(nonatomic, assign, setter=setCornerRadius:, getter=getCornerRadius) float m_cornerRadius;

/** 字体 */
@property(nonatomic, retain , setter=setTextFont:, getter=getTextFont) UIFont *m_textFont;

/** 字体颜色 */
@property(nonatomic, retain, setter=setTextColor:, getter=getTextColor) UIColor *m_textColor;

@end

// ==============================================================================================
#pragma mark 委托协议
@protocol DishStyleItemViewDelegate<NSObject>

@optional
/** 点击菜系 */
- (void) clickMenuTypeItem:(id)v_sender;

@end
