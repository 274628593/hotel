//
//  View_BaseScrollView.h
//  HotelSystem
//
//  Created by hancj on 15/11/13.
//  Copyright © 2015年 hancj. All rights reserved.
//

#import "View_Base.h"

/** 界面基类－主界面实现有滑动栏 */
@interface View_BaseScrollView : View_Base

// ==============================================================================================
#pragma mark View_BaseScrollView外部方法
/** 返回主界面View对象 */
- (UIView*) getMainView_BaseScroll;

/** 刷新主界面尺寸 */
- (void) updateMainViewSize_BaseScroll:(CGSize)v_size;

/** 刷新主界面尺寸 */
- (void) updateMainViewHeight_BaseScroll:(int)v_height;

/** 刷新滑动尺寸 */
- (void) updateScrollViewContentHeight:(float)v_height;

/** 刷新滑动尺寸 */
- (void) updateScrollViewContentSize:(CGSize)v_size;

// ==============================================================================================
#pragma mark View_BaseScrollView待子类实现的方法
/** 待重写函数，初始化主界面View */
- (UIView*) initMainView_BaseScroll:(CGRect)v_frameMain;

@end
