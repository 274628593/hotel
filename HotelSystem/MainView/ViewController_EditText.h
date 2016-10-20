//
//  EditTextViewController.h
//  MachineModule
//
//  Created by LHJ on 15/12/31.
//  Copyright © 2015年 LHJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditViewWithIcon.h"

@protocol ViewController_EditTextDelegate;

/** 修改文本的ViewController */
@interface ViewController_EditText : UIViewController<EditViewWithIconDelegate>

// ==============================================================================================
#pragma mark -  外部方法

// ==============================================================================================
#pragma mark -  外部变量
/** 委托 */
@property(nonatomic, weak, setter=setDelegate:) id<ViewController_EditTextDelegate> m_delegate;

/** 导航栏标题 */
@property(nonatomic, copy, setter=setNavTitle:, getter=getNavTitle) NSString *m_strNavTitle;

/** 初始文本 */
@property(nonatomic, copy, setter=setTextBegin:, getter=getTextBegin) NSString *m_strTextBegin;

/** Tag标识 */
@property(nonatomic, assign, setter=setTag:, getter=getTag) int m_tag;

/** 存储对象 */
@property(nonatomic, retain, setter=setExtraObj:, getter=getExtraObj) id m_extraObj;

@end

// ==============================================================================================
#pragma mark -  委托协议
@protocol ViewController_EditTextDelegate<NSObject>

/** 返回编辑的结果值 */
- (void) getEditTextResult:(NSString*)v_strResult _tag:(int)v_tag _sender:(id)v_sender;

@end
