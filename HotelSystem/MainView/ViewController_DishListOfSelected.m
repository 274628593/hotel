//
//  ViewController_DishListOfSelected.m
//  HotelSystem
//
//  Created by LHJ on 16/3/28.
//  Copyright © 2016年 hancj. All rights reserved.
//

#import "ViewController_DishListOfSelected.h"
#import "CPublic.h"
#import "DeskItem.h"
#import "DishOfSelectedManager.h"
#import "DishItemOfSelected.h"

#define FontHeadText    Font(22.0f)
#define ColorHeadText   Color_RGB(120, 120, 120)
#define FontBottomText  Font(24.0f)

typedef enum : int{
    ViewTag_NavRightBtn = 1, /* 导航栏右键 */
    ViewTag_Finish, /* 完成结账 */
}ViewTag;

@implementation ViewController_DishListOfSelected
{
    DishOfSelectedManager       *m_dishOfSelectedManager;
    UITableView                 *m_tvList;
    UIView                      *m_viewOfHead;
    NSArray                     *m_aryViewScale;
    UILabel                     *m_labDishName;
    UILabel                     *m_labDishPrice;
    UILabel                     *m_labDishDiscount;
    UILabel                     *m_labDishNum;
    UILabel                     *m_labDiscountName;
    
    UIView                      *m_viewBottom;
    UIButton                    *m_btnFinish;
    EditViewWithIcon            *m_editViewDiscount;
    float                       m_discount;
    UILabel                     *m_labCost;
    
    NSArray<DishItemOfSelected*>            *m_aryDishItemOfSelectedList;
    NSMutableArray<CellViewOfDishItemOfSelected*>  *m_muAryCellViewList;
}
@synthesize m_delegate;
@synthesize m_tag;
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
    [self initCellViewListOfTv];
}
- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
- (void) viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    [self addAllViewToViewController];
    [self updateAllDishCost];
}
// ==================================================================================
#pragma mark - 内部调用方法
/** 初始化导航栏 */
- (void) initNavView
{
    self.navigationItem.title = @"已选菜单";
    UIBarButtonItem *barBtnItem = [[UIBarButtonItem alloc]initWithTitle:@"再去选菜"
                                                                  style:UIBarButtonItemStyleDone
                                                                 target:self
                                                                 action:@selector(clickBtn:)];
    [barBtnItem setTag:ViewTag_NavRightBtn];
    self.navigationItem.rightBarButtonItem = barBtnItem;
}
/** 初始化数据 */
- (void) initData
{
    m_discount = 1.0f;
    m_dishOfSelectedManager = [DishOfSelectedManager new];
    m_aryViewScale = @[@(2), @(1), @(1), @(1), @(0.5)];
}
/** 初始化头部View，表现为列表头部索引 */
- (void) initHeadView
{
    if(m_viewOfHead == nil){
        UIView *view = [UIView new];
        [view setBackgroundColor:Color_RGB(255, 255, 255)];
        [view.layer setBorderColor:Color_RGB(120, 120, 120).CGColor];
        [view.layer setBorderWidth:1.f];
        m_viewOfHead = view;
    }
    if(m_labDishName == nil){
        UILabel *lab = [UILabel new];
        [lab setBackgroundColor:Color_Transparent];
        [lab setNumberOfLines:1];
        [lab setFont:FontHeadText];
        [lab setTextAlignment:NSTextAlignmentCenter];
        [lab setTextColor:ColorHeadText];
        [lab setLineBreakMode:NSLineBreakByTruncatingTail];
        [lab setText:@"菜名"];
        m_labDishName = lab;
    }
    if(m_labDishPrice == nil){
        UILabel *lab = [UILabel new];
        [lab setBackgroundColor:Color_Transparent];
        [lab setNumberOfLines:1];
        [lab setFont:FontHeadText];
        [lab setTextAlignment:NSTextAlignmentCenter];
        [lab setTextColor:ColorHeadText];
        [lab setLineBreakMode:NSLineBreakByTruncatingTail];
        [lab setText:@"费用"];
        m_labDishPrice = lab;
    }
    if(m_labDishDiscount == nil){
        UILabel *lab = [UILabel new];
        [lab setBackgroundColor:Color_Transparent];
        [lab setNumberOfLines:1];
        [lab setFont:FontHeadText];
        [lab setTextAlignment:NSTextAlignmentCenter];
        [lab setTextColor:ColorHeadText];
        [lab setLineBreakMode:NSLineBreakByTruncatingTail];
        [lab setText:@"折扣"];
        m_labDishDiscount = lab;
    }
    if(m_labDishNum == nil){
        UILabel *lab = [UILabel new];
        [lab setBackgroundColor:Color_Transparent];
        [lab setNumberOfLines:1];
        [lab setFont:FontHeadText];
        [lab setTextAlignment:NSTextAlignmentCenter];
        [lab setTextColor:ColorHeadText];
        [lab setLineBreakMode:NSLineBreakByTruncatingTail];
        [lab setText:@"数量"];
        m_labDishNum = lab;
    }
    if(m_labDiscountName == nil){
        UILabel *lab = [UILabel new];
        [lab setBackgroundColor:Color_Transparent];
        [lab setNumberOfLines:1];
        [lab setFont:FontHeadText];
        [lab setTextAlignment:NSTextAlignmentCenter];
        [lab setTextColor:ColorHeadText];
        [lab setLineBreakMode:NSLineBreakByTruncatingTail];
        [lab setText:@"折扣："];
        m_labDiscountName = lab;
    }
}
/** 初始化顶部操作栏，包括结算按钮和用餐费用显示 */
- (void) initBottomView
{
    if(m_viewBottom == nil){
        UIView *view = [UIView new];
        [view setBackgroundColor:Color_RGB(230, 230, 230)];
        [view.layer setBorderColor:Color_RGBA(120, 120, 120, 0.4f).CGColor];
        [view.layer setBorderWidth:1.f];
        m_viewBottom = view;
    }
    if(m_btnFinish == nil){
        UIButton *btn = [UIButton new];
        [btn setBackgroundColor:Color_RGB(30, 200, 100)];
        [btn setTitle:@"完成" forState:UIControlStateNormal];
        [btn setTitleColor:Color_RGB(255, 255, 255) forState:UIControlStateNormal];
        [btn.titleLabel setFont:Font_Bold(24.0)];
        [btn setTag:ViewTag_Finish];
        [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        m_btnFinish = btn;
    }
    if(m_editViewDiscount == nil){
        EditViewWithIcon *editView = [EditViewWithIcon new];
        [editView setBackgroundColor:Color_Transparent];
        [editView setTxFont:FontBottomText];
        [editView setTxColor:Color_RGB(30, 30, 30)];
        [editView setDelegate:(id)self];
        [editView setIsShowBorderLine:YES];
        [editView setIsInputOnlyNum:YES];
        [editView setKeyboardType:UIKeyboardTypeNumberPad];
        m_editViewDiscount = editView;
    }
    if(m_labCost == nil){
        UILabel *lab = [UILabel new];
        [lab setBackgroundColor:Color_Transparent];
        [lab setNumberOfLines:1];
        [lab setFont:FontBottomText];
        [lab setTextAlignment:NSTextAlignmentRight];
        [lab setTextColor:Color_RGB(230, 120, 30)];
        [lab setLineBreakMode:NSLineBreakByTruncatingTail];
        m_labCost = lab;
    }
}
/** 初始化所有视图View */
- (void) initMainView
{
    [self initHeadView];
    [self initBottomView];
    
    if(m_tvList == nil) {
        UITableView *tvList = [UITableView new];
        [tvList setBackgroundColor:Color_Transparent];
        [tvList setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [tvList setDataSource:(id)self];
        [tvList setDelegate:(id)self];
        m_tvList = tvList;
    }
}
/** 将所有View添加到控制中显示 */
- (void) addAllViewToViewController
{
    UIView *viewMain = self.view;
    [viewMain setBackgroundColor:[UIColor whiteColor]];
    
    const float h_headView = [CPublic getTextHeight:@"高" _font:FontHeadText]*12/10;
    const float h_bottomView = [CPublic getTextHeight:@"高" _font:FontBottomText]*12/10;
    float x_add = 0;
    float y_add = 0;
    float w_add = viewMain.bounds.size.width - x_add;
    float h_add = h_headView;
    if(m_viewOfHead != nil){ // 顶部列表索引栏
        [m_viewOfHead setFrame:CGRectMake(x_add, y_add, w_add, h_add)];
        [viewMain addSubview:m_viewOfHead];
        int index = 0;
        float scaleValue = m_viewOfHead.bounds.size.width / m_aryViewScale.count;
        float x_child = 0;
        float y_child = 0;
        float h_child = m_viewOfHead.bounds.size.height;
        float w_child = scaleValue * [(NSNumber*)[m_aryViewScale objectAtIndex:index++] intValue];
        
        if(m_labDishName != nil){ // 菜名
            [m_labDishName setFrame:CGRectMake(x_child, y_child, w_child, h_child)];
            [m_viewOfHead addSubview:m_labDishName];
        }
        x_child += m_labDishName.frame.size.width;
        w_child = scaleValue * [(NSNumber*)[m_aryViewScale objectAtIndex:index++] intValue];
        if(m_labDishPrice != nil){ // 菜价格
            [m_labDishPrice setFrame:CGRectMake(x_child, y_child, w_child, h_child)];
            [m_viewOfHead addSubview:m_labDishPrice];
        }
        x_child += m_labDishPrice.frame.size.width;
        w_child = scaleValue * [(NSNumber*)[m_aryViewScale objectAtIndex:index++] intValue];
        if(m_labDishDiscount != nil){ // 菜折扣
            [m_labDishDiscount setFrame:CGRectMake(x_child, y_child, w_child, h_child)];
            [m_viewOfHead addSubview:m_labDishDiscount];
        }
        x_child += m_labDishPrice.frame.size.width;
        w_child = scaleValue * [(NSNumber*)[m_aryViewScale objectAtIndex:index++] intValue];
        if(m_labDishNum!= nil){ // 菜数目
            [m_labDishNum setFrame:CGRectMake(x_child, y_child, w_child, h_child)];
            [m_viewOfHead addSubview:m_labDishNum];
        }
    }
    h_add = h_bottomView;
    y_add = viewMain.bounds.size.height - h_add;
    if(m_viewBottom != nil){ // 底部操作栏，用于计算结账
        [m_viewBottom setFrame:CGRectMake(x_add, y_add, w_add, h_add)];
        [viewMain addSubview:m_viewBottom];
        
        const float spaceX_child = 10;
        const float spaceY_child = 10;
        float x_child = spaceX_child;
        float y_child = spaceY_child;
        float h_child = (m_viewBottom.bounds.size.height - y_child - spaceY_child);
        float w_child = h_child*2;
        if(m_btnFinish != nil){ // 完成结账的按钮
            [m_btnFinish setFrame:CGRectMake(x_child, y_child, w_child, h_child)];
            [m_viewBottom addSubview:m_btnFinish];
        }
        if(m_labCost != nil){ // 用餐总费用
//            NSString *strCost = @"总费用：¥88.00";
//            [m_labCost setText:strCost];
            CGSize sizeTemp = [m_labCost sizeThatFits:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
            w_child = sizeTemp.width;
            h_child = m_viewBottom.bounds.size.height;
            x_child = m_viewBottom.bounds.size.width - spaceX_child - w_child;
            y_child = 0;
            [m_labCost setFrame:CGRectMake(x_child, y_child, w_child, h_child)];
            [m_viewBottom addSubview:m_labCost];
        }
        w_child = [CPublic getTextSizeWithLabelSizeToFit:@"1.0000" _font:[m_editViewDiscount getTxFont]].width;
        y_child = spaceY_child;
        h_child = m_viewBottom.bounds.size.height - y_child - spaceY_child;
        x_child = m_viewBottom.bounds.size.width/2;
        if(m_editViewDiscount != nil){ // 折扣的输入框
            [m_editViewDiscount setFrame:CGRectMake(x_child, y_child, w_child, h_child)];
            [m_viewBottom addSubview:m_editViewDiscount];
            NSString *strText = [NSString stringWithFormat:@"%.02f", m_discount];
            [m_editViewDiscount setText:strText];
        }
        CGSize sizeTemp = [m_labDiscountName sizeThatFits:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
        w_child = sizeTemp.width;
        h_child = m_viewBottom.bounds.size.height;
        x_child = m_editViewDiscount.frame.origin.x - w_child;
        y_child = 0;
        if(m_labDiscountName != nil){ //  "折扣"的文字
            [m_labDiscountName setFrame:CGRectMake(x_child, y_child, w_child, h_child)];
            [m_viewBottom addSubview:m_labDiscountName];
        }
    }
    
    // ====== 列表 ======
    y_add = m_viewOfHead.frame.origin.y + m_viewOfHead.frame.size.height;
    h_add = m_viewBottom.frame.origin.y - y_add;
    w_add = viewMain.bounds.size.width;
    x_add = 0;
    [m_tvList setFrame:CGRectMake(x_add, y_add, w_add, h_add)];
    [viewMain addSubview:m_tvList];
}
/** 把菜系名列表初始化为TableView的CellView列表 */
- (void) initCellViewListOfTv
{
    m_aryDishItemOfSelectedList = [m_dishOfSelectedManager getAllDishItemListOfSelectedWithDeskId:[m_deskItem getDeskID]];
    UIFont *fontDishName = Font(24.0);
    UIFont *fontDishPrice = Font(22.0);
    UIFont *fontDishNum = Font(22.0);
    UIColor *colorDishName = Color_RGB(30, 30, 30);
    UIColor *colorDishPrice = Color_RGB(200, 30, 120);
    UIColor *colorDishNum = Color_RGB(120, 120, 120);
    const float h_cellView = [CPublic getTextHeight:@"高" _font:fontDishName]*3.5f;
    const float w_cellView = self.view.bounds.size.width;
    NSMutableArray<CellViewOfDishItemOfSelected*> *muAryCellView = [NSMutableArray<CellViewOfDishItemOfSelected*> new];
    
    for(int i=0; i<m_aryDishItemOfSelectedList.count; i+=1){
        DishItemOfSelected *dishItem = [m_aryDishItemOfSelectedList objectAtIndex:i];
        CellViewOfDishItemOfSelected *cellView = nil;
        if(i < m_muAryCellViewList.count){
            cellView = [m_muAryCellViewList objectAtIndex:i];
        } else {
            cellView = [CellViewOfDishItemOfSelected new];
            [cellView setFrame:CGRectMake(0, 0, w_cellView, h_cellView)];
            [cellView setDelegate:(id)self];
            [cellView setFontDishName:fontDishName];
            [cellView setFontDishNum:fontDishNum];
            [cellView setFontDishPrice:fontDishPrice];
            [cellView setColorDishName:colorDishName];
            [cellView setColorDishNum:colorDishNum];
            [cellView setColorDishPrice:colorDishPrice];
        }
        [cellView setDishItemOfSelected:dishItem];
        [muAryCellView addObject:cellView];
    }
    if(m_muAryCellViewList != nil){
        [m_muAryCellViewList removeAllObjects];
        m_muAryCellViewList = nil;
    }
    m_muAryCellViewList = muAryCellView;
}
/** 更新列表 */
- (void) updateTvList
{
    [self initCellViewListOfTv];
    [m_tvList reloadData];
}
// ==================================================================================
#pragma mark - 动作触发方法
/** Button按钮点击事件 */
- (void) clickBtn:(id)v_sender
{
    UIView *view = (UIView*)v_sender;
    switch((ViewTag)view.tag){
        case ViewTag_NavRightBtn:{ // 导航栏右键
            if(m_delegate != nil){
                BOOL bTemp = [m_delegate respondsToSelector:@selector(openViewControllerOfDishStyleFromDishListSelectedView_deskItem:_sender:)];
                if(bTemp == YES){
                    [m_delegate openViewControllerOfDishStyleFromDishListSelectedView_deskItem:m_deskItem _sender:(id)self];
                }
            }
            break;
        }
        case ViewTag_Finish:{ // 完成结账，把该桌子的用餐信息清空
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
    return (m_muAryCellViewList != nil)? m_muAryCellViewList.count : 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIView *view = [m_muAryCellViewList objectAtIndex:indexPath.row];
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
    UIView *viewCell = [m_muAryCellViewList objectAtIndex:indexPath.row];
    [tvCellView.contentView addSubview:viewCell];
    
    return tvCellView;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

// ==============================================================================================
#pragma mark - 委托协议CellViewOfDishItemOfSelectedDelegate
/** 点击了增加按钮 */
- (void) clickBtn_addDishWithDishItem:(DishItemOfSelected*)v_dishItem _sender:(id)v_sender
{
    [v_dishItem setDishSelectNum:([v_dishItem getDishSelectNum]+1)]; // 已选菜+1
    BOOL bTemp = [self updateDishItemOfSelected:v_dishItem];
    if(bTemp == YES){
        CellViewOfDishItemOfSelected *cellView = v_sender;
        [cellView setDishItemOfSelected:v_dishItem];
        [self updateAllDishCost];
    }
}

/** 点击了减少按钮 */
- (void) clickBtn_reduceDishWithDishItem:(DishItemOfSelected*)v_dishItem _sender:(id)v_sender
{
    [v_dishItem setDishSelectNum:([v_dishItem getDishSelectNum]-1)]; // 已选菜-1
    BOOL bTemp = [self updateDishItemOfSelected:v_dishItem];
    if(bTemp == YES){
        CellViewOfDishItemOfSelected *cellView = v_sender;
        
        if([v_dishItem getDishSelectNum] <= 0){ // 在数据库里面已经删除这道菜，那么在这里则更新列表
//            [self updateTvList];
            m_aryDishItemOfSelectedList = [m_dishOfSelectedManager getAllDishItemListOfSelectedWithDeskId:[m_deskItem getDeskID]];
            NSInteger row = [m_muAryCellViewList indexOfObject:cellView];
            [m_muAryCellViewList removeObject:cellView];
            [m_tvList deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:row inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            
        } else {
            [cellView setDishItemOfSelected:v_dishItem];
        }
        [self updateAllDishCost];
    }
}
/** 确定输入折扣之后 */
- (void) commitNewDiscount:(float)v_discount _dishItem:(DishItemOfSelected*)v_dishItem _sender:(id)v_sender
{
    [v_dishItem setDishPriceDiscount:v_discount];
    BOOL bUpdate = [m_dishOfSelectedManager updateDishOfSelectedWithDishItem:v_dishItem _deskID:[m_deskItem getDeskID]];
    if(bUpdate == YES){
        [self updateAllDishCost];
    }
}
/** 更新已选菜的数量 */
- (BOOL) updateDishItemOfSelected:(DishItemOfSelected*)v_dishItem
{
    return [m_dishOfSelectedManager updateNumOfSelectedForDishID:[v_dishItem getDishID]
                                                         _newNum:[v_dishItem getDishSelectNum]
                                                         _deskID:[m_deskItem getDeskID]];
}
/** 更新所有菜的总价格 */
- (void) updateAllDishCost
{
    dispatch_queue_t globalQueue=dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        //异步执行队列任务
    dispatch_async(globalQueue, ^{
        float cost = 0;
        for(CellViewOfDishItemOfSelected *cellView in m_muAryCellViewList){
            DishItemOfSelected *dishItem = [cellView getDishItemOfSelected];
            cost += ([dishItem getDishPriceDiscount] * [dishItem getDishPrice]) * [dishItem getDishSelectNum];
        }
        cost *= m_discount;
        [self performSelectorOnMainThread:@selector(showCost:) withObject:@(cost) waitUntilDone:NO];
    });
}
/** 将计算好的总价格显示到界面上 */
- (void) showCost:(NSNumber*)v_numCost
{
    float cost = [v_numCost floatValue];
    NSString *strCost = [NSString stringWithFormat:@"总费用：¥%.02f", cost];
    if(m_labCost != nil){
        [m_labCost setText:strCost];
        CGSize size = [m_labCost sizeThatFits:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
        float value = m_labCost.frame.origin.x + m_labCost.frame.size.width;
        CGRect frame = m_labCost.frame;
        frame.origin.x = value - size.width;
        frame.size.width = size.width;
        m_labCost.frame = frame;
    }
}
// ==============================================================================================
#pragma mark -  委托协议EditViewDelegate
/** 确定输入内容之后回调这个方法 */
- (void) commitInput:(NSString*)v_strInputText _sender:(id)v_sender
{
    @try{
        m_discount = [v_strInputText floatValue];
        [self updateAllDishCost];
    }@catch(NSException *e){
        [CPublic ShowDialg:@"输入有误"];
    }
}

@end
