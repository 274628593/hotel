//
//  Network.m
//  MyPro
//
//  Created by LHJ on 15/12/5.
//  Copyright © 2015年 hancj. All rights reserved.
//

#import "Network.h"
#import "CPublic.h"

#define Boundary    @"Boundary" // 上传文件头的分割

@implementation Network
{
    float                           m_aniDuration;
    DialogOfLoadingViewController   *m_dialogViewController;
}
@synthesize m_strBaseURL;
@synthesize m_dicHttpRequestParams;
@synthesize m_timeOut;
@synthesize m_strUploadFileName;
@synthesize m_bIsShowDialog;

// ==========================================================================
#pragma mark 继承类方法
- (instancetype)init
{
    [self initData];
    return [super init];
}

// ==========================================================================
#pragma mark 内部使用方法
- (void) initData
{
    m_dialogViewController = nil;
    m_aniDuration = 0.3f;
    m_bIsShowDialog = NO;
//    m_strBaseURL = BaseAddress;
    m_dicHttpRequestParams = @{  @"Accept" : @"application/json"};

    m_timeOut = 10.0f;
}
/** 获取上传文件的参数 */
- (NSData*) getStrBodyWithUploadFile:(NSData*)v_data
{
    if(m_strUploadFileName == nil
       || [m_strUploadFileName isEqualToString:@""] == YES){
        m_strUploadFileName = [NSString stringWithFormat:@"%@.jpg", [CPublic getUniqueName]];
    }
    
    NSMutableData *dataRS = [NSMutableData new];
    NSMutableString *muStrBody = [NSMutableString new];
    [muStrBody appendFormat:@"--%@", Boundary];
    [muStrBody appendString:@"\r\n"];
    [muStrBody appendFormat:@"Content-Disposition:form-data; name=\"formname\"; filename=\"%@\"", m_strUploadFileName];
    [muStrBody appendString:@"\r\n"];
    [muStrBody appendFormat:@"Content-Type:image/jpg"];
    [muStrBody appendString:@"\r\n\r\n"];
    
    [dataRS appendData:[muStrBody dataUsingEncoding:NSUTF8StringEncoding]];
    [dataRS appendData:v_data];
    
    [muStrBody setString:@"\r\n"];
    [muStrBody appendFormat:@"--%@--", Boundary];
    
    [dataRS appendData:[muStrBody dataUsingEncoding:NSUTF8StringEncoding]];
    
    return dataRS;
}
/** 移除加载框 */
- (void) removeDialogLoading
{
    if(m_bIsShowDialog == YES
       && m_dialogViewController != nil){
        [m_dialogViewController removeFromSuperview];
    }
}
+ (NSString *)escape:(NSString *)v_strText
{
    return (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(
                                                                                 NULL,
                                                                                 (__bridge CFStringRef)v_strText,
                                                                                 NULL,
                                                                                 CFSTR("!*’();:@&=+$,/?%#[]"), CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));;
}

// ==========================================================================
#pragma mark 外部调用方法
/** 以Post方式请求Json数据 */
- (void) getJsonDataWithNetwork_withPost_params:(NSDictionary*)v_dicParams
                               _successCallBack:(void(^)(NSDictionary*v_dic))v_sucCallBack
                                 _faildCallBack:(void(^)(NSError*v_dic))v_failedCallBack
{
    [self getJsonDataWithNetwork_withPost:m_strBaseURL _params:v_dicParams _successCallBack:v_sucCallBack _faildCallBack:v_failedCallBack];
}
/** 以Post方式请求Json数据 */
- (void) getJsonDataWithNetwork_withPost:(NSString*)v_strURL
                                 _params:(NSDictionary*)v_dicParams
                        _successCallBack:(void(^)(NSDictionary*v_dic))v_sucCallBack
                          _faildCallBack:(void(^)(NSError*))v_failedCallBack
{
    if([v_strURL rangeOfString:@"http:"].length <= 0){
        v_strURL = [NSString stringWithFormat:@"%@/%@", m_strBaseURL, v_strURL];
    }

    NSMutableString *muStrParams = [NSMutableString new];
    NSArray *aryKeys = [v_dicParams allKeys];
    for(int i=0; i<aryKeys.count; i+=1)
    {
        NSString *strKey = [aryKeys objectAtIndex:i];
        NSString *strValue = [v_dicParams objectForKey:strKey];
        [muStrParams appendFormat:@"%@=%@", strKey, strValue];
        if((i+1) < aryKeys.count) {
            [muStrParams appendString:@"&"];
        }
    }
    NSData *dataParams = [muStrParams dataUsingEncoding:NSUTF8StringEncoding];
    
    // ======= 发送请求 ======
    NSURL *url = [NSURL URLWithString:[v_strURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSMutableURLRequest *muRequest = [[NSMutableURLRequest alloc] initWithURL:url];
    [muRequest setHTTPMethod:@"POST"];
    [muRequest setHTTPBody:dataParams];
//    [muRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"]; //设置发送数据的格式
//    [muRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"]; //设置预期接收数据的格式
    [muRequest setTimeoutInterval:m_timeOut];
    for(NSString *strKey in [m_dicHttpRequestParams allKeys]){
        [muRequest setValue:[m_dicHttpRequestParams objectForKey:strKey] forHTTPHeaderField:strKey];
    }
    
    [NSURLConnection sendAsynchronousRequest:muRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable v_response, NSData * _Nullable v_data, NSError * _Nullable v_connectionError)
    {
//        [self performSelector:@selector(removeDialogLoading) withObject:nil afterDelay:2.0f];
        [self removeDialogLoading];
        if(v_response == nil){ // 请求响应失败
            v_failedCallBack(v_connectionError);
            [CPublic ShowToast_NetError];
            return; 
        }
        
        NSHTTPURLResponse *response = (NSHTTPURLResponse*)v_response;
        if(response.statusCode == 200)
        {
            // 请求成功
            NSLog(@"%@", [[NSString alloc]initWithData:v_data encoding:NSUTF8StringEncoding]);
            NSDictionary *dicJson = [NSJSONSerialization JSONObjectWithData:v_data options:NSJSONReadingAllowFragments error:nil];
            v_sucCallBack(dicJson);

        } else { // 请求失败
            v_failedCallBack(v_connectionError);
        }
    }];
    if(m_bIsShowDialog == YES){
        DialogOfLoadingViewController *viewContorller= [DialogOfLoadingViewController new];
        [[UIApplication sharedApplication].keyWindow addSubview:viewContorller];
        m_dialogViewController = viewContorller;
    }
}
/** 以Get方式请求Json数据 */
- (void) getJsonDataWithNetwork_withGet:(NSString*)v_strURL
                                _params:(NSDictionary*)v_dicParams
                       _successCallBack:(void(^)(NSDictionary*v_dic))v_sucCallBack
                         _faildCallBack:(void(^)(NSError*))v_failedCallBack
{
    NSMutableString *muStrURL = [NSMutableString new];
    if([v_strURL rangeOfString:@"http:"].length <= 0){
        muStrURL = [[NSMutableString alloc] initWithString:m_strBaseURL];
        [muStrURL appendFormat:@"/%@", v_strURL];
    
    } else {
        [muStrURL setString:v_strURL];
    }
    
    // ====== 设置Get参数 ======
    [muStrURL appendString:@"?"];
    NSArray *aryKeys = [v_dicParams allKeys];
    for(int i=0; i<aryKeys.count; i+=1){
        NSString *strKey = [aryKeys objectAtIndex:i];
        NSString *strValue = [v_dicParams objectForKey:strKey];
        [muStrURL appendFormat:@"%@=%@", strKey, strValue];
        if((i+1) < aryKeys.count){
            [muStrURL appendString:@"&"];
        }
    }
    [self getJsonDataWithNetwork_withGet:muStrURL
                        _successCallBack:v_sucCallBack
                          _faildCallBack:v_failedCallBack];
}
/** 以Get方式请求Json数据，v_strURL包含所有参数 */
- (void) getJsonDataWithNetwork_withGet:(NSString*)v_strURL
                       _successCallBack:(void(^)(NSDictionary*v_dic))v_sucCallBack
                         _faildCallBack:(void(^)(NSError*))v_failedCallBack;
{
    // ======= 发送请求 ======
    NSURL *url = [NSURL URLWithString:[v_strURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSMutableURLRequest *muRequest = [[NSMutableURLRequest alloc] initWithURL:url];
    [muRequest setHTTPMethod:@"GET"];
    [muRequest setTimeoutInterval:m_timeOut];
    
    [NSURLConnection sendAsynchronousRequest:muRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable v_response, NSData * _Nullable v_data, NSError * _Nullable v_connectionError)
     {
         [self removeDialogLoading];
         if(v_response == nil){ // 请求响应失败
             v_failedCallBack(v_connectionError);
             [CPublic ShowToast_NetError];
             return;
         }
         
         NSHTTPURLResponse *response = (NSHTTPURLResponse*)v_response;
         if(response.statusCode == 200){
             NSDictionary *dicJson = [NSJSONSerialization JSONObjectWithData:v_data options:NSJSONReadingAllowFragments error:nil];
             v_sucCallBack(dicJson);
             
         } else {
             v_failedCallBack(v_connectionError);
         }
    }];
    if(m_bIsShowDialog == YES){
        DialogOfLoadingViewController *viewContorller= [DialogOfLoadingViewController new];
        [[UIApplication sharedApplication].keyWindow addSubview:viewContorller];
        m_dialogViewController = viewContorller;
        
    }
}
/** 以Get方式请求Json数据 */
- (void) getJsonDataWithNetwork_withGet_params:(NSDictionary*)v_dicParams
                              _successCallBack:(void(^)(NSDictionary*v_dic))v_sucCallBack
                                _faildCallBack:(void(^)(NSError*))v_failedCallBack
{
    [self getJsonDataWithNetwork_withGet:m_strBaseURL _params:v_dicParams _successCallBack:v_sucCallBack _faildCallBack:v_failedCallBack];
}

/** 以Get方式请求Json数据，v_strURL包含所有参数 */
- (void) getJsonDataWithNetwork_withGet_successCallBack:(void(^)(NSDictionary*v_dic))v_sucCallBack
                                         _faildCallBack:(void(^)(NSError*))v_failedCallBack
{
    [self getJsonDataWithNetwork_withGet:m_strBaseURL _successCallBack:v_sucCallBack _faildCallBack:v_failedCallBack];
}

/** 上传文件 */
- (void) uploadFileToNetworkWithFileData:(NSData*)v_data
                        _successCallBack:(void(^)(NSString *v_strRS))v_successCallBack
                         _failedCallBack:(void(^)(NSError *v_error))v_failedCallBack
{
    [self uploadFileToNetwork:m_strBaseURL
                    _fileData:v_data
             _successCallBack:v_successCallBack
              _failedCallBack:v_failedCallBack];
}
/** 上传文件 */
- (void) uploadFileToNetwork:(NSString*)v_strURL
                   _fileData:(NSData*)v_data
            _successCallBack:(void(^)(NSString *v_strRS))v_successCallBack
             _failedCallBack:(void(^)(NSError *v_error))v_failedCallBack
{
    if([v_strURL rangeOfString:@"http:"].length <= 0){
        v_strURL = [NSString stringWithFormat:@"%@/%@", m_strBaseURL, v_strURL];
    }
    v_data = [self getStrBodyWithUploadFile:v_data];
    
    // ====== 发送请求 ======
    NSURL *url = [NSURL URLWithString:[v_strURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSMutableURLRequest *muRequest = [[NSMutableURLRequest alloc] initWithURL:url];
    [muRequest setHTTPMethod:@"POST"];
    [muRequest setHTTPBody:v_data];
    [muRequest setValue:[NSString stringWithFormat:@"%li", (unsigned long)v_data.length] forHTTPHeaderField:@"Content-Length"];
    [muRequest setValue:[NSString stringWithFormat:@"multipart/form-data;boundary=%@", Boundary] forHTTPHeaderField:@"Content-Type"];
    
    [NSURLConnection sendAsynchronousRequest:muRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable v_response, NSData * _Nullable v_data, NSError * _Nullable v_connectionError)
     {
         [self removeDialogLoading];
         if(v_response == nil){ // 请求响应失败
             v_failedCallBack(v_connectionError);
             [CPublic ShowToast_NetError];
             return;
         }
         
         NSHTTPURLResponse *response = (NSHTTPURLResponse*)v_response;
         if(response.statusCode == 200){
             NSString *strRS = [[NSString alloc] initWithData:v_data encoding:NSUTF8StringEncoding];
             strRS = [strRS stringByReplacingOccurrencesOfString:@"\n" withString:@""];
             v_successCallBack(strRS);
             
         } else {
             v_failedCallBack(v_connectionError);
         }
     }];
    if(m_bIsShowDialog == YES){
        DialogOfLoadingViewController *viewContorller= [DialogOfLoadingViewController new];
        [[UIApplication sharedApplication].keyWindow addSubview:viewContorller];
        m_dialogViewController = viewContorller;
        
    }
}
/** 以Post方式请求Json数据：同步 */
- (void) getJsonDataWithNetworkSync_withPost_params:(NSDictionary*)v_dicParams
                               _successCallBack:(void(^)(NSDictionary*v_dic))v_sucCallBack
                                 _faildCallBack:(void(^)(NSError*v_dic))v_failedCallBack
{
[self getJsonDataWithNetworkSync_withPost:m_strBaseURL _params:v_dicParams _successCallBack:v_sucCallBack _faildCallBack:v_failedCallBack];
}
/** 以Post方式请求Json数据：同步 */
- (void) getJsonDataWithNetworkSync_withPost:(NSString*)v_strURL
                                 _params:(NSDictionary*)v_dicParams
                        _successCallBack:(void(^)(NSDictionary*v_dic))v_sucCallBack
                          _faildCallBack:(void(^)(NSError*))v_failedCallBack
{
    if([v_strURL rangeOfString:@"http:"].length <= 0){
        v_strURL = [NSString stringWithFormat:@"%@/%@", m_strBaseURL, v_strURL];
    }
    
    NSMutableString *muStrParams = [NSMutableString new];
    NSArray *aryKeys = [v_dicParams allKeys];
    for(int i=0; i<aryKeys.count; i+=1)
    {
        NSString *strKey = [aryKeys objectAtIndex:i];
        NSString *strValue = [v_dicParams objectForKey:strKey];
        [muStrParams appendFormat:@"%@=%@", strKey, strValue];
        if((i+1) < aryKeys.count) {
            [muStrParams appendString:@"&"];
        }
    }
    NSData *dataParams = [muStrParams dataUsingEncoding:NSUTF8StringEncoding];
    
    // ======= 发送请求 ======
    NSURL *url = [NSURL URLWithString:[v_strURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSMutableURLRequest *muRequest = [[NSMutableURLRequest alloc] initWithURL:url];
    [muRequest setHTTPMethod:@"POST"];
    [muRequest setHTTPBody:dataParams];
    //    [muRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"]; //设置发送数据的格式
    //    [muRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"]; //设置预期接收数据的格式
    [muRequest setTimeoutInterval:m_timeOut];
    for(NSString *strKey in [m_dicHttpRequestParams allKeys]){
        [muRequest setValue:[m_dicHttpRequestParams objectForKey:strKey] forHTTPHeaderField:strKey];
    }
    if(m_bIsShowDialog == YES){
        DialogOfLoadingViewController *viewContorller= [DialogOfLoadingViewController new];
        [[UIApplication sharedApplication].keyWindow addSubview:viewContorller];
        m_dialogViewController = viewContorller;
    }
    
    NSError *error = nil;
    NSHTTPURLResponse *response = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:muRequest returningResponse:&response error:&error];
    if(response == nil){ // 请求响应失败
        v_failedCallBack(error);
        [CPublic ShowToast_NetError];
        return;
    }
    if(error == nil
       && response.statusCode == 200){
        NSDictionary *dicJson = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        v_sucCallBack(dicJson);
    } else {
        v_failedCallBack(error);
    }
    [self removeDialogLoading];
}

@end
