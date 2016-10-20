//
//  Socket_ShareData.h
//  HotelSystem
//
//  Created by LHJ on 16/4/19.
//  Copyright © 2016年 hancj. All rights reserved.
//

#import <Foundation/Foundation.h>

/** Socket - 发送文件数据 */
@interface Socket_ShareData : NSObject

// ==============================================================================================
#pragma mark - 外部调用方法

/** 关闭分享数据 */
- (void) closeConnect;

/** 设置监听IP和端口，当收到请求的时候，自动接收并发送数据 */
- (BOOL) setAcceptInface:(NSString*)v_strInterface _port:(int)v_port;

/** 设置端口，只接收局域网内部的请求，当收到请求的时候，自动接收并发送数据 */
- (BOOL) setAcceptPort:(int)v_port;

/** 开始监听，需要事先设置IP/端口号，也可以直接调用setAccept***接口开始接听 */
- (BOOL) startListen;

// ==============================================================================================
#pragma mark - 外部变量

@end
