//
//  SearchInputView.h
//  HotelSystem
//
//  Created by hancj on 15/11/19.
//  Copyright © 2015年 hancj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditView.h"

/** 搜索框 */
@interface SearchInputView : UIView<EditViewDelegate>

// ==============================================================================================
#pragma mark 外部方法

// ==============================================================================================
#pragma mark 外部变量
/** 委托 */
//@property(nonatomic, retain, setter=setDelegate:, getter=getDelegate) id<DeskViewDelegate> m_delegate;

/** 字体 */
@property(nonatomic, retain , setter=setTextFont:, getter=getTextFont) UIFont *m_textFont;

/** 字体颜色 */
@property(nonatomic, retain, setter=setTextColor:, getter=getTextColor) UIColor *m_textColor;

@end
