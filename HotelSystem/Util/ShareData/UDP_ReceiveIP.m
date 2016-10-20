//
//  UDP_ReceiveIP.m
//  HotelSystem
//
//  Created by LHJ on 16/4/15.
//  Copyright © 2016年 hancj. All rights reserved.
//

#import "UDP_ReceiveIP.h"
#import "AsyncUdpSocket.h"
#import "CPublic.h"
#import "Params.h"

#define Port_ReceiveIP    8981

@implementation UDP_ReceiveIP
{
    AsyncUdpSocket  *m_udpSocket;
    
    NSString                *m_strAddress;
    int                     m_port;
    NSMutableDictionary     *m_muDicReceiveData;
    BOOL                    m_bIsReceiving;
}
@synthesize m_delegate;

// ==============================================================================================
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
    m_bIsReceiving = NO;
    m_strAddress = @"";
    m_port = 0;
    m_udpSocket = [[AsyncUdpSocket alloc] initWithDelegate:self];
    NSError *error = nil;
    BOOL bIsEnable = [m_udpSocket bindToAddress:@"255.255.255.255" port:Port_ReceiveIP error:&error];
    if(bIsEnable != YES){
        if(error != nil){
            NSLog(@"连接UDP广播失败，失败原因：%@", error);
        }
    }
    
    bIsEnable = [m_udpSocket enableBroadcast:YES error:&error];
    if(bIsEnable != YES){
        if(error != nil){
            NSLog(@"开启UDP广播失败，失败原因：%@", error);
        }
    }
}
- (void) dealloc
{
    [self closeReceive];
}
// ==============================================================================================
#pragma mark - 外部调用方法
/** 开始接收IP的分享消息 */
- (void) startReceive
{
    Reachability *reachability = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    //结果说明：0-无连接   1-wifi    2-3G
    NSInteger stateNet = [reachability currentReachabilityStatus];
    if(stateNet != 1) {
        [CPublic ShowDialg:@"请连接WIFI才能使用共享数据功能"];
        return;
    }
    [m_udpSocket receiveWithTimeout:-1 tag:0];
    m_bIsReceiving = YES;
}

/** 关闭分享数据 */
- (void) closeReceive
{
    if(m_udpSocket != nil){
        [m_udpSocket close];
        m_udpSocket = nil;
    }
    m_bIsReceiving = NO;
}
/** 是否正在监听 */
- (BOOL) isReceiveDataNow
{
    return m_bIsReceiving;
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
    if(data != nil){
        NSString *strData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSDictionary *dicData = [CPublic getDicObjWithJsonStr:strData];
        
        if(m_muDicReceiveData == nil){
            m_muDicReceiveData = [NSMutableDictionary new];
        }
        
        NSString *strKey = [NSString stringWithFormat:@"%@_%i", host, port];
        if([m_muDicReceiveData objectForKey:strKey] != nil){
            NSString *strAddress = [dicData objectForKey:Params_ShareIP];
            NSNumber *number = [dicData objectForKey:Params_SharePort];
            int port = [number intValue]; // 端口号
            
            NSDictionary *dicDataBefore = m_muDicReceiveData[strKey];
            NSString *strAddressBefore = [dicDataBefore objectForKey:Params_ShareIP];
            NSNumber *numberBefore = [dicDataBefore objectForKey:Params_SharePort];
            int portBefore = [numberBefore intValue];
            if([strAddressBefore isEqualToString:strAddress] != YES
                    || port != portBefore){ // 数据有更新，重新发送
                [m_muDicReceiveData setObject:dicData forKey:strKey];
                [m_delegate receiveNewData:dicData];
            }
            
        } else {
            [m_muDicReceiveData setObject:dicData forKey:strKey];
            [m_delegate receiveNewData:dicData];
        }
    }
    return YES;
}
- (void)onUdpSocket:(AsyncUdpSocket *)sock didNotReceiveDataWithTag:(long)tag dueToError:(NSError *)error
{
    
}

- (void)onUdpSocketDidClose:(AsyncUdpSocket *)sock
{
    
}
@end
