//
//  DropSelectView.m
//  HotelSystem
//
//  Created by LHJ on 16/3/21.
//  Copyright © 2016年 hancj. All rights reserved.
//

#import "DropSelectView.h"
#import "CPublic.h"

@implementation DropSelectView
{
    UILabel     *m_labTitle;
    UIImageView *m_imgViewIcon;
}
@synthesize m_strSelectName;
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
    m_strSelectName = @"";
    m_textFont = Font(22);
    m_textColor = Color_RGB(30, 30, 30);
}
- (void) layoutSubviews
{
    [super layoutSubviews];
    
    if(m_labTitle == nil){
        UILabel *lab = [UILabel new];
        [lab setBackgroundColor:Color_Transparent];
        [lab setNumberOfLines:1];
        [lab setFont:m_textFont];
        [lab setTextAlignment:NSTextAlignmentLeft];
        [lab setTextColor:m_textColor];
        [lab setLineBreakMode:NSLineBreakByTruncatingTail];
        m_labTitle = lab;
        lab = nil;
    }
    
    if(m_imgViewIcon == nil){
        UIImageView *imgView = [UIImageView new];
        [imgView setBackgroundColor:Color_Transparent];
        [imgView setContentMode:UIViewContentModeScaleToFill];
        [imgView setImage:GetImg(@"friendlist_rightarrow")];
        m_imgViewIcon = imgView;
        imgView = nil;
    }
    const float space_x = 20;
    float h_add = self.bounds.size.height/3;
    float w_add = h_add;
    float y_add = (self.bounds.size.height - h_add)/2;
    float x_add = self.bounds.size.width - space_x - w_add;
    [m_imgViewIcon setFrame:CGRectMake(x_add, y_add, w_add, h_add)];
    [self addSubview:m_imgViewIcon];
    
    x_add = space_x;
    y_add = 0;
    w_add = m_imgViewIcon.frame.origin.x - space_x - x_add;
    h_add = self.bounds.size.height;
    [m_labTitle setFrame:CGRectMake(x_add, y_add, w_add, h_add)];
    [m_labTitle setText:m_strSelectName];
    [self addSubview:m_labTitle];
}
- (void) setSelectName:(NSString *)v_strSelectName
{
    m_strSelectName = v_strSelectName;
    if(m_labTitle != nil){
        [m_labTitle setText:m_strSelectName];
    }
}

@end
