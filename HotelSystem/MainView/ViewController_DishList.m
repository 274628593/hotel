//
//  ViewController_DishList.m
//  HotelSystem
//
//  Created by LHJ on 16/3/24.
//  Copyright © 2016年 hancj. All rights reserved.
//

#import "ViewController_DishList.h"
#import "CPublic.h"
#import "DishItem.h"
#import "DishManager.h"
#import "DishOfSelectedManager.h"
#import "DeskItem.h"

typedef enum : int{
    ViewTag_NavRightBtn = 1, /* 导航栏右边按键 */
    ViewTag_AddDish, /* 添加菜 */
    ViewTag_EditSwitch, /* 控制编辑开关的按钮 */
}ViewTag;

@implementation ViewController_DishList
{
    BOOL                            m_bIsReommecdDish; // 是否是打开推荐菜单
    BOOL                            m_bIsEditEnable;   // 是否可以编辑
    BOOL                            m_bIsEditing; // 是否正在编辑
    DishManager                     *m_dishManager;
    BOOL                            m_bIsSearchViewMode;
    NSString                        *m_strSearchText;
    NSString                        *m_strDishStyleID;
    NSString                        *m_strDishStyleName;
    int                             m_colsOfEveryRow;
    
    NSArray<DishItem*>              *m_aryDishList;
    NSMutableArray<DishItemView*>   *m_muAryDishItemView;
    UIScrollView                    *m_scrollViewMain;
    UIButton                        *m_btnEditSwitch;
    NSString                        *m_strNavTitle;
    UIButton                        *m_btnAddDish;
    UIView                          *m_btnSearch;
    
    UIFont                          *m_fontText;
    
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
- (void) viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    [self addAllViewToViewController];
}

// ==================================================================================
#pragma mark - 内部使用方法
/** 初始化导航栏 */
- (void) initNavView
{
    
    self.navigationItem.title = m_strNavTitle;
    
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
    m_strNavTitle = @"菜单";
    m_dishManager = [DishManager SharedDishManagerObj];
    m_colsOfEveryRow = 2;
    m_bIsSearchViewMode = NO;
    m_muAryDishItemView = [NSMutableArray new];
    m_bIsEditEnable = NO;
    m_bIsEditing = NO;
    m_fontText = Font_Bold(26);
    m_strDishStyleID = nil;
    m_strDishStyleName = nil;
}
/** 初始化所有视图View */
- (void) initMainView
{
    UIView *viewMain = self.view;
    [viewMain setBackgroundColor:[UIColor whiteColor]];
    
    if(m_bIsReommecdDish == YES){ // 推荐菜单模式
        m_aryDishList = [m_dishManager getAllDishItemListForRecommend];
        
    } else if(m_bIsSearchViewMode != YES){ // 指定菜系或者全部的菜单
        if(m_strDishStyleID != nil){
            m_aryDishList = [m_dishManager getDishItemListForDishStyleID:m_strDishStyleID];
        } else {
            m_aryDishList = [m_dishManager getAllDishItemList];
        }
       
    } else { // 搜索模式
        if(m_strSearchText == nil
           || [m_strSearchText isEqualToString:@""] == YES){
            m_aryDishList = [m_dishManager getAllDishItemList]; // 全部菜

        } else { // 按照关键字搜索
            m_aryDishList = [m_dishManager getDishItemListForSearchText:m_strSearchText];
        }
    }
    
    // ====== 菜列表排列View ======
    UIFont *fontDishItemName = Font_Bold(30);
    UIColor *colorDishItemName = Color_RGB(60, 60, 60);
    UIFont *fontDishPrice = Font_Bold(28);
    UIColor *colorDishPrice = Color_RGB(200, 60, 120);
    NSMutableArray<DishItemView*> *muAryView = [NSMutableArray<DishItemView*> new];
    for(int i=0; i<m_aryDishList.count+1; i+=1){
        if(i == m_aryDishList.count){ // 初始化添加按钮
            if(m_btnAddDish == nil){
                m_btnAddDish = [self getBtnAddDish_tag:ViewTag_AddDish];
            }
            continue;
        }
        
        DishItem *dishItem = [m_aryDishList objectAtIndex:i];
        DishItemView *dishItemView = nil;
        if(i<m_muAryDishItemView.count){
            dishItemView = [m_muAryDishItemView objectAtIndex:i];
        } else {
            dishItemView = [DishItemView new];
            [dishItemView setDelegate:(id)self];
            [dishItemView setFontTitle:fontDishItemName];
            [dishItemView setColorTitle:colorDishItemName];
            [dishItemView setFontPrice:fontDishPrice];
            [dishItemView setColorPrice:colorDishPrice];
        }
        
        BOOL bSelected = [[DishOfSelectedManager SharedDishOfSelectedManagerObj] isSelectedOfDishItem:dishItem _deskID:[m_deskItem getDeskID]];
        [dishItemView setIsSelected:bSelected];
        [dishItemView setDishItem:dishItem];
        [dishItemView setTag:i];
        [muAryView addObject:dishItemView];
    }
    if(m_muAryDishItemView != nil){
        for(DishItemView *itemView in m_muAryDishItemView){
            [itemView removeFromSuperview];
        }
        [m_muAryDishItemView removeAllObjects];
        m_muAryDishItemView = nil;
    }
    m_muAryDishItemView = muAryView;
    
    
    if(m_bIsEditEnable == YES){
        // ====== 控制编辑开关的按钮 ======
        if(m_btnEditSwitch == nil){
            m_btnEditSwitch = [self getBtnEditSwitch_Tag:ViewTag_EditSwitch
                                                _fontTitle:m_fontText];
        }
    }
    if(m_btnSearch == nil){
        m_btnSearch = [self getBtnForSearch:m_fontText];
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

    const float space_y = 20;
    const float space_x = 20;
    float w_add = (viewMain.bounds.size.width - space_x*(m_colsOfEveryRow+2))/m_colsOfEveryRow;
    float h_add = w_add*4/10;
    float x_add = space_x;
    float y_add = space_y;
    int colIndex = 0;
    int rowIndex = 0;
    for(int i=0; i<m_muAryDishItemView.count+1; i+=1){
        x_add = (colIndex * w_add) + space_x*(colIndex+1);
        y_add = (rowIndex * h_add) + space_y*(rowIndex+1);
        
        UIView *view = nil;
        if(i == m_muAryDishItemView.count){
            view = m_btnAddDish;
        }else {
            view = [m_muAryDishItemView objectAtIndex:i];
            [(DishItemView*)view setIsSelectEnable:!m_bIsEditing];
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
    
    h_add = [CPublic getTextHeight:@"高" _font:m_fontText];
    w_add = viewMain.bounds.size.width;
    x_add = 0;
    y_add = 0;
    float y_scrollView = 0;
    if(m_bIsSearchViewMode == YES
       && m_btnSearch != nil){
        [m_btnSearch setFrame:CGRectMake(x_add, y_add, w_add, h_add)];
        [viewMain addSubview:m_btnSearch];
        y_scrollView = y_add + m_btnSearch.frame.size.height;
    }
    
//    float value = self.navigationController.navigationBar.frame.size.height + Height_StatusBar;
    h_add = [CPublic getTextHeight:@"高" _font:m_fontText];
    w_add = viewMain.bounds.size.width;
    x_add = 0;
    y_add = viewMain.bounds.size.height - h_add;
    if(m_bIsEditEnable == YES
       && m_btnEditSwitch != nil){
        [m_btnEditSwitch setFrame:CGRectMake(x_add, y_add, w_add, h_add)];
        [viewMain addSubview:m_btnEditSwitch];
    }
    
    CGRect frameScrollView = viewMain.bounds;
    frameScrollView.origin.y = y_scrollView;
    float h_temp = (m_bIsEditEnable == YES)? m_btnEditSwitch.frame.origin.y : viewMain.bounds.size.height;
    frameScrollView.size.height = h_temp - frameScrollView.origin.y;
    [m_scrollViewMain setFrame:frameScrollView];
    
    float content_y = (rowIndex * h_add) + space_y*(rowIndex+1);
    [m_scrollViewMain setContentSize:CGSizeMake(m_scrollViewMain.contentSize.width, content_y)];
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
    [btnRS setTextDefault:m_strSearchText];
    return btnRS;
}
/** 获取控制编辑开关的按钮 */
- (UIButton*) getBtnEditSwitch_Tag:(ViewTag)v_viewTag
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
/** 返回添加菜的添加按钮 */
- (UIButton*) getBtnAddDish_tag:(ViewTag)v_viewTag;
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
/** 设置要显示的菜系ID，为nil时则显示全部，默认nil，在界面显示之前设置 */
- (void) setDishStyleIdOfDishList:(NSString*)v_strDishStyleID
                   _dishStyleName:(NSString*)v_strDishStyleName
{
    m_strDishStyleID = v_strDishStyleID;
    m_strDishStyleName = v_strDishStyleName;
    m_strNavTitle = m_strDishStyleName;
}

/** 设置要搜索的文字，如果设置这个，则显示搜索界面的风格 */
- (void) setSearchText:(NSString*)v_strSearchText
{
    m_strSearchText = v_strSearchText;
    if(m_strSearchText != nil){
        m_bIsSearchViewMode = YES;
        m_strNavTitle = @"搜索";
    } else {
        m_bIsSearchViewMode = NO;
    }
}
/** 是否是打开推荐菜单，如果设置这个，则设置菜系ID和搜索关键字都无效，显示前设置 */
- (void) setIsOpenRecommendDish:(BOOL)v_bIsRecommend
{
    m_bIsReommecdDish = v_bIsRecommend;
    m_strNavTitle = @"推荐菜单";
}
/** 添加新菜，v_dishItem里面ID为空 */
- (void) addNewDish:(DishItem*)v_dishItem
{
    BOOL bAdd = [m_dishManager addDishWithDishName:[v_dishItem getDishName]
                                      _dishImgPath:[v_dishItem getDishIconImgPath]
                                   _dishDescrition:[v_dishItem getDishDescrition]
                                      _dishStyleID:[v_dishItem getDishStyleID]
                                    _dishStyleName:[v_dishItem getDishStyleName]
                                        _dishPrice:[v_dishItem getDishPrice]
                                      _isRecommend:[v_dishItem getIsDishRecommend]];
    if(bAdd == YES){
        [self initMainView];
        [self addAllViewToViewController];
    }
}

/** 编辑菜 */
- (void) updateDish:(DishItem*)v_dishItem
{
    BOOL bUpdate =  [m_dishManager updateDishWithDishItem:v_dishItem];
    if(bUpdate == YES){
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
        case ViewTag_NavRightBtn:{ // 导航栏右键：同步管理
            if(m_bIsEditing == YES){
                [self setEditMode:NO];
            } else {
                if(m_delegate != nil){
                    BOOL bTemp = [m_delegate respondsToSelector:@selector(openViewControllerOfDishListOfSelectedFromDishListWithDeskItem:_sender:)];
                    if(bTemp == YES){
                        [m_delegate openViewControllerOfDishListOfSelectedFromDishListWithDeskItem:m_deskItem
                                                                                            _sender:self];
                    }
                }
            }
            break;
        }
        case ViewTag_AddDish:{ // 添加菜
            if(m_delegate != nil){
                BOOL bTemp = [m_delegate respondsToSelector:@selector(openNewDishViewController_dishStyleID:_dishStyleName: _isRecommend: _sender:)];
                if(bTemp == YES){
                    [m_delegate openNewDishViewController_dishStyleID:m_strDishStyleID
                                                       _dishStyleName:m_strDishStyleName
                                                         _isRecommend:m_bIsReommecdDish
                                                              _sender:self];
                }
            }
            break;
        }
        case ViewTag_EditSwitch:{ // 控制 编辑开关
            [self setEditMode:!m_bIsEditing];
            break;
        }
    }
}

// ==============================================================================================
#pragma mark - 委托协议DishItemViewDelegate
/** 点击选择按钮 */
- (void) clickSelectBtn_sender:(id)v_sender
{
    if(m_bIsEditing != YES){
        DishItemView *itemView = v_sender;
        [itemView setIsSelected:![itemView getIsSelected]];
        DishItem *dishItem = [itemView getDishItem];
        if([itemView getIsSelected] == YES){
            BOOL bTemp = [[DishOfSelectedManager SharedDishOfSelectedManagerObj] addDishOfSelectedWithDishItem:dishItem _deskID:[m_deskItem getDeskID]];
            NSLog(@"%i", bTemp);
        } else {
            BOOL bTemp =  [[DishOfSelectedManager SharedDishOfSelectedManagerObj] deleteDishOfSelectedForDishItem:dishItem _deskID:[m_deskItem getDeskID]];
            NSLog(@"%i", bTemp);
        }
   
    } else { // 编辑状态下不能选菜
    
    }
}

/** 点击打开View详情 */
- (void) clickItemViewDetails_sender:(id)v_sender
{
    DishItemView *itemView = v_sender;
    DishItem *dishItem = [itemView getDishItem];
    int index = (int)itemView.tag;
    if(m_bIsEditing != YES){ // 编辑状态下
        if(m_delegate != nil){
            BOOL bTemp = [m_delegate respondsToSelector:@selector(openDishDetailsViewControllerWithDishList:_aryIndex: _sender:)];
            if(bTemp == YES){
                [m_delegate openDishDetailsViewControllerWithDishList:m_aryDishList
                                                            _aryIndex:index
                                                              _sender:self];
            }
        }
    } else {
        if(m_delegate != nil){
            BOOL bTemp = [m_delegate respondsToSelector:@selector(openEditDishViewControllerWithDishItem: _sender:)];
            if(bTemp == YES){
                [m_delegate openEditDishViewControllerWithDishItem:dishItem _sender:self];
            }
        }
    }
}
// ==============================================================================================
#pragma mark - 委托定义View_SearchDelegate
/** 确定搜索的关键字 */
- (void) commitSearch:(NSString*)v_strSearch
{
    m_strSearchText = v_strSearch;
    [self initMainView];
    [self addAllViewToViewController];
}
@end