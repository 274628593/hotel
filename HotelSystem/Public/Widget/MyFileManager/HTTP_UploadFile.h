//
//  HTTP_UploadFile.h
//  WorkFriend
//
//  Created by hancj on 15/12/24.
//  Copyright © 2015年 LHJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTTP_UploadFile : NSObject

/** 上传文件到指定路径 */
+ (NSMutableURLRequest*) getRequestForUploadFile:(NSData*)v_fileData _fileName:(NSString*)v_strName;

@end
