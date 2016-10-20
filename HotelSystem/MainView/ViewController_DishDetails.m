//
//  ViewController_DishDetails.m
//  HotelSystem
//
//  Created by LHJ on 16/3/26.
//  Copyright © 2016年 hancj. All rights reserved.
//

#import "ViewController_DishDetails.h"
#import "CPublic.h"
#import "DishItem.h"
#import "DishOfSelectedManager.h"
#import "DeskItem.h"

typedef enum : int{
    ViewTag_Commit = 1, /* 确定按钮 */
    ViewTag_ImgViewIcon,
    ViewTag_BtnSelect,
}ViewTag;

@implementation ViewController_DishDetails
{
    NSArray<DishItem*>  *m_aryDishItemList;
    int                 m_rowIndex;
    
    DishItem            *m_dishItem;
    DishItem            *m_dishItemPre;
    DishItem            *m_dishItemNext;
    UIImageView         *m_imgViewDishIcon;
    UIImageView         *m_imgViewDishIconPre;
    UIImageView         *m_imgViewDishIconNext;
    UIView              *m_viewLine;
    
    UIButton            *m_btnSelected;
    UILabel             *m_labDishName;
    UILabel             *m_labDishPrice;
    UILabel             *m_labDishDescrition;
    UIScrollView        *m_scrollViewMain;
    BOOL                m_bIsShowView;
    UIImageView         *m_imgViewRecommend;
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
/** 初始化数据 */
- (void) initData
{
    m_bIsShowView = YES;
}
/** 初始化导航栏 */
- (void) initNavView
{
    UIBarButtonItem *barBtnItem = [[UIBarButtonItem alloc]initWithTitle:@"确定"
                                                                  style:UIBarButtonItemStyleDone
                                                                 target:self
                                                                 action:@selector(clickBtn:)];
    [barBtnItem setTag:ViewTag_Commit];
    self.navigationItem.rightBarButtonItem = barBtnItem;
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent];
}
/** 初始化所有视图View */
- (void) initMainView
{
    if(m_scrollViewMain == nil){
        UIScrollView *scrollView = [UIScrollView new];
        [scrollView setBackgroundColor:[UIColor blackColor]];
        [scrollView setShowsHorizontalScrollIndicator:NO];
        [scrollView setPagingEnabled:YES];
        [scrollView setDelegate:(id)self];
        m_scrollViewMain = scrollView;
    }
    
    if(m_imgViewDishIcon == nil){
        UIImageView *imgView = [UIImageView new];
        [imgView setBackgroundColor:Color_Transparent];
        [imgView setContentMode:UIViewContentModeScaleAspectFit];
        [imgView setUserInteractionEnabled:YES];
        [imgView setTag:ViewTag_ImgViewIcon];
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTapGes:)];
        [imgView addGestureRecognizer:tapGes];
        m_imgViewDishIcon = imgView;
    }
    if(m_imgViewDishIconPre == nil){
        UIImageView *imgView = [UIImageView new];
        [imgView setBackgroundColor:Color_Transparent];
        [imgView setContentMode:UIViewContentModeScaleAspectFit];
        [imgView setUserInteractionEnabled:YES];
        m_imgViewDishIconPre = imgView;
    }
    if(m_imgViewDishIconNext == nil){
        UIImageView *imgView = [UIImageView new];
        [imgView setBackgroundColor:Color_Transparent];
        [imgView setContentMode:UIViewContentModeScaleAspectFit];
        [imgView setUserInteractionEnabled:YES];
        m_imgViewDishIconNext = imgView;
    }
    
    if(m_btnSelected == nil){
        UIButton *btn = [UIButton new];
        [btn setBackgroundColor:Color_Transparent];
        [btn setContentMode:UIViewContentModeScaleToFill];
        [btn setTag:ViewTag_BtnSelect];
        [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        [btn setBackgroundImage:GetImg(@"mainview_noselect") forState:UIControlStateNormal];
        [btn setBackgroundImage:GetImg(@"mainview_selected") forState:UIControlStateSelected];
        m_btnSelected = btn;
    }
    if(m_labDishName == nil){
        UILabel *lab = [UILabel new];
        [lab setBackgroundColor:Color_Transparent];
        [lab setNumberOfLines:1];
        [lab setFont:Font(32)];
        [lab setTextAlignment:NSTextAlignmentLeft];
        [lab setTextColor:[UIColor whiteColor]];
        [lab setLineBreakMode:NSLineBreakByTruncatingTail];
        m_labDishName = lab;
    }
    if(m_labDishPrice == nil){
        UILabel *lab = [UILabel new];
        [lab setBackgroundColor:Color_Transparent];
        [lab setNumberOfLines:1];
        [lab setFont:Font(32)];
        [lab setTextAlignment:NSTextAlignmentRight];
        [lab setTextColor:[UIColor whiteColor]];
        [lab setLineBreakMode:NSLineBreakByTruncatingTail];
        m_labDishPrice = lab;
    }
    if(m_labDishDescrition == nil){
        UILabel *lab = [UILabel new];
        [lab setBackgroundColor:Color_Transparent];
        [lab setNumberOfLines:0];
        [lab setFont:Font(30)];
        [lab setTextAlignment:NSTextAlignmentLeft];
        [lab setTextColor:[UIColor whiteColor]];
        [lab setLineBreakMode:NSLineBreakByWordWrapping];
        m_labDishDescrition = lab;
    }
    if(m_viewLine == nil){
        UIView *viewLine = [UIView new];
        [viewLine setBackgroundColor:Color_RGBA(255, 255, 255, 0.9)];
        [viewLine setUserInteractionEnabled:NO];
        m_viewLine = viewLine;
    }
    if(m_imgViewRecommend == nil){
        UIImageView *imgView = [UIImageView new];
        [imgView setBackgroundColor:Color_Transparent];
        [imgView setUserInteractionEnabled:NO];
        [imgView setClipsToBounds:YES];
        [imgView setContentMode:UIViewContentModeScaleAspectFit];
        [imgView setImage:GetImg(@"recommend")];
        m_imgViewRecommend = imgView;
    }
}
/** 将所有View添加到控制中显示 */
- (void) addAllViewToViewController
{
    UIView *viewMain = self.view;
    [viewMain setBackgroundColor:[UIColor blackColor]];
    
    if(m_scrollViewMain != nil){
        [m_scrollViewMain setFrame:viewMain.bounds];
        [viewMain addSubview:m_scrollViewMain];
    }
    
    if(m_dishItem == nil) { return; }
    
    // ====== 菜图 ======
    float x_add = 0;
    float y_add = 0;
    float w_add = viewMain.bounds.size.width;
    float h_add = viewMain.bounds.size.height;
    if(m_dishItemPre != nil
       && m_imgViewDishIconPre != nil){
        [m_imgViewDishIconPre setFrame:CGRectMake(x_add, y_add, w_add, h_add)];
        NSString *strFilePath = [CPublic getLocalAbsolutePathOfRelativePath:[m_dishItemPre getDishIconImgPath]];
        [m_imgViewDishIconPre setImage:[UIImage imageWithContentsOfFile:strFilePath]];
        [m_scrollViewMain addSubview:m_imgViewDishIconPre];
        x_add += m_imgViewDishIconPre.frame.size.width;
    } else {
        [m_imgViewDishIconPre removeFromSuperview];
    }
    if(m_imgViewDishIcon != nil){
        [m_imgViewDishIcon setFrame:CGRectMake(x_add, y_add, w_add, h_add)];
        NSString *strFilePath = [CPublic getLocalAbsolutePathOfRelativePath:[m_dishItem getDishIconImgPath]];
        [m_imgViewDishIcon setImage:[UIImage imageWithContentsOfFile:strFilePath]];
        [m_scrollViewMain addSubview:m_imgViewDishIcon];
        [m_scrollViewMain setContentOffset:m_imgViewDishIcon.frame.origin];
        x_add += m_imgViewDishIcon.frame.size.width;
    }
    if(m_dishItemNext != nil
       && m_imgViewDishIconNext != nil){
        [m_imgViewDishIconNext setFrame:CGRectMake(x_add, y_add, w_add, h_add)];
        NSString *strFilePath = [CPublic getLocalAbsolutePathOfRelativePath:[m_dishItemNext getDishIconImgPath]];
        [m_imgViewDishIconNext setImage:[UIImage imageWithContentsOfFile:strFilePath]];
        [m_scrollViewMain addSubview:m_imgViewDishIconNext];
        x_add += m_imgViewDishIconNext.frame.size.width;
    } else {
        [m_imgViewDishIconNext removeFromSuperview];
    }
    [m_scrollViewMain setContentSize:CGSizeMake(x_add, m_scrollViewMain.bounds.size.height)];
    
    // ====== 是否选择这道菜的图标 ======
    BOOL bSelected = [[DishOfSelectedManager SharedDishOfSelectedManagerObj] isSelectedOfDishItem:m_dishItem _deskID:[m_deskItem getDeskID]];
    const float space_x = 20;
    const float space_y = 14;
    h_add = 30;
    w_add = h_add;
    y_add = 44;
    x_add = m_imgViewDishIcon.bounds.size.width - w_add - space_x;
    if(m_btnSelected != nil){
        [m_btnSelected setFrame:CGRectMake(x_add, y_add, w_add, h_add)];
        [m_btnSelected setSelected:bSelected];
        [m_imgViewDishIcon addSubview:m_btnSelected];
    }
    h_add = 100;
    w_add = h_add * 11/5;
    x_add = space_x;
    y_add = 44;
    if(m_imgViewRecommend != nil){
        [m_imgViewRecommend setFrame:CGRectMake(x_add, y_add, w_add, h_add)];
        [m_imgViewRecommend setHidden:![m_dishItem getIsDishRecommend]];
        [m_imgViewDishIcon addSubview:m_imgViewRecommend];
    }
    
    // ====== 菜简介 ======
    x_add = space_x;
    y_add = 0;
    w_add = m_imgViewDishIcon.bounds.size.width - x_add - space_x;
    h_add = 0;
    if(m_labDishDescrition != nil){
        [m_labDishDescrition setFrame:CGRectMake(x_add, y_add, w_add, h_add)];
        [m_labDishDescrition setText:[m_dishItem getDishDescrition]];
        [m_labDishDescrition sizeToFit];
        y_add = m_imgViewDishIcon.bounds.size.height - space_y - m_labDishDescrition.frame.size.height;
        CGRect frame = m_labDishDescrition.frame;
        frame.origin.y = y_add;
        m_labDishDescrition.frame = frame;
        [m_imgViewDishIcon addSubview:m_labDishDescrition];
    }
    
    // ====== 菜名 ======
    x_add = space_x;
    y_add = 0;
    w_add = m_imgViewDishIcon.bounds.size.width/2 - x_add - space_x;
    h_add = 0;
    if(m_labDishName != nil){
        [m_labDishName setFrame:CGRectMake(x_add, y_add, w_add, h_add)];
        [m_labDishName setText:[m_dishItem getDishName]];
        [m_labDishName sizeToFit];
        y_add = m_labDishDescrition.frame.origin.y - space_y - m_labDishName.frame.size.height;
        CGRect frame = m_labDishName.frame;
        frame.origin.y = y_add;
        m_labDishName.frame = frame;
        [m_imgViewDishIcon addSubview:m_labDishName];
    }
    
    // ====== 菜价格 ======
    x_add = m_imgViewDishIcon.bounds.size.width/2 + space_x;
    w_add = m_imgViewDishIcon.bounds.size.width - x_add - space_x;
    h_add = 0;
    y_add = 0;
    if(m_labDishPrice != nil){
        [m_labDishPrice setFrame:CGRectMake(x_add, y_add, w_add, h_add)];
        [m_labDishPrice setText:[NSString stringWithFormat:@"%.02f", [m_dishItem getDishPrice]]];
        [m_labDishPrice sizeToFit];
        y_add = m_labDishDescrition.frame.origin.y - space_y - m_labDishPrice.frame.size.height;
        CGRect frame = m_labDishPrice.frame;
        frame.origin.y = y_add;
        frame.size.width = w_add;
        m_labDishPrice.frame = frame;
        [m_imgViewDishIcon addSubview:m_labDishPrice];
    }
    
    h_add = 1.0f;
    x_add = space_x;
    w_add = m_imgViewDishIcon.bounds.size.width - x_add - space_x;
    y_add = m_labDishPrice.frame.origin.y + m_labDishPrice.frame.size.height + space_y/2;
    if(m_viewLine != nil){
        [m_viewLine setFrame:CGRectMake(x_add, y_add, w_add, h_add)];
        [m_imgViewDishIcon addSubview:m_viewLine];
    }
    [self setIsShowDetailsView:m_bIsShowView];
}
/** 显示目前显示的索引 */
- (BOOL) setShowDishItemForIndex:(int)v_index
{
    BOOL bRS = NO;
    if(v_index < 0
       || v_index >= m_aryDishItemList.count){
        return bRS;
    }
    m_rowIndex = v_index;
    
    m_dishItem = [m_aryDishItemList objectAtIndex:m_rowIndex];
    int rowNext = m_rowIndex+1;
    if(rowNext < m_aryDishItemList.count){
        m_dishItemNext = [m_aryDishItemList objectAtIndex:rowNext];
    } else {
        m_dishItemNext = nil;
    }
    
    int rowPre = m_rowIndex-1;
    if(rowPre >= 0
       && rowPre < m_aryDishItemList.count){
        m_dishItemPre = [m_aryDishItemList objectAtIndex:rowPre];
    } else {
        m_dishItemPre = nil;
    }
    bRS = YES;
    return bRS;
}
/** 设置是否显示详情字段 */
- (void) setIsShowDetailsView:(BOOL)v_bIsShowDetail
{
    m_bIsShowView = v_bIsShowDetail;
    
    [m_labDishDescrition setHidden:!m_bIsShowView];
    [m_labDishName setHidden:!m_bIsShowView];
    [m_labDishPrice setHidden:!m_bIsShowView];
    [m_viewLine setHidden:!m_bIsShowView];
}
/** 是否选择当前显示的菜 */
- (void) handleIsSelectDish:(BOOL)v_bIsSelect
{
    if(v_bIsSelect == YES){
        BOOL bTemp = [[DishOfSelectedManager SharedDishOfSelectedManagerObj] addDishOfSelectedWithDishItem:m_dishItem _deskID:[m_deskItem getDeskID]];
        NSLog(@"添加菜是否成功：%i", bTemp);
    } else {
        BOOL bTemp =  [[DishOfSelectedManager SharedDishOfSelectedManagerObj] deleteDishOfSelectedForDishItem:m_dishItem _deskID:[m_deskItem getDeskID]];
        NSLog(@"添加菜是否成功：%i", bTemp);
    }
    
}
// ==================================================================================
#pragma mark - 外部调用方法
/** 设置菜列表，用于显示菜的详情，在界面显示之前设置，需要传入当前要显示的菜的列表索引 */
- (void) setDishItemList:(NSArray<DishItem*>*)v_aryDishItemList _curIndex:(int)v_index
{
    m_aryDishItemList = v_aryDishItemList;
    [self setShowDishItemForIndex:v_index];
}

// ==================================================================================
#pragma mark - 动作触发方法
/** Button按钮点击事件 */
- (void) clickBtn:(id)v_sender
{
    UIView *view = (UIView*)v_sender;
    switch((ViewTag)view.tag){
        case ViewTag_BtnSelect:{ // 选择按钮
            UIButton *btn = (UIButton*)view;
            btn.selected = !btn.selected;
            [self handleIsSelectDish:btn.selected];
            break;
        }
        default:{
            break;
        }
    }
}
/** 手势单击事件 */
- (void) handleTapGes:(UITapGestureRecognizer*)v_ges
{
    [self setIsShowDetailsView:!m_bIsShowView];
}
// ==================================================================================
#pragma mark - 委托协议UIScrollViewDelegate
// called when scroll view grinds to a halt
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    float x_offset = scrollView.contentOffset.x;
    if(x_offset < (m_imgViewDishIcon.frame.origin.x - m_imgViewDishIcon.frame.size.width/2)){ // 上一个
        int row = m_rowIndex - 1;
        BOOL bIsUpdateData = [self setShowDishItemForIndex:row];
        if(bIsUpdateData == YES){
//            [self addAllViewToViewController];
            [self.view setNeedsLayout];
            [self.view layoutIfNeeded];
        }
        
    } else if(x_offset > (m_imgViewDishIcon.frame.origin.x + m_imgViewDishIcon.frame.size.width/2)){ // 下一个
        int row = m_rowIndex + 1;
        BOOL bIsUpdateData = [self setShowDishItemForIndex:row];
        if(bIsUpdateData == YES){
//            [self addAllViewToViewController];
            [self.view setNeedsLayout];
            [self.view layoutIfNeeded];
        }
    }
}
@end
