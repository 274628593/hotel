//
//  DeskItem.h
//  HotelSystem
//
//  Created by hancj on 15/11/16.
//  Copyright © 2015年 hancj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CPublic.h"

@protocol DeskItemViewDelegate;

/** 桌子项View */
@interface DeskItemView : UIView

// ==============================================================================================
#pragma mark 外部方法
/** 是否开启删除模式 */
- (void) setIsOpenDeleteMode:(BOOL)v_bIsDeleteMode;

// ==============================================================================================
#pragma mark 外部变量
/** 委托 */
@property(nonatomic, weak, setter=setDelegate:, getter=getDelegate) id<DeskItemViewDelegate> m_delegate;

/** 桌子数字号 */
@property(nonatomic, assign, setter=setDeskItemNum:, getter=getDeskItemNum) int m_deskItemNum;

/** 圆角值 */
@property(nonatomic, assign, setter=setCornerRadius:, getter=getCornerRadius) float m_cornerRadius;

/** 字体 */
@property(nonatomic, retain , setter=setTextFont:, getter=getTextFont) UIFont *m_textFont;

/** 字体颜色 */
@property(nonatomic, retain, setter=setTextColor:, getter=getTextColor) UIColor *m_textColor;

@end

// ==============================================================================================
#pragma mark 委托协议
@protocol DeskItemViewDelegate<NSObject>

/** 点击桌子项 */
- (void) clickDeskItem:(id)v_sender;

/** 删除桌子项 */
- (void) removeDeskItemView:(id)v_sender;

@end

