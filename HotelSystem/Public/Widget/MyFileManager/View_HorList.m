//
//  View_HorList.m
//  musicController
//
//  Created by LHJ on 15/11/30.
//  Copyright © 2015年 citymap. All rights reserved.
//

#import "View_HorList.h"
#import "CPublic.h"

@implementation View_HorList
{
    NSMutableArray  *m_muAryItemView;
    NSMutableArray  *m_muAryGesture;
    int             m_indexGesture;
}
@synthesize m_listType;
@synthesize m_aryHorList;
@synthesize m_textColor;
@synthesize m_textFont;
@synthesize m_delegate;

- (id) initWithFrame:(CGRect)v_frame
{
    self = [super initWithFrame:v_frame];
    if(self != nil){
        [self initData];
    }
    return self;
}

- (void) initData
{
    m_listType = ListType_1;
}

- (void) initLayoutView
{
    const float spaceLAndR = 2;
    const float spaceTAndB = 4;
    NSString *strTemp = @"获取高度";
    CGSize sizeFont = [CPublic getTextSize:strTemp _font:m_textFont];
    float h_add = sizeFont.height + spaceTAndB*2;
    
    m_muAryItemView = [NSMutableArray new];
    m_muAryGesture = [NSMutableArray new];
    float x_add = 0.0f;
    float y_add = 1.0f;
    float w_add = self.bounds.size.width / m_aryHorList.count;
    UITapGestureRecognizer *tapGesFirst = nil;
    for(int i=0; i<m_aryHorList.count; i+=1)
    {
        HorListItmObj *itemObj = [m_aryHorList objectAtIndex:i];
        if(m_listType == ListType_2){
            w_add = [CPublic getTextSize:[itemObj getText] _font:m_textFont].width;
            w_add += spaceLAndR*2;
        }
        UIColor *colorBG = Color_RGB(250, 250, 250);
        View_HorListItem *view = [View_HorListItem new];
        [view setFrame:CGRectMake(x_add, y_add, w_add, h_add)];
        [view setBackgroundColor:colorBG];
        [view setUserInteractionEnabled:YES];
        [view setText:[itemObj getText]];
        [view setTag:[itemObj getID]];
        [view setFont:m_textFont];
        [view setTextColor:m_textColor];
        [view setTextAlignment:NSTextAlignmentCenter];
        [view setNumberOfLines:1];
        [view setClipsToBounds:YES];
        [self addSubview:view];
        x_add += view.frame.size.width;
        
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGes:)];
        [view addGestureRecognizer:tapGes];
        [m_muAryItemView addObject:view];
        if(i == 0){
            tapGesFirst = tapGes;
        }
        [m_muAryGesture addObject:tapGes];
    }
    CGRect frame = self.frame;
    frame.size.height = h_add ;
    self.frame = frame;
    
    float x_line = 0;
    float h_line = 0.6f;
    float w_line = self.bounds.size.width;
    float y_line = self.bounds.size.height - h_line;
    UIView *viewLine = [UIView new];
    [viewLine setFrame:CGRectMake(x_line, y_line, w_line, h_line)];
    [viewLine setBackgroundColor:Color_RGBA(30, 30, 30, 0.4f)];
    [viewLine setUserInteractionEnabled:NO];
    [self addSubview:viewLine];
    
    [self setShowsHorizontalScrollIndicator:NO];
    [self setContentSize:CGSizeMake(x_add, self.contentSize.height)];
    
    // ====== 默认选中第一项 ======
    [self handleTapGes:tapGesFirst];
}
/** 选下一个 */
- (void) selectNext
{
    int index = m_indexGesture + 1;
    if(index >= 0
       && index < m_muAryGesture.count){
        UITapGestureRecognizer *ges = [m_muAryGesture objectAtIndex:index];
        [self handleTapGes:ges];
    }
}
/** 选上一个 */
- (void) selectPre
{
    int index = m_indexGesture - 1;
    if(index >= 0
       && index < m_muAryGesture.count){
        UITapGestureRecognizer *ges = [m_muAryGesture objectAtIndex:index];
        [self handleTapGes:ges];
    }
}

- (void) handleTapGes:(UITapGestureRecognizer*)v_ges
{
    View_HorListItem *view = (View_HorListItem*)[v_ges view];
    
    for(View_HorListItem *itemView in m_muAryItemView){
        [itemView setIsSelected:NO];
    }
    int IDItem = (int)[view tag];
    for(int i=0; i<m_aryHorList.count; i+=1){
        HorListItmObj *itemObj = [m_aryHorList objectAtIndex:i];
        if(IDItem == [itemObj getID]){
            m_indexGesture = i;
            break;
        }
    }
    
    [view setIsSelected:YES];
    
    [self handleScrollViewOffset:view];
    
    for(HorListItmObj *itemObj in m_aryHorList)
    {
        if([itemObj getID] == [view tag])
        {
            if(m_delegate != nil){
                BOOL bTemp = [m_delegate respondsToSelector:@selector(selectItem:)];
                if(bTemp == YES){
                    [m_delegate selectItem:itemObj];
                }
            }
            break;
        }
    }
}
- (void) handleScrollViewOffset:(UIView*)v_view
{
    float x_conffset = 0.0f;
    float x_view = v_view.frame.origin.x;
    float w_view = v_view.frame.size.width;
    float temp = x_view + w_view/2;
    if(temp <= self.bounds.size.width/2){
        x_conffset = 0.0f;
    
    } else if((self.contentSize.width - temp) <= self.bounds.size.width/2){
        x_conffset = self.contentSize.width - self.bounds.size.width;
    
    } else {
        x_conffset = temp - self.bounds.size.width/2;
    }
    
    [self setContentOffset:CGPointMake(x_conffset, 0) animated:YES];
}

@end
