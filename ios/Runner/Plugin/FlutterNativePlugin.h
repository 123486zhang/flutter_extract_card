//
//  FlutterNativePlugin.h
//  Runner
//
//
#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>

NS_ASSUME_NONNULL_BEGIN

@interface FlutterNativePlugin : NSObject <FlutterPlugin>

@property (nonatomic,strong)FlutterMethodChannel *channel;

+ (instancetype)defaultPlugin;

- (void)payRealName;

@end

NS_ASSUME_NONNULL_END
