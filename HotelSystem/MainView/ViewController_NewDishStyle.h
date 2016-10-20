//
//  ViewController_NewDishStyle.h
//  HotelSystem
//
//  Created by LHJ on 16/3/19.
//  Copyright © 2016年 hancj. All rights reserved.
//

#import "UIViewController_Base.h"
#import "GetPhoto.h"
@class DishStyleNameItem;
@class DishStyleItem;

@protocol ViewController_NewDishStyleDelegate;

/** 创建新菜系的界面 */
@interface ViewController_NewDishStyle : UIViewController_Base<GetPhotoDelegate>

// ==================================================================================
#pragma mark - 外部调用方法
/** 设置选择的菜系名，用于再菜系名列表选择之后设置用的 */
- (void) setNameOfDishStyleWithItem:(DishStyleNameItem*)v_item;

/** 设置需要编辑的菜系，在打开这个界面之后设置 */
- (void) setDishStyleItemForEdit:(DishStyleItem*)v_dishStyleItem;

// ==================================================================================
#pragma mark - 外部变量
/** 委托 */
@property(nonatomic, weak, setter=setDelegate:, getter=getDelegate) id<ViewController_NewDishStyleDelegate> m_delegate;

@end

// ==================================================================================
#pragma mark - 委托协议
@protocol ViewController_NewDishStyleDelegate<NSObject>

/** 打开选择菜系名的下拉选择列表界面 */
- (void) openSelectDropView:(id)v_sender;

/** 确定新建菜系 */
- (void) commitAddNewDishStyleWithID:(NSString*)v_strDishStyleID
                               _name:(NSString*)v_strName
                       _iconFilePath:(NSString*)v_strIconFilePath;

/** 确定编辑菜系 */
- (void) commitEditDishStyleWithDishStyleID:(NSString*)v_strID
                                   _newName:(NSString*)v_strName
                           _newIconFilePath:(NSString*)v_strIconFilePath;

@end
