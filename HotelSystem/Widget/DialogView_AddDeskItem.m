//
//  DialogView_AddDeskItem.m
//  HotelSystem
//
//  Created by hancj on 15/11/16.
//  Copyright © 2015年 hancj. All rights reserved.
//

#import "DialogView_AddDeskItem.h"

typedef enum : int{
    ClickTag_Cancel = 1, /* 取消 */
    ClickTag_Commit, /* 确定 */
} ClickTag;

@implementation DialogView_AddDeskItem
{
    BOOL        m_bIsLayoutView;
    EditView    *m_editView;
}
@synthesize m_delegate;
@synthesize m_textFont;
@synthesize m_textColor;

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
    [self setFrame:[UIScreen mainScreen].bounds];
}
/** 初始化布局 */
- (void) initLayoutView
{
    UIView *viewBG = [UIView new];
    [viewBG setFrame:self.bounds];
    [viewBG setBackgroundColor:Color_RGBA(30, 30, 30, 0.1f)];
    [viewBG setUserInteractionEnabled:YES];
    [self addSubview:viewBG];
    
    // ====== 中间填写框 ======
    float w_add = viewBG.bounds.size.width * 7.0/10.0;
    float x_add = (viewBG.bounds.size.width - w_add)/2;
    float y_add = 0.0f;
    float h_add = 0.0f;
    UIView *viewDialog = [UIView new];
    [viewDialog setFrame:CGRectMake(x_add, y_add, w_add, h_add)];
    [viewDialog setBackgroundColor:Color_RGB(200, 150, 40)];
    [viewDialog setClipsToBounds:YES];
    [viewDialog.layer setCornerRadius:6.0f];
    [viewDialog setUserInteractionEnabled:YES];
    [self addSubview:viewDialog];
    
    // ---- 编辑框 ----
    NSString *strText = @"高度";
    const float spaceTAndB = 20;
    float w_child = viewDialog.bounds.size.width *6.0/10.0f;
    float x_child = (viewDialog.bounds.size.width - w_child)/2;
    float y_child = spaceTAndB;
    float h_child = [CPublic getTextHeight:strText _font:m_textFont];
    UIView *viewEdit = [self getInputView:CGRectMake(x_child, y_child, w_child, h_child)];
    [viewDialog addSubview:viewEdit];
    y_child += viewEdit.frame.size.height;
    y_child += spaceTAndB;
    
    // ---- 确定／取消按钮 ----
    x_child = viewDialog.bounds.origin.x;
    h_child = 0;
    w_child = viewDialog.bounds.size.width - x_child*2;
    UIView *viewBtn = [self getBtnView:CGRectMake(x_child, y_child, w_child, h_child)];
    [viewDialog addSubview:viewBtn];
    y_child += viewBtn.frame.size.height;
    
    // ====== 重新设定尺寸 ======
    CGRect frame = viewDialog.frame;
    frame.size.height = y_child;
    viewDialog.frame = frame;
    [viewDialog setCenter:CGPointMake(viewDialog.center.x, viewBG.center.y)];
}
/** 获取编辑框 */
- (UIView*) getInputView:(CGRect)v_frame
{
    UIView *viewRS = [UIView new];
    [viewRS setFrame:v_frame];
    [viewRS setBackgroundColor:Color_RGB(255, 255, 255)];
    [viewRS.layer setCornerRadius:4.0f];
    [viewRS.layer setBorderColor:Color_RGB(120, 120, 120).CGColor];
    [viewRS.layer setBorderWidth:1.0f];
    [viewRS setClipsToBounds:YES];
    
    float x_add = viewRS.bounds.origin.x + 10;
    float y_add = viewRS.bounds.origin.y;
    float w_add = viewRS.bounds.size.width - x_add*2;
    float h_add = viewRS.bounds.size.height - y_add*2;
    EditView *editView = [EditView new];
    [editView setFrame:CGRectMake(x_add, y_add, w_add, h_add)];
    [editView setBackgroundColor:Color_Transparent];
    [editView setTextColor:m_textColor];
    [editView setTextFont:m_textFont];
    [editView setEditViewType:EditViewType_SinggleRow];
    [editView setPlaceHolder:@"输入桌子号"];
    [editView setDelegate:(id)self];
    [editView setIsInputOnlyNum:YES];
    [editView requireFirstResponder];
    [editView setKeyboardType:UIKeyboardTypeNumberPad];
    [viewRS addSubview:editView];
    m_editView = editView;
    
    return viewRS;
}
/** 获取按钮View */
- (UIView*) getBtnView:(CGRect)v_frame
{
    UIView *viewRS = [UIView new];
    [viewRS setFrame:v_frame];
    [viewRS setBackgroundColor:Color_RGBA(80, 80, 80, 0.1f)];
    [viewRS setUserInteractionEnabled:YES];
    
    // ====== 确定按钮 ======
    NSString *strTemp = @"确 定";
    CGSize sizeFont = [CPublic getTextSize:strTemp _font:m_textFont];
    sizeFont.height *= 1.2/1.0f;
//    sizeFont.width *= 2.0f;
    
    int w_add = viewRS.bounds.size.width/2;
    int h_add = sizeFont.height;
    const int space_x = 0;
    const int space_y = 10;
    int x_add = viewRS.bounds.origin.x + space_x;
    int y_add = viewRS.bounds.origin.y + space_y;
    UIButton *btnCommit = [UIButton new];
    [btnCommit setFrame:CGRectMake(x_add, y_add, w_add, h_add)];
    [btnCommit setBackgroundColor:Color_Transparent];
    [btnCommit setTitle:strTemp forState:UIControlStateNormal];
    [btnCommit setTitleColor:m_textColor forState:UIControlStateNormal];
    [btnCommit.titleLabel setFont:m_textFont];
    [btnCommit setTag:ClickTag_Commit];
    [btnCommit addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    [viewRS addSubview:btnCommit];
    x_add += (btnCommit.frame.size.width + space_x);
    
    // ====== 取消按钮 ======
    UIButton *btnCancel = [UIButton new];
    [btnCancel setFrame:CGRectMake(x_add, y_add, w_add, h_add)];
    [btnCancel setBackgroundColor:Color_Transparent];
    [btnCancel setTitle:@"取 消" forState:UIControlStateNormal];
    [btnCancel setTitleColor:m_textColor forState:UIControlStateNormal];
    [btnCancel.titleLabel setFont:m_textFont];
    [btnCancel setTag:ClickTag_Cancel];
    [btnCancel addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    [viewRS addSubview:btnCancel];
    y_add += (btnCommit.frame.size.height + space_y);
    
    CGRect frame = viewRS.frame;
    frame.size.height = y_add;
    viewRS.frame = frame;
    
    return viewRS;
}

/** 确定添加桌子项 */
- (void) commitAddDeskItem
{
    NSString *strRS = [m_editView getTextContent];
    int num = [strRS intValue];
    if(num == 0){
        [CPublic ShowDialg:@"请输入桌子号，从1开始"];
        return;
    }
    if(m_delegate != nil){
        BOOL bTemp = [m_delegate respondsToSelector:@selector(commitAddDeskItem: _sender:)];
        if(bTemp == YES){
            [m_delegate commitAddDeskItem:num _sender:self];
        }
    }
}
// ==============================================================================================
#pragma mark - 外部调用方法
/** 显示对话框 */
- (void) showDialog
{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}

// ==============================================================================================
#pragma mark 动作触发方法
/** 点击按钮方法 */
- (void) clickBtn:(id)v_sender
{
    UIView *view = (UIView*)v_sender;
    switch((ClickTag)view.tag)
    {
        case ClickTag_Commit:{ // 确定添加
            [m_editView resignFirstResponder];
            [self commitAddDeskItem];
            break;
        }
        case ClickTag_Cancel:{ // 取消
            [m_editView resignFirstResponder];
            [self removeFromSuperview];
            break;
        }
    }
}
// ==============================================================================================
#pragma mark -  委托协议EditViewDelegate
/** 确定输入内容之后回调这个方法 */
- (void) commitInput:(NSString*)v_strInputText _sender:(id)v_sender
{
//    [self commitAddDeskItem];
}

@end
