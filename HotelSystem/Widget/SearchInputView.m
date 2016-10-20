//
//  SearchInputView.m
//  HotelSystem
//
//  Created by hancj on 15/11/19.
//  Copyright © 2015年 hancj. All rights reserved.
//

#import "SearchInputView.h"
#import "CPublic.h"

typedef enum : int{
    ClickTag_OpenSearchMode = 1, /* 开启搜索模式 */
} ClickTag;

@implementation SearchInputView
{
    BOOL        m_bIsLayoutView;
    UILabel     *m_labInBtn;
    NSString    *m_strPlaceHolder;
    EditView    *m_editView;
    UIButton    *m_btnOpenSearch;
    float       m_xOfAniFrom;
}
@synthesize m_textColor;
@synthesize m_textFont;

// ==============================================================================================
#pragma mark 基层类方法
- (id) initWithFrame:(CGRect)v_frame
{
    self = [super initWithFrame:v_frame];
    if(self != nil){
        [self initData];
    }
    return self;
}
- (void) layoutSubviews
{
    [super layoutSubviews];
    if(m_bIsLayoutView == YES) { return; }
    
    m_bIsLayoutView = YES;
    [self initLayoutView];
}

// ==============================================================================================
#pragma mark 内部使用方法
/** 初始化数据 */
- (void) initData
{
    m_bIsLayoutView = NO;
    m_textColor = Color_RGB(30, 30, 30);
    m_textFont = Font(18.0f);
    m_strPlaceHolder = @"搜 索";
}
/** 初始化布局 */
- (void) initLayoutView
{
    UIView *viewSearchNormal = [self getSearchView_normal];
    m_btnOpenSearch = (UIButton*)viewSearchNormal;
    [self addSubview:viewSearchNormal];
    
    [self initEditView_search];
}
/** 返回点击搜索框之前的View */
- (UIView*) getSearchView_normal
{
    UIButton *btnRS = [UIButton new];
    [btnRS setFrame:self.bounds];
    [btnRS setBackgroundColor:Color_Transparent];
    [btnRS setTag:ClickTag_OpenSearchMode];
    [btnRS addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    // ====== 显示在搜索栏中的文字 ======
    CGSize sizeFont = [CPublic getTextSize:m_strPlaceHolder _font:m_textFont];
    float x_add = 0;
    float y_add = 0;
    float w_add = sizeFont.width;
    float h_add = btnRS.bounds.size.height;
    UILabel *labTitle = [UILabel new];
    [labTitle setFrame:CGRectMake(x_add, y_add, w_add, h_add)];
    [labTitle setBackgroundColor:Color_Transparent];
    [labTitle setContentMode:UIViewContentModeCenter];
    [labTitle setNumberOfLines:1];
    [labTitle setText:m_strPlaceHolder];
    [labTitle setTextAlignment:NSTextAlignmentLeft];
    [labTitle setTextColor:m_textColor];
    [labTitle setFont:m_textFont];
    [labTitle setCenter:CGPointMake(btnRS.bounds.size.width/2, labTitle.center.y)];
    [btnRS addSubview:labTitle];
    m_labInBtn = labTitle;
    
    return btnRS;
}
/** 初始化搜索框输入栏 － 开启搜索之后 */
- (void) initEditView_search
{
    float x_add = self.bounds.origin.x + 6;
    float y_add = self.bounds.origin.y;
    float w_add = self.bounds.size.width - x_add*2;
    float h_add = self.bounds.size.height - y_add*2;
    EditView *editView = [EditView new];
    [editView setFrame:CGRectMake(x_add, y_add, w_add, h_add)];
    [editView setBackgroundColor:Color_Transparent];
    [editView setTextColor:m_textColor];
    [editView setTextFont:m_textFont];
    [editView setEditViewType:EditViewType_SinggleRow];
    [editView setPlaceHolder:m_strPlaceHolder];
    [editView setPlaceHolderColor:m_textColor];
    [editView setDelegate:(id)self];
    [editView setHidden:YES];
    [self addSubview:editView];
    m_editView = editView;
}
/** 开启搜索模式的动画 */
- (void) beginAnimation_openSearch
{
    m_xOfAniFrom = m_labInBtn.frame.origin.x;
    float x_aniTo = m_editView.frame.origin.x;
    [UIView animateWithDuration:0.4f animations:^{
        CGRect frame = m_labInBtn.frame;
        frame.origin.x = x_aniTo;
        m_labInBtn.frame = frame;
    } completion:^(BOOL v_b){
        [m_btnOpenSearch setHidden:YES];
        [m_editView setHidden:NO];
        [m_editView requireFirstResponder];
    }];
}
/** 关闭搜索模式的动画 */
- (void) endAnimation_closeSearch
{
    [m_editView setHidden:YES];
    [m_btnOpenSearch setHidden:NO];
    [UIView animateWithDuration:0.4f animations:^{
        CGRect frame = m_labInBtn.frame;
        frame.origin.x = m_xOfAniFrom;
        m_labInBtn.frame = frame;
    }];
}

// ==============================================================================================
#pragma mark 外部调用方法

// ==============================================================================================
#pragma mark 动作触发方法
/** 点击按钮方法 */
- (void) clickBtn:(id)v_sender
{
    UIView *view = (UIView*)v_sender;
    switch((ClickTag)view.tag)
    {
        case ClickTag_OpenSearchMode :{ // 开启搜索
            [self beginAnimation_openSearch];
            break;
        }
    }
}

// ==============================================================================================
#pragma mark 委托协议EditViewDelegate
/** 关闭键盘后的触发函数 */
- (void) closeKeyboardEvent
{
    [self endAnimation_closeSearch];
}
/** 确定输入内容之后回调这个方法 */
- (void) commitInput:(NSString*)v_strInputText _sender:(id)v_sender
{
    
}

@end
