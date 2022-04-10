import 'dart:io';
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

class GPage extends StatefulWidget {
  @override
  createState() => GState();
}

class GState extends State<GPage> {
  String _imagePath;
  TextEditingController _controller ;
  bool _textState = false;
  bool _btnState=false;

  int _itemLength = 0;

  List<FreeCode> codes = [];

  List<String> backImages = [
    'img_1.png',
    'img_2.png',
    'img_3.png',
    'img_4.png',
    'img_5.png',
    'img_6.png',
    'img_7.png',
    'img_8.png',
  ];

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
    _getCodes();
    _controller = TextEditingController();
    _addTextListener();  //监听输入变化
    _addBtnListener();
  }

  @override
  void dispose() {
    BuriedPointHelper.addBuriedPoint(
      eventType: BuriedPointEventType.PAGE_HIDE,
      pageName: "G码页面",
    );
    if (_controller != null) {
      _controller.dispose();
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
            '免费使用',
            style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: Color(0xFF000000)),
          ),
        ),
        body: Container(
            child: SafeArea(
              child: Align(
                alignment: Alignment.center,
                child: Stack(
                  children: [
                    Column(
                      children: <Widget>[
                        Expanded(child: UserHelper.instance.bmobUserVM.bmobUserModel.isAdmin?buildCodes():Container()),
                        Container(
                          width: ScreenUtil().setWidth(296),
                          height: ScreenUtil().setHeight(45),
                          margin: EdgeInsets.only(left: ScreenUtil().setWidth(40), right: ScreenUtil().setWidth(40),top: 30),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                                color: _textState?Color(0xFF00C27C):Color(0xFF979797), width: 0.8),
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
                              hintText: '请输入免费码',
                              hintStyle: TextStyle(fontSize: 16),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                              left: ScreenUtil().setWidth(40), right: ScreenUtil().setWidth(40), top: ScreenUtil().setHeight(15), bottom: ScreenUtil().setHeight(30)),
                          child: GestureDetector(
                            onTap: () {
                              _clickUse();
                            },
                            child: Container(
                              width: ScreenUtil().setWidth(296),
                              height: ScreenUtil().setHeight(45),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: _btnState?Color(0XFF00C27C):Color(0x8000C27C),
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(15))),
                              child: Text(
                                '提交',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                     Column(
                          children: [
                            GestureDetector(
                                onTap: () {
                                  if (Platform.isAndroid) {
                                    CommonUtils.checkPermission(context, "存储")
                                        .then((value) {
                                      if (value) {
                                        _saveCodeImage();
                                      }
                                    });
                                  } else {
                                    _saveCodeImage();
                                  }
                                },
                              child: Image.asset(
                                ImageHelper.imageRes("ic_code.jpg"),
                                width: ScreenUtil().setWidth(154),
                                height: ScreenUtil().setHeight(154),
                              ),
                            ),
                            SizedBox(
                              height: ScreenUtil().setHeight(10),
                            ),
                            GestureDetector(
                              onTap: () {
                                if (Platform.isAndroid) {
                                  CommonUtils.checkPermission(context, "存储")
                                      .then((value) {
                                    if (value) {
                                      _saveCodeImage();
                                    }
                                  });
                                } else {
                                  _saveCodeImage();
                                }
                              },
                              child: TextHelper.TextCreateWith(
                                  text: "点击保存二维码",
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF333333)),
                            ),
                            Container(
                                margin:
                                EdgeInsets.only(left: ScreenUtil().setWidth(40), right: ScreenUtil().setWidth(40)),
                                alignment: Alignment.topLeft,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: ScreenUtil().setHeight(20),
                                    ),
                                    // TextHelper.TextCreateWith(
                                    //     text: "保存上方二维码进入用户微信群，群内不定期发放G码。您也可在群内提供软件改进建议、反馈问题。",
                                    //     fontSize: 15,
                                    //     fontWeight: FontWeight.w500,
                                    //     color: Color(0xFF999999)),
                                  ],
                                ))
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
  }

  Widget buildCodes() {
    return Container(
      decoration: BoxDecoration(
        color: Color(0x0D3C90FB),
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      child: Column(children: [
        Row(
          mainAxisAlignment:MainAxisAlignment.spaceAround,
          children: [
          TextHelper.TextCreateWith(
            text: "免费码",
            fontSize: 15,
            color: ColorHelper.color_main,
            isBlod: true,
          ),
          TextHelper.TextCreateWith(
            text: "代币数",
            fontSize: 15,
            color: ColorHelper.color_main,
            isBlod: true,
          ),
          TextHelper.TextCreateWith(
            text: "是否已使用",
            fontSize: 15,
            color: ColorHelper.color_main,
            isBlod: true,
          ),
        ],),
        Expanded(child:    ListView.builder(
          itemCount: codes.length,
          itemBuilder: (ctx, index) {
            return buildModel(codes, index);
          },
        ),),
      ],),
    );
  }

  Widget buildModel(List<FreeCode> codes, int index) {
    double topLeft = index == 0 ? 10 : 0;
    double topRight = index == 0 ? 10 : 0;
    double bottomLeft = index == _itemLength - 1 ? 10 : 0;
    double bottomRight = index == _itemLength - 1 ? 10 : 0;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
          },
          child: Container(
            margin: EdgeInsets.only(
                top: index == 0 ? ScreenUtil().setHeight(20) : ScreenUtil().setHeight(34)),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(30),
              ),
              // border: userVM.hasUser
              //     ? Border.all(color: Color(0xFFFFFFFF), width: 1)
              //     : Border.all(color: Color(0xFFFFFFFF), width: 0)
              // border: Border.all(color: Color(0x33FFFFFF), width: 2),
            ),
            width: 375,
            child:Row(
              mainAxisAlignment:MainAxisAlignment.spaceAround,
              children: [
               TextHelper.TextCreateWith(
                text: "${codes[index].code}",
                fontSize: 15,
                color: Color(0xFF333333),
              ),
              TextHelper.TextCreateWith(
                text: "${codes[index].coins}",
                fontSize: 15,
                color: Color(0xFF333333),
              ),
              TextHelper.TextCreateWith(
                text: "${codes[index].isUse}",
                fontSize: 15,
                color: Color(0xFF333333),
              ),
            ],),
          ),
        ),
      ],
    );

    /*
      Dismissible(
        key: Key(model.createTime),
        onDismissed: (direction){

        },
        movementDuration: Duration(milliseconds: 100),
        child:
      );*/
  }

  _clickUse() async {
    if (CommonUtils.isFastClick()) return;
    bool hasNet = await CommonUtils.isNetConnected();
    if (!hasNet) {
      showToast('请确认您的网络！');
      return;
    }
    String code = _controller.text;
    if (code == null || code.isEmpty) {
      showToast('请填写免费码！');
      return;
    }
    if (code.length > 8) {
      showToast('免费码不能超过8位');
      return;
    }
    EasyLoading.show();

    BmobQuery<FreeCode> bmobQuery = BmobQuery();
    bmobQuery.addWhereEqualTo("code", code);
    bmobQuery.queryObjects().then((data) {
      List<FreeCode> codes = data.map((i) => FreeCode().fromJsons(i)).toList();
      if(codes==null ||codes.length==0) {
        showToast('免费码不存在！');
        EasyLoading.dismiss();
        return;
      }
      EasyLoading.dismiss();
      for (FreeCode freeCode in codes) {
        if (!freeCode.isUse) {
          BmobUser local=UserHelper().bmobUserVM.bmobUserModel;
          int coninsRaw=local.coins;
          int coins=freeCode.coins+coninsRaw;
          local.coins=coins;

          FreeCode myCode=freeCode;
          myCode.isUse=true;
          myCode.user=local;
          local.update().then((BmobUpdated bmobUpdated) {
            showToast('使用成功');
            UserHelper().bmobUserVM.bmobUserModel=local;
            _getCodes();
          }).catchError((e) {
            // UserHelper().bmobUserVM.bmobUserModel.coins=UserHelper().bmobUserVM.bmobUserModel.coins-coins;
          });

          myCode.update().then((BmobUpdated bmobUpdated) {
          //  showToast('更新成功！');
          }).catchError((e) {
            showError(context, BmobError.convert(e).error);
          });
        }else{
          showToast('已被使用！');
        }
      }
    }).catchError((e) {
      showToast('网络错误！');
    });

  }

  _saveCodeImage() async {
    if (CommonUtils.isFastClick()) return;
    ByteData bytes = await rootBundle.load('assets/images/ic_code.jpg');
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
      if (_controller.text.length >0) {
        _textState = true;
      } else {
        _textState = false;
      }
    });
    return _textState;
  }

  _addBtnListener() {
    _controller.addListener(() {
      setState(() {});
      if (_controller.text.length >0) {
        _btnState = true;
      } else {
        _btnState = false;
      }
    });
    return _btnState;
  }

  _getCodes() async {
    BmobQuery<FreeCode> query = new BmobQuery<FreeCode>();
    await query.queryObjects().then((data) {
      List<FreeCode> freeCodes = data.map((i) => FreeCode().fromJsons(i)).toList();
      codes.clear();
      codes.addAll(freeCodes);
      if(mounted) {
        setState(() {
        });
      }
    }).catchError((e) {
      showToast("网络错误");
    });
  }
}
