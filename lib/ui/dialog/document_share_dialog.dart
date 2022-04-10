import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluwx/fluwx.dart';
import 'package:graphic_conversion/ui/helper/buried_point_helper.dart';
import 'package:graphic_conversion/ui/helper/resoure_helper.dart';

typedef DocumentShareCallback = void Function(int index);

class DocumentShareDialog extends StatelessWidget {

  final File file;

  final DocumentShareCallback callback;

  DocumentShareDialog({this.file, this.callback});

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
              borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: ScreenUtil().setHeight(20),),
                Container(
                  alignment: Alignment.topCenter,
                  child: TextHelper.TextCreateWith(
                    text: "选择分享方式",
                    color: Color(0xFF666666),
                    fontSize: 15,
                    isBlod: false,
                  ),
                ),
                SizedBox(height: ScreenUtil().setHeight(30),),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(20)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          _clickButton(context, 0);
                          _shareWeChatSession();
                        },
                        child: Container(
                          alignment: Alignment.center,
                          child: Column(
                            children: [
                              Image.asset(
                                ImageHelper.imageRes("share_wechat_session.png"),
                                width: ScreenUtil().setWidth(35),
                                height: ScreenUtil().setHeight(35),
                              ),
                              SizedBox(height: ScreenUtil().setHeight(5),),
                              TextHelper.TextCreateWith(
                                  text: "发给微信好友",
                                  fontSize: 12,
                                  color: ColorHelper.color_666
                              )
                            ],
                          ),
                        ),
                      ),
                      // GestureDetector(
                      //   onTap: () {
                      //     _clickButton(context, 1);
                      //     _shareWeChatTimeline();
                      //   },
                      //   child: Container(
                      //     alignment: Alignment.center,
                      //     child: Column(
                      //       children: [
                      //         Image.asset(
                      //           ImageHelper.imageRes("share_wechat_timeline.png"),
                      //           width: 45,
                      //           height: 45,
                      //         ),
                      //         SizedBox(height: 10,),
                      //         TextHelper.TextCreateWith(
                      //             text: "朋友圈",
                      //             fontSize: 12,
                      //             color: ColorHelper.color_666
                      //         )
                      //       ],
                      //     ),
                      //   ),
                      // ),
                      GestureDetector(
                        onTap: () {
                          _clickButton(context, 2);
                          _shareWeChatFavorite();
                        },
                        child: Container(
                          alignment: Alignment.center,
                          child: Column(
                            children: [
                              Image.asset(
                                ImageHelper.imageRes("share_wechat_favorite.png"),
                                width: ScreenUtil().setWidth(35),
                                height: ScreenUtil().setHeight(35),
                              ),
                              SizedBox(height: ScreenUtil().setHeight(5),),
                              TextHelper.TextCreateWith(
                                  text: "微信收藏",
                                  fontSize: 12,
                                  color: ColorHelper.color_666
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: ScreenUtil().setHeight(30),),
                GestureDetector(
                  child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        color: Color(0xFFF3F5F7),
                      ),
                      margin: EdgeInsets.only(left: ScreenUtil().setWidth(93),right: ScreenUtil().setWidth(93),bottom: ScreenUtil().setHeight(49)),
                      height: ScreenUtil().setHeight(45),
                      alignment: Alignment.center,
                      child: TextHelper.TextCreateWith(
                        text: "取消",
                        color: Color(0xFF333333),
                        fontSize: 15,
                      )
                  ),
                  onTap: () {
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

  /// 分享微信好友
  _shareWeChatSession() async {
    shareToWeChat(WeChatShareFileModel(
        WeChatFile.file(file, suffix: ".txt"),
        scene: WeChatScene.SESSION),
    );
  }
  /// 分享微信朋友圈
  _shareWeChatTimeline() async {
    shareToWeChat(WeChatShareFileModel(
        WeChatFile.file(file, suffix: ".txt"),
        scene: WeChatScene.TIMELINE)
    );
  }

  /// 分享微信收藏
  _shareWeChatFavorite() async {
    shareToWeChat(WeChatShareFileModel(
        WeChatFile.file(file, suffix: ".txt"),
        scene: WeChatScene.FAVORITE)
    );
  }
}
