import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:date_format/date_format.dart';
import 'package:dio/dio.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graphic_conversion/data/net/conversion_api.dart';
import 'package:graphic_conversion/data/net/fizz_api.dart';
import 'package:graphic_conversion/locatization/localizations.dart';
import 'package:graphic_conversion/model/document_model.dart';
import 'package:graphic_conversion/router/router_config.dart';
import 'package:graphic_conversion/ui/helper/buried_point_helper.dart';
import 'package:graphic_conversion/ui/helper/dialog_helper.dart';
import 'package:graphic_conversion/ui/helper/resoure_helper.dart';
import 'package:graphic_conversion/ui/helper/user_helper.dart';
import 'package:graphic_conversion/utils/common_utils.dart';
import 'package:graphic_conversion/utils/string_utils.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:oktoast/oktoast.dart';

class ConversionMultiPage extends StatefulWidget {
  final List<String> photos;

  final int translateTelephoneEnabledType;

  ConversionMultiPage({this.photos, this.translateTelephoneEnabledType=-1});

  @override
  _ConversionMultiPageState createState() => _ConversionMultiPageState();
}

class _ConversionMultiPageState extends State<ConversionMultiPage> {
  int _currentIndex = 0;

  List<String> _photos = [];

  List<String> _contents = [];

  List<CancelToken> _cancelTokens = [];

  int _conversionCount = 0;

  PageController _pageController = PageController();

  String _pageName = "";

  bool _isConversing=false;

  List<Map<String, dynamic>> _results = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _pageName = widget.photos.length == 1 ? "单张预览页" : "多张预览页";

    _photos = widget.photos;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return _goBack();
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Column(
            children: [
              // buildNavigator(),
              Expanded(child: buildPhotoContent()),
              buildBottomTool(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildNavigator() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          height: ScreenUtil().setHeight(50),
          margin: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(100)),
          alignment: Alignment.center,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {},
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // TextHelper.TextCreateWith(
                //   text: "台本编辑",
                //   fontSize: 18,
                //   color: Colors.black,
                //   isBlod: true,
                // ),
              ],
            ),
          ),
        ),
        Positioned(
          left: 0,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: _goBack,
            child: Container(
              height: ScreenUtil().setHeight(50),
              padding: EdgeInsets.only(left: ScreenUtil().setWidth(10)),
              alignment: Alignment.centerLeft,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    ImageHelper.imageRes('vip_navigator_back.png'),
                    width: ScreenUtil().setWidth(22),
                    height: ScreenUtil().setHeight(22),
                  ),
                  TextHelper.TextCreateWith(
                    text: "上一步",
                    fontSize: 15,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ),
        ),
        // Positioned(
        //   right: 0,
        //   child: GestureDetector(
        //     behavior: HitTestBehavior.opaque,
        //     onTap: _clickRightButton,
        //     child: Container(
        //       height: 50,
        //       padding: EdgeInsets.symmetric(horizontal: 20),
        //       alignment: Alignment.center,
        //       child: widget.index == -1
        //           ? TextHelper.TextCreateWith(
        //           text: "保存",
        //           fontSize: 16,
        //           color: Color(0xFFFD3B50)
        //       )
        //           : Image.asset(
        //         ImageHelper.imageRes("script_edit_delete.png"),
        //         width: 22,
        //         height: 22,
        //       ),
        //     ),
        //   ),
        // ),
      ],
    );
  }

  Widget buildPhotoContent() {
    return Container(
      color: Color(0xFF303135),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            padding: EdgeInsets.only(
                top: ScreenUtil().setHeight(105),
                bottom: ScreenUtil().setHeight(87)),
            child: PageView.builder(
                itemCount: _photos.length,
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                itemBuilder: (ctx, index) {
                  return buildPhotoItem(index);
                }),
          ),
          // //边框线
          // Positioned(
          //   right: 50,
          //   top: 105,
          //   child: Container(
          //     width: 275,
          //     height: 405,
          //     decoration: BoxDecoration(
          //       border: Border.all(color: Color(0xFF00C27C), width: 3.0),
          //     ),
          //   ),
          // ),
          // //左上角
          // Positioned(
          //   left: 45,
          //   top: 100,
          //   child: Container(
          //     width: 16,
          //     height: 16,
          //     decoration: BoxDecoration(
          //       borderRadius: BorderRadius.all(Radius.circular(10)),
          //       color: Color(0xFF00C27C),
          //     ),
          //   ),
          // ),
          // //右上角
          // Positioned(
          //   right: 45,
          //   top: 100,
          //   child: Container(
          //     width: 16,
          //     height: 16,
          //     decoration: BoxDecoration(
          //       borderRadius: BorderRadius.all(Radius.circular(10)),
          //       color: Color(0xFF00C27C),
          //     ),
          //   ),
          // ),
          // //左下角
          // Positioned(
          //   left: 45,
          //   bottom: 80,
          //   child: Container(
          //     width: 16,
          //     height: 16,
          //     decoration: BoxDecoration(
          //       borderRadius: BorderRadius.all(Radius.circular(10)),
          //       color: Color(0xFF00C27C),
          //     ),
          //   ),
          // ),
          // //右下角
          // Positioned(
          //   right: 45,
          //   bottom: 80,
          //   child: Container(
          //     width: 16,
          //     height: 16,
          //     decoration: BoxDecoration(
          //       borderRadius: BorderRadius.all(Radius.circular(10)),
          //       color: Color(0xFF00C27C),
          //     ),
          //   ),
          // ),
          // //上
          // Positioned(
          //   top: 100,
          //   child: Container(
          //     alignment: Alignment.topCenter,
          //     width: 65,
          //     height: 12,
          //     decoration: BoxDecoration(
          //       borderRadius: BorderRadius.all(Radius.circular(29)),
          //       color: Color(0xFF00C27C),
          //     ),
          //   ),
          // ),
          //
          // //下
          // Positioned(
          //   bottom: 80,
          //   child: Container(
          //     alignment: Alignment.topCenter,
          //     width: 65,
          //     height: 12,
          //     decoration: BoxDecoration(
          //       borderRadius: BorderRadius.all(Radius.circular(29)),
          //       color: Color(0xFF00C27C),
          //     ),
          //   ),
          // ),
          //
          // //左
          // Positioned(
          //   left: 45,
          //   child: Container(
          //     alignment: Alignment.centerLeft,
          //     width: 12,
          //     height: 65,
          //     decoration: BoxDecoration(
          //       borderRadius: BorderRadius.all(Radius.circular(29)),
          //       color: Color(0xFF00C27C),
          //     ),
          //   ),
          // ),
          //
          // //右
          // Positioned(
          //   right: 45,
          //   child: Container(
          //     alignment: Alignment.centerLeft,
          //     width: 12,
          //     height: 65,
          //     decoration: BoxDecoration(
          //       borderRadius: BorderRadius.all(Radius.circular(29)),
          //       color: Color(0xFF00C27C),
          //     ),
          //   ),
          // ),

          Positioned(
            bottom: ScreenUtil().setHeight(25),
            child: Offstage(
              offstage: _photos.length == 1,
              child: Container(
                width: ScreenUtil().setWidth(90),
                height: ScreenUtil().setHeight(35),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: Color(0xFF3E3F43),
                    borderRadius: BorderRadius.all(Radius.circular(31))),
                child: TextHelper.TextCreateWith(
                  text: "${_currentIndex + 1} / ${_photos.length}",
                  color: Colors.white,
                  fontSize: 17,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildPhotoItem(int index) {
    String path = _photos[index];
    return Container(
      padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(40)),
      child: Image.file(
        File(path),
        fit: BoxFit.contain,
      ),
    );
  }

  Widget buildBottomTool() {
    return Container(
      height: ScreenUtil().setHeight(210),
      alignment: Alignment.center,
      child: _photos.length == 1
          ? buildSingleBottomTool()
          : buildMultiBottomTool(),
    );
  }

  Widget buildSingleBottomTool() {
    return Column(
      children: [
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: _cropImage,
          child: Container(
            alignment: Alignment.topCenter,
            transformAlignment: Alignment.center,
            margin: EdgeInsets.only(top: ScreenUtil().setHeight(20)),
            child: Image.asset(
              ImageHelper.imageRes("conversion_cutting.png"),
              width: ScreenUtil().setWidth(40),
              height: ScreenUtil().setHeight(40),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: ScreenUtil().setHeight(5)),
          alignment: Alignment.topCenter,
          child: TextHelper.TextCreateWith(
            text: "裁剪",
            color: Colors.white,
            fontSize: 13,
          ),
        ),
        Row(
          children: [
            Container(
              margin: EdgeInsets.only(
                  top: ScreenUtil().setHeight(25),
                  left: ScreenUtil().setWidth(30)),
              child: GestureDetector(
                onTap: _goBack,
                child: TextHelper.TextCreateWith(
                  text: "返回",
                  color: Colors.white,
                  fontSize: 17,
                ),
              ),
            ),
            //  buildCuttingButton(),
            buildConversionButton(width: ScreenUtil().setWidth(115)),
          ],
        ),
      ],
    );
  }


  Widget buildConversionButton({double width}) {
    return GestureDetector(
      onTap:  !_isConversing?_conversion:null,
      child: Container(
        width: width,
        height: ScreenUtil().setHeight(45),
        margin: EdgeInsets.only(
            left: ScreenUtil().setWidth(176), top: ScreenUtil().setHeight(25)),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Color(0xFF00C27C),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: TextHelper.TextCreateWith(
          text: "开始识别",
          color: Colors.white,
          fontSize: 17,
        ),
      ),
    );
  }

  Widget buildMultiBottomTool() {
    return Column(
      children: [
        Row(
          children: [
            GestureDetector(
              onTap: _remake,
              child: Container(
                alignment: Alignment.topLeft,
                transformAlignment: Alignment.topLeft,
                margin: EdgeInsets.only(
                    top: ScreenUtil().setHeight(20),
                    left: ScreenUtil().setWidth(67)),
                child: Image.asset(
                  ImageHelper.imageRes("conversion_remake.png"),
                  width: ScreenUtil().setWidth(40),
                  height: ScreenUtil().setHeight(40),
                ),
              ),
            ),
            GestureDetector(
              onTap:  _cropImage,
              child: Container(
                alignment: Alignment.topLeft,
                transformAlignment: Alignment.topLeft,
                margin: EdgeInsets.only(
                    top: ScreenUtil().setHeight(20),
                    left: ScreenUtil().setWidth(60)),
                child: Image.asset(
                  ImageHelper.imageRes("conversion_cutting.png"),
                  width: ScreenUtil().setWidth(40),
                  height: ScreenUtil().setHeight(40),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                BuriedPointHelper.clickBuriedPoint(
                  pageName: _pageName,
                  clickName: "删除",
                );
                CommonUtils.isFastClick() ? null: setState(() {
                  _photos.removeAt(_currentIndex);
                  if (_currentIndex > _photos.length - 1)
                    _currentIndex = _photos.length - 1;
                });
              },
              child: Container(
                alignment: Alignment.topLeft,
                transformAlignment: Alignment.topLeft,
                margin:
                    EdgeInsets.only(top: ScreenUtil().setHeight(20), left: ScreenUtil().setWidth(60)),
                child: Image.asset(
                  ImageHelper.imageRes("conversion_delete.png"),
                  width: ScreenUtil().setWidth(40),
                  height: ScreenUtil().setHeight(40),
                ),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Container(
              margin: EdgeInsets.only(
                  top: ScreenUtil().setHeight(5),
                  left: ScreenUtil().setWidth(74)),
              child: TextHelper.TextCreateWith(
                text: "重拍",
                color: Colors.white,
                fontSize: 13,
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                  top: ScreenUtil().setHeight(5),
                  left: ScreenUtil().setWidth(74)),
              child: TextHelper.TextCreateWith(
                text: "裁剪",
                color: Colors.white,
                fontSize: 13,
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                  top: ScreenUtil().setHeight(5),
                  left: ScreenUtil().setWidth(74)),
              child: TextHelper.TextCreateWith(
                text: "删除",
                color: Colors.white,
                fontSize: 13,
              ),
            ),
          ],
        ),
        Row(
          children: [
            Container(
              margin: EdgeInsets.only(
                  top: ScreenUtil().setHeight(25),
                  left: ScreenUtil().setWidth(30)),
              child: GestureDetector(
                onTap: _goBack,
                child: TextHelper.TextCreateWith(
                  text: "取消",
                  color: Colors.white,
                  fontSize: 17,
                ),
              ),
            ),
            //  buildCuttingButton(),
            buildConversionButton(width: ScreenUtil().setWidth(115)),
          ],
        ),
      ],
    );
  }

  _remake() async {
    BuriedPointHelper.clickBuriedPoint(
      pageName: _pageName,
      clickName: "重拍",
    );
    Navigator.of(context).pushNamed(RouteName.camera_page, arguments: {
      "singlePhoto": true,
      "photoCallback": (photoPath) {
        _photos.removeAt(_currentIndex);
        _photos.insert(_currentIndex, photoPath);
        setState(() {});
      }
    });
  }

  _conversion() async {
    _isConversing=true;
    print("Test conversion");
    BuriedPointHelper.clickBuriedPoint(
      pageName: _pageName,
      clickName: "开始识别",
    );
    if (!await CommonUtils.isLogin(context)) return;
    if (!UserHelper().userVM.isVip) {
      bool isCanUse = await FIZZApi.requestFunctionCanUse(); //是否可使用 ，需要改id
      if (!isCanUse) {
        DialogHelper.showVipDialog(context);
        return;
      }
    }

    _contents = [];
    _cancelTokens = [];
    _conversionCount = 0;
    DialogHelper.showConversionLoadingDialog(context).then((value) {
      return;
      _cancelTokens.forEach((token) {
        token.cancel();
      });
    });
    // EasyLoading.show(status: "正在识别中，请稍等");
    for (int i = 0; i < _photos.length; i++) {
      String photoPath = _photos[i];
      _contents.add("");

      print("photoPath==> $photoPath");
      int quality=100;
      int resultIndex = i;
      var content = "";
      //普通用户仅可使用一张
      if (UserHelper().userVM.isVip||i==0) {
        File file = File(photoPath);
        Uint8List bytes = await file.readAsBytes();
        String base64 = base64Encode(bytes);

        print("base64==> ${base64.length}");
        while (base64.length > 4000000) {
          print("压缩前：${base64.length}");
          bytes =
              await FlutterImageCompress.compressWithList(bytes, quality: quality);
          base64 = base64Encode(bytes);
          print("压缩后：${base64.length}");
          quality=quality-5;
        }

        CancelToken cancelToken = CancelToken();
        _cancelTokens.add(cancelToken);
        var value = await ConversionApi.requestRecognition(
            image: base64, index: i, cancelToken: cancelToken);
        _results.add(value);
        _conversionCount++;
        resultIndex = value["index"];
        if (value["words_result"] != null) {
          for (Map map in value["words_result"]) {
            content = content + map["words"] + "\n";
          }
        }
        print("conversion==>${content}");
      } else {
        content = JYLocalizations.localizedString("（开通会员后可识别剩余内容!）");
      }

      if (StringUtils.isNull(content))
        content = JYLocalizations.localizedString("（该张图片格式不符合规范或内容有误，无法识别!）");
      _contents.removeAt(resultIndex);
      _contents.insert(resultIndex, content);
    }
    _conversionComplete();
  }

  _conversionComplete() {
    // if (_conversionCount != _photos.length) return;
    _isConversing=false; //转换完成
    Navigator.pop(DialogHelper.dialogContext);
    FIZZApi.requestFunctionSave();
    DocumentModel model = DocumentModel();
    String documentNum = UserHelper().documentVM.documents.length<=0?"":UserHelper().documentVM.documents.length.toString();
    model.title = JYLocalizations.localizedString("文档") + documentNum;
    model.contents = _contents;
    model.imagePath = _photos[0];
    model.imagePaths = _photos;
    model.results = _results;
    if(widget.translateTelephoneEnabledType==1){
      model.title = formatDate(DateTime.now(), [mm, '-', dd, ' ', HH, ':', nn, ':', ss]);
      var content = "";
      for (String lineContent in _contents) {
        content = content + lineContent + "\n";
      }
      model.mobiles = _getMobiles(content);
      Navigator.of(context).pushNamed(
          RouteName.telephone_page,
          arguments: {
            "model": model,
            "index": -1,
          }
      );
    }else {
      Navigator.of(context).pushNamed(
          RouteName.document_page,
          arguments: {
            "model": model,
            "index": -1,
            "translateTelephoneEnabledType": widget
                .translateTelephoneEnabledType
          }
      );
    }
  }

  List<String> _getMobiles(String string) {
    var result="";
    string = string.replaceAll(" ", "");
    RegExp exp = RegExp(r'((13[0-9])|(14[0-9])|(15[0-9])|(16[0-9])|(17[0-9])|(18[0-9])|(19[0-9]))\d{8}|(0\d{2,3}-?\d{7,8})');
    Iterable<Match> matches = exp.allMatches(string);
    List<String> mobiles = [];
    for (Match m in matches) {
      String match = m.group(0);
      debugPrint("match = $match");
      mobiles.add(match);
    }
    return mobiles;
  }

  Future _cropImage() async {
    // File croppedFile = await ImageCropper.cropImage(
    //     sourcePath: _photos[_currentIndex],
    //     androidUiSettings: AndroidUiSettings(
    //       toolbarTitle: JYLocalizations.localizedString('裁剪'),
    //       toolbarColor: ColorHelper.color_main,
    //       toolbarWidgetColor: Colors.white,
    //       cropFrameColor: ColorHelper.color_main,
    //       dimmedLayerColor: Color(0xFF303135),
    //       activeControlsWidgetColor: ColorHelper.color_main,
    //       initAspectRatio: CropAspectRatioPreset.original,
    //       lockAspectRatio: false,
    //       hideBottomControls: true,
    //     ),
    //     iosUiSettings: IOSUiSettings(
    //       title: JYLocalizations.localizedString('裁剪'),
    //     ));
    // if (croppedFile != null) {
    //   setState(() {
    //     _photos.removeAt(_currentIndex);
    //     _photos.insert(_currentIndex, croppedFile.path);
    //   });
    // }

    // Navigator.of(context).pushNamed(RouteName.cutting_page, arguments: {
    //   "photoPath": _photos[_currentIndex],
    //   "callback": (photoPath) {
    //     if (!StringUtils.isNull(photoPath)) {
    //       setState(() {
    //         _photos.removeAt(_currentIndex);
    //         _photos.insert(_currentIndex, photoPath);
    //       });
    //     }
    //   }
    // });
  }

  _goBack() {
    BuriedPointHelper.clickBuriedPoint(
      pageName: _pageName,
      clickName: "上一步",
    );
    Navigator.of(context).pop();
    // _jumpAlbum();
  }


  _jumpAlbum() async {
    // assets[0].originFile;
    // final XFile image = await _picker.pickImage(source: ImageSource.gallery);
    // debugPrint("Album = ${image.path}");
    // Navigator.of(context).pushNamed(RouteName.conversion_page, arguments: {
    //   "imagePath": image.path,
    //   "index": 1,
    //   "callback": () {
    //     _jumpAlbum();
    //   }
    // });
    // final List<AssetEntity> assets = await AssetPicker.pickAssets(context, maxAssets: 30);
    final List<File> assets = await CommonUtils.pickAssets(maxImages: 30);
    if (assets == null) return;
    List<String> photos = [];
    for (File file in assets) {
      photos.add(file.path);
    }
    Navigator.of(context)
        .pushNamed(RouteName.conversion_multi_page, arguments: {
      "photos": photos,
    });
  }
}
