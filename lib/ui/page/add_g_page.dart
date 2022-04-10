import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:data_plugin/bmob/response/bmob_error.dart';
import 'package:data_plugin/utils/dialog_util.dart';
import 'package:data_plugin/bmob/response/bmob_updated.dart';
import 'package:data_plugin/bmob/table/bmob_user.dart';
import 'package:data_plugin/bmob/bmob_query.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graphic_conversion/table/free_code.dart';
import 'package:graphic_conversion/data/net/download_api.dart';
import 'package:graphic_conversion/event/any_event.dart';
import 'package:graphic_conversion/event/event_bus_util.dart';
import 'package:graphic_conversion/ui/helper/user_helper.dart';
import 'package:graphic_conversion/ui/manager/cache_audio_manager.dart';
import 'package:graphic_conversion/utils/common_utils.dart';
import 'package:graphic_conversion/utils/string_utils.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'package:graphic_conversion/data/net/fizz_api.dart';
import 'package:graphic_conversion/model/buried_point_model.dart';
import 'package:graphic_conversion/ui/helper/buried_point_helper.dart';
import 'package:graphic_conversion/ui/helper/resoure_helper.dart';
import 'package:graphic_conversion/view_model/user_view_model.dart';

class AddGPage extends StatefulWidget {
  @override
  createState() => AddGPageState();
}

class AddGPageState extends State<AddGPage> {
  String _imagePath;
  TextEditingController _controller;
  TextEditingController _coinsController;

  static const _availableChars =
      'ABCDEFGHIJKLMNOPQRSTUVWXZYabcdefghijklmnopqrstuvwxyz1234567890';


  int _coins=100;
  bool _textState = false;
  bool _coinsState = false;
  bool _btnState = false;

  @override
  void initState() {
    super.initState();
    // EasyLoading.show();
    // FIZZApi.requestProductQrcode().then((value) async {
    //   if (value != null && !StringUtils.isNull(value["imageList"])) {
    //     var imageUrl = value["imageList"];
    //     File file = await CacheAudioManager.getImagePath(imageUrl);
    //     await DownloadApi.downloadImage(imageUrl, savePath: file.path);
    //     setState(() {
    //       _imagePath = file.path;
    //     });
    //   }
    //   EasyLoading.dismiss();
    // });
    _controller = TextEditingController();
    _coinsController=TextEditingController();

    _addTextListener(); //监听输入变化
    _addCoinsListener();
    _addBtnListener();
  }

  @override
  void dispose() {
    if (_controller != null) {
      _controller.dispose();
    }
    if (_coinsController != null) {
      _coinsController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ColorHelper.color_fff,
        appBar: AppBar(
          backgroundColor: ColorHelper.color_fff,
          brightness: Brightness.light,
          leading: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              EasyLoading.dismiss();
              Navigator.of(context).pop();
            },
            child: Container(
              width: ScreenUtil().setWidth(50),
              height: ScreenUtil().setHeight(50),
              padding: EdgeInsets.only(left: ScreenUtil().setWidth(15)),
              alignment: Alignment.centerLeft,
              child: Image.asset(
                ImageHelper.imageRes('navigator_back.png'),
                width: ScreenUtil().setWidth(22),
                height: ScreenUtil().setHeight(22),
              ),
            ),
          ),
          centerTitle: true,
          elevation: 0.01,
          title: Text(
            '添加免费码',
            style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: Color(0xFF000000)),
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            child: SafeArea(
              child: Align(
                alignment: Alignment.center,
                child: Stack(
                  children: [
                    Column(
                      children: <Widget>[
                        SizedBox(
                          height: 30,
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.only(
                                left: ScreenUtil().setWidth(40),
                                right: ScreenUtil().setWidth(40),
                                top: ScreenUtil().setHeight(27),
                                bottom: ScreenUtil().setHeight(25)),
                            child: Text(
                              "添加指定免费码",
                              style: TextStyle(
                                  fontSize: 18,
                                  color: ColorHelper.color_main,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                        Container(
                          width: ScreenUtil().setWidth(296),
                          height: ScreenUtil().setHeight(45),
                          margin: EdgeInsets.only(
                              left: ScreenUtil().setWidth(40),
                              right: ScreenUtil().setWidth(40)),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                                color: _coinsState
                                    ? Color(0xFF00C27C)
                                    : Color(0xFF979797),
                                width: 0.8),
                          ),
                          child: TextField(
                            controller: _coinsController,
                            maxLines: 1,
                            inputFormatters: [
                              if (Platform.isAndroid)
                                LengthLimitingTextInputFormatter(8),
                              FilteringTextInputFormatter.allow(
                                  RegExp('[0-9]')),
                            ],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                            decoration: InputDecoration(
                              hintText: '请输入代币数量',
                              hintStyle: TextStyle(fontSize: 16),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        SizedBox(height: 15,),
                        Container(
                          width: ScreenUtil().setWidth(296),
                          height: ScreenUtil().setHeight(45),
                          margin: EdgeInsets.only(
                              left: ScreenUtil().setWidth(40),
                              right: ScreenUtil().setWidth(40)),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                                color: _textState
                                    ? Color(0xFF00C27C)
                                    : Color(0xFF979797),
                                width: 0.8),
                          ),
                          child: TextField(
                            controller: _controller,
                            maxLines: 1,
                            inputFormatters: [
                              if (Platform.isAndroid)
                                LengthLimitingTextInputFormatter(8),
                              FilteringTextInputFormatter.allow(
                                  RegExp('[0-9a-zA-Z]')),
                            ],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                            decoration: InputDecoration(
                              hintText: '请输入G码',
                              hintStyle: TextStyle(fontSize: 16),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                              left: ScreenUtil().setWidth(40),
                              right: ScreenUtil().setWidth(40),
                              top: ScreenUtil().setHeight(15),
                              bottom: ScreenUtil().setHeight(30)),
                          child: GestureDetector(
                            onTap: () {
                              _clickAdd();
                            },
                            child: Container(
                              width: ScreenUtil().setWidth(296),
                              height: ScreenUtil().setHeight(45),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: _btnState
                                      ? Color(0XFF00C27C)
                                      : Color(0x8000C27C),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15))),
                              child: Text(
                                '添加',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.only(
                                left: ScreenUtil().setWidth(40),
                                right: ScreenUtil().setWidth(40),
                                top: ScreenUtil().setHeight(27),
                                bottom: ScreenUtil().setHeight(25)),
                            child: Text(
                              "添加随机免费码",
                              style: TextStyle(
                                  fontSize: 18,
                                  color: ColorHelper.color_main,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                              left: ScreenUtil().setWidth(40),
                              right: ScreenUtil().setWidth(40),
                              top: ScreenUtil().setHeight(15),
                              bottom: ScreenUtil().setHeight(30)),
                          child: GestureDetector(
                            onTap: () {
                              _addCode();
                            },
                            child: Container(
                              width: ScreenUtil().setWidth(296),
                              height: ScreenUtil().setHeight(45),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: Color(0XFF00C27C),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15))),
                              child: Text(
                                '添加一个',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                              left: ScreenUtil().setWidth(40),
                              right: ScreenUtil().setWidth(40),
                              top: ScreenUtil().setHeight(15),
                              bottom: ScreenUtil().setHeight(30)),
                          child: GestureDetector(
                            onTap: () {
                              _addTenCodes();
                            },
                            child: Container(
                              width: ScreenUtil().setWidth(296),
                              height: ScreenUtil().setHeight(45),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: Color(0XFF00C27C),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15))),
                              child: Text(
                                '添加十个',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  _clickAdd() async {
    if (CommonUtils.isFastClick()) return;
    bool hasNet = await CommonUtils.isNetConnected();
    if (!hasNet) {
      showToast('请确认您的网络！');
      return;
    }
    String code = _controller.text;
    if (code == null || code.isEmpty) {
      showToast('请填写G码！');
      return;
    }
    if (code.length > 8) {
      showToast('G码不能超过8位');
      return;
    }

    EasyLoading.show();
    FreeCode freeCode = FreeCode();
    freeCode.user = UserHelper().bmobUserVM.bmobUserModel;
    freeCode.coins = _coinsController.text.length>0? int.parse(_coinsController.text) :100;
    freeCode.code = code;
    BmobQuery<FreeCode> query = BmobQuery();
    query.addWhereEqualTo("code", code);
    query.queryObjects().then((data) {
      // showSuccess(context, data.toString());
      List<BmobUser> users = data.map((i) => BmobUser().fromJsons(i)).toList();
      if (users == null || users.length == 0) {
        freeCode.save().then((value) {
          showToast('添加成功');
          EasyLoading.dismiss();
        }).catchError((e) {
          showToast('添加失败');
          EasyLoading.dismiss();
        });
      } else {
        showToast('添加失败,免费码已存在');
        EasyLoading.dismiss();
      }
    }).catchError((e) {
      showToast('网络错误');
      EasyLoading.dismiss();
    });
  }

  _addCode() async {
    if (CommonUtils.isFastClick()) return;
    bool hasNet = await CommonUtils.isNetConnected();
    if (!hasNet) {
      showToast('请确认您的网络！');
      return;
    }

    EasyLoading.show();
    FreeCode freeCode = FreeCode();
    freeCode.user = UserHelper().bmobUserVM.bmobUserModel;
    freeCode.coins = _coinsController.text.length>0? int.parse(_coinsController.text) :100;
    freeCode.code = _generateRandomCode(Random().nextInt(8) + 1);
    freeCode.save().then((value) {
      showToast('添加成功');
      EasyLoading.dismiss();
    }).catchError((e) {
      showToast('添加失败');
      EasyLoading.dismiss();
    });
  }

  _addTenCodes() async {
    if (CommonUtils.isFastClick()) return;
    bool hasNet = await CommonUtils.isNetConnected();
    if (!hasNet) {
      showToast('请确认您的网络！');
      return;
    }
    EasyLoading.show();
    for (int i = 0; i < 10; i++) {
      FreeCode freeCode = FreeCode();
      freeCode.user = UserHelper().bmobUserVM.bmobUserModel;
      freeCode.coins = _coinsController.text.length>0? int.parse(_coinsController.text) :100;
      freeCode.code = _generateRandomCode(Random().nextInt(8) + 1);
      freeCode.save().then((value) {
        showToast('添加成功');
        if (i == 9) {
          EasyLoading.dismiss();
        }
      }).catchError((e) {
        showToast('添加失败');
        if (i == 9) {
          EasyLoading.dismiss();
        }
      });
    }
  }

  String _generateRandomCode(int length) {
    final _random = Random();
    var randomCode = List.generate(length,
            (index) => _availableChars[_random.nextInt(_availableChars.length)])
        .join();
    return randomCode;
  }

  _saveCodeImage() async {
    if (CommonUtils.isFastClick()) return;
    ByteData bytes = await rootBundle.load('assets/images/ic_code.png');
    var value = await ImageGallerySaver.saveImage(bytes.buffer.asUint8List());
    if (value != null && value["isSuccess"]) {
      CommonUtils.showToastInfo('图片保存成功');
    } else {
      CommonUtils.showToastInfo('保存失败');
    }
  }

  _getUserInfo() async {
    FIZZApi.requestGetUserInfo().then((value) {
      if (value == null) return;
      UserViewModel userVM = Provider.of<UserViewModel>(context, listen: false);
      var model = userVM.userModel;
      model.vipType = CommonUtils.noNull(value["vipType"].toString());
      model.vipEndTime = CommonUtils.noNull(value["vipEndTime"]);
      model.mobile = CommonUtils.noNull(value["mobile"]);
      userVM.userModel = model;
      EventBusUtil.getInstance().fire(AnyEvent(AnyEvent.REFRESH_VIP));
      Navigator.of(context).pop();
    });
  }

  _addTextListener() {
    _controller.addListener(() {
      setState(() {});
      if (_controller.text.length > 0) {
        _textState = true;
      } else {
        _textState = false;
      }
    });
    return _textState;
  }

  _addCoinsListener() {
    _coinsController.addListener(() {
      setState(() {});
      if (_coinsController.text.length > 0) {
        _coinsState = true;
      } else {
        _coinsState = false;
      }
    });
    return _coinsState;
  }

  _addBtnListener() {
    _controller.addListener(() {
      setState(() {});
      if (_controller.text.length > 0) {
        _btnState = true;
      } else {
        _btnState = false;
      }
    });
    return _btnState;
  }
}
