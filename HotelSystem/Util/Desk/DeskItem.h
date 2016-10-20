//
//  DeskItem.h
//  HotelSystem
//
//  Created by hancj on 15/11/16.
//  Copyright © 2015年 hancj. All rights reserved.
//

#import <Foundation/Foundation.h>

/** 桌子项对象 */
@interface DeskItem : NSObject

// =========================================================
#pragma mark - 外部调用方法

// =========================================================
#pragma mark - 外部变量
/** 桌子ID */
@property(nonatomic, copy, setter=setDeskID:, getter=getDeskID) NSString *m_strDeskID;

/** 桌子号 */
@property(nonatomic, assign, setter=setDeskNum:, getter=getDeskNum) int m_deskNum;

@end
