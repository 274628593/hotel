//
//  MenuTypeView.h
//  HotelSystem
//
//  Created by hancj on 15/11/20.
//  Copyright © 2015年 hancj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuTypeItem.h"
#import "MenuTypeItemView.h"

@protocol MenuTypeViewDelegate;

/** 菜系选择View */
@interface MenuTypeView : UIView

// ==============================================================================================
#pragma mark 外部调用方法
/** 是否开启编辑模式，默认NO */
- (void) setIsOpenEditMode:(BOOL)v_bIsEditMode;

/** 设置桌子列表 */
- (void) setMenuItemList:(NSArray*)v_aryDeskItem;

// ==============================================================================================
#pragma mark 外部变量
/** 委托 */
@property(nonatomic, retain, setter=setDelegate:, getter=getDelegate) id<MenuTypeViewDelegate> m_delegate;

/** 字体 */
@property(nonatomic, retain , setter=setTextFont:, getter=getTextFont) UIFont *m_textFont;

/** 字体颜色 */
@property(nonatomic, retain, setter=setTextColor:, getter=getTextColor) UIColor *m_textColor;

@end

// ==============================================================================================
#pragma mark 委托协议
@protocol MenuTypeViewDelegate<NSObject>

/** 添加桌子 */
- (void) addMenuTypeItemView:(id)v_sender;

/** 删除桌子 */
- (void) deleteMenuTypeItem:(MenuTypeItem*)v_MenuTypeItem _sender:(id)v_sender;

/** 打开对应桌子的详情 */
- (void) openMenuTypeItem:(MenuTypeItem*)v_menuTypeItem _sender:(id)v_sender;

/** 当DeskView尺寸改变的时候调用这个函数 */
- (void) changeMenuTypeViewSize:(id)v_sender;

@end
