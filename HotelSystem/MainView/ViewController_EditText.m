//
//  EditTextViewController.m
//  MachineModule
//
//  Created by LHJ on 15/12/31.
//  Copyright © 2015年 LHJ. All rights reserved.
//

#import "ViewController_EditText.h"
#import "CPublic.h"

#define Font_Text   Font(22.0f)
#define Color_Text  Color_RGB(30, 30, 30)

@implementation ViewController_EditText
{
    EditViewWithIcon    *m_editView;
}
@synthesize m_delegate;
@synthesize m_strTextBegin;
@synthesize m_tag;
@synthesize m_strNavTitle;
@synthesize m_extraObj;
// ==============================================================================================
#pragma mark -  基类方法
- (instancetype) init
{
    self = [super init];
    if(self != nil){
        [self initData];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavView];
}
- (void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [m_editView requireFirstResponder];
}
- (void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [m_editView resignFirstResponder];
}
- (void) viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    [self initLayoutView];
}
// ==============================================================================================
#pragma mark -  内部使用方法
/** 初始化数据 */
- (void) initData
{
    m_strTextBegin = @"";
    m_tag = 0;
    m_strNavTitle = @"";
}
- (void) initNavView
{
    self.navigationItem.title = m_strNavTitle;
    UIBarButtonItem *rightBarBtn = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(clickNavBarButton:)];
    [self.navigationItem setRightBarButtonItem:rightBarBtn animated:YES];
}
/** 初始化视图 */
- (void) initLayoutView
{
    UIView *viewMain = self.view;
    [viewMain setUserInteractionEnabled:YES];
    [viewMain setBackgroundColor:Color_RGB(255, 255, 255)];
    
    const float cornerRadius = 6.0f;
    const float space_x = 16.f;
    const float space_y = 20.0f;
    const float height_tx = [CPublic getTextHeight:@"高" _font:Font_Text];
    
//    float value = self.navigationController.navigationBar.frame.size.height + Height_StatusBar;
    float x_add = viewMain.bounds.origin.x + space_x;
    float w_add = viewMain.bounds.size.width - x_add - space_x;
    float h_add = height_tx + space_y;
    float y_add = viewMain.bounds.origin.y + space_y;
    EditViewWithIcon *editView = [EditViewWithIcon new];
    [editView setFrame:CGRectMake(x_add, y_add, w_add, h_add)];
    [editView setBackgroundColor:Color_RGB(250, 250, 250)];
    [editView setIsPasswordMode:NO];
    [editView setText:m_strTextBegin];
    [editView setCornerRadius:cornerRadius];
    [editView setTxFont:Font_Text];
    [editView setTxColor:Color_Text];
    [editView setDelegate:(id)self];
    [editView setPlaceHolder:@""];
    [editView setIsEditEnable:YES];
    [editView setIsShowBorderLine:YES];
    [editView setSpaceIconWithText:12.0f];
    [editView setUserInteractionEnabled:YES];
    [editView setReturnKeyType:UIReturnKeyDone];
    [editView setBorderColor:Color_RGBA(230, 230, 230, 0.6f)];
    [editView setBorderWidth:0.6f];
    [viewMain addSubview:editView];
    m_editView = editView;
}
/** 确定输入 */
- (void) commitResult
{
    [m_editView resignFirstResponder];
    NSString *strText = [m_editView getText];
    if(strText == nil
       || [strText isEqualToString:@""] == YES){
        [CPublic ShowDialgController:@"输入不能为空" _viewController:self];
        return;
    }
    if(m_delegate != nil){
        BOOL bTemp = [m_delegate respondsToSelector:@selector(getEditTextResult:_tag: _sender:)];
        if(bTemp == YES){
            [m_delegate getEditTextResult:strText _tag:m_tag _sender:self];
        }
    }
}
// ==============================================================================================
#pragma mark -  动作触发事件
/** 导航栏按钮点击事件 */
- (void) clickNavBarButton:(id)v_sender
{
    [self commitResult];
}
// ==============================================================================================
#pragma mark -  委托协议EditViewWithIconDelegate
/** 确定输入内容之后回调这个方法 */
- (void) commitInput:(NSString*)v_strInputText _editViewWithIcon:(EditViewWithIcon*)v_sender
{
//    [self commitResult];
}
@end
