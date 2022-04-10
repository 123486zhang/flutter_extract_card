import 'dart:io';

import 'package:flutter/material.dart';
import 'package:graphic_conversion/locatization/localizations.dart';
import 'package:graphic_conversion/router/router_config.dart';
import 'package:graphic_conversion/ui/helper/buried_point_helper.dart';
import 'package:graphic_conversion/ui/helper/resoure_helper.dart';

class VipDialog extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        type: MaterialType.transparency,
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(15)),
              color: Colors.white),
          margin: EdgeInsets.only(top: 45),
          width: 300,
          child: Stack(
            alignment: Alignment.topRight,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 37,),
                  TextHelper.TextCreateWith(
                    text: "开通VIP会员",
                    fontSize: 20,
                    isBlod: true,
                    color: Colors.black,
                  ),
                  SizedBox(height: 23,),
                  Text.rich(
                    TextSpan(
                      text: JYLocalizations.localizedString('普通用户可免费使用'),
                      style: TextStyle(
                          fontSize: 18, color: Colors.black),
                      children: <TextSpan>[
                        TextSpan(
                          text: JYLocalizations.localizedString('一次'),
                          style:
                          TextStyle(fontSize: 18, color: Color(0xFFFD0000)),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10,),
                  Text.rich(
                    TextSpan(
                      text: JYLocalizations.localizedString('开通VIP会员可'),
                      style: TextStyle(
                          fontSize: 18, color: Colors.black),
                      children: <TextSpan>[
                        TextSpan(
                          text: JYLocalizations.localizedString('无限次识别'),
                          style:
                          TextStyle(fontSize: 18, color: Color(0xFFFD0000)),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      BuriedPointHelper.clickBuriedPoint(
                        pageName: "提醒页面",
                        clickName: "开通会员",
                      );
                      if(Platform.isIOS) {
                        Navigator.of(context).pushReplacementNamed(RouteName.vip_apple_page, arguments: {
                          "isBack": true,
                        });
                      } else {
                        Navigator.of(context).pushReplacementNamed(RouteName.vip_android_page,  arguments: {
                          "from": 1,
                        });
                      }
                    },
                    child: Container(
                      margin: EdgeInsets.only(top: 32, left: 50, right: 50, bottom: 28),
                      height: 44,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Color(0xFF00C27C),
                          borderRadius:
                          BorderRadius.all(Radius.circular(93))),
                      child: TextHelper.TextCreateWith(
                        text: "开通VIP",
                        fontSize: 16,
                        isBlod: true,
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              ),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Container(
                  width: 50,
                  height: 50,
                  alignment: Alignment.center,
                  child: Image.asset(
                    ImageHelper.imageRes("vip_close.png"),
                    width: 16,
                    height: 16,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
