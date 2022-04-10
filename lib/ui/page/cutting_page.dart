import 'dart:io';
import 'dart:typed_data';

// import 'package:crop_your_image/crop_your_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:graphic_conversion/ui/helper/resoure_helper.dart';
import 'package:graphic_conversion/ui/manager/cache_audio_manager.dart';

typedef CuttingCallBack = void Function(String photoPath);

class CuttingPage extends StatefulWidget {

  final String photoPath;

  final CuttingCallBack callback;

  CuttingPage({this.photoPath, this.callback});

  @override
  _CuttingPageState createState() => _CuttingPageState();
}

class _CuttingPageState extends State<CuttingPage> {

  // CropController _cropController = CropController();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return _goBack();
      },
      child: Scaffold(
        backgroundColor: Color(0xFF101010),
        body: SafeArea(
          child: Column(
            children: [
              buildNavigator(),
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
          height: 50,
          margin: EdgeInsets.symmetric(horizontal: 100),
          alignment: Alignment.center,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {

            },
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
              height: 50,
              padding: EdgeInsets.only(left: 10),
              alignment: Alignment.centerLeft,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [

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
    File file = File(widget.photoPath);
    Uint8List uint8list = file.readAsBytesSync();
    return Container(
      color: Color(0xFF202020),
      padding: EdgeInsets.symmetric(horizontal: 40),
      // child: Crop(
      //   controller: _cropController,
      //   image: uint8list,
      //   onCropped: (croppedData) async {
      //     if (croppedData != null && widget.callback != null) {
      //       File file = await CacheAudioManager.saveImageWithUint8List(croppedData);
      //       widget.callback(file.path);
      //     }
      //     EasyLoading.dismiss();
      //     if (mounted) Navigator.of(context).pop();
      //   },
      // ),
    );
  }

  Widget buildBottomTool() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      height: 160,
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: _goBack,
            child: Container(
              width: 124,
              height: 50,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Color(0xFFE9EFFF),
                borderRadius: BorderRadius.all(Radius.circular(93)),
              ),
              child: TextHelper.TextCreateWith(
                text: "取消",
                color: Color(0xFF376DF7),
                fontSize: 16,
                isBlod: true,
              ),
            ),
          ),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              EasyLoading.show();
              // _cropController.crop();
            },
            child: Container(
              width: 203,
              height: 50,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Color(0xFF376DF7),
                borderRadius: BorderRadius.all(Radius.circular(93)),
              ),
              child: TextHelper.TextCreateWith(
                text: "确认",
                color: Colors.white,
                fontSize: 16,
                isBlod: true,
              ),
            ),
          ),
        ],
      ),
    );
  }

  _goBack() {
    Navigator.of(context).pop();
  }
}
