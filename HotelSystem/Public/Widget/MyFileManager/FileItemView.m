//
//  FileItemView.m
//  MachineModule
//
//  Created by LHJ on 15/12/21.
//  Copyright © 2015年 LHJ. All rights reserved.
//

#import "FileItemView.h"
#import "CPublic.h"

#define CornerRadius    4.0f

typedef enum : int{
    ViewTag_ImgViewSelected = 10, /* 选中的图片View */
    ViewTag_ImgViewIcon, /* 列表图标 */
    ViewTag_LabName, /* 列表名称 */
    ViewTag_LabDescription, /* 列表描述 */
    
} ViewTag;

@implementation FileItemView
{
    BOOL            m_bIsLayoutView;
}
@synthesize m_strName;
@synthesize m_strDescription;
@synthesize m_bIsSelected;
@synthesize m_descriptionFont;
@synthesize m_img;
@synthesize m_nameFont;
@synthesize m_nameTxColor;
@synthesize m_descriptionTxColor;
@synthesize m_fileItem;

// ==============================================================================================
#pragma mark 基类继承方法
- (instancetype) initWithFrame:(CGRect)v_frame
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
    
    [self initLayoutView];
}

// ==============================================================================================
#pragma mark 内部使用方法
/** 初始化数据 */
- (void) initData
{
    m_nameFont = Font(16.0f);
    m_descriptionFont = Font(14.0f);
    m_descriptionTxColor = Color_RGB(120, 120, 120);
    m_nameTxColor = Color_RGB(30, 30, 30);
    m_strName = @"";
    m_strDescription = @"";
    m_bIsSelected = NO;
    m_img = nil;
}
/** 初始化视图 */
- (void) initLayoutView
{
    m_bIsLayoutView = YES;
    
    [self setClipsToBounds:YES];
    [self.layer setCornerRadius:CornerRadius];
//    [self.layer setBorderWidth:0.5f];
//    [self.layer setBorderColor:Color_RGBA(150, 150, 150, 0.4f).CGColor];
    
    // ====== 重新计算高度 ======
    const float space_x = 10;
    const float space_y = 10;
    const float space_insert = space_y/2;
    static NSString *strTemp = @"高";
    const float h_name = [CPublic getTextHeightWithLabelSizeToFit:strTemp _font:m_nameFont];
    const float h_description = [CPublic getTextHeightWithLabelSizeToFit:strTemp _font:m_descriptionFont];
    const float h_view = space_y + h_name + space_insert + h_description + space_y;
    CGRect frame = self.frame;
    frame.size.height = h_view;
    self.frame = frame;
    
    // ====== 是否选中的标志 ======
    float x_add = 0;
    float y_add = 0;
    float w_add = space_x*22/10;
    float h_add = w_add;
    UIImageView *imgViewSelected = [UIImageView new];
    [imgViewSelected setFrame:CGRectMake(x_add, y_add, w_add, h_add)];
    [imgViewSelected setBackgroundColor:Color_Transparent];
    [imgViewSelected setImage:GetImg(@"iconfont_selected")];
    [imgViewSelected setContentMode:UIViewContentModeScaleToFill];
    [imgViewSelected setUserInteractionEnabled:NO];
    [imgViewSelected setClipsToBounds:YES];
    [imgViewSelected setTag:ViewTag_ImgViewSelected];
    [imgViewSelected setHidden:!m_bIsSelected];
    [self addSubview:imgViewSelected];
    
    // ======= 图片 =======
    x_add = space_x;
    y_add = space_y;
    h_add = (int)(self.bounds.size.height - y_add - space_y);
    w_add = (int)h_add;
    m_img = (m_img!=nil)? m_img : GetImg(@"iconfont_wendang");
    UIImageView *imgViewIcon = [UIImageView new];
    [imgViewIcon setFrame:CGRectMake(x_add, y_add, w_add, h_add)];
    [imgViewIcon setBackgroundColor:Color_Transparent];
    [imgViewIcon setImage:m_img];
    [imgViewIcon setContentMode:UIViewContentModeScaleToFill];
    [imgViewIcon setUserInteractionEnabled:NO];
    [imgViewIcon setClipsToBounds:YES];
    [imgViewIcon setTag:ViewTag_ImgViewIcon];
    [imgViewIcon.layer setCornerRadius:CornerRadius];
    [self addSubview:imgViewIcon];
    x_add += imgViewIcon.frame.size.width + space_x;
    [self bringSubviewToFront:imgViewSelected];
    
    // ====== 名字 ======
    y_add = imgViewIcon.frame.origin.y;
    w_add = self.bounds.size.width - space_x - x_add;
    h_add = h_name;
    UILabel *labName = [UILabel new];
    [labName setFrame:CGRectMake(x_add, y_add, w_add, h_add)];
    [labName setBackgroundColor:Color_Transparent];
    [labName setUserInteractionEnabled:NO];
    [labName setFont:m_nameFont];
    [labName setText:m_strName];
    [labName setTextAlignment:NSTextAlignmentLeft];
    [labName setTextColor:m_nameTxColor];
    [labName setNumberOfLines:1];
    [labName setLineBreakMode:NSLineBreakByTruncatingTail];
    [labName setTag:ViewTag_LabName];
    [self addSubview:labName];
    y_add += (labName.bounds.size.height + space_insert);
    
    // ======= 描述 ======
    h_add = h_description;
    UILabel *labDescription = [UILabel new];
    [labDescription setFrame:CGRectMake(x_add, y_add, w_add, h_add)];
    [labDescription setBackgroundColor:Color_Transparent];
    [labDescription setUserInteractionEnabled:NO];
    [labDescription setFont:m_descriptionFont];
    [labDescription setText:m_strDescription];
    [labDescription setTextAlignment:NSTextAlignmentLeft];
    [labDescription setTextColor:m_descriptionTxColor];
    [labDescription setNumberOfLines:1];
    [labDescription setLineBreakMode:NSLineBreakByTruncatingTail];
    [labDescription setTag:ViewTag_LabDescription];
    [self addSubview:labDescription];
    
    // ======= 横线 ======
    x_add = imgViewIcon.frame.origin.x + imgViewIcon.bounds.size.width;
    h_add = 1.0f;
    w_add = self.bounds.size.width - x_add - space_x;
    y_add = self.bounds.size.height - h_add;
    UIView *viewLine = [UIView new];
    [viewLine setFrame:CGRectMake(x_add, y_add, w_add, h_add)];
    [viewLine setBackgroundColor:Color_RGBA(120, 120, 120, 0.4f)];
    [viewLine setUserInteractionEnabled:NO];
    [self addSubview:viewLine];
}

// ==============================================================================================
#pragma mark 外部使用方法
/** 设置是否选中 */
- (void) setIsSelected:(BOOL)v_bIsSelected
{
    m_bIsSelected = v_bIsSelected;
    UIImageView *imgView = [self viewWithTag:ViewTag_ImgViewSelected];
    if(imgView != nil){
        [imgView setHidden:!m_bIsSelected];
    }
    [[imgView superview] bringSubviewToFront:imgView];
}
/** 设置图标 */
- (void) setImg:(UIImage *)v_img
{
    m_img = v_img;
    UIImageView *imgView = [self viewWithTag:ViewTag_ImgViewIcon];
    if(imgView != nil){
        [imgView setImage:m_img];
    }
}
/** 设置名称 */
- (void) setName:(NSString *)v_strName
{
    m_strName = v_strName;
    UILabel *lab = [self viewWithTag:ViewTag_LabName];
    if(lab != nil){
        [lab setText:m_strName];
    }
}
/** 设置描述 */
- (void) setDescription:(NSString*)v_strDescription
{
    m_strDescription = v_strDescription;
    UILabel *lab = [self viewWithTag:ViewTag_LabDescription];
    if(lab != nil){
        [lab setText:m_strDescription];
    }
}
@end
