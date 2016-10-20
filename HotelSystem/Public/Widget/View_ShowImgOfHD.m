//
//  View_ShowImgOfHD.m
//  MachineModule
//
//  Created by LHJ on 15/12/26.
//  Copyright © 2015年 LHJ. All rights reserved.
//

#import "View_ShowImgOfHD.h"
#import "CPublic.h"
#import "DialogOfLoadingViewController.h"

typedef enum : int{
    ViewTag_ViewNormal = 1,
    ViewTag_ViewHD,
    
} ViewTag;

@implementation View_ShowImgOfHD
{
    BOOL            m_bIsLayoutView;
    UIImage         *m_imgHD;
    UIImageView     *m_imgViewHD;
}
@synthesize m_block;
@synthesize m_strImgURLOfHDImg;
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
    
    [self initLayoutView];
    [self handleImgHDWIthWiFiStatus];
}
- (void) dealloc
{
    m_imgHD = nil;
}
// ==============================================================================================
#pragma mark 内部使用方法
/** 初始化数据 */
- (void) initData
{
    m_bIsLayoutView = NO;
    m_strImgURLOfHDImg = @"";
    m_imgHD = nil;
}
/** 初始化布局 */
- (void) initLayoutView
{
    m_bIsLayoutView = YES;
    
    UIView *view = m_block(self.bounds);
    [self addSubview:view];
    
    [view setTag:ViewTag_ViewNormal];
    // 添加单击手势
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                             action:@selector(handleTapGes:)];
    [view addGestureRecognizer:tapGes];
}
/** 判断网络状态，如果是WIFI，则自动下载图片，如果是3G，则不下载*/
- (void) handleImgHDWIthWiFiStatus
{
    NetworkStatusNow network = [CPublic getNetworkStatusNow];
    if(network == NetworkStatusNow_WiFi){ // WIFI环境
        NSOperationQueue *operationQueue = [[NSOperationQueue alloc] init];
        NSInvocationOperation *op = [[NSInvocationOperation alloc] initWithTarget:self
                                                                         selector:@selector(downloadImage)
                                                                           object:nil];
        [operationQueue addOperation:op];
    }
}
/** 下载图片 */
- (void)downloadImage
{
    NSURL *imageUrl = [NSURL URLWithString:[m_strImgURLOfHDImg stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    m_imgHD = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageUrl]];
}
/** 显示大头像 */
- (void) showImgViewOfHD
{
    if(m_imgViewHD == nil){ // 初始化
        UIImageView *imgView = [UIImageView new];
        [imgView setFrame:[UIScreen mainScreen].bounds];
        [imgView setBackgroundColor:Color_RGB(0, 0, 0)];
        [imgView setUserInteractionEnabled:YES];
        [imgView setContentMode:UIViewContentModeScaleAspectFit];
        [imgView setTag:ViewTag_ViewHD];
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGes:)];
        [imgView addGestureRecognizer:tapGes];
        m_imgViewHD = imgView;
    }
    
    if(m_imgHD == nil){ // 显示图片
        DialogOfLoadingViewController *viewDialog= [DialogOfLoadingViewController new];
        [m_imgViewHD addSubview:viewDialog];
        [m_imgViewHD sd_setImageWithURL:[CPublic getURLFromString:m_strImgURLOfHDImg]
                          completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
         {
             [viewDialog removeFromSuperview];
             if(image != nil){ // 加载成功
                 m_imgHD = image;
             }
         }];
    } else { // 显示已经下载好的图片
        [m_imgViewHD setImage:m_imgHD];
        
    }
    // 动画显示
    [[UIApplication sharedApplication].keyWindow addSubview:m_imgViewHD];
    [UIView animateWithDuration:0.3f animations:^{
        [m_imgViewHD setAlpha:0.0f];
        [m_imgViewHD setAlpha:1.0f];
    }];
}

// ==============================================================================================
#pragma mark 动作触发方法
/** 处理单击手势 */
- (void) handleTapGes:(UITapGestureRecognizer*)v_ges
{
    UIView *view = v_ges.view;
    
    switch((ViewTag)view.tag){
        case ViewTag_ViewNormal:{
            [self showImgViewOfHD];
            break;
        }
        case ViewTag_ViewHD:{ // 关闭高清图
            [view removeFromSuperview];
            break;
        }
    }
}

@end
