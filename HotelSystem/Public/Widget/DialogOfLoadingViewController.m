//
//  DialogOfLoadingViewController.m
//  MachineModule
//
//  Created by LHJ on 15/12/12.
//  Copyright © 2015年 LHJ. All rights reserved.
//

#import "DialogOfLoadingViewController.h"
#import "CPublic.h"

@implementation DialogOfLoadingViewController
{
    UIImageView *m_imgView;
}

// ==============================================================================================
#pragma mark 基类方法
- (id)initWithFrame:(CGRect)frame
{
    frame = [UIScreen mainScreen].bounds;
    self = [super initWithFrame:frame];
    if(self != nil){
        [self initData];
    }
    return self;
}
- (void) layoutSubviews
{
    [self initLayoutView];
}
- (void) dealloc
{
    [m_imgView.layer removeAllAnimations];
    m_imgView = nil;
}
// ==============================================================================================
#pragma mark 内部使用方法
/** 初始化数据 */
- (void) initData
{
}
/** 初始化视图View */
- (void) initLayoutView
{
    [self setBackgroundColor:Color_Transparent];
    UIView *viewMain = self;
    
    // ====== 加载框内的图片 =======
    float w_add = viewMain.bounds.size.width *8/100;
    float h_add = w_add;
    float x_add = 0;
    float y_add = 0;
    UIImageView *imgView = [UIImageView new];
    [imgView setFrame:CGRectMake(x_add, y_add, w_add, h_add)];
    [imgView setBackgroundColor:Color_Transparent];
    [imgView setContentMode:UIViewContentModeScaleToFill];
    [imgView setImage:GetImg(@"icon_jiazai")];
    m_imgView = imgView;
    
    // ====== 加载框 ======
    const float space_x = 12;
    const float space_y = 8;
    w_add = imgView.bounds.size.width + space_x*2;
    h_add = imgView.bounds.size.height + space_y*2;
    x_add = (viewMain.bounds.size.width - w_add)/2;
    y_add = (viewMain.bounds.size.height - h_add)/2;
    UIView *viewLoad = [UIView new];
    [viewLoad setFrame:CGRectMake(x_add, y_add, w_add, h_add)];
    [viewLoad setBackgroundColor:Color_RGBA(0, 0, 0, 0.3f)];
    [viewLoad setClipsToBounds:YES];
    [viewLoad.layer setCornerRadius:6.0f];
    [viewMain addSubview:viewLoad];
    
    [viewLoad addSubview:imgView];
    [imgView setCenter:CGPointMake(viewLoad.bounds.size.width/2, viewLoad.bounds.size.height/2)];

    // ====== 加载动画 ======
    CABasicAnimation *rotationAni = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAni.fromValue = [NSNumber numberWithFloat:0.0f];
    rotationAni.toValue = [NSNumber numberWithFloat:M_PI*2.0f];
    rotationAni.duration = 4.0f;
    rotationAni.fillMode = kCAFillModeForwards;
    rotationAni.repeatCount = HUGE_VALF;
    rotationAni.removedOnCompletion = NO;
    rotationAni.autoreverses = NO;
    [imgView.layer addAnimation:rotationAni forKey:nil];
}

@end
