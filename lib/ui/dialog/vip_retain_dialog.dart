import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graphic_conversion/locatization/localizations.dart';
import 'package:graphic_conversion/ui/helper/resoure_helper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class VipRetainDialog extends StatefulWidget {
  const VipRetainDialog({
    Key key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return VipRetainDialogState();
  }
}

class VipRetainDialogState extends State<VipRetainDialog> {
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
          width: ScreenUtil().setWidth(315),
          height: ScreenUtil().setHeight(313),
          child: Column(
            children: <Widget>[
              Stack(
                children: [
                  Container(
                        width: ScreenUtil().setWidth(315),
                        height: ScreenUtil().setHeight(223),
                    alignment: Alignment.topLeft,
                    decoration: BoxDecoration(
                        color: Color(0xFFFDF7E9),
                        borderRadius:
                        BorderRadius.only(topLeft: Radius.circular(15),topRight: Radius.circular(15))),
                    // child: Image.asset(ImageHelper.imageRes('open_vip_bg.png'),
                    //     width: ScreenUtil().setWidth(315),
                    //     height: ScreenUtil().setHeight(243),
                    //     fit: BoxFit.fill),
                    child: Column(
                      children: [
                        SizedBox(height: 30,),
                      Row(
                        mainAxisAlignment:MainAxisAlignment.center,
                        children: [   TextHelper.TextCreateWith(
                        text: '您真的要放弃购买会员吗?',
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF383838),
                      ),],),
                        SizedBox(height: 20,),
                        Row(
                          mainAxisAlignment:MainAxisAlignment.center,
                          children: [
                            Container(width: 40,
                            height: 1,
                            color: Color(0xFFEEE1C8),),
                            SizedBox(width: 5,),
                            TextHelper.TextCreateWith(
                            text: '您可能会错过以下权益',
                            fontSize: 18,
                            color: Color(0xFF565754),
                          ),
                            SizedBox(width: 5,),
                            Container(width: 40,
                              height: 1,
                              color: Color(0xFFEEE1C8),),
                          ],),
                        SizedBox(height: 20,),
                    Container(
                      margin: EdgeInsets.only(
                        right: ScreenUtil().setWidth(15),
                        left: ScreenUtil().setWidth(15),
                      ),
                      height: ScreenUtil().setHeight(70),
                      width: ScreenUtil().setWidth(280),
                      alignment: Alignment(0, 0),
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: ColorHelper.colors_VipGradient),
                          borderRadius:
                          BorderRadius.all(Radius.circular(10))),
                      child: Stack(children: [
                        Row(
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: ScreenUtil().setHeight(3),left: 20),
                              child: Image.asset(
                                ImageHelper.imageRes("icon_items.png"),
                                width: ScreenUtil().setWidth(45),
                                height: ScreenUtil().setHeight(45),
                              ),
                            ),
                            SizedBox(
                              width: ScreenUtil().setWidth(15),
                            ),
                            Container(
                              alignment: Alignment.center,
                              child: Column(
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(top: ScreenUtil().setHeight(14)),
                                    child: TextHelper.TextCreateWith(
                                      text: "使用所有功能          ",
                                      fontSize: 15,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(top: ScreenUtil().setHeight(2)),
                                    child: TextHelper.TextCreateWith(
                                      text: "每日签到赠送500代币",
                                      fontSize: 13,
                                      color: Color(0xFFC29647),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],),
                    ),
                    ],),
                  ),
                  Container(
                    child: GestureDetector(
                      onTap: () async {
                        Navigator.of(context).pop(true);
                      },
                        child: Container(
                          margin: EdgeInsets.only(
                              top: ScreenUtil().setHeight(10),
                              left: ScreenUtil().setWidth(285)),
                          alignment: Alignment.topLeft,
                          child: Image.asset(
                              ImageHelper.imageRes('retain_dialog_close.png'),
                              width: ScreenUtil().setWidth(20),
                              height: ScreenUtil().setHeight(20),
                              fit: BoxFit.fill),
                        ),
                    ),
                  ),
                ],
              ),
              Container(
                child: GestureDetector(
                  onTap: () async {
                    Navigator.of(context).pop(false);
                  },
                  child: Container(
                    margin: EdgeInsets.only(
                      top: ScreenUtil().setHeight(25),
                      right: ScreenUtil().setWidth(68),
                      left: ScreenUtil().setWidth(68),
                    ),
                    height: ScreenUtil().setHeight(45),
                    width: ScreenUtil().setWidth(180),
                    alignment: Alignment(0, 0),
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: ColorHelper.colors_VipBtnGradient),
                        borderRadius:
                        BorderRadius.all(Radius.circular(55))),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          JYLocalizations.localizedString('继续开通'),
                          style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF512C19)),
                        ),
                      ],
                    ),
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
