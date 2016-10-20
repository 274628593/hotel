//
//  View_Search.m
//  HotelSystem
//
//  Created by LHJ on 16/4/1.
//  Copyright © 2016年 hancj. All rights reserved.
//

#import "View_Search.h"
#import "CPublic.h"

typedef enum : int{

    ViewTag_OpenSearchMode = 1, /* 打开搜索模式 */
    
} ViewTag;

@implementation View_Search
{
    UIButton    *m_btnSearch;
    EditView    *m_editView;
    BOOL        m_bIsOpenEditView;
}
@synthesize m_textColor;
@synthesize m_textFont;
@synthesize m_bIsEditWhileShow;
@synthesize m_delegate;
@synthesize m_strTextDefault;

- (instancetype) init{
    self = [super init];
    if(self != nil){
        [self initData];
    }
    return self;
}
/** 初始化数据 */
- (void) initData
{
    m_textFont = Font(22);
    m_textColor = Color_RGB(30, 30, 30);
    m_bIsEditWhileShow = NO;
    m_strTextDefault = @"";
}
- (void) layoutSubviews
{
    [super layoutSubviews];
    [self initMainView];
    [self addViewToShow];
}
/** 把界面View显示到屏幕上 */
- (void) addViewToShow
{
    if(m_bIsOpenEditView == YES){ // 编辑模式开启，显示编辑框
        if(m_editView != nil){
            const float space_x = 16;
            const float x_add = space_x;
            const float y_add = 0;
            const float w_add = self.bounds.size.width - x_add - space_x;
            const float h_add = self.bounds.size.height;
            [m_editView setFrame:CGRectMake(x_add, y_add, w_add, h_add)];
            [self addSubview:m_editView];
            [m_editView requireFirstResponder];
        }
        if(m_btnSearch != nil
           && [m_btnSearch superview] != nil){
            [m_btnSearch removeFromSuperview];
        }
        
    } else { // 编辑模式关闭，显示按钮
        if(m_btnSearch != nil){
            [m_btnSearch setFrame:self.bounds];
            [self addSubview:m_btnSearch];
        }
        if(m_editView != nil
           && [m_editView superview] != nil){
            [m_editView removeFromSuperview];
        }
    }
}
/** 初始化View */
- (void) initMainView
{
    if(m_btnSearch == nil){
        UIButton *btn = [UIButton new];
        [btn setTitle:@"搜 索" forState:UIControlStateNormal];
        [btn setTitleColor:m_textColor forState:UIControlStateNormal];
        [btn setBackgroundColor:Color_Transparent];
        [btn setTag:ViewTag_OpenSearchMode];
        [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        [btn.titleLabel setFont:m_textFont];
        m_btnSearch = btn;
    }
    if(m_editView == nil){
        EditView *editView = [EditView new];
        [editView setUserInteractionEnabled:YES];
        [editView setBackgroundColor:Color_Transparent];
        [editView setIsShowClearBtn:YES];
        [editView setIsPasswordMode:NO];
        [editView setTextFont:m_textFont];
        [editView setIsInputOnlyNum:NO];
        [editView setTextAlignment:NSTextAlignmentLeft];
        [editView setTextColor:m_textColor];
        [editView setTextContent:m_strTextDefault];
        [editView setPlaceHolder:@"输入搜索关键字"];
        [editView setPlaceHolderColor:Color_RGB(255, 255, 255)];
        [editView setTag:[self tag]];
        [editView setDelegate:(id)self];
        [editView setIsEditEnable:YES];
        [editView setReturnKeyType:UIReturnKeySearch];
        m_editView = editView;
    }
}
/** 确定搜索 */
- (void) commitSearch
{
    NSString *strSearch = [m_editView getTextContent];
    if(m_delegate != nil){
        [m_delegate commitSearch:strSearch];
    }
}
- (void) setIsOpenEditView:(BOOL)v_bIsOpen
{
    m_bIsOpenEditView = v_bIsOpen;
    [self setNeedsLayout];
}
// ==============================================================================================
#pragma mark - 外部调用方法
- (void) setIsEditWhileShow:(BOOL)v_bIsEditWhileShow
{
    m_bIsEditWhileShow = v_bIsEditWhileShow;
    if(m_bIsEditWhileShow == YES){
        m_bIsOpenEditView = YES;
    }
}

// ==============================================================================================
#pragma mark - 动作触发方法
/** 点击按钮事件 */
- (void) clickBtn:(id)v_sender
{
    UIView *view = v_sender;
    ViewTag viewTag = (ViewTag)[view tag];
    switch(viewTag){
        case ViewTag_OpenSearchMode:{ // 打开搜索模式
            [self setIsOpenEditView:YES];
            break;
        }
    }
}

// ==============================================================================================
#pragma mark -  委托协议EditViewDelegate
/** 跳转到下一个编辑框 */
- (void) gotoNextEditView:(id)v_sender _returnKeyType:(UIReturnKeyType)v_returnKeyType;
{
    [self commitSearch];
}
/* 关闭键盘后的触发函数 */
- (void) closeKeyboardEvent:(id)v_sender
{
    [self setIsOpenEditView:NO];
}
@end
