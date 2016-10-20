//
//  View_Base.m
//  HotelSystem
//
//  Created by hancj on 15/11/13.
//  Copyright © 2015年 hancj. All rights reserved.
//

#import "View_Base.h"

#define Height_Nav  60.0f

/** 点击标识 */
typedef enum : int{
    ClickTag_NavLeftBtn = 1, /* 导航栏左侧按钮 */
    ClickTag_NavRightBtn, /* 导航栏右侧按钮 */
} ClickTag;

/** 界面标识 */
typedef enum : int{
    ViewTag_Nav = 1, /* 导航栏 */
    ViewTag_Bottom, /* 底部栏 */
    ViewTag_Main, /* 主界面 */
} ViewTag;

@implementation View_Base
{
    BOOL m_bIsLayoutView;
}
@synthesize m_bIsShowNav;
@synthesize m_btnLeftNav;
@synthesize m_btnRightNav;
@synthesize m_bIsShowLeftBtn;
@synthesize m_bIsShowRightBtn;
@synthesize m_strTitle;
@synthesize m_titleColor;
@synthesize m_titleFont;

// ==============================================================================================
#pragma mark 基类方法
- (id) initWithFrame:(CGRect)v_frame
{
    self = [super initWithFrame:v_frame];
    if(self != nil){
        [self initBaseData];
        [self initData];
    }
    return self;
}
- (void) layoutSubviews
{
    [super layoutSubviews];
    if(m_bIsLayoutView == YES) { return; }
    
    m_bIsLayoutView = YES;
    [self initBaseLayoutView];
    [self performSelector:@selector(beginHandleData)];
}

// ==============================================================================================
#pragma mark 内部使用方法
/** 初始化基类数据 */
- (void) initBaseData
{
    m_strTitle = @"";
    m_bIsLayoutView = NO;
    m_bIsShowNav = YES;
    m_btnLeftNav = nil;
    m_btnRightNav = nil;
    m_bIsShowLeftBtn = YES;
    m_bIsShowRightBtn = NO;
    m_titleColor = Color_RGB(30, 30, 30);
    m_titleFont = Font_Bold(16.0f);
}
/** 初始化界面 */
- (void) initBaseLayoutView
{
    // ====== 顶部栏 ======
    float x_add = self.bounds.origin.x;
    float y_add = self.bounds.origin.y;
    float w_add = self.bounds.size.width;
    float h_add = 0;
    if(m_bIsShowNav == YES){
        CGRect frameNav = CGRectMake(x_add, y_add, w_add, h_add);
        UIView *viewNav = [self initNavView:frameNav];
        if(viewNav != nil){
            [viewNav setTag:ViewTag_Nav];
            [self addSubview:viewNav];
        }
    }
    
    // ====== 底部栏 ======
    h_add = 60.0f;
    y_add = self.bounds.size.height - h_add;
    UIView *viewBottom = [self initBottomView:CGRectMake(x_add, y_add, w_add, h_add)];
    if(viewBottom != nil){
        if(viewBottom.tag != 0){ // 底部可能设计成按钮，需要用到Tag，所以则另设一层View
            UIView *viewTemp = [UIView new];
            [viewTemp setFrame:viewBottom.frame];
            [viewTemp setBackgroundColor:Color_Transparent];
            [viewTemp setUserInteractionEnabled:YES];
            [viewTemp addSubview:viewBottom];
            
            CGRect frameTemp = viewBottom.frame;
            frameTemp.origin = viewTemp.bounds.origin;
            viewBottom.frame = frameTemp;
            viewBottom = viewTemp;
        }
        
        [viewBottom setTag:ViewTag_Bottom];
        [self addSubview:viewBottom];
    }
    
    // ====== 主界面栏 ======
    UIView *viewTemp = [self viewWithTag:ViewTag_Nav];
    y_add = (viewTemp == nil) ? self.bounds.origin.y : viewTemp.frame.origin.y + viewTemp.frame.size.height;
    
    viewTemp = [self viewWithTag:ViewTag_Bottom];
    h_add = (viewBottom == nil)? self.bounds.size.height - y_add : viewTemp.frame.origin.y - y_add;
    UIView *viewMain = [self initMainView:CGRectMake(x_add, y_add, w_add, h_add)];
    if(viewMain != nil){
        [viewMain setTag:ViewTag_Main];
        [self addSubview:viewMain];
    }
}
/** 待重写函数，初始化头部导航栏，当不实现此方法时，用默认的顶部栏 */
- (UIView*) initNavView:(CGRect)v_frameNav
{
    const float heightNav = Height_Nav;
    const float heightStatusBar = (SystemVersonOfIOS >= SystemVersonOfIOS_7_0)? Height_StatusBar : 0;
    int h_rs = heightStatusBar + heightNav;
    int w_rs = v_frameNav.size.width;
    CGSize sizeRS = CGSizeMake(w_rs, h_rs);
    v_frameNav.size = sizeRS;
    UIView *viewRS = [UIView new];
    [viewRS setFrame:v_frameNav];
    [viewRS setBackgroundColor:Color_RGB(120, 120, 120)];
    [viewRS setUserInteractionEnabled:YES];
    [viewRS setClipsToBounds:YES];
    
    // ====== 导航栏 ======
    float x_add = viewRS.bounds.origin.x;
    float y_add = heightStatusBar;
    float w_add = viewRS.bounds.size.width - x_add*2;
    float h_add = viewRS.bounds.size.height - y_add;
    UIView *viewNav = [UIView new];
    [viewNav setFrame:CGRectMake(x_add, y_add, w_add, h_add)];
    [viewNav setBackgroundColor:Color_Transparent];
    [viewNav setUserInteractionEnabled:YES];
    [viewRS addSubview:viewNav];
    
    // ====== 导航栏左侧按钮 ======
    if(m_bIsShowLeftBtn == YES){
        if(m_btnLeftNav == nil){
            float h_btn = viewNav.bounds.size.height;
            float w_btn = h_btn;
            UIButton *btn = [UIButton new];
            [btn setFrame:CGRectMake(0, 0, w_btn, h_btn)];
            [btn setBackgroundColor:Color_Transparent];
            [btn setAdjustsImageWhenHighlighted:NO];
            [btn setTitle:@"返回" forState:UIControlStateNormal];
            [btn setTag:ClickTag_NavLeftBtn];
            [btn addTarget:self action:@selector(clickBtn_BaseView:) forControlEvents:UIControlEventTouchUpInside];
            m_btnLeftNav = btn;
        }
        float x_btn = viewNav.bounds.origin.x;
        float y_btn = viewNav.bounds.origin.y;
        CGRect frame = m_btnRightNav.frame;
        frame.origin = CGPointMake(x_btn, y_btn);
        m_btnRightNav.frame = frame;
        [viewNav addSubview:m_btnLeftNav];
    }
    
    // ====== 导航栏右侧按钮 ======
    if(m_bIsShowRightBtn == YES){
        if(m_btnRightNav == nil){
            float h_btn = viewNav.bounds.size.height;
            float w_btn = h_btn;
            UIButton *btn = [UIButton new];
            [btn setFrame:CGRectMake(0, 0, w_btn, h_btn)];
            [btn setBackgroundColor:Color_Transparent];
            [btn setAdjustsImageWhenHighlighted:NO];
            [btn setTitle:@"右侧按钮" forState:UIControlStateNormal];
            [btn setTag:ClickTag_NavRightBtn];
            [btn addTarget:self action:@selector(clickBtn_BaseView:) forControlEvents:UIControlEventTouchUpInside];
            m_btnRightNav = btn;
        }
        float y_btn = viewNav.bounds.origin.y;
        float x_btn = viewNav.bounds.size.width - m_btnRightNav.frame.size.width;
        CGRect frame = m_btnRightNav.frame;
        frame.origin = CGPointMake(x_btn, y_btn);
        m_btnRightNav.frame = frame;
        [viewNav addSubview:m_btnRightNav];
    }
    
    // ====== 导航栏标题 ======
    float x_child = (m_btnLeftNav == nil)? viewNav.bounds.origin.x : viewNav.bounds.origin.x + m_btnLeftNav.frame.size.width;
    float y_child = viewNav.bounds.origin.y;
    float w_child = (m_btnRightNav == nil)? viewNav.bounds.size.width - x_child*2 : m_btnRightNav.frame.origin.x - x_child;
    float h_child = viewNav.bounds.size.height - y_child;
    UILabel *labTitle = [UILabel new];
    [labTitle setFrame:CGRectMake(x_child, y_child, w_child, h_child)];
    [labTitle setBackgroundColor:Color_Transparent];
    [labTitle setText:m_strTitle];
    [labTitle setTextAlignment:NSTextAlignmentCenter];
    [labTitle setTextColor:m_titleColor];
    [labTitle setFont:m_titleFont];
    [labTitle setLineBreakMode:NSLineBreakByTruncatingMiddle];
    [labTitle setNumberOfLines:1];
    [viewNav addSubview:labTitle];
    
    return (id)viewRS;
}

// ==============================================================================================
#pragma mark 外部调用方法
/** 返回主界面View对象 */
- (UIView*) getMainView
{
    return [self viewWithTag:ViewTag_Main];
}
/** 获取导航栏高度 */
- (float) getNavHeight
{
    return Height_Nav;
}

// ==============================================================================================
#pragma mark 待子类实现方法
- (void) initData
{

}

/** 待重写函数，初始化主界面View */
- (UIView*) initMainView:(CGRect)v_frameMain
{
    return nil;
}

/** 待重写函数，初始化底部View，当不实现此方法或者返回nil时，不显示底部栏 */
- (UIView*) initBottomView:(CGRect)v_frameNav
{
    return nil;
}

/** 所有界面完成后开始调用的数据 */
- (void) beginHandleData
{

}

/** 点击顶部栏左按钮 */
- (void) clickNavLeftBtn
{

}

/** 点击顶部栏右按钮 */
- (void) clickNavRightBtn
{

}

// ==============================================================================================
#pragma mark 动作触发方法
/** 点击按钮事件 */
- (void) clickBtn_BaseView:(id)v_sender
{
    UIView *view = (UIView*)v_sender;
    switch((ClickTag)view.tag)
    {
        case ClickTag_NavLeftBtn:{ // 点击导航栏左侧按钮
            [self clickNavLeftBtn];
            break;
        }
        case ClickTag_NavRightBtn:{ // 点击导航栏右侧按钮
            [self clickNavRightBtn];
            break;
        }
    }
}

@end
