//
//  ViewController_DishList.h
//  HotelSystem
//
//  Created by LHJ on 16/3/24.
//  Copyright © 2016年 hancj. All rights reserved.
//

#import "UIViewController_Base.h"
#import "DishItemView.h"
#import "View_Search.h"
@class DeskItem;

@protocol ViewController_DishListDelegate;

/** 选菜界面 */
@interface ViewController_DishList : UIViewController_Base<DishItemViewDelegate, View_SearchDelegate>

// ==================================================================================
#pragma mark - 外部调用方法
/** 是否可以编辑 */
- (void) setIsEditEnable:(BOOL)v_bIsEditEnable;

/** 设置要显示的菜系ID，为nil时则显示全部，默认nil，在界面显示之前设置 */
- (void) setDishStyleIdOfDishList:(NSString*)v_strDishStyleID _dishStyleName:(NSString*)v_strDishStyleName;

/** 设置要搜索的文字，如果设置这个，则显示搜索界面的风格，在界面显示之前设置 */
- (void) setSearchText:(NSString*)v_strSearchText;

/** 是否是打开推荐菜单，如果设置这个，则设置菜系ID和搜索关键字都无效，显示前设置 */
- (void) setIsOpenRecommendDish:(BOOL)v_bIsRecommend;

/** 添加新菜，v_dishItem里面ID为空 */
- (void) addNewDish:(DishItem*)v_dishItem;

/** 编辑菜 */
- (void) updateDish:(DishItem*)v_dishItem;

// ==================================================================================
#pragma mark - 外部变量
/** 委托 */
@property(nonatomic, weak, setter=setDelegate:, getter=getDelegate) id<ViewController_DishListDelegate> m_delegate;

/** 要展示的桌子号，在界面显示之前显示 */
@property(nonatomic, retain, setter=setDeskItem:, getter=getDeskItem) DeskItem *m_deskItem;

@end

// ==================================================================================
#pragma mark - 委托协议
@protocol ViewController_DishListDelegate<NSObject>

/** 打开添加菜的页面 */
- (void) openNewDishViewController_dishStyleID:(NSString*)v_strDishStyleID
                                _dishStyleName:(NSString*)v_strDishStyleName
                                  _isRecommend:(BOOL)v_bIsRecommend
                                       _sender:(id)v_sender;

/** 打开编辑菜的页面 */
- (void) openEditDishViewControllerWithDishItem:(DishItem*)v_dishItem _sender:(id)v_sender;

/** 打开菜浏览的页面 */
- (void) openDishDetailsViewControllerWithDishList:(NSArray<DishItem*>*)v_aryDishList
                                         _aryIndex:(int)v_index
                                           _sender:(id)v_sender;
/** 打开该桌子已经选择的菜单界面 */
- (void) openViewControllerOfDishListOfSelectedFromDishListWithDeskItem:(DeskItem*)v_deskItem _sender:(id)v_sender;

@end
