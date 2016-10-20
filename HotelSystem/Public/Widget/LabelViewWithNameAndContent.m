//
//  LabelWithNameAndContent.m
//  MachineModule
//
//  Created by LHJ on 15/12/15.
//  Copyright © 2015年 LHJ. All rights reserved.
//

#import "LabelViewWithNameAndContent.h"
#import "CPublic.h"

@implementation LabelViewWithNameAndContent
{
    BOOL        m_bIsLayoutView;
    UILabel     *m_labContent;
}
@synthesize m_contentColor;
@synthesize m_nameColor;
@synthesize m_numOfNameWidth;
@synthesize m_textFont;
@synthesize m_strContent;
@synthesize m_strName;
@synthesize m_img;
@synthesize m_bIsShowRightArrow;
@synthesize m_bIsShowLine;
@synthesize m_bIsShowSmallImg;
@synthesize m_spaceXInsert;
@synthesize m_textAlignmentOfLeftLab;
@synthesize m_numOfStar;
@synthesize m_titalNumOfStar;
@synthesize m_rightContentType;

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
/** 向右箭头 */
- (UIView*) getRightArrow:(CGRect)v_frame
{
    UIImageView *imgView_right = [UIImageView new];
    [imgView_right setFrame:v_frame];
    [imgView_right setBackgroundColor:Color_Transparent];
    [imgView_right setContentMode:UIViewContentModeScaleToFill];
    [imgView_right setUserInteractionEnabled:NO];
    [imgView_right setClipsToBounds:YES];
    [imgView_right setImage:GetImg(@"friendlist_rightarrow")];
    return imgView_right;
}
/** 初始化数据 */
- (void) initData
{
    m_rightContentType = RightContentType_Text;
    m_textAlignmentOfLeftLab = NSTextAlignmentLeft;
    m_spaceXInsert = 6.0f;
    m_bIsShowSmallImg = NO;
    m_bIsShowLine = NO;
    m_contentColor = Color_RGB(120, 120, 120);
    m_nameColor = Color_RGB(30, 30, 30);
    m_numOfNameWidth = 4;
    m_textFont = Font(16.0f);
    m_strContent = nil;
    m_strName = @"";
    m_bIsLayoutView = NO;
    m_img = nil;
    m_bIsShowRightArrow = NO;
}
/** 初始化布局 */
- (void) initLayoutView
{
    NSString *strTemp = [self getTextWithNum:m_numOfNameWidth];
    CGSize sizeFont = [CPublic getTextSize:strTemp _font:m_textFont];
    float width = sizeFont.width;
    float x_add = 0.0f;
    float y_add = 0.0f;
    float w_add = width;
    float h_add = self.bounds.size.height;
    const float space_x = m_spaceXInsert;
    
    // ====== 左侧图片 ======
    if(m_img != nil){
        h_add = sizeFont.height;
        h_add = (m_bIsShowSmallImg == YES)? h_add/2 : h_add;
        w_add = h_add;
        y_add = (self.bounds.size.height - h_add)/2;
        UIImageView *imgView = [UIImageView new];
        [imgView setFrame:CGRectMake(x_add, y_add, w_add, h_add)];
        [imgView setBackgroundColor:Color_Transparent];
        [imgView setContentMode:UIViewContentModeScaleToFill];
        [imgView setImage:m_img];
        [self addSubview:imgView];
        x_add += (imgView.bounds.size.width + space_x);
    }
    
    // ====== 左侧名字 ======
    y_add = 0.0f;
    w_add = width;
    h_add = self.bounds.size.height;
    UILabel *labName = [UILabel new];
    [labName setFrame:CGRectMake(x_add, y_add, w_add, h_add)];
    [labName setBackgroundColor:Color_Transparent];
    [labName setFont:m_textFont];
    [labName setTextColor:m_nameColor];
    [labName setTextAlignment:m_textAlignmentOfLeftLab];
    [labName setNumberOfLines:1];
    [labName setLineBreakMode:NSLineBreakByTruncatingTail];
    [labName setText:m_strName];
    [labName setUserInteractionEnabled:NO];
    [self addSubview:labName];
    float space_textInsert = space_x;
    
    if(m_numOfNameWidth == 0){
        [labName sizeToFit];
        CGRect frame = labName.frame;
        frame.size.height = h_add;
        labName.frame = frame;
        space_textInsert = 0.0f;
    }
    
    if(m_bIsShowLine == YES){
        float h_line = 1.0f;
        float x_line = labName.frame.origin.x;
        float w_line = self.bounds.size.width - x_add;
        float y_line = self.bounds.size.height - h_line;
        UIView *viewLine = [self getLineView:CGRectMake(x_line, y_line, w_line, h_line)];
        [self addSubview:viewLine];
    }
    
    // ====== 右侧名字 ======
    if(m_bIsShowRightArrow == YES){ // 显示向右的箭头图片
        h_add = sizeFont.height*5/10;
        w_add = h_add*8/10;
        x_add = self.bounds.size.width - w_add;
        y_add = (self.bounds.size.height - h_add)/2;
        UIView *viewRight = [self getRightArrow:CGRectMake(x_add, y_add, w_add, h_add)];
        [self addSubview:viewRight];
        
        // ---- 右侧文字 ----
        x_add = labName.frame.origin.x + labName.frame.size.width + space_textInsert;
        y_add = 0.0f;
        w_add = viewRight.frame.origin.x - space_x/2 - x_add;
        h_add = self.bounds.size.height;
    
    } else { // ---- 右侧文字 ----
        x_add = labName.frame.origin.x + labName.frame.size.width + space_textInsert;
        y_add = 0.0f;
        w_add = self.bounds.size.width - x_add;
        h_add = self.bounds.size.height;
    }
    
    if(m_rightContentType == RightContentType_Text){
        if(m_strContent != nil){
            UILabel *labContent = [UILabel new];
            [labContent setFrame:CGRectMake(x_add, y_add, w_add, h_add)];
            [labContent setBackgroundColor:Color_Transparent];
            [labContent setFont:m_textFont];
            [labContent setTextColor:m_contentColor];
            [labContent setTextAlignment:NSTextAlignmentLeft];
            [labContent setNumberOfLines:1];
            [labContent setLineBreakMode:NSLineBreakByTruncatingTail];
            [labContent setText:m_strContent];
            [labContent setUserInteractionEnabled:NO];
            [self addSubview:labContent];
            m_labContent = labContent;
        }
    
    } else {
        UIView *viewStar = [self getStarView:CGRectMake(x_add, y_add, w_add, h_add)
                                  _numOfStar:m_numOfStar
                             _titalNumOfStar:m_titalNumOfStar];
        [self addSubview:viewStar];
    }
}
/** 获取评论星星的View */
- (UIView*) getStarView:(CGRect)v_frame
             _numOfStar:(int)v_numOfStar
        _titalNumOfStar:(int)v_titalNumOfStar
{
    UIView *viewRS = [UIView new];
    [viewRS setFrame:v_frame];
    [viewRS setBackgroundColor:Color_Transparent];
    [viewRS setUserInteractionEnabled:YES];
    
    float h_add = [CPublic getTextSizeWithLabelSizeToFit:@"高" _font:m_textFont].height;
    float w_add = h_add;
    float x_add = 0.0f;
    float y_add = (viewRS.bounds.size.height - h_add)/2 - 3;
    UIImageView *imgViewStar = nil;
    for(int i=0; i<v_titalNumOfStar; i+=1){
        imgViewStar = [UIImageView new];
        [imgViewStar setFrame:CGRectMake(x_add, y_add, w_add, h_add)];
        [imgViewStar setUserInteractionEnabled:NO];
        [imgViewStar setContentMode:UIViewContentModeScaleToFill];
        [imgViewStar setBackgroundColor:Color_Transparent];
        if(i<v_numOfStar){
            [imgViewStar setImage:GetImg(@"devicelist_health_1")];
        } else {
            [imgViewStar setImage:GetImg(@"devicelist_health_2")];
        }
        [viewRS addSubview:imgViewStar];
        x_add += imgViewStar.frame.size.width;
    }
    return viewRS;
}

/** 根据数字返回多少个字 */
- (NSString*) getTextWithNum:(int)v_num
{
    NSMutableString *muStrRS = [NSMutableString stringWithString:@""];
    for(int i=0; i<v_num; i+=1){
        [muStrRS appendString:@"宽"];
    }
    return muStrRS;
}
/** 返回线条View */
- (UIView*) getLineView:(CGRect)v_frame
{
    UIView *viewRS = [UIView new];
    [viewRS setFrame:v_frame];
    [viewRS setBackgroundColor:Color_RGBA(230, 230, 230, 0.8f)];
    [viewRS setUserInteractionEnabled:NO];
    return viewRS;
}
// ==============================================================================================
#pragma mark 内部使用方法
- (void) setContent:(NSString *)v_strContent
{
    m_strContent = v_strContent;
    if(m_labContent != nil){
        [m_labContent setText:m_strContent];
    }
}

@end
