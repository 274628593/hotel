//
//  Network.h
//  MyPro
//
//  Created by LHJ on 15/12/5.
//  Copyright © 2015年 hancj. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "Network_Key.h"
#import "DialogOfLoadingViewController.h"

/** 网络请求类 */
@interface Network : NSObject

// ==========================================================================
#pragma mark -  外部变量
/** 基础URL，每次发送请求就与v_strURL入参对接，默认值BaseAddress */
@property(nonatomic, copy, setter=setBaseURL:, getter=getBaseURL) NSString *m_strBaseURL;

/** 上传保存的文件名，不设置的话就自动生成 */
@property(nonatomic, copy, setter=setUploadFileName:) NSString *m_strUploadFileName;

/** 是否加载加载框。默认YES */
@property(nonatomic, assign, setter=setIsShowDialog:) BOOL m_bIsShowDialog;

// ==========================================================================
#pragma mark -  外部调用方法
/** 请求参数，如果为nil，则采用默认值 */
@property(nonatomic, retain, setter=setHttpRequestParams:, getter=getHttpRequestParams) NSDictionary *m_dicHttpRequestParams;

/** 超时时间，默认10秒 */
@property(nonatomic, assign, setter=setTimeOut:, getter=getTimeOut) NSTimeInterval m_timeOut;

/** 以Post方式请求Json数据 */
- (void) getJsonDataWithNetwork_withPost_params:(NSDictionary*)v_dicParams
                               _successCallBack:(void(^)(NSDictionary*v_dic))v_sucCallBack
                                 _faildCallBack:(void(^)(NSError*v_dic))v_failedCallBack;

/** 以Post方式请求Json数据 */
- (void) getJsonDataWithNetwork_withPost:(NSString*)v_strURL
                                 _params:(NSDictionary*)v_dicParams
                        _successCallBack:(void(^)(NSDictionary*v_dic))v_sucCallBack
                          _faildCallBack:(void(^)(NSError*v_dic))v_failedCallBack;

/** 以Get方式请求Json数据 */
- (void) getJsonDataWithNetwork_withGet:(NSString*)v_strURL
                                _params:(NSDictionary*)v_dicParams
                       _successCallBack:(void(^)(NSDictionary*v_dic))v_sucCallBack
                         _faildCallBack:(void(^)(NSError*))v_failedCallBack;

/** 以Get方式请求Json数据，v_strURL包含所有参数 */
- (void) getJsonDataWithNetwork_withGet:(NSString*)v_strURL
                       _successCallBack:(void(^)(NSDictionary*v_dic))v_sucCallBack
                         _faildCallBack:(void(^)(NSError*))v_failedCallBack;

/** 以Get方式请求Json数据 */
- (void) getJsonDataWithNetwork_withGet_params:(NSDictionary*)v_dicParams
                              _successCallBack:(void(^)(NSDictionary*v_dic))v_sucCallBack
                                _faildCallBack:(void(^)(NSError*))v_failedCallBack;

/** 以Get方式请求Json数据，v_strURL包含所有参数 */
- (void) getJsonDataWithNetwork_withGet_successCallBack:(void(^)(NSDictionary*v_dic))v_sucCallBack
                                         _faildCallBack:(void(^)(NSError*))v_failedCallBack;

/** 上传文件 */
- (void) uploadFileToNetworkWithFileData:(NSData*)v_data
                        _successCallBack:(void(^)(NSString *v_strRS))v_successCallBack
                         _failedCallBack:(void(^)(NSError *v_error))v_failedCallBack;

/** 上传文件 */
- (void) uploadFileToNetwork:(NSString*)v_strURL
                   _fileData:(NSData*)v_data
            _successCallBack:(void(^)(NSString *v_strRS))v_successCallBack
             _failedCallBack:(void(^)(NSError *v_error))v_failedCallBack;

/** 以Post方式请求Json数据：同步 */
- (void) getJsonDataWithNetworkSync_withPost_params:(NSDictionary*)v_dicParams
                                   _successCallBack:(void(^)(NSDictionary*v_dic))v_sucCallBack
                                     _faildCallBack:(void(^)(NSError*v_dic))v_failedCallBack;

/** 以Post方式请求Json数据：同步 */
- (void) getJsonDataWithNetworkSync_withPost:(NSString*)v_strURL
                                     _params:(NSDictionary*)v_dicParams
                            _successCallBack:(void(^)(NSDictionary*v_dic))v_sucCallBack
                              _faildCallBack:(void(^)(NSError*))v_failedCallBack;


@end
