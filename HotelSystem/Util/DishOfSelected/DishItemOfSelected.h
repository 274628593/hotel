//
//  DishItemOfSelected.h
//  HotelSystem
//
//  Created by LHJ on 16/3/26.
//  Copyright © 2016年 hancj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DishItem.h"

/** 已经选择的菜 */
@interface DishItemOfSelected : DishItem

/** 用菜对象初始化已选菜的对象 */
+ (DishItemOfSelected*) dishItemOfSelectedWithDishItem:(DishItem*)v_dishItem;

/** 菜选择的数量，默认1 */
@property(nonatomic, assign, setter=setDishSelectNum:, getter=getDishSelectNum) int m_dishSelectNum;

/** 价格折扣 */
@property(nonatomic, assign, setter=setDishPriceDiscount:, getter=getDishPriceDiscount) float m_dishPriceDiscount;

@end
