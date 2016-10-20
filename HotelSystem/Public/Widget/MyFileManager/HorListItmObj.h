//
//  HorListItmObj.h
//  musicController
//
//  Created by LHJ on 15/11/30.
//  Copyright © 2015年 citymap. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HorListItmObj : NSObject

@property(nonatomic, copy, setter=setText:, getter=getText) NSString *m_strText;

@property(nonatomic, assign, setter=setID:, getter=getID) int m_id;

@end
