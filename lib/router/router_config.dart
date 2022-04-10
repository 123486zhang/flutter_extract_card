import 'dart:io';

import 'package:graphic_conversion/ui/page/add_g_page.dart';
import 'package:graphic_conversion/ui/page/back_select_page.dart';
import 'package:graphic_conversion/ui/page/camera_page.dart';
import 'package:graphic_conversion/ui/page/conversion_multi_page.dart';
import 'package:graphic_conversion/ui/page/conversion_page.dart';
import 'package:graphic_conversion/ui/page/cutting_page.dart';
import 'package:graphic_conversion/ui/page/document_page.dart';
import 'package:graphic_conversion/ui/page/extract_pets_page.dart';
import 'package:graphic_conversion/ui/page/find_password_page.dart';
import 'package:graphic_conversion/ui/page/g_page.dart';
import 'package:graphic_conversion/ui/page/head_select_page.dart';
import 'package:graphic_conversion/ui/page/report_info_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graphic_conversion/ui/page/about_us_page.dart';
import 'package:graphic_conversion/ui/page/login_apple_page.dart';
import 'package:graphic_conversion/ui/page/login_page.dart';
import 'package:graphic_conversion/ui/page/login_phone_page.dart';
import 'package:graphic_conversion/ui/page/register_page.dart';
import 'package:graphic_conversion/ui/page/bind_phone_page.dart';
import 'package:graphic_conversion/ui/page/change_phone_page.dart';
import 'package:graphic_conversion/ui/page/main_page.dart';
import 'package:graphic_conversion/ui/page/setting_page.dart';
import 'package:graphic_conversion/ui/page/share_page.dart';
import 'package:graphic_conversion/ui/page/telephone_page.dart';
import 'package:graphic_conversion/ui/page/splash_page.dart';
import 'package:graphic_conversion/ui/page/update_password_page.dart';
import 'package:graphic_conversion/ui/page/vip_android_page.dart';
import 'package:graphic_conversion/ui/page/update_card_page.dart';
import 'package:graphic_conversion/ui/page/vip_apple_page.dart';
import 'package:graphic_conversion/ui/page/webview_page.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';

import '../ui/page/vip_android_page.dart';

///页面跳转路由
class RouteName {
  static const String splash = 'splash';
  static const String main = 'main';
  static const String login = 'login';
  static const String setting = 'setting';
  static const String webview = 'webview';
  static const String aboutus = 'aboutus';
  static const String share_page = 'share_page';
  static const String login_phone_page = 'login_phone_page';
  static const String register_page = 'register_page';
  static const String bind_phone_page = 'bind_phone_page';
  static const String change_phone_page = 'change_phone_page';
  static const String login_apple_page = 'login_apple_page';
  static const String report_info_page = 'report_info_page';
  static const String vip_apple_page = 'vip_apple_page';
  static const String vip_android_page = 'vip_android_page';
  static const String conversion_page = 'conversion_page';
  static const String document_page = 'document_page';
  static const String g_page = 'g_page';
  static const String add_g_page = 'add_g_page';
  static const String camera_page = 'camera_page';
  static const String conversion_multi_page = 'conversion_multi_page';
  static const String cutting_page = 'cutting_page';
  static const String telephone_page = 'telephone_page';
  static const String head_select_page = 'head_select_page';
  static const String back_select_page = 'back_select_page';
  static const String update_card_page = 'update_card_page';
  static const String find_password_page = 'find_password_page';
  static const String update_password_page = 'update_password_page';
  static const String extract_pets_page = 'extract_pets_page';
}

class JYRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteName.splash:
        return NoAnimRouteBuilder(SplashPage(), settings: settings);
      case RouteName.main:
        return NoAnimRouteBuilder(MainPage(), settings: settings);
      case RouteName.setting:
        return SwipeablePageRoute(
            builder: (_) => SettingPage(), settings: settings);
      case RouteName.webview:
        var arguments = settings.arguments as Map;
        return NoAnimRouteBuilder(WebViewPage(
          title: arguments['title'],
          url: arguments['url'],
        ));
      case RouteName.aboutus:
        return SwipeablePageRoute(
            builder: (_) => AboutUsPage(), settings: settings);
      case RouteName.share_page:
        return SwipeablePageRoute(
            builder: (_) => SharePage(), settings: settings);
      case RouteName.login:
        return SwipeablePageRoute(
            builder: (_) => LoginPhonePage(), settings: settings);
      case RouteName.login_phone_page:
        return SwipeablePageRoute(
            builder: (_) => LoginPhonePage(), settings: settings);
      case RouteName.register_page:
        return SwipeablePageRoute(
            builder: (_) => RegisterPage(), settings: settings);
      case RouteName.extract_pets_page:
        return SwipeablePageRoute(
            builder: (_) => ExtractPetsPage(), settings: settings);
      case RouteName.bind_phone_page:
        return SwipeablePageRoute(
            builder: (_) => BindPhonePage(), settings: settings);
      case RouteName.change_phone_page:
        return SwipeablePageRoute(
            builder: (_) => ChangePhonePage(), settings: settings);
      case RouteName.login_apple_page:
        return SwipeablePageRoute(
            builder: (_) => LoginApplePage(), settings: settings);
      case RouteName.report_info_page:
        return SwipeablePageRoute(
            builder: (_) => ReportInfoPage(), settings: settings);
      case RouteName.vip_apple_page:
        var arguments = settings.arguments as Map;
        return SwipeablePageRoute(
            builder: (_) => VipApplePage(
                  from: arguments['from'],
                ),
            settings: settings);
      case RouteName.head_select_page:
        return SwipeablePageRoute(
            builder: (_) => HeadSelectPage(), settings: settings);
      case RouteName.back_select_page:
        return SwipeablePageRoute(
            builder: (_) => BackSelectPage(), settings: settings);
      case RouteName.update_card_page:
        return SwipeablePageRoute(
            builder: (_) => UpdateCardPage(), settings: settings);
      case RouteName.vip_android_page:
        var arguments = settings.arguments as Map;
        return NoAnimRouteBuilder(VipAndroidPage(
          from: arguments['from'],
        ));

      ///
      case RouteName.find_password_page:
        var arguments = settings.arguments as Map;
        return NoAnimRouteBuilder(FindPasswordPage(
          username: arguments['username'],
        ));

      ///
      case RouteName.update_password_page:
        var arguments = settings.arguments as Map;
        return NoAnimRouteBuilder(UpdatePasswordPage(
          username: arguments['username'],
        ));

      ///
      case RouteName.conversion_page:
        var arguments = settings.arguments as Map;
        return SwipeablePageRoute(
            builder: (_) => ConversionPage(
                  imagePath: arguments["imagePath"],
                  index: arguments["index"],
                  callback: arguments["callback"],
                ),
            settings: settings);
      case RouteName.conversion_multi_page:
        var arguments = settings.arguments as Map;
        return NoAnimRouteBuilder(
            ConversionMultiPage(
              photos: arguments["photos"],
              translateTelephoneEnabledType:
                  arguments["translateTelephoneEnabledType"],
            ),
            settings: settings);
      case RouteName.telephone_page:
        var arguments = settings.arguments as Map;
        return SwipeablePageRoute(
            builder: (_) => TelephonePage(
                  model: arguments["model"],
                  index: arguments["index"],
                ),
            settings: settings);

      case RouteName.document_page:
        var arguments = settings.arguments as Map;
        return NoAnimRouteBuilder(
            DocumentPage(
              model: arguments["model"],
              index: arguments["index"],
              translateTelephoneEnabledType:
                  arguments["translateTelephoneEnabledType"],
            ),
            settings: settings);
      case RouteName.g_page:
        return SwipeablePageRoute(builder: (_) => GPage(), settings: settings);
      case RouteName.add_g_page:
        return SwipeablePageRoute(
            builder: (_) => AddGPage(), settings: settings);
      case RouteName.camera_page:
        var arguments = settings.arguments as Map;
        return NoAnimRouteBuilder(
            CameraPage(
              singlePhoto: arguments == null ? false : arguments["singlePhoto"],
              photoCallback:
                  arguments == null ? null : arguments["photoCallback"],
              index: arguments == null ? null : arguments["index"],
              translateTelephoneEnabledType:
                  arguments["translateTelephoneEnabledType"],
            ),
            settings: settings);
      case RouteName.cutting_page:
        var arguments = settings.arguments as Map;
        return NoAnimRouteBuilder(
            CuttingPage(
              photoPath: arguments["photoPath"],
              callback: arguments["callback"],
            ),
            settings: settings);
      default:
        return NoAnimRouteBuilder(Scaffold(
          body: Center(
            child: Text('No route defined for ${settings.name}'),
          ),
        ));
    }
  }
}

class NoAnimRouteBuilder extends PageRouteBuilder {
  final Widget page;

  NoAnimRouteBuilder(this.page, {RouteSettings settings})
      : super(
            opaque: false,
            settings: settings,
            pageBuilder: (context, animation, secondaryAnimation) => page,
            transitionDuration: Duration(milliseconds: 0),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) => child);
}

class FadeRoute extends PageRouteBuilder {
  final Widget page;

  FadeRoute({this.page})
      : super(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              page,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
}
