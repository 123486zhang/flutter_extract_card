//
//  UIColor+Hex.m
//  VideoClip
//
//  Created by 刘浩 on 2019/4/10.
//  Copyright © 2019 admin. All rights reserved.
//

#import "UIColor+Hex.h"

@implementation UIColor (Hex)
+ (UIColor*) colorWithHex:(long)hexColor;
{
    return [UIColor colorWithHex:hexColor alpha:1.];
}

+ (UIColor *)colorWithHex:(long)hexColor alpha:(float)opacity
{
    float red = ((float)((hexColor & 0xFF0000) >> 16))/255.0;
    float green = ((float)((hexColor & 0xFF00) >> 8))/255.0;
    float blue = ((float)(hexColor & 0xFF))/255.0;
    return [UIColor colorWithRed:red green:green blue:blue alpha:opacity];
}
+(UIColor *)jyNavyGreen{
    return [UIColor colorWithHex:0x2da2b4];
}
+(UIColor *)jyTextGray{
    return [UIColor colorWithHex:0xb3b3b3];
}
+ (instancetype)nv_colorWithHexARGB:(NSString *)argb {
    NSAssert([argb hasPrefix:@"#"], @"颜色字符串要以#开头");
    
    NSString *hexString = [argb substringFromIndex:1];
    unsigned int hexInt;
    BOOL result = [[NSScanner scannerWithString:hexString] scanHexInt:&hexInt];
    if (!result) {
        return nil;
    }
    
    CGFloat divisor = 255.0;
    CGFloat alpha = ((hexInt & 0xFF000000) >> 24) / divisor;
    CGFloat red   = ((hexInt & 0x00FF0000) >> 16) / divisor;
    CGFloat green    = ((hexInt & 0x0000FF00) >>  8) / divisor;
    CGFloat blue   = ( hexInt & 0x000000FF       ) / divisor;
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
    
}
+(UIColor *)pannelBlack24232A{
    return [UIColor colorWithHex:0x24232A];
}
+(UIColor *)pinkCoverColorF6267E_05{
    return [[UIColor colorWithHex:0xF6267E]colorWithAlphaComponent:0.5];
}
+(UIColor *)pinkCoverColorF6267E{
    return [UIColor colorWithHex:0xF6267E];
}

+(UIColor *)pinkCoverColor32303A{
    return [UIColor colorWithHex:0x32303A];
}


@end
