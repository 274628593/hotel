//
//  FileManager.h
//  MachineModule
//
//  Created by LHJ on 15/12/22.
//  Copyright © 2015年 LHJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FileItem.h"

#define FileType_PNG        @"png"
#define FileType_JPG        @"jpg"
#define FileType_JPEG       @"jpeg"
#define FileType_DOC        @"doc"
#define FileType_DOCX       @"docx"
#define FileType_PDF        @"pdf"
#define FileType_XLS        @"xls"
#define FileType_TXT        @"txt"
#define FileType_TIFF       @"tiff"
#define FileType_RTF        @"rtf"
#define FileType_PPT        @"ppt"
#define FileType_ICO        @"ico"
#define FileType_HTML       @"html"
#define FileType_TMP        @"tmp"
#define FileType_WPS        @"wps"
#define FileType_RAR        @"rar"
#define FileType_ZIP        @"zip"
#define FileType_BMP        @"bmp"
#define FileType_XML        @"xml"

#define FileList_File   @[FileType_XML, FileType_DOC, FileType_WPS, FileType_HTML, FileType_TMP, FileType_XLS, FileType_PDF, FileType_DOCX, FileType_TXT, FileType_RTF, FileType_PPT]
#define FileList_Img    @[ FileType_JPG, FileType_PNG, FileType_JPEG, FileType_TIFF, FileType_ICO, FileType_BMP]

/** 文件管理器 */
@interface FileManager : NSObject

/** 删除文件 */
+ (BOOL) deleteFileWithPath:(NSString*)v_strPath;

/** 获取文件内容 */
- (NSData*) getFileDataWithPath:(NSString*)v_strPath;

/** 获取包括文档在内的文件后缀 */
+ (NSArray*) getKeysWithFile;

/** 获取包括图片的文件后缀 */
+ (NSArray*) getKeysWithImg;

/** 获取所有的文件后缀，注意：这个方法返回没有内容的数组，可以表示成全部文件 */
+ (NSArray*) getKeysWithAllType;

/** 根据文件后缀获取对应的图片名 */
+ (void) getIconNameWithFileItem:(FileItem*)v_fileItem;

/** 获取文件夹下面的所有文件 */
+ (NSMutableDictionary<NSString*, NSMutableArray<FileItem*>*>*) getFilesWithDirect:(NSString*)v_strDirPath;

/** 获取本地所有文件 */
+ (NSMutableDictionary<NSString*, NSMutableArray<FileItem*>*>*) getAllFilesOfLocal;

/** 获取APP文件夹根目录 */
+ (NSString*) getRootDirectorFilePath;

@end
