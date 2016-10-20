//
//  HTTP_UploadFile.m
//  WorkFriend
//
//  Created by hancj on 15/12/24.
//  Copyright © 2015年 LHJ. All rights reserved.
//

#import "HTTP_UploadFile.h"
#import "FileManager.h"

#define Boundry             @"myboundry"

@implementation HTTP_UploadFile

/** 根据文件类型返回上传BodyData里面的ContentType */
+ (NSString*) getContentTypeInBodyData:(NSString*)v_strType
{
    NSString *strRS = @"";
    if(v_strType == nil) { return strRS; }
    
    if([v_strType containsString:FileType_DOC] == YES
       || [v_strType containsString:FileType_DOCX] == YES){
        v_strType = @"application/msword";
    
    } else if([v_strType containsString:FileType_JPG] == YES){
        v_strType = @"image/jpg";
    
    } else if([v_strType containsString:FileType_JPEG] == YES){
        v_strType = @"image/jpeg";
    
    } else if([v_strType containsString:FileType_PNG] == YES){
        v_strType = @"image/png";
        
    } else if([v_strType containsString:FileType_PDF] == YES){
        v_strType = @"application/pdf";
        
    } else if([v_strType containsString:FileType_XLS] == YES){
        v_strType = @"application/x-xls";
        
    } else if([v_strType containsString:FileType_TXT] == YES){
        v_strType = @"text/plain";
        
    } else if([v_strType containsString:FileType_TIFF] == YES){
        v_strType = @"image/tiff";
        
    } else if([v_strType containsString:FileType_RTF] == YES){
        v_strType = @"application/msword";
   
    } else if([v_strType containsString:FileType_PPT] == YES){
        v_strType = @"application/x-ppt";
        
    } else {
        v_strType = @"text/html";
    }
    return v_strType;
}

/** 获取上传文件的数据包 */
+ (NSData*) getBodyDataWithUploadFile:(NSData*)v_fileData
                            _fileName:(NSString*)v_strFileName
{
    NSString *strType = [v_strFileName pathExtension];
    NSString *strContentType = [HTTP_UploadFile getContentTypeInBodyData:strType];
    
    NSMutableString *muStr = [NSMutableString new];
    [muStr appendFormat:@"--%@", Boundry];
    [muStr appendString:@"\r\n"]; // 换行符
    [muStr appendFormat:@"Content-Disposition: form-data; name=\"formname\"; filename=\"%@\"", v_strFileName];
    [muStr appendString:@"\r\n"];
    [muStr appendFormat:@"Content-Type:%@", strContentType];
    [muStr appendString:@"\r\n\r\n"];
    
    NSMutableData *dataRS = [[NSMutableData alloc]init];
    [dataRS appendData:[muStr dataUsingEncoding:NSUTF8StringEncoding]];
    
    [dataRS appendData:v_fileData]; // 文件Data
    
    [muStr setString:@"\r\n"]; // 清空字符串
    [muStr appendFormat:@"--%@--", Boundry];
    
    [dataRS appendData:[muStr dataUsingEncoding:NSUTF8StringEncoding]];
    
    return dataRS;
}
/** 上传文件到指定路径 */
+ (NSMutableURLRequest*) getRequestForUploadFile:(NSData*)v_fileData _fileName:(NSString*)v_strName
{
    NSData *dataBody = [HTTP_UploadFile getBodyDataWithUploadFile:v_fileData _fileName:v_strName];
    
    NSMutableURLRequest *request = [NSMutableURLRequest new];
    NSString *strLength = [NSString stringWithFormat:@"%li", (unsigned long)dataBody.length];
    [request setValue:strLength forHTTPHeaderField:@"Content-Length"];
    
    NSString *strContentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", Boundry];
    [request setValue:strContentType forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:dataBody];
    [request setHTTPMethod:@"POST"];
    
    return request;
}

@end
