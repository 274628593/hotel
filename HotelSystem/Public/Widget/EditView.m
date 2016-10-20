//
//  EditView.m
//  MyPro
//
//  Created by hancj on 15/11/9.
//  Copyright © 2015年 hancj. All rights reserved.
//

#import "EditView.h"
#import "CPublic.h"

typedef enum : int{
    ClickTag_BG = 1,
    ClickTag_ClearText,
} ClickTag;

@implementation EditView
{
    float       m_fAniTimeDuaShow;
    float       m_fAniTimeDuaHide;
    float       m_fKeyboardHeight;
    BOOL        m_bIsMove;
    float       m_fY_beigin;
    BOOL        m_bIsLayoutView;
    float       m_fHeightTV;
//    UIButton    *m_btnBackground;
//    UIView      *m_viewScreen;
    BOOL        m_bKeyboardShow;
    float       m_fHeightMinTV;
    UIButton    *m_btnClearText;
    CGPoint     m_pointEdit;
//    UIView      *m_viewSuper;
    
    UITextField *m_tf;
    UITextView  *m_tv;
}
@synthesize m_editViewType;
@synthesize m_bIsLayoutWhenSuperCall;
@synthesize m_textColor;
@synthesize m_textFont;
@synthesize m_strPlaceHolder;
@synthesize m_strTextContent;
@synthesize m_placeHolderColor;
@synthesize m_delegate;
@synthesize m_bIsShowClearBtn;
@synthesize m_bIsInputOnlyNum;
@synthesize m_returnKeyType;
@synthesize m_textAlignment;
@synthesize m_bIsEditEnable;
@synthesize m_bIsPasswordMode;
@synthesize m_bIsShowKeyboard;
@synthesize m_keyboardType;

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
    if(m_bIsLayoutWhenSuperCall != YES) { return; }
    
    [self initLayoutView];
}

// ==============================================================================================
#pragma mark 外部调用方法
- (void) setIsPasswordMode:(BOOL)v_bIsPasswordMode
{
    m_bIsPasswordMode = v_bIsPasswordMode;
    if(m_tf != nil){
        [m_tf setSecureTextEntry:m_bIsPasswordMode];
    }
}
/** 外部调用：在初始化说所有必要数据之后，初始化布局View，当开启自动布局时，调用这个函数无效 */
- (void) initLayoutViewAfterInitData
{
    if(m_bIsLayoutWhenSuperCall == YES) { return; }
    
    [self initLayoutView];
}
/** 编辑框获取焦点，弹出对话框 */
- (void) requireFirstResponder
{
    m_bIsShowKeyboard = YES;
    for(UIView *view in [self subviews]){
        if([view isKindOfClass:[UITextView class]] == YES){
            [(UITextView*)view becomeFirstResponder];
            
        } else if([view isKindOfClass:[UITextField class]] == YES){
            [(UITextField*)view becomeFirstResponder];
            
        }
    }
}
/** 编辑框获取焦点，弹出对话框 */
- (void) resignFirstResponder
{
    m_bIsShowKeyboard = YES;
    for(UIView *view in [self subviews]){
        if([view isKindOfClass:[UITextView class]] == YES){
            [(UITextView*)view resignFirstResponder];
            
        } else if([view isKindOfClass:[UITextField class]] == YES){
            [(UITextField*)view resignFirstResponder];
            
        }
    }
}
/** 设置是否可以编辑 */
- (void) setIsEditEnable:(BOOL)v_bIsEditEnable
{
    m_bIsEditEnable = v_bIsEditEnable;
    for(UIView *view in [self subviews]){
        if([view isKindOfClass:[UITextView class]] == YES){
            [(UITextView*)view setEditable:m_bIsEditEnable];
            
        } else if([view isKindOfClass:[UITextField class]] == YES){
            [(UITextField*)view setEnabled:m_bIsEditEnable];
            
        }
    }
}
- (void) setTextContent:(NSString *)v_strTextContent
{
    m_strTextContent = v_strTextContent;
    if(m_tf != nil){
        [m_tf setText:m_strTextContent];
    
    } else if(m_tv != nil){
        [m_tv setText:m_strTextContent];
    }
}
- (NSString*)getTextContent
{
    if(m_tf != nil){
        m_strTextContent = m_tf.text;
    } else {
        m_strTextContent = m_tv.text;
    }
    return m_strTextContent;
}

// ==============================================================================================
#pragma mark 内部使用方法
/** 初始化数据 */
- (void) initData
{
    m_bIsShowKeyboard = NO;
    [self setUserInteractionEnabled:YES];
    m_fAniTimeDuaShow = 0.2f;
    m_fAniTimeDuaHide = 0.6f;
    m_fY_beigin = 0.0f;
    m_fKeyboardHeight = 0.0f;
    m_bIsMove = NO;
    m_bIsShowClearBtn = YES;
    m_bIsPasswordMode = NO;
    m_bIsLayoutWhenSuperCall = YES;
    m_bIsLayoutView = NO;
    m_bIsInputOnlyNum = NO;
    m_textColor = Color_RGB(0, 0, 0);
    m_placeHolderColor = Color_RGB(120, 120, 120);
    m_textFont = Font(16.0f);
    m_editViewType = EditViewType_SinggleRow;
    m_strTextContent = @"";
    m_strPlaceHolder = @"";
    m_textAlignment = NSTextAlignmentLeft;
    m_returnKeyType = UIReturnKeyDone;
    m_bIsEditEnable = YES;
    m_keyboardType = UIKeyboardTypeDefault;
}

/** 初始化布局 */
- (void) initLayoutView
{
    switch(m_editViewType)
    {
        case EditViewType_SinggleRow:{
            [self initLayoutView_EditViewTypeSingleRow];
            break;
        }
        case EditViewType_ManyRows_NoAutoLayout:{
            [self initLayoutView_EditViewTypeManyRows:NO];
            break;
        }
        case EditViewType_ManyRows_AutoLayout:{
            [self initLayoutView_EditViewTypeManyRows:YES];
            break;
        }
    }
}
/** 初始化布局：单行编辑框 */
- (void) initLayoutView_EditViewTypeSingleRow
{
    UITextField *textField = [UITextField new];
    [textField setFrame:self.bounds];
    [textField setFont:m_textFont];
    [textField setDelegate:(id)self];
    [textField setTextColor:m_textColor];
    [textField setText:m_strTextContent];
    [textField setSecureTextEntry:m_bIsPasswordMode];
    [textField setTextAlignment:m_textAlignment];
    [textField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [textField setReturnKeyType:m_returnKeyType];
    [textField setBackgroundColor:Color_Transparent];
    [textField setEnabled:m_bIsEditEnable];
    [textField setAutocorrectionType:UITextAutocorrectionTypeNo];
    [textField setAutocapitalizationType:UITextAutocapitalizationTypeNone];

    textField.inputAccessoryView = [self customAccessoryView];;
    
    if(m_bIsShowKeyboard == YES){
        [textField becomeFirstResponder];
    }
    if(m_returnKeyType == UIReturnKeySearch){
        textField.enablesReturnKeyAutomatically = YES;
    }
    [textField setKeyboardType:m_keyboardType];
    
    NSAttributedString *attribute = [[NSAttributedString alloc] initWithString:m_strPlaceHolder attributes:@{NSForegroundColorAttributeName:m_placeHolderColor}];
    [textField setAttributedPlaceholder:attribute];

    if(m_bIsShowClearBtn == YES){
        [textField setClearButtonMode:UITextFieldViewModeWhileEditing];
    } else {
        [textField setClearButtonMode:UITextFieldViewModeNever];
    }
    
    [self addSubview:textField];
    
    m_tf = textField;
}
/** 初始化布局：多行编辑框 */
- (void) initLayoutView_EditViewTypeManyRows:(BOOL)v_bIsAutoHeight
{
    UITextView *textView = [UITextView new];
    [textView setFrame:self.bounds];
    [textView setDelegate:(id)self];
    [textView setFont:m_textFont];
    [textView setBackgroundColor:Color_Transparent];
    [textView setTextColor:m_textColor];
    [textView setTextAlignment:NSTextAlignmentLeft];
    [textView setText:m_strTextContent];
//    [textView setClearsOnInsertion:YES];
    [textView setReturnKeyType:UIReturnKeyDefault];
    [textView setTag:v_bIsAutoHeight];
    [textView setEditable:m_bIsEditEnable];
    [textView setAutocorrectionType:UITextAutocorrectionTypeNo];
    [textView setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [textView setKeyboardType:m_keyboardType];
    textView.inputAccessoryView = [self customAccessoryView];
    
    [self addSubview:textView];
    if(m_bIsShowKeyboard == YES){
        [textView becomeFirstResponder];
    } else {
        [textView resignFirstResponder];
    }
    
    m_fHeightTV = textView.frame.size.height;
    m_fHeightMinTV = textView.frame.size.height;
    
    [self initClearBtn:textView];
    
    [self handleTextViewContent:textView];
    
    m_tv = textView;
}
- (UIToolbar *)customAccessoryView{
    UIToolbar *customAccessoryView = [[UIToolbar alloc]initWithFrame:(CGRect){0, 0, ScreenSize.width, 44}];
    customAccessoryView.barTintColor = Color_RGB(240, 240, 240);
    UIBarButtonItem *space = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *finish = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(onKeyBoardDown)];
    [customAccessoryView setItems:@[space, space,finish]];
    return customAccessoryView;
}
/** 添加清空按钮 */
- (void) initClearBtn:(UITextView*)v_tv
{
    if(m_bIsShowClearBtn != YES){ return; }
    
    NSString *strTemp = @"高度";
    NSDictionary *dicTemp = @{NSFontAttributeName:m_textFont};
    CGSize size = [strTemp sizeWithAttributes:dicTemp];
    float x_add = v_tv.bounds.size.width - size.width*5/4;
    float y_add = (v_tv.bounds.size.height - size.height)/2;
    float h_add = size.height;
    float w_add = h_add;
    UIButton *btnClear = [UIButton new];
    [btnClear setFrame:CGRectMake(x_add, y_add, w_add, h_add)];
    [btnClear setBackgroundColor:Color_Transparent];
    [btnClear setTag:ClickTag_ClearText];
    [btnClear addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    [btnClear setContentMode:UIViewContentModeScaleToFill];
    [btnClear setAlpha:0.6f];
    [btnClear setImage:GetImg(@"stop_d") forState:UIControlStateNormal];
    [btnClear setHidden:YES];
    [v_tv addSubview:btnClear];
    m_btnClearText = btnClear;
}
/** 添加点击背景：点击就收起键盘 */
//- (void) initBackgoundView
//{
//    if(m_bKeyboardShow == YES) { return; }
//    
//    m_pointEdit = self.frame.origin;
//    m_viewSuper = [self superview];
//    m_viewScreen = [CPublic getScreenView:self];
//    m_btnBackground = [UIButton new];
//    [m_btnBackground setFrame:m_viewScreen.bounds];
//    [m_btnBackground setBackgroundColor:Color_Transparent];
//    [m_btnBackground setTag:ClickTag_BG];
//    [m_btnBackground addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
//    [m_viewScreen addSubview:m_btnBackground];
//    
//    CGPoint pInSrc = [CPublic getRelativePointForScreenView:self];
//    CGRect frame = self.frame;
//    frame.origin = pInSrc;
//    self.frame = frame;
//    [self.layer removeAllAnimations];
//    
//    [m_btnBackground addSubview:self];
//    [m_viewScreen addSubview:m_btnBackground];
//}
///** 移除点击背景 */
//- (void) removeBackgoundView
//{
//    CGRect frame = self.frame;
//    frame.origin = m_pointEdit;
//    self.frame = frame;
//    [self.layer removeAllAnimations];
//    
//    [m_viewSuper addSubview:self];
//    [m_btnBackground removeFromSuperview];
//    if(m_delegate != nil){
//        BOOL bTemp = [m_delegate respondsToSelector:@selector(closeKeyboardEvent:)];
//        if(bTemp == YES){
//            [m_delegate closeKeyboardEvent:(id)self];
//        }
//    }
//}
/** 收起键盘 */
- (void) resignTextView
{
    for(UIView *view in [self subviews]){
        if([view isKindOfClass:[UITextView class]] == YES){
            [(UITextView*)view resignFirstResponder];
            
        } else if([view isKindOfClass:[UITextField class]] == YES){
            [(UITextField*)view resignFirstResponder];
            
        }
    }
}
/** 判断UITextView是否为空 */
- (void) handleTextViewContent:(UITextView*)v_tv
{
    if([[v_tv text] isEqualToString:@""] == YES){
        [v_tv setText:m_strPlaceHolder];
        [v_tv setTextColor:m_placeHolderColor];
   
    } else {
        [v_tv setTextColor:m_textColor];
    }
}

/** 处理键盘高度-显示 */
- (void) handleKeyboard_show
{
//    float fTempY = (m_viewScreen != nil)? m_viewScreen.frame.origin.y : 0;
    float fTemp1 = [CPublic getRelativePointForScreenView:self].y + self.bounds.size.height;
    float fTemp2 = ScreenSize.height - m_fKeyboardHeight;
//    NSLog(@"键盘高度：%f", m_fKeyboardHeight);
    if(m_bIsMove == YES
       || fTemp1 >= fTemp2){
        if([self superview] != NULL) {
            const float fValue = fTemp1 - fTemp2;
            UIView *view  = [CPublic getScreenView:self];
            if(m_bIsMove != YES){
                m_fY_beigin = view.frame.origin.y;
            }
            [UIView animateWithDuration:m_fAniTimeDuaShow animations:^{
                CGRect frame = view.frame;
                frame.origin.y -= fValue;
                view.frame = frame;
            }];
            m_bIsMove = YES;
        }
    }
}
/** 处理键盘高度-隐藏 */
- (void) handleKeyboard_hide
{
    if(m_bIsMove == YES){
        [UIView animateWithDuration:m_fAniTimeDuaHide animations:^{
            UIView *view  = [CPublic getScreenView:self];
//            UIView *view = m_viewScreen;
            CGRect frame = view.frame;
            frame.origin.y = m_fY_beigin;
            view.frame = frame;
        } completion:^(BOOL v_bIs){
            m_bIsMove = NO;
        }];
    }
}
/** 判断是否只包含数字 */
- (BOOL)validateNumber:(NSString*)number
{
    if(m_bIsInputOnlyNum == NO) { return YES; }
    
    BOOL res = YES;
    NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789."];
    int i = 0;
    while (i < number.length) {
        NSString * string = [number substringWithRange:NSMakeRange(i, 1)];
        NSRange range = [string rangeOfCharacterFromSet:tmpSet];
        if (range.length == 0) {
            res = NO;
            break;
        }
        i++;
    }
    return res;
}

// ==============================================================================================
#pragma mark 动作触发方法
/** 点击按钮方法 */
- (void) clickBtn:(id)v_sender
{
    UIView *view = (UIView*)v_sender;
    switch((ClickTag)view.tag)
    {
        case ClickTag_BG:{ // 点击背景
            [self resignTextView];
            break;
        }
        case ClickTag_ClearText:{ // 清空文本
            for(UIView *view in [self subviews]){
                if([view isKindOfClass:[UITextView class]] == YES){
                    [(UITextView*)view setText:@""];
                }
            }
            break;
        }
    }
}
- (void) onKeyBoardDown
{
    if(m_delegate != nil){
        BOOL bTemp = [m_delegate respondsToSelector:@selector(closeKeyboardEvent:)];
        if(bTemp == YES){
            [m_delegate closeKeyboardEvent:(id)self];
        }
    }
    [self resignTextView];
}
/** 键盘弹出触发事件 */
- (void) keyboardShow:(NSNotification*)v_notification
{
    m_fKeyboardHeight = [CPublic getKeyboardHeight];
//    [self initBackgoundView];
    [self handleKeyboard_show];
    m_bKeyboardShow = YES;
}
/** 键盘隐藏触发事件 */
- (void) keyboardHide:(NSNotification*)v_notification
{
    m_bKeyboardShow = NO;
    
    [self handleKeyboard_hide];
//    [self removeBackgoundView];
    
    if(m_delegate != nil){
        BOOL bTemp = [m_delegate respondsToSelector:@selector(commitInput:_sender:)];
        if(bTemp == YES){
            [m_delegate commitInput:[self getTextContent] _sender:(id)self];
        }
    }
}
// ==============================================================================================
#pragma mark 委托实现UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    m_strTextContent = textField.text;
    [self keyboardHide:nil];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(m_delegate != nil){
        BOOL bTemp = [m_delegate respondsToSelector:@selector(gotoNextEditView: _returnKeyType:)];
        if(bTemp == YES){
            [m_delegate gotoNextEditView:self _returnKeyType:[textField returnKeyType]];
        }
    }
    [textField resignFirstResponder];
    return NO;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    return [self validateNumber:string];
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self keyboardShow:nil];
}

// ==============================================================================================
#pragma mark 委托实现UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)v_textView
{
    if(m_bIsShowClearBtn == YES
       && m_btnClearText != nil
       && [m_btnClearText isHidden] == YES){
        [m_btnClearText setHidden:NO];
    }
    
    if([v_textView.text isEqualToString:m_strPlaceHolder] == YES){
        v_textView.text = @"";
        [v_textView setTextColor:m_textColor];
    }
    [self keyboardShow:nil];
    return YES;
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    [self keyboardHide:nil];
}
- (BOOL)textViewShouldEndEditing:(UITextView *)v_textView
{
    if(m_bIsShowClearBtn == YES
       && m_btnClearText != nil
       && [m_btnClearText isHidden] != YES){
        [m_btnClearText setHidden:YES];
    }
    
    m_strTextContent = v_textView.text;
    if([v_textView.text isEqualToString:@""] == YES){
        v_textView.text = m_strPlaceHolder;
        v_textView.textColor = m_placeHolderColor;
    }
    
    return YES;
}
- (void)textViewDidChange:(UITextView *)v_textView
{
    if(v_textView.tag != 0){ // 自动变换高度
        float width = v_textView.contentSize.width;
        CGSize size = [v_textView sizeThatFits:CGSizeMake(width, CGFLOAT_MAX)];
        if(size.height < m_fHeightMinTV
           && m_fHeightTV <= m_fHeightMinTV){
            return;
        }
        
        if(size.height != m_fHeightTV){
            m_fHeightTV =(size.height >= m_fHeightMinTV)? size.height : m_fHeightMinTV;
            
            CGRect frameTV = v_textView.frame;
            frameTV.size.height = m_fHeightTV;
            v_textView.frame = frameTV;
            
            CGRect frame = self.frame;
            frame.size.height = m_fHeightTV;
            self.frame = frame;
            [self handleKeyboard_show];
            if(m_delegate != nil){
                BOOL bTemp = [m_delegate respondsToSelector:@selector(changeViewFrame:)];
                if(bTemp == YES){
                    [m_delegate changeViewFrame:self];
                }
            }
        }
    }
}


@end
