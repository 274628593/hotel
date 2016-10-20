//
//  BtnForRecommend.m
//  HotelSystem
//
//  Created by LHJ on 16/3/23.
//  Copyright © 2016年 hancj. All rights reserved.
//

#import "BtnForAllDish.h"
#import "CPublic.h"

@implementation BtnForAllDish
{
    UILabel     *m_labTitle;
    UIImageView *m_imgViewIcon;
}
@synthesize m_textColor;
@synthesize m_textFont;

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
    
}
- (void) layoutSubviews
{
    [super layoutSubviews];

    // ====== 右边图标 ======
    if(m_imgViewIcon == nil){
        m_imgViewIcon = [UIImageView new];
        [m_imgViewIcon setBackgroundColor:Color_Transparent];
        [m_imgViewIcon setContentMode:UIViewContentModeScaleToFill];
        [m_imgViewIcon setImage:GetImg(@"friendlist_rightarrow")];
    }
    const float space_x = 20;
    float h_add = self.bounds.size.height/2;
    float w_add = h_add;
    float y_add = (self.bounds.size.height-h_add)/2;
    float x_add = self.bounds.size.width - space_x - w_add;
    [m_imgViewIcon setFrame:CGRectMake(x_add, y_add, w_add, h_add)];
    [self addSubview:m_imgViewIcon];
    
    // ====== 标题 ======
    if(m_labTitle == nil){
        m_labTitle = [UILabel new];
        [m_labTitle setBackgroundColor:Color_Transparent];
        [m_labTitle setText:@"全部菜单"];
        [m_labTitle setTextAlignment:NSTextAlignmentLeft];
        [m_labTitle setTextColor:m_textColor];
        [m_labTitle setNumberOfLines:1];
        [m_labTitle setFont:m_textFont];
    }
    x_add = space_x;
    y_add = 0;
    w_add = m_imgViewIcon.frame.origin.x - space_x - x_add;
    h_add = self.bounds.size.height;
    [m_labTitle setFrame:CGRectMake(x_add, y_add, w_add, h_add)];
    [self addSubview:m_labTitle];
}
@end
