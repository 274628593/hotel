//
//  View_BaseScrollView.m
//  HotelSystem
//
//  Created by hancj on 15/11/13.
//  Copyright © 2015年 hancj. All rights reserved.
//

#import "View_BaseScrollView.h"

/** 界面标识 */
typedef enum : int{
    ViewTag_Main = 1, /* 主界面 */
} ViewTag;

@implementation View_BaseScrollView

// ==============================================================================================
#pragma mark 基类方法
- (UIView*) initMainView:(CGRect)v_frameMain
{
    UIScrollView *viewRS = [UIScrollView new];
    [viewRS setFrame:v_frameMain];
    [viewRS setBackgroundColor:Color_Transparent];
    [viewRS setIndicatorStyle:UIScrollViewIndicatorStyleWhite];
    [viewRS setPagingEnabled:NO];
    
    UIView *viewMain = [self initMainView_BaseScroll:viewRS.bounds];
    if(viewMain != nil){
        [viewMain setTag:ViewTag_Main];
        [viewRS addSubview:viewMain];
        int hContentSize = viewMain.frame.origin.y + viewMain.frame.size.height;
//        hContentSize = (hContentSize > viewRS.contentSize.height )? hContentSize : viewRS.contentSize.height;
        [viewRS setContentSize:CGSizeMake(viewRS.contentSize.width, hContentSize)];
    }
    
    return (id)viewRS;
}
// ==============================================================================================
#pragma mark 外部调用方法
/** 返回主界面View对象 */
- (UIView*) getMainView_BaseScroll
{
    UIView *viewScr = [self getMainView];
    return [viewScr viewWithTag:ViewTag_Main];
}
/** 刷新主界面尺寸 */
- (void) updateMainViewSize_BaseScroll:(CGSize)v_size
{
    UIScrollView *viewScr = (UIScrollView*)[self getMainView];
    UIView *viewMain = [viewScr viewWithTag:ViewTag_Main];
    CGRect frame = viewMain.frame;
    frame.size = v_size;
    viewMain.frame = frame;
    
    int hViewSize = viewMain.frame.size.height;
    [viewScr setContentSize:CGSizeMake(viewScr.contentSize.width, hViewSize)];
}
/** 刷新主界面尺寸 */
- (void) updateMainViewHeight_BaseScroll:(int)v_height
{
    UIView *viewMain = [self getMainView_BaseScroll];
    CGSize size = viewMain.frame.size;
    size.height = v_height;
    [self updateMainViewSize_BaseScroll:size];
}

/** 刷新滑动尺寸 */
- (void) updateScrollViewContentHeight:(float)v_height
{
    UIView *viewScr = (UIView*)[self getMainView];
    CGSize size = viewScr.frame.size;
    size.height = v_height;
    [self updateScrollViewContentSize:size];
}
/** 刷新滑动尺寸 */
- (void) updateScrollViewContentSize:(CGSize)v_size
{
    UIScrollView *viewScr = (UIScrollView*)[self getMainView];
    [viewScr setContentSize:v_size];
}

// ==============================================================================================
#pragma mark View_BaseScrollView待子类实现的方法
/** 待重写函数，初始化主界面View */
- (UIView*) initMainView_BaseScroll:(CGRect)v_frameMain
{
    return nil;
}


@end
