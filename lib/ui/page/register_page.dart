import 'dart:async';

import 'package:data_plugin/bmob/bmob_query.dart';
import 'package:data_plugin/bmob/response/bmob_error.dart';
import 'package:data_plugin/bmob/table/bmob_user.dart';
import 'package:data_plugin/utils/dialog_util.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graphic_conversion/data/net/fizz_api.dart';
import 'package:graphic_conversion/event/any_event.dart';
import 'package:graphic_conversion/event/event_bus_util.dart';
import 'package:graphic_conversion/locatization/localizations.dart';
import 'package:graphic_conversion/ui/helper/buried_point_helper.dart';
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

class RegisterPage extends StatefulWidget {
  @override
  createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {
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
              // ??????????????????
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
                                text: "??????",
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
                            text: "???????????????????????????",
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
                                  JYLocalizations.localizedString('??????????????????'),
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
                                        '???????????????'),
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
                          onTap: _register,
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
                              text: "??????",
                              fontSize: 17,
                              color: Color(0xFFFFFFFF),
                            ),
                          ),
                        ),
                        // SizedBox(
                        //   height: 30,
                        // ),
                        // Row(
                        //   children: [
                        //     GestureDetector(
                        //       onTap: _findPass,
                        //       child: Container(
                        //         margin: EdgeInsets.only(left: 30),
                        //         alignment: Alignment.centerRight,
                        //         child: Text(
                        //           "????????????",
                        //           style: TextStyle(
                        //               decoration: TextDecoration.underline,
                        //               fontSize: 16,
                        //               color: Color(0xFF00C27C)),
                        //         ),
                        //       ),
                        //     ),
                        //     Expanded(child: Container()),
                        //     GestureDetector(
                        //       onTap: _register,
                        //       child: Container(
                        //         margin: EdgeInsets.only(right: 30),
                        //         alignment: Alignment.centerRight,
                        //         child: Text(
                        //           "????????????",
                        //           style: TextStyle(
                        //               decoration: TextDecoration.underline,
                        //               fontSize: 16,
                        //               color: Color(0xFF00C27C)),
                        //         ),
                        //       ),
                        //     ),
                        //   ],
                        // ),
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

  void _register() {
    if (checkInfo()) {
      String username = usernameController.text;
      String password = passwordController.text;
      BmobQuery<BmobUser> query = BmobQuery();
      query.addWhereEqualTo("username", username);
      query.queryObjects().then((data) {
        // showSuccess(context, data.toString());
        List<BmobUser> users = data.map((i) => BmobUser().fromJsons(i)).toList();
        if (users == null || users.length == 0) {
          BmobUser user = BmobUser();
          user.username = username;
          user.password = password;
          user.register().then((value) {
            if (value != null) {
              showToast(JYLocalizations.localizedString("????????????"));

              BmobUserViewModel userVM =
              Provider.of<BmobUserViewModel>(context, listen: false);
              user.login().then((BmobUser bmobUser) {
                // showSuccess(context, bmobUser.getObjectId() + "\n" + bmobUser.username);
                userVM.bmobUserModel = bmobUser;
                Navigator.of(context).pop();
              }).catchError((e) {
                // showError(context, BmobError.convert(e).error);
                showToast(JYLocalizations.localizedString("????????????"));
              });
            } else {
              showToast(JYLocalizations.localizedString("????????????"));
            }
          });
        } else {
          showToast(JYLocalizations.localizedString("??????????????????"));
        }
      }).catchError((e) {
        showToast('????????????');
      });

    }
  }

  bool checkInfo() {
    if (usernameController.text.length < 6) {
      showToast(JYLocalizations.localizedString("???????????????????????????6"));
      return false;
    }
    if (passwordController.text.length < 6) {
      showToast(JYLocalizations.localizedString("????????????????????????5"));
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
        showToast(JYLocalizations.localizedString('????????????????????????'));
        return;
      }
      WxApi.sendWeChatAuth();
    } else {
      showToast(JYLocalizations.localizedString("???????????????????????????????????????"));
    }
  }
}
