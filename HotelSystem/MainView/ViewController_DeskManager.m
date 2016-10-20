//
//  ViewController_DeskManager.m
//  HotelSystem
//
//  Created by LHJ on 16/3/16.
//  Copyright © 2016年 hancj. All rights reserved.
//

#import "ViewController_DeskManager.h"
#import "DeskManager.h"
#import "CPublic.h"

typedef enum : int{
    ViewTag_NavRightBtn = 1, /* 导航栏右边按键 */
    ViewTag_AddDesk, /* 添加桌子 */
    ViewTag_EditSwitch, /* 控制编辑开关的按钮 */
}ViewTag;

@implementation ViewController_DeskManager
{
    DeskManager                     *m_deskManager;
    NSArray<DeskItem*>              *m_aryDeskList;
    int                             m_colsOfEveryRow;
    NSMutableArray<DeskItemView*>   *m_muAryDeskItemView;
    UIButton                        *m_btnAddDesk;
    UIButton                        *m_btnEditSwitch;
    UIScrollView                    *m_scrollViewMain;
    BOOL                            m_bIsEditing;
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
#pragma mark - 内部使用方法
/** 初始化导航栏 */
- (void) initNavView
{
    self.navigationItem.title = @"酒店系统";
    
    UIBarButtonItem *barBtnItem = [[UIBarButtonItem alloc]initWithTitle:@"同步功能"
                                                                  style:UIBarButtonItemStyleDone
                                                                 target:self
                                                                 action:@selector(clickBtn:)];
    [barBtnItem setTag:ViewTag_NavRightBtn];
    self.navigationItem.rightBarButtonItem = barBtnItem;
}
/** 初始化数据 */
- (void) initData
{
    m_deskManager = [DeskManager SharedDeskManagerObj];
    m_colsOfEveryRow = 5;
    m_bIsEditing = NO;
}
/** 初始化所有视图View */
- (void) initMainView
{
    UIView *viewMain = self.view;
    [viewMain setBackgroundColor:[UIColor whiteColor]];
    
    m_aryDeskList = [m_deskManager getDeskItemList];
    const float space_y = 20;
    const float space_x = 30;
    const float cornerRadius = 6.0f;
    UIFont *fontDeskItemView = Font_Bold(22);
    UIColor *colorDeskItemView = Color_RGB(60, 60, 60);
    float w_add = (viewMain.bounds.size.width - space_x*(m_colsOfEveryRow+2))/m_colsOfEveryRow;
    float h_add = w_add;
    float x_add = space_x;
    float y_add = space_y;
    
    int colIndex = 0;
    int rowIndex = 0;
    NSMutableArray<DeskItemView*> *muAryView = [NSMutableArray<DeskItemView*> new];
    for(int i=0; i<m_aryDeskList.count+1; i+=1){
        x_add = (colIndex * w_add) + space_x*(colIndex+1);
        y_add = (rowIndex * h_add) + space_y*(rowIndex+1);
        if(i == m_aryDeskList.count){ // 添加按钮
            if(m_btnAddDesk == nil){
                m_btnAddDesk = [self getBtnAddDesk_frame:CGRectMake(x_add, y_add, w_add, h_add)
                                                    _tag:ViewTag_AddDesk
                                            _layerCorner:cornerRadius];
            } else {
                [m_btnAddDesk setFrame:CGRectMake(x_add, y_add, w_add, h_add)];
            }
            continue;
        }
        
        DeskItem *deskItem = [m_aryDeskList objectAtIndex:i];
        DeskItemView *deskItemView = nil;
        if(i<m_muAryDeskItemView.count){
            deskItemView = [m_muAryDeskItemView objectAtIndex:i];
        } else {
            deskItemView = [DeskItemView new];
            [deskItemView setCornerRadius:cornerRadius];
            [deskItemView setTextFont:fontDeskItemView];
            [deskItemView setTextColor:colorDeskItemView];
            [deskItemView setDelegate:(id)self];
        }
        [deskItemView setFrame:CGRectMake(x_add, y_add, w_add, h_add)];
        [deskItemView setDeskItemNum:[deskItem getDeskNum]];
        [muAryView addObject:deskItemView];
        
        colIndex += 1;
        if(colIndex >= m_colsOfEveryRow){ // 增加一行
            colIndex = 0;
            rowIndex += 1;
        }
    }
    if(m_muAryDeskItemView != nil){
        for(DeskItemView *itemView in m_muAryDeskItemView){
            [itemView removeFromSuperview];
        }
        [m_muAryDeskItemView removeAllObjects];
        m_muAryDeskItemView = nil;
    }
    m_muAryDeskItemView = muAryView;
    
    // ====== 控制编辑开关的按钮 ======
    if(m_btnEditSwitch == nil){
        UIFont *fontBtnTitle = Font_Bold(22);
        float value = self.navigationController.navigationBar.frame.size.height + Height_StatusBar;
        h_add = [CPublic getTextHeight:@"高" _font:fontBtnTitle];
        w_add = viewMain.bounds.size.width;
        x_add = 0;
        y_add = viewMain.bounds.size.height - h_add - value;
        m_btnEditSwitch = [self getBtnEditSwitch_frame:CGRectMake(x_add, y_add, w_add, h_add)
                                                  _tag:ViewTag_EditSwitch
                                            _fontTitle:fontBtnTitle];
    }
    if(m_scrollViewMain == nil){
        CGRect frameScrollView = viewMain.bounds;
        frameScrollView.size.height = m_btnEditSwitch.frame.origin.y - frameScrollView.origin.y;
        m_scrollViewMain = [UIScrollView new];
        [m_scrollViewMain setFrame:frameScrollView];
        [m_scrollViewMain setBackgroundColor:Color_Transparent];
    }
    
    float content_y = m_btnAddDesk.frame.origin.y + m_btnAddDesk.frame.size.height + space_y;
    [m_scrollViewMain setContentSize:CGSizeMake(m_scrollViewMain.contentSize.width, content_y)];
}
/** 将所有View添加到控制中显示 */
- (void) addAllViewToViewController
{
    UIView *viewMain = self.view;
    [viewMain addSubview:m_scrollViewMain];
    
    for(UIView *view in m_muAryDeskItemView){
        [m_scrollViewMain addSubview:view];
    }
    [m_scrollViewMain addSubview:m_btnAddDesk];
    [viewMain addSubview:m_btnEditSwitch];
}

/** 返回添加桌子的添加按钮 */
- (UIButton*) getBtnAddDesk_frame:(CGRect)v_frame
                             _tag:(ViewTag)v_viewTag
                     _layerCorner:(float)v_corner;
{
    UIButton *btnRS = [UIButton new];
    [btnRS setFrame:v_frame];
    [btnRS setBackgroundColor:Color_RGB(30, 200, 120)];
    [btnRS setTag:v_viewTag];
    [btnRS.layer setCornerRadius:v_corner];
    [btnRS setClipsToBounds:YES];
    [btnRS addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    return btnRS;
}
/** 获取控制编辑开关的按钮 */
- (UIButton*) getBtnEditSwitch_frame:(CGRect)v_frame
                                _tag:(ViewTag)v_viewTag
                             _fontTitle:(UIFont*)v_fontTitle
{
    UIButton *btnRS = [UIButton new];
    [btnRS setFrame:v_frame];
    [btnRS setBackgroundColor:Color_RGB(30, 200, 120)];
    [btnRS setTag:v_viewTag];
    [btnRS setTitle:@"编辑开关：关" forState:UIControlStateNormal];
    [btnRS setTitle:@"编辑开关：开" forState:UIControlStateSelected];
    [btnRS setTitleColor:Color_RGB(255, 255, 255) forState:UIControlStateNormal];
    [btnRS.titleLabel setFont:v_fontTitle];
    [btnRS setClipsToBounds:YES];
    [btnRS addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    return btnRS;
}
/** 显示添加新桌子的对话框View */
- (void) showDialogViewOfAddDesk
{
    DialogView_AddDeskItem *dialogView = [DialogView_AddDeskItem new];
    [dialogView setDelegate:(id)self];
    [dialogView showDialog];
}
/** 根据桌子号获取对应的桌子项对象 */
- (DeskItem*) getDeskItemWithDeskNum:(int)v_deskNum
{
    DeskItem *itemRS = nil;
    for(DeskItem *itemObj in m_aryDeskList){
        if([itemObj getDeskNum] == v_deskNum){
            itemRS = itemObj;
            break;
        }
    }
    return itemRS;
}
- (void) setEditMode:(BOOL)v_bIsEdit
{
    m_bIsEditing = v_bIsEdit;
    [m_btnEditSwitch setSelected:m_bIsEditing];
    if(m_delegate != nil){
        BOOL bTemp = [m_delegate respondsToSelector:@selector(setEditEnable:)];
        if(bTemp == YES){
            [m_delegate setEditEnable:m_bIsEditing];
        }
    }
}
// ==================================================================================
#pragma mark - 外部调用方法

// ==================================================================================
#pragma mark - 动作触发方法
/** Button按钮点击事件 */
- (void) clickBtn:(id)v_sender
{
    UIView *view = (UIView*)v_sender;
    switch((ViewTag)view.tag){
        case ViewTag_NavRightBtn:{ // 导航栏右键：同步管理
            if(m_delegate != nil){
                [m_delegate openShareDataViewController:self];
            }
            break;
        }
        case ViewTag_AddDesk:{ // 添加桌子
            [self showDialogViewOfAddDesk];
            break;
        }
        case ViewTag_EditSwitch:{ // 控制 编辑开关
            [self setEditMode:!m_bIsEditing];
            break;
        }
    }
}
// ==============================================================================================
#pragma mark - 委托协议DeskItemViewDelegate
/** 点击桌子项 */
- (void) clickDeskItem:(id)v_sender
{
    DeskItemView *itemView = v_sender;
    int deskNum = [itemView getDeskItemNum];
    DeskItem *deskItem = [self getDeskItemWithDeskNum:deskNum];
    
    if(m_delegate != nil){
        BOOL bTemp = [m_delegate respondsToSelector:@selector(openDiskTypeView_deskItem:_sender:)];
        if(bTemp == YES){
            [m_delegate openDiskTypeView_deskItem:deskItem _sender:self];
        }
    }
}

/** 删除桌子项 */
- (void) removeDeskItemView:(id)v_sender
{

}
// ==============================================================================================
#pragma mark 委托协议DialogView_AddDeskItemDelegate
/** 确定添加桌子项 */
- (void) commitAddDeskItem:(int)v_deskNum _sender:(id)v_sender;
{
    if([m_deskManager isHaveTheDeskOfDeskNum:v_deskNum] == YES){
        [CPublic ShowDialgController:@"这个桌号现在还在用餐" _viewController:self];
        return;
    } else {
        BOOL bAdd = [m_deskManager addDeskWithDeskNum:v_deskNum];
        if(bAdd == YES){
            dispatch_queue_t mainQueue= dispatch_get_main_queue();
            __weak typeof(self) weakSelf = self;
            dispatch_async(mainQueue, ^{
                [weakSelf initMainView];
                [weakSelf addAllViewToViewController];
            });
        }
        [(UIView*)v_sender removeFromSuperview];
    }
}

@end
