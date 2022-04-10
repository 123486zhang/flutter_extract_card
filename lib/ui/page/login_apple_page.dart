import 'dart:async';
import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graphic_conversion/data/net/fizz_api.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:graphic_conversion/configs.dart';
import 'package:graphic_conversion/data/net/wx_api.dart';
import 'package:graphic_conversion/model/buried_point_model.dart';
import 'package:graphic_conversion/router/router_config.dart';
import 'package:graphic_conversion/ui/helper/buried_point_helper.dart';
import 'package:graphic_conversion/ui/helper/resoure_helper.dart';
import 'package:graphic_conversion/ui/helper/user_helper.dart';
import 'package:graphic_conversion/ui/widget/navigation_back_button.dart';
import 'package:graphic_conversion/utils/common_utils.dart';
import 'package:graphic_conversion/view_model/user_view_model.dart';

import '../../event/any_event.dart';
import '../../event/event_bus_util.dart';
import '../../locatization/localizations.dart';

class LoginApplePage extends StatefulWidget {
  @override
  _LoginApplePageState createState() => _LoginApplePageState();
}

class _LoginApplePageState extends State<LoginApplePage> {
  bool check = false;
  StreamSubscription listen;

  TextEditingController phoneController = TextEditingController();
  TextEditingController codeController = TextEditingController();

  Timer _countdownTimer;
  String _codeCountdownStr = '发送验证码';
  int _countdownNum = 59;


  @override
  void dispose() {
    debugPrint('---dispose--------------');
    BuriedPointHelper.addBuriedPoint(
      eventType: BuriedPointEventType.PAGE_HIDE,
      pageName: "苹果-我的页面-登录",
    );
    _countdownTimer?.cancel();
    _countdownTimer = null;
    listen?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    BuriedPointHelper.addBuriedPoint(
      eventType: BuriedPointEventType.PAGE_SHOW,
      pageName: "苹果-我的页面-登录",
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double height = screenHeight * 375/screenWidth;
    double diff=812-height;
    return Scaffold(
        backgroundColor: ColorHelper.color_bg,
        appBar: AppBar(
          backgroundColor: ColorHelper.color_bg,
          leading: NabigationBackButton.back(context),
          centerTitle: true,
          elevation: 0,
        ),
        body: SafeArea(
          child: Align(
            alignment: Alignment.topLeft,

            child:Stack(
              children: [
                Column(
                  children: <Widget>[
                    Stack(
                      children: [
                        Container(
                          alignment: Alignment.topLeft,
                          margin: EdgeInsets.only(
                              top: ScreenUtil().setHeight(30)),
                          child: Image.asset(
                            ImageHelper.imageRes('login_top_bg.png'),
                            fit: BoxFit.fill,
                            width: ScreenUtil().setWidth(105),
                            height: ScreenUtil().setHeight(61),
                          ),
                        ),
                        Container(
                          alignment: Alignment.topLeft,
                          margin: EdgeInsets.only(
                              top: ScreenUtil().setHeight(74),
                              left: ScreenUtil().setWidth(30)),
                          child: TextHelper.TextCreateWith(
                            text: "登录",
                            fontSize: 30,
                            color: Color(0xFF333333),
                            isBlod: true,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      alignment: Alignment.topLeft,
                      margin: EdgeInsets.only(top: ScreenUtil().setHeight(5),
                          left: ScreenUtil().setWidth(30)),
                      child: TextHelper.TextCreateWith(
                        text: "登录后查看会员特权",
                        fontSize: 15,
                        color: Color(0xFF999999),
                      ),
                    ),

                    Container(
                      margin: EdgeInsets.only(top: ScreenUtil().setHeight(80),
                          left: ScreenUtil().setWidth(171)),
                      child: Image.asset(
                        ImageHelper.imageRes('login_bottom_bg.png'),
                        fit: BoxFit.fill,
                        width: ScreenUtil().setWidth(204),
                        height: ScreenUtil().setHeight(120),
                      ),
                    ),
                    // GestureDetector(
                    //   onTap: () async {
                    //     if (check) {
                    //       BuriedPointHelper.clickBuriedPoint(
                    //         pageName: "安卓-我的页面-登录",
                    //         clickName: "微信登录",
                    //       );
                    //       if (!await CommonUtils.isNetConnected()) {
                    //         showToast('请确认网络连接！');
                    //         return;
                    //       }
                    //       WxApi.sendWeChatAuth();
                    //     } else {
                    //       showToast("请先同意用户协议和隐私政策");
                    //     }
                    //   },
                    //   child: Container(
                    //     alignment: Alignment.center,
                    //     margin: EdgeInsets.only(top: ScreenUtil().setHeight(20), left: ScreenUtil().setWidth(30), right: ScreenUtil().setWidth(30)),
                    //     width: ScreenUtil().setWidth(315),
                    //     height: ScreenUtil().setHeight(50),
                    //     decoration: BoxDecoration(
                    //       borderRadius: BorderRadius.all(Radius.circular(10)),
                    //       color: Color(0xFF00C27C),
                    //       //  border: Border.all(color: Color(0xFFE6E6E6), width: 1),
                    //     ),
                    //     child: Row(
                    //       children: [
                    //         Container(
                    //           margin: EdgeInsets.only(left: ScreenUtil().setWidth(108)),
                    //           child:    Image.asset(
                    //             ImageHelper.imageRes('icon_login_wechat.png'),
                    //             fit: BoxFit.fill,
                    //             width: ScreenUtil().setWidth(25),
                    //             height: ScreenUtil().setHeight(25),
                    //           ),
                    //         ),
                    //
                    //         Container(
                    //           margin: EdgeInsets.only(left: ScreenUtil().setWidth(5)),
                    //           child:   TextHelper.TextCreateWith(
                    //             text: "微信登录",
                    //             fontSize: 17,
                    //             color: Color(0xFFFFFFFF),
                    //           ),),
                    //       ],
                    //     ),
                    //   ),
                    // ),
                    GestureDetector(
                      onTap: () async {
                        if (check) {
                          BuriedPointHelper.clickBuriedPoint(
                            pageName: "苹果-我的页面-登录",
                            clickName: "手机号登录",
                          );
                          if (!await CommonUtils.isNetConnected()) {
                            showToast('请确认网络连接！');
                            return;
                          }
                          Navigator.of(context)
                              .pushReplacementNamed(RouteName.login_phone_page);
                        } else {
                          showToast("请先同意用户协议和隐私政策");
                        }
                      },
                      child: Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(top: ScreenUtil().setHeight(15),
                            left: ScreenUtil().setWidth(30),
                            right: ScreenUtil().setWidth(30)),
                        width: ScreenUtil().setWidth(315),
                        height: ScreenUtil().setHeight(50),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: Color(0xFF00C27C),
                          border:
                          Border.all(color: Color(0xFFBBBBBB), width: 0.5),
                        ),
                        child: TextHelper.TextCreateWith(
                          text: "手机号登录",
                          fontSize: 15,
                          color: Color(0xFFFFFFFF),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: ScreenUtil().setHeight(20),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            setState(() {
                              check = !check;
                            });
                          },
                          child: Container(
                            padding:
                            EdgeInsets.only(right: ScreenUtil().setWidth(10),
                                top: ScreenUtil().setHeight(10),
                                bottom: ScreenUtil().setHeight(10)),
                            child: Image.asset(
                              ImageHelper.imageRes(check
                                  ? 'icon_login_selected.png'
                                  : 'icon_login_disable.png'),
                              width: ScreenUtil().setWidth(15),
                              height: ScreenUtil().setHeight(15),
                            ),
                          ),
                        ),
                        Text.rich(
                          TextSpan(
                            text: JYLocalizations.localizedString('阅读并同意'),
                            style: TextStyle(
                                fontSize: 13, color: Color(0xFF9B9B9B)),
                            children: <TextSpan>[
                              TextSpan(
                                text: JYLocalizations.localizedString('「隐私政策」'),
                                style: TextStyle(
                                    fontSize: 13,
                                    color: ColorHelper.color_main),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () async {
                                    if (!await CommonUtils.isNetConnected()) {
                                      showToast('请确认网络连接!');
                                      return;
                                    }
                                    Navigator.of(context).pushNamed(
                                        RouteName.webview,
                                        arguments: {
                                          'title': '隐私政策',
                                          'url': Configs.URL_YSZC,
                                        });
                                  },
                              ),
                              TextSpan(
                                text: JYLocalizations.localizedString('&'),
                                style: TextStyle(
                                    fontSize: 13,
                                    color: Color(0xFF9B9B9B)),
                              ),
                              TextSpan(
                                text: JYLocalizations.localizedString('「用户协议」'),
                                style: TextStyle(
                                    fontSize: 13,
                                    color: ColorHelper.color_main),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () async {
                                    if (!await CommonUtils.isNetConnected()) {
                                      showToast('请确认网络连接!');
                                      return;
                                    }
                                    Navigator.of(context).pushNamed(
                                        RouteName.webview,
                                        arguments: {
                                          'title': '用户协议',
                                          'url': Configs.URL_YHXY,
                                        });
                                  },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    // Padding(
                    //   padding: EdgeInsets.only(top: 14, bottom: 60),
                    //   child: Text(
                    //     Configs.appName,
                    //     style:
                    //     TextStyle(fontSize: 19, color: Color(0xFF333333), fontWeight: FontWeight.bold),
                    //   ),
                    // ),
                    // GestureDetector(
                    //   onTap: () async {
                    //     if (check) {
                    //       BuriedPointHelper.clickBuriedPoint(
                    //         pageName: "安卓-我的页面-登录",
                    //         clickName: "微信登录",
                    //       );
                    //       if (!await CommonUtils.isNetConnected()) {
                    //         showToast('请确认网络连接！');
                    //         return;
                    //       }
                    //       WxApi.sendWeChatAuth();
                    //     } else {
                    //       showToast("请先同意用户协议和隐私政策");
                    //     }
                    //   },
                    //   child: Container(
                    //     margin: EdgeInsets.symmetric(horizontal: 25),
                    //     height: 50,
                    //     alignment: Alignment(0, 0),
                    //     decoration: BoxDecoration(
                    //         color: Color(0xFF28C445),
                    //         borderRadius:
                    //         BorderRadius.all(Radius.circular(47))),
                    //     child: Row(
                    //       mainAxisSize: MainAxisSize.min,
                    //       crossAxisAlignment: CrossAxisAlignment.center,
                    //       children: <Widget>[
                    //         TextHelper.TextCreateWith(text:
                    //           '微信登录',
                    //               fontSize: 17,
                    //               color: Colors.white,
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    // ),
                    //  SizedBox(height: 20,),
                    //   Row(
                    //     mainAxisAlignment: MainAxisAlignment.center,
                    //     crossAxisAlignment: CrossAxisAlignment.center,
                    //     mainAxisSize: MainAxisSize.max,
                    //     children: <Widget>[
                    //       GestureDetector(
                    //         behavior: HitTestBehavior.opaque,
                    //         onTap: () {
                    //           setState(() {
                    //             check = !check;
                    //           });
                    //         },
                    //         child: Container(
                    //           padding: EdgeInsets.only(right: 10, top: 10, bottom: 10),
                    //           child: Image.asset(
                    //             ImageHelper.imageRes(check
                    //                 ? 'ic_checkbox_selected.png'
                    //                 : 'ic_checkbox_disable.png'),
                    //             width: 16,
                    //             height: 16,
                    //           ),
                    //         ),
                    //       ),
                    //       Text.rich(
                    //         TextSpan(
                    //           text: JYLocalizations.localizedString('阅读并同意'),
                    //           style: TextStyle(
                    //               fontSize: 14, color: Color(0xFF9B9B9B)),
                    //           children: <TextSpan>[
                    //             TextSpan(
                    //               text: JYLocalizations.localizedString('《用户协议》'),
                    //               style:
                    //               TextStyle(fontSize: 14, color: ColorHelper.color_main),
                    //               recognizer: TapGestureRecognizer()
                    //                 ..onTap = () async {
                    //                   if (!await CommonUtils.isNetConnected()) {
                    //                   showToast('请确认网络连接!');
                    //                   return;
                    //                   }
                    //                   Navigator.of(context)
                    //                       .pushNamed(RouteName.webview, arguments: {
                    //                     'title': '用户协议',
                    //                     'url': Configs.URL_YHXY,
                    //                   });
                    //                 },
                    //             ),
                    //             TextSpan(
                    //               text: JYLocalizations.localizedString('和'),
                    //               style: TextStyle(
                    //                   fontSize: 14, color: Color(0xFF9B9B9B)),
                    //             ),
                    //             TextSpan(
                    //               text: JYLocalizations.localizedString('《隐私政策》'),
                    //               style:
                    //               TextStyle(fontSize: 14, color: ColorHelper.color_main),
                    //               recognizer: TapGestureRecognizer()
                    //                 ..onTap = () async {
                    //                   if (!await CommonUtils.isNetConnected()) {
                    //                   showToast('请确认网络连接!');
                    //                   return;
                    //                   }
                    //                   Navigator.of(context)
                    //                       .pushNamed(RouteName.webview, arguments: {
                    //                     'title': '隐私政策',
                    //                     'url': Configs.URL_YSZC,
                    //                   });
                    //                 },
                    //             ),
                    //           ],
                    //         ),
                    //       ),
                    //     ],
                    //   )
                  ],
                ),
                // Positioned(
                //   bottom: 0,
                //   left: 0,
                //   right: 0,
                //   child: Column(
                //     children: [
                //       Container(
                //         margin: EdgeInsets.symmetric(horizontal: 15),
                //         height: 1,
                //         color: ColorHelper.color_divideLine,
                //       ),
                //       SizedBox(height: 20,),
                //       TextHelper.TextCreateWith(
                //         text: "其他登录方式",
                //         fontSize: 14,
                //         color: Color(0xFF9B9B9B)
                //       ),
                //       SizedBox(height: 15,),
                //       GestureDetector(
                //         onTap: () {
                //           BuriedPointHelper.clickBuriedPoint(
                //             pageName: "安卓-我的页面-登录",
                //             clickName: "手机号登录",
                //           );
                //           Navigator.of(context).pushReplacementNamed(RouteName.login_phone_page);
                //         },
                //         child: Image.asset(
                //           ImageHelper.imageRes("login_phone.png"),
                //           width: 50,
                //           height: 50,
                //         ),
                //       ),
                //       SizedBox(height: 10,),
                //       TextHelper.TextCreateWith(
                //           text: "手机号登录",
                //           fontSize: 13,
                //           color: Color(0xFFB8B8B8)
                //       ),
                //       SizedBox(height: 40,),
                //     ],
                //   )
                // )
                Row(children: [
                  GestureDetector(
                    onTap: () async {
                      if (check) {
                        BuriedPointHelper.clickBuriedPoint(
                          pageName: "苹果-我的页面-登录",
                          clickName: "苹果账号登录",
                        );
                        if (!await CommonUtils.isNetConnected()) {
                          showToast('请确认网络连接！');
                          return;
                        }
                        _appleLogin();
                      } else {
                        showToast("请先同意用户协议和隐私政策");
                      }
                    },
                    child: Container(
                      margin: EdgeInsets.only(top: ScreenUtil().setHeight(645-diff.toInt())),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[

                          Container(
                            margin: EdgeInsets.only(left: ScreenUtil().setWidth(97)),
                            child: Image.asset(
                              ImageHelper.imageRes('icon_login_ios_apple.png'),
                              width: ScreenUtil().setWidth(40),
                              height: ScreenUtil().setHeight(40),
                            ),),

                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      if (check) {
                        BuriedPointHelper.clickBuriedPoint(
                          pageName: "苹果-我的页面-登录",
                          clickName: "微信登录",
                        );
                        if (!await CommonUtils.isNetConnected()) {
                          showToast('请确认网络连接！');
                          return;
                        }
                        _weChatLogin();
                      } else {
                        showToast("请先同意用户协议和隐私政策");
                      }
                    },
                    child: Container(
                      margin: EdgeInsets.only(top: ScreenUtil().setHeight(645-diff.toInt())),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(left: ScreenUtil().setWidth(97)),
                            child: Image.asset(
                              ImageHelper.imageRes('icon_login_ios_wechat.png'),
                              width: ScreenUtil().setWidth(40),
                              height: ScreenUtil().setHeight(40),
                            ),),

                        ],
                      ),
                    ),
                  ),
                ],),
                Row(children: [
                  Container(
                    margin: EdgeInsets.only(top: ScreenUtil().setHeight(645-diff.toInt()), left: ScreenUtil().setWidth(77)),
                    child: TextHelper.TextCreateWith(
                      text: "",//"苹果账号登录",
                      fontSize: 13,
                      color: Color(0xFF666666),
                    ),),
                  Container(
                    margin: EdgeInsets.only(top: ScreenUtil().setHeight(645-diff.toInt()), left: ScreenUtil().setWidth(75)),
                    child: TextHelper.TextCreateWith(
                      text: "",//"微信登录",
                      fontSize: 13,
                      color: Color(0xFF666666),
                    ),),
                ]),
              ],
            ),

          ),
        ));
  }

  void sendCode() {
    if (_countdownTimer != null) {
      return;
    }
    if (phoneController.text.length != 11) {
      showToast("请输入正确的手机号");
      return;
    }

    var smsCode = FIZZApi.requestGetSMSCode(
        phone: phoneController.text, type: 3);
    smsCode.then((value) {
      if (value) {
        showToast("验证码已发送");
        reGetCountdown();
      }
    });
  }

  void reGetCountdown() {
    setState(() {
      if (_countdownTimer != null) {
        return;
      }
      // Timer的第一秒倒计时是有一点延迟的，为了立刻显示效果可以添加下一行。
      _codeCountdownStr = '（${_countdownNum--}）秒';
      _countdownTimer = new Timer.periodic(new Duration(seconds: 1), (timer) {
        setState(() {
          if (_countdownNum > 0) {
            _codeCountdownStr = '（${_countdownNum--}）秒';
          } else {
            _codeCountdownStr = '获取验证码';
            _countdownNum = 59;
            _countdownTimer.cancel();
            _countdownTimer = null;
          }
        });
      });
    });
  }

  void nextButtonAction() {
    if (checkInfo()) {
      BuriedPointHelper.clickBuriedPoint(
        pageName: "苹果-我的页面-登录",
        clickName: "手机号登录",
      );
      FocusScope.of(context).requestFocus(FocusNode());
      EasyLoading.show();
      var reg = FIZZApi.requestSMSLogin(
        phone: phoneController.text,
        smsCode: codeController.text,
      );
      reg.then((value) async {
        if (value != null) {
          UserViewModel userVM = Provider.of<UserViewModel>(
              context, listen: false);
          userVM.userModel = value;
          UserHelper().documentVM.init();
          await userVM.getUserInfo();
          EasyLoading.dismiss();
          Navigator.of(context).pop();
          showToast('登录成功！');
        } else {
          EasyLoading.dismiss();
        }
      });
    }
  }

  bool checkInfo() {
    if (phoneController.text.length != 11) {
      showToast("请填写正确的手机号");
      return false;
    }
    if (codeController.text.length < 2) {
      showToast("请输入正确的验证码");
      return false;
    }
    if (!check) {
      showToast("请先同意用户协议和隐私政策");
      return false;
    }
    return true;
  }

  _weChatLogin() async {
    if (check) {
      BuriedPointHelper.clickBuriedPoint(
        pageName: "苹果-我的页面-登录",
        clickName: "微信登录",
      );
      if (!await CommonUtils.isNetConnected()) {
        showToast('请确认网络连接！');
        return;
      }
      WxApi.sendWeChatAuth();
    } else {
      showToast("请先同意用户协议和隐私政策");
    }
  }

  _appleLogin() async {
    if (check) {
      BuriedPointHelper.clickBuriedPoint(
        pageName: "苹果-我的页面-登录",
        clickName: "苹果登录",
      );
      if (!await CommonUtils.isNetConnected()) {
        showToast('请确认网络连接！');
        return;
      }
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );
      var nikeName = "${credential.familyName ?? ""}${credential.givenName ??
          ""}";
      FIZZApi.requestAppleLogin(
        appleToken: credential.identityToken,
        nikeName: nikeName,
        uid: credential.userIdentifier,
      ).then((value) {
        UserViewModel userVM = Provider.of<UserViewModel>(
            context, listen: false);
        userVM.userModel = value;
        Navigator.of(context).pop();
        EventBusUtil.getInstance().fire(AnyEvent(AnyEvent.REFRESH_VIP));
        showToast('登录成功！');
        UserHelper().documentVM.init();
      });
    } else {
      showToast("请先同意用户协议和隐私政策");
    }
  }
}