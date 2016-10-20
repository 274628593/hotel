//
//  View_HorListItem.m
//  musicController
//
//  Created by LHJ on 15/11/30.
//  Copyright © 2015年 citymap. All rights reserved.
//

#import "View_HorListItem.h"
#import "CPublic.h"

typedef enum : int{
    ViewTag_SelectedView = 1,
    
} ViewTag;

@implementation View_HorListItem
{
    UIView *m_viewSelected;
}
@synthesize m_bIsSelected;

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
    m_bIsSelected = NO;
}

- (void) setIsSelected:(BOOL)v_bIsSelected
{
    if(m_bIsSelected == v_bIsSelected) { return; }
    
    m_bIsSelected = v_bIsSelected;
    [self initLayoutView];
}

- (void) initLayoutView
{
    UIView *viewSelect = m_viewSelected;
    if(viewSelect == nil){
        float x_add = 0;
        float w_add = self.bounds.size.width;
        float h_add = self.bounds.size.height/16;
        float y_add = self.bounds.size.height - h_add;
        UIView *view = [UIView new];
        [view setFrame:CGRectMake(x_add, y_add, w_add, h_add)];
        [view setBackgroundColor:self.textColor];
        [view setUserInteractionEnabled:NO];
        [view setTag:ViewTag_SelectedView];
        [self addSubview:view];
        m_viewSelected = view;
        viewSelect = m_viewSelected;
    }
    [viewSelect setHidden:!m_bIsSelected];
    
//    if(m_bIsSelected == NO){
//        [self setTextColor:Color(200, 200, 200, 1.0f)];
//    } else {
//    self setTextColor:m_
//    }
}

@end
