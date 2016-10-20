//
//  BtnForRecommend.h
//  HotelSystem
//
//  Created by LHJ on 16/3/23.
//  Copyright © 2016年 hancj. All rights reserved.
//

#import <UIKit/UIKit.h>

/** 所有菜单按钮 */
@interface BtnForAllDish : UIButton

// ==============================================================================================
#pragma mark - 外部调用方法

// ==============================================================================================
#pragma mark - 外部变量
/** 字体 */
@property(nonatomic, retain , setter=setTextFont:, getter=getTextFont) UIFont *m_textFont;

/** 字体颜色 */
@property(nonatomic, retain, setter=setTextColor:, getter=getTextColor) UIColor *m_textColor;

@end
