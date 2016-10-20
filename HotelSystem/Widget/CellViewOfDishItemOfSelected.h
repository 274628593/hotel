//
//  CellViewOfDishItemOfSelected.h
//  HotelSystem
//
//  Created by LHJ on 16/3/28.
//  Copyright © 2016年 hancj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditView.h"
@class DishItemOfSelected;

@protocol CellViewOfDishItemOfSelectedDelegate;

/** 已选菜单CellView */
@interface CellViewOfDishItemOfSelected : UIView<EditViewDelegate, UIAlertViewDelegate>

// ==============================================================================================
#pragma mark - 外部变量
/** 委托 */
@property(nonatomic, weak , setter=setDelegate:, getter=getDelegate) id<CellViewOfDishItemOfSelectedDelegate> m_delegate;

/** 设置要显示的已选菜对象，在显示之前设置 */
@property(nonatomic, retain , setter=setDishItemOfSelected:, getter=getDishItemOfSelected) DishItemOfSelected *m_dishItemOfSelected;

/** 菜名字体 */
@property(nonatomic, retain , setter=setFontDishName:, getter=getFontDishName) UIFont *m_fontDishName;

/** 菜名颜色 */
@property(nonatomic, retain, setter=setColorDishName:, getter=getColorDishName) UIColor *m_colorDishName;

/** 价格字体 */
@property(nonatomic, retain , setter=setFontDishPrice:, getter=getFontDishPrice) UIFont *m_fontDishPrice;

/** 价格颜色 */
@property(nonatomic, retain, setter=setColorDishPrice:, getter=getColorDishPrice) UIColor *m_colorDishPrice;

/** 数量字体 */
@property(nonatomic, retain , setter=setFontDishNum:, getter=getFontDishNum) UIFont *m_fontDishNum;

/** 数量颜色 */
@property(nonatomic, retain, setter=setColorDishNum:, getter=getColorDishNum) UIColor *m_colorDishNum;

///** 价格折扣 */
//@property(nonatomic, assign, setter=setDishPriceDiscount:, getter=getDishPriceDiscount) float m_dishPriceDiscount;

/** 界面宽度比例，分别对应（菜名+菜图）、（菜价格）、（菜价格）、（菜数量）、（操作） */
@property(nonatomic, retain , setter=setAryViewScale:, getter=getAryViewScale) NSArray *m_aryViewScale;

@end

// ==============================================================================================
#pragma mark - 委托协议
@protocol CellViewOfDishItemOfSelectedDelegate<NSObject>

/** 点击了增加按钮 */
- (void) clickBtn_addDishWithDishItem:(DishItemOfSelected*)v_dishItem _sender:(id)v_sender;

/** 点击了减少按钮 */
- (void) clickBtn_reduceDishWithDishItem:(DishItemOfSelected*)v_dishItem _sender:(id)v_sender;

/** 确定输入折扣之后 */
- (void) commitNewDiscount:(float)v_discount _dishItem:(DishItemOfSelected*)v_dishItem _sender:(id)v_sender;

@end


