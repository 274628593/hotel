//
//  View_HorList.h
//  musicController
//
//  Created by LHJ on 15/11/30.
//  Copyright © 2015年 citymap. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "HorListItmObj.h"
#import "View_HorListItem.h"

@protocol View_HorListDelegate;

typedef enum : int{
    ListType_1 = 1, /* 样式1，按照个数平分宽度 */
    ListType_2,
    
} ListType;

/** 列表导航 */
@interface View_HorList : UIScrollView

- (void) initLayoutView;

/** 选下一个 */
- (void) selectNext;

/** 选上一个 */
- (void) selectPre;

@property(nonatomic, assign, setter=setListType:, getter=getListType) ListType m_listType;

@property(nonatomic, retain, setter=setHorList:, getter=getHorList) NSArray<HorListItmObj*> *m_aryHorList;

@property(nonatomic, retain, setter=setTextFont:, getter=getTextFont) UIFont *m_textFont;

@property(nonatomic, retain, setter=setTextColor:, getter=getTextColor) UIColor *m_textColor;

@property(nonatomic, retain, setter=setDelegate:, getter=getDelegate,) id<View_HorListDelegate> m_delegate;

@end

// ======================================================================================
#pragma mark 委托协议
@protocol View_HorListDelegate<NSObject>

@required
- (void) selectItem:(HorListItmObj*)v_item;

@end
