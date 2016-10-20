//
//  FileManagerViewController.h
//  MachineModule
//
//  Created by LHJ on 15/12/22.
//  Copyright © 2015年 LHJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "View_HorList.h"
#import "FileManager.h"
#import "FileItemView.h"

@protocol FileManagerViewControllerDelegate;

/** 文件管理器ViewController */
@interface FileManagerViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, View_HorListDelegate>

// ======================================================================================
#pragma mark 外部变量
/** 委托 */
@property(nonatomic, weak, setter=setDelegate:, getter=getDelegate) id<FileManagerViewControllerDelegate> m_delegate;

// ======================================================================================
#pragma mark 外部使用方法

@end

// ======================================================================================
#pragma mark 委托协议
@protocol FileManagerViewControllerDelegate<NSObject>

@required
/** 返回选择的结果，数组存储FileItem对象 */
- (void) getAllFilesOfSelected:(NSArray<FileItem*>*)v_ary;

@end

