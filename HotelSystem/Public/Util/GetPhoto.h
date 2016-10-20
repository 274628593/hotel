//
//  GetPhoto.h
//  MachineModule
//
//  Created by LHJ on 15/12/30.
//  Copyright © 2015年 LHJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h> 

@protocol GetPhotoDelegate;

@interface GetPhoto : NSObject<UIAlertViewDelegate, UIImagePickerControllerDelegate>

// ==============================================================================================
#pragma mark -  外部调用方法
/** 打开照片选择器 */
+ (void) openViewWithSelectPhoto:(id)v_delegate;

// ==============================================================================================
#pragma mark -  外部调用变量
/** 委托 */
@property(nonatomic, weak, setter=setDelegate:, getter=getDelegate) id<GetPhotoDelegate> m_delegate;

@end


// ==============================================================================================
#pragma mark -  委托协议
@protocol GetPhotoDelegate<NSObject>

/** 获取选择的照片数据 */
- (void) getImgData:(NSData*)v_dataImg _sender:(id)v_sender;

@end
