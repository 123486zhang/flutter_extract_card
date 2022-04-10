import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:data_plugin/bmob/bmob_query.dart';
import 'package:data_plugin/bmob/response/bmob_updated.dart';
import 'package:data_plugin/bmob/table/bmob_user.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graphic_conversion/data/net/conversion_api.dart';
import 'package:graphic_conversion/data/net/fizz_api.dart';
import 'package:graphic_conversion/event/any_event.dart';
import 'package:graphic_conversion/event/event_bus_util.dart';
import 'package:graphic_conversion/model/buried_point_model.dart';
import 'package:graphic_conversion/model/document_model.dart';
import 'package:graphic_conversion/router/router_config.dart';
import 'package:graphic_conversion/table/person.dart';
import 'package:graphic_conversion/ui/helper/buried_point_helper.dart';
import 'package:graphic_conversion/ui/helper/dialog_helper.dart';
import 'package:graphic_conversion/ui/helper/resoure_helper.dart';
import 'package:graphic_conversion/ui/helper/user_helper.dart';
import 'package:graphic_conversion/utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:graphic_conversion/view_model/document_view_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

import '../../configs.dart';

class UpdateCardPage extends StatefulWidget {
  @override
  _UpdateCardPageState createState() => _UpdateCardPageState();
}

class _UpdateCardPageState extends State<UpdateCardPage> {
  final ImagePicker _picker = ImagePicker();

  int _itemLength = 0;

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

  List<Person> cards = [];

  StreamSubscription listen;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    listen = EventBusUtil.listener<AnyEvent>((event) {
      switch (event.type) {
        case AnyEvent.REFRESH_CARDS:
          cards.clear();
          _getCards();
          break;
      }
    });

    _getCards();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: Color(0xFFF3FAF9),
        body: Column(
          children: [
            buildTopContent(),
            Expanded(child: buildCards()),
          ],
        ),
      ),
    );
  }

  Widget buildTopContent() {
    return Container(
      color: Colors.white,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 21),
            child: Container(
              width: 375,
              height: 64, // 114,
            ),
            // Image.asset(
            //   ImageHelper.imageRes("home_top_bg.png"),
            //   width: 375,
            //   height: 114,
            // ),
          ),
          Container(
            padding: EdgeInsets.only(bottom: 15),
            child: TextHelper.TextCreateWith(
              text: "卡池",
              fontSize: 18,
              color: Color(0xFF36414B),
              isBlod: true,
            ),
          )
        ],
      ),
    );
  }

  Widget buildToolContent() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          buildOpenPhoto(),
          buildOpenAlbum(),
        ],
      ),
    );
  }

  _getCards() async {
    cards.addAll(await Configs.PERSONS);
    if (mounted) {
      setState(() {});
    }
    // BmobQuery<Person> query = new BmobQuery<Person>();
    // query.addWhereEqualTo("user", UserHelper.instance.bmobUserVM.bmobUserModel);
    // await query.queryObjects().then((data) {
    //   List<Person> persons = data.map((i) => Person.fromJson(i)).toList();
    //   cards.addAll(persons);
    //   if(mounted) {
    //     setState(() {
    //     });
    //   }
    // }).catchError((e) {
    //   showToast("网络错误");
    // });
  }

  Widget buildOpenPhoto() {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () async {
        if (Platform.isAndroid) {
          CommonUtils.checkPermission(context, "存储相机").then((value) {
            if (value) _jumpPhoto();
          });
        } else {
          _jumpPhoto();
        }
      },
      child: Container(
        width: 166,
        height: 184,
        child: Stack(
          children: [
            Image.asset(
              ImageHelper.imageRes("home_photo_bg.png"),
              width: 166,
              height: 184,
            ),
            Positioned(
              top: 28,
              left: 22,
              child: Image.asset(
                ImageHelper.imageRes("home_photo.png"),
                width: 64,
                height: 64,
              ),
            ),
            Positioned(
              left: 23,
              bottom: 25,
              child: TextHelper.TextCreateWith(
                text: "拍照提取文字",
                color: Colors.white,
                fontSize: 20,
                isBlod: true,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildOpenAlbum() {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () async {
        BuriedPointHelper.clickBuriedPoint(
          pageName: "首页",
          clickName: "图片提取文字",
        );
        if (Platform.isAndroid) {
          CommonUtils.checkPermission(context, "存储相机").then((value) {
            if (value) _jumpAlbum();
          });
        } else {
          _jumpAlbum();
        }
      },
      child: Container(
        width: 166,
        height: 184,
        child: Stack(
          children: [
            Image.asset(
              ImageHelper.imageRes("home_album_bg.png"),
              width: 166,
              height: 184,
            ),
            Positioned(
              top: 28,
              left: 22,
              child: Image.asset(
                ImageHelper.imageRes("home_album.png"),
                width: 64,
                height: 64,
              ),
            ),
            Positioned(
              left: 23,
              bottom: 25,
              child: TextHelper.TextCreateWith(
                text: "图片提取文字",
                color: Colors.white,
                fontSize: 20,
                isBlod: true,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildCards() {
    return Container(
      decoration: BoxDecoration(
        color: Color(0x0D3C90FB),
        // borderRadius: BorderRadius.all(
        //   Radius.circular(10),
        // ),
      ),
      child: cards.length>0?ListView.builder(
        // padding: EdgeInsets.symmetric(horizontal: 20),
        itemCount: cards.length,
        itemBuilder: (ctx, index) {
          return buildModel(cards, index);
        },
      ):Container(
        alignment: Alignment.center,
        child:Image.asset(
          ImageHelper.imageRes("update_page_empty.png"),
          fit: BoxFit.fill,
          width: 320,
          height: 240,
        ),
      //   child:  TextHelper.TextCreateWith(
      //   text: "空空如也",
      //   color: ColorHelper.color_main,
      //   fontSize: 30,
      // ),
      ),
    );
  }

  Widget buildModel(List<Person> cards, int index) {
    double topLeft = index == 0 ? 10 : 0;
    double topRight = index == 0 ? 10 : 0;
    double bottomLeft = index == _itemLength - 1 ? 10 : 0;
    double bottomRight = index == _itemLength - 1 ? 10 : 0;
    int back = Random().nextInt(backImages.length);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            _showUpdateDialog(cards[index].names,
                cards[index].weight.toString(), cards[index]);
          },
          onLongPress: () {
            _showDeleteDialog(cards[index].names, cards[index]);
          },
          child: Stack(
            children: [
              Container(
                width: ScreenUtil().setWidth(320),
                height: ScreenUtil().setHeight(90),
                margin: EdgeInsets.only(
                    top: index == 0 ? 0 : ScreenUtil().setHeight(20)),
                // decoration: BoxDecoration(
                //   borderRadius: BorderRadius.all(
                //     Radius.circular(10),
                //   ),
                // border: userVM.hasUser
                //     ? Border.all(color: Color(0xFFFFFFFF), width: 1)
                //     : Border.all(color: Color(0xFFFFFFFF), width: 0)
                // border: Border.all(color: Color(0x33FFFFFF), width: 2),
                // ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    ImageHelper.imageRes(backImages[back]),
                    fit: BoxFit.fill,
                    width: ScreenUtil().setWidth(320),
                    height: ScreenUtil().setHeight(90),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(
                    top: index == 0
                        ? ScreenUtil().setHeight(10)
                        : ScreenUtil().setHeight(30),
                    left: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextHelper.TextCreateWith(
                      text: cards[index].updatedAt,
                      fontSize: ScreenUtil().setSp(12),
                      color: Color(0xFF7D7B7B),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    TextHelper.TextCreateWith(
                      text: "${cards[index].names}",
                      fontSize: ScreenUtil().setSp(14),
                      color: Color(0xFFFF5F5F),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    TextHelper.TextCreateWith(
                      text: "权重：${cards[index].weight}",
                      fontSize: ScreenUtil().setSp(14),
                      color: Color(0xFF29C9FA),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // GestureDetector(
        //   onTap: () {
        //     // _selectHead(index);
        //   },
        //
        //   child: Container(
        //     width: ScreenUtil().setWidth(300),
        //     height: ScreenUtil().setHeight(168),
        //     margin: EdgeInsets.only(
        //         top: index == 0 ? 0 : ScreenUtil().setHeight(34)),
        //     decoration: BoxDecoration(
        //       borderRadius: BorderRadius.all(
        //         Radius.circular(30),
        //       ),
        //       // border: userVM.hasUser
        //       //     ? Border.all(color: Color(0xFFFFFFFF), width: 1)
        //       //     : Border.all(color: Color(0xFFFFFFFF), width: 0)
        //       // border: Border.all(color: Color(0x33FFFFFF), width: 2),
        //     ),
        //     child: Image.asset(
        //       ImageHelper.imageRes(backImages[back]),
        //       fit: BoxFit.fill,
        //       width: ScreenUtil().setWidth(300),
        //       height: ScreenUtil().setHeight(168),
        //     ),
        //   ),
        // ),
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

  _selectHead(int index) {
    BmobUser local = UserHelper().bmobUserVM.bmobUserModel;
    local.backId = index;
    local.update().then((BmobUpdated bmobUpdated) {
      UserHelper().bmobUserVM.bmobUserModel = local;
      showToast('更换成功！');
      EventBusUtil.getInstance().fire(AnyEvent(AnyEvent.REFRESH_HEAD));
      Navigator.of(context).pop();
    }).catchError((e) {
      showToast('更换失败！');
    });
  }

  _showUpdateDialog(String name, String weight, Person person) {
    DialogHelper.showUpdatePersonDialog(context,
        name: name, weight: weight, person: person);
  }

  _showDeleteDialog(String name, Person person) {
    DialogHelper.showDeleteCardDialog(context,
        content: '确认删除\'$name\'卡吗？', person: person);
  }

  Widget buildDocumentEmpty() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10))),
      margin: EdgeInsets.all(15),
      width: 375,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            ImageHelper.imageRes("home_document_empty.png"),
            width: 164,
            height: 128,
          ),
          TextHelper.TextCreateWith(
            text: "暂时还没有识别记录哦～",
            fontSize: 15,
            color: Color(0xFF929292),
          )
        ],
      ),
    );
  }

  _jumpPhoto() async {
    // final XFile photo = await _picker.pickImage(source: ImageSource.camera);
    // debugPrint("Photo = ${photo.path}");
    // Navigator.of(context).pushNamed(RouteName.conversion_page, arguments: {
    //   "imagePath": photo.path,
    //   "index": 0,
    //   "callback": () {
    //     _jumpPhoto();
    //   }
    // });
    Navigator.of(context).pushNamed(RouteName.camera_page);
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
