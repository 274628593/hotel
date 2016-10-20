//
//  Socket_ShareData.m
//  HotelSystem
//
//  Created by LHJ on 16/4/19.
//  Copyright © 2016年 hancj. All rights reserved.
//

#import "Socket_ShareData.h"
#import "AsyncSocket.h"
#import "CPublic.h"

@implementation Socket_ShareData
{
    AsyncSocket     *m_asyncSocket;
    NSString        *m_strInterface;
    int             m_port;
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
    if(m_asyncSocket == nil){
        m_asyncSocket = [[AsyncSocket alloc] initWithDelegate:self];
    }
}

// ==============================================================================================
#pragma mark - 外部调用方法

/** 关闭分享数据 */
- (void) closeConnect
{
    if(m_asyncSocket != nil){
        if([m_asyncSocket isConnected] == YES){ // 读/写之后关闭连接
            [m_asyncSocket disconnectAfterReadingAndWriting];
        }
    }
}
/** 设置端口，只接收局域网内部的请求，当收到请求的时候，自动接收并发送数据 */
- (BOOL) setAcceptPort:(int)v_port
{
    return [self setAcceptInface:@"localhost" _port:v_port];
}
/** 设置监听IP和端口，当收到请求的时候，自动接收并发送数据 */
- (BOOL) setAcceptInface:(NSString*)v_strInterface _port:(int)v_port
{
    m_strInterface = v_strInterface;
    m_port = v_port;
    return [self startListen];
}
/** 开始监听，需要事先设置IP/端口号，也可以直接调用setAccept***接口开始接听 */
- (BOOL) startListen
{
    BOOL bResult = NO;
    if(m_asyncSocket != nil){
        NSError *error = nil;
        bResult = [m_asyncSocket acceptOnInterface:m_strInterface port:m_port error:&error];
        if(bResult == YES){
            NSLog(@"启动Socket成功，端口号：%i", m_port);
        } else {
            NSLog(@"启动Socket监听失败，原因：%@", error.description);
        }
    }
    return bResult;
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
