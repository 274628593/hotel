//
//  ViewTest.m
//  HotelSystem
//
//  Created by LHJ on 16/4/8.
//  Copyright © 2016年 hancj. All rights reserved.
//

#import "ViewTest.h"

@implementation ViewTest

- (void) layoutSubviews
{
    [super layoutSubviews];
    
    NSLog(@"%f", self.frame.size.height);
    
//    CGRect frame = self.frame;
//    frame.size.height += 1;
//    self.frame = frame;
}

@end
