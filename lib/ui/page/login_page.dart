import 'dart:async';
import 'dart:convert' as convert;
import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluwx/fluwx.dart' as fluwx;
import 'package:graphic_conversion/locatization/localizations.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'package:graphic_conversion/configs.dart';
import 'package:graphic_conversion/data/net/wx_api.dart';
import 'package:graphic_conversion/model/buried_point_model.dart';
import 'package:graphic_conversion/router/router_config.dart';
import 'package:graphic_conversion/ui/helper/buried_point_helper.dart';
import 'package:graphic_conversion/ui/helper/resoure_helper.dart';
import 'package:graphic_conversion/ui/widget/navigation_back_button.dart';
import 'package:graphic_conversion/utils/common_utils.dart';
import 'package:graphic_conversion/view_model/user_view_model.dart';

class LoginPage extends StatefulWidget {
  @override
  createState() => LoginState();
}

class LoginState extends State<LoginPage> {
  bool check = false;
  StreamSubscription listen;
  MethodChannel methodChannel = new MethodChannel("plugin/login");

  @override
  void initState() {
    super.initState();
    BuriedPointHelper.addBuriedPoint(
      eventType: BuriedPointEventType.PAGE_SHOW,
      pageName: "安卓-我的页面-登录",
    );
  }

  @override
  void dispose() {
    BuriedPointHelper.addBuriedPoint(
      eventType: BuriedPointEventType.PAGE_HIDE,
      pageName: "安卓-我的页面-登录",
    );

    listen?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
            child: Stack(
              children: [
                Column(
                  children: <Widget>[
                    Stack(
                      children: [
                        Container(
                          alignment: Alignment.topLeft,
                          margin: EdgeInsets.only(top: ScreenUtil().setHeight(30)),
                          child: Image.asset(
                            ImageHelper.imageRes('login_top_bg.png'),
                            fit: BoxFit.fill,
                            width: ScreenUtil().setWidth(105),
                            height: ScreenUtil().setHeight(61),
                          ),
                        ),
                        Container(
                          alignment: Alignment.topLeft,
                          margin: EdgeInsets.only(top: ScreenUtil().setHeight(74), left: ScreenUtil().setWidth(30)),
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
                      margin: EdgeInsets.only(top: ScreenUtil().setHeight(5), left: ScreenUtil().setWidth(30)),
                      child: TextHelper.TextCreateWith(
                        text: "登录后查看会员特权",
                        fontSize: 15,
                        color: Color(0xFF999999),
                      ),
                    ),

                    Container(
                      margin: EdgeInsets.only(top: ScreenUtil().setHeight(80), left: ScreenUtil().setWidth(171)),
                      child: Image.asset(
                        ImageHelper.imageRes('login_bottom_bg.png'),
                        fit: BoxFit.fill,
                        width: ScreenUtil().setWidth(204),
                        height: ScreenUtil().setHeight(120),
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        if (check) {
                          BuriedPointHelper.clickBuriedPoint(
                            pageName: "安卓-我的页面-登录",
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
                      },
                      child: Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(top: ScreenUtil().setHeight(20), left: ScreenUtil().setWidth(30), right: ScreenUtil().setWidth(30)),
                        width: ScreenUtil().setWidth(315),
                        height: ScreenUtil().setHeight(50),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: Color(0xFF00C27C),
                          //  border: Border.all(color: Color(0xFFE6E6E6), width: 1),
                        ),
                        child: Row(
                          children: [
                            Container(
                              margin: EdgeInsets.only(left: ScreenUtil().setWidth(108)),
                              child:    Image.asset(
                                ImageHelper.imageRes('icon_login_wechat.png'),
                                fit: BoxFit.fill,
                                width: ScreenUtil().setWidth(25),
                                height: ScreenUtil().setHeight(25),
                              ),
                            ),

                            Container(
                              margin: EdgeInsets.only(left: ScreenUtil().setWidth(5)),
                              child:   TextHelper.TextCreateWith(
                                text: "微信登录",
                                fontSize: 17,
                                color: Color(0xFFFFFFFF),
                              ),),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        if (check) {
                          BuriedPointHelper.clickBuriedPoint(
                            pageName: "安卓-我的页面-登录",
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
                        margin: EdgeInsets.only(top: ScreenUtil().setHeight(15), left: ScreenUtil().setWidth(30), right: ScreenUtil().setWidth(30)),
                        width: ScreenUtil().setWidth(315),
                        height: ScreenUtil().setHeight(50),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: Color(0xFFFFFFFF),
                          border:
                              Border.all(color: Color(0xFFBBBBBB), width: 0.5),
                        ),
                        child: TextHelper.TextCreateWith(
                          text: "手机号登录",
                          fontSize: 15,
                          color: Color(0xFF666666),
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
                                EdgeInsets.only(right: ScreenUtil().setWidth(10), top: ScreenUtil().setHeight(10), bottom: ScreenUtil().setHeight(10)),
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
              ],
            ),
          ),
        ));
  }
}
