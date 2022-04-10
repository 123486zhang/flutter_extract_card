import 'dart:async';
import 'dart:typed_data';

import 'package:graphic_conversion/data/net/fizz_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

///与安卓原生交互通道
class AndroidMethodChannel {
  static const methodChannel = const MethodChannel('plugin/my_method');

  static initHandler() {
    methodChannel.setMethodCallHandler(handlerMethod);
  }

  ///接收原生过来的方法
  static Future<dynamic> handlerMethod(MethodCall call) async {
    debugPrint(
        'flutter  handlerMethod   method=${call.method}   arguments-->${call.arguments}');
  }

  static Future<String> getChannelId() async {
    try {
      final String result = await methodChannel.invokeMethod('getChannelId');
      debugPrint('getChannelId->' + result);
      return result;
    } catch (e) {
      debugPrint(e.toString());
      return '';
    }
  }

  static Future<String> getAndroidId() async {
    try {
      final String result = await methodChannel.invokeMethod('getAndroidId');
      debugPrint('getAndroidId->' + result);
      return result;
    } catch (e) {
      debugPrint(e.toString());
      return '';
    }
  }

  static onPageStart(String pageName) {
    try {
      methodChannel.invokeMethod('onPageStart', {'pageName': pageName});
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  static onPageEnd(String pageName) {
    try {
      methodChannel.invokeMethod('onPageEnd', {'pageName': pageName});
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  static onEvent(String eventId) {
    try {
      methodChannel.invokeMethod('onEvent', {'eventId': eventId});
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  static onEventValue(String eventId, String value) {
    try {
      methodChannel
          .invokeMethod('onEventValue', {'eventId': eventId, 'value': value});
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  static Future<bool> pay({
    int payType,
    int stype,
    String userId,
    String md5,
    String orderAdvance,
    String code = "fizz",
    String operate = FIZZApi.JY_AndroidPay,
  }) async {
    try {
      bool has = await methodChannel.invokeMethod('pay', {
        'payType': payType,
        'stype': stype,
        'userId': userId,
        'md5': md5,
        'orderAdvance': orderAdvance,
        'code': code,
        'operate': operate,
      });

      return has;
    } catch (e) {
      debugPrint(e.toString());
    }
    return false;
  }


  static tranInto(int functionType) {
    try {
      methodChannel.invokeMethod('tranInto', {'functionType': functionType});
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  static Future<List<int>> getFunctionType(int type) async {
    try {
      List<int> list = await methodChannel
          .invokeListMethod('getFunctionType', {'type': type});
      debugPrint("JuanTop->$list");
      return list;
    } catch (e) {
      debugPrint("JuanTop->$e");
      return List();
    }
  }

  static realName() {
    try {
      methodChannel.invokeMethod('realName');
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  static startKf() {
    try {
      methodChannel.invokeMethod('startKf');
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  static shareText(int type, String text) {
    try {
      methodChannel.invokeMethod('shareText', {'text': text, 'type': type});
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  static shareShop(String id, String detail, String imgUrl) {
    if (imgUrl == null || imgUrl.isEmpty) {
      imgUrl = "http://wsv1.laotouge.cn/Images/Logo/ic_launcher.png";
    }
    try {
      methodChannel.invokeMethod(
          'shareShop', {'id': id, 'detail': detail, 'imgUrl': imgUrl});
    } catch (e) {
      debugPrint(e.toString());
    }
  }


  static shareGoods([String title, String desc, String imgUrl, String link]) {
    try {
      methodChannel.invokeMethod('shareGoods',
          {'title': title, 'desc': desc, 'imgUrl': imgUrl, 'link': link});
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  static openSmallProgram() async {
    try {
      debugPrint('openSmallProgram');
      await methodChannel.invokeMethod('openSmallProgram');
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  ///成功返回图片存储路径
  static Future<String> saveImage(String imgUrl) async {
    try {
      String result =
          await methodChannel.invokeMethod('saveImage', {'imgUrl': imgUrl});
      return result;
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  ///成功返回图片存储目录
  static Future<String> downloadImages(String images) async {
    try {
      String result = await methodChannel
          .invokeMethod('downloadImages', {'images': images});
      return result;
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  ///跳转到微信
  static jumpTpWX() async {
    try {
      methodChannel.invokeMethod('jumpTpWX');
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  static Future<int> getPluginVersion() async {
    try {
      int version = await methodChannel.invokeMethod('getPluginVersion');
      return version;
    } catch (e) {
      debugPrint(e.toString());
    }
    return 0;
  }

  //检测环境
  static Future<bool> checkEnvironment() async {
    try {
      bool result = await methodChannel.invokeMethod('checkEnvironment');
      return result;
    } catch (e) {
      debugPrint(e.toString());
    }
    return false;
  }

  //转发到朋友圈
  static Future<bool> forwardImages(String images, String text) async {
    try {
      bool result = await methodChannel
          .invokeMethod('forwardImages', {"images": images, "text": text});
      return result;
    } catch (e) {
      debugPrint(e.toString());
    }
    return false;
  }

  //添加单个好友
  static addSingleFan({String wechatNo, String msg}) async {
    try {
      debugPrint('wechatNo-$wechatNo');
      debugPrint('msg-$msg');
      methodChannel
          .invokeMethod('addSingleFan', {"wechatNo": wechatNo, "msg": msg});
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  //添加单个好友
  static Future<bool> addSingleFanByQr(String qrUrl) async {
    try {
      debugPrint('qrUrl-$qrUrl');
      return await methodChannel
          .invokeMethod('addSingleFanByQr', {"qrUrl": qrUrl});
    } catch (e) {
      debugPrint(e.toString());
    }
    return false;
  }

  //添加多个好友
  static addMoreFan(List<String> list) async {
    try {
      debugPrint('addMoreFan-${list.length}');
      methodChannel.invokeMethod('addMoreFan', {"fansList": list});
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  //二维码识别
  static Future<String> recogQRcode(Uint8List uint8list) async {
    try {
      return await methodChannel
          .invokeMethod('recogQRcode', {"bytes": uint8list});
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  //判断是否安装某app
  static Future<bool> isExistApp(String pkname) async {
    try {
      return await methodChannel.invokeMethod('isExistApp', {"pkname": pkname});
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  //打开某app
  static openExistApp(String pkname) async {
    try {
      methodChannel.invokeMethod('openExistApp', {"pkname": pkname});
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  static hideKeyboard() async {
    try {
      methodChannel.invokeMethod('hideKeyboard');
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  //用户同意协议,通知原生初始化
  static onAgreementPass() async {
    try {
      methodChannel.invokeMethod('onAgreementPass');
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  static saveUserFlag(int flag) async {
    try {
      methodChannel.invokeMethod('saveUserFlag', {"flag": flag});
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  static startH5Activity(String title, String url) {
    try {
      methodChannel
          .invokeMethod('startH5Activity', {"title": title, "url": url});
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  static startPrivacyActivity(String title, String url) {
    try {
      methodChannel
          .invokeMethod('startPrivacyActivity', {"title": title, "url": url});
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  static uploadLog() {
    try {
      methodChannel.invokeMethod('uploadLog');
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  static Future<bool> handlePermission(String permission) async {
    try {
      final bool result = await methodChannel
          .invokeMethod('handlePermission', {"permission": permission});
      return result;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }


  //type 1微信好友 2朋友圈
  static shareImage(Uint8List uint8list,int type) async {
    try {
      methodChannel.invokeMethod('shareImage', {"bytes": uint8list,"type":type});
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  static Future<bool> checkPermission(String permission) async {
    try {
      bool has = await methodChannel
          .invokeMethod('checkPermission', {'permission': permission});
      return has;
    } catch (e) {
      debugPrint(e.toString());
    }
    return false;
  }

  static Future<bool> requestPermission(String permission) async {
    try {
      bool has = await methodChannel
          .invokeMethod('requestPermission', {'permission': permission});
      return has;
    } catch (e) {
      debugPrint(e.toString());
    }
    return false;
  }

  static goPermissionSetting() {
    try {
      methodChannel.invokeMethod('goPermissionSetting');
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
