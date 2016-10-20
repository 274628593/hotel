//
//  DishItem.m
//  HotelSystem
//
//  Created by LHJ on 16/3/24.
//  Copyright © 2016年 hancj. All rights reserved.
//

#import "DishItem.h"

@implementation DishItem

@synthesize m_bIsDishRecommend;
@synthesize m_dishPrice;
@synthesize m_strDishDescrition;
@synthesize m_strDishIconImgPath;
@synthesize m_strDishID;
@synthesize m_strDishName;
@synthesize m_strDishStyleID;
@synthesize m_strDishStyleName;

- (void) setDishID:(NSString*)v_strDishId
{
    m_strDishID = v_strDishId;
}

@end
