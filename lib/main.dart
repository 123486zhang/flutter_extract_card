import 'dart:io';
import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:data_plugin/bmob/bmob.dart';
import 'package:data_plugin/bmob/table/bmob_user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:graphic_conversion/channel/android_method_channel.dart';
import 'package:graphic_conversion/channel/ios_method_channel.dart';
import 'package:graphic_conversion/data/local_storage/storage_manager.dart';
import 'package:graphic_conversion/data/net/buried_point_api.dart';
import 'package:graphic_conversion/data/net/wx_api.dart';
import 'package:graphic_conversion/fitter/fitter.dart';
import 'package:graphic_conversion/router/router_config.dart';
import 'package:graphic_conversion/ui/helper/resoure_helper.dart';
import 'package:graphic_conversion/ui/helper/user_helper.dart';
import 'package:graphic_conversion/ui/page/camera_page.dart';
import 'package:graphic_conversion/ui/widget/custom_footer.dart';
import 'package:graphic_conversion/utils/size_fit_utils.dart';
import 'package:graphic_conversion/view_model/bmob_user_view_model.dart';
import 'package:graphic_conversion/view_model/provider/provider_manager.dart';
import 'package:graphic_conversion/ui/helper/ios_pay_helper.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'configs.dart';
import 'fitter/viewport/custom_materialapp.dart';
import 'localization.dart';
import 'locatization/localizations_delegate.dart';

main() async {
  Provider.debugCheckInvalidValueType = null;
//  debugPaintSizeEnabled = true;
  WidgetsBinding widgetsBinding =
      InnerWidgetsFlutterBinding.ensureInitialized();

  if (Platform.isAndroid) {
    await FlutterDownloader.initialize();
    AndroidMethodChannel.initHandler();
  } else {
    IOSMethodChannel.initHandler();
  }

  //强制横竖屏初始化
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Colors.transparent));

  /// 一些必备首选项的初始化
  await StorageManager.init();

  configLoading();

  _initEasyRefresh();

  WxApi.init();

  cameras = await availableCameras();

  /**
   * 超级权限非加密方式初始化
   */
  Bmob.initMasterKey("https://api2.bmob.cn", "83f9f14f6e2c720ab0eac9689259a1f4",
      "e7a436b8522e398e03a6d493c984b978", "b4c93c877cc5369778796d8647f20cd6");


  // Bmob.init("https://api2.bmob.cn", "83f9f14f6e2c720ab0eac9689259a1f4", "e7a436b8522e398e03a6d493c984b978");

  // BmobConfig.initSafe(
  //   "5678483ddf66e7f1",
  //   'JsonYe-',
  //   masterKey: "b4c93c877cc5369778796d8647f20cd6",
  // );

  //尺寸适配方案
  widgetsBinding
    ..attachRootWidget(MultiProvider(providers: providers, child: MyApp()))
    ..scheduleWarmUpFrame();
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 1000)
    ..indicatorType = EasyLoadingIndicatorType.circle
    ..maskType = EasyLoadingMaskType.custom
    ..loadingStyle = EasyLoadingStyle.custom
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.white
    ..backgroundColor = Colors.black.withOpacity(0.7)
    ..indicatorColor = Colors.white
    ..textColor = Colors.white
    ..maskColor = Colors.black.withOpacity(0)
    ..toastPosition = EasyLoadingToastPosition.center
    ..userInteractions = false;
//    ..customAnimation = CustomAnimation();
}

_initEasyRefresh() {
  EasyRefresh.defaultHeader = ClassicalHeader(
    enableHapticFeedback: false,
    enableInfiniteRefresh: false,
    refreshText: '下拉刷新',
    refreshReadyText: '松手刷新',
    refreshingText: '正在刷新..',
    refreshedText: '刷新完成',
    refreshFailedText: '刷新失败',
    noMoreText: '没有更多数据',
    showInfo: false,
    infoText: '更新于 %T',
    bgColor: Colors.transparent,
    textColor: Color(0xFF333333),
    infoColor: Colors.teal,
  );
  EasyRefresh.defaultFooter = MyClassicalFooter(
    enableHapticFeedback: false,
    enableInfiniteLoad: true,
    loadedText: '加载完成',
    loadReadyText: '松手加载',
    loadingText: '正在加载..',
    loadText: '上拉加载',
    loadFailedText: '加载失败',
    noMoreText: '已经到底了哦～',
    showInfo: false,
    infoText: '更新于 %T',
    bgColor: Colors.transparent,
    textColor: Colors.black,
    infoColor: Colors.teal,
  );
}

final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  @override
  // TODO: implement widget
  Widget build(BuildContext context) {
    rootContext = context;
    SizeFitUtils.initialize();
    return OKToast(
      backgroundColor: Color(0xB3333333),
      position: ToastPosition(
        align: Alignment.bottomCenter,
      ),
      textStyle: TextStyle(color: Colors.white, fontSize: 15),
      textPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      radius: 10,
      child: CustomMaterialApp(
        title: Configs.appName,
        localizationsDelegates: [
          //CupertinoLocalizationsDelegate(),
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          //const FallbackCupertinoLocalisationsDelegate(),
          JYLocalizationsDelegate.delegate,
        ],
        supportedLocales: [
          const Locale('zh', 'CH'),
          const Locale('en', 'US'),
        ],
        //locale: const Locale('zh'),
        theme: ThemeData(
          primaryColor: Colors.white,
          primaryColorLight: Colors.white,
          brightness: Brightness.light,
          cupertinoOverrideTheme:
              CupertinoThemeData(brightness: Brightness.light),
        ),
        onGenerateRoute: JYRouter.generateRoute,
        initialRoute: RouteName.main,
        builder: (BuildContext context, Widget child) {
          return FlutterEasyLoading(child: child);
        },
      ),
    );
  }
}

class FallbackCupertinoLocalisationsDelegate
    extends LocalizationsDelegate<CupertinoLocalizations> {
  const FallbackCupertinoLocalisationsDelegate();

  @override
  bool isSupported(Locale locale) => true;

  @override
  Future<CupertinoLocalizations> load(Locale locale) =>
      DefaultCupertinoLocalizations.load(locale);

  @override
  bool shouldReload(FallbackCupertinoLocalisationsDelegate old) => false;
}
