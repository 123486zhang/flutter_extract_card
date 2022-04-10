//
//  JYUIUtils.h
//  VideoClip
//
//  Created by 杨志豪 on 2019/5/7.
//  Copyright © 2019 Ray. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define APP_PRODUCT_ID @"152"

#define JY_SCREAN_WIDTH [UIScreen mainScreen].bounds.size.width
#define JY_SCREAN_SCALE [UIScreen mainScreen].bounds.size.width / 375.0
#define JY_SCREAN_HEIGHT [UIScreen mainScreen].bounds.size.height

#define JY_NavAndStatusHight  self.navigationController.navigationBar.frame.size.height+[[UIApplication sharedApplication] statusBarFrame].size.height

//安全的主线程
#ifndef dispatch_main_async_safe
#define dispatch_main_async_safe(block)\
if (strcmp(dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL), dispatch_queue_get_label(dispatch_get_main_queue())) == 0) {\
block();\
} else {\
dispatch_async(dispatch_get_main_queue(), block);\
}
#endif


@interface JYUIUtils : NSObject



+ (UIViewController *_Nullable) getVisibleViewController;

+ (UIViewController *_Nullable) getVisibleViewControllerFrom:(UIViewController *_Nullable) vc;

/**
 按照比例及最大尺寸范围转化的ScaleAspectFit

 @param maxSize 最大尺寸范围
 @param scale 比例
 @return 按照比例及最大尺寸范围转化的ScaleAspectFit
 */
+ (CGSize)resultSizeWithMaxSize:(CGSize)maxSize scale:(CGSize)scale;

+ (NSData *)compressImageSize:(UIImage *)image toByte:(NSUInteger)maxLength;

@end

