import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluwx/fluwx.dart';
import 'package:graphic_conversion/data/net/conversion_api.dart';
import 'package:graphic_conversion/ui/helper/buried_point_helper.dart';
import 'package:graphic_conversion/ui/helper/resoure_helper.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';

import '../../data/net/download_api.dart';
import '../manager/cache_audio_manager.dart';

typedef DocumentShareCallback1 = void Function(int index);

class DocumentShareDialog1 extends StatefulWidget {
  final File file;
  final List<TextEditingController> contentControllers;
  final List<TextEditingController> translateControllers;
  final DocumentShareCallback1 callback;
  final String title;

  DocumentShareDialog1(
      {this.file,
      this.contentControllers,
      this.translateControllers,
      this.callback,
      this.title});

  @override
  _DocumentShareDialog1State createState() => _DocumentShareDialog1State();
}

class _DocumentShareDialog1State extends State<DocumentShareDialog1> {
  File file;

  DocumentShareCallback1 callback;

  int _selectedColorIndex = 0;

  int _selectedIndex = 0;

  String title;

  BuildContext _context;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    file = widget.file;
    title = widget.title;
    callback = widget.callback;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _context = null;
    super.dispose();
  }

  Widget buildSelectedItem(int i) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      child: Container(
          width: 120,
          height: 40,
          alignment: Alignment.center,
          child: Column(
            children: [
              TextHelper.TextCreateWith(
                text: i == 0 ? "Txt分享" : "Word分享",
                color: Color(0xFF333333),
                fontSize: 15,
              ),
              Container(
                margin: EdgeInsets.only(
                  top: 14,
                ),
                width: 24,
                height: 3,
                decoration: BoxDecoration(
                  color: _selectedColorIndex == i
                      ? Color(0xFF2F68F8)
                      : Colors.transparent,
                ),
              )
            ],
          )),
      onTap: () {
        setState(() {
          _selectedColorIndex = i;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    _context = context;
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // SizedBox(height: 28,),
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    alignment: Alignment.topCenter,
                    child: TextHelper.TextCreateWith(
                        text: '选择分享方式',
                        isBlod:true,
                        color: Color(0xFF666666),
                        fontSize: 15),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedIndex = 0;
                          });
                        },
                        child: Container(
                          margin: EdgeInsets.only(top: 25),
                          alignment: Alignment.center,
                          height: 75,
                          width: 140,
                          decoration: BoxDecoration(
                              color: _selectedIndex == 0
                                  ? Color(0xFF00C27C)
                                  : Color(0x1900C27C),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          child: TextHelper.TextCreateWith(
                              text: 'Txt分享',
                              color: _selectedIndex == 0
                                  ? Color(0xFFFFFFFF)
                                  : Color(0xFF00C27C),
                              fontSize: 15),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedIndex = 1;
                          });
                        },
                        child: Container(
                          margin: EdgeInsets.only(top: 25),
                          alignment: Alignment.center,
                          height: 75,
                          width: 140,
                          decoration: BoxDecoration(
                              color: _selectedIndex == 1
                                  ? Color(0xFF00C27C)
                                  : Color(0x1900C27C),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          child: TextHelper.TextCreateWith(
                              text: 'Word分享',
                              color: _selectedIndex == 1
                                  ? Color(0xFFFFFFFF)
                                  : Color(0xFF00C27C),
                              fontSize: 15),
                        ),
                      ),
                    ],
                  ),

                  GestureDetector(
                    onTap: () {
                      _export();
                    },
                    child: Container(
                      margin: EdgeInsets.only(
                          top: 45, bottom: 15, left: 92, right: 92),
                      alignment: Alignment.center,
                      height: 45,
                      width: 190,
                      decoration: BoxDecoration(
                          color: Color(0xFF00C27C),
                          borderRadius: BorderRadius.all(Radius.circular(5))),
                      child: TextHelper.TextCreateWith(
                          text: '确定', color: Color(0xFFFFFFFF), fontSize: 15),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _clickButton(BuildContext context, int index) {
    Navigator.of(context).pop();
    if (callback != null) {
      callback(index);
    }
  }

  _export() async {
    if (_selectedIndex == 0) {
      //txt分享
      _onSystemShare(file.path);
      _clickButton(_context, 0);
    } else if (_selectedIndex == 1) {
      //以docx分享
      String savePath =
          '/data/user/0/com.hiyuyi.photoscan/app_flutter/DocumentCache/' +
              (DateTime.now().microsecondsSinceEpoch).toString() +
              ".docx";
      EasyLoading.show();
      await ConversionApi.requestShareDoc(
              contentControllers: widget.contentControllers,
              translateControllers: widget.translateControllers)
          .then((value) async {
        EasyLoading.dismiss();
        String docxUrl = value["data"]["data"];
        await DownloadApi.downloadDocument(docxUrl, savePath: savePath);
      });
      _onSystemShare(savePath);
      _clickButton(_context, 1);
    }
  }

  /// 分享微信朋友圈
  _shareWeChatTimeline() async {
    shareToWeChat(WeChatShareFileModel(WeChatFile.file(file, suffix: ".txt"),
        scene: WeChatScene.TIMELINE));
  }

  /// 分享微信收藏
  _shareWeChatFavorite() async {
    if (_selectedColorIndex == 0) {
      shareToWeChat(WeChatShareFileModel(WeChatFile.file(file, suffix: ".txt"),
          scene: WeChatScene.FAVORITE));
    } else {
      ConversionApi.requestShareDoc(
              contentControllers: widget.contentControllers,
              translateControllers: widget.translateControllers)
          .then((value) {
        print(value);
        String docxUrl = value["data"]["data"];
        print(docxUrl);
        shareToWeChat(
            WeChatShareWebPageModel(docxUrl, scene: WeChatScene.FAVORITE));
      });
    }
  }

  _onSystemShare(String path) async {
    List<String> list = [path];
    final RenderBox box = _context.findRenderObject() as RenderBox;
    await Share.shareFiles(list,
        text: title,
        subject: "",
        sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
  }
}
