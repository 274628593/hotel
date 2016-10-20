//
//  View_ShowImgOfHD.h
//  MachineModule
//
//  Created by LHJ on 15/12/26.
//  Copyright © 2015年 LHJ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef UIView* (^ReturnViewWithClick)(CGRect v_frame) ;

/** 点击显示高清图片的view */
@interface View_ShowImgOfHD : UIView

// ==============================================================================================
#pragma mark -  外部方法

// ==============================================================================================
#pragma mark -  外部变量
/** 返回自定义的点击View，点击该View之后显示高清图 */
@property(nonatomic, copy, setter=setBlock:) ReturnViewWithClick m_block;

/** 高清图地址 */
@property(nonatomic, copy, setter=setImgURLOfHDImg:, getter=getImgURLOfHDImg) NSString *m_strImgURLOfHDImg;

@end
