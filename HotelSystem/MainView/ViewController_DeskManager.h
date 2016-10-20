//
//  ViewController_DeskManager.h
//  HotelSystem
//
//  Created by LHJ on 16/3/16.
//  Copyright © 2016年 hancj. All rights reserved.
//

#import "UIViewController_Base.h"
#import "DeskItemView.h"
#import "DialogView_AddDeskItem.h"
#import "DeskItem.h"

@protocol ViewController_DeskManagerDelegate;

@class DeskManager;

/** 用餐桌子管理界面 */
@interface ViewController_DeskManager : UIViewController_Base<DeskItemViewDelegate, DialogView_AddDeskItemDelegate>

// ==================================================================================
#pragma mark - 外部调用方法

// ==================================================================================
#pragma mark - 外部变量
/** 委托 */
@property(nonatomic, weak, setter=setDelegate:, getter=getDelegate) id<ViewController_DeskManagerDelegate> m_delegate;

@end

// ==================================================================================
#pragma mark - 委托协议
@protocol ViewController_DeskManagerDelegate<NSObject>

@optional
/** 打开该菜系选择界面 */
- (void) openDiskTypeView_deskItem:(DeskItem*)v_deskItem _sender:(id)v_sender;

/** 设置是否开启编辑 */
- (void) setEditEnable:(BOOL)v_bIsEdit;

/** 打开共享数据的界面 */
- (void) openShareDataViewController:(ViewController_DeskManager*)v_controller;

@end
