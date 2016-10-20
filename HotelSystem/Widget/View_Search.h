//
//  View_Search.h
//  HotelSystem
//
//  Created by LHJ on 16/4/1.
//  Copyright © 2016年 hancj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditView.h"

@protocol View_SearchDelegate;

/** 搜索栏 */
@interface View_Search : UIView<EditViewDelegate>

// ==============================================================================================
#pragma mark - 外部调用方法

// ==============================================================================================
#pragma mark - 外部变量
/** 委托 */
@property(nonatomic, weak, setter=setDelegate:, getter=getDelegate) id<View_SearchDelegate> m_delegate;

/** 是否一开始就处于编辑模式，在界面显示之前设置，默认NO */
@property(nonatomic, assign, setter=setIsEditWhileShow:, getter=getIsEditWhileShow) BOOL m_bIsEditWhileShow;

/** 一开始就显示在编辑框的文字 */
@property(nonatomic, copy, setter=setTextDefault:) NSString *m_strTextDefault;

/** 字体 */
@property(nonatomic, retain , setter=setTextFont:, getter=getTextFont) UIFont *m_textFont;

/** 字体颜色 */
@property(nonatomic, retain, setter=setTextColor:, getter=getTextColor) UIColor *m_textColor;

@end

// ==============================================================================================
#pragma mark - 委托定义
@protocol View_SearchDelegate<NSObject>

/** 确定搜索的关键字 */
- (void) commitSearch:(NSString*)v_strSearch;

@end
