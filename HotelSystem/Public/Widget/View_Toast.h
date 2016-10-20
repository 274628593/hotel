//
//  View_Toast.h
//  MeetingSys
//
//  Created by citymap on 14/11/2.
//  Copyright (c) 2014年 citymap. All rights reserved.
//

#import <UIKit/UIKit.h>

/** 显示在界面上的提示语 */
@interface View_Toast : NSObject

/** 显示提示语 */
- (void) showToast:(UIView*)v_view _content:(NSString*)v_strContent;

@end
