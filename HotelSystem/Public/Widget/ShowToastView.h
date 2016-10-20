//
//  ShowToastView.h
//  MachineModule
//
//  Created by LHJ on 15/12/15.
//  Copyright © 2015年 LHJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShowToastView : UIView<UIApplicationDelegate>

// ==============================================================================================
#pragma mark -  外部方法

// ==============================================================================================
#pragma mark -  外部变量
/** 显示内容 */
@property(nonatomic, copy, setter=setContent:, getter=getContent) NSString *m_strContent;

@end
