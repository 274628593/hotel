//
//  DishItemView.m
//  HotelSystem
//
//  Created by LHJ on 16/3/24.
//  Copyright © 2016年 hancj. All rights reserved.
//

#import "DishItemView.h"
#import "CPublic.h"
#import "DishItem.h"

typedef enum : int{
    ViewTag_SelectBtn = 1, /* 选择按钮，是否选择这道菜 */
    ViewTag_ItemView, /* 点击这个View的点击事件，用于打开这个菜的详情 */
    
}ViewTag;

@implementation DishItemView
{
    DishItem    *m_dishItem;
    BOOL        m_bIsSelectEnable;
    CGRect      m_frameSelf;
    
    UIButton        *m_btnDishItem;
    UIButton        *m_btnSelectOrNot;
    UIImageView     *m_imgViewIcon;
    UILabel         *m_labTitle;
    UILabel         *m_labPrice;
    UIImageView     *m_imgViewRecommend;
}
@synthesize m_colorPrice;
@synthesize m_colorTitle;
@synthesize m_delegate;
@synthesize m_fontPrice;
@synthesize m_fontTitle;
@synthesize m_bIsSelected;
@synthesize m_dishItem;

// ==============================================================================================
#pragma mark - 基类继承方法
- (instancetype) init{
    self = [super init];
    if(self != nil){
        [self initData];
    }
    return self;
}
- (void) layoutSubviews
{
    if(CGRectEqualToRect(m_frameSelf, self.frame) == YES) { return; }
    
    [super layoutSubviews];
    [self initMainView];
    [self sendAllViewAddToSelfView];
}
// ==============================================================================================
#pragma mark - 内部调用方法
/** 初始化数据 */
- (void) initData
{
    m_bIsSelected = NO;
    m_bIsSelectEnable = YES;
    m_dishItem = nil;
    m_colorTitle = Color_RGB(30, 30, 30);
    m_colorPrice = Color_RGB(200, 30, 120);
    m_fontTitle = Font(26);
    m_fontPrice = Font(22);
}
/** 初始化View */
- (void) initMainView
{
    if(m_btnDishItem == nil){
        UIButton *btn = [UIButton new];
        [btn setBackgroundColor:Color_RGB(255, 255, 255)];
        [btn setUserInteractionEnabled:YES];
        [btn setClipsToBounds:YES];
        [btn.layer setCornerRadius:6.0f];
        [btn.layer setBorderColor:Color_RGB(120, 120, 120).CGColor];
        [btn.layer setBorderWidth:1];
        [btn setTag:ViewTag_ItemView];
        [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        m_btnDishItem = btn;
        btn = nil;
    }
    if(m_btnSelectOrNot == nil){
        UIButton *btn = [UIButton new];
        [btn setBackgroundColor:Color_Transparent];
        [btn setUserInteractionEnabled:YES];
        [btn setClipsToBounds:YES];
        [btn setBackgroundImage:GetImg(@"mainview_noselect") forState:UIControlStateNormal];
        [btn setBackgroundImage:GetImg(@"mainview_selected") forState:UIControlStateSelected];
        [btn setTag:ViewTag_SelectBtn];
        [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        m_btnSelectOrNot = btn;
        btn = nil;
    }
    if(m_imgViewIcon == nil){
        UIImageView *imgView = [UIImageView new];
        [imgView setBackgroundColor:Color_Transparent];
        [imgView setUserInteractionEnabled:NO];
        [imgView setClipsToBounds:YES];
        [imgView.layer setCornerRadius:4.0f];
        [imgView.layer setBorderColor:Color_RGB(120, 120, 120).CGColor];
        [imgView.layer setBorderWidth:1];
        m_imgViewIcon = imgView;
        imgView = nil;
    }
    if(m_labTitle == nil){
        UILabel *lab = [UILabel new];
        [lab setUserInteractionEnabled:NO];
        [lab setBackgroundColor:Color_Transparent];
        [lab setNumberOfLines:1];
        [lab setFont:m_fontTitle];
        [lab setTextAlignment:NSTextAlignmentLeft];
        [lab setTextColor:m_colorTitle];
        m_labTitle = lab;
        lab = nil;
    }
    if(m_labPrice == nil){
        UILabel *lab = [UILabel new];
        [lab setUserInteractionEnabled:NO];
        [lab setBackgroundColor:Color_Transparent];
        [lab setNumberOfLines:1];
        [lab setFont:m_fontPrice];
        [lab setTextAlignment:NSTextAlignmentLeft];
        [lab setTextColor:m_colorPrice];
        m_labPrice = lab;
        lab = nil;
    }
    if(m_imgViewRecommend == nil){
        UIImageView *imgView = [UIImageView new];
        [imgView setBackgroundColor:Color_Transparent];
        [imgView setUserInteractionEnabled:NO];
        [imgView setClipsToBounds:YES];
        [imgView setContentMode:UIViewContentModeScaleAspectFit];
        [imgView setImage:GetImg(@"recommend")];
        m_imgViewRecommend = imgView;
        imgView = nil;
    }
    [self sendAllViewAddToSelfView];
}
/** 把所有界面添加到主界面显示 */
- (void) sendAllViewAddToSelfView
{
    const float spaceItem_y = 24;
    const float space_x = spaceItem_y/2;
    const float spaceInsert_y = 14;
    const float h_iconSelected = spaceItem_y*2;
    const float w_iconSelected = h_iconSelected;
    const float h_title = [CPublic getTextHeightWithLabelSizeToFit:@"高" _font:m_fontTitle];
    const float h_price = [CPublic getTextHeightWithLabelSizeToFit:@"高" _font:m_fontPrice];
    const float h_btnItemView = spaceItem_y + h_title + spaceInsert_y + h_price + spaceItem_y;
    const float h_imgViewIcon = h_title + spaceInsert_y + h_price;
    const float w_imgViewIcon = h_imgViewIcon * 6/5;
    const float h_imgViewRecommend = spaceItem_y * 2;
    const float w_imgViewRecommend = h_imgViewRecommend * 11/5;
//    const float h_self = space_y + h_btnItemView + space_y;
    
//    CGRect frame = self.frame;
//    frame.size.height = h_self;
//    self.frame = frame;
//    m_frameSelf = self.frame;
    
    float h_add = h_btnItemView;
    float x_add = space_x;
    float w_add = self.bounds.size.width - x_add - space_x;
    float y_add = (self.bounds.size.height - h_add)/2;
    [m_btnDishItem setFrame:CGRectMake(x_add, y_add, w_add, h_add)];
    [self addSubview:m_btnDishItem];
    
    // ====== 图标 ======
    h_add = h_imgViewIcon;
    w_add = w_imgViewIcon;
    x_add = space_x;
    y_add = (m_btnDishItem.bounds.size.height - h_add)/2;
    [m_imgViewIcon setFrame:CGRectMake(x_add, y_add, w_add, h_add)];
    NSString *strPath = [CPublic getLocalAbsolutePathOfRelativePath:[m_dishItem getDishIconImgPath]];
    [m_imgViewIcon setImage:[UIImage imageWithContentsOfFile:strPath]];
    [m_btnDishItem addSubview:m_imgViewIcon];
    
    // ====== 推荐图标 =====
    h_add = h_imgViewRecommend;
    w_add = w_imgViewRecommend;
    y_add = m_btnDishItem.frame.origin.y - h_add/2;
    x_add = 0;
    [m_imgViewRecommend setFrame:CGRectMake(x_add, y_add, w_add, h_add)];
    [self addSubview:m_imgViewRecommend];
    BOOL bIsRecommend = [m_dishItem getIsDishRecommend];
    [m_imgViewRecommend setHidden:!bIsRecommend];
    
    // ====== 标题 ======
    x_add = m_imgViewIcon.frame.origin.x + m_imgViewIcon.frame.size.width + space_x/2;
    y_add = m_imgViewIcon.frame.origin.y;
    w_add = m_btnDishItem.bounds.size.width - x_add - space_x;
    h_add = h_title;
    [m_labTitle setFrame:CGRectMake(x_add, y_add, w_add, h_add)];
    [m_labTitle setText:[m_dishItem getDishName]];
    [m_btnDishItem addSubview:m_labTitle];
    
    // ====== 价格 =====
    y_add += m_labTitle.frame.size.height + spaceInsert_y;
    h_add = h_price;
    [m_labPrice setFrame:CGRectMake(x_add, y_add, w_add, h_add)];
    [m_labPrice setText:[NSString stringWithFormat:@"%.02f", [m_dishItem getDishPrice]]];
    [m_btnDishItem addSubview:m_labPrice];
    
    // ====== 是否选择这道菜的图标 ======
    h_add = h_iconSelected;
    w_add = w_iconSelected;
    x_add = self.bounds.size.width - w_add;
    y_add = m_btnDishItem.frame.origin.y - h_add/2;;
    [m_btnSelectOrNot setFrame:CGRectMake(x_add, y_add, w_add, h_add)];
    [m_btnSelectOrNot setSelected:m_bIsSelected];
    [self addSubview:m_btnSelectOrNot];
    
    [self bringSubviewToFront:m_imgViewRecommend];
    [self bringSubviewToFront:m_btnSelectOrNot];
}
// ==============================================================================================
#pragma mark - 外部调用方法
/** 设置要显示的菜对象 */
- (void) setDishItem:(DishItem*)v_dishItem
{
    m_dishItem = v_dishItem;
    if(m_imgViewIcon != nil){
        NSString *strPath = [CPublic getLocalAbsolutePathOfRelativePath:[m_dishItem getDishIconImgPath]];
        [m_imgViewIcon setImage:[UIImage imageWithContentsOfFile:strPath]];
    }
    if(m_imgViewRecommend != nil){
        [m_imgViewRecommend setHidden:![m_dishItem getIsDishRecommend]];
    }
    if(m_labTitle != nil){
        [m_labTitle setText:[m_dishItem getDishName]];
    }
    if(m_labPrice != nil){
        [m_labPrice setText:[NSString stringWithFormat:@"%.02f", [m_dishItem getDishPrice]]];
    }
}

/** 设置是否可选，编辑状态下不可选 */
- (void) setIsSelectEnable:(BOOL)v_bIsSelectEnable
{
    m_bIsSelectEnable = v_bIsSelectEnable;
}
- (void) setIsSelected:(BOOL)v_bIsSelect
{
    m_bIsSelected = v_bIsSelect;
    if(m_btnSelectOrNot != nil){
        [m_btnSelectOrNot setSelected:m_bIsSelected];
    }
}

// ==============================================================================================
#pragma mark - 动作触发方法
/** 按钮点击事件 */
- (void) clickBtn:(id)v_sender
{
    UIView *view = (UIView*)v_sender;
    switch((ViewTag)view.tag){
        case ViewTag_ItemView:{
            if(m_delegate != nil){
                BOOL bTemp = [m_delegate respondsToSelector:@selector(clickItemViewDetails_sender:)];
                if(bTemp == YES){
                    [m_delegate clickItemViewDetails_sender:self];
                }
            }
            break;
        }
        case ViewTag_SelectBtn:{
            
            if(m_delegate != nil){
                BOOL bTemp = [m_delegate respondsToSelector:@selector(clickSelectBtn_sender:)];
                if(bTemp == YES){
                    [m_delegate clickSelectBtn_sender:self];
                }
            }
            break;
        }
    }
}

@end
