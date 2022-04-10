import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graphic_conversion/router/router_config.dart';
import 'package:graphic_conversion/ui/helper/buried_point_helper.dart';
import 'package:graphic_conversion/ui/helper/resoure_helper.dart';
import 'package:graphic_conversion/utils/common_utils.dart';
import 'package:graphic_conversion/utils/string_utils.dart';
import 'package:oktoast/oktoast.dart';

typedef PhotoCallback = void Function(String photoPath);

class CameraPage extends StatefulWidget {
  final bool singlePhoto;

  final PhotoCallback photoCallback;

  final int index;

  final int translateTelephoneEnabledType;

  CameraPage({this.singlePhoto = false, this.photoCallback, this.index, this.translateTelephoneEnabledType = -1});

  @override
  _CameraPageState createState() => _CameraPageState();
}

List<CameraDescription> cameras = [];

class _CameraPageState extends State<CameraPage>
    with WidgetsBindingObserver, TickerProviderStateMixin {

  int index;  //功能index：0 拍照 1 2 3
  CameraController controller;
  XFile imageFile;
  bool enableAudio = false;
  double _minAvailableExposureOffset = 0.0;
  double _maxAvailableExposureOffset = 0.0;
  double _currentExposureOffset = 0.0;
  double _minAvailableZoom = 1.0;
  double _maxAvailableZoom = 1.0;
  double _currentScale = 1.0;
  double _baseScale = 1.0;
  int _pointers = 0;
  int _currentCameraIndex = 0;

  bool _joinMultiPhotoMode = false;

  List<String> _photoModes = ["单张拍摄", "多张拍摄"];
  int _currentPhotoModeIndex = 0;

  List<String> _photos = [];

  bool _isSinglePhoto = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _isSinglePhoto = widget.singlePhoto;

    onNewCameraSelected(cameras[_currentCameraIndex]);
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController cameraController = controller;

    // App state changed before we got the chance to initialize.
    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      onNewCameraSelected(cameraController.description);
    }
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
              Expanded(
                  child: Align(
                      alignment: Alignment.topCenter,
                      child: _cameraPreviewWidget())),
              Stack(
                children: [
                  buildBottomContent(),
                  //   buildPhotoMode(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _cameraPreviewWidget() {
    final CameraController cameraController = controller;

    if (cameraController == null || !cameraController.value.isInitialized) {
      return Container(
        alignment: Alignment.center,
        child: TextHelper.TextCreateWith(
          text: '正在打开相机',
          color: Colors.white,
          fontSize: 24.0,
          isBlod: true,
        ),
      );
    } else {
      return Listener(
        onPointerDown: (_) => _pointers++,
        onPointerUp: (_) => _pointers--,
        child: CameraPreview(
          controller,
          child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onScaleStart: _handleScaleStart,
              onScaleUpdate: _handleScaleUpdate,
              onTapDown: (details) => onViewFinderTap(details, constraints),
            );
          }),
        ),
      );
    }
  }

  Widget buildPhotoMode() {
    if (widget.singlePhoto || _joinMultiPhotoMode) return Container();
    return Container(
      alignment: Alignment.topLeft,
      child: Row(
        children: List<Widget>.generate(
            _photoModes.length, (index) => buildPhotoModeItem(index)),
      ),
    );
  }

  Widget buildPhotoModeItem(int index) {
    String text = _photoModes[index];
    Color color =
        _currentPhotoModeIndex == index ? Color(0xFF00C27C) : Color(0xB3FFFFFF);
    return GestureDetector(
      onTap: () {
        BuriedPointHelper.clickBuriedPoint(
          pageName: "拍摄页",
          clickName: index == 0 ? "单张拍摄" : "连续拍摄",
        );
        if (_isSinglePhoto) {
          showToast("重拍只能拍摄一张");
        } else {
          setState(() {
            _currentPhotoModeIndex = index;
          });
        }
      },
      child: Container(
        //padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(50)),
        child: Column(
          children: [
            Container(

              margin: EdgeInsets.only(left:  index==0?ScreenUtil().setWidth(102):ScreenUtil().setWidth(50)),
              child: TextHelper.TextCreateWith(
                  text: text,
                  color: color,
                  fontSize: 15,
                  isBlod: _currentPhotoModeIndex == index),
            ),
            SizedBox(
              height: ScreenUtil().setHeight(5),
            ),
            Container(
              margin: EdgeInsets.only(left:  index==0?ScreenUtil().setWidth(102):ScreenUtil().setWidth(50)),
              width: ScreenUtil().setWidth(5),
              height: ScreenUtil().setHeight(5),
              decoration: BoxDecoration(
                  color: _currentPhotoModeIndex == index
                      ? Color(0XFF00C27C)
                      : Colors.black,
                  borderRadius: BorderRadius.all(Radius.circular(5))),
            )
          ],
        ),
      ),
    );
  }

  Widget buildBottomContent() {
    return Container(
      child: widget.singlePhoto || !_joinMultiPhotoMode
          ? buildBottomTool()
          : buildMultiBottomTool(),
    );
  }

  Widget buildBottomTool() {
    return Container(
      height: ScreenUtil().setHeight(210),
      alignment: Alignment.topLeft,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: _goBack,
                child: Container(
                  alignment: Alignment.center,
                  transformAlignment: Alignment.center,
                  margin: EdgeInsets.only(
                      top: ScreenUtil().setHeight(45),
                      right: ScreenUtil().setWidth(10),
                      left: ScreenUtil().setWidth(50)),
                  child: Image.asset(
                    ImageHelper.imageRes("camera_close.png"),
                    width: ScreenUtil().setWidth(45),
                    height: ScreenUtil().setHeight(45),
                  ),
                ),
              ),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  onTakePictureButtonPressed();
                },
                child: Container(
                  margin: EdgeInsets.only(top: ScreenUtil().setHeight(35)),
                  child: Image.asset(
                    ImageHelper.imageRes("camera_photo.png"),
                    width: ScreenUtil().setWidth(65),
                    height: ScreenUtil().setHeight(65),
                  ),
                ),
              ),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: _selectAlbum,
                child: Container(
                  margin: EdgeInsets.only(
                      top: ScreenUtil().setHeight(45),
                      left: ScreenUtil().setWidth(10),
                      right: ScreenUtil().setWidth(50)),
                  child: Image.asset(
                    ImageHelper.imageRes("camera_album.png"),
                    width: ScreenUtil().setWidth(45),
                    height: ScreenUtil().setHeight(45),
                  ),
                ),
              ),
            ],
          ),
          Container(
            alignment: Alignment.topLeft,
            margin: EdgeInsets.only(top: ScreenUtil().setHeight(30)),
            child: Row(
              children: List<Widget>.generate(
                  _photoModes.length, (index) => buildPhotoModeItem(index)),
            ),
          )
        ],
      ),
    );
  }

  Widget buildMultiBottomTool() {
    return Container(
      height: ScreenUtil().setHeight(210),
      alignment: Alignment.topLeft,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: _goBack,
                child: Container(
                  alignment: Alignment.center,
                  transformAlignment: Alignment.center,
                  margin: EdgeInsets.only(
                      top: ScreenUtil().setHeight(45),
                      right: ScreenUtil().setWidth(10),
                      left: ScreenUtil().setWidth(50)),
                  child: Image.asset(
                    ImageHelper.imageRes("camera_close.png"),
                    width: ScreenUtil().setWidth(45),
                    height: ScreenUtil().setHeight(45),
                  ),
                ),
              ),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  onTakePictureButtonPressed();
                },
                child: Container(
                  margin: EdgeInsets.only(top: ScreenUtil().setHeight(35)),
                  child: Image.asset(
                    ImageHelper.imageRes("camera_photo.png"),
                    width: ScreenUtil().setWidth(65),
                    height: ScreenUtil().setHeight(65),
                  ),
                ),
              ),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  BuriedPointHelper.clickBuriedPoint(
                    pageName: "拍摄页",
                    clickName: "下一步",
                  );
                  Navigator.of(context).pushNamed(RouteName.conversion_multi_page, arguments: {
                    "photos": _photos,
                    "translateTelephoneEnabledType":widget.translateTelephoneEnabledType
                  }).then((value) {
                    // onNewCameraSelected(controller.description, needDispose: false);
                    onNewCameraSelected(cameras[_currentCameraIndex]);
                  });
                },
                child: Container(
                  child: Stack(
                    children: [
                      Container(
                        //   padding: EdgeInsets.only(top: 9, left: 9),
                        child: Row(
                          children: [
                            Container(
                              margin: EdgeInsets.only(
                                  top: ScreenUtil().setHeight(45),
                                  left: ScreenUtil().setWidth(10),
                                  right: ScreenUtil().setWidth(50)),
                              child: ClipOval(
                                child: Image.file(
                                  File(imageFile.path),
                                  width: ScreenUtil().setWidth(45),
                                  height: ScreenUtil().setHeight(45),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        right: ScreenUtil().setWidth(48),
                        top: ScreenUtil().setHeight(42),
                        child: Container(
                          width: ScreenUtil().setWidth(16),
                          height: ScreenUtil().setHeight(16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            color: Color(0xFF00C27C),
                          ),
                          alignment: Alignment.center,
                          child: TextHelper.TextCreateWith(
                            text: "${_photos.length}",
                            color: Colors.white,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Container(
            alignment: Alignment.topLeft,
            margin: EdgeInsets.only(top: ScreenUtil().setHeight(30)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List<Widget>.generate(
                  _photoModes.length, (index) => buildPhotoModeItem(index)),
            ),
          )
        ],
      ),
    );
    // return Container(
    //   padding: EdgeInsets.symmetric(horizontal: 28),
    //   child: Row(
    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //     children: [
    //       GestureDetector(
    //         behavior: HitTestBehavior.opaque,
    //         onTap: () {
    //           BuriedPointHelper.clickBuriedPoint(
    //             pageName: "拍摄页",
    //             clickName: "返回",
    //           );
    //           setState(() {
    //             _joinMultiPhotoMode = false;
    //             _photos = [];
    //           });
    //         },
    //         child: Container(
    //           padding: EdgeInsets.only(top: 10, bottom: 10, right: 10),
    //           child: Image.asset(
    //             ImageHelper.imageRes("camera_close.png"),
    //             width: 45,
    //             height: 45,
    //           ),
    //         ),
    //       ),
    //       GestureDetector(
    //         behavior: HitTestBehavior.opaque,
    //         onTap: () {
    //           onTakePictureButtonPressed();
    //         },
    //         child: Container(
    //           child: Image.asset(
    //             ImageHelper.imageRes("camera_photo.png"),
    //             width: 65,
    //             height: 65,
    //           ),
    //         ),
    //       ),
    //       GestureDetector(
    //         behavior: HitTestBehavior.opaque,
    //         onTap: () {
    //           BuriedPointHelper.clickBuriedPoint(
    //             pageName: "拍摄页",
    //             clickName: "下一步",
    //           );
    //           Navigator.of(context)
    //               .pushNamed(RouteName.conversion_multi_page, arguments: {
    //             "photos": _photos,
    //           }).then((value) {
    //             // onNewCameraSelected(controller.description, needDispose: false);
    //             onNewCameraSelected(cameras[_currentCameraIndex]);
    //           });
    //         },
    //         child: Container(
    //           child: Stack(
    //             children: [
    //               Container(
    //                 //   padding: EdgeInsets.only(top: 9, left: 9),
    //                 child: Row(
    //                   children: [
    //                     ClipOval(
    //                       child: Image.file(
    //                         File(imageFile.path),
    //                         width: 45,
    //                         height: 45,
    //                         fit: BoxFit.cover,
    //                       ),
    //                     ),
    //                   ],
    //                 ),
    //               ),
    //               Positioned(
    //                 right: 0,
    //                 top: 0,
    //                 child: Container(
    //                   width: 16,
    //                   height: 16,
    //                   decoration: BoxDecoration(
    //                     borderRadius: BorderRadius.all(Radius.circular(10)),
    //                     color: Color(0xFF00C27C),
    //                   ),
    //                   alignment: Alignment.center,
    //                   child: TextHelper.TextCreateWith(
    //                     text: "${_photos.length}",
    //                     color: Colors.white,
    //                     fontSize: 10,
    //                   ),
    //                 ),
    //               ),
    //             ],
    //           ),
    //         ),
    //       ),
    //     ],
    //   ),
    // );
  }

  void onNewCameraSelected(CameraDescription cameraDescription,
      {bool needDispose = true}) async {
    if (controller != null && needDispose) {
      await controller.dispose();
    }

    final CameraController cameraController = CameraController(
      cameraDescription,
      ResolutionPreset.medium,
      enableAudio: enableAudio,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );

    controller = cameraController;

    // If the controller is updated then update the UI.
    cameraController.addListener(() {
      if (mounted) setState(() {});
      if (cameraController.value.hasError) {
        debugPrint('Camera error ${cameraController.value.errorDescription}');
      }
    });

    try {
      await cameraController.initialize();
      await Future.wait([
        // The exposure mode is currently not supported on the web.
        ...(!kIsWeb
            ? [
                cameraController
                    .getMinExposureOffset()
                    .then((value) => _minAvailableExposureOffset = value),
                cameraController
                    .getMaxExposureOffset()
                    .then((value) => _maxAvailableExposureOffset = value)
              ]
            : []),
        cameraController
            .getMaxZoomLevel()
            .then((value) => _maxAvailableZoom = value),
        cameraController
            .getMinZoomLevel()
            .then((value) => _minAvailableZoom = value),
      ]);
    } on CameraException catch (e) {
      debugPrint('Error: ${e.code}\n${e.description}');
    }

    await cameraController.setFlashMode(FlashMode.off);
    if (mounted) {
      setState(() {});
    }
  }

  void onTakePictureButtonPressed() {
    if (_photos.length >= 30) {
      showToast("单次最多识别30张图片");
      return;
    }
    BuriedPointHelper.clickBuriedPoint(
      pageName: "拍摄页",
      clickName: "拍照",
    );
    takePicture().then((XFile file) {
      if (file == null || StringUtils.isNull(file.path)) return;
      if (mounted) {
        setState(() {
          imageFile = file;
          if (widget.singlePhoto && widget.photoCallback != null) {
            widget.photoCallback(file.path);
            Navigator.of(context).pop();
          } else {
            if (_currentPhotoModeIndex == 0) {
              Navigator.of(context).pushNamed(RouteName.conversion_multi_page, arguments: {
                "photos": [file.path],
                "translateTelephoneEnabledType":widget.translateTelephoneEnabledType
              }).then((value) {
                // onNewCameraSelected(controller.description, needDispose: false);
                onNewCameraSelected(cameras[_currentCameraIndex]);
              });
            } else {
              _joinMultiPhotoMode = true;
              _photos.add(file.path);
            }
          }
        });
        if (file != null) debugPrint('Picture saved to ${file.path}');
      }
    });
  }

  Future<XFile> takePicture() async {
    final CameraController cameraController = controller;
    if (cameraController == null || !cameraController.value.isInitialized) {
      debugPrint('Error: select a camera first.');
      return null;
    }

    if (cameraController.value.isTakingPicture) {
      // A capture is already pending, do nothing.
      return null;
    }

    try {
      XFile file = await cameraController.takePicture();
      return file;
    } on CameraException catch (e) {
      debugPrint('Error: ${e.code}\n${e.description}');
      return null;
    }
  }

  void _handleScaleStart(ScaleStartDetails details) {
    _baseScale = _currentScale;
  }

  Future<void> _handleScaleUpdate(ScaleUpdateDetails details) async {
    // When there are not exactly two fingers on screen don't scale
    if (controller == null || _pointers != 2) {
      return;
    }

    _currentScale = (_baseScale * details.scale)
        .clamp(_minAvailableZoom, _maxAvailableZoom);

    await controller.setZoomLevel(_currentScale);
  }

  void onViewFinderTap(TapDownDetails details, BoxConstraints constraints) {
    if (controller == null) {
      return;
    }

    final CameraController cameraController = controller;

    final offset = Offset(
      details.localPosition.dx / constraints.maxWidth,
      details.localPosition.dy / constraints.maxHeight,
    );
    cameraController.setExposurePoint(offset);
    cameraController.setFocusPoint(offset);
  }

  _selectAlbum() async {
    await controller.dispose();
    BuriedPointHelper.clickBuriedPoint(
      pageName: "拍摄页",
      clickName: "相册",
    );
    if (widget.singlePhoto && widget.photoCallback != null) {
      // final List<AssetEntity> assets = await AssetPicker.pickAssets(context, maxAssets: 1);
      final List<File> assets = await CommonUtils.pickAssets(maxImages: 1);
      if (assets == null || assets.isEmpty) {
        // onNewCameraSelected(controller.description, needDispose: false);
        onNewCameraSelected(cameras[_currentCameraIndex]);
        return;
      }
      // File file = await assets[0].file;
      widget.photoCallback(assets[0].path);
      Navigator.of(context).pop();
    } else {
      // final List<AssetEntity> assets = await AssetPicker.pickAssets(context, maxAssets: 30);
      final List<File> assets = await CommonUtils.pickAssets(maxImages: 30);
      if (assets == null || assets.isEmpty) {
        // onNewCameraSelected(controller.description, needDispose: false);
        onNewCameraSelected(cameras[_currentCameraIndex]);
        return;
      }
      List<String> photos = [];
      for (File file in assets) {
        photos.add(file.path);
      }
      Navigator.of(context).pushNamed(RouteName.conversion_multi_page, arguments: {
        "photos": photos,
        "translateTelephoneEnabledType":widget.translateTelephoneEnabledType
      }).then((value) {
        onNewCameraSelected(cameras[_currentCameraIndex]);
      });
    }
  }

  _goBack() {
    BuriedPointHelper.clickBuriedPoint(
      pageName: "拍摄页",
      clickName: "退出",
    );
    Navigator.of(context).pop();
  }
}
