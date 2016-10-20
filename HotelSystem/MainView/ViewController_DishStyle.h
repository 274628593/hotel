//
//  ViewController_DishStyle.h
//  HotelSystem
//
//  Created by LHJ on 16/3/19.
//  Copyright © 2016年 hancj. All rights reserved.
//

#import "UIViewController_Base.h"
#import "DishStyleItem.h"
#import "DishStyleItemView.h"
#import "View_Search.h"
@class DeskItem;

@protocol ViewController_DishStyleDelegate;

/** 菜系选择图 */
@interface ViewController_DishStyle : UIViewController_Base<DishStyleItemViewDelegate, View_SearchDelegate>

// ==================================================================================
#pragma mark - 外部调用方法
/** 是否可以编辑 */
- (void) setIsEditEnable:(BOOL)v_bIsEditEnable;

/** 添加新的菜系 */
- (void) addDishStyleWithDishStyleID:(NSString*)v_strDishTyleID
                               _name:(NSString*)v_strName
                        _imgFilePath:(NSString*)v_strFilePath;

/** 编辑菜系 */
- (void) editDishStyleWithDishStyleID:(NSString*)v_strDishStyleID
                             _newName:(NSString*)v_strDishStyleName
                      _newImgFilePath:(NSString*)v_strImgFilePath;

// ==================================================================================
#pragma mark - 外部变量
/** 委托 */
@property(nonatomic, weak, setter=setDelegate:, getter=getDelegate) id<ViewController_DishStyleDelegate> m_delegate;

/** 要展示的桌子号，在界面显示之前显示 */
@property(nonatomic, retain, setter=setDeskItem:, getter=getDeskItem) DeskItem *m_deskItem;

@end

// ==================================================================================
#pragma mark - 委托协议
@protocol ViewController_DishStyleDelegate<NSObject>

/** 打开新建菜系的界面 */
- (void) openViewControllerOfAddNewDishStyle_sender:(id)v_sender;

/** 打开编辑菜系的界面 */
- (void) openViewControllerOfEditDishStyle:(DishStyleItem*)v_dishStyleItem _sender:(id)v_sender;

/** 打开推荐菜单 */
- (void) openViewControllerOfRecommendDish:(id)v_sender;

/** 打开全部菜单 */
- (void) openViewControllerOfAllDish:(id)v_sender;

/** 打开搜索菜单 */
- (void) openViewControllerOfSearchDishWithSearchText:(NSString*)v_strSearchText _sender:(id)v_sender;

/** 打开指定菜系的菜单 */
- (void) openViewControllerOfDishListForDishStyleItem:(DishStyleItem*)v_dishStyleItem _sender:(id)v_sender;

/** 打开该桌子已经选择的菜单界面 */
- (void) openViewControllerOfDishListOfSelectedFromDishStyleWithDeskItem:(DeskItem*)v_deskItem _sender:(id)v_sender;

@end
