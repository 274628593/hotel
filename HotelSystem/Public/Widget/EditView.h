//
//  EditView.h
//  MyPro
//
//  Created by hancj on 15/11/9.
//  Copyright © 2015年 hancj. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : int{
    EditViewType_SinggleRow, /* 单行输入框，键盘确定键关闭键盘（默认） */
    EditViewType_ManyRows_AutoLayout, /* 多行输入框，随着输入文字自动调整高度 */
    EditViewType_ManyRows_NoAutoLayout, /* 多行输入框，固定高度 */

}EditViewType;

@protocol EditViewDelegate;

/** 文本编辑框 */
@interface EditView : UIView

// ==============================================================================================
#pragma mark -  外部方法
/** 外部调用：在初始化说所有必要数据之后，初始化布局View，当m_bIsLayoutWhenSuperCall＝YES，调用这个函数无效 */
- (void) initLayoutViewAfterInitData;

/** 编辑框获取焦点，弹出对话框 */
- (void) requireFirstResponder;

/** 编辑框失去焦点，收起对话框 */
- (void) resignFirstResponder;

// ==============================================================================================
#pragma mark -  外部变量
/** 键盘右下角样式，默认 UIReturnKeyDone，暂时只能用于单行编辑框 */
@property(nonatomic, assign, setter=setReturnKeyType:, getter=getReturnKeyType) UIReturnKeyType m_returnKeyType;

@property(nonatomic, assign, setter=setKeyboardType:, getter=getKeyboardType) UIKeyboardType m_keyboardType;

/** 编辑框样式 */
@property(nonatomic, assign, setter=setEditViewType:, getter=getEditViewType) EditViewType m_editViewType;

/** 文字对齐方向，默认NSTextAlignmentLeft，暂时只能用于单行编辑框 */
@property(nonatomic, assign, setter=setTextAlignment:, getter=getTextAlignment) NSTextAlignment m_textAlignment;

/** 是否可以编辑，默认YES */
@property(nonatomic, assign, setter=setIsEditEnable:, getter=getIsEditEnable) BOOL m_bIsEditEnable;

/** 是否是等待系统自动调用布局函数：默认YES */
@property(nonatomic, assign, setter=setIsLayoutWhenSuperCall:, getter=getIsLayoutWhenSuperCall) BOOL m_bIsLayoutWhenSuperCall;

/** 是否一开始就显示键盘：默认NO */
@property(nonatomic, assign, setter=setIsShowKeyboard:, getter=getIsShowKeyboard) BOOL m_bIsShowKeyboard;

/** 是否显示清空按钮：默认YES */
@property(nonatomic, assign, setter=setIsShowClearBtn:, getter=getIsShowClearBtn) BOOL m_bIsShowClearBtn;

/** 是否是密码模式：默认NO ，暂时只对单行编辑框模式起作用*/
@property(nonatomic, assign, setter=setIsPasswordMode:, getter=getIsPasswordMode) BOOL m_bIsPasswordMode;

/** 是否只能输入数字：默认NO，暂时只对单行编辑框样式起作用 */
@property(nonatomic, assign, setter=setIsInputOnlyNum:, getter=getIsInputOnlyNum) BOOL m_bIsInputOnlyNum;

/** 字体 */
@property(nonatomic, retain , setter=setTextFont:, getter=getTextFont) UIFont *m_textFont;

/** 字体颜色 */
@property(nonatomic, retain, setter=setTextColor:, getter=getTextColor) UIColor *m_textColor;

/** 替换文字颜色 */
@property(nonatomic, retain, setter=setPlaceHolderColor:, getter=getPlaceHolderColor) UIColor *m_placeHolderColor;

/** 替换文字 */
@property(nonatomic, copy, setter=setPlaceHolder:, getter=getPlaceHolder) NSString *m_strPlaceHolder;

/** 编辑框文字 */
@property(nonatomic, copy, setter=setTextContent:, getter=getTextContent) NSString *m_strTextContent;

/** 委托 */
@property(nonatomic, weak, setter=setDelegate:, getter=getDelegate) id<EditViewDelegate> m_delegate;

@end

// ==============================================================================================
#pragma mark -  委托协议
@protocol EditViewDelegate<NSObject>

@optional
/** 当开启自动高度之后，当编辑框高度变化时，则调用这个函数（只适用于） */
- (void) changeViewFrame:(id)v_sender;

/** 跳转到下一个编辑框 */
- (void) gotoNextEditView:(id)v_sender _returnKeyType:(UIReturnKeyType)v_returnKeyType;

/* 关闭键盘后的触发函数 */
- (void) closeKeyboardEvent:(id)v_sender;

/** 确定输入内容之后回调这个方法 */
- (void) commitInput:(NSString*)v_strInputText _sender:(id)v_sender;

@end

