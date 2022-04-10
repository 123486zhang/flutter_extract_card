//
//  FlutterNativePlugin.m
//  Runner
//
//

#import "FlutterNativePlugin.h"
#import <UIKit/UIKit.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import "JYSystemTool.h"
#import "Runner-Swift.h"
#import "JYUIUtils.h"
#import "Udesk.h"
#import <CommonCrypto/CommonDigest.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>
#import <Photos/PHPhotoLibrary.h>
#import <UMCommon/UMCommon.h>
#import <UMCommon/MobClick.h>

@interface FlutterNativePlugin()

@property (nonatomic,strong)FlutterResult result;

@end

@implementation FlutterNativePlugin

+ (instancetype)defaultPlugin
{
    static FlutterNativePlugin *_instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}


+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar {
    FlutterMethodChannel *channel = [FlutterMethodChannel methodChannelWithName:@"flutter_IOSMethod" binaryMessenger:[registrar messenger]];
    FlutterNativePlugin *instance = [FlutterNativePlugin defaultPlugin];
    instance.channel = channel;
    [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall *)call result:(FlutterResult)result {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(paySuccess) name:@"PaySuccess" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(payEerror) name:@"PayError" object:nil];
    
    
    if ([call.method isEqualToString:@"comeonman"]) {
        result([self isCanOpenWeinXin] ? @"1" : @"0");
    } else if ([call.method isEqualToString:@"getAppname"]) {
        NSString *appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
        result(appName);
    } else if ([call.method isEqualToString:@"onPageStart"]) {
        [MobClick beginLogPageView:call.arguments[@"pageName"]];
        NSLog(@"打开了界面%@",call.arguments[@"pageName"]);
    } else if ([call.method isEqualToString:@"onPageEnd"]) {
        [MobClick beginLogPageView:call.arguments[@"pageName"]];
        NSLog(@"关闭了界面%@",call.arguments[@"pageName"]);
    } else if ([call.method isEqualToString:@"onEvent"]) {
        NSLog(@"点击了事件%@",call.arguments[@"eventId"]);
        [MobClick event:call.arguments[@"eventId"]];
    } else if ([call.method isEqualToString:@"onEventValue"]) {
        NSLog(@"点击了事件%@-参数%@",call.arguments[@"eventId"],call.arguments[@"value"]);
        [MobClick event:call.arguments[@"eventId"] attributes:@{@"value":call.arguments[@"value"]}];
    } else if ([call.method isEqualToString:@"onHUDShowError"]) {
        [SVProgressHUD showErrorWithStatus:call.arguments[@"text"]];
    } else if ([call.method isEqualToString:@"onHUDShowText"]) {
        [SVProgressHUD showWithStatus:call.arguments[@"text"]];
    } else if ([call.method isEqualToString:@"onHUDShowSuccess"]) {
        [SVProgressHUD showSuccessWithStatus:call.arguments[@"text"]];
    } else if ([call.method isEqualToString:@"onHUDDismiss"]) {
        [SVProgressHUD dismiss];
    } else if ([call.method isEqualToString:@"getUuid"]) {
        result([JYSystemTool getUUID]);
    } else if ([call.method isEqualToString:@"getPayInfo"]) {
        NSLog(@"获取凭证");
        NSURL *receiptURL = [[NSBundle mainBundle] appStoreReceiptURL];
        NSData *receiptData = [NSData dataWithContentsOfURL:receiptURL];
        if (receiptData) {
            NSString *encodeStr = [receiptData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
            result(encodeStr);
        } else {
            result(@"");
        }
        
    } else if ([call.method isEqualToString:@"CansaveImage"]) {        
        NSString *mediaType = AVMediaTypeVideo;//读取媒体类型
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];//读取设备授权状态
        NSLog(@"states::%ld",authStatus);
        if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
            result(@"false");
        }else{
            result(@"true");
        }
        
    } else if ([call.method isEqualToString:@"connetUs"]) {
        NSLog(@"联系客服");
        NSString *token = call.arguments[@"token"];
        NSString *phone = call.arguments[@"phone"];
        NSString *nickName = call.arguments[@"nickName"];
        NSString *version = call.arguments[@"version"];
        UIViewController *flutterVC = [JYUIUtils getVisibleViewController];
        NSLog(@"vc = %@=====%@-%@-%@-%@",[[JYUIUtils getVisibleViewController] class],token,phone,nickName,version);
        UdeskOrganization *organization = [[UdeskOrganization alloc] initWithDomain:@"hnjiyw.udesk.cn" appKey:@"03c1aeac9349b0521b915d1e6577e164" appId:@"24a84b34fd59f509"];
        UdeskCustomer *customer = [UdeskCustomer new];
        //必填（请不要使用特殊字符）
        customer.sdkToken = token.length < 1 ? [JYSystemTool getUUID] : token;
        customer.customerDescription = [NSString stringWithFormat:@"扫图识字iOS%@",[JYSystemTool getAppVersion]];
        customer.customerToken = [JYSystemTool getUUID];
        customer.nickName = nickName;
        [UdeskManager initWithOrganization:organization customer:customer];
        [UdeskManager updateCustomer:customer completion:nil];
        
        UdeskSDKStyle *style = [UdeskSDKStyle defaultStyle];
        
        UdeskSDKActionConfig *actionConfig = [[UdeskSDKActionConfig alloc] init];
        actionConfig.leaveUdeskSDKBlock = ^{
            [self dismissEasyLoading];
//            [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
        };
        
        UdeskSDKConfig *config = [UdeskSDKConfig customConfig];
        config.faqTitle = @"客服中心";
        config.imTitle = @"客服中心";
        
        UdeskSDKManager *sdkManager = [[UdeskSDKManager alloc] initWithSDKStyle:style sdkConfig:config sdkActionConfig:actionConfig];
        [sdkManager pushUdeskInViewController:flutterVC completion:^{
            [self showEasyLoading];
//            [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
        }];
        
    } else if ([call.method isEqualToString:@"clearUserInfo"]) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"JYUserInfoString"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else if ([call.method isEqualToString:@"putUserInfo"]) {
        NSLog(@"putUserInfo = %@", call.arguments);
        [[NSUserDefaults standardUserDefaults] setValue:[JYSystemTool getStringFromDict:call.arguments] forKey:@"JYUserInfoString"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
        result(FlutterMethodNotImplemented);
       
    }
}

+ (NSString*)dictionaryToJson:(NSDictionary *)dic {
 
    NSError *parseError = nil;

    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];

    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];

}


- (void)paySuccess {
    NSLog(@"收到支付成功的回调");
    self.result(@"1");
}

- (void)payEerror {
    NSLog(@"收到支付失败的回调");
    self.result(@"0");
}



- (BOOL)isCanOpenWeinXin {
    return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://"]];
}

+ (NSString *)contentTypeWithImageData:(NSData *)data {
    
    uint8_t c;
    
    [data getBytes:&c length:1];
    
    switch (c) {
        case 0xFF:
            return @"jpeg";
        case 0x89:
            return @"png";
        case 0x47:
            return @"gif";
        case 0x49:
        case 0x4D:
            return @"tiff";
        case 0x52:
            if ([data length] < 12) {
                return nil;
            }
            NSString *testString = [[NSString alloc] initWithData:[data subdataWithRange:NSMakeRange(0, 12)] encoding:NSASCIIStringEncoding];
            if ([testString hasPrefix:@"RIFF"] && [testString hasSuffix:@"WEBP"]) {
                return @"webp";
            }
            return nil;
    }
    return nil;
}

+ (NSString *)getMd5_32Bit_String:(NSString *)srcString{
    const char *cStr = [srcString UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, strlen(cStr), digest );
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [result appendFormat:@"%02x", digest[i]];
    
    return result;
}

- (void)payRealName
{
    [self.channel invokeMethod:@"payRealName" arguments:@""];
}

- (void)showEasyLoading
{
    [self.channel invokeMethod:@"showEasyLoading" arguments:@""];
}

- (void)dismissEasyLoading
{
    [self.channel invokeMethod:@"dismissEasyLoading" arguments:@""];
}

@end
