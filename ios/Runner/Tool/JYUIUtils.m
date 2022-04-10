//
//  JYUIUtils.m
//  VideoClip
//
//  Created by 杨志豪 on 2019/5/7.
//  Copyright © 2019 Ray. All rights reserved.
//

#import "JYUIUtils.h"

@implementation JYUIUtils


+ (UIViewController *) getVisibleViewController {
    UIViewController *topController = [UIApplication sharedApplication].keyWindow.rootViewController;
    topController = [JYUIUtils getVisibleViewControllerFrom:topController];
    
    return topController;
}

+ (UIViewController *) getVisibleViewControllerFrom:(UIViewController *) vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [JYUIUtils getVisibleViewControllerFrom:[((UINavigationController *) vc) visibleViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [JYUIUtils getVisibleViewControllerFrom:[((UITabBarController *) vc) selectedViewController]];
    } else {
        if (vc.presentedViewController) {
            return [JYUIUtils getVisibleViewControllerFrom:vc.presentedViewController];
        } else {
            return vc;
        }
    }
}

+ (NSString *)getMinAndSecondTimeStringForSecond:(NSInteger)scond{
    return [NSString stringWithFormat:@"%02d:%02d", scond / 60, scond % 60];
}

+ (CGSize)resultSizeWithMaxSize:(CGSize)maxSize scale:(CGSize)scale {
    if (scale.height <= 0 || scale.width <= 0) {
        return CGSizeZero;
    }
    CGFloat width = maxSize.width;
    CGFloat height = maxSize.height;
    
    if (width / scale.width * scale.height <= height) {
        return CGSizeMake(width, width / scale.width * scale.height);
    } else if (height / scale.height * scale.width <= width) {
        return CGSizeMake(height / scale.height * scale.width, height);
    } else {
        return CGSizeZero;
    }
}

//图片质量压缩到某一范围内，如果后面用到多，可以抽成分类或者工具类,这里压缩递减比二分的运行时间长，二分可以限制下限。
+ (NSData *)compressImageSize:(UIImage *)image toByte:(NSUInteger)maxLength{
    //首先判断原图大小是否在要求内，如果满足要求则不进行压缩，over
    CGFloat compression = 1;
    NSData *data = UIImageJPEGRepresentation(image, compression);
    if (data.length < maxLength) return data;
    //原图大小超过范围，先进行“压处理”，这里 压缩比 采用二分法进行处理，6次二分后的最小压缩比是0.015625，已经够小了
    CGFloat max = 1;
    CGFloat min = 0;
    for (int i = 0; i < 6; ++i) {
        compression = (max + min) / 2;
        data = UIImageJPEGRepresentation(image, compression);
        if (data.length < maxLength * 0.9) {
            min = compression;
        } else if (data.length > maxLength) {
            max = compression;
        } else {
            break;
        }
    }
    //判断“压处理”的结果是否符合要求，符合要求就over
    UIImage *resultImage = [UIImage imageWithData:data];
    if (data.length < maxLength) return data;
    
    //缩处理，直接用大小的比例作为缩处理的比例进行处理，因为有取整处理，所以一般是需要两次处理
    NSUInteger lastDataLength = 0;
    while (data.length > maxLength && data.length != lastDataLength) {
        lastDataLength = data.length;
        //获取处理后的尺寸
        CGFloat ratio = (CGFloat)maxLength / data.length;
        CGSize size = CGSizeMake((NSUInteger)(resultImage.size.width * sqrtf(ratio)),
                                 (NSUInteger)(resultImage.size.height * sqrtf(ratio)));
        //通过图片上下文进行处理图片
        UIGraphicsBeginImageContext(size);
        [resultImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
        resultImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        //获取处理后图片的大小
        data = UIImageJPEGRepresentation(resultImage, compression);
    }
    
    return data;
}

@end
