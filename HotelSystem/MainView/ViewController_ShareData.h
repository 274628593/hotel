//
//  ViewController_ShareData.h
//  HotelSystem
//
//  Created by LHJ on 16/4/14.
//  Copyright © 2016年 hancj. All rights reserved.
//

#import "UIViewController_Base.h"

@class UDP_ShareIP;
@class UDP_ReceiveIP;

@protocol ViewController_ShareDataDelegate;
@protocol UDP_ReceiveIPDelegate;

/** 共享数据 */
@interface ViewController_ShareData : UIViewController_Base<UDP_ReceiveIPDelegate>

// ==================================================================================
#pragma mark - 外部调用方法

// ==================================================================================
#pragma mark - 外部变量
/** 委托 */
@property(nonatomic, weak, setter=setDelegate:, getter=getDelegate) id<ViewController_ShareDataDelegate> m_delegate;

/** Tag */
@property(nonatomic, assign, setter=setTag:, getter=getTag) int m_tag;

@end

// ==================================================================================
#pragma mark - 委托协议
@protocol ViewController_ShareDataDelegate<NSObject>

@end
