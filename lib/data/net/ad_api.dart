import 'package:flutter/cupertino.dart';
import 'package:flutter_universalad/flutter_universalad.dart';
import 'package:graphic_conversion/configs.dart';
import 'package:graphic_conversion/event/ad_event.dart';
import 'package:graphic_conversion/event/event_bus.dart';
import 'package:graphic_conversion/model/app_config.dart';
import 'package:graphic_conversion/ui/helper/user_helper.dart';


class AdApi {

  /// 穿山甲
  // 应用ID
  static const String pAppId_iOS = '5240678';
  static const String pAppId_android = '5240675';
  // 开屏广告ID
  static const String pSplashAdId_iOS = '887636671';
  static const String pSplashAdId_android = '887637384';

  /// 优量汇
  // 应用ID
  static const String tAppId_iOS = '1200346581';
  static const String tAppId_android = '1200346574';
  // 开屏广告ID
  static const String tSplashAdId_iOS = '1032464975508685';
  static const String tSplashAdId_android = '4022865975003733';


  //广告加载模式 UniversalLoadType.INTURN 交替拉取广告，UniversalLoadType.RANDOWM 完全随机拉去广告
  static int get loadTypeSplash {
    return hideSplashAdp==hideSplashAdt ? UniversalLoadType.INTURN : UniversalLoadType.RANDOWM;
  }
  //穿山甲出现的几率，UniversalLoadType.RANDOWM 起效，「0-1取值，0为不出现 1必出现」
  static double get probabilitySplash {
    return hideSplashAdp==hideSplashAdt ? 0.5 : hideSplashAdp?0:1;
  }

  //广告加载模式 UniversalLoadType.INTURN 交替拉取广告，UniversalLoadType.RANDOWM 完全随机拉去广告
  static int get loadTypeBanner {
    return hideBannerAdp == hideBannerAdt ? UniversalLoadType.INTURN : UniversalLoadType.RANDOWM;
  }
  //穿山甲出现的几率，UniversalLoadType.RANDOWM 起效，「0-1取值，0为不出现 1必出现」
  static double get probabilityBanner {
    return hideBannerAdp == hideBannerAdt ? 0.5 : hideBannerAdp?0:1;
  }

  //广告加载模式 UniversalLoadType.INTURN 交替拉取广告，UniversalLoadType.RANDOWM 完全随机拉去广告
  static int get loadTypeReward {
    return hideRewardAdp == hideRewardAdt ? UniversalLoadType.INTURN : UniversalLoadType.RANDOWM;
  }
  //穿山甲出现的几率，UniversalLoadType.RANDOWM 起效，「0-1取值，0为不出现 1必出现」
  static double get probabilityReward {
    return hideRewardAdp == hideRewardAdt ? 0.5 : hideRewardAdp?0:1;
  }

  //广告初始状态，默认未初始化或初始化失败false，初始化成功true
  static bool pResult = false;  //穿山甲
  static bool tResult = false;  //优量汇

  static bool hideSplashAdp = true;  //隐藏穿山甲开屏广告
  static bool hideBannerAdp = true;  //隐藏穿山甲横幅广告
  static bool hideRewardAdp = true;  //隐藏穿山甲激励广告

  static bool hideSplashAdt = true;  //隐藏优量汇开屏广告
  static bool hideBannerAdt = true;  //隐藏优量汇横幅广告
  static bool hideRewardAdt = true;  //隐藏优量汇激励广告

  static bool hideSplashAdShowing = false;  //App隐藏开屏广告
  static bool hideBannerAdShowing = false;  //App隐藏横幅广告
  static bool hideRewardAdShowing = false;  //App隐藏激励广告

  static bool get hideSplashAd {
    return hideSplashAdp&&hideSplashAdt;//||(!StorageManager.pResult&&!StorageManager.tResult);
  }  //隐藏开屏广告
  static bool get hideBannerAd {
    return hideBannerAdShowing||(hideBannerAdp&&hideBannerAdt);//||(!StorageManager.pResult&&!StorageManager.tResult);
  }  //隐藏横幅广告
  static bool get hideRewardAd {
    return hideRewardAdShowing||(hideRewardAdp&&hideRewardAdt);//||(!StorageManager.pResult&&!StorageManager.tResult);
  } //隐藏激励广告

  static init() async {
    await FlutterUniversalad.register(
      //穿山甲android id
      pAndroidId: pAppId_android,
      //穿山甲ios id
      pIosId: pAppId_iOS,
      //优量汇android id
      tAndroidId: tAppId_android,
      //优量汇ios id
      tIosId: tAppId_iOS,
      //app名字
      appName: Configs.appName,
      //是否显示日志
      debug: true,
      callBack: RegisterCallBack(pangolinInit: (result) {
        debugPrint("穿山甲初始化 $result");
        pResult = true;
        // eventBus.fire(AdEvent(AdEvent.AD_PangolinInit));
        eventBus.fire(AdEvent(AdEvent.AD_ShowStatusUpdated));
      }, tencentInit: (result) {
        debugPrint("优量汇初始化 $result");
        tResult = true;
        // eventBus.fire(AdEvent(AdEvent.AD_TencentInit));
        eventBus.fire(AdEvent(AdEvent.AD_ShowStatusUpdated));
      }),
    );
  }

  static Widget splashAdView({
    UOnShow onShow,
    UOnFail onFail,
    UOnClose onClose,
    UOnClick onClick,
  }) {
    return FlutterUniversalad.splashAdView(
        //穿山甲广告android id
        pAndroidId: pSplashAdId_android,
        //穿山甲广告ios id
        pIosId: pSplashAdId_iOS,
        //优量汇广告android id
        tAndroidId: tSplashAdId_android,
        //优量汇广告ios id
        tIosId: tSplashAdId_iOS,
        //广告加载模式 UniversalLoadType.INTURN 交替拉取广告，UniversalLoadType.RANDOWM 完全随机拉去广告
        loadType: loadTypeSplash,
        //穿山甲出现的几率，UniversalLoadType.RANDOWM 起效，「0-1取值，0为不出现 1必出现」
        probability: probabilitySplash,
        callBack: USplashCallBack(
        onShow: (sdkType) {
          debugPrint("$sdkType  开屏广告显示");
          if (onShow != null) onShow(sdkType);
        },
        onFail: (sdkType, code, message) {
          debugPrint("$sdkType  开屏广告失败  $code $message");
          // Navigator.pop(context);
          if (onFail != null) onFail(sdkType, code, message);
        },
        onClick: (sdkType) {
          debugPrint("$sdkType  开屏广告点击");
          if (onClick != null) onClick(sdkType);
        },
        onClose: (sdkType) {
          debugPrint("$sdkType  开屏广告关闭");
          // Navigator.pop(context);
          if (onClose != null) onClose(sdkType);
        },
      )
    );
  }

  static void updateShowAd() {
    hideSplashAdp = false;  //隐藏穿山甲开屏广告
    hideBannerAdp = false;  //隐藏穿山甲横幅广告
    hideRewardAdp = false;  //隐藏穿山甲激励广告

    hideSplashAdt = false;  //隐藏优量汇开屏广告
    hideBannerAdt = false;  //隐藏优量汇横幅广告
    hideRewardAdt = false;  //隐藏优量汇激励广告

    AppConfig appConfig = UserHelper().appConfig;
    if(appConfig.bhinfo!=null&&appConfig.bhinfo.length>0){
      for(int i=0;i<appConfig.bhinfo.length;i++){
        int btype = appConfig.bhinfo[i]["btype"];
        int state = appConfig.bhinfo[i]["state"];
        switch(btype){
          case 10014:{
            if(state==1){
              hideSplashAdp = true;
            }
            break;
          }
          case 10015:{
            if(state==1){
              hideBannerAdp = true;
            }
            break;
          }
          case 10016:{
            if(state==1){
              hideRewardAdp = true;
            }
            break;
          }
          case 10017:{
            if(state==1){
              hideSplashAdt = true;
            }
            break;
          }
          case 10018:{
            if(state==1){
              hideBannerAdt = true;
            }
            break;
          }
          case 10019:{
            if(state==1){
              hideRewardAdt = true;
            }
            break;
          }
        }
      }
    }
    eventBus.fire(AdEvent(AdEvent.AD_ShowStatusUpdated));
  }
}