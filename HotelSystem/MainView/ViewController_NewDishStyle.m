//
//  ViewController_NewDishStyle.m
//  HotelSystem
//
//  Created by LHJ on 16/3/19.
//  Copyright © 2016年 hancj. All rights reserved.
//

#import "ViewController_NewDishStyle.h"
#import "CPublic.h"
#import "DishStyleNameItem.h"
#import "ImgFileManager.h"
#import "DishStyleItem.h"
#import "DropSelectView.h"

#define Font_Text   Font(22)
#define Color_Text  Color_RGB(250, 250, 250)

typedef enum : int{
    ViewTag_Commit = 1, /* 确定按钮 */
    ViewTag_BtnIcon, /* 头像按钮，点击切换图片 */
    ViewTag_DropList, /* 下拉列表Tag */
}ViewTag;

@implementation ViewController_NewDishStyle
{
    UIButton            *m_btnImgIcon;
    DropSelectView      *m_dropSelectView;
    NSString            *m_strDishStyleName;
    NSString            *m_strDishStyleID;
    NSString            *m_strImgFilePath;
    DishStyleItem       *m_dishStyleItemForEdit;
    BOOL                m_bIsEditEnable; // 是否是正在编辑菜系。
}
@synthesize m_delegate;

// ==================================================================================
#pragma mark - 父类方法
- (instancetype) init
{
    self = [super init];
    if(self != nil){
        [self initData];
    }
    return self;
}
- (void) viewDidLoad{
    [super viewDidLoad];
    [self initNavView];
    [self initMainView];
}
- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
- (void) viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    [self addAllViewToViewController];
}
// ==================================================================================
#pragma mark - 内部调用方法
/** 初始化导航栏 */
- (void) initNavView
{
    self.navigationItem.title = @"新建菜系";
    UIBarButtonItem *barBtnItem = [[UIBarButtonItem alloc]initWithTitle:@"确定"
                                                                  style:UIBarButtonItemStyleDone
                                                                 target:self
                                                                 action:@selector(clickBtn:)];
    [barBtnItem setTag:ViewTag_Commit];
    self.navigationItem.rightBarButtonItem = barBtnItem;
}
/** 初始化数据 */
- (void) initData
{
    m_bIsEditEnable = NO;
}
/** 初始化所有视图View */
- (void) initMainView
{
    if(m_btnImgIcon == nil){
        UIButton *btnImg = [UIButton new];
        [btnImg setBackgroundColor:Color_RGBA(200, 200, 200, 0.6f)];
        [btnImg setClipsToBounds:YES];
        [btnImg setTag:ViewTag_BtnIcon];
        [btnImg addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        m_btnImgIcon = btnImg;
    }
    
    if(m_dropSelectView == nil){
        DropSelectView *dropSelectView = [DropSelectView new];
        [dropSelectView setSelectName:@""];
        [dropSelectView setTextColor:Color_Text];
        [dropSelectView setTextFont:Font_Text];
        [dropSelectView setTag:ViewTag_DropList];
        [dropSelectView setClipsToBounds:YES];
        [dropSelectView setBackgroundColor:Color_RGBA(200, 200, 200, 0.6f)];
        [dropSelectView addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        m_dropSelectView = dropSelectView;
    }
    
    if(m_bIsEditEnable == YES
       && m_dishStyleItemForEdit != nil){
        if(m_btnImgIcon != nil){
            NSString *strImgPath = [CPublic getLocalAbsolutePathOfRelativePath:[m_dishStyleItemForEdit getDishStyleIconImgPath]];
            [m_btnImgIcon setBackgroundImage:[UIImage imageWithContentsOfFile:strImgPath] forState:UIControlStateNormal];
        }
        
        if(m_dropSelectView != nil){
            [m_dropSelectView setSelectName:[m_dishStyleItemForEdit getDishStyleName]];
        }
    }
}
/** 将所有View添加到控制中显示 */
- (void) addAllViewToViewController
{
    UIView *viewMain = self.view;
    [viewMain setBackgroundColor:[UIColor whiteColor]];
    
    float value = self.navigationController.navigationBar.frame.size.height + Height_StatusBar;
    float w_add = 400;
    float h_add = 400;
    float x_add = (viewMain.bounds.size.width - w_add)/2;
    float y_add = value + 10;
    [m_btnImgIcon setFrame:CGRectMake(x_add, y_add, w_add, h_add)];
    [viewMain addSubview:m_btnImgIcon];
    
    const float space_y = 20;
    y_add += m_btnImgIcon.frame.size.height;
    y_add += space_y;
    [m_dropSelectView setFrame:CGRectMake(x_add, y_add, w_add, h_add)];
    [viewMain addSubview:m_dropSelectView];
}
/** 确定新建菜系 */
- (void) commitNewDishStyle
{
    if(m_delegate != nil){
        BOOL bTemp = [m_delegate respondsToSelector:@selector(commitAddNewDishStyleWithID:_name:_iconFilePath:)];
        if(bTemp == YES){
            [m_delegate commitAddNewDishStyleWithID:m_strDishStyleID
                                              _name:m_strDishStyleName
                                        _iconFilePath:m_strImgFilePath];
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}
/** 确定编辑菜系 */
- (void) commitEditDishStyle
{
    if(m_delegate != nil){
        BOOL bTemp = [m_delegate respondsToSelector:@selector(commitEditDishStyleWithDishStyleID:_newName:_newIconFilePath:)];
        if(bTemp == YES){
            [m_delegate commitEditDishStyleWithDishStyleID:[m_dishStyleItemForEdit getDishStyleID]
                                                  _newName:m_strDishStyleName
                                          _newIconFilePath:m_strImgFilePath];
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}
// ==================================================================================
#pragma mark - 外部调用方法
/** 设置选择的菜系名 */
- (void) setNameOfDishStyleWithItem:(DishStyleNameItem*)v_item
{
    m_strDishStyleName = [v_item getDishStyleNameItemName];
    m_strDishStyleID = [v_item getDishStyleNameItemID];
    [m_dropSelectView setSelectName:m_strDishStyleName];
}
/** 设置需要编辑的菜系，在打开这个界面之后设置 */
- (void) setDishStyleItemForEdit:(DishStyleItem*)v_dishStyleItem
{
    m_dishStyleItemForEdit = v_dishStyleItem;
    m_bIsEditEnable = YES;
    m_strDishStyleName = [m_dishStyleItemForEdit getDishStyleName];
    m_strImgFilePath = [m_dishStyleItemForEdit getDishStyleIconImgPath];
}
// ==================================================================================
#pragma mark - 动作触发方法
/** Button按钮点击事件 */
- (void) clickBtn:(id)v_sender
{
    UIView *view = (UIView*)v_sender;
    switch((ViewTag)view.tag){
        case ViewTag_Commit:{ // 确定按钮
            if(m_bIsEditEnable == YES){ // 编辑
                [self commitEditDishStyle];
            } else { // 添加
                [self commitNewDishStyle];
            }
            
            break;
        }
        case ViewTag_BtnIcon:{ // 切换图片
            [GetPhoto openViewWithSelectPhoto:self];
            break;
        }
        case ViewTag_DropList:{ // 下拉选择菜系名
            if(m_delegate != nil){
                BOOL bTemp = [m_delegate respondsToSelector:@selector(openSelectDropView:)];
                if(bTemp == YES){
                    [m_delegate openSelectDropView:self];
                }
            }
            break;
        }
        default:{
            break;
        }
    }
}
// ==============================================================================================
#pragma mark -  委托协议GetPhotoDelegate
/** 获取选择的照片数据 */
- (void) getImgData:(NSData*)v_dataImg _sender:(id)v_sender
{
    ImgFileManager *imgFileManagerObj = [ImgFileManager sharedImgFileManagerObj];
    NSString *strFilePath = [imgFileManagerObj saveImgDataToLocal:v_dataImg];
    m_strImgFilePath = strFilePath;
    UIImage *img = [UIImage imageWithData:v_dataImg];
    [m_btnImgIcon setBackgroundImage:img forState:UIControlStateNormal];
}
@end
