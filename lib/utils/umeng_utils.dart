import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:graphic_conversion/channel/android_method_channel.dart';
import 'package:graphic_conversion/channel/ios_method_channel.dart';

class UmengUtils {
  static onPageStart(String pageName) {
    if (Platform.isAndroid) {
      AndroidMethodChannel.onPageStart(pageName);
    } else {
      IOSMethodChannel.onPageStart(pageName);
    }
  }

  static onPageEnd(String pageName) {
    if (Platform.isAndroid) {
      AndroidMethodChannel.onPageEnd(pageName);
    } else {
      IOSMethodChannel.onPageEnd(pageName);
    }
  }

  static onEvent(String eventId) {
    debugPrint('上报友盟统计:${eventId}');
    if (Platform.isAndroid) {
      AndroidMethodChannel.onEvent(eventId);
    } else {
      IOSMethodChannel.onEvent(eventId);
    }
  }

  static onEventValue(String eventId, String value) {
    eventId = chineseConvertEnglish(eventId);
    if (Platform.isAndroid) {
      AndroidMethodChannel.onEventValue(eventId, value);
    } else {
      IOSMethodChannel.onEventValue(eventId, value);
    }
  }

  static String chineseConvertEnglish(String name) {
    String event = "";
    switch (name) {
      case "首页":
        event = "home_page";
        break;
      case "我的页面":
        event = "mine_page";
        break;
      case "识别页面":
        event = "identify_page";
        break;
      case "提醒页面":
        event = "remind_page";
        break;
      case "编辑文本页面":
        event = "edit_text_page";
        break;
      case "安卓-我的页面-登录":
        event = "android_login_page";
        break;
      case "苹果-我的页面-登录":
        event = "apple_login_page";
        break;
      case "安卓-我的页面-会员中心-开通会员":
        event = "android_vip_page";
        break;
      case "苹果-我的页面-会员中心-开通会员":
        event = "apple_vip_page";
        break;
      case "G码页面":
        event = "g_page";
        break;
      case "拍摄页":
        event = "shooting_page";
        break;
      case "单张预览页":
        event = "leaflet_preview_page";
        break;
      case "多张预览页":
        event = "multiple_preview_page";
        break;
    }
    return event;
  }
}
