import 'dart:io';

import 'package:flutter/material.dart';
import 'package:graphic_conversion/model/buried_point_model.dart';
import 'package:graphic_conversion/ui/helper/buried_point_helper.dart';
import 'package:graphic_conversion/ui/helper/dialog_helper.dart';
import 'package:graphic_conversion/ui/helper/resoure_helper.dart';
import 'package:graphic_conversion/ui/widget/navigation_back_button.dart';

class SharePage extends StatefulWidget {
  @override
  _SharePageState createState() => _SharePageState();
}

class _SharePageState extends State<SharePage> {

  var shareImage = Platform.isIOS ? 'share_apple.png' : 'share_android.png';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    BuriedPointHelper.addBuriedPoint(
      eventType: BuriedPointEventType.PAGE_SHOW,
      pageName: "我的页面-分享给好友",
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    BuriedPointHelper.addBuriedPoint(
      eventType: BuriedPointEventType.PAGE_HIDE,
      pageName: "我的页面-分享给好友",
    );
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ColorHelper.color_bg,
        appBar: AppBar(
          backgroundColor: ColorHelper.color_bg,
          brightness: Brightness.dark,
          leading: NabigationBackButton.back(context),
          centerTitle: true,
          title: TextHelper.TextCreateWith(
              text: "分享给好友",
              fontSize: 18,
              color: Colors.white,
              isBlod: true
          ),
          elevation: 0.5,
        ),
        body: SafeArea(
          child: Container(
              child: Stack(
                children: [
                  ListView(
                    children: [
                      SizedBox(height: 10,),
                      Container(
                        padding: EdgeInsets.only(left: 15),
                        child: TextHelper.TextCreateWith(
                          text: "二维码分享",
                          fontSize: 16,
                          color: Color(0xCCFFFFFF),
                        ),
                      ),
                      Container(
                        width: 375,
                        // alignment: Alignment.center,
                        // width: 375,
                        child: Image.asset(
                          ImageHelper.imageRes(shareImage),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Container(
                      alignment: Alignment.bottomCenter,
                      child: GestureDetector(
                        onTap: () {
                          BuriedPointHelper.clickBuriedPoint(
                            pageName: "我的页面-分享给好友",
                            clickName: "分享给我的好友",
                          );
                          DialogHelper.showShareDialog(context, shareImage: shareImage);
                        },
                        child: Container(
                          margin: EdgeInsets.only(
                              bottom: 20, left: 25, right: 25, top: 20),
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Color(0xFFB39FFC), Color(0xFF7B69CE)]
                              ),
                              borderRadius: BorderRadius.all(Radius.circular(110))),
                          alignment: Alignment.center,
                          height: 46,
                          child: TextHelper.TextCreateWith(
                              text: '分享给我的好友', fontSize: 17, isBlod: true, color: Colors.white),
                        ),
                      ),
                    ),
                  )
                ],
              )
          ),
        ));
  }
}
