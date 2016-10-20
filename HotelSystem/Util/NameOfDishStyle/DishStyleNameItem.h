//
//  DishStyleNameItem.h
//  HotelSystem
//
//  Created by LHJ on 16/3/20.
//  Copyright © 2016年 hancj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DishStyleNameItem : NSObject

// =========================================================
#pragma mark 外部变量

/** 菜系ID */
@property(nonatomic, copy, setter=setDishStyleNameItemID:, getter=getDishStyleNameItemID) NSString *m_strDishStyleNameItemID;

/** 菜系名称 */
@property(nonatomic, copy, setter=setDishStyleNameItemName:, getter=getDishStyleNameItemName) NSString *m_strDishStyleNameItemName;


@end
