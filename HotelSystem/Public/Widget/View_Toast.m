//
//  View_Toast.m
//  MeetingSys
//
//  Created by citymap on 14/11/2.
//  Copyright (c) 2014年 citymap. All rights reserved.
//

#import "View_Toast.h"
#import "CPublic.h"

@implementation View_Toast

- (void) showToast:(UIView*)v_view _content:(NSString*)v_strContent
{
    const int space_row = 30;
    UILabel *labToast = [UILabel new];
    [labToast setFrame:CGRectMake(0, 0, 500, 0)];
    [labToast setFont:Font_Bold(15.0f)];
    [labToast setTextAlignment:NSTextAlignmentCenter];
    [labToast setTextColor:Color_RGB(254, 254, 254)];
    [labToast setText:v_strContent];
    [labToast setNumberOfLines:0];
    [labToast setLineBreakMode:NSLineBreakByWordWrapping];
    [labToast setBackgroundColor:Color_RGBA(0, 0, 0, 0.6f)];
    [labToast.layer setCornerRadius:4];
    [labToast setClipsToBounds:YES];
    float width_fit = ScreenSize.width - space_row*2;
    CGSize size = [CPublic getTextSize:labToast.text _font:labToast.font _fitSize:CGSizeMake(width_fit, CGFLOAT_MAX)];
    size.width = (size.width + 30 < v_view.frame.size.width-space_row*2)? size.width + 30 : v_view.frame.size.width-space_row*2;
    size.height += 20;
    int y_toast = v_view.frame.size.height - space_row*3/2 - size.height;
    CGRect frame = labToast.frame;
    frame.size = size;
    frame.origin.y = y_toast;
    labToast.frame = frame;
    [labToast setCenter:CGPointMake(v_view.frame.size.width/2, labToast.center.y)];
    [labToast setAlpha:0.0f];
    [v_view addSubview:labToast];
    
    [UIView animateWithDuration:0.4f animations:^{
        [labToast setAlpha:1.0f];
    } completion:^(BOOL v_bIs){
        [UIView animateWithDuration:0.3f delay:2.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
            [labToast setAlpha:0.0f];
        }completion:^(BOOL v_bIs){
            [labToast removeFromSuperview];
        }];
    }];
}

@end
