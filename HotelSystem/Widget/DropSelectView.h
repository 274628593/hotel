//
//  DropSelectView.h
//  HotelSystem
//
//  Created by LHJ on 16/3/21.
//  Copyright © 2016年 hancj. All rights reserved.
//

#import <UIKit/UIKit.h>

/** 下拉选择View */
@interface DropSelectView : UIButton

// ==============================================================================================
#pragma mark - 外部调用方法

// ==============================================================================================
#pragma mark - 外部变量
/** 菜系名 */
@property(nonatomic, copy, setter=setSelectName:, getter=getSelectName) NSString *m_strSelectName;

/** 字体 */
@property(nonatomic, retain , setter=setTextFont:, getter=getTextFont) UIFont *m_textFont;

/** 字体颜色 */
@property(nonatomic, retain, setter=setTextColor:, getter=getTextColor) UIColor *m_textColor;

@end
