//
//  UDP.m
//  HotelSystem
//
//  Created by LHJ on 16/4/15.
//  Copyright © 2016年 hancj. All rights reserved.
//

#import "UDP_ShareIP.h"
#import "AsyncUdpSocket.h"
#import "CPublic.h"

#define Port_ShareIP    8981

const int TimeDuration  = 3;

@implementation UDP_ShareIP
{
    AsyncUdpSocket  *m_udpSocket;
    NSTimer         *m_timer;
    NSDictionary    *m_dicDataOfSend;
    
    BOOL            m_bIsSendData;
}
// ==============================================================================================
#pragma mark - 内部方法
- (instancetype) init
{
    self = [super init];
    if(self != nil){
    
    }
    return self;
}
/** 初始化数据 */
- (void) initData
{
    m_bIsSendData = NO;
}
- (void) dealloc
{
    [self closeShare];
}
/** 发送该设备的IP和端口 */
- (void) sendShareIPAndPort
{
    NSData *data = [self getSendData];
    if(data != nil
       && m_udpSocket != nil){
        [m_udpSocket sendData:data withTimeout:-1 tag:0];
    } else {
        NSLog(@"%@", ShowContentForLog(@"UDP发送数据失败"));
    }
}
/** 获取发送数据 */
- (NSData*) getSendData
{
//    NSString *strAddressID = [CPublic getLocalWiFiIPAddress];
//    NSDictionary *dic = @{Params_ShareIP : strAddressID,
//                          Params_SharePort : @(Params_ValueOfSharePort)};
//    NSString *strData = [CPublic getJsonStrWithDicObj:dic];
    NSString *strData = [CPublic getJsonStrWithDicObj:m_dicDataOfSend];
    return [strData dataUsingEncoding:NSUTF8StringEncoding];
}
// ==============================================================================================
#pragma mark - 外部调用方法
/** 开始发送分享数据的请求 */
- (BOOL) startShareWithData:(NSDictionary*)v_dicData
{
    m_dicDataOfSend = v_dicData;
    if(m_dicDataOfSend == nil){
        return NO;
    }
    
    Reachability *reachability = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    //结果说明：0-无连接   1-wifi    2-3G
    NSInteger stateNet = [reachability currentReachabilityStatus];
    if(stateNet != 1){
        [CPublic ShowDialg:@"请连接WIFI才能使用共享数据功能"];
        return NO;
    }
    if(m_udpSocket != nil){
        [self closeShare];
    }
    
    m_udpSocket = [[AsyncUdpSocket alloc] initWithDelegate:self];
    NSError *error = nil;
    BOOL bIsEnable = [m_udpSocket bindToAddress:@"255.255.255.255" port:Port_ShareIP error:&error];
    if(bIsEnable != YES){
        if(error != nil){
            NSString *strError = [NSString stringWithFormat:@"连接UDP广播失败，失败原因：%@", error];
            NSLog(@"%@", ShowContentForLog(strError));
            [CPublic ShowDialg:strError];
             return NO;
        }
    }
    
    bIsEnable = [m_udpSocket enableBroadcast:YES error:&error];
    if(bIsEnable != YES){
        if(error != nil){
            NSString *strError = [NSString stringWithFormat:@"连接UDP广播失败，失败原因：%@", error];
            NSLog(@"%@", ShowContentForLog(strError));
            [CPublic ShowDialg:strError];
            return NO;
        }
    }
    m_timer = [NSTimer scheduledTimerWithTimeInterval:TimeDuration target:self selector:@selector(sendShareIPAndPort) userInfo:nil repeats:YES];
    [m_timer fire];
    m_bIsSendData = YES;
    return YES;
}
/** 关闭分享数据 */
- (void) closeShare
{
    [m_timer invalidate];
    m_timer = nil;
    if(m_udpSocket != nil){
        [m_udpSocket close];
        m_udpSocket = nil;
    }
    m_bIsSendData = NO;
}
/** 是否正在分享数据 */
- (BOOL) isSharedData
{
    return m_bIsSendData;
}

// ==================================================================================
#pragma mark - 委托协议AsyncUdpSocketDelegate
- (void)onUdpSocket:(AsyncUdpSocket *)sock didSendDataWithTag:(long)tag
{
    
}

- (void)onUdpSocket:(AsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError *)error
{

}

- (BOOL)onUdpSocket:(AsyncUdpSocket *)sock didReceiveData:(NSData *)data withTag:(long)tag fromHost:(NSString *)host port:(UInt16)port
{
    return YES;
}
- (void)onUdpSocket:(AsyncUdpSocket *)sock didNotReceiveDataWithTag:(long)tag dueToError:(NSError *)error
{

}

- (void)onUdpSocketDidClose:(AsyncUdpSocket *)sock
{

}

@end
