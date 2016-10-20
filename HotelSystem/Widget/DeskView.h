//
//  DeskView.h
//  HotelSystem
//
//  Created by hancj on 15/11/16.
//  Copyright © 2015年 hancj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DeskItemView.h"
#import "DeskItem.h"

@protocol DeskViewDelegate;

/** 添加／编辑桌号的界面View */
@interface DeskView : UIView<DeskItemViewDelegate>

// ==============================================================================================
#pragma mark 外部方法
/** 设置桌子列表 */
- (void) setDeskitemList:(NSArray*)v_aryDeskItem;

/** 添加桌子项 */
- (void) addDeskItem:(DeskItem*)v_deskItem;

/** 添加桌子项 */
- (void) addDeskItem_id:(NSString*)v_strDeskID _num:(int)v_deskNum;

/** 移除桌子项 */
- (void) removeDeskItem:(DeskItem*)v_deskItem;

/** 移除桌子项 */
- (void) removeDeskItemAtIndex:(int)v_index;

// ==============================================================================================
#pragma mark 外部变量
/** 委托 */
@property(nonatomic, weak, setter=setDelegate:, getter=getDelegate) id<DeskViewDelegate> m_delegate;

/** 字体 */
@property(nonatomic, retain , setter=setTextFont:, getter=getTextFont) UIFont *m_textFont;

/** 字体颜色 */
@property(nonatomic, retain, setter=setTextColor:, getter=getTextColor) UIColor *m_textColor;

@end

// ==============================================================================================
#pragma mark 委托协议
@protocol DeskViewDelegate<NSObject>

/** 添加桌子 */
- (void) addDeskItemView:(id)v_sender;

/** 删除桌子 */
- (void) deleteDeskItem:(DeskItem*)v_deskItem _sender:(id)v_sender;

/** 打开对应桌子的详情 */
- (void) openDeskItem:(DeskItem*)v_deskItem _sender:(id)v_sender;

/** 当DeskView尺寸改变的时候调用这个函数 */
- (void) changeDeskViewSize:(id)v_sender;

@end

