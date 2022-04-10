//
//  UIColor+Hex.h
//  VideoClip
//
//  Created by 刘浩 on 2019/4/10.
//  Copyright © 2019 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (Hex)
+ (UIColor *)colorWithHex:(long)hexColor;
+ (UIColor *)colorWithHex:(long)hexColor alpha:(float)opacity;
+ (instancetype)nv_colorWithHexARGB:(NSString *)argb;
+(UIColor *)jyNavyGreen;
+(UIColor *)jyTextGray;

+(UIColor *)pannelBlack24232A;
+(UIColor *)pinkCoverColorF6267E_05;
+(UIColor *)pinkCoverColorF6267E;
+(UIColor *)pinkCoverColor32303A;
@end

NS_ASSUME_NONNULL_END
