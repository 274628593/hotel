//
//  DishItem.h
//  HotelSystem
//
//  Created by LHJ on 16/3/24.
//  Copyright © 2016年 hancj. All rights reserved.
//

#import <Foundation/Foundation.h>

/** 菜 */
@interface DishItem : NSObject

// =========================================================
#pragma mark 外部变量

/** 菜ID */
@property(nonatomic, copy, setter=setDishID:, getter=getDishID) NSString *m_strDishID;

/** 菜名称 */
@property(nonatomic, copy, setter=setDishName:, getter=getDishName) NSString *m_strDishName;

/** 菜图片路径 */
@property(nonatomic, copy, setter=setDishIconImgPath:, getter=getDishIconImgPath) NSString *m_strDishIconImgPath;

/** 所属的菜系ID */
@property(nonatomic, copy, setter=setDishStyleID:, getter=getDishStyleID) NSString *m_strDishStyleID;

/** 所属的菜系名 */
@property(nonatomic, copy, setter=setDishStyleName:, getter=getDishStyleName) NSString *m_strDishStyleName;

/** 菜简介 */
@property(nonatomic, copy, setter=setDishDescrition:, getter=getDishDescrition) NSString *m_strDishDescrition;

/** 价格 */
@property(nonatomic, assign, setter=setDishPrice:, getter=getDishPrice) float m_dishPrice;

/** 是否是推荐菜，YES为推荐，NO为不推荐 */
@property(nonatomic, assign, setter=setIsDishRecommend:, getter=getIsDishRecommend) BOOL m_bIsDishRecommend;

@end
