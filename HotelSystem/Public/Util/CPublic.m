//
//  CPublic.m
//  MyPro
//
//  Created by hancj on 15/11/9.
//  Copyright © 2015年 hancj. All rights reserved.
//

#import "CPublic.h"
#include <arpa/inet.h>
#include <netdb.h>
#include <net/if.h>
#include <ifaddrs.h>
#import <dlfcn.h>

static CPublic *CPublicObj;
static float KeyboardHeight = 280.0f;

/** 当前网络状态 */
static NetworkStatusNow networkStatusNow;

@implementation CPublic
{
    /** 监测网络状态的对象*/
    Reachability *m_reachability;
}

- (instancetype) init
{
    self = [super init];
//    m_reachability = [Reachability reachabilityForInternetConnection];
//    [m_reachability startNotifier];
//    networkStatusNow = NetworkStatusNow_ViaWWAN; // 默认非WIFI
    
//    [self checkNetworkStateChange];
    
    return self;
}
- (void) dealloc
{
    [m_reachability stopNotifier];
    m_reachability = nil;
    
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter removeObserver:self];
    notificationCenter = nil;
}

/** 初始化公共事件的监听 */
+ (void) initCPublicObserver
{
    if(CPublicObj == nil){
        CPublicObj = [CPublic new];
    }
    [self initKeyboardEvent];
    [self initNetworkObserver];
}
/** 初始化键盘弹出/隐藏的监听事件 */
+ (void) initKeyboardEvent
{
    // 注册键盘响应事件
    @try{
        NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
        [notificationCenter removeObserver:self name:UIKeyboardWillShowNotification object:nil];
        
        [notificationCenter addObserver:CPublicObj selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    }@catch(NSException *e){}
}
/** 添加网络状态变化的监听事件 */
+ (void) initNetworkObserver
{
    if(CPublicObj == nil){
        CPublicObj = [CPublic new];
    }
    @try{
        NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
        [notificationCenter removeObserver:CPublicObj name:kReachabilityChangedNotification object:nil];
        
        [notificationCenter addObserver:CPublicObj selector:@selector(checkNetworkStateChange) name:kReachabilityChangedNotification object:nil];
        notificationCenter = nil;
        
    }@catch(NSException *e){}
}

/** 获取键盘高度 */
+ (float) getKeyboardHeight
{
    return KeyboardHeight;
}
/** 键盘弹出触发事件 */
- (void) keyboardWillShow:(NSNotification*)v_notification
{
    NSDictionary *dicUserInfo = [v_notification userInfo];
    NSValue *value = [dicUserInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    KeyboardHeight = [value CGRectValue].size.height;
}
/** 监测网络变化  */
- (void) checkNetworkStateChange
{
    // 1.检测wifi状态
    Reachability *wifi = [Reachability reachabilityForLocalWiFi];
    
    // 2.检测手机是否能上网络(WIFI\3G\2.5G)
    Reachability *conn = [Reachability reachabilityForInternetConnection];
    
    // 3.判断网络状态
    if ([wifi currentReachabilityStatus] != NotReachable) { // 有wifi
        NSLog(@"Wifi");
        networkStatusNow = NetworkStatusNow_WiFi;
        
    } else if ([conn currentReachabilityStatus] != NotReachable) { // 没有使用wifi, 使用手机自带网络进行上网
        NSLog(@"3G/4G");
        networkStatusNow = NetworkStatusNow_ViaWWAN;
        
    } else { // 没有网络
        NSLog(@"无网络");
        networkStatusNow = NetworkStatusNow_NoEnable;
    }
}
/** 获取当前的网络状态 */
+ (NetworkStatusNow) getNetworkStatusNow
{
    return networkStatusNow;
}

/** 根据年月日时分秒生成唯一字符串 */
+ (NSString*) getUniqueName
{
    NSDate *date = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit)
                                          fromDate:date];
    NSInteger year = [comps year];
    NSInteger month = [comps month];
    NSInteger day = [comps day];
    NSInteger hour = [comps hour];
    NSInteger min = [comps minute];
    NSInteger second = [comps second];
    
    return [NSString stringWithFormat:@"%d%d%d%d%d%d",(int)year, (int)month, (int)day, (int)hour, (int)min, (int)second];
}

/** 获取处于屏幕的View */
+ (UIView*) getScreenView:(UIView*)v_view
{
    BOOL bIOS7 = (SystemVersonOfIOS >= SystemVersonOfIOS_7_0);
    CGFloat fScrHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat fScrWidth = [UIScreen mainScreen].bounds.size.width;
    if(bIOS7 != YES){ // IOS7.0之前状态栏占20高度
        fScrHeight -= Height_StatusBar;
    }
    UIView *viewResult = v_view;
    while (viewResult.frame.size.width!=fScrWidth
           || viewResult.frame.size.height!=fScrHeight) {
        viewResult = [viewResult superview];
        if(viewResult == NULL)
            break;
    }
    return viewResult;
}
/** 获取最顶层ViewController */
+ (UIViewController *)appRootViewController
{
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *topVC = appRootVC;
    while (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    return topVC;
}
/** 获取该View在屏幕View的坐标点 */
+ (CGPoint)getRelativePointForScreenView:(UIView *)v_view
{
    BOOL bIOS7 = (SystemVersonOfIOS >= SystemVersonOfIOS_7_0);
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    if (bIOS7 != YES) {
        screenHeight -= Height_StatusBar;
    }
    UIView *view = v_view;
    CGFloat x = .0;
    CGFloat y = .0;
    while (view.frame.size.width != screenWidth || view.frame.size.height != screenHeight) {
        x += view.frame.origin.x;
        y += view.frame.origin.y;
        view = view.superview;
        if ([view isKindOfClass:[UIScrollView class]]) {
            x -= ((UIScrollView *) view).contentOffset.x;
            y -= ((UIScrollView *) view).contentOffset.y;
        }
    }
    return CGPointMake(x, y);
}
// ======================================================================
#pragma mark -  用UILabel计算适应字体尺寸的方法
/** 获取文字适应高度-用UILabel的函数计算 */
+ (CGFloat) getTextHeightWithLabelSizeToFit:(NSString*)v_str _font:(UIFont*)v_font
{
    return [CPublic getTextSizeWithLabelSizeToFit:v_str _font:v_font _fitSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)].height;
}
/** 获取文字适应高度-用UILabel的函数计算 */
+ (CGSize) getTextSizeWithLabelSizeToFit:(NSString*)v_str _font:(UIFont*)v_font
{
    return [CPublic getTextSizeWithLabelSizeToFit:v_str _font:v_font _fitSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
}
+ (CGSize) getTextSizeWithLabelSizeToFit:(NSString*)v_str _font:(UIFont*)v_font _fitWidth:(float)v_fitWidth
{
    return [CPublic getTextSizeWithLabelSizeToFit:v_str _font:v_font _fitSize:CGSizeMake(v_fitWidth, CGFLOAT_MAX)];
}
/** 获取文字适应高度-用UILabel的函数计算 */
+ (CGSize) getTextSizeWithLabelSizeToFit:(NSString*)v_str _font:(UIFont*)v_font _fitSize:(CGSize)v_fitSize
{
    UILabel *lab = [UILabel new];
    [lab setFont:v_font];
    [lab setText:v_str];
    return [lab sizeThatFits:v_fitSize];
}

// ======================================================================
#pragma mark -  用UITextView计算适应字体尺寸的方法
/** 获取文字适应高宽-用UITextView的函数计算 */
+ (CGSize) getTextSize:(NSString*)v_str _font:(UIFont*)v_font _fitSize:(CGSize)v_fitSize
{
    UITextView *tv = [UITextView new];
    [tv setFrame:CGRectMake(0, 0, 1, 1)];
    [tv setFont:v_font];
    [tv setText:v_str];
    CGSize sizeRS = [tv sizeThatFits:v_fitSize];
    return sizeRS;
}
/** 获取文字适应高宽 */
+ (float) getTextHeight:(NSString*)v_str _font:(UIFont*)v_font _fitWidth:(float)v_fitWidth
{
    return [CPublic getTextSize:v_str _font:v_font _fitSize:CGSizeMake(v_fitWidth, CGFLOAT_MAX)].height;
}
/** 获取文字适应高宽 */
+ (float) getTextHeight:(NSString*)v_str _font:(UIFont*)v_font
{
    return [CPublic getTextSize:v_str _font:v_font _fitSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)].height;
}
/** 获取文字适应高宽 */
+ (CGSize) getTextSize:(NSString*)v_str _font:(UIFont*)v_font
{
    return [CPublic getTextSize:v_str _font:v_font _fitSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
}
/** 显示对话框 */
+ (void) ShowToast:(NSString*)v_strContent
{
    ShowToastView *viewToast = [ShowToastView new];
    [viewToast setContent:v_strContent];
    [[UIApplication sharedApplication].keyWindow addSubview:viewToast];
}
/** 显示对话框 - 网络错误 */
+ (void) ShowToast_NetError
{
    ShowToastView *viewToast = [ShowToastView new];
    [viewToast setContent:@"网络不给力"];
    [[UIApplication sharedApplication].keyWindow addSubview:viewToast];
}
/** 显示类似Android一样的提示框 */
+ (void) ShowToastWithAndroid:(NSString*)v_strContent
{
    View_Toast *viewToast = [View_Toast new];
    [viewToast showToast:[UIApplication sharedApplication].keyWindow _content:v_strContent];
}

/** 返回毛玻璃效果的View，覆盖在目标View上， iOS8.0以后使用 */
+ (UIView*) getViewWithVisualEffectView:(CGRect)v_frame
{
    return [CPublic getViewWithVisualEffectView:v_frame _alpha:1.0f];
}

/** 返回毛玻璃效果的View，覆盖在目标View上， iOS8.0以后使用 */
+ (UIView*) getViewWithVisualEffectView:(CGRect)v_frame _alpha:(float)v_alpha
{
    UIView *viewRS = nil;
    if(iOS_8_0)
    {
        UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        
        UIVisualEffectView *effectview = [[UIVisualEffectView alloc] initWithEffect:blur];
        [effectview setAlpha:v_alpha];
        effectview.frame = v_frame;
        viewRS = effectview;
    }
    
    return viewRS;
}

/** 显示对话框 */
+ (void) ShowDialgController:(NSString*)v_strContent _viewController:(UIViewController*)v_viewController
{
    if(iOS_8_0)
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:v_strContent preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *commitAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:commitAction];
        [v_viewController presentViewController:alertController animated:YES completion:nil];
    
    } else {
        [self ShowDialg:v_strContent];
    }
    
}

/** 显示对话框 */
+ (void) ShowDialg:(NSString*)v_strContent
{
    if(v_strContent == nil) return;
    
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:v_strContent delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
    alert = nil;
}

/** 显示对话框 */
+ (void) ShowDialg:(NSString*)v_strContent _delegate:(id)v_delegate _tag:(int)v_tag
{
    if(v_strContent == nil) return;
    
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:v_strContent delegate:v_delegate cancelButtonTitle:@"确定" otherButtonTitles:nil];
    alert.tag = v_tag;
    [alert show];
    alert = nil;
}

/** 显示对话框 */
+ (void) ShowDialg:(NSString*)v_strContent _delegate:(id)v_delegate
{
    [CPublic ShowDialg:v_strContent _delegate:v_delegate _tag:0];
}
/** 获取字符串第一个字的首字母 */
+ (NSString *)getIndexTitleForName:(NSString *)v_strName
{
    static NSString *otherKey = @"#";
    if (v_strName == nil
        || [v_strName isEqualToString:@""] == YES) {
        return otherKey;
    }
    
    NSMutableString *mutableString = [NSMutableString stringWithString:[v_strName substringToIndex:1]];
    CFMutableStringRef mutableStringRef = (__bridge CFMutableStringRef)mutableString;
    CFStringTransform(mutableStringRef, nil, kCFStringTransformToLatin, NO);
    CFStringTransform(mutableStringRef, nil, kCFStringTransformStripCombiningMarks, NO);
    
    NSString *key = [[mutableString uppercaseString] substringToIndex:1];
    unichar capital = [key characterAtIndex:0];
    if (capital >= 'A' && capital <= 'Z') {
        return key;
    }
    return otherKey;
}
/** 返回该文字的拼音组合 */
+ (NSString*) getIndexForName:(NSString*)v_strName
{
    if(v_strName == nil
       || [v_strName isEqualToString:@""] == YES){
        return @"";
    }
    NSMutableString *muStrRS = [NSMutableString stringWithString:@""];
    for(int i=0; i<v_strName.length; i+=1){
        NSRange range;
        range.location = i;
        range.length = 1;
        NSMutableString *muStrTemp = [NSMutableString stringWithString:[v_strName substringWithRange:range]];
        CFMutableStringRef cfMuStringRef = (__bridge CFMutableStringRef)muStrTemp;
        CFStringTransform(cfMuStringRef, nil, kCFStringTransformToLatin, NO);
        CFStringTransform(cfMuStringRef, nil, kCFStringTransformStripCombiningMarks, NO);
        [muStrRS appendString:[muStrTemp lowercaseString]];
    }
    return muStrRS;
}
/** 根据传入的数组，返回以英文A~Z为索引的字典集 */
+ (NSDictionary*) getNamesWithIndex:(NSArray*)v_ary
{
    NSMutableDictionary *muDicRS = [NSMutableDictionary new];
    if(v_ary != nil) {
        for(NSString *strName in v_ary){
            NSString *strIndex = [CPublic getIndexTitleForName:strName];
            NSMutableArray *muAryTemp = [muDicRS objectForKey:strIndex];
            if(muAryTemp == nil){
                muAryTemp = [NSMutableArray new];
                [muDicRS setObject:muAryTemp forKey:strIndex];
            }
            [muAryTemp addObject:strName];
        }
    }
    return muDicRS;
}

/** 获取APP文件夹根目录 */
+ (NSString*) getRootDirectorFilePath
{
    NSString *strRS = @"";
    NSArray *aryPaths = NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES);
    if(aryPaths!=nil
       && aryPaths.count > 0){
        strRS = [aryPaths objectAtIndex:0];
    }
    return strRS;
}
/** 字符串转换成NSURL */
+ (NSURL*) getURLFromString:(NSString*)v_strURL
{
    NSString *strTemp = [v_strURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *urlRS = [NSURL URLWithString:strTemp];
    return urlRS;
}
/** 获取指定大小的图片 */
+ (UIImage*) getNewImgOfNewSize:(UIImage*)v_oldImg _newSize:(CGSize)v_newSize
{
    UIGraphicsBeginImageContext(v_newSize);
    [v_oldImg drawInRect:CGRectMake(0, 0, v_newSize.width, v_newSize.height)];
    UIImage *imgRS = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    v_oldImg = nil;
    return imgRS;
}
/** 获取压缩过的Jpg图片，v_scale为压缩比 */
+ (UIImage*) getNewImgOfJPG:(UIImage*)v_oldImg _scale:(float)v_scale
{
    NSData *data = UIImageJPEGRepresentation(v_oldImg, v_scale);
    return [UIImage imageWithData:data];
}
/** 用颜色填充一张图片 */
+ (UIImage*) getImgWithColor:(UIColor*)v_color
{
    CGRect frame = CGRectMake(0, 0, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, v_color.CGColor);
    CGContextFillRect(context, frame);
    UIImage *imgRS = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    CGContextRelease(context);
    return imgRS;
}
/** 以Iphone6的屏幕宽高以基准，计算该v_view及其子View的所有坐标尺寸 */
+ (void) handleAutoLayoutWithIphone6:(UIView*)v_view
{
    for(UIView *viewChild in [v_view subviews])
    {
        [CPublic handleAutoLayoutWithIphone6:viewChild];
    }
    CGFloat scale_screen = [UIScreen mainScreen].scale;
    float scale_x = ScreenSize.width*scale_screen/750;
    float scale_y = ScreenSize.height*scale_screen/1334;
    float scale = MIN(scale_x, scale_y);
    float width = v_view.bounds.size.width;
    float height = v_view.bounds.size.height;
    CGRect frame = v_view.frame;
    frame.origin.x *= scale;
    frame.origin.y *= scale;
    if(width < ScreenSize.width){
        width *= scale;
    }
    if(height < ScreenSize.height){
        height *= scale;
    }
    frame.size = CGSizeMake(width, height);
    v_view.frame = frame;
    
    if([v_view isKindOfClass:[UIScrollView class]] == YES){
        CGSize contentSize = [(UIScrollView*)v_view contentSize];
        if(contentSize.width > v_view.bounds.size.width){
            contentSize.width *= scale;
        }
        if(contentSize.height > v_view.bounds.size.height){
            contentSize.height *= scale;
        }
        [(UIScrollView*)v_view setContentSize:contentSize];
    }
}
/** 判断本地路径是否存在，不存在则创建 */
+ (BOOL) createLocalFilePathIfNoExit:(NSString*)v_strPath
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    return [fileManager createDirectoryAtPath:v_strPath withIntermediateDirectories:YES attributes:nil error:nil];
}
/** 根据文件的相对地址，获取APP沙盒的绝对路径地址 */
+ (NSString*) getLocalAbsolutePathOfRelativePath:(NSString*)v_strRelativePath
{
    NSString *strLocalPath = [CPublic getRootDirectorFilePath];
    return [NSString stringWithFormat:@"%@/%@", strLocalPath, v_strRelativePath];
}
/** 根据Json字符串获取对应的字典 */
+ (NSDictionary*) getDicObjWithJsonStr:(NSString*)v_strJson
{
    NSData *data = [v_strJson dataUsingEncoding:NSUTF8StringEncoding];
    return [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
}

/** 根据字典生成对应的Json字符串 */
+ (NSString*) getJsonStrWithDicObj:(NSDictionary*)v_dicObj
{
    NSData *data = [NSJSONSerialization dataWithJSONObject:v_dicObj options:NSJSONWritingPrettyPrinted error:nil];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}
//获取当前网络的IP地址
+ (NSString *) getLocalWiFiIPAddress
{
    BOOL success;
    struct ifaddrs * addrs;
    const struct ifaddrs * cursor;
    
    success = getifaddrs(&addrs) == 0;
    if (success) {
        cursor = addrs;
        while (cursor != NULL) {
            // the second test keeps from picking up the loopback address
            if (cursor->ifa_addr->sa_family == AF_INET && (cursor->ifa_flags & IFF_LOOPBACK) == 0)
            {
                NSString *name = [NSString stringWithUTF8String:cursor->ifa_name];
                if ([name isEqualToString:@"en0"])  // Wi-Fi adapter
                    return [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)cursor->ifa_addr)->sin_addr)];
            }
            cursor = cursor->ifa_next;
        }
        freeifaddrs(addrs);
    }
    return nil;
}

@end
