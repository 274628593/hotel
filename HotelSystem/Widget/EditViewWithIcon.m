//
//  EditViewWithIcon.m
//  MachineModule
//
//  Created by LHJ on 15/12/11.
//  Copyright © 2015年 LHJ. All rights reserved.
//

#import "EditViewWithIcon.h"
#import "CPublic.h"

@implementation EditViewWithIcon
{
    EditView    *m_editView;
    BOOL        m_bIsLayoutView;
}
@synthesize m_bIsPasswordMode;
@synthesize m_strText;
@synthesize m_txColor;
@synthesize m_txFont;
@synthesize m_imgIcon;
@synthesize m_strPlaceHolder;
@synthesize m_btIsAutoAdjustHeight;
@synthesize m_cornerRadius;
@synthesize m_delegate;
@synthesize m_returnKeyType;
@synthesize m_bIsEditEnable;
@synthesize m_bIsShowBorderLine;
@synthesize m_spaceIconWithText;
@synthesize m_bIsShowKeyboard;
@synthesize m_borderColor;
@synthesize m_borderWidth;
@synthesize m_spaceInsert;
@synthesize m_bIsShowCircelImg;
@synthesize m_bIsInputOnlyNum;
@synthesize m_keyboardType;

// ==============================================================================================
#pragma mark 基类方法
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
    
    if(m_bIsLayoutView == YES) { return;}
    
    m_bIsLayoutView = YES;
    [self initLayoutView];
}
// ==============================================================================================
#pragma mark 内部使用方法
/** 初始化数据 */
- (void) initData
{
    m_bIsShowCircelImg = YES;
    m_spaceInsert = 4.0f;
    m_borderWidth = 1.0f;
    m_borderColor = Color_RGB(150, 150, 150);
    m_bIsShowKeyboard = NO;
    m_returnKeyType = UIReturnKeyDone;
    m_bIsLayoutView = NO;
    m_txFont = Font(16.0f);
    m_txColor = Color_RGB(30, 30, 30);
    m_bIsPasswordMode = NO;
    m_imgIcon = nil;
    m_strPlaceHolder = @"";
    m_btIsAutoAdjustHeight = NO;
    m_cornerRadius = 4.0f;
    m_bIsEditEnable = YES;
    m_bIsShowBorderLine = YES;
    m_spaceIconWithText = 4.0f;
    m_bIsInputOnlyNum = NO;
    m_keyboardType = UIKeyboardTypeDefault;
}
// ==============================================================================================
#pragma mark 外部调用方法
/** 初始化视图，只有调用这个方法之后，才能得到相应的View高度尺寸 */
- (void) initLayoutView
{
    [self setUserInteractionEnabled:YES];
    [self.layer setMasksToBounds:YES];
    if(m_bIsShowBorderLine == YES)
    {
        [self.layer setBorderWidth:m_borderWidth];
        [self.layer setBorderColor:m_borderColor.CGColor];
        [self.layer setCornerRadius:m_cornerRadius];
    }
    
    if(m_btIsAutoAdjustHeight == YES){
        NSString *strTemp = @"高";
        float height = [CPublic getTextHeight:strTemp _font:m_txFont];
        CGRect frame = self.frame;
        frame.size.height = height;
        self.frame = frame;
    }
    
    float x_add = m_spaceInsert;
    float y_add = 0;
    float w_add = 0;
    float h_add = 0;
    if(m_imgIcon != nil){  // ======= 图片 ======
        h_add = (self.bounds.size.height - y_add - m_spaceInsert)*3/4;
        w_add = h_add;
        y_add = (self.bounds.size.height - h_add)/2;
        x_add = self.bounds.origin.x + m_spaceInsert;
        UIImageView *imgView = [UIImageView new];
        [imgView setFrame:CGRectMake(x_add, y_add, w_add, h_add)];
        [imgView setBackgroundColor:Color_Transparent];
        [imgView setUserInteractionEnabled:NO];
        [imgView setContentMode:UIViewContentModeScaleToFill];
        [imgView setClipsToBounds:YES];
        [imgView setImage:m_imgIcon];
        [self addSubview:imgView];
        x_add += (imgView.bounds.size.width );
        if(m_bIsShowCircelImg == YES){
            [imgView.layer setCornerRadius:imgView.bounds.size.width/2];
        }
    }
    x_add += m_spaceIconWithText;
    
    // ====== 输入框 ======
    w_add = self.bounds.size.width - x_add - m_spaceInsert;
    h_add = self.bounds.size.height;
    y_add = self.bounds.origin.y;
    EditView *editView = [EditView new];
    [editView setFrame:CGRectMake(x_add, y_add, w_add, h_add)];
    [editView setUserInteractionEnabled:YES];
    [editView setBackgroundColor:Color_Transparent];
    [editView setIsShowClearBtn:YES];
    [editView setIsPasswordMode:m_bIsPasswordMode];
    [editView setTextFont:m_txFont];
    [editView setIsInputOnlyNum:m_bIsInputOnlyNum];
    [editView setTextColor:m_txColor];
    [editView setTextContent:m_strText];
    [editView setPlaceHolder:m_strPlaceHolder];
    [editView setTag:[self tag]];
    [editView setDelegate:(id)self];
    [editView setIsEditEnable:m_bIsEditEnable];
    [editView setReturnKeyType:m_returnKeyType];
    [editView setIsShowKeyboard:m_bIsShowKeyboard];
    [editView setKeyboardType:m_keyboardType];
    [self addSubview:editView];
    m_editView = editView;
}
- (void) setText:(NSString *)v_strText
{
    m_strText = v_strText;
    if(m_editView != nil){
        [m_editView setTextContent:m_strText];
    }
}
/** 编辑框获取焦点，弹出对话框 */
- (void) requireFirstResponder
{
    m_bIsShowKeyboard = YES;
    [m_editView requireFirstResponder];
}
/** 编辑框获取焦点，弹出对话框 */
- (void) resignFirstResponder
{
    m_bIsShowKeyboard = YES;
    [m_editView resignFirstResponder];
}
- (void) setIsPasswordMode:(BOOL)v_bIsPasswordMode
{
    m_bIsPasswordMode = v_bIsPasswordMode;
    if(m_editView != nil){
        [m_editView setIsPasswordMode:m_bIsPasswordMode];
    }
}
- (NSString*) getText
{
    return [m_editView getTextContent];
}
// ==============================================================================================
#pragma mark -  委托协议EditViewDelegate
/** 确定输入内容之后回调这个方法 */
- (void) commitInput:(NSString*)v_strInputText _sender:(id)v_sender
{
    if(m_delegate != nil){
        BOOL bTemp = [m_delegate respondsToSelector:@selector(commitInput:_editViewWithIcon:)];
        if(bTemp == YES){
            [m_delegate commitInput:[self getText] _editViewWithIcon:(id)self];
        }
    }
}

@end
