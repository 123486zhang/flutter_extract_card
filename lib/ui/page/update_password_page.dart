import 'dart:async';

import 'package:data_plugin/bmob/bmob_query.dart';
import 'package:data_plugin/bmob/response/bmob_updated.dart';
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

class UpdatePasswordPage extends StatefulWidget {
  final String username;

  const UpdatePasswordPage({Key key, this.username}) : super(key: key);

  @override
  createState() => UpdatePasswordPageState();
}

class UpdatePasswordPageState extends State<UpdatePasswordPage> {
  bool check = false;
  StreamSubscription listen;

  TextEditingController phoneController = TextEditingController();
  TextEditingController codeController = TextEditingController();

  bool textState = false;

  Timer _countdownTimer;
  String _codeCountdownStr = JYLocalizations.localizedString('获取验证码');
  int _countdownNum = 59;

  String _username;

  bool _isVerify = false;

  @override
  void dispose() {
    debugPrint('---dispose--------------');
    _countdownTimer?.cancel();
    _countdownTimer = null;
    listen?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _addListener();

    _username = widget.username;

    listen = EventBusUtil.listener<AnyEvent>((event) {
      switch (event.type) {
        case AnyEvent.REFRESH_PHONE:
          setState(() {});
          break;
      }
    });
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
                    _showBindState(),
                  ],
                ),
              ),
            )));
  }

  Widget _showBindState() {
    if (true)
      // if (false)
      return Column(
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
                margin: EdgeInsets.only(
                    top: ScreenUtil().setHeight(74),
                    left: ScreenUtil().setWidth(30)),
                child: TextHelper.TextCreateWith(
                  text: "重置密码",
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
              text: "验证绑定手机号后可重置密码",
              fontSize: 15,
              color: Color(0xFF999999),
            ),
          ),
          Container(
            alignment: Alignment.center,
            padding:
                EdgeInsets.symmetric(horizontal: ScreenUtil().setHeight(15)),
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
              style: TextStyle(fontSize: 15, color: Color(0xFF333333)),
              decoration: InputDecoration(
                hintText: _isVerify ? "请输入新密码" : "请输入绑定手机号",
                hintStyle: TextStyle(fontSize: 15, color: Color(0xFF999999)),
                border: InputBorder.none,
              ),
              obscureText: _isVerify,
              controller: phoneController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),
          ),
          GestureDetector(
            onTap: _verifyPassword,
            child: Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(
                  top: ScreenUtil().setHeight(60),
                  left: ScreenUtil().setWidth(40),
                  right: ScreenUtil().setWidth(40)),
              width: ScreenUtil().setWidth(315),
              height: ScreenUtil().setHeight(50),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(25)),
                color: textState ? Color(0xFF00C27C) : Color(0x8F00C27C),
                //  border: Border.all(color: Color(0xFFE6E6E6), width: 1),
              ),
              child: TextHelper.TextCreateWith(
                text: _isVerify ? "重置密码":"验证手机号",
                fontSize: 17,
                color: Color(0xFFFFFFFF),
              ),
            ),
          ),
        ],
      );
    return Column(children: <Widget>[
      Container(
        alignment: Alignment.topCenter,
        margin: EdgeInsets.only(top: ScreenUtil().setHeight(64)),
        child: Image.asset(
          ImageHelper.imageRes('icon_change_phone.png'),
          fit: BoxFit.fill,
          width: ScreenUtil().setWidth(160),
          height: ScreenUtil().setHeight(160),
        ),
      ),
      Container(
        alignment: Alignment.topCenter,
        child: TextHelper.TextCreateWith(
          text:
              "已绑定手机号：${UserHelper().bmobUserVM.bmobUserModel.mobilePhoneNumber.substring(0, 3)}****${UserHelper().bmobUserVM.bmobUserModel.mobilePhoneNumber.substring(7, 11)}",
          fontSize: 15,
          color: Color(0xFF333333),
        ),
      ),
      GestureDetector(
        onTap: () {
          if (!UserHelper().bmobUserVM.hasUser) {
            Navigator.of(context).pushNamed(RouteName.login);
          } else {
            BuriedPointHelper.clickBuriedPoint(
              pageName: "绑定手机",
              clickName: "更换绑定手机号",
            );
            Navigator.of(context).pushNamed(RouteName.change_phone_page);
          }
        }, //更换绑定手机
        child: Container(
          alignment: Alignment.center,
          margin: EdgeInsets.only(
              top: ScreenUtil().setHeight(40),
              left: ScreenUtil().setWidth(40),
              right: ScreenUtil().setWidth(30)),
          width: ScreenUtil().setWidth(315),
          height: ScreenUtil().setHeight(50),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(25)),
            color: Color(0xFF00C27C),
            //  border: Border.all(color: Color(0xFFE6E6E6), width: 1),
          ),
          child: TextHelper.TextCreateWith(
            text: "更换手机号",
            fontSize: 17,
            color: Color(0xFFFFFFFF),
          ),
        ),
      ),
    ]);
  }

  void sendCode() {
    if (_countdownTimer != null) {
      return;
    }
    if (phoneController.text.length != 11) {
      showToast(JYLocalizations.localizedString("请输入正确的手机号"));
      return;
    }

    var smsCode =
        FIZZApi.requestGetSMSCode(phone: phoneController.text, type: 1);
    smsCode.then((value) {
      if (value) {
        showToast(JYLocalizations.localizedString("验证码已发送"));
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
      _codeCountdownStr =
          '（${_countdownNum--}）' + JYLocalizations.localizedString('秒');
      _countdownTimer = new Timer.periodic(new Duration(seconds: 1), (timer) {
        setState(() {
          if (_countdownNum > 0) {
            _codeCountdownStr =
                '（${_countdownNum--}）' + JYLocalizations.localizedString('秒');
          } else {
            _codeCountdownStr = JYLocalizations.localizedString('获取验证码');
            _countdownNum = 59;
            _countdownTimer.cancel();
            _countdownTimer = null;
          }
        });
      });
    });
  }

  _verifyPassword() async {
    if (checkInfo()) {
      if (_isVerify) {
        BmobQuery<BmobUser> query = BmobQuery();
        query.addWhereEqualTo("username", _username);
        query.queryObjects().then((data) {
          // showSuccess(context, data.toString());
          List<BmobUser> users =
          data.map((i) => BmobUser().fromJsons(i)).toList();
          BmobUser local = users[0];
          local.password=phoneController.text;
          local.update().then((BmobUpdated bmobUpdated) {
            UserHelper().bmobUserVM.bmobUserModel = local;
            setState(() {});
            showToast('更换密码成功！');
            Navigator.of(context).pop();
            Navigator.of(context).pushNamed(RouteName.login_phone_page);
          }).catchError((e) {
            showToast('更换密码失败！');
          });
        }).catchError((e) {
          showToast('网络错误');
        });
      } else {
        BmobQuery<BmobUser> query = BmobQuery();
        query.addWhereEqualTo("username", _username);
        query.queryObjects().then((data) {
          // showSuccess(context, data.toString());
          List<BmobUser> users =
          data.map((i) => BmobUser().fromJsons(i)).toList();
          BmobUser local = users[0];
          if (local.mobilePhoneNumber == phoneController.text) {
            setState(() {
              _isVerify = true;
              phoneController.text = "";
            });
          } else {
            showToast('手机号错误');
          }
        }).catchError((e) {
          showToast('网络错误');
        });
      }
    }
  }

  bool checkInfo() {
    if (!_isVerify) {
      if (phoneController.text.length != 11) {
        showToast(JYLocalizations.localizedString("请输入正确的手机号"));
        return false;
      }
      return true;
    } else {
      if (phoneController.text.length < 6) {
        showToast(JYLocalizations.localizedString("密码长度过低"));
        return false;
      }
      return true;
    }
  }

  _addListener() {
    phoneController.addListener(() {
      setState(() {});
      if (phoneController.text.length > 0) {
        textState = true;
      } else {
        textState = false;
      }
    });
    return textState;
  }
}
