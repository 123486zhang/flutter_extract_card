//
//  JYSystemTool.m
//  VideoClip
//
//  Created by 刘浩 on 2019/4/17.
//  Copyright © 2019 admin. All rights reserved.
//

#import "JYSystemTool.h"
#import <CommonCrypto/CommonDigest.h>

#import "AFNetworking.h"

#import <NetworkExtension/NetworkExtension.h>
#import <SystemConfiguration/CaptiveNetwork.h>
#define KEY_UDID_INSTEAD  @"com.qi.ming_UDID_INSTEAD"
#define k_baseUrl  @"https://ajj.fuguizhukj.cn"
//支付验证
#define apiApplePayOrder  @"api/ApplePay/QueryValidateRealNameOrder"

static JYSystemTool *instance;
@interface JYSystemTool()
@property(nonatomic,strong) NSString *mMacAddress;
@property(nonatomic,strong) NSString *mUniqueIdentification;
@property(nonatomic,assign) BOOL hasShownMsg;

@end
@implementation JYSystemTool
+(instancetype)shareInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [JYSystemTool new];
    });
    return instance;
}

+ (NSString *) md5:(NSString *) str
{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

+(NSString *)getUUID{
    NSString *k_uuid = [self loadSevice:KEY_UDID_INSTEAD];
    if (k_uuid) {
        return k_uuid;
    }else{
        CFUUIDRef uuidRef = CFUUIDCreate(kCFAllocatorDefault);
        
        CFStringRef uuidString = CFUUIDCreateString(kCFAllocatorDefault, uuidRef);
        
        NSString* app_uuid = [NSString stringWithString:(__bridge NSString*)uuidString];
        
        CFRelease(uuidString);
        
        CFRelease(uuidRef);
        [self saveSevice:KEY_UDID_INSTEAD data:app_uuid];
        return app_uuid;
    }
}

+ (void)deleteSevice:(NSString *)service {
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    SecItemDelete((CFDictionaryRef)keychainQuery);
}
+(void)deleteUuid{
    [self deleteSevice:KEY_UDID_INSTEAD];
//    [[JYVIPCheckManager shared] clean];
}
+ (id)loadSevice:(NSString *)service {
    id ret = nil;
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    //Configure the search setting
    //Since in our simple case we are expecting only a single attribute to be returned (the password) we can set the attribute kSecReturnData to kCFBooleanTrue
    [keychainQuery setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnData];
    [keychainQuery setObject:(id)kSecMatchLimitOne forKey:(id)kSecMatchLimit];
    CFDataRef keyData = NULL;
    if (SecItemCopyMatching((CFDictionaryRef)keychainQuery, (CFTypeRef *)&keyData) == noErr) {
        @try {
            ret = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge NSData *)keyData];
        } @catch (NSException *e) {
            NSLog(@"Unarchive of %@ failed: %@", service, e);
        } @finally {
        }
    }
    if (keyData)
        CFRelease(keyData);
    return ret;
}

+ (void)saveSevice:(NSString *)service data:(id)data {
    //Get search dictionary
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    //Delete old item before add new item
    SecItemDelete((CFDictionaryRef)keychainQuery);
    //Add new object to search dictionary(Attention:the data format)
    [keychainQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:data] forKey:(id)kSecValueData];
    //Add item to keychain with the search dictionary
    SecItemAdd((CFDictionaryRef)keychainQuery, NULL);
}
+ (NSMutableDictionary *)getKeychainQuery:(NSString *)service {
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:
            (id)kSecClassGenericPassword,(id)kSecClass,
            service, (id)kSecAttrService,
            service, (id)kSecAttrAccount,
            (id)kSecAttrAccessibleAfterFirstUnlock,(id)kSecAttrAccessible,
            nil];
}

+(NSString *)getAppVersion{
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *appVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
    return appVersion;
}

+(void)jyVerifyPayWithParam:(NSDictionary *)param response:(JY_RESPONSE_BLOCK)response{
    
   
    AFHTTPSessionManager * _manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:k_baseUrl]];
    _manager.securityPolicy.allowInvalidCertificates = YES;
    _manager.securityPolicy.validatesDomainName = NO;
    _manager.requestSerializer.timeoutInterval = 30;
    _manager.requestSerializer = [AFHTTPRequestSerializer serializer]; // 上传普通格式
    _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSString *url = [NSString stringWithFormat:@"%@/%@",k_baseUrl,apiApplePayOrder];
    NSLog(@"验证接口：：%@--%@",url,param);
    [_manager POST:url parameters:param headers:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        //
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (responseObject) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            response(dict,nil);
        }else{
            response(nil,nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        response(nil,error);
    }];
    
    
}

+(NSDictionary *)getDicFromString:(NSString *)string{
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err = nil;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&err];
    return  dic;
}

+ (NSString *)getStringFromDict:(NSDictionary *)dict
{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&parseError];
    NSString * str = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return str;
}

+ (BOOL)isBlankString:(NSString *)string
{
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}

@end
