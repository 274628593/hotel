//
//  Socket_ReceiveData.h
//  HotelSystem
//
//  Created by LHJ on 16/4/20.
//  Copyright © 2016年 hancj. All rights reserved.
//

#import <Foundation/Foundation.h>

/** Socket - 接收文件数据 */
@interface Socket_ReceiveData : NSObject

// ==============================================================================================
#pragma mark - 外部调用方法
/** 开始接收数据的请求 */
- (void) startReceive;

/** 关闭接收数据 */
- (void) closeReceive;

// ==============================================================================================
#pragma mark - 外部变量

@end
