//
//  MenuTypeItem.h
//  HotelSystem
//
//  Created by hancj on 15/11/20.
//  Copyright © 2015年 hancj. All rights reserved.
//

#import <Foundation/Foundation.h>

/** 菜系选择对象 */
@interface DishStyleItem : NSObject

// =========================================================
#pragma mark 外部变量

/** 菜系ID */
@property(nonatomic, copy, setter=setDishStyleID:, getter=getDishStyleID) NSString *m_strDishStyleID;

/** 菜系名称 */
@property(nonatomic, copy, setter=setDishStyleName:, getter=getDishStyleName) NSString *m_strDishStyleName;

/** 菜系图片路径 */
@property(nonatomic, copy, setter=setDishStyleIconImgPath:, getter=getDishStyleIconImgPath) NSString *m_strDishStyleIconImgPath;


@end
