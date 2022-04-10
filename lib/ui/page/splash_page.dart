import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:graphic_conversion/channel/android_method_channel.dart';
import 'package:graphic_conversion/data/local_storage/storage_manager.dart';
import 'package:graphic_conversion/data/net/ad_api.dart';
import 'package:graphic_conversion/data/net/fizz_api.dart';
import 'package:graphic_conversion/event/ad_event.dart';
import 'package:graphic_conversion/event/event_bus.dart';
import 'package:graphic_conversion/locatization/localizations.dart';
import 'package:graphic_conversion/ui/dialog/agreement_dialog.dart';
import 'package:graphic_conversion/ui/helper/dialog_helper.dart';
import 'package:graphic_conversion/ui/helper/ios_pay_helper.dart';
import 'package:graphic_conversion/ui/helper/resoure_helper.dart';
import 'package:graphic_conversion/ui/helper/user_helper.dart';
import 'package:graphic_conversion/utils/common_utils.dart';
import 'package:oktoast/oktoast.dart';

import '../../configs.dart';

class SplashPage extends StatefulWidget {
  @override
  createState() => SplashState();
}

class SplashState extends State<SplashPage> {
  int _count = 5;
  Timer _countdownTimer;

  Widget _splashAdView;

  bool _loadedSplashAd = false;

  StreamSubscription _listen;


  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      StorageManager.sharedPreferences.setBool(isShowAgreement, false);
      var isAgree = await showAgreementDialog();
      debugPrint('showAgreementDialog-isAgree=$isAgree');

      if(isAgree) {
        if (Platform.isAndroid) {
          await AndroidMethodChannel.onAgreementPass();
        } else {
          // IOSPayHelper.getProduct();
        }

        await Configs.init();

        if (!await CommonUtils.isNetConnected()){
          showToast(JYLocalizations.localizedString('请确认网络连接！'));
          Future.delayed(Duration(seconds: 1), () {
            Navigator.of(context).pop();
          });
          return;
        }

         _startTimer(3);
      }
    });

    // _listen = eventBus.on<AdEvent>().listen((event) {
    //   switch (event.type) {
    //     case AdEvent.AD_ShowStatusUpdated:
    //       if ((AdApi.pResult || AdApi.tResult) && (!AdApi.hideSplashAd) && (_splashAdView == null)) {
    //         _createSplashAdView();
    //         setState(() {});
    //       }
    //   }
    // });
  }

  Future<bool> showAgreementDialog() async {
    bool agreement = StorageManager.sharedPreferences.getBool(kAgreement);

    if (agreement == true) {
      return true;
    }

    var isAgree = await DialogHelper.showAgreementDialog(
        context, Configs.URL_YHXY, Configs.URL_YSZC);

    if (isAgree != true) {
      var isAgreeEnsure = await DialogHelper.showAgreementEnsureDialog(context);

      if (isAgreeEnsure == true) {
        return showAgreementDialog();
      } else {
        StorageManager.sharedPreferences.setBool(kAgreement, false);
        return false;
      }
    }
    StorageManager.sharedPreferences.setBool(isShowAgreement, true);
    StorageManager.sharedPreferences.setBool(kAgreement, true);
    return true;
  }

  @override
  void dispose() {
    _listen?.cancel();
    _listen = null;
    _countdownTimer?.cancel();
    _countdownTimer = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String pngStr;
    Size size = MediaQuery.of(context).size;
    debugPrint("------->${MediaQuery.of(context).size.width}");
    if (MediaQuery.of(context).size.width > 375) {
      pngStr = "splash_bg_new1.png";
    } else {
      pngStr = "splash_bg_new.png";
    }
    double t = 600 /
        MediaQuery.of(context).devicePixelRatio /
        (MediaQuery.of(context).size.width / 375);
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Scaffold(
          backgroundColor: Colors.white,
          body: Stack(
            alignment: Alignment.topRight,
            overflow: Overflow.clip,
            children: <Widget>[
              // Platform.isIOS
              //     ? Container(
              //   alignment: Alignment.center,
              //   child: Image.asset(
              //     ImageHelper.imageRes('bg_splash.png'),
              //     fit: BoxFit.cover,
              //     width: size.width,
              //     height: size.height,
              //   ),
              // )
              //     : Container(
              //   child: Container(
              //     margin: EdgeInsets.only(top: t),
              //     alignment: Alignment.topCenter,
              //     child: Image.asset(
              //       ImageHelper.imageRes(pngStr),
              //       fit: BoxFit.fitWidth,
              //     ),
              //   ),
              // ),

              Platform.isIOS
                  ? Container(
                alignment: Alignment.center,
                child: Image.asset(
                  ImageHelper.imageRes('bg_splash.png'),
                  fit: BoxFit.fitWidth,
//                        width: 375,
                ),
              )
                  : Container(
                alignment: Alignment.center,
                child: Image.asset(
                  ImageHelper.imageRes('splash_bg.png'),
                  fit: BoxFit.fill,
                  width: 375,
                  height: 812,
                ),
              ),
              buildSplashAdView(),
            ],
          )
      ),
    );
  }

  Widget buildSplashAdView() {
    return Offstage(
      offstage: !(_loadedSplashAd && _splashAdView != null),
      child: _splashAdView != null
          ? Container(
              padding: Platform.isIOS ? EdgeInsets.zero : EdgeInsets.only(top: CommonUtils.getStatusBarHeight()),
              child: _splashAdView
            )
          : Container()
    );
  }

  _createSplashAdView() {
    _splashAdView = AdApi.splashAdView(
        onShow: (_) {
          setState(() {
            _loadedSplashAd = true;
          });
        },
        onClick: (_) {

        },
        onClose: (_) {
          Navigator.of(context).pop();
        }
    );
  }

  _startTimer(int time) {
    if (_countdownTimer != null) return;

    _count = time;
    _countdownTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _count--;
      });
      if (_count < 1) {
        _countdownTimer?.cancel();
        _countdownTimer = null;
        if (_splashAdView == null) {
          Navigator.of(context).pop();
        }
      }
    });
  }
}
