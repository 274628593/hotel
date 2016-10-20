//
//  UDP_ReceiveIP.h
//  HotelSystem
//
//  Created by LHJ on 16/4/15.
//  Copyright © 2016年 hancj. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol UDP_ReceiveIPDelegate<NSObject>

@required
/** 当接收到新数据的时候回调这个接口 */
- (void) receiveNewData:(NSDictionary*)v_dic;

@end

/** 接收广播IP的UDP，接收到IP后就启动Scoket连接该IP */
@interface UDP_ReceiveIP : NSObject

// ==============================================================================================
#pragma mark - 外部调用方法
/** 开始接收IP的分享消息 */
- (void) startReceive;

/** 关闭分享数据 */
- (void) closeReceive;

/** 是否正在监听 */
- (BOOL) isReceiveDataNow;

// ==============================================================================================
#pragma mark - 外部变量
/** 委托 */
@property(nonatomic, weak, setter=setDelegate:, getter=getDelegate) id<UDP_ReceiveIPDelegate> m_delegate;

@end
