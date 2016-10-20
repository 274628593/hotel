//
//  ViewController_selectDishTypeName.m
//  HotelSystem
//
//  Created by LHJ on 16/3/19.
//  Copyright © 2016年 hancj. All rights reserved.
//

#import "ViewController_selectDishTypeName.h"
#import "CPublic.h"
#import "NameOfDishStyleManager.h"

#define Font_Title  Font(20.0f)
#define Color_Title Color_RGB(30, 30, 30)

typedef enum : int{
    ViewTag_AddDishStyle = 1, /* 添加菜系分类 */
    ViewTag_NavRightBtn_OpenEdit, /* 导航栏右边按键-开启编辑 */
    ViewTag_NavRightBtn_CloseEdit, /* 导航栏右边按键-关闭编辑 */
}ViewTag;

@implementation ViewController_selectDishTypeName
{
    NameOfDishStyleManager      *m_nameOfDishStyleManager;
    UITableView                 *m_tvList;
    UIView                      *m_viewOfTvHead;
    NSArray<DishStyleNameItem*> *m_aryDishStyleNameItemList;
    NSArray<UIView*>            *m_aryCellViewList;
    BOOL                        m_bIsEdit;
    UIImageView                 *m_imgViewIconOfSelected;
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
    [self initCellViewListOfTv];
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
    [self initNavRightBtnItem:m_bIsEdit];
}
- (void) initNavRightBtnItem:(BOOL)v_bIsEdit
{
    if(v_bIsEdit != YES){
        UIBarButtonItem *barBtnItem = [[UIBarButtonItem alloc]initWithTitle:@"编辑"
                                                                      style:UIBarButtonItemStyleDone
                                                                     target:self
                                                                     action:@selector(clickBtn:)];
        [barBtnItem setTag:ViewTag_NavRightBtn_OpenEdit];
        self.navigationItem.rightBarButtonItem = barBtnItem;
    
    } else {
        UIBarButtonItem *barBtnItem = [[UIBarButtonItem alloc]initWithTitle:@"关闭"
                                                                      style:UIBarButtonItemStyleDone
                                                                     target:self
                                                                     action:@selector(clickBtn:)];
        [barBtnItem setTag:ViewTag_NavRightBtn_CloseEdit];
        self.navigationItem.rightBarButtonItem = barBtnItem;
    }
}
/** 初始化数据 */
- (void) initData
{
    m_bIsEdit = NO;
    m_nameOfDishStyleManager = [NameOfDishStyleManager new];
    m_aryDishStyleNameItemList = [m_nameOfDishStyleManager getNameOfDishStyleItemList];
}

/** 初始化所有视图View */
- (void) initMainView
{
    if(m_tvList == nil) {
        UITableView *tvList = [UITableView new];
        [tvList setBackgroundColor:Color_Transparent];
        [tvList setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [tvList setDataSource:(id)self];
        [tvList setDelegate:(id)self];
        m_tvList = tvList;
    }
    
    m_viewOfTvHead = [self getHeadViewOfTv];
    if(m_imgViewIconOfSelected == nil){
        float h_add = m_viewOfTvHead.bounds.size.height/2;
        float w_add = h_add;
        float y_add = (m_viewOfTvHead.bounds.size.height - h_add)/2;
        float x_add = m_viewOfTvHead.bounds.size.width - w_add - 20;
        m_imgViewIconOfSelected = [UIImageView new];
        [m_imgViewIconOfSelected setFrame:CGRectMake(x_add, y_add, w_add, h_add)];
        [m_imgViewIconOfSelected setUserInteractionEnabled:NO];
        [m_imgViewIconOfSelected setBackgroundColor:Color_Transparent];
        [m_imgViewIconOfSelected setContentMode:UIViewContentModeScaleToFill];
        [m_imgViewIconOfSelected setTag:-1];
        [m_imgViewIconOfSelected setImage:GetImg(@"mainview_selected")];
    }
}

/** 将所有View添加到控制中显示 */
- (void) addAllViewToViewController
{
    UIView *viewMain = self.view;
    [viewMain setBackgroundColor:[UIColor whiteColor]];
    
    float x_add = 0;
    float y_add = 0;
    float w_add = viewMain.bounds.size.width - x_add;
    float h_add = viewMain.bounds.size.height - y_add;
    [m_tvList setFrame:CGRectMake(x_add, y_add, w_add, h_add)];
    [viewMain addSubview:m_tvList];
    
    if(m_bIsEdit == YES){
        m_tvList.tableHeaderView = m_viewOfTvHead;
    }
}
/** 获取列表头View */
- (UIView*) getHeadViewOfTv
{
    UIView *viewRS = [UIView new];
    [viewRS setBackgroundColor:Color_RGB(255, 255, 255)];
    [viewRS setUserInteractionEnabled:YES];
    
    UIView *viewMain = self.view;
    float x_viewRS = 0;
    float y_viewRS = 0;
    float w_viewRS = viewMain.bounds.size.width;
    float h_viewRS = 0;
    
    UIFont *fontTitle = Font_Title;
    UIColor *colorTitle = Color_Title;
    float x_add = 0;
    float y_add = 0;
    float w_add = w_viewRS;
    float h_add = 0;
    UIView *viewAddDishStyleName = [self getCellView_frame:CGRectMake(x_add, y_add, w_add, h_add)
                                                     _name:@"添加"
                                                     _font:fontTitle
                                                _colorOfTx:colorTitle];
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self
                                                                            action:@selector(handleTapGes:)];
    [viewAddDishStyleName setTag:ViewTag_AddDishStyle];
    [viewAddDishStyleName addGestureRecognizer:tapGes];
    [viewRS addSubview:viewAddDishStyleName];
    y_add += viewAddDishStyleName.frame.size.height;
    
    h_viewRS = y_add;
    [viewRS setFrame:CGRectMake(x_viewRS, y_viewRS, w_viewRS, h_viewRS)];
    
    return viewRS;
}
/** 获取线条View */
- (UIView*) getLineView:(CGRect)v_frame
{
    UIView *viewRS = [UIView new];
    [viewRS setFrame:v_frame];
    [viewRS setBackgroundColor:Color_RGBA(200, 200, 200, 0.6)];
    [viewRS setUserInteractionEnabled:NO];
    return viewRS;
}
/** 获取列表项View */
- (UIView*) getCellView_frame:(CGRect)v_frame
                        _name:(NSString*)v_strName
                        _font:(UIFont*)v_font
                   _colorOfTx:(UIColor*)v_colorTx
{
    const float space_y = 20;
    const float space_x = 20;
    float h_tx = [CPublic getTextHeight:@"高" _font:v_font];
    h_tx += space_y*2;
    
    v_frame.size.height = h_tx;
    UIView *viewRS = [UIView new];
    [viewRS setFrame:v_frame];
    [viewRS setUserInteractionEnabled:YES];
    [viewRS setBackgroundColor:Color_RGB(255, 255, 255)];

    float x_add = space_x;
    float y_add = 0;
    float w_add = viewRS.bounds.size.width - x_add - space_x;
    float h_add = viewRS.bounds.size.height;
    UILabel *labName = [UILabel new];
    [labName setFrame:CGRectMake(x_add, y_add, w_add, h_add)];
    [labName setBackgroundColor:Color_Transparent];
    [labName setText:v_strName];
    [labName setTextAlignment:NSTextAlignmentLeft];
    [labName setTextColor:v_colorTx];
    [labName setFont:v_font];
    [labName setNumberOfLines:1];
    [viewRS addSubview:labName];
    
    float h_line = 1;
    float x_line = labName.frame.origin.x;
    float w_line = viewRS.bounds.size.width - x_line - 10;
    float y_line = viewRS.bounds.size.height - h_line;
    UIView *viewLine = [self getLineView:CGRectMake(x_line, y_line, w_line, h_line)];
    [viewRS addSubview:viewLine];
    
    return viewRS;
}
/** 把菜系名列表初始化为TableView的CellView列表 */
- (void) initCellViewListOfTv
{
    float w_add = self.view.bounds.size.width;

    UIFont *fontTitle = Font_Title;
    UIColor *colorTitle = Color_Title;
    NSMutableArray<UIView*> *muAryCellView = [NSMutableArray<UIView*> new];
    for(DishStyleNameItem *item in m_aryDishStyleNameItemList)
    {
        UIView *viewCell = [self getCellView_frame:CGRectMake(0, 0, w_add, 0)
                                                         _name:[item getDishStyleNameItemName]
                                                         _font:fontTitle
                                                    _colorOfTx:colorTitle];
        [muAryCellView addObject:viewCell];
    }
    m_aryCellViewList = muAryCellView;
}
/** 更新列表 */
- (void) updateTvList
{
    m_aryDishStyleNameItemList = [m_nameOfDishStyleManager getNameOfDishStyleItemList];
    [self initCellViewListOfTv];
    [m_tvList reloadData];
}
// ==================================================================================
#pragma mark - 外部调用方法
/** 更新菜系名 */
- (BOOL) updateDishStyleNameItem:(DishStyleNameItem*)v_item
{
    BOOL bRs = [m_nameOfDishStyleManager addDishStyleNameWithItem:v_item];
    if(bRs == YES){
        [self updateTvList];
    }
    return bRs;
}

/** 添加菜系名 */
- (BOOL) addDishStyleNameItem:(NSString*)v_strName
{
    BOOL bIsHave = [m_nameOfDishStyleManager isHaveThisNameOfDishStyle:v_strName];
    
    BOOL bRS = NO;
    if(bIsHave != YES){
        bRS = [m_nameOfDishStyleManager addDishStyleName_name:v_strName];
    }
    if(bRS == YES){
        [self updateTvList];
    }
    return bRS;
}

// ==================================================================================
#pragma mark - 动作触发方法
/** Button按钮点击事件 */
- (void) clickBtn:(id)v_sender
{
    UIView *view = (UIView*)v_sender;
    switch((ViewTag)view.tag){
        case ViewTag_NavRightBtn_OpenEdit:{ // 导航栏右键 - 打开编辑
            m_bIsEdit = YES;
            __weak typeof(m_tvList) weakTvList = m_tvList;
            __weak typeof(m_viewOfTvHead) weakHeadView = m_viewOfTvHead;
            [UIView animateWithDuration:0.3f animations:^{
                weakTvList.tableHeaderView = weakHeadView;
            }];
            [self initNavRightBtnItem:m_bIsEdit];
            
            break;
        }
        case ViewTag_NavRightBtn_CloseEdit:{ // 导航栏右键 - 关闭编辑
            m_bIsEdit = NO;
            __weak typeof(m_tvList) weakTvList = m_tvList;
            [UIView animateWithDuration:0.3f animations:^{
                weakTvList.tableHeaderView = nil;
            }];
            [self initNavRightBtnItem:m_bIsEdit];
        }
        default:{
            break;
        }
    }
}
/** 处理手势单击的事件 */
- (void) handleTapGes:(UITapGestureRecognizer*)v_ges
{
    UIView *view = [v_ges view];
    switch((ViewTag)view.tag){
        case ViewTag_AddDishStyle:{ // 添加菜系分类
            if(m_delegate != nil){
                BOOL bTemp = [m_delegate respondsToSelector:@selector(openViewControllerOfAddDishStyleName)];
                if(bTemp == YES){
                    [m_delegate openViewControllerOfAddDishStyleName];
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
#pragma mark -  委托协议UITableViewDataSource, UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (m_aryCellViewList != nil)? m_aryCellViewList.count : 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIView *view = [m_aryCellViewList objectAtIndex:indexPath.row];
    return view.bounds.size.height;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *strCellID = @"TableViewCellView";
    UITableViewCell *tvCellView = [tableView dequeueReusableCellWithIdentifier:strCellID];
    if(tvCellView == nil){
        tvCellView = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strCellID];
        [tvCellView setSelectionStyle:UITableViewCellSelectionStyleNone];
        [tvCellView setBackgroundColor:Color_Transparent];
    }
    for(UIView *viewChild in [tvCellView.contentView subviews]){
        [viewChild removeFromSuperview];
    }
    UIView *viewCell = [m_aryCellViewList objectAtIndex:indexPath.row];
    [tvCellView.contentView addSubview:viewCell];
    
    return tvCellView;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    DishStyleNameItem *item = [m_aryDishStyleNameItemList objectAtIndex:indexPath.row];
    if(m_bIsEdit == YES){
        if(m_delegate != nil){
            BOOL bTemp = [m_delegate respondsToSelector:@selector(openViewControllerOfEditDishStyleName:)];
            if(bTemp == YES){
                [m_delegate openViewControllerOfEditDishStyleName:item];
            }
        }
    } else {
        int row = (int)indexPath.row;
        int indexOfSelected = (int)[m_imgViewIconOfSelected tag];
        if(indexOfSelected != row){
            UIView *viewCell = [m_aryCellViewList objectAtIndex:indexPath.row];
            [viewCell addSubview:m_imgViewIconOfSelected];
            [m_imgViewIconOfSelected setTag:row];
        
        } else {
            [m_imgViewIconOfSelected removeFromSuperview];
            [m_imgViewIconOfSelected setTag:-1];
        }
        if(m_delegate != nil){
            BOOL bTemp = [m_delegate respondsToSelector:@selector(getDishStyleNameItemOfSelectResult: _sender:)];
            if(bTemp == YES){
                [m_delegate getDishStyleNameItemOfSelectResult:item _sender:self];
            }
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
