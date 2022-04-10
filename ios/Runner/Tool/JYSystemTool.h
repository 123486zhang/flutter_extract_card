//
//  JYSystemTool.h
//  VideoClip
//
//  Created by 刘浩 on 2019/4/17.
//  Copyright © 2019 admin. All rights reserved.
//

#import <Foundation/Foundation.h>



NS_ASSUME_NONNULL_BEGIN

typedef void(^JY_RESPONSE_BLOCK)(NSDictionary* result, NSError* _Nullable  error);

@interface JYSystemTool : NSObject
+ (NSString *) md5:(NSString *) str;

+ (NSString *)getUUID;

+ (NSString *)getAppVersion;
//清除之前存在keychain上的uuid
+ (void)deleteUuid;
//利用keychain存uuid
+ (id)loadSevice:(NSString *)service ;
+ (void)deleteSevice:(NSString *)service ;
+ (void)saveSevice:(NSString *)service data:(id)data ;

///请求支付验证
+(void)jyVerifyPayWithParam:(NSDictionary *)param response:(JY_RESPONSE_BLOCK)response;

+(NSDictionary *)getDicFromString:(NSString *)string;

+ (NSString *)getStringFromDict:(NSDictionary *)dict;

+ (BOOL)isBlankString:(NSString *)string;

@end

NS_ASSUME_NONNULL_END

