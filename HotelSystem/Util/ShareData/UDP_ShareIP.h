//
//  UDP.h
//  HotelSystem
//
//  Created by LHJ on 16/4/15.
//  Copyright © 2016年 hancj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Params.h"

/** 用UDP共享设备IP，接收到该IP的设备启动Scoket连接 */
@interface UDP_ShareIP : NSObject

// ==============================================================================================
#pragma mark - 外部调用方法
/** 开始发送分享数据的请求 */
- (BOOL) startShareWithData:(NSDictionary*)v_dicData;

/** 关闭分享数据 */
- (void) closeShare;

/** 是否正在分享数据 */
- (BOOL) isSharedData;

// ==============================================================================================
#pragma mark - 外部变量

@end
