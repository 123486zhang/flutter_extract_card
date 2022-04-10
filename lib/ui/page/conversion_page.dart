import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graphic_conversion/data/net/conversion_api.dart';
import 'package:graphic_conversion/data/net/fizz_api.dart';
import 'package:graphic_conversion/model/document_model.dart';
import 'package:graphic_conversion/router/router_config.dart';
import 'package:graphic_conversion/ui/helper/buried_point_helper.dart';
import 'package:graphic_conversion/ui/helper/dialog_helper.dart';
import 'package:graphic_conversion/ui/helper/resoure_helper.dart';
import 'package:graphic_conversion/ui/helper/user_helper.dart';
import 'package:graphic_conversion/utils/common_utils.dart';
import 'package:oktoast/oktoast.dart';

class ConversionPage extends StatefulWidget {

  final String imagePath;

  final VoidCallback callback;

  final int index;

  ConversionPage({this.imagePath, this.callback, this.index});

  @override
  _ConversionPageState createState() => _ConversionPageState();
}

class _ConversionPageState extends State<ConversionPage> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF242424),
      body: Column(
        children: [
          Expanded(child: Image.file(File(widget.imagePath), fit: BoxFit.contain,)),
          Container(
            padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(15)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    BuriedPointHelper.clickBuriedPoint(
                      pageName: "识别页面",
                      clickName: "重拍",
                    );
                    Navigator.of(context).pop();
                    if (widget.callback != null) {
                      widget.callback();
                    }
                  },
                  child: Container(
                    width: ScreenUtil().setWidth(112),
                    height: ScreenUtil().setHeight(50),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(93)),
                        color: Colors.white
                    ),
                    child: TextHelper.TextCreateWith(
                      text: widget.index == 0 ? "重拍" : "重选",
                      fontSize: 16,
                      color: Color(0xFF376DF7),
                      isBlod: true,
                    ),
                  ),
                ),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: _conversion,
                  child: Container(
                    width: ScreenUtil().setWidth(221),
                    height: ScreenUtil().setHeight(50),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(93)),
                      color: Color(0xFF376DF7)
                    ),
                    child: TextHelper.TextCreateWith(
                      text: "开始识别",
                      fontSize: 16,
                      color: Colors.white,
                      isBlod: true,
                    ),
                  ),
                )
              ],
            ),
          ),
          SizedBox(height: ScreenUtil().setWidth(55),)
        ],
      ),
    );
  }

  _conversion() async {
    BuriedPointHelper.clickBuriedPoint(
      pageName: "识别页面",
      clickName: "开始识别",
    );
    if (!await CommonUtils.isLogin(context)) return;
    if (!UserHelper().userVM.isVip) {
      bool isCanUse = await FIZZApi.requestFunctionCanUse();
      if (!isCanUse) {
        DialogHelper.showVipDialog(context);
        return;
      }
    }
    EasyLoading.show(status: "正在识别中，请稍等");
    File file = File(widget.imagePath);
    Uint8List bytes = await file.readAsBytes();
    String base64 = base64Encode(bytes);
    int quality=100;
    while (base64.length > 4000000) {
      debugPrint("压缩前：${base64.length}");
      bytes = await FlutterImageCompress.compressWithList(bytes, quality: quality);
      base64 = base64Encode(bytes);
      debugPrint("压缩后：${base64.length}");
      quality=quality-5;
    }
    ConversionApi.requestRecognition(image: base64).then((value) {
      EasyLoading.dismiss();
      FIZZApi.requestFunctionSave();
      if (value == null) {
        showToast("识别失败，请重拍");
      }
      var content = "";
      for (Map map in value["words_result"]) {
        content = content + map["words"] + "\n";
      }
      DocumentModel model = DocumentModel();
      model.title = "文档";
      model.content = content;
      model.imagePath = widget.imagePath;
      Navigator.of(context).pushNamed(
        RouteName.document_page,
        arguments: {
          "model": model,
          "index": -1,
        }
      );
    });
  }

  Future<String> _compress(Uint8List image) async {
    Uint8List bytes = await FlutterImageCompress.compressWithList(image, quality: 50);
    String base64 = base64Encode(bytes);
    return base64;
  }
}
