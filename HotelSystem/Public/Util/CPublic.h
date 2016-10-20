//
//  CPublic.h
//  MyPro
//
//  Created by hancj on 15/11/9.
//  Copyright © 2015年 hancj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"
#import "ShowToastView.h"
#import "View_Toast.h"
#import "Reachability.h"

// ========================================================================================
#pragma mark - iOS版本宏
#define SystemVersonOfIOS           [[[UIDevice currentDevice] systemVersion] floatValue]
#define iOS(version)                ((SystemVersonOfIOS >= version)? YES : NO)
#define iOS_7_0                     iOS(SystemVersonOfIOS_7_0)
#define iOS_8_0                     iOS(SystemVersonOfIOS_8_0)
#define iOS_9_0                     iOS(SystemVersonOfIOS_9_0)
#define SystemVersonOfIOS_7_0       7.0f
#define SystemVersonOfIOS_8_0       8.0f
#define SystemVersonOfIOS_9_0       9.0f

// ========================================================================================
#pragma mark - 图片相关宏
#define GetImg(str)                 [UIImage imageNamed:str]
#define ColorWithImg(str)           [[UIColor alloc]initWithPatternImage:[UIImage imageNamed:str]]
#define Color_Transparent           [UIColor clearColor]
#define Color_RGBA(r, g, b, a)      [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define Color_RGB(r, g, b)          [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1.0f]

// ========================================================================================
#pragma mark - 字体相关宏
#define Font(s)                 [UIFont systemFontOfSize:s]
#define Font_Bold(s)            [UIFont boldSystemFontOfSize:s]

// ========================================================================================
#pragma mark - 尺寸相关宏
#define ScreenSize              [UIScreen mainScreen].bounds.size // 屏幕分辨率
#define Height_StatusBar        [UIApplication sharedApplication].statusBarFrame.size.height// 状态栏高度

// ========================================================================================
#pragma mark - NSLog宏
// 以release模式编译的程序不会用NSLog输出，而以debug模式编译的程序将执行NSLog的全部功能。
// release模式通常会定义 __OPTIMIZE__，debug模式不会
#ifdef __OPTIMIZE__
    #define NSLog(...)      {}
#else
    #define NSLog(...)      NSLog(__VA_ARGS__)
#endif

#define ShowContentForLog(str)      [NSString stringWithFormat:@"class:%@ ------ content:%@", NSStringFromClass([self class]), str]

// ========================================================================================
#pragma mark - 网络环境枚举
typedef enum : int
{
    NetworkStatusNow_WiFi = 1,  /* WIFI */
    NetworkStatusNow_ViaWWAN,   /* 非WIFI */
    NetworkStatusNow_NoEnable   /* 网络不可用 */
    
} NetworkStatusNow;

// ========================================================================================
#pragma mark -
@interface CPublic : NSObject

// =========================================================
#pragma mark - 全局使用方法
/** 初始化公共事件的监听 */
+ (void) initCPublicObserver;

/** 获取当前的网络状态 */
+ (NetworkStatusNow) getNetworkStatusNow;

/** 获取键盘高度 */
+ (float) getKeyboardHeight;

/** 根据年月日时分秒生成唯一字符串 */
+ (NSString*) getUniqueName;

/** 获取最顶层ViewController */
+ (UIViewController *)appRootViewController;

/** 获取处于屏幕的View */
+ (UIView*) getScreenView:(UIView*)v_view;

/** 获取该View在屏幕View的坐标点 */
+ (CGPoint)getRelativePointForScreenView:(UIView *)v_view;

#pragma mark -  用UILabel计算适应字体尺寸的方法
/** 获取文字适应高度-用UILabel的函数计算 */
+ (CGFloat) getTextHeightWithLabelSizeToFit:(NSString*)v_str _font:(UIFont*)v_font;

/** 获取文字适应高度-用UILabel的函数计算 */
+ (CGSize) getTextSizeWithLabelSizeToFit:(NSString*)v_str _font:(UIFont*)v_font;

+ (CGSize) getTextSizeWithLabelSizeToFit:(NSString*)v_str _font:(UIFont*)v_font _fitWidth:(float)v_fitWidth;

/** 获取文字适应高度-用UILabel的函数计算 */
+ (CGSize) getTextSizeWithLabelSizeToFit:(NSString*)v_str _font:(UIFont*)v_font _fitSize:(CGSize)v_fitSize;


#pragma mark -  用UITextView计算适应字体尺寸的方法
/** 获取文字适应高宽-用UITextView的函数计算 */
+ (CGSize) getTextSize:(NSString*)v_str _font:(UIFont*)v_font _fitSize:(CGSize)v_fitSize;

/** 获取文字适应高宽-用UITextView的函数计算 */
+ (float) getTextHeight:(NSString*)v_str _font:(UIFont*)v_font _fitWidth:(float)v_fitWidth;

/** 获取文字适应高宽-用UITextView的函数计算 */
+ (float) getTextHeight:(NSString*)v_str _font:(UIFont*)v_font;

/** 获取文字适应高宽-用UITextView的函数计算 */
+ (CGSize) getTextSize:(NSString*)v_str _font:(UIFont*)v_font;

/** 显示对话框 */
+ (void) ShowDialg:(NSString*)v_strContent;

/** 显示对话框 */
+ (void) ShowToast:(NSString*)v_strContent;

/** 显示类似Android一样的提示框 */
+ (void) ShowToastWithAndroid:(NSString*)v_strContent;

/** 显示对话框 - 网络错误 */
+ (void) ShowToast_NetError;

/** 显示对话框 */
+ (void) ShowDialg:(NSString*)v_strContent _delegate:(id)v_delegate _tag:(int)v_tag;

/** 显示对话框 */
+ (void) ShowDialg:(NSString*)v_strContent _delegate:(id)v_delegate;

/** 获取APP文件夹根目录 */
+ (NSString*) getRootDirectorFilePath;

/** 返回该文字的拼音组合 */
+ (NSString*) getIndexForName:(NSString*)v_strName;

/** 获取字符串第一个字的首字母 */
+ (NSString *)getIndexTitleForName:(NSString *)v_strName;

/** 根据传入的数组，返回以英文A~Z为索引的字典集 */
+ (NSDictionary*) getNamesWithIndex:(NSArray*)v_ary;

/** 字符串转换成NSURL */
+ (NSURL*) getURLFromString:(NSString*)v_strURL;

/** 获取指定大小的图片 */
+ (UIImage*) getNewImgOfNewSize:(UIImage*)v_oldImg _newSize:(CGSize)v_newSize;

/** 获取压缩过的Jpg图片，v_scale为压缩比 */
+ (UIImage*) getNewImgOfJPG:(UIImage*)v_oldImg _scale:(float)v_scale;

/** 用颜色填充一张图片 */
+ (UIImage*) getImgWithColor:(UIColor*)v_color;

/** 以Iphone6的屏幕宽高以基准，计算该v_view及其子View的所有坐标尺寸 */
+ (void) handleAutoLayoutWithIphone6:(UIView*)v_view;

/** 判断本地路径是否存在，不存在则创建 */
+ (BOOL) createLocalFilePathIfNoExit:(NSString*)v_strPath;

/** 根据文件的相对地址，获取APP沙盒的绝对路径地址 */
+ (NSString*) getLocalAbsolutePathOfRelativePath:(NSString*)v_strRelativePath;

/** 根据Json字符串获取对应的字典 */
+ (NSDictionary*) getDicObjWithJsonStr:(NSString*)v_strJson;

/** 根据字典生成对应的Json字符串 */
+ (NSString*) getJsonStrWithDicObj:(NSDictionary*)v_dicObj;

//获取当前网络的IP地址
+ (NSString *) getLocalWiFiIPAddress;

// =====================================================================================
#pragma mark - iOS SDK 8.0+版本才能使用的方法
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_8_0

/** 显示对话框，iOS8.0+使用 */
+ (void) ShowDialgController:(NSString*)v_strContent _viewController:(UIViewController*)v_viewController NS_ENUM_AVAILABLE_IOS(8.0);

/** 返回毛玻璃效果的View，覆盖在目标View上， iOS8.0+使用 */
+ (UIView*) getViewWithVisualEffectView:(CGRect)v_frame NS_ENUM_AVAILABLE_IOS(8.0);

/** 返回毛玻璃效果的View，覆盖在目标View上， iOS8.0+使用 */
+ (UIView*) getViewWithVisualEffectView:(CGRect)v_frame _alpha:(float)v_alpha NS_ENUM_AVAILABLE_IOS(8.0);

#endif

@end
