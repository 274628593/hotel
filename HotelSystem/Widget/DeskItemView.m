//
//  DeskItem.m
//  HotelSystem
//
//  Created by hancj on 15/11/16.
//  Copyright © 2015年 hancj. All rights reserved.
//

#import "DeskItemView.h"

typedef enum : int{
    ClickTag_Delete = 1, /* 删除 */
    ClickTag_Open,
} ClickTag;

@implementation DeskItemView
{
    BOOL        m_bIsLayoutView;
}
@synthesize m_deskItemNum;
@synthesize m_textColor;
@synthesize m_textFont;
@synthesize m_cornerRadius;
@synthesize m_delegate;

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
    m_deskItemNum = 1;
    [self setUserInteractionEnabled:YES];
    m_bIsLayoutView = NO;
    m_textColor = Color_RGB(30, 30, 30);
    m_textFont = Font(18.0f);
    m_cornerRadius = 0.0f;
}
/** 初始化布局 */
- (void) initLayoutView
{
    UIButton *btn = [UIButton new];
    [btn setFrame:self.bounds];
    [btn setClipsToBounds:YES];
    [btn setTag:ClickTag_Open];
    [btn.layer setCornerRadius:m_cornerRadius];
    [btn setBackgroundColor:Color_Transparent];
    [btn setBackgroundImage:GetImg(@"desk.jpg") forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
    
    UILabel *labNum = [UILabel new];
    [labNum setFrame:btn.bounds];
    [labNum setBackgroundColor:Color_Transparent];
    [labNum setNumberOfLines:2];
    [labNum setText:[NSString stringWithFormat:@"桌号%i", m_deskItemNum]];
    [labNum setTextAlignment:NSTextAlignmentCenter];
    [labNum setContentMode:UIViewContentModeCenter];
    [labNum setTextColor:m_textColor];
    [labNum setFont:m_textFont];
    [labNum setLineBreakMode:NSLineBreakByWordWrapping];
    [btn addSubview:labNum];
    
    // ====== 删除按钮 ======
    float w_add = self.bounds.size.width * 4.0/10.0;
    float h_add = w_add;
    float x_add = self.bounds.origin.x + self.bounds.size.width - w_add;
    float y_add = self.bounds.origin.y;
    UIButton *btnDelete = [UIButton new];
    [btnDelete setFrame:CGRectMake(x_add, y_add, w_add, h_add)];
    [btnDelete setBackgroundColor:Color_Transparent];
    [btnDelete setBackgroundImage:GetImg(@"delete") forState:UIControlStateNormal];
    [btnDelete setTag:ClickTag_Delete];
    [btnDelete setHidden:YES];
    [btnDelete addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btnDelete];
}
// ==============================================================================================
#pragma mark 外部调用方法
/** 是否开启删除模式 */
- (void) setIsOpenDeleteMode:(BOOL)v_bIsDeleteMode
{
    UIView *viewBtnDelete = [self viewWithTag:ClickTag_Delete];
    [viewBtnDelete setHidden:!v_bIsDeleteMode];
}

// ==============================================================================================
#pragma mark 动作触发方法
/** 点击按钮方法 */
- (void) clickBtn:(id)v_sender
{
    UIView *view = (UIView*)v_sender;
    switch((ClickTag)view.tag){
        case ClickTag_Delete:{ // 删除
            if(m_delegate != nil){
                BOOL bTemp = [m_delegate respondsToSelector:@selector(removeDeskItemView:)];
                if(bTemp == YES){
                    [m_delegate removeDeskItemView:self];
                }
            }
            break;
        }
        case ClickTag_Open:{ // 打开这个桌子项的详情
            if(m_delegate != nil){
                BOOL bTemp = [m_delegate respondsToSelector:@selector(clickDeskItem:)];
                if(bTemp == YES){
                    [m_delegate clickDeskItem:self];
                }
            }
            break;
        }
    }
}
@end
