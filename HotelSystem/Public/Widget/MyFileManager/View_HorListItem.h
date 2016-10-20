//
//  View_HorListItem.h
//  musicController
//
//  Created by LHJ on 15/11/30.
//  Copyright © 2015年 citymap. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface View_HorListItem : UILabel

/** 是否选择 */
@property(nonatomic, assign, setter=setIsSelected:, getter=getIsSelected) BOOL m_bIsSelected;

@end
