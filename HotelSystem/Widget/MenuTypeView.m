//
//  MenuTypeView.m
//  HotelSystem
//
//  Created by hancj on 15/11/20.
//  Copyright © 2015年 hancj. All rights reserved.
//

#import "MenuTypeView.h"

#define ColNum          2
#define CornerRadius    10.0f

typedef enum : int{
    ClickTag_AddMenuTypeItem = 1, /* 添加桌子项 */
    ClickTag_CloseDelete, /* 关闭删除 */
} ClickTag;

@implementation MenuTypeView
{
    BOOL        m_bIsLayoutView;
    BOOL        m_bIsDeleteMode; // 是否在删除模式，必须先开启编辑模式才能开启删除
    int         m_colNum;
    float       m_spaceCol;
    float       m_spaceRow;
    float       m_hBeigin;      // 初始化的高度值
    BOOL        m_bIsEditMode;  // 是否编辑模式
    
    UIButton                *m_btnBG;
    UIButton                *m_btnAdd;
    NSMutableArray          *m_muAryMenuBtn;
    NSMutableArray          *m_muAryMenuItems;
}
@synthesize m_delegate;
@synthesize m_textColor;
@synthesize m_textFont;

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
    m_hBeigin = self.frame.size.height;
    [self initLayoutView];
}

// ==============================================================================================
#pragma mark 内部使用方法
/** 初始化数据 */
- (void) initData
{
    [self setUserInteractionEnabled:YES];
    m_bIsLayoutView = NO;
    m_bIsEditMode = NO;
    m_bIsDeleteMode = NO;
    m_colNum = ColNum;
    m_spaceCol = 60;
    m_spaceRow = 40;
    m_muAryMenuItems = [NSMutableArray new];
    m_muAryMenuBtn = [NSMutableArray new];
    m_textColor = Color_RGB(30, 30, 30);
    m_textFont = Font(18.0f);
}
/** 初始化布局 */
- (void) initLayoutView
{
    if(m_btnBG == nil){
        UIButton *btnBG = [UIButton new];
        [btnBG setFrame:self.bounds];
        [btnBG setBackgroundColor:Color_Transparent];
        [btnBG setTag:ClickTag_CloseDelete];
        [btnBG setHidden:YES];
        [btnBG addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btnBG];
        m_btnBG = btnBG;
    }
    
    const float spaceLAndR = m_spaceCol*3/2;
    const float spaceTAndB = m_spaceRow*2;
    float x_add = spaceLAndR;
    float y_add = spaceTAndB;
    float w_add = self.bounds.size.width - x_add*2;
    w_add = (w_add - m_spaceCol*(m_colNum-1))/ m_colNum;
    float h_add = w_add *5/4;
    int count = (m_muAryMenuItems != nil)? (int)m_muAryMenuItems.count : 0;
    count = (m_bIsEditMode == YES)? count+1 : count;
    for(int i=0; i<count; i+=1)
    {
        if(m_bIsEditMode == YES
           && i >= m_muAryMenuItems.count){ // “添加”按钮
            if(m_btnAdd == nil){
                m_btnAdd = [UIButton new];
                [m_btnAdd setTag:ClickTag_AddMenuTypeItem];
                [m_btnAdd setBackgroundColor:Color_Transparent];
                [m_btnAdd setClipsToBounds:YES];
                [m_btnAdd addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
                [m_btnAdd.layer setCornerRadius:CornerRadius];
                [m_btnAdd setContentMode:UIViewContentModeScaleToFill];
                [m_btnAdd setBackgroundImage:GetImg(@"addDeskItem.jpg") forState:UIControlStateNormal];
            }
            [m_btnAdd setFrame:CGRectMake(x_add, y_add, w_add, h_add)];
            [self addSubview:m_btnAdd];
            
        } else { // 桌子按钮
            m_muAryMenuBtn = [NSMutableArray new];
            MenuTypeItem *item = [m_muAryMenuItems objectAtIndex:i];
            MenuTypeItemView *itemView = [MenuTypeItemView new];
            [itemView setClipsToBounds:YES];
            [itemView setBackgroundColor:Color_Transparent];
            [itemView setMenuTypeName:[item getMenuTypeName]];
            [itemView setMenuTypeImgPath:[item getMenuTypeImgName]];
            [itemView setTag:[item getMenuTypeItemID]];
            [itemView setDelegate:(id)m_delegate];
            [itemView setCornerRadius:CornerRadius];
            [itemView setTextColor:m_textColor];
            [itemView setTextFont:m_textFont];
            [itemView setIsEditEnable:m_bIsEditMode];
            [itemView setFrame:CGRectMake(x_add, y_add, w_add, h_add)];
            [self addSubview:itemView];
            [m_muAryMenuBtn addObject:itemView];
            
            if(i != 0
               && (i+1) % m_colNum == 0){ // 换行
                x_add = spaceLAndR;
                y_add += (h_add + m_spaceRow);
            } else {
                x_add += (m_spaceCol + w_add);
            }
        }
    }
    y_add += (h_add + spaceTAndB);
    [self sendSubviewToBack:m_btnBG];
    [self updateMenuTypeViewSize:y_add];
}

/** 是否开启删除模式 */
- (void) isOpenDeleteMode:(BOOL)v_bIsDeleteMode
{
    m_bIsDeleteMode = v_bIsDeleteMode;
    [m_btnBG setHidden:!m_bIsDeleteMode];
    for(MenuTypeItemView *itemView in m_muAryMenuBtn)
    {
        [itemView setIsOpenDeleteMode:m_bIsDeleteMode];
    }
}
/** 更新视图 */
- (void) updateMenuTypeView
{
    for(UIView *view in [self subviews]){
        [view removeFromSuperview];
    }
    m_btnBG = nil;
    [self initLayoutView];
}
/** 更新视图尺寸 */
- (void) updateMenuTypeViewSize:(float)v_newHeight
{
    v_newHeight = (v_newHeight >= m_hBeigin)? v_newHeight : m_hBeigin;
    if(self.frame.size.height != v_newHeight){
        CGRect frame = self.frame;
        frame.size.height = v_newHeight;
        self.frame = frame;
        
        m_btnBG.frame = self.bounds;
        if(m_delegate != nil){
            BOOL bTemp = [m_delegate respondsToSelector:@selector(changeMenuTypeViewSize:)];
            if(bTemp == YES){
                [m_delegate changeMenuTypeViewSize:self];
            }
        }
    }
}


// ==============================================================================================
#pragma mark 外部调用方法
/** 是否开启编辑模式 */
- (void) setIsOpenEditMode:(BOOL)v_bIsEditMode
{
    m_bIsEditMode = v_bIsEditMode;
    for(MenuTypeItemView *itemView in m_muAryMenuBtn)
    {
        UILongPressGestureRecognizer *longPressGes = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGes:)];
        [itemView addGestureRecognizer:longPressGes];
        [itemView setIsEditEnable:m_bIsEditMode];
    }
}
/** 设置桌子列表 */
- (void) setMenuItemList:(NSArray*)v_aryDeskItem
{
    if(m_muAryMenuItems == nil){
        m_muAryMenuItems = [NSMutableArray new];
    }
    for(MenuTypeItem *item in v_aryDeskItem){
        [m_muAryMenuItems addObject:item];
    }
    [self updateMenuTypeView];
}

// ==============================================================================================
#pragma mark 动作触发方法
/** 点击按钮方法 */
- (void) clickBtn:(id)v_sender
{
    UIView *view = (UIView*)v_sender;
    switch((ClickTag)view.tag)
    {
        case ClickTag_AddMenuTypeItem:{ // 添加桌子项
            if(m_delegate != nil){
                BOOL bTemp = [m_delegate respondsToSelector:@selector(addMenuTypeItemView:)];
                if(bTemp == YES){
                    [m_delegate addMenuTypeItemView:self];
                }
            }
            break;
        }
        case ClickTag_CloseDelete:{ // 关闭删除
            if(m_bIsDeleteMode == YES){
                [self isOpenDeleteMode:NO];
            }
            break;
        }
    }
}
/** 长按手势 */
- (void) handleLongPressGes:(UILongPressGestureRecognizer*)v_ges
{
    switch(v_ges.state){
        case UIGestureRecognizerStateChanged:{
            break;
        }
        case UIGestureRecognizerStatePossible:{
            break;
        }
        case UIGestureRecognizerStateBegan:{
            [self isOpenDeleteMode:YES];
            break;
        }
        case UIGestureRecognizerStateEnded:{
            break;
        }
        case UIGestureRecognizerStateCancelled:{
            break;
        }
        case UIGestureRecognizerStateFailed:{
            break;
        }
    }
}

// ==============================================================================================
#pragma mark 委托协议MenuTypeItemViewDelegate
/** 点击桌子项 */
- (void) clickMenuTypeItem:(id)v_sender
{
    UIView *view = (UIView*)v_sender;
    int menuTypeItemID = (int)view.tag;
    MenuTypeItem *itemRS = nil;
    for(MenuTypeItem *itemTemp in m_muAryMenuItems){
        if([itemTemp getMenuTypeItemID] == menuTypeItemID){
            itemRS = itemTemp;
            break;
        }
    }
    if(itemRS != nil){
        if(m_delegate != nil){
            BOOL bTemp = [m_delegate respondsToSelector:@selector(openMenuTypeItem:_sender:)];
            if(bTemp == YES){
                [m_delegate openMenuTypeItem:itemRS _sender:self];
            }
        }
    }
}

/** 删除桌子项 */
- (void) removeMenuTypeItemView:(id)v_sender
{
    UIView *view = (UIView*)v_sender;
    int menuTypeItemID = (int)view.tag;
    MenuTypeItem *itemRS = nil;
    for(MenuTypeItem *itemTemp in m_muAryMenuItems){
        if([itemTemp getMenuTypeItemID] == menuTypeItemID){
            itemRS = itemTemp;
            break;
        }
    }
    [view removeFromSuperview];
    [m_muAryMenuItems removeObject:itemRS];
    [m_muAryMenuBtn removeObject:view];
    if(itemRS != nil){
        if(m_delegate != nil){
            BOOL bTemp = [m_delegate respondsToSelector:@selector(deleteMenuTypeItem:_sender:)];
            if(bTemp == YES){
                [m_delegate deleteMenuTypeItem:itemRS _sender:self];
            }
        }
    }
}

@end
