//
//  FileItemView.h
//  MachineModule
//
//  Created by LHJ on 15/12/21.
//  Copyright © 2015年 LHJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FileItem.h"

/** 文件列表对象CellView */
@interface FileItemView : UIView

// ==============================================================================================
#pragma mark 外部调用方法
/** 初始化视图 */
- (void) initLayoutView;

// ==============================================================================================
#pragma mark 外部变量
/** 名字字体 */
@property(nonatomic, retain , setter=setNameFont:, getter=getNameFont) UIFont *m_nameFont;

/** 名字字体颜色 */
@property(nonatomic, retain, setter=setNameTxColor:, getter=getNameTxColor) UIColor *m_nameTxColor;

/** 描述字体 */
@property(nonatomic, retain , setter=setDescriptionFont:, getter=getDescriptionFont) UIFont *m_descriptionFont;

/** 描述字体颜色 */
@property(nonatomic, retain, setter=setDescriptionTxColor:, getter=getDescriptionTxColor) UIColor *m_descriptionTxColor;

/** 描述 */
@property(nonatomic, copy, setter=setDescription:, getter=getDescription) NSString *m_strDescription;

/** 名字 */
@property(nonatomic, copy , setter=setName:, getter=getName) NSString *m_strName;

/** 图片 */
@property(nonatomic, retain , setter=setImg:, getter=getImg) UIImage *m_img;

/** 是否选中 */
@property(nonatomic, assign, setter=setIsSelected:, getter=getIsSelected) BOOL m_bIsSelected;

/** 对应显示的文件对象 */
@property(nonatomic, weak, setter=setFileItem:, getter=getFileItem) FileItem *m_fileItem;

@end
