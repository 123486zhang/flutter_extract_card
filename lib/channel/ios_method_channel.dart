
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:graphic_conversion/ui/helper/user_helper.dart';

import '../configs.dart';

class IOSMethodChannel {
  static const iosMethodChannel = const MethodChannel('flutter_IOSMethod');

  static Future<String> getChannelId() async {
    try {
      final String result = await iosMethodChannel.invokeMethod('getChannelId');
      debugPrint('getChannelId->' + result);
      return result;
    } catch (e) {
      debugPrint(e);
      return '';
    }
  }

  static onPageStart(String pageName) {
    try {
      iosMethodChannel.invokeMethod('onPageStart', {'pageName': pageName});
    } catch (e) {
      debugPrint(e);
    }
  }

  static onPageEnd(String pageName) {
    try {
      iosMethodChannel.invokeMethod('onPageEnd', {'pageName': pageName});
    } catch (e) {
      debugPrint(e);
    }
  }

  static onEvent(String eventId) {
    try {
      iosMethodChannel.invokeMethod('onEvent', {'eventId': eventId});
    } catch (e) {
      debugPrint(e);
    }
  }

  static onEventValue(String eventId, String value) {
    try {
      iosMethodChannel
          .invokeMethod('onEventValue', {'eventId': eventId, 'value': value});
    } catch (e) {
      debugPrint(e);
    }
  }

  static Future<String> getUUid() async {
    try {
      final String result = await iosMethodChannel.invokeMethod('getUuid');
      debugPrint('getChannelId->' + result);
      return result;
    } catch (e) {
      debugPrint(e);
      return '';
    }
  }

  static Future<bool> canOpenWX() async {
    try {
      final String result = await iosMethodChannel.invokeMethod('canOpenWX');
      UserHelper().iOSCanOpenWX = result == "1";
      return result == "1";
    } catch (e) {
      return false;
    }
  }

  static Future<String> getPayInfo() async {
    try {
      final String result = await iosMethodChannel.invokeMethod('getPayInfo');
      debugPrint('获取到了凭证->' + result);
      return result;
    } catch (e) {
      debugPrint('获取凭证失败：error${e.toString()}');
      return '';
    }
  }

  static connetUs({String token, String phone, String nickName, String version}) {
    try {
      // var token = "";
      // var phone = "";
      // var nickName = "";
      // var version = '${Configs.PRODUCT_ID}';
      // if (UserHelper().usermodel.hasUser) {
      //   token = StringUtils.getStringValue(UserHelper().usermodel.user.uid);
      //   phone = StringUtils.getStringValue(UserHelper().usermodel.user.moblie);
      //   nickName =
      //       StringUtils.getStringValue(UserHelper().usermodel.user.nickname);
      // }
      iosMethodChannel.invokeMethod('connetUs', {
        "token": token,
        "phone": phone,
        "nickName": nickName,
        "version": version
      });
    } catch (e) {
      debugPrint(e);
    }
  }

  static initHandler() {
    iosMethodChannel.setMethodCallHandler((MethodCall call) async {
      debugPrint(
          'flutter  handlerMethod   method=${call.method}   arguments-->${call
              .arguments}');

      switch (call.method) {
        case "showEasyLoading":
          EasyLoading.show();
          break;
        case "dismissEasyLoading":
          EasyLoading.dismiss();
          break;
      }
    });
  }

}
