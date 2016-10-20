//
//  DialogView_AddDeskItem.h
//  HotelSystem
//
//  Created by hancj on 15/11/16.
//  Copyright © 2015年 hancj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditView.h"
#import "CPublic.h"

@protocol DialogView_AddDeskItemDelegate;

/** 添加桌子号的对话框 */
@interface DialogView_AddDeskItem : UIView<EditViewDelegate>

// ==============================================================================================
#pragma mark - 外部调用方法
/** 显示对话框 */
- (void) showDialog;

// ==============================================================================================
#pragma mark 外部变量
/** 委托 */
@property(nonatomic, weak, setter=setDelegate:, getter=getDelegate) id<DialogView_AddDeskItemDelegate> m_delegate;

/** 字体 */
@property(nonatomic, retain , setter=setTextFont:, getter=getTextFont) UIFont *m_textFont;

/** 字体颜色 */
@property(nonatomic, retain, setter=setTextColor:, getter=getTextColor) UIColor *m_textColor;

@end

// ==============================================================================================
#pragma mark 委托协议
@protocol DialogView_AddDeskItemDelegate<NSObject>

/** 确定添加桌子项 */
- (void) commitAddDeskItem:(int)v_deskNum _sender:(id)v_sender;

@end