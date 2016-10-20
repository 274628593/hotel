//
//  ShowToastView.m
//  MachineModule
//
//  Created by LHJ on 15/12/15.
//  Copyright © 2015年 LHJ. All rights reserved.
//

#import "ShowToastView.h"
#import "CPublic.h"

#define AnimationKey_BeginAni   @"AnimationKey_BeginAni"
#define AnimationKey_EndAni     @"AnimationKey_EndAni"

/** 中间弹出框 - 用于提示错误 */
@implementation ShowToastView
{
    BOOL    m_bIsLayoutView;
    UIView  *m_viewToast;
}
@synthesize m_strContent;
// ==============================================================================================
#pragma mark 基层类方法
- (id) initWithFrame:(CGRect)v_frame
{
    v_frame = [UIScreen mainScreen].bounds;
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
    
    [self initLayoutView];
    [self beginAni];
}

// ==============================================================================================
#pragma mark 内部使用方法
/** 初始化数据 */
- (void) initData
{
    m_bIsLayoutView = NO;
}
/** 初始化布局 */
- (void) initLayoutView
{
    [self setUserInteractionEnabled:NO];
    [self setBackgroundColor:Color_Transparent];
    
    const float space_y = 20;
    const float fitWidth = self.bounds.size.width *6/10;
    UIFont *fontTX = Font(16.0f);
    CGSize sizeFont = [CPublic getTextSize:m_strContent _font:fontTX _fitSize:CGSizeMake(fitWidth, CGFLOAT_MAX)];
    const float h_tx = sizeFont.height;
    const float h_imgView = h_tx/2;
    
    // ====== 弹出框 ======
    const float space_x = 20;
    float h_toast = space_y + h_imgView + space_y/2 + h_tx + space_y;
    float w_toast = sizeFont.width + space_x*2;
    float x_toast = (self.bounds.size.width - w_toast)/2;
    float y_toast = (self.bounds.size.height - h_toast)/2;
    UIView *viewToast = [UIView new];
    [viewToast setFrame:CGRectMake(x_toast, y_toast, w_toast, h_toast)];
    [viewToast setBackgroundColor:Color_RGBA(120, 120, 120, 0.9f)];
    [viewToast setClipsToBounds:YES];
    [viewToast.layer setCornerRadius:4.0f];
    [self addSubview:viewToast];
    m_viewToast = viewToast;
    
    // ====== 图标 ======
    float h_add = h_imgView;
    float w_add = h_add;
    float y_add = space_y;
    float x_add = (viewToast.bounds.size.width - w_add)/2;
    UIImageView *imgView = [UIImageView new];
    [imgView setFrame:CGRectMake(x_add, y_add, w_add, h_add)];
    [imgView setBackgroundColor:Color_Transparent];
    [imgView setContentMode:UIViewContentModeScaleToFill];
    [imgView setImage:GetImg(@"iconfont_dachaguanbi")];
    [viewToast addSubview:imgView];
    y_add += imgView.frame.size.height;
    y_add += space_y/2;
    
    // ====== 文字 ======
    w_add = sizeFont.width;
    h_add = sizeFont.height;
    x_add = (viewToast.bounds.size.width - w_add)/2;
    UILabel *labName = [UILabel new];
    [labName setFrame:CGRectMake(x_add, y_add, w_add, h_add)];
    [labName setBackgroundColor:Color_Transparent];
    [labName setFont:fontTX];
    [labName setTextColor:Color_RGB(255, 255, 255)];
    [labName setTextAlignment:NSTextAlignmentCenter];
    [labName setNumberOfLines:2];
    [labName setLineBreakMode:NSLineBreakByTruncatingTail];
    [labName setText:m_strContent];
    [labName setUserInteractionEnabled:NO];
    [viewToast addSubview:labName];
    y_add += labName.frame.size.height;
    y_add += space_y;
}
/** 开始动画 */
- (void) beginAni
{
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.5;
    [animation setDelegate:(id)self];
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    [animation setValue:AnimationKey_BeginAni forKey:AnimationKey_BeginAni];
    [m_viewToast.layer addAnimation:animation forKey:@"animationBegin"];
}
/** 结束动画 */
- (void) endAni
{
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.5;
    animation.delegate = (id)self;
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 0.9)]];
//    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.2)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 0.1)]];
    animation.values = values;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    [animation setValue:AnimationKey_EndAni forKey:AnimationKey_EndAni];
    [m_viewToast.layer addAnimation:animation forKey:@"animationBegin"];
}

// ==============================================================================================
#pragma mark 委托协议CAAnimationDelegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if([anim valueForKey:AnimationKey_BeginAni] != nil){
        [self performSelector:@selector(endAni) withObject:nil afterDelay:1.5f];
        
    } else if([anim valueForKey:AnimationKey_EndAni] != nil){
        [self removeFromSuperview];
    }
}
@end
