//
//  EditViewWithIcon.h
//  MachineModule
//
//  Created by LHJ on 15/12/11.
//  Copyright © 2015年 LHJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditView.h"

@protocol EditViewWithIconDelegate;

@interface EditViewWithIcon : UIView<EditViewDelegate>

// ==========================================================================
#pragma mark -  外部调用方法
/** 初始化视图，只有调用这个方法之后，才能得到相应的View高度尺寸 */
- (void) initLayoutView;

/** 编辑框获取焦点，弹出对话框 */
- (void) requireFirstResponder;

/** 编辑框失去焦点，收起对话框 */
- (void) resignFirstResponder;

// ==========================================================================
#pragma mark -  外部变量
@property(nonatomic, weak, setter=setDelegate:, getter=getDelegate) id<EditViewWithIconDelegate> m_delegate;

/** 键盘右下角样式，默认 UIReturnKeyDone，暂时只能用于单行编辑框 */
@property(nonatomic, assign, setter=setReturnKeyType:, getter=getReturnKeyType) UIReturnKeyType m_returnKeyType;

@property(nonatomic, assign, setter=setKeyboardType:, getter=getKeyboardType) UIKeyboardType m_keyboardType;

/** 是否设置为自动高度，默认NO */
@property(nonatomic, assign, setter=setIsAutoAdjustHeight:, getter=gettIsAutoAdjustHeight) BOOL m_btIsAutoAdjustHeight;

/** 是否是密码模式：默认NO ，暂时只对单行编辑框模式起作用*/
@property(nonatomic, assign, setter=setIsPasswordMode:, getter=getIsPasswordMode) BOOL m_bIsPasswordMode;

/** 圆角值， 默认值4.0f */
@property(nonatomic, assign, setter=setCornerRadius:, getter=getCornerRadius) float m_cornerRadius;

/** 文本 */
@property(nonatomic, copy, setter=setText:, getter=getText) NSString *m_strText;

/** 字体 */
@property(nonatomic, retain, setter=setTxFont:, getter=getTxFont) UIFont *m_txFont;

/** 字体颜色 */
@property(nonatomic, retain, setter=setTxColor:, getter=getTxColor) UIColor *m_txColor;

/** 出现在左侧的图片，如果不设置则不显示 */
@property(nonatomic, retain, setter=setImgIcon:, getter=getImgIcon) UIImage *m_imgIcon;

/** 替换文字 */
@property(nonatomic, copy, setter=setPlaceHolder:, getter=getPlaceHolder) NSString *m_strPlaceHolder;

/** 是否可以编辑，默认YES */
@property(nonatomic, assign, setter=setIsEditEnable:, getter=getIsEditEnable) BOOL m_bIsEditEnable;

/** 是否显示边框线 */
@property(nonatomic, assign, setter=setIsShowBorderLine:) BOOL m_bIsShowBorderLine;

/** 是否只能输入数字：默认NO，暂时只对单行编辑框样式起作用 */
@property(nonatomic, assign, setter=setIsInputOnlyNum:, getter=getIsInputOnlyNum) BOOL m_bIsInputOnlyNum;

/** 图标和文字间的间隔 */
@property(nonatomic, assign, setter=setSpaceIconWithText:) float m_spaceIconWithText;

/** 是否一开始就显示键盘：默认NO */
@property(nonatomic, assign, setter=setIsShowKeyboard:, getter=getIsShowKeyboard) BOOL m_bIsShowKeyboard;

/** 框线颜色 */
@property(nonatomic, retain, setter=setBorderColor:, getter=getBorderColor) UIColor *m_borderColor;

/** 图标和文字间的间隔 */
@property(nonatomic, assign, setter=setBorderWidth:) float m_borderWidth;

/** 上下左右的间隔的间隔 */
@property(nonatomic, assign, setter=setSpaceInsert:) float m_spaceInsert;

/** 是否显示圆形的图标，默认YES */
@property(nonatomic, assign, setter=setIsShowCircelImg:) BOOL m_bIsShowCircelImg;



@end

// ==============================================================================================
#pragma mark -  委托协议EditViewWithIconDelegate
@protocol EditViewWithIconDelegate <NSObject>
/** 确定输入内容之后回调这个方法 */
- (void) commitInput:(NSString*)v_strInputText _editViewWithIcon:(EditViewWithIcon*)v_sender;

@end
