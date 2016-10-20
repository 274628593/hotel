//
//  DishItemOfSelected.m
//  HotelSystem
//
//  Created by LHJ on 16/3/26.
//  Copyright © 2016年 hancj. All rights reserved.
//

#import "DishItemOfSelected.h"

@implementation DishItemOfSelected

@synthesize m_dishSelectNum;
@synthesize m_dishPriceDiscount;

/** 用菜对象初始化已选菜的对象 */
+ (DishItemOfSelected*) dishItemOfSelectedWithDishItem:(DishItem*)v_dishItem
{
    DishItemOfSelected *itemObjRS = [DishItemOfSelected new];
    [itemObjRS setDishID:[v_dishItem getDishID]];
    [itemObjRS setDishName:[v_dishItem getDishName]];
    [itemObjRS setDishDescrition:[v_dishItem getDishDescrition]];
    [itemObjRS setDishIconImgPath:[v_dishItem getDishIconImgPath]];
    [itemObjRS setDishPrice:[v_dishItem getDishPrice]];
    [itemObjRS setDishStyleID:[v_dishItem getDishStyleID]];
    [itemObjRS setDishStyleName:[v_dishItem getDishStyleName]];
    [itemObjRS setIsDishRecommend:[v_dishItem getIsDishRecommend]];
    return itemObjRS;
}

- (instancetype) init
{
    self = [super init];
    if(self != nil){
        m_dishSelectNum = 1;
        m_dishPriceDiscount = 1.0f;
    }
    return self;
}

@end
