import 'dart:io';

import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:graphic_conversion/channel/android_method_channel.dart';
import 'package:graphic_conversion/configs.dart';
import 'package:graphic_conversion/ui/helper/resoure_helper.dart';
import 'package:graphic_conversion/ui/widget/navigation_back_button.dart';

class AboutUsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorHelper.color_bg,
      appBar: AppBar(
        backgroundColor: Color(0xFFFFFFFF),
        leading: NabigationBackButton.back(context),
        centerTitle: true,
        title: TextHelper.TextCreateWith(
            text: "关于我们",
            fontSize: 18,
            color: ColorHelper.color_333,
            isBlod: true
        ),
        elevation: 0,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: 50,
          ),
          ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            child: Image.asset(
              ImageHelper.imageRes('ic_logo.png'),
              fit: BoxFit.fill,
              width: 106,
              height: 106,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 14, bottom: 58),
            child: Text(
              Configs.appName,
              style: TextStyle(fontSize: 18, color: ColorHelper.color_333),
            ),
          ),
          GestureDetector(
            onDoubleTap: () {
              if (Platform.isAndroid) {
                // AndroidMethodChannel.getPluginVersion().then((version) {
                //   showToast('内部版本: $version');
                // });
              }
            },
            child: Container(
              color: Color(0xFFEEEEEE),
              height: 72,
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextHelper.TextCreateWith (text:
                  '版本号',
                    color: ColorHelper.color_333, fontSize: 16,),
                  Text(
                      '${Configs.versionName}',
                      style: TextStyle(color: ColorHelper.color_333, fontSize: 16,))
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
