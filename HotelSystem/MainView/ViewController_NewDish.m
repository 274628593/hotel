//
//  ViewController_NewDish.m
//  HotelSystem
//
//  Created by LHJ on 16/3/25.
//  Copyright © 2016年 hancj. All rights reserved.
//

#import "ViewController_NewDish.h"
#import "CPublic.h"
#import "DishItem.h"
#import "DishStyleNameItem.h"
#import "ImgFileManager.h"
#import "DropSelectView.h"

#define Font_Text   Font(26)
#define Color_Text  Color_RGB(30, 30, 30)

typedef enum : int{
    ViewTag_Commit = 1, /* 确定按钮 */
    ViewTag_BtnIcon, /* 头像按钮，点击切换图片 */
    ViewTag_DropList, /* 下拉列表Tag */
    ViewTag_EditViewDishName,
    ViewTag_EditViewDishPrice,
    ViewTag_EditViewDishDescription,
    ViewTag_Recommend, /* 推荐 */
    ViewTag_Delete, /* 删除 */
}ViewTag;

@implementation ViewController_NewDish
{
    BOOL                m_bIsEditMode;
    DishItem            *m_dishItem;
    NSString            *m_strNavTitle;
    
    DropSelectView      *m_dropSelectView;
    UIButton            *m_btnImgIcon;
    EditView            *m_editViewDishName;
    EditView            *m_editViewDishPrice;
    EditView            *m_editViewDishDescrition;
    UIButton            *m_btnDelete;
    UIButton            *m_btnIsRecommend;
    UIScrollView        *m_scrollViewMain;
}
@synthesize m_delegate;
@synthesize m_tag;
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
- (void) viewDidDisappear:(BOOL)animated
{
    [m_editViewDishDescrition resignFirstResponder];
    [m_editViewDishName resignFirstResponder];
    [m_editViewDishPrice resignFirstResponder];
}
// ==================================================================================
#pragma mark - 内部调用方法
/** 初始化导航栏 */
- (void) initNavView
{
    self.navigationItem.title = m_strNavTitle;
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
    if(m_dishItem == nil){
        m_dishItem = [DishItem new];
    }
    m_strNavTitle = @"新建菜";
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
    if(m_editViewDishName == nil){
        EditView *editView = [EditView new];
        [editView setReturnKeyType:UIReturnKeyNext];
        [editView setEditViewType:EditViewType_SinggleRow];
        [editView setBackgroundColor:Color_RGB(240, 240, 240)];
        [editView setTextAlignment:NSTextAlignmentLeft];
        [editView setIsLayoutWhenSuperCall:YES];
        [editView setTextFont:Font_Text];
        [editView setTextColor:Color_Text];
        [editView setPlaceHolder:@"输入菜名"];
        [editView setPlaceHolderColor:Color_Text];
        [editView setDelegate:(id)self];
        [editView setTag:ViewTag_EditViewDishName];
        m_editViewDishName = editView;
    }
    if(m_editViewDishPrice == nil){
        EditView *editView = [EditView new];
        [editView setReturnKeyType:UIReturnKeyNext];
        [editView setEditViewType:EditViewType_SinggleRow];
        [editView setBackgroundColor:Color_RGB(240, 240, 240)];
        [editView setTextAlignment:NSTextAlignmentLeft];
        [editView setIsLayoutWhenSuperCall:YES];
        [editView setTextFont:Font_Text];
        [editView setTextColor:Color_Text];
        [editView setPlaceHolder:@"输入价格"];
        [editView setPlaceHolderColor:Color_Text];
        [editView setDelegate:(id)self];
        [editView setTag:ViewTag_EditViewDishPrice];
        [editView setKeyboardType:UIKeyboardTypeNumberPad];
        m_editViewDishPrice = editView;
    }
    if(m_btnIsRecommend == nil){
        UIButton *btn = [UIButton new];
        [btn setBackgroundColor:Color_Transparent];
        [btn setClipsToBounds:YES];
        [btn setTag:ViewTag_Recommend];
        [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        [btn setBackgroundImage:GetImg(@"mainview_noselect") forState:UIControlStateNormal];
        [btn setBackgroundImage:GetImg(@"mainview_selected") forState:UIControlStateSelected];
        m_btnIsRecommend = btn;
    }
    
    if(m_editViewDishDescrition == nil){
        EditView *editView = [EditView new];
        [editView setReturnKeyType:UIReturnKeyDone];
        [editView setEditViewType:EditViewType_ManyRows_NoAutoLayout];
        [editView setBackgroundColor:Color_RGB(240, 240, 240)];
        [editView setTextAlignment:NSTextAlignmentLeft];
        [editView setIsLayoutWhenSuperCall:YES];
        [editView setTextFont:Font_Text];
        [editView setTextColor:Color_Text];
        [editView setPlaceHolder:@"输入菜简介"];
        [editView setPlaceHolderColor:Color_Text];
        [editView setDelegate:(id)self];
        [editView setTag:ViewTag_EditViewDishDescription];
        m_editViewDishDescrition = editView;
    }
    if(m_btnDelete == nil){
        UIButton *btn = [UIButton new];
        [btn setBackgroundColor:Color_RGB(200, 30, 120)];
        [btn setClipsToBounds:YES];
        [btn setTag:ViewTag_Delete];
        [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        m_btnDelete = btn;
    }
    if(m_scrollViewMain == nil){
        m_scrollViewMain = [UIScrollView new];
        [m_scrollViewMain setBackgroundColor:Color_Transparent];
    }
    
}
/** 将所有View添加到控制中显示 */
- (void) addAllViewToViewController
{
    UIView *viewMain = self.view;
    [viewMain setBackgroundColor:[UIColor whiteColor]];
    
    const float h_tx_singgle = [CPublic getTextHeight:@"高" _font:Font_Text]*3/2;
    const float h_tx_manyRow = h_tx_singgle*3;
    const float h_imgViewIcon = h_tx_singgle*2;
    const float h_imgViewRecommend = h_tx_singgle;
    const float h_btnDelete = h_tx_singgle;
    const float space_x = 20;
    const float space_y = 20;
    
    CGRect frameSelf = viewMain.bounds;
    float valueTemp = (m_bIsEditMode == YES)? h_btnDelete : 0;
    frameSelf.size.height -= valueTemp;
    m_scrollViewMain.frame = frameSelf;
    [viewMain addSubview:m_scrollViewMain];
    
    
    float x_add = space_x*4;
    float y_add = space_y;
    float h_add = h_imgViewIcon;
    float w_add = h_add;
    
    // ====== 菜图标 ======
    if(m_btnImgIcon != nil){
        [m_btnImgIcon setFrame:CGRectMake(x_add, y_add, w_add, h_add)];
        [m_scrollViewMain addSubview:m_btnImgIcon];
        y_add += m_btnImgIcon.frame.size.height + space_y;
        if([m_dishItem getDishIconImgPath] != nil){
            NSString *strFilePath = [CPublic getLocalAbsolutePathOfRelativePath:[m_dishItem getDishIconImgPath]];
            [m_btnImgIcon setBackgroundImage:[UIImage imageWithContentsOfFile:strFilePath] forState:UIControlStateNormal];
        }
            
    }
    // ====== 菜名编辑框 ======
    h_add = h_tx_singgle;
    w_add = m_scrollViewMain.bounds.size.width - x_add - space_x;
    if(m_editViewDishName != nil){
        [m_editViewDishName setFrame:CGRectMake(x_add, y_add, w_add, h_add)];
        [m_scrollViewMain addSubview:m_editViewDishName];
        y_add += m_editViewDishName.frame.size.height + space_y;
        if([m_dishItem getDishName] != nil){
            [m_editViewDishName setTextContent:[m_dishItem getDishName]];
        }
    }
    // ====== 价格编辑框 =======
    h_add = h_tx_singgle;
    w_add = m_scrollViewMain.bounds.size.width - x_add - space_x;
    if(m_editViewDishPrice != nil){
        [m_editViewDishPrice setFrame:CGRectMake(x_add, y_add, w_add, h_add)];
        [m_scrollViewMain addSubview:m_editViewDishPrice];
        y_add += m_editViewDishPrice.frame.size.height + space_y;
        [m_editViewDishPrice setTextContent:[NSString stringWithFormat:@"%.02f", [m_dishItem getDishPrice]]];
    }
    
    // ======= 菜系选择框 ======
    h_add = h_tx_singgle;
    w_add = m_scrollViewMain.bounds.size.width - x_add - space_x;
    if(m_dropSelectView != nil){
        [m_dropSelectView setFrame:CGRectMake(x_add, y_add, w_add, h_add)];
        [m_scrollViewMain addSubview:m_dropSelectView];
        y_add += m_dropSelectView.frame.size.height + space_y;
        NSString *strDishStyleName = [m_dishItem getDishStyleName];
        if(strDishStyleName != nil){
            [m_dropSelectView setSelectName:strDishStyleName];
        }
    }
    
    // ====== 是否推荐 =======
    h_add = h_imgViewRecommend;
    w_add = h_add;
    if(m_btnIsRecommend != nil){
        [m_btnIsRecommend setFrame:CGRectMake(x_add, y_add, w_add, h_add)];
        [m_scrollViewMain addSubview:m_btnIsRecommend];
        y_add += m_btnIsRecommend.frame.size.height + space_y;
        [m_btnIsRecommend setSelected:[m_dishItem getIsDishRecommend]];
    }
    // ====== 菜描述编辑框 =======
    h_add = h_tx_manyRow;
    w_add = m_scrollViewMain.bounds.size.width - x_add - space_x;
    if(m_editViewDishDescrition != nil){
        [m_editViewDishDescrition setFrame:CGRectMake(x_add, y_add, w_add, h_add)];
        [m_scrollViewMain addSubview:m_editViewDishDescrition];
        y_add += m_editViewDishDescrition.frame.size.height + space_y;
        if([m_dishItem getDishDescrition] != nil){
            [m_editViewDishDescrition setTextContent:[m_dishItem getDishDescrition]];
        }
    }
    
    // ======= 删除按钮 =======
    h_add = h_btnDelete;
    w_add = viewMain.bounds.size.width;
    x_add = 0;
    y_add = viewMain.bounds.size.height - h_add;
    if(m_btnDelete != nil){
        [m_btnDelete setFrame:CGRectMake(x_add, y_add, w_add, h_add)];
        [viewMain addSubview:m_btnDelete];
    }
    
    float h_contentY = m_editViewDishDescrition.frame.origin.y + m_editViewDishDescrition.frame.size.height + space_y;
    [m_scrollViewMain setContentSize:CGSizeMake(m_scrollViewMain.contentSize.width, h_contentY)];
}

// ==================================================================================
#pragma mark - 外部调用方法
/** 设置菜系，可通用与编辑菜和新建菜 */
- (void) setDishStyleWithID:(NSString*)v_strDishStyleID _dishStyleName:(NSString*)v_strDishStyleName
{
    if(m_dishItem == nil){
        m_dishItem = [DishItem new];
    }
    v_strDishStyleID = (v_strDishStyleID!=nil)? v_strDishStyleID : @"";
    v_strDishStyleName = (v_strDishStyleName!=nil)? v_strDishStyleName : @"";
    
    [m_dishItem setDishStyleID:v_strDishStyleID];
    [m_dishItem setDishStyleName:v_strDishStyleName];
    if(m_dropSelectView != nil){
        [m_dropSelectView setSelectName:v_strDishStyleName];
    }
}
/** 是否默认设置为推荐菜 */
- (void) setIsRecommendDefault:(BOOL)v_bIsRecommend
{
    if(m_dishItem == nil){
        m_dishItem = [DishItem new];
    }
    [m_dishItem setIsDishRecommend:v_bIsRecommend];
    if(m_btnIsRecommend != nil){
        [m_btnIsRecommend setSelected:v_bIsRecommend];
    }
}

/** 设置菜，用于编辑菜的时候设置的 */
- (void) setDishItemForEdit:(DishItem*)v_dishItem
{
    m_dishItem = v_dishItem;
    m_strNavTitle = @"编辑菜";
    m_bIsEditMode = YES;
}
/** 确定添加或者编辑菜 */
- (void) commitEdit
{
    NSString *strDishName = [m_editViewDishName getTextContent];
    NSString *strDishPrice = [m_editViewDishPrice getTextContent];
    NSString *strDishDescription = [m_editViewDishDescrition getTextContent];
    if(strDishName == nil
       || [strDishName isEqualToString:@""] == YES){
        [CPublic ShowDialg:@"菜名不能为空"];
        return;
    }
    if(strDishPrice == nil
       || [strDishPrice isEqualToString:@""] == YES){
        [CPublic ShowDialg:@"菜价格不能为空"];
        return;
    }
    [m_dishItem setDishName:strDishName];
    [m_dishItem setDishPrice:[strDishPrice floatValue]];
    [m_dishItem setDishDescrition:strDishDescription];
    
    if(m_bIsEditMode != YES){ // 新建菜
        if(m_delegate != nil){
            BOOL bTemp = [m_delegate respondsToSelector:@selector(addNewDishWithDishItemOfNoID:)];
            if(bTemp == YES){
                [m_delegate addNewDishWithDishItemOfNoID:m_dishItem];
            }
        }
   
    } else { // 编辑菜
        if(m_delegate != nil){
            BOOL bTemp = [m_delegate respondsToSelector:@selector(updateDishWithDishItem:)];
            if(bTemp == YES){
                [m_delegate updateDishWithDishItem:m_dishItem];
            }
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}

// ==================================================================================
#pragma mark - 动作触发方法
/** Button按钮点击事件 */
- (void) clickBtn:(id)v_sender
{
    UIView *view = (UIView*)v_sender;
    switch((ViewTag)view.tag){
        case ViewTag_Commit:{ // 确定按钮
            [self commitEdit];
            break;
        }
        case ViewTag_BtnIcon:{ // 切换图片
            [GetPhoto openViewWithSelectPhoto:self];
            break;
        }
        case ViewTag_DropList:{ // 下拉选择菜系名
            if(m_delegate != nil){
                BOOL bTemp = [m_delegate respondsToSelector:@selector(openSelectDropView_newDish:)];
                if(bTemp == YES){
                    [m_delegate openSelectDropView_newDish:self];
                }
            }
            break;
        }
        case ViewTag_Delete:{ // 删除
            break;
        }
        case ViewTag_Recommend:{ // 推荐
            m_btnIsRecommend.selected = !m_btnIsRecommend.selected;
            [m_dishItem setIsDishRecommend:m_btnIsRecommend.selected];
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
    [m_dishItem setDishIconImgPath:strFilePath];
    UIImage *img = [UIImage imageWithData:v_dataImg];
    [m_btnImgIcon setBackgroundImage:img forState:UIControlStateNormal];
}

// ==============================================================================================
#pragma mark -  委托协议EditViewDelegate
/** 跳转到下一个编辑框 */
- (void) gotoNextEditView:(id)v_sender _returnKeyType:(UIReturnKeyType)v_returnKeyType
{
    UIView *view = v_sender;
    switch((ViewTag)view.tag){
        case ViewTag_EditViewDishName:{ // 菜名
            [m_editViewDishPrice requireFirstResponder];
            break;
        }
        case ViewTag_EditViewDishPrice:{ // 菜价格
            [m_editViewDishDescrition requireFirstResponder];
            break;
        }
        case ViewTag_EditViewDishDescription:{ // 菜描述
            break;
        }
        default:{
            break;
        }
    }
}
@end
