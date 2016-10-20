//
//  UIImage+ImageEffects.h
//  MachineModule
//
//  Created by LHJ on 16/1/12.
//  Copyright © 2016年 LHJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (ImageEffects)

// =====================================================================================
#pragma mark - iOS SDK 7.0+版本才能使用的方法
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_7_0

- (UIImage *)applyLightEffect NS_ENUM_AVAILABLE_IOS(7_0);
- (UIImage *)applyExtraLightEffect NS_ENUM_AVAILABLE_IOS(7_0);
- (UIImage *)applyDarkEffect NS_ENUM_AVAILABLE_IOS(7_0);
- (UIImage *)applyTintEffectWithColor:(UIColor *)tintColor NS_ENUM_AVAILABLE_IOS(7_0);

/** 返回毛玻璃的图片 */
- (UIImage*) getImgOfBlurred NS_ENUM_AVAILABLE_IOS(7_0);

/** 返回毛玻璃效果的图片 */
- (UIImage *)applyBlurWithRadius:(CGFloat)blurRadius
                       tintColor:(UIColor *)tintColor
           saturationDeltaFactor:(CGFloat)saturationDeltaFactor
                       maskImage:(UIImage *)maskImage NS_ENUM_AVAILABLE_IOS(7_0);

#endif

@end