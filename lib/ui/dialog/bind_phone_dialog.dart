import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graphic_conversion/locatization/localizations.dart';
import 'package:graphic_conversion/router/router_config.dart';
import 'package:graphic_conversion/ui/helper/buried_point_helper.dart';
import 'package:graphic_conversion/ui/helper/resoure_helper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graphic_conversion/ui/helper/user_helper.dart';

class BindPhoneDialog extends StatefulWidget {
  const BindPhoneDialog({
    Key key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return BindPhoneDialogState();
  }
}

class BindPhoneDialogState extends State<BindPhoneDialog> {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Material(
      type: MaterialType.transparency,
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xFFFFFFFF),
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        child: Container(
          width: ScreenUtil().setWidth(335),
          height: ScreenUtil().setHeight(320),
          child: Column(
            children: <Widget>[
              GestureDetector(
                onTap: () async {
                  Navigator.of(context).pop(true);
                },
                child: Container(
                  margin: EdgeInsets.only(
                      top: ScreenUtil().setHeight(10),
                      right: ScreenUtil().setWidth(10)),
                  alignment: Alignment.topRight,
                  child: Image.asset(
                      ImageHelper.imageRes('retain_dialog_close.png'),
                      width: ScreenUtil().setWidth(20),
                      height: ScreenUtil().setHeight(20),
                      fit: BoxFit.fill),
                ),
              ),
              Container(
                alignment: Alignment.topCenter,
                margin: EdgeInsets.only(
                    left: ScreenUtil().setWidth(105),
                    right: ScreenUtil().setWidth(108)),
                child: Image.asset(
                    ImageHelper.imageRes('ic_bind_phone_top.png'),
                    width: ScreenUtil().setWidth(120),
                    height: ScreenUtil().setHeight(120),
                    fit: BoxFit.fill),
              ),
              Container(
                alignment: Alignment.topCenter,
                child: TextHelper.TextCreateWith(
                  text: "绑定手机号",
                  fontSize: 19,
                  color: Color(0xFF333333),
                  isBlod: true,
                ),
              ),
              Container(
                alignment: Alignment.topCenter,
                margin: EdgeInsets.only(
                    top: ScreenUtil().setHeight(5),
                    left: ScreenUtil().setWidth(59),
                    right: ScreenUtil().setWidth(59)),
                child: TextHelper.TextCreateWith(
                  text: "防止账号丢失及方便找回\n       建议您绑定手机号",
                  fontSize: 17,
                  color: Color(0xFF666666),
                ),
              ),
              GestureDetector(
                onTap: () async {
                  if (!UserHelper().bmobUserVM.hasUser) {
                    Navigator.of(context).pushNamed(RouteName.login);
                  } else {
                    BuriedPointHelper.clickBuriedPoint(
                      pageName: "我的页面",
                      clickName: "绑定手机号",
                    );
                    Navigator.of(context)
                        .pushReplacementNamed(RouteName.bind_phone_page);
                  }
                },
                child: Container(
                  margin: EdgeInsets.only(
                    top: ScreenUtil().setHeight(20),
                    right: ScreenUtil().setWidth(83),
                    left: ScreenUtil().setWidth(82),
                  ),
                  height: ScreenUtil().setHeight(45),
                  width: ScreenUtil().setWidth(170),
                  alignment: Alignment(0, 0),
                  decoration: BoxDecoration(
                      color: Color(0xFF00C27C),
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        JYLocalizations.localizedString('立即绑定'),
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFFFFFFFF)),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
