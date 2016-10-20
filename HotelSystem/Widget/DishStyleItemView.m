//
//  MenuTypeItemView.m
//  HotelSystem
//
//  Created by hancj on 15/11/20.
//  Copyright © 2015年 hancj. All rights reserved.
//

#import "DishStyleItemView.h"
#import "EditView.h"

typedef enum : int{
    ViewTag_OpenDetails = 1, /* 点击打开详情 */
    ViewTag_EditView, /* 编辑框Tag */
}ViewTag;

@implementation DishStyleItemView
{
    BOOL        m_bIsLayoutView;
    UIButton    *m_btnIcon;
    EditView    *m_editView;
}
@synthesize m_strDishStyleImgPath;
@synthesize m_strDishStyleName;
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
    [self setUserInteractionEnabled:YES];
    m_bIsLayoutView = NO;
    m_textColor = Color_RGB(30, 30, 30);
    m_textFont = Font(18.0f);
    m_cornerRadius = 0.0f;
    m_strDishStyleName = @"";
    m_strDishStyleImgPath = @"";
}
/** 初始化布局 */
- (void) initLayoutView
{
    [self setClipsToBounds:NO];
    [self.layer setCornerRadius:m_cornerRadius];
    [self.layer setBorderWidth:1.0f];
    [self.layer setBorderColor:Color_RGBA(0, 0, 0, 0.6f).CGColor];
    
    // ====== 菜系名 ======
    const float spaceTandB = 12;
    float h_add =[CPublic getTextHeight:m_strDishStyleName _font:m_textFont];;
    float w_add = self.bounds.size.width;
    float x_add = self.bounds.origin.x;
    float y_add = self.bounds.size.height - h_add - spaceTandB;
    EditView *editView = [EditView new];
    [editView setFrame:CGRectMake(x_add, y_add, w_add, h_add)];
    [editView setBackgroundColor:Color_Transparent];
    [editView setEditViewType:EditViewType_SinggleRow];
    [editView setTextAlignment:NSTextAlignmentCenter];
    [editView setTextColor:m_textColor];
    [editView setTextContent:m_strDishStyleName];
    [editView setTextFont:m_textFont];
    [editView setIsEditEnable:NO];
    [editView setTag:ViewTag_EditView];
    [self addSubview:editView];
    m_editView = editView;
    
    // ====== 菜系图按钮 ======
    const float space = 6;
    y_add = self.bounds.origin.y + space;
    h_add = editView.frame.origin.y - spaceTandB - y_add;
    w_add = h_add;
    x_add = (self.bounds.size.width - w_add)/2;
    UIButton *btn = [UIButton new];
    [btn setFrame:CGRectMake(x_add, y_add, w_add, h_add)];
    [btn setClipsToBounds:YES];
    [btn setTag:ViewTag_OpenDetails];
    [btn.layer setCornerRadius:m_cornerRadius];
    [btn.layer setBorderWidth:1.0f];
    [btn.layer setBorderColor:Color_RGBA(255, 255, 255, 0.4f).CGColor];
    [btn setBackgroundColor:Color_Transparent];
    [btn setContentMode:UIViewContentModeScaleToFill];
    NSString *strImgPath = [CPublic getLocalAbsolutePathOfRelativePath:m_strDishStyleImgPath];
    [btn setBackgroundImage:[UIImage imageWithContentsOfFile:strImgPath] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
    m_btnIcon = btn;
}
// ==============================================================================================
#pragma mark 外部调用方法
- (void) setDishStyleImgPath:(NSString *)v_strDishStyleImgPath
{
    m_strDishStyleImgPath = v_strDishStyleImgPath;
    if(m_btnIcon != nil){
        NSString *strImgPath = [CPublic getLocalAbsolutePathOfRelativePath:m_strDishStyleImgPath];
        [m_btnIcon setBackgroundImage:[UIImage imageWithContentsOfFile:strImgPath] forState:UIControlStateNormal];
    }
}
- (void) setDishStyleName:(NSString *)v_strDishStyleName
{
    m_strDishStyleName = v_strDishStyleName;
    if(m_editView != nil){
        [m_editView setTextContent:m_strDishStyleName];
    }
}

// ==============================================================================================
#pragma mark 动作触发方法
/** 点击按钮方法 */
- (void) clickBtn:(id)v_sender
{
    UIView *view = (UIView*)v_sender;
    switch((ViewTag)view.tag){
        case ViewTag_OpenDetails:{ // 打开这个桌子项的详情
            if(m_delegate != nil){
                BOOL bTemp = [m_delegate respondsToSelector:@selector(clickMenuTypeItem:)];
                if(bTemp == YES){
                    [m_delegate clickMenuTypeItem:self];
                }
            }
            break;
        }
        default:{break;}
    }
}
- (UIViewController*) getControllerView
{
    UIViewController *controllerRS = nil;
    for(UIView *view = self; view!=nil; view=[view superview])
    {
        UIResponder *responder = [view nextResponder];
        if([responder isKindOfClass:[UIViewController class]] == YES){
            controllerRS = (UIViewController*)responder;
            break;
        }
    }
    return controllerRS;
}
@end
