//
//  ImgFileManager.h
//  HotelSystem
//
//  Created by LHJ on 16/3/22.
//  Copyright © 2016年 hancj. All rights reserved.
//

#import <Foundation/Foundation.h>

/** 图片文件管理器 */
@interface ImgFileManager : NSObject

// ==============================================================================================
#pragma mark - 外部调用方法
/** 返回图片管理器全局对象 */
+ (instancetype) sharedImgFileManagerObj;

/** 保存文件数据到本地，成功后返回文件保存路径 */
- (NSString*) saveImgDataToLocal:(NSData*)v_data;

@end
