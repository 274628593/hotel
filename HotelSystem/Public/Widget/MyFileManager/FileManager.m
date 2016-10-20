//
//  FileManager.m
//  MachineModule
//
//  Created by LHJ on 15/12/22.
//  Copyright © 2015年 LHJ. All rights reserved.
//

#import "FileManager.h"
#import "CPublic.h"

@implementation FileManager

// ==============================================================================================
#pragma mark 外部调用方法
/** 获取本地所有文件 */
+ (NSMutableDictionary<NSString*, NSMutableArray<FileItem*>*>*) getAllFilesOfLocal
{
    NSString *strRootPath = [FileManager getRootDirectorFilePath];
    return [FileManager getFilesWithDirect:strRootPath];
}

/** 获取文件夹下面的所有文件 */
+ (NSMutableDictionary<NSString*, NSMutableArray<FileItem*>*>*) getFilesWithDirect:(NSString*)v_strDirPath
{
    NSMutableDictionary *muDicRS = [NSMutableDictionary new];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
    NSArray *aryFiles = [fileManager contentsOfDirectoryAtPath:v_strDirPath error:&error];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    
    for(NSString *strFileName in aryFiles){
        BOOL bIsDir = NO;
        NSString *strFilePath = [NSString stringWithFormat:@"%@/%@", v_strDirPath, strFileName];
        [fileManager fileExistsAtPath:strFilePath isDirectory:&bIsDir];
        if(bIsDir == YES){ // 文件夹
            [muDicRS setValuesForKeysWithDictionary:[self getFilesWithDirect:strFilePath]];
            
        } else {
            FileItem *fileItem = [FileItem new];
            [fileItem setFilePath:strFilePath];
            NSDictionary *dicFileAttri = [fileManager attributesOfItemAtPath:strFilePath error:nil];
            
            // 文件创建时间
            NSDate *date = [dicFileAttri objectForKey:NSFileCreationDate];
            [fileItem setFileCreateTime:[dateFormatter stringFromDate:date]];
            
            // 文件修改时间
            date = [dicFileAttri objectForKey:NSFileModificationDate];
            [fileItem setFileEditTime:[dateFormatter stringFromDate:date]];
            
            // 文件大小(M)
            NSNumber *numSize = (NSNumber*)[dicFileAttri objectForKey:NSFileSize];
            float size = [numSize floatValue] / 1024.f / 1024.f;
            [fileItem setFileSize:[NSString stringWithFormat:@"文件大小：%.2f MB", size]];
            
            // 文件后缀（全部小写）
            [fileItem setFileType:[[strFilePath pathExtension] lowercaseString]];
            
            // 文件名称
            [fileItem setFileName:strFileName];
            
            // 文件图标
            [FileManager getIconNameWithFileItem:fileItem];
            
            // ====== 以文件类型为Key添加到对应的数组中 ======
            NSMutableArray *muAry = [muDicRS objectForKey:[fileItem getFileType]];
            if(muAry == nil){
                muAry = [NSMutableArray new];
                [muDicRS setObject:muAry forKey:[fileItem getFileType]];
            }
            [muAry addObject:fileItem];
        }
    }
    return muDicRS;
}
/** 根据文件后缀获取对应的图片名 */
+ (void) getIconNameWithFileItem:(FileItem*)v_fileItem
{
    NSString *strFileType = [v_fileItem getFileType];
    if([strFileType containsString:FileType_DOC] == YES){
        [v_fileItem setImgIcon:GetImg(@"doc")];
        
    } else if([strFileType containsString:FileType_PDF] == YES){
        [v_fileItem setImgIcon:GetImg(@"pdf")];
        
    } else if([strFileType containsString:FileType_XLS] == YES){
        [v_fileItem setImgIcon:GetImg(@"xls")];
        
    } else if([strFileType containsString:FileType_PPT] == YES){
        [v_fileItem setImgIcon:GetImg(@"ppt")];
        
    } else if([strFileType containsString:FileType_PNG] == YES
              || [strFileType containsString:FileType_JPG] == YES
              || [strFileType containsString:FileType_TIFF] == YES
              || [strFileType containsString:FileType_ICO] == YES
              || [strFileType containsString:FileType_BMP] == YES) { // 图片文件，则直接显示缩略图
        NSData *data = [NSData dataWithContentsOfFile:[v_fileItem getFilePath]];
        UIImage *img = [UIImage imageWithData:data scale:0.001f];
        [v_fileItem setImgIcon:img];
    
    } else if([strFileType containsString:FileType_HTML] == YES){
        [v_fileItem setImgIcon:GetImg(@"html")];
        
    } else if([strFileType containsString:FileType_WPS] == YES){
        [v_fileItem setImgIcon:GetImg(@"wps")];
        
    } else if([strFileType containsString:FileType_TXT] == YES){
        [v_fileItem setImgIcon:GetImg(@"txt")];
        
    } else if([strFileType containsString:FileType_XML] == YES){
        [v_fileItem setImgIcon:GetImg(@"xml")];
        
    } else if([strFileType containsString:FileType_RAR] == YES
              || [strFileType containsString:FileType_ZIP] == YES){
        [v_fileItem setImgIcon:GetImg(@"rar")];
        
    } else {
        [v_fileItem setImgIcon:GetImg(@"file")];
    }
    
    
}
/** 获取包括文档在内的文件后缀 */
+ (NSArray*) getKeysWithFile
{
    return FileList_File;
}
/** 获取包括图片的文件后缀 */
+ (NSArray*) getKeysWithImg
{
    return FileList_Img;
}
/** 获取所有的文件后缀 */
+ (NSArray*) getKeysWithAllType
{
//    NSMutableArray *muAryRS = [NSMutableArray new];
//    [muAryRS addObjectsFromArray:FileList_File];
//    [muAryRS addObjectsFromArray:FileList_Img];
    return @[];
}
/** 删除文件 */
+ (BOOL) deleteFileWithPath:(NSString*)v_strPath
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    return [fileManager removeItemAtPath:v_strPath error:nil];
}
/** 获取文件内容 */
- (NSData*) getFileDataWithPath:(NSString*)v_strPath
{
    return [NSData dataWithContentsOfFile:v_strPath];
}
/** 获取APP文件夹根目录 */
+ (NSString*) getRootDirectorFilePath
{
    NSString *strRS = @"";
    NSArray *aryPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    if(aryPaths!=nil
       && aryPaths.count > 0){
        strRS = [aryPaths objectAtIndex:0];
    }
    return strRS;
}

@end
