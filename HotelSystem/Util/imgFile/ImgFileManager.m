//
//  ImgFileManager.m
//  HotelSystem
//
//  Created by LHJ on 16/3/22.
//  Copyright © 2016年 hancj. All rights reserved.
//

#import "ImgFileManager.h"
#import "CPublic.h"

@implementation ImgFileManager
{
    NSString *m_strDirectPath;
    NSString *m_strRelativeFilePath; // 相对路径
}
// ==============================================================================================
#pragma mark - 外部调用方法
/** 返回图片管理器全局对象 */
+ (instancetype) sharedImgFileManagerObj
{
    static ImgFileManager *imgFileManagerObj = nil;
    if(imgFileManagerObj == nil){
        imgFileManagerObj = [ImgFileManager new];
    }
    return imgFileManagerObj;
}
- (instancetype) init
{
    self = [super init];
    if(self != nil){
        m_strDirectPath = [CPublic getRootDirectorFilePath];
//        m_strDirectPath = [m_strDirectPath stringByAppendingString:@"/fileImg"];
        m_strRelativeFilePath = @"fileImg";
        [CPublic createLocalFilePathIfNoExit:[NSString stringWithFormat:@"%@/%@", m_strDirectPath, m_strRelativeFilePath]];
    }
    return self;
}

/** 保存文件数据到本地，成功后返回文件保存路径 */
- (NSString*) saveImgDataToLocal:(NSData*)v_data
{
    NSString *strRS = nil;
    if(v_data == nil) { return strRS; }
    
    BOOL bIsWhile = YES;
    do{
        NSString *strFileName = [NSString stringWithFormat:@"%@/%@.png", m_strRelativeFilePath, [CPublic getUniqueName]];
        NSString *strPath = [NSString stringWithFormat:@"%@/%@", m_strDirectPath, strFileName];
        NSFileManager *fileManger = [NSFileManager defaultManager];
        if([fileManger fileExistsAtPath:strPath] != YES){
            BOOL bSuc = [v_data writeToFile:strPath atomically:YES];
            if(bSuc == YES){
                strRS = strFileName;
                bIsWhile = NO;
            }
        } else {
            bIsWhile = YES;
        }
    }while(bIsWhile);
    
    return strRS;
}

@end
