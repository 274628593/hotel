//
//  View_Base.h
//  HotelSystem
//
//  Created by hancj on 15/11/13.
//  Copyright © 2015年 hancj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CPublic.h"

/** 界面基类 */
@interface View_Base : UIView

// ==============================================================================================
#pragma mark View_Base外部方法
/** 返回主界面View对象 */
- (UIView*) getMainView;

/** 获取导航栏高度 */
- (float) getNavHeight;

// ==============================================================================================
#pragma mark 外部变量
/** 顶部栏标题 */
@property(nonatomic, copy, setter=setTitle:)NSString *m_strTitle;

/** 是否显示顶部栏，默认YES */
@property(nonatomic, assign, setter=setShowNav:) BOOL m_bIsShowNav;

/** 是否显示导航栏左侧按钮，默认YES */
@property(nonatomic, assign, setter=setShowNavLeftBtn:) BOOL m_bIsShowLeftBtn;

/** 是否显示导航栏右侧按钮，默认NO */
@property(nonatomic, assign, setter=setShowNavRightBtn:) BOOL m_bIsShowRightBtn;

/** 顶部栏左按钮 */
@property(nonatomic, retain, setter=setNavLeftBtn:) UIButton *m_btnLeftNav;

/** 顶部栏右按钮 */
@property(nonatomic, retain, setter=setNavRightBtn:) UIButton *m_btnRightNav;

/** 顶部导航栏标题字体 */
@property(nonatomic, retain , setter=setTitleFont:, getter=getTitleFont) UIFont *m_titleFont;

/** 顶部导航栏标题字体颜色 */
@property(nonatomic, retain, setter=setTitleColor:, getter=getTitleColor) UIColor *m_titleColor;

// ==============================================================================================
#pragma mark View_Base待子类实现的方法
/** 初始化数据 */
- (void) initData;

/** 待重写函数，初始化头部导航栏，当不实现此方法时，用默认的底部栏 */
- (UIView*) initNavView:(CGRect)v_frameNav;

/** 待重写函数，初始化主界面View */
- (UIView*) initMainView:(CGRect)v_frameMain;

/** 待重写函数，初始化底部View，当不实现此方法或者返回nil时，不显示底部栏 */
- (UIView*) initBottomView:(CGRect)v_frame;

/** 所有界面完成后开始调用的数据 */
- (void) beginHandleData;

/** 点击顶部栏左按钮 */
- (void) clickNavLeftBtn;

/** 点击顶部栏右按钮 */
- (void) clickNavRightBtn;

@end
