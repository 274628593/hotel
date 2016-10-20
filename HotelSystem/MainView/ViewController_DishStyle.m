//
//  ViewController_DishStyle.m
//  HotelSystem
//
//  Created by LHJ on 16/3/19.
//  Copyright © 2016年 hancj. All rights reserved.
//

#import "ViewController_DishStyle.h"
#import "CPublic.h"
#import "DishStyleManager.h"
#import "BtnForRecommend.h"
#import "DeskItem.h"
#import "BtnForAllDish.h"

typedef enum : int{
    ViewTag_NavRightBtn = 1, /* 导航栏右边按键 */
    ViewTag_EditSwitch, /* 控制编辑开关的按钮 */
    ViewTag_AddDishStyle, /* 添加菜系 */
    ViewTag_RecommendBtn, /* 推荐菜单按钮 */
    ViewTag_AllDish, /* 全部菜单按钮 */
}ViewTag;

@implementation ViewController_DishStyle
{
    BOOL                                    m_bIsEditEnable;
    NSArray<DishStyleItem*>                 *m_aryDishStyleList;
    DishStyleManager                        *m_dishStyleManager;
    UIScrollView                            *m_scrollViewMain;
    int                                     m_colsOfEveryRow;
    NSMutableArray<DishStyleItemView*>      *m_muAryDishStyleItemView;
    UIButton                                *m_btnEditSwitch; // 切换编辑开关的按钮
    UIView                                  *m_btnSearch;   // 搜索按钮
    UIView                                  *m_btnRecommend; // 推荐按钮
    UIView                                  *m_btnAllDish;  // 全部菜
    UIFont                                  *m_fontSearch;  // 搜索文字字体
    UIFont                                  *m_fontRecommend; // 推荐文字字体
    UIFont                                  *m_fontBtnText;
    UIButton                                *m_btnAddDish;
    BOOL                                    m_bIsEditing; // 是否正在编辑
}
@synthesize m_delegate;
@synthesize m_deskItem;

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
- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    NSLog(@"%f", self.view.bounds.size.height);
}
- (void) viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
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
    self.navigationItem.title = @"菜系选择";
    
    if(m_bIsEditing != YES){
        UIBarButtonItem *barBtnItem = [[UIBarButtonItem alloc]initWithTitle:@"已选菜单"
                                                                      style:UIBarButtonItemStyleDone
                                                                     target:self
                                                                     action:@selector(clickBtn:)];
        [barBtnItem setTag:ViewTag_NavRightBtn];
        self.navigationItem.rightBarButtonItem = barBtnItem;
    } else {
        UIBarButtonItem *barBtnItem = [[UIBarButtonItem alloc]initWithTitle:@"关闭"
                                                                      style:UIBarButtonItemStyleDone
                                                                     target:self
                                                                     action:@selector(clickBtn:)];
        [barBtnItem setTag:ViewTag_NavRightBtn];
        self.navigationItem.rightBarButtonItem = barBtnItem;
    }
}
/** 初始化数据 */
- (void) initData
{
    m_dishStyleManager = [DishStyleManager new];
    m_colsOfEveryRow = 3;
    m_muAryDishStyleItemView = [NSMutableArray new];
    m_bIsEditEnable = NO;
    m_fontSearch = Font_Bold(26.0f);
    m_fontRecommend = Font_Bold(28.0f);
    m_fontBtnText = Font_Bold(26.0f);
    m_bIsEditing = NO;
}
/** 初始化所有视图View */
- (void) initMainView
{
    UIView *viewMain = self.view;
    [viewMain setBackgroundColor:[UIColor whiteColor]];
    
    if(m_btnSearch == nil){
        m_btnSearch = [self getBtnForSearch:m_fontSearch];
    }
  
    if(m_btnRecommend == nil){
        m_btnRecommend = [self getBtnForRecommend:m_fontRecommend];
    }
    if(m_btnAllDish == nil){
        m_btnAllDish = [self getBtnForAllDish:m_fontRecommend];
    }
    
    // ====== 菜系排列View ======
    m_aryDishStyleList = [m_dishStyleManager getDishStyleItemList];
    const float cornerRadius = 6.0f;
    UIFont *fontDishStyleView = Font_Bold(22);
    UIColor *colorDishStyleView = Color_RGB(60, 60, 60);
    NSMutableArray<DishStyleItemView*> *muAryView = [NSMutableArray<DishStyleItemView*> new];
    for(int i=0; i<m_aryDishStyleList.count+1; i+=1)
    {
        if(i == m_aryDishStyleList.count){ // 初始化添加按钮
            if(m_btnAddDish == nil){
                m_btnAddDish = [self getBtnAddDishStyle_tag:ViewTag_AddDishStyle];
            }
            continue;
        }
        
        DishStyleItem *dishStyleItem = [m_aryDishStyleList objectAtIndex:i];
        DishStyleItemView *dishStyleItemView = nil;
        if(i<m_muAryDishStyleItemView.count){
            dishStyleItemView = [m_muAryDishStyleItemView objectAtIndex:i];
        } else {
            dishStyleItemView = [DishStyleItemView new];
            [dishStyleItemView setCornerRadius:cornerRadius];
            [dishStyleItemView setTextFont:fontDishStyleView];
            [dishStyleItemView setTextColor:colorDishStyleView];
            [dishStyleItemView setDelegate:(id)self];
            
        }
        [dishStyleItemView setDishStyleImgPath:[dishStyleItem getDishStyleIconImgPath]];
        [dishStyleItemView setDishStyleName:[dishStyleItem getDishStyleName]];
        [dishStyleItemView setTag:i];
        [muAryView addObject:dishStyleItemView];
    }
    if(m_muAryDishStyleItemView != nil){
        for(DishStyleItemView *itemView in m_muAryDishStyleItemView){
            [itemView removeFromSuperview];
        }
        [m_muAryDishStyleItemView removeAllObjects];
        m_muAryDishStyleItemView = nil;
    }
    m_muAryDishStyleItemView = muAryView;
    
    
    if(m_bIsEditEnable == YES){
        // ====== 控制编辑开关的按钮 ======
        if(m_btnEditSwitch == nil){
            m_btnEditSwitch = [self getBtnEditSwitch_tag:ViewTag_EditSwitch
                                                _fontTitle:m_fontBtnText];
        }
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
    [viewMain addSubview:m_scrollViewMain];
    
    // ====== 搜索按钮 ======
    float x_add = 0;
    float y_add = 0;
    float w_add = viewMain.bounds.size.width;
    float h_add = [CPublic getTextHeight:@"高" _font:m_fontSearch]*3/2;
    [m_btnSearch setFrame:CGRectMake(x_add, y_add, w_add, h_add)];
    [viewMain addSubview:m_btnSearch];
    
    // ====== 推荐菜单按钮 ======
    y_add += m_btnSearch.frame.size.height;
    h_add = [CPublic getTextHeight:@"高" _font:m_fontRecommend]*3/2;
    [m_btnRecommend setFrame:CGRectMake(x_add, y_add, w_add, h_add)];
    [viewMain addSubview:m_btnRecommend];
    
    // ====== 全部菜单按钮 ======
    y_add += m_btnRecommend.frame.size.height;
    h_add = [CPublic getTextHeight:@"高" _font:m_fontRecommend]*3/2;
    [m_btnAllDish setFrame:CGRectMake(x_add, y_add, w_add, h_add)];
    [viewMain addSubview:m_btnAllDish];
    y_add += m_btnAllDish.frame.size.height;
    const float y_scroll = y_add;
    
    // ====== 菜系排列View ======
    const float space_y = 20;
    const float space_x = 40;
    y_add = space_y;
    w_add = (viewMain.bounds.size.width - space_x*(m_colsOfEveryRow+2))/m_colsOfEveryRow;
    h_add = w_add;
    x_add = space_x;
    y_add = 0;
    int colIndex = 0;
    int rowIndex = 0;
    for(int i=0; i<m_muAryDishStyleItemView.count+1; i+=1){
        x_add = (colIndex * w_add) + space_x*(colIndex+1);
        y_add = (rowIndex * h_add) + space_y*(rowIndex+1);
        
        UIView *view = nil;
        if(i<m_muAryDishStyleItemView.count){
            view = [m_muAryDishStyleItemView objectAtIndex:i];
        } else {
            view = m_btnAddDish;
        }
        if(view != nil){
            [view setFrame:CGRectMake(x_add, y_add, w_add, h_add)];
            [m_scrollViewMain addSubview:view];
            colIndex += 1;
            if(colIndex >= m_colsOfEveryRow){ // 增加一行
                colIndex = 0;
                rowIndex += 1;
            }
        }
    }
    if(m_btnAddDish != nil){
        [m_btnAddDish setHidden:!m_bIsEditing];
    }
//    float value = self.navigationController.navigationBar.frame.size.height + Height_StatusBar;
    h_add = [CPublic getTextHeight:@"高" _font:m_fontBtnText];
    w_add = viewMain.bounds.size.width;
    x_add = 0;
    y_add = viewMain.bounds.size.height - h_add;
    if(m_bIsEditEnable == YES
       && m_btnEditSwitch != nil){
        [m_btnEditSwitch setFrame:CGRectMake(x_add, y_add, w_add, h_add)];
        [viewMain addSubview:m_btnEditSwitch];
    }
    
    CGRect frameScrollView = viewMain.bounds;
    frameScrollView.origin.y = y_scroll;
    float h_temp = (m_btnEditSwitch != nil)? m_btnEditSwitch.frame.origin.y : viewMain.bounds.size.height;
    frameScrollView.size.height = h_temp - frameScrollView.origin.y;
    [m_scrollViewMain setFrame:frameScrollView];
    
    float content_y = (rowIndex * h_add) + space_y*(rowIndex+1);;
    [m_scrollViewMain setContentSize:CGSizeMake(m_scrollViewMain.contentSize.width, content_y)];
}
/** 获取控制编辑开关的按钮 */
- (UIButton*) getBtnEditSwitch_tag:(ViewTag)v_viewTag
                          _fontTitle:(UIFont*)v_fontTitle
{
    UIButton *btnRS = [UIButton new];
    [btnRS setBackgroundColor:Color_RGB(30, 200, 120)];
    [btnRS setTag:v_viewTag];
    [btnRS setTitle:@"编辑菜单" forState:UIControlStateNormal];
    [btnRS setTitle:@"关闭编辑" forState:UIControlStateSelected];
    [btnRS setTitleColor:Color_RGB(255, 255, 255) forState:UIControlStateNormal];
    [btnRS.titleLabel setFont:v_fontTitle];
    [btnRS setClipsToBounds:YES];
    [btnRS addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    return btnRS;
}
/** 创建搜索按钮 */
- (UIView*) getBtnForSearch:(UIFont*)v_font
{
    View_Search *btnRS = [View_Search new];
    [btnRS setBackgroundColor:Color_RGB(100, 100, 200)];
    [btnRS setClipsToBounds:YES];
    [btnRS setDelegate:(id)self];
    [btnRS setTextColor:Color_RGB(255, 255, 255)];
    [btnRS setTextFont:v_font];
    [btnRS setIsEditWhileShow:NO];
    return btnRS;
}
/** 创建推荐菜单按钮 */
- (UIView*) getBtnForRecommend:(UIFont*)v_font
{
    BtnForRecommend *btnRS = [BtnForRecommend new];
    [btnRS setBackgroundColor:Color_RGB(30, 200, 120)];
    [btnRS setTextColor:Color_RGB(255, 255, 255)];
    [btnRS setTextFont:v_font];
    [btnRS setClipsToBounds:YES];
    [btnRS setTag:ViewTag_RecommendBtn];
    [btnRS addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    return btnRS;
}
/** 创建所有菜单按钮 */
- (UIView*) getBtnForAllDish:(UIFont*)v_font
{
    BtnForAllDish *btnRS = [BtnForAllDish new];
    [btnRS setBackgroundColor:Color_RGB(30, 100, 230)];
    [btnRS setTextColor:Color_RGB(255, 255, 255)];
    [btnRS setTextFont:v_font];
    [btnRS setClipsToBounds:YES];
    [btnRS setTag:ViewTag_AllDish];
    [btnRS addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    return btnRS;
}
/** 返回添加菜的添加按钮 */
- (UIButton*) getBtnAddDishStyle_tag:(ViewTag)v_viewTag;
{
    UIButton *btnRS = [UIButton new];
    [btnRS setBackgroundColor:Color_RGB(30, 200, 120)];
    [btnRS setTag:v_viewTag];
    [btnRS setClipsToBounds:YES];
    [btnRS addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    return btnRS;
}
/** 设置是否编辑 */
- (void) setEditMode:(BOOL)v_bIsEdit
{
    m_bIsEditing = v_bIsEdit;
    [m_btnEditSwitch setSelected:m_bIsEditing];
    [self initNavView];
    [self addAllViewToViewController];
}
// ==================================================================================
#pragma mark - 外部调用方法
/** 是否可以编辑 */
- (void) setIsEditEnable:(BOOL)v_bIsEditEnable
{
    m_bIsEditEnable = v_bIsEditEnable;
}
/** 添加新的菜系 */
- (void) addDishStyleWithDishStyleID:(NSString*)v_strDishTyleID
                                _name:(NSString*)v_strName
                        _imgFilePath:(NSString*)v_strFilePath;
{
    BOOL bAdd = [m_dishStyleManager addDishStyleWithDishStyleNameID:v_strDishTyleID
                                                              _name:v_strName
                                            _imgPathOfDishStyleIcon:v_strFilePath];
    if(bAdd == YES){ // 添加成功，刷新界面
        [self initMainView];
        [self addAllViewToViewController];
    }
}
/** 编辑菜系 */
- (void) editDishStyleWithDishStyleID:(NSString*)v_strDishStyleID
                             _newName:(NSString*)v_strDishStyleName
                      _newImgFilePath:(NSString*)v_strImgFilePath
{
    BOOL bUpdate = [m_dishStyleManager updateDishStyle:v_strDishStyleID _name:v_strDishStyleName _imgPathOfDishStyleIcon:v_strImgFilePath];
    if(bUpdate == YES){ // 添加成功，刷新界面
        [self initMainView];
        [self addAllViewToViewController];
    }
}
// ==================================================================================
#pragma mark - 动作触发方法
/** Button按钮点击事件 */
- (void) clickBtn:(id)v_sender
{
    UIView *view = (UIView*)v_sender;
    switch((ViewTag)view.tag){
        case ViewTag_NavRightBtn:{ // 导航栏右键：已选菜单
            if(m_bIsEditing == YES){
                [self setEditMode:NO];
            } else {
                if(m_delegate != nil){
                    BOOL bTemp = [m_delegate respondsToSelector:@selector(openViewControllerOfDishListOfSelectedFromDishStyleWithDeskItem:_sender:)];
                    if(bTemp == YES){
                        [m_delegate openViewControllerOfDishListOfSelectedFromDishStyleWithDeskItem:m_deskItem
                                                                               _sender:self];
                    }
                }
            }
            break;
        }
        case ViewTag_EditSwitch:{ // 控制 编辑开关
            [self setEditMode:!m_bIsEditing];
            break;
        }
        case ViewTag_RecommendBtn:{ // 推荐菜单
            if(m_delegate != nil){
                BOOL bTemp = [m_delegate respondsToSelector:@selector(openViewControllerOfRecommendDish:)];
                if(bTemp == YES){
                    [m_delegate openViewControllerOfRecommendDish:self];
                }
            }
            break;
        }
        case ViewTag_AllDish:{ // 全部菜单
            
            if(m_delegate != nil){
                BOOL bTemp = [m_delegate respondsToSelector:@selector(openViewControllerOfAllDish:)];
                if(bTemp == YES){
                    [m_delegate openViewControllerOfAllDish:self];
                }
            }
            break;
        }
        case ViewTag_AddDishStyle:{ // 添加菜系
            if(m_delegate != nil){
                BOOL bTemp = [m_delegate respondsToSelector:@selector(openViewControllerOfAddNewDishStyle_sender:)];
                if(bTemp == YES){
                    [m_delegate openViewControllerOfAddNewDishStyle_sender:self];
                }
            }
            break;
        }
    }
}
// ==============================================================================================
#pragma mark 委托协议DishStyleItemViewDelegate
/** 点击菜系 */
- (void) clickMenuTypeItem:(id)v_sender
{
    int index = (int)[(UIView*)v_sender tag];
    DishStyleItem *item = [m_aryDishStyleList objectAtIndex:index];
    if(m_bIsEditing == YES){ // 编辑菜系
        if(m_delegate != nil){
            BOOL bTemp = [m_delegate respondsToSelector:@selector(openViewControllerOfEditDishStyle:_sender:)];
            if(bTemp == YES){
                [m_delegate openViewControllerOfEditDishStyle:item _sender:self];
            }
        }
    } else { // 打开菜系菜单
        if(m_delegate != nil){
            BOOL bTemp = [m_delegate respondsToSelector:@selector(openViewControllerOfDishListForDishStyleItem: _sender:)];
            if(bTemp == YES){
                [m_delegate openViewControllerOfDishListForDishStyleItem:item _sender:self];
            }
        }
    }
}
// ==============================================================================================
#pragma mark - 委托定义View_SearchDelegate
/** 确定搜索的关键字 */
- (void) commitSearch:(NSString*)v_strSearch
{
    if(m_delegate != nil){
        [m_delegate openViewControllerOfSearchDishWithSearchText:v_strSearch _sender:self];
    }
}

@end
