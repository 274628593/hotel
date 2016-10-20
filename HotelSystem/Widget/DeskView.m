//
//  DeskView.m
//  HotelSystem
//
//  Created by hancj on 15/11/16.
//  Copyright © 2015年 hancj. All rights reserved.
//

#import "DeskView.h"

#define ColNum          5
#define CornerRadius    6.0f

typedef enum : int{
    ClickTag_AddDeskItem = 1, /* 添加桌子项 */
    ClickTag_CloseDelete, /* 关闭删除 */
} ClickTag;

@implementation DeskView
{
    BOOL        m_bIsLayoutView;
    BOOL        m_bIsDeleteMode;
    int         m_colNum;
    float       m_spaceCol;
    float       m_spaceRow;
    float       m_hBeigin; // 初始化的高度值
    
    UIButton                *m_btnBG;
    UIButton                *m_btnAdd;
    NSMutableDictionary     *m_muDicDeskBtn;
    NSMutableArray          *m_muAryDeskItems;
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
    m_bIsDeleteMode = NO;
    m_colNum = ColNum;
    m_spaceCol = 40;
    m_spaceRow = 30;
    m_muAryDeskItems = [NSMutableArray new];
    m_muDicDeskBtn = [NSMutableDictionary new];
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
    
    const float spaceLAndR = m_spaceCol*2;
    const float spaceTAndB = m_spaceRow*2;
    float x_add = spaceLAndR;
    float y_add = spaceTAndB;
    float w_add = self.bounds.size.width - x_add*2;
    w_add = (w_add - m_spaceCol*(m_colNum-1))/ m_colNum;
    float h_add = w_add;
    for(int i=0; m_muAryDeskItems!=nil && i<(m_muAryDeskItems.count+1); i+=1)
    {
        if(i >= m_muAryDeskItems.count){ // “添加”按钮
            if(m_btnAdd == nil){
                m_btnAdd = [UIButton new];
                [m_btnAdd setTag:ClickTag_AddDeskItem];
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
            DeskItem *item = [m_muAryDeskItems objectAtIndex:i];
            DeskItemView *itemView = [m_muDicDeskBtn objectForKey:[item getDeskID]];
            if(itemView == nil){
                itemView = [DeskItemView new];
                [itemView setClipsToBounds:YES];
                [itemView setBackgroundColor:Color_Transparent];
                [itemView setDeskItemNum:[item getDeskNum]];
                [itemView setTag:[item getDeskNum]];
                [itemView setDelegate:(id)self];
                [itemView setCornerRadius:CornerRadius];
                [itemView setTextColor:m_textColor];
                [itemView setTextFont:m_textFont];
                [m_muDicDeskBtn setObject:itemView forKey:[item getDeskID]];
            }
            UILongPressGestureRecognizer *longPressGes = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGes:)];
            [itemView addGestureRecognizer:longPressGes];
            
            [itemView setFrame:CGRectMake(x_add, y_add, w_add, h_add)];
            [self addSubview:itemView];
            
            if(i != 0
               && (i+1)%m_colNum == 0){ // 换行
                x_add = spaceLAndR;
                y_add += (h_add + m_spaceRow);
            } else {
                x_add += (m_spaceCol + w_add);
            }
        }
    }
    y_add += (h_add + spaceTAndB);
    [self sendSubviewToBack:m_btnBG];
    [self updateDeskViewSize:y_add];
}
/** 更新视图尺寸 */
- (void) updateDeskViewSize:(float)v_newHeight
{
    v_newHeight = (v_newHeight >= m_hBeigin)? v_newHeight : m_hBeigin;
    if(self.frame.size.height != v_newHeight){
        CGRect frame = self.frame;
        frame.size.height = v_newHeight;
        self.frame = frame;
        
        m_btnBG.frame = self.bounds;
        
        if(m_delegate != nil){
            BOOL bTemp = [m_delegate respondsToSelector:@selector(changeDeskViewSize:)];
            if(bTemp == YES){
                [m_delegate changeDeskViewSize:self];
            }
        }
    }
}
/** 更新视图 */
- (void) updateDeskView
{
    for(UIView *view in [self subviews]){
        [view removeFromSuperview];
    }
    m_btnBG = nil;
    [self initLayoutView];
}
/** 给桌子号数组排序 */
- (void) handleDeskAry
{
    if(m_muAryDeskItems == nil) { return; }
    
    [m_muAryDeskItems sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        DeskItem *item1 = (DeskItem*) obj1;
        DeskItem *item2 = (DeskItem*) obj2;
        return ([item1 getDeskNum] > [item2 getDeskNum]);
    }];
}

// ==============================================================================================
#pragma mark 外部调用方法
/** 添加桌子项 */
- (void) addDeskItem_id:(NSString*)v_strDeskID _num:(int)v_deskNum
{
    DeskItem *item = [DeskItem new];
    [item setDeskID:v_strDeskID];
    [item setDeskNum:v_deskNum];
    [self addDeskItem:item];
}
/** 设置桌子列表 */
- (void) setDeskitemList:(NSArray*)v_aryDeskItem
{
    if(m_muAryDeskItems == nil){
        m_muAryDeskItems = [NSMutableArray new];
    }
    for(DeskItem *item in v_aryDeskItem){
        [m_muAryDeskItems addObject:item];
    }
    [self handleDeskAry];
    [self updateDeskView];
}
/** 添加桌子项 */
- (void) addDeskItem:(DeskItem*)v_deskItem
{
    if(m_muAryDeskItems == nil){
        m_muAryDeskItems = [NSMutableArray new];
    }
    [m_muAryDeskItems addObject:v_deskItem];
    [self handleDeskAry];
    [self updateDeskView];
}
/** 移除桌子项 */
- (void) removeDeskItem:(DeskItem*)v_deskItem
{
    NSString *strDeskID = [v_deskItem getDeskID];
    [m_muAryDeskItems removeObject:v_deskItem];
    [m_muDicDeskBtn removeObjectForKey:strDeskID];
    [self handleDeskAry];
    [self updateDeskView];
}
/** 移除桌子项 */
- (void) removeDeskItemAtIndex:(int)v_index
{
    DeskItem *item = [m_muAryDeskItems objectAtIndex:v_index];
    [self removeDeskItem:item];
}
/** 是否开启删除模式 */
- (void) isOpenDeleteMode:(BOOL)v_bIsDeleteMode
{
    m_bIsDeleteMode = v_bIsDeleteMode;
    [m_btnBG setHidden:!m_bIsDeleteMode];
    NSArray *aryKeys = [m_muDicDeskBtn allKeys];
    for(NSString *strKey in aryKeys)
    {
        DeskItemView *itemView = [m_muDicDeskBtn objectForKey:strKey];
        [itemView setIsOpenDeleteMode:m_bIsDeleteMode];
    }
}

// ==============================================================================================
#pragma mark 动作触发方法
/** 点击按钮方法 */
- (void) clickBtn:(id)v_sender
{
    UIView *view = (UIView*)v_sender;
    switch((ClickTag)view.tag)
    {
        case ClickTag_AddDeskItem:{ // 添加桌子项
            if(m_delegate != nil){
                BOOL bTemp = [m_delegate respondsToSelector:@selector(addDeskItemView:)];
                if(bTemp == YES){
                    [m_delegate addDeskItemView:self];
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
#pragma mark 委托实现DeskItemViewDelegate
/** 点击桌子项 */
- (void) clickDeskItem:(id)v_sender
{
    UIView *view = (UIView*)v_sender;
    int deskNum = (int)view.tag;
    DeskItem *itemRS = nil;
    for(DeskItem *itemTemp in m_muAryDeskItems){
        if([itemTemp getDeskNum] == deskNum){
            itemRS = itemTemp;
            break;
        }
    }
    if(itemRS != nil){
        if(m_delegate != nil){
            BOOL bTemp = [m_delegate respondsToSelector:@selector(openDeskItem:_sender:)];
            if(bTemp == YES){
                [m_delegate openDeskItem:itemRS _sender:self];
            }
        }
    }
}
/** 删除桌子项 */
- (void) removeDeskItemView:(id)v_sender
{
    UIView *view = (UIView*)v_sender;
    int deskNum = (int)view.tag;
    DeskItem *itemRS = nil;
    for(DeskItem *itemTemp in m_muAryDeskItems){
        if([itemTemp getDeskNum] == deskNum){
            itemRS = itemTemp;
            break;
        }
    }
    [view removeFromSuperview];
    [m_muAryDeskItems removeObject:itemRS];
    [m_muDicDeskBtn removeObjectForKey:[itemRS getDeskID]];
    if(itemRS != nil){
        if(m_delegate != nil){
            BOOL bTemp = [m_delegate respondsToSelector:@selector(deleteDeskItem:_sender:)];
            if(bTemp == YES){
                [m_delegate deleteDeskItem:itemRS _sender:self];
            }
        }
    }
}

@end
