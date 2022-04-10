import 'dart:async';

import 'package:data_plugin/bmob/table/bmob_user.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graphic_conversion/data/local_storage/storage_manager.dart';
import 'package:graphic_conversion/data/net/fizz_api.dart';
import 'package:graphic_conversion/event/any_event.dart';
import 'package:graphic_conversion/event/event_bus_util.dart';
import 'package:graphic_conversion/locatization/localizations.dart';
import 'package:graphic_conversion/ui/helper/buried_point_helper.dart';
import 'package:graphic_conversion/ui/helper/dialog_helper.dart';
import 'package:graphic_conversion/ui/helper/user_helper.dart';
import 'package:graphic_conversion/view_model/bmob_user_view_model.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'package:graphic_conversion/configs.dart';
import 'package:graphic_conversion/data/net/wx_api.dart';
import 'package:graphic_conversion/router/router_config.dart';
import 'package:graphic_conversion/ui/helper/resoure_helper.dart';
import 'package:graphic_conversion/ui/widget/navigation_back_button.dart';
import 'package:graphic_conversion/utils/common_utils.dart';
import 'package:graphic_conversion/view_model/user_view_model.dart';
import 'package:fluwx/fluwx.dart' as fluwx;

class LoginPhonePage extends StatefulWidget {
  @override
  createState() => LoginPhonePageState();
}

class LoginPhonePageState extends State<LoginPhonePage> {
  bool check = false;
  StreamSubscription listen;

  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool textState = false;

  @override
  void dispose() {
    debugPrint('---dispose--------------');
    listen?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _addListener();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: ColorHelper.color_bg,
        appBar: AppBar(
          backgroundColor: ColorHelper.color_bg,
          leading: NabigationBackButton.back(context),
          centerTitle: true,
          elevation: 0,
        ),
        body: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              // 触摸收起键盘
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: SafeArea(
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
                          margin: EdgeInsets.only(
                              top: ScreenUtil().setHeight(5),
                              left: ScreenUtil().setWidth(30)),
                          child: TextHelper.TextCreateWith(
                            text: "登录后使用更多功能",
                            fontSize: 15,
                            color: Color(0xFF999999),
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.symmetric(
                              horizontal: ScreenUtil().setWidth(15)),
                          margin: EdgeInsets.only(
                              top: ScreenUtil().setHeight(50),
                              left: ScreenUtil().setWidth(30),
                              right: ScreenUtil().setWidth(30)),
                          width: ScreenUtil().setWidth(315),
                          height: ScreenUtil().setHeight(50),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            color: Color(0xFFF2F2F5),
                            //  border: Border.all(color: Color(0xFFE6E6E6), width: 1),
                          ),
                          child: TextField(
                            style: TextStyle(
                                fontSize: 15, color: Color(0xFF333333)),
                            decoration: InputDecoration(
                              hintText:
                                  JYLocalizations.localizedString('请输入用户名'),
                              hintStyle: TextStyle(
                                  fontSize: 15, color: Color(0xFF999999)),
                              border: InputBorder.none,
                            ),
                            controller: usernameController,
                            // keyboardType: TextInputType.numberWithOptions(decimal: true),
                            // inputFormatters: [ WhitelistingTextInputFormatter.digitsOnly],
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.symmetric(
                              horizontal: ScreenUtil().setWidth(15)),
                          margin: EdgeInsets.only(
                              top: ScreenUtil().setHeight(20),
                              left: ScreenUtil().setWidth(30),
                              right: ScreenUtil().setWidth(30)),
                          width: ScreenUtil().setWidth(315),
                          height: ScreenUtil().setHeight(50),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            color: Color(0xFFF2F2F5),
                            //  border: Border.all(color: Color(0xFFE6E6E6), width: 1),
                          ),
                          child: Stack(
                            children: [
                              Container(
                                alignment: Alignment.centerLeft,
                                child: TextField(
                                  style: TextStyle(
                                      fontSize: 15, color: Color(0xFF333333)),
                                  decoration: InputDecoration(
                                    hintText: JYLocalizations.localizedString(
                                        '请输入密码'),
                                    hintStyle: TextStyle(
                                        fontSize: 15, color: Color(0xFF999999)),
                                    border: InputBorder.none,
                                  ),
                                  controller: passwordController,
                                  obscureText: true,
                                ),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: _login,
                          child: Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.only(
                                top: ScreenUtil().setHeight(50),
                                left: ScreenUtil().setWidth(40),
                                right: ScreenUtil().setWidth(40)),
                            width: ScreenUtil().setWidth(315),
                            height: ScreenUtil().setHeight(50),
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(25)),
                              color: textState
                                  ? Color(0xFF00C27C)
                                  : Color(0x8F00C27C),
                              //  border: Border.all(color: Color(0xFFE6E6E6), width: 1),
                            ),
                            child: TextHelper.TextCreateWith(
                              text: "登录",
                              fontSize: 17,
                              color: Color(0xFFFFFFFF),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: _findPass,
                              child: Container(
                                margin: EdgeInsets.only(left: 30),
                                alignment: Alignment.centerRight,
                                child: Text(
                                  "忘记密码",
                                  style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      fontSize: 16,
                                      color: Color(0xFF00C27C)),
                                ),
                              ),
                            ),
                            Expanded(child: Container()),
                            GestureDetector(
                              onTap: _register,
                              child: Container(
                                margin: EdgeInsets.only(right: 30),
                                alignment: Alignment.centerRight,
                                child: Text(
                                  "立即注册",
                                  style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      fontSize: 16,
                                      color: Color(0xFF00C27C)),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )));
  }

  // _textListener() {
  //   setState(() {});
  //   if (phoneController.text.length == 11 && codeController.text.length == 4) {
  //     return true;
  //   } else {
  //     return false;
  //   }
  // }

  void _login() {
    if (checkInfo()) {
      BmobUserViewModel userVM =
      Provider.of<BmobUserViewModel>(context, listen: false);
      BmobUser user = BmobUser();
      user.username = usernameController.text.toString();
      user.password = passwordController.text.toString();
      user.login().then((BmobUser bmobUser) {
        // showSuccess(context, bmobUser.getObjectId() + "\n" + bmobUser.username);
        bmobUser.password=passwordController.text.toString();
        userVM.bmobUserModel = bmobUser;
        showToast(JYLocalizations.localizedString("登录成功"));
        Navigator.of(context).pop();
        bool isFirstPop=StorageManager.sharedPreferences.getBool("isFirstPop");
        if(isFirstPop==null){
          isFirstPop=true;
        }
        if((isFirstPop)&&(userVM.bmobUserModel.mobilePhoneNumber==null||userVM.bmobUserModel.mobilePhoneNumber.length==0)){
          DialogHelper.showBindPhoneDialog(context);
          StorageManager.sharedPreferences.setBool("isFirstPop",false);
        }
      }).catchError((e) {
        // showError(context, BmobError.convert(e).error);
        showToast(JYLocalizations.localizedString("登录失败"));
      });
    }
  }

  void _register() {
    Navigator.of(context).pushNamed(RouteName.register_page);
  }

  void _findPass() {
    Navigator.of(context).pushNamed(RouteName.find_password_page, arguments: {
      'username': usernameController.text,
    });
  }

  bool checkInfo() {
    if (usernameController.text.length < 6) {
      showToast(JYLocalizations.localizedString("请填写正确的用户名"));
      return false;
    }
    if (passwordController.text.length < 6) {
      showToast(JYLocalizations.localizedString("请输入正确的密码"));
      return false;
    }
    return true;
  }

  _addListener() {
    usernameController.addListener(() {
      setState(() {});
      if (usernameController.text.length >= 6 &&
          passwordController.text.length >= 6) {
        textState = true;
      } else {
        textState = false;
      }
    });
    passwordController.addListener(() {
      setState(() {});
      if (usernameController.text.length >= 6 &&
          passwordController.text.length >= 6) {
        textState = true;
      } else {
        textState = false;
      }
    });
    return textState;
  }

  _weChatLogin() async {
    if (check) {
      if (!await CommonUtils.isNetConnected()) {
        showToast(JYLocalizations.localizedString('请确认网络连接！'));
        return;
      }
      WxApi.sendWeChatAuth();
    } else {
      showToast(JYLocalizations.localizedString("请先同意用户协议和隐私政策"));
    }
  }
}
