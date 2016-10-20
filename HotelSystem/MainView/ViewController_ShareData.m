//
//  ViewController_ShareData.m
//  HotelSystem
//
//  Created by LHJ on 16/4/14.
//  Copyright © 2016年 hancj. All rights reserved.
//

#import "ViewController_ShareData.h"
#import "CPublic.h"
#import "UDP_ShareIP.h"
#import "UDP_ReceiveIP.h"
#import "Socket_ShareData.h"

#define ColorText   Color_RGB(255, 255, 255)
#define FontText    Font(24.0)

typedef enum : int{
    ViewTag_StartSendData = 1 << 0, /* 开始发送数据 */
    ViewTag_StartReceiveData = 1 << 1, /* 开始接收数据 */
    ViewTag_EndSendData = 1 << 2, /* 结束发送数据 */
    ViewTag_EndReceiveData = 1 << 3, /* 结束接收数据 */
}ViewTag;

@implementation ViewController_ShareData
{
    UIButton    *m_btnStartSendData;
    UIButton    *m_btnStartReceiveData;
    
    UDP_ShareIP         *m_udpShareIP;
    UDP_ReceiveIP       *m_udpReceiveIP;
    Socket_ShareData    *m_socketShareData;
}
@synthesize m_delegate;
@synthesize m_tag;

// ==================================================================================
#pragma mark - 父类方法
- (instancetype) init
{
    self = [super init];
    if(self != nil){
        [self initData];
    }
    return self;
}
- (void) viewDidLoad{
    [super viewDidLoad];
    [self initNavView];
    [self initMainView];
}
- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
- (void) viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    [self addAllViewToViewController];
}
- (void) viewWillDisappear:(BOOL)animated
{
    [m_udpShareIP closeShare];
    [m_socketShareData closeConnect];
}
// ==================================================================================
#pragma mark - 内部调用方法
/** 初始化导航栏 */
- (void) initNavView
{
    self.navigationItem.title = @"共享数据";
}
/** 初始化数据 */
- (void) initData
{

}
/** 初始化所有视图View */
- (void) initMainView
{
    if(m_btnStartReceiveData == nil){
        UIButton *btn = [UIButton new];
        [btn setBackgroundColor:Color_RGB(200, 30, 20)];
        [btn.titleLabel setFont:FontText];
        [btn setTag:ViewTag_StartReceiveData];
        [btn setTitle:@"开始接收数据" forState:UIControlStateNormal];
        [btn setTitleColor:ColorText forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        m_btnStartReceiveData = btn;
    }
    if(m_btnStartSendData == nil){
        UIButton *btn = [UIButton new];
        [btn setBackgroundColor:Color_RGB(30, 200, 20)];
        [btn.titleLabel setFont:FontText];
        [btn setTag:ViewTag_StartSendData];
        [btn setTitle:@"开始共享数据" forState:UIControlStateNormal];
        [btn setTitleColor:ColorText forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        m_btnStartSendData = btn;
    }
}

/** 将所有View添加到控制中显示 */
- (void) addAllViewToViewController
{
    UIView *viewMain = self.view;
    [viewMain setBackgroundColor:[UIColor whiteColor]];
    
    const float space_x = 20;
    float w_add = (viewMain.bounds.size.width - space_x*4)/2;
    float h_add = [CPublic getTextHeight:@"高" _font:FontText]*3/2;
    float x_add = viewMain.bounds.size.width/2 - space_x - w_add;
    float y_add = (viewMain.bounds.size.height - h_add)/2;
    if(m_btnStartSendData != nil) { // 开始发送数据的按钮
        [m_btnStartSendData setFrame:CGRectMake(x_add, y_add, w_add, h_add)];
        [viewMain addSubview:m_btnStartSendData];
    }
    
    x_add = viewMain.bounds.size.width/2 + space_x;
    if(m_btnStartReceiveData != nil){ // 开始接收数据的按钮
        [m_btnStartReceiveData setFrame:CGRectMake(x_add, y_add, w_add, h_add)];
        [viewMain addSubview:m_btnStartReceiveData];
    }
}
/** 做分享设备前的IP发送工作 */
- (void) beginShareIP
{
    if(m_udpShareIP != nil
        && [m_udpShareIP isSharedData] == YES){
        [CPublic ShowDialg:@"正在分享数据..."];
        
    } else {
        NSLog(@"%@", ShowContentForLog(@"开始分享数据..."));
        if(m_udpShareIP == nil){
            m_udpShareIP = [UDP_ShareIP new];
        }
        NSString *strAddressID = [CPublic getLocalWiFiIPAddress];
        NSDictionary *dicData = @{Params_ShareIP : strAddressID,
                                  Params_SharePort : @(Params_ValueOfSharePort)};
        BOOL bIsSend = [m_udpShareIP startShareWithData:dicData];
        if(bIsSend == YES){
            if(m_socketShareData == nil){
                m_socketShareData = [[Socket_ShareData alloc] init];
            }
            [m_socketShareData setAcceptPort:Params_ValueOfSharePort]; // 开始监听
        }
    }
}
/** 关闭分享数据 */
- (void) endShareIP
{
    NSLog(@"%@", ShowContentForLog(@"结束分享数据..."));
    if(m_udpShareIP != nil){
        [m_udpShareIP closeShare];
    }
}
/** 开始检测是否有设备正在发送数据 */
- (void) startReceiveUdp
{
    if(m_udpReceiveIP == nil
       || [m_udpReceiveIP isReceiveDataNow] != YES){
    
    } else {
        [CPublic ShowDialg:@"正在搜索数据..."];
    }
}
/** 停止监听UDP */
- (void) endReceiveUdp
{

}
// ==================================================================================
#pragma mark - 动作触发方法
/** Button按钮点击事件 */
- (void) clickBtn:(UIButton*)v_btn
{
    ViewTag viewTag = (ViewTag)(v_btn.tag);
    switch(viewTag){
        case ViewTag_StartReceiveData:{ // 开始接收数据
            [self startReceiveUdp];
            break;
        }
        case ViewTag_StartSendData:{ // 开始共享数据
            [self beginShareIP];
            break;
        }
        case ViewTag_EndReceiveData:{ // 结束接收数据
            [self endReceiveUdp];
            break;
        }
        case ViewTag_EndSendData:{ // 结束共享数据
            [self endShareIP];
            break;
        }
    }
}
// ==================================================================================
#pragma mark - UDP_ReceiveIPDelegate
/** 当接收到新数据的时候回调这个接口 */
- (void) receiveNewData:(NSDictionary*)v_dic
{

}

@end
