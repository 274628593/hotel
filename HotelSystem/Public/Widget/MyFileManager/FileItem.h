//
//  FileItem.h
//  MachineModule
//
//  Created by LHJ on 15/12/21.
//  Copyright © 2015年 LHJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/** 文件对象 */
@interface FileItem : NSObject

// ==============================================================================================
#pragma mark 外部变量
/** 文件路径 */
@property(nonatomic, copy, setter=setFilePath:, getter=getFilePath) NSString *m_strFilePath;

/** 文件名称 */
@property(nonatomic, copy, setter=setFileName:, getter=getFileName) NSString *m_strFileName;

/** 文件类型（文件后缀名） */
@property(nonatomic, copy, setter=setFileType:, getter=getFileType) NSString *m_strFileType;

/** 文件大小（M为单位） */
@property(nonatomic, copy, setter=setFileSize:, getter=getFileSize) NSString *m_strFileSize;

/** 文件图标 */
@property(nonatomic, copy, setter=setImgIcon:, getter=getImgIcon) UIImage *m_imgIcon;

/** 文件创建时间 */
@property(nonatomic, copy, setter=setFileCreateTime:, getter=getFileCreateTime) NSString *m_strFileCreateTime;

/** 文件修改时间 */
@property(nonatomic, copy, setter=setFileEditTime:, getter=getFileEditTime) NSString *m_strFileEditTime;

@end
