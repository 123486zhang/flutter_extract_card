import 'dart:io';

import 'package:graphic_conversion/channel/android_method_channel.dart';
import 'package:graphic_conversion/ui/helper/buried_point_helper.dart';
import 'package:graphic_conversion/ui/helper/resoure_helper.dart';
import 'package:flutter/material.dart';
import 'package:fluwx/fluwx.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

typedef ClickCallback = void Function(int index);

class SaveDialog extends StatelessWidget {

  final ClickCallback callback;

  SaveDialog({this.callback});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 20,),
                TextHelper.TextCreateWith(
                  text: "选择保存方式",
                  color: Color(0xFF666666),
                  fontSize: 15,
                  isBlod: true,
                ),
                SizedBox(height: 25,),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          _clickButton(context, 0);
                        },
                        child: Container(
                          alignment: Alignment.center,
                          child: Column(
                            children: [
                              Image.asset(
                                ImageHelper.imageRes("save_email.png"),
                                width: 53,
                                height: 51,
                              ),
                              SizedBox(height: 10,),
                              TextHelper.TextCreateWith(
                                text: "发送到邮箱",
                                fontSize: 12,
                                color: ColorHelper.color_666
                              )
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          _clickButton(context, 1);
                        },
                        child: Container(
                          alignment: Alignment.center,
                          child: Column(
                            children: [
                              Image.asset(
                                ImageHelper.imageRes("save_album.png"),
                                width: 45,
                                height: 45,
                              ),
                              SizedBox(height: 10,),
                              TextHelper.TextCreateWith(
                                text: "保存到本地",
                                fontSize: 12,
                                color: ColorHelper.color_666
                              )
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          _clickButton(context, 2);
                        },
                        child: Container(
                          alignment: Alignment.center,
                          child: Column(
                            children: [
                              Image.asset(
                                ImageHelper.imageRes("save_wechat.png"),
                                width: 45,
                                height: 45,
                              ),
                              SizedBox(height: 10,),
                              TextHelper.TextCreateWith(
                                text: "发送到微信",
                                fontSize: 12,
                                color: ColorHelper.color_666
                              )
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {

                        },
                        child: Container(
                          width: 45,
                          height: 45,
                          alignment: Alignment.center,
                          child: Column(
                            children: [
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 20,),
                GestureDetector(
                  child: Container(
                      decoration: BoxDecoration(
                        color: Color(0xFFF3F5F7),
                      ),
                      height: 58,
                      alignment: Alignment.center,
                      child: TextHelper.TextCreateWith(
                        text: "取消",
                        color: Color(0xFF333333),
                        fontSize: 15,
                      )
                  ),
                  onTap: () {
                    BuriedPointHelper.clickBuriedPoint(
                      pageName: "订单详情页",
                      clickName: "取消",
                    );
                    Navigator.of(context).pop();
                  },
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  _clickButton(BuildContext context, int index) {
    Navigator.of(context).pop();
    if (callback != null) {
      callback(index);
    }
  }
}
