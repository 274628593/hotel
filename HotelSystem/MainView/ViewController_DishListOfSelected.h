//
//  ViewController_DishListOfSelected.h
//  HotelSystem
//
//  Created by LHJ on 16/3/28.
//  Copyright © 2016年 hancj. All rights reserved.
//

#import "UIViewController_Base.h"
#import "CellViewOfDishItemOfSelected.h"
#import "EditViewWithIcon.h"

@class DeskItem;

@protocol ViewController_DishListOfSelectedDelegate;
/** 已选菜单界面 */
@interface ViewController_DishListOfSelected : UIViewController_Base<CellViewOfDishItemOfSelectedDelegate, UITableViewDataSource, UITableViewDelegate, EditViewDelegate>

// ==================================================================================
#pragma mark - 外部调用方法

// ==================================================================================
#pragma mark - 外部变量
/** 委托 */
@property(nonatomic, weak, setter=setDelegate:, getter=getDelegate) id<ViewController_DishListOfSelectedDelegate> m_delegate;

/** Tag */
@property(nonatomic, assign, setter=setTag:, getter=getTag) int m_tag;

/** 要展示的桌子号，在界面显示之前显示 */
@property(nonatomic, retain, setter=setDeskItem:, getter=getDeskItem) DeskItem *m_deskItem;

@end

// ==================================================================================
#pragma mark - 委托协议
@protocol ViewController_DishListOfSelectedDelegate<NSObject>

/** 再去选菜，打开选择菜系的界面 */
- (void) openViewControllerOfDishStyleFromDishListSelectedView_deskItem:(DeskItem*)v_deskItem _sender:(id)v_sender;

@end