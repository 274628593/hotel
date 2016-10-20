//
//  Socket_ReceiveData.m
//  HotelSystem
//
//  Created by LHJ on 16/4/20.
//  Copyright © 2016年 hancj. All rights reserved.
//

#import "Socket_ReceiveData.h"
#import "AsyncSocket.h"
#import "CPublic.h"

@implementation Socket_ReceiveData
{
    AsyncSocket     *m_asyncSocket;
}
// ==============================================================================================
#pragma mark - 内部使用方法
- (instancetype) init
{
    self = [super init];
    if(self != nil){
        [self initData];
    }
    return self;
}
/** 初始化数据 */
- (void) initData
{
    m_asyncSocket = [[AsyncSocket alloc] initWithDelegate:self];
}

// ==============================================================================================
#pragma mark - 外部调用方法
/** 开始接收数据的请求 */
- (void) startReceive
{
    
}

/** 关闭接收数据 */
- (void) closeReceive
{
    
}
// ==============================================================================================
#pragma mark - 委托协议AsyncSocketDelegate
- (void)onSocket:(AsyncSocket *)sock willDisconnectWithError:(NSError *)err
{
    
}
- (void)onSocketDidDisconnect:(AsyncSocket *)sock
{
    
}
/** 当接收到新的连接请求时，会调用这个方法  */
- (void)onSocket:(AsyncSocket *)sock didAcceptNewSocket:(AsyncSocket *)newSocket
{
    
}
//- (NSRunLoop *)onSocket:(AsyncSocket *)sock wantsRunLoopForNewSocket:(AsyncSocket *)newSocket
//{
//
//}
- (BOOL)onSocketWillConnect:(AsyncSocket *)sock
{
    return YES;
}
- (void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port
{
    
}
- (void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    
}

/**
 * Called when a socket has read in data, but has not yet completed the read.
 * This would occur if using readToData: or readToLength: methods.
 * It may be used to for things such as updating progress bars.
 **/
- (void)onSocket:(AsyncSocket *)sock didReadPartialDataOfLength:(NSUInteger)partialLength tag:(long)tag
{
    
}
/**
 * Called when a socket has completed writing the requested data. Not called if there is an error.
 **/
- (void)onSocket:(AsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    
}

- (void)onSocket:(AsyncSocket *)sock didWritePartialDataOfLength:(NSUInteger)partialLength tag:(long)tag
{
    
}

@end
