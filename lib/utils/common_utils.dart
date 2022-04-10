import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:ui';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:graphic_conversion/locatization/localizations.dart';
import 'package:graphic_conversion/ui/helper/dialog_helper.dart';
import 'package:graphic_conversion/ui/manager/cache_audio_manager.dart';
import 'package:graphic_conversion/view_model/bmob_user_view_model.dart';
import 'package:graphic_conversion/view_model/provider/provider_manager.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:launch_review/launch_review.dart';

import 'package:oktoast/oktoast.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';
import 'package:graphic_conversion/channel/android_method_channel.dart';
import 'package:graphic_conversion/router/router_config.dart';
import 'package:graphic_conversion/view_model/user_view_model.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

import '../configs.dart';

class CommonUtils {
  static openMarket() async {

    LaunchReview.launch(iOSAppId: Configs.iOS_App_ID, writeReview: false);

    // PackageInfo packageInfo = await PackageInfo.fromPlatform();
    //
    // LaunchReview.launch(
    //     androidAppId: packageInfo.packageName, iOSAppId: Configs.iOS_App_ID);

   // if (Platform.isIOS) {
   //   String url = 'http://itunes.apple.com/cn/app/id{$Configs.iOS_App_ID}?mt=8';
   //   launch(url);
   //
   // } else if (Platform.isAndroid) {
   //   PackageInfo packageInfo = await PackageInfo.fromPlatform();
   //
   //   String url = 'market://details?id=${packageInfo.packageName}';
   //
   //   launch(url);
   // }
  }

  ///是否有网络连接
  static Future<bool> isNetConnected() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    return connectivityResult != ConnectivityResult.none;
  }

  static int _lastClickTime = 0;

  static bool isFastClick() {
    if (DateTime.now().millisecondsSinceEpoch - _lastClickTime < 1500) {
      return true;
    }

    _lastClickTime = DateTime.now().millisecondsSinceEpoch;
    return false;
  }

  static int _lastClickTime3 = 0;

  static bool isFastClick3() {
    if (DateTime.now().millisecondsSinceEpoch - _lastClickTime3 < 1000) {
      return true;
    }

    _lastClickTime3 = DateTime.now().millisecondsSinceEpoch;
    return false;
  }

  static int _lastClickTime5 = 0;

  static bool isFastClick5() {
    if (DateTime.now().millisecondsSinceEpoch - _lastClickTime5 < 1000) {
      return true;
    }

    _lastClickTime5 = DateTime.now().millisecondsSinceEpoch;
    return false;
  }

  static int _lastClickTime4 = 0;

  static bool isFastClick4() {
    if (DateTime.now().millisecondsSinceEpoch - _lastClickTime4 < 1000) {
      return true;
    }

    _lastClickTime4 = DateTime.now().millisecondsSinceEpoch;
    return false;
  }

  static int _lastClickTime2 = 0;

  static bool isFastClick2() {
    if (DateTime.now().millisecondsSinceEpoch - _lastClickTime2 < 1500) {
      return true;
    }

    _lastClickTime2 = DateTime.now().millisecondsSinceEpoch;
    return false;
  }

  static Future<Uint8List> capturePng(RenderRepaintBoundary boundary) async {
    if (boundary == null) return null;
    await Future.delayed(Duration(milliseconds: 500));
    try {
      var image = await boundary.toImage(pixelRatio: 4.0);
      ByteData byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData.buffer.asUint8List();
      return pngBytes;
    } catch (e) {
    }
    return null;
  }

  static Future<bool> isLogin(BuildContext context) async {
    if (!await CommonUtils.isNetConnected()) {
      showToast('请确认网络连接！');
      return false;
    }
    BmobUserViewModel userViewModel = Provider.of<BmobUserViewModel>(context, listen: false);
    if (!userViewModel.hasUser) {
      Navigator.of(context).pushNamed(RouteName.login);
      return false;
    }
    return true;
  }

  static dynamic noNull(objc) {
    if (objc == null) {
      return "";
    } else {
      return objc;
    }
  }

  /// 检查权限
  static Future<bool> checkPermission(BuildContext context, String per) async {
    bool checkPermission = await AndroidMethodChannel.checkPermission(per);
    if (!checkPermission) {
      bool dlgResult = await DialogHelper.showPermissionTipDialog(context, per);
      if (dlgResult) {
        bool requestPermission =
        await AndroidMethodChannel.requestPermission(per);
        if (requestPermission) {
          return true;
        } else {
          DialogHelper.showPermissionDialog(context);
          return false;
        }
      } else {
        DialogHelper.showPermissionDialog(context);
        return false;
      }
    } else {
      return true;
    }
  }

  static Future<List<File>> pickAssets({int maxImages}) async {
    try {
      // final result = await MultiImagePicker.pickImages(
      //   maxImages: maxImages,
      //   // 是否支持拍照
      //   enableCamera: false,
      //   materialOptions: MaterialOptions(
      //     // 显示所有照片，值为 false 时显示相册
      //     startInAllView: true,
      //     allViewTitle: JYLocalizations.localizedString('所有照片'),
      //     actionBarColor: '#2196F3',
      //     textOnNothingSelected: '没有选择照片',
      //     selectionLimitReachedText: JYLocalizations.localizedString("选择照片超过上限"),
      //   ),
      // );
      // EasyLoading.show(status: JYLocalizations.localizedString("正在加载图片..."));
      // if (result != null && result.isNotEmpty) {
      //   List<File> images = [];
      //   for (var asset in result) {
      //     ByteData byteData = await asset.getByteData();
      //     File file = await CacheAudioManager.saveImageWithUint8List(byteData.buffer.asUint8List());
      //     images.add(file);
      //   }
      //   EasyLoading.dismiss();
      //   return images;
      // }
      final List<AssetEntity> assets = await AssetPicker.pickAssets(navigatorContext, maxAssets: maxImages);
      EasyLoading.show(status: JYLocalizations.localizedString("正在加载图片..."));
      if (assets != null && assets.isNotEmpty) {
        List<File> images = [];
        for (var asset in assets) {
          File file = await asset.file;
          images.add(file);
        }
        EasyLoading.dismiss();
        return images;
      }
    } catch (e) {
      var info = e.toString();
      if (info.contains("cancel")) {
        debugPrint('用户取消');
      } else {
        showToast("获取相册失败，请检查您的权限");
      }
    }
    EasyLoading.dismiss();
    return null;
  }

  ///获取状态栏高度
  static double getStatusBarHeight() {
    return MediaQueryData.fromWindow(window).padding.top;
  }

  ///获取底部高度
  static double getBottomHeight() {
    return MediaQueryData.fromWindow(window).padding.bottom;
  }

  static showToastInfo(String text) {
    showToast(JYLocalizations.localizedString(text));
  }
}
