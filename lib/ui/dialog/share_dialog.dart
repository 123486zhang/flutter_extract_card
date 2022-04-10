import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluwx/fluwx.dart';
import 'package:graphic_conversion/channel/android_method_channel.dart';
import 'package:graphic_conversion/ui/helper/resoure_helper.dart';

class ShareDialog extends StatefulWidget {

  final String shareImage;

  ShareDialog({this.shareImage});

  @override
  _ShareDialogState createState() => _ShareDialogState();
}

class _ShareDialogState extends State<ShareDialog> {
  @override
  Widget build(BuildContext context) {
    var shareButtonWidth = (MediaQuery.of(context).size.width) / 2;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Color(0xFF282E50),
              borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 20,),
                TextHelper.TextCreateWith(
                  text: "请选择分享方式",
                  color: Color(0xFFFFFFFF),
                  fontSize: 16,
                  isBlod: true,
                ),
                SizedBox(height: 25,),
                Row(
                  children: [
                    GestureDetector(
                      onTap: _shareWeChatSession,
                      child: Container(
                        alignment: Alignment.center,
                        width: shareButtonWidth,
                        child: Column(
                          children: [
                            Image.asset(
                              ImageHelper.imageRes("share_wx_hy.png"),
                              width: 52,
                              height: 52,
                            ),
                            SizedBox(height: 10,),
                            TextHelper.TextCreateWith(
                              text: "微信好友",
                            )
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: _shareWeChatTimeline,
                      child: Container(
                        alignment: Alignment.center,
                        width: shareButtonWidth,
                        child: Column(
                          children: [
                            Image.asset(
                              ImageHelper.imageRes("share_wx_pyq.png"),
                              width: 52,
                              height: 52,
                            ),
                            SizedBox(height: 10,),
                            TextHelper.TextCreateWith(
                              text: "微信朋友圈",
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 20,),
                GestureDetector(
                  child: Container(
                      decoration: BoxDecoration(
                        color: Color(0xFF262B49),
                      ),
                      height: 58,
                      alignment: Alignment.center,
                      child: TextHelper.TextCreateWith(
                        text: "取消分享",
                        color: Color(0xFFA9AAB3),
                        fontSize: 16,
                        isBlod: true,
                      )
                  ),
                  onTap: () => Navigator.of(context).pop(),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 分享微信好友
  _shareWeChatSession() async {
    if (Platform.isIOS) {
      shareToWeChat(WeChatShareImageModel(
          WeChatImage.asset(ImageHelper.imageRes(widget.shareImage), suffix: ".png"),
          scene: WeChatScene.SESSION),
      );
    } else {
      var data = await DefaultAssetBundle.of(context).load(ImageHelper.imageRes(widget.shareImage));
      AndroidMethodChannel.shareImage(data.buffer.asUint8List(), 1);
    }
  }
  /// 分享微信朋友圈
  _shareWeChatTimeline() async {
    if (Platform.isIOS) {
      shareToWeChat(WeChatShareImageModel(
          WeChatImage.asset(ImageHelper.imageRes(widget.shareImage), suffix: ".png"),
          scene: WeChatScene.TIMELINE)
      );
    } else {
      var data = await DefaultAssetBundle.of(context).load(ImageHelper.imageRes(widget.shareImage));
      AndroidMethodChannel.shareImage(data.buffer.asUint8List(), 2);
    }
  }
}
