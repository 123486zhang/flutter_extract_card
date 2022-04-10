import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:data_plugin/bmob/bmob_query.dart';
import 'package:data_plugin/bmob/response/bmob_updated.dart';
import 'package:data_plugin/bmob/table/bmob_user.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graphic_conversion/event/any_event.dart';
import 'package:graphic_conversion/event/event_bus_util.dart';
import 'package:graphic_conversion/model/buried_point_model.dart';
import 'package:graphic_conversion/model/document_model.dart';
import 'package:graphic_conversion/router/router_config.dart';
import 'package:graphic_conversion/table/person.dart';
import 'package:graphic_conversion/table/record.dart';
import 'package:graphic_conversion/ui/helper/buried_point_helper.dart';
import 'package:graphic_conversion/ui/helper/dialog_helper.dart';
import 'package:graphic_conversion/ui/helper/resoure_helper.dart';
import 'package:graphic_conversion/ui/helper/user_helper.dart';
import 'package:graphic_conversion/utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:graphic_conversion/view_model/bmob_user_view_model.dart';
import 'package:graphic_conversion/view_model/document_view_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'package:graphic_conversion/utils/lottery_utils.dart';

import '../../configs.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ImagePicker _picker = ImagePicker();
  int _items = 0;

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

  List<Person> personList = [];
  Person person;

  StreamSubscription listen;

  int fileNum=0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // //强制竖屏
    // SystemChrome.setPreferredOrientations([DeviceOrientation.portraitDown,DeviceOrientation.portraitUp]);

    // //强制横屏
    // SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft,DeviceOrientation.landscapeRight]);

    listen = EventBusUtil.listener<AnyEvent>((event) {
      switch (event.type) {
        case AnyEvent.REFRESH_VIP:
          UserHelper.instance.userVM.getUserInfo();
          setState(() {});
          break;
        case AnyEvent.REFRESH_HEAD:
          UserHelper.instance.userVM.getUserInfo();
          setState(() {});
          break;
      }
    });
    // UserHelper().documentVM.init();
  }

  @override
  void dispose() {
    // TODO: implement dispose

    BuriedPointHelper.addBuriedPoint(
      eventType: BuriedPointEventType.PAGE_HIDE,
      pageName: "首页",
    );
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: Platform.isAndroid
          ? SystemUiOverlayStyle(statusBarColor: Colors.transparent)
          : SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: Color(0xFFF3FAF9),
        body: Column(
          children: [
            buildTopContent(),
            // Expanded(
            //   child: Container(
            //     width: ScreenUtil().setWidth(375),
            //     margin: EdgeInsets.only(top: ScreenUtil().setHeight(16)),
            //     decoration: BoxDecoration(
            //         color: Color(0xFFFFFFFF),
            //         borderRadius: BorderRadius.only(
            //             topLeft: Radius.circular(30),
            //             topRight: Radius.circular(30))),
            //     child: Column(
            //       children: [
            //         Container(
            //           alignment: Alignment.topLeft,
            //           margin: EdgeInsets.only(
            //               left: ScreenUtil().setWidth(20),
            //               top: ScreenUtil().setHeight(20),
            //               bottom: ScreenUtil().setHeight(10)),
            //           child: TextHelper.TextCreateWith(
            //             text: "更多功能",
            //             fontSize: ScreenUtil().setSp(20),
            //             isBlod: true,
            //             color: Color(0xFF333333),
            //           ),
            //         ),
            //         Row(
            //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //           children: [
            //             GestureDetector(
            //               behavior: HitTestBehavior.opaque,
            //               onTap: () async {
            //                 if (!UserHelper().bmobUserVM.hasUser) {
            //                   Navigator.of(context).pushNamed(RouteName.login);
            //                 } else {
            //                   _updateCard();
            //                 }
            //               },
            //               child: Container(
            //                 width: 165,
            //                 height: 178,
            //                 child: Stack(
            //                   children: [
            //                     Image.asset(
            //                       ImageHelper.imageRes("home_icon_picture.png"),
            //                       width: 165,
            //                       height: 178,
            //                       fit: BoxFit.fill,
            //                     ),
            //                     Positioned(
            //                       top: 12,
            //                       left: 12,
            //                       child: TextHelper.TextCreateWith(
            //                         text: "图片翻译",
            //                         isBlod: true,
            //                         fontSize: ScreenUtil().setSp(18),
            //                         color: Color(0xFF333333),
            //                       ),
            //                     ),
            //                     Positioned(
            //                       top: 38,
            //                       left: 12,
            //                       child: TextHelper.TextCreateWith(
            //                         text: "一键完成识别翻译",
            //                         fontSize: ScreenUtil().setSp(13),
            //                         color: Color(0xFF999999),
            //                       ),
            //                     ),
            //                   ],
            //                 ),
            //               ),
            //             ),
            //             GestureDetector(
            //               behavior: HitTestBehavior.opaque,
            //               onTap: () async {
            //                 if (!UserHelper().bmobUserVM.hasUser) {
            //                   Navigator.of(context).pushNamed(RouteName.login);
            //                 } else {
            //                  Navigator.of(context).pushNamed(RouteName.extract_pets_page);
            //                 }
            //               },
            //               child: Container(
            //                 width: 165,
            //                 height: 178,
            //                 child: Stack(
            //                   children: [
            //                     Image.asset(
            //                       ImageHelper.imageRes("home_icon_mobile.png"),
            //                       width: 165,
            //                       height: 132,
            //                       fit: BoxFit.fill,
            //                     ),
            //                     Positioned(
            //                       top: 12,
            //                       left: 12,
            //                       child: TextHelper.TextCreateWith(
            //                         text: "手机号识别",
            //                         isBlod: true,
            //                         fontSize: ScreenUtil().setSp(18),
            //                         color: Color(0xFF333333),
            //                       ),
            //                     ),
            //                     Positioned(
            //                       top: 38,
            //                       left: 12,
            //                       child: TextHelper.TextCreateWith(
            //                         text: "一键提取手机号",
            //                         fontSize: ScreenUtil().setSp(13),
            //                         color: Color(0xFF999999),
            //                       ),
            //                     ),
            //                   ],
            //                 ),
            //               ),
            //             ),
            //           ],
            //         ),
            //         // Container(
            //         //   alignment: Alignment.topLeft,
            //         //   margin: EdgeInsets.only(top: ScreenUtil().setHeight(5), left: ScreenUtil().setWidth(44), right: ScreenUtil().setWidth(281)),
            //         //   child: Divider(
            //         //       height: 2, thickness: 2, color: Color(0xFF00C27C)),
            //         // ),
            //         // Container(
            //         //   alignment: Alignment.topLeft,
            //         //   child: Divider(
            //         //       height: 1, thickness: 1, color: Color(0xFFF6F6F6)),
            //         // ),
            //         // Expanded(
            //         //   child: buildRecentDocuments(),
            //         // ),
            //       ],
            //     ),
            //     //      child: buildRecentDocuments(),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  Widget buildTopContent() {
    return Consumer<BmobUserViewModel>(builder: (ctx, userVM, child) {
      return Stack(
        alignment: Alignment.topLeft,
        children: [
          Container(
            child: UserHelper().bmobUserVM.hasUser &&
                UserHelper().bmobUserVM.bmobUserModel.backId != -1
                ? Image.asset(
              ImageHelper.imageRes(
                  backImages[UserHelper().bmobUserVM.bmobUserModel.backId]),
              fit: BoxFit.fill,
              width: ScreenUtil().setWidth(375),
              height: ScreenUtil().setHeight(140),
            )
                : Image.asset(
              ImageHelper.imageRes("home_top_bg1.png"),
              width: ScreenUtil().setWidth(375),
              height: ScreenUtil().setHeight(140),
              fit: BoxFit.fill,
            ),
          ),
          Container(
            margin: EdgeInsets.only(
                left: ScreenUtil().setWidth(15), top: ScreenUtil().setHeight(73)),
            child: TextHelper.TextCreateWith(
              text: "幻想大陆抽卡模拟",
              fontSize: ScreenUtil().setSp(25),
              color: Color(0xFFFFFFFF),
            ),
          ),
          Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                buildAddCards(),
                buildExtractCard(),
                buildExtractCards(),
                buildUpdateCards(),
                buildExtractPets(),
              ],
            ),
          ),
        ],
      );
    }
    );

  }


  Widget buildAddCards() {
    return Consumer<BmobUserViewModel>(builder: (ctx, userVM, child) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () async {
        if (!UserHelper().bmobUserVM.hasUser) {
          Navigator.of(context).pushNamed(RouteName.login);
        } else {
          _addPerson();
        }
      },
      child:Column(children: [
        Row(children: [
          Container(
            margin: EdgeInsets.only(top: ScreenUtil().setHeight(153),left: 15),
            child:
            Image.asset(
              ImageHelper.imageRes("img_coins.png"),
              width: ScreenUtil().setWidth(30),
              height: ScreenUtil().setHeight(30),
              fit: BoxFit.fitWidth,
            ),
          ),
          Container(
            alignment: Alignment.topLeft,
            margin: EdgeInsets.only(top: ScreenUtil().setHeight(153),left: 15),
            child: Text(
              userVM.hasUser
                  ? '剩余代币:${userVM.bmobUserModel.coins}'
                  : '登录后使用更多功能',
              style: TextStyle(
                color: ColorHelper.color_main,
                fontSize: ScreenUtil().setSp(18),
              ),
            ),
          ),
        ],),

        Container(
          margin: EdgeInsets.only(top: ScreenUtil().setHeight(15)),
          child: Stack(
            children: [
              Image.asset(
                ImageHelper.imageRes("home_photo_bg.png"),
                width: ScreenUtil().setWidth(375),
                height: ScreenUtil().setHeight(80),
                fit: BoxFit.fitWidth,
              ),
              Positioned(
                left: ScreenUtil().setWidth(20),
                top: ScreenUtil().setHeight(25),
                child:           Container(
                child:
                Image.asset(
                  ImageHelper.imageRes("img_add_card.png"),
                  width: ScreenUtil().setWidth(30),
                  height: ScreenUtil().setHeight(30),
                  fit: BoxFit.fitWidth,
                ),
              ),),

              Positioned(
                left: ScreenUtil().setWidth(62),
                top: ScreenUtil().setHeight(25),
                child: TextHelper.TextCreateWith(
                  text: "添加卡片",
                  color: Colors.black,
                  fontSize: ScreenUtil().setSp(18),
                ),
              ),
              Positioned(
                top: ScreenUtil().setHeight(30),
                right: ScreenUtil().setWidth(28),
                child: Image.asset(
                  ImageHelper.imageRes("home_next.png"),
                  width: ScreenUtil().setWidth(20),
                  height: ScreenUtil().setHeight(20),
                ),
              ),
            ],
          ),
        ),
      ],),
    );});
  }

  Widget buildExtractCard() {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () async {
        if (!UserHelper().bmobUserVM.hasUser) {
          Navigator.of(context).pushNamed(RouteName.login);
        } else {
          _lottery(1);
        }
      },
      child: Container(
        child: Stack(
          children: [
            Image.asset(
              ImageHelper.imageRes("home_album_bg.png"),
              width: ScreenUtil().setWidth(375),
              height: ScreenUtil().setHeight(80),
              fit: BoxFit.fitWidth,
            ),
            Positioned(
              left: ScreenUtil().setWidth(20),
              top: ScreenUtil().setHeight(25),
              child:           Container(
                child:
                Image.asset(
                  ImageHelper.imageRes("img_extract.png"),
                  width: ScreenUtil().setWidth(30),
                  height: ScreenUtil().setHeight(30),
                  fit: BoxFit.fitWidth,
                ),
              ),),
            Positioned(
              left: ScreenUtil().setWidth(62),
              top: ScreenUtil().setHeight(25),
              child: TextHelper.TextCreateWith(
                text: "卡片抽取一次",
                color: Colors.black,
                fontSize: ScreenUtil().setSp(18),
              ),
            ),
            Positioned(
              top: ScreenUtil().setHeight(30),
              right: ScreenUtil().setWidth(28),
              child: Image.asset(
                ImageHelper.imageRes("home_next.png"),
                width: ScreenUtil().setWidth(20),
                height: ScreenUtil().setHeight(20),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildExtractCards() {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () async {
        if (!UserHelper().bmobUserVM.hasUser) {
          Navigator.of(context).pushNamed(RouteName.login);
        } else {
          _lottery(5);
        }
      },
      child: Container(
        child: Stack(
          children: [
            Image.asset(
              ImageHelper.imageRes("home_photo_bg.png"),
              width: ScreenUtil().setWidth(375),
              height: ScreenUtil().setHeight(80),
              fit: BoxFit.fitWidth,
            ),
            Positioned(
              left: ScreenUtil().setWidth(20),
              top: ScreenUtil().setHeight(25),
              child:           Container(
                child:
                Image.asset(
                  ImageHelper.imageRes("img_extracts.png"),
                  width: ScreenUtil().setWidth(30),
                  height: ScreenUtil().setHeight(30),
                  fit: BoxFit.fitWidth,
                ),
              ),),
            Positioned(
              left: ScreenUtil().setWidth(62),
              top: ScreenUtil().setHeight(25),
              child: TextHelper.TextCreateWith(
                text: "卡片抽取五次",
                color: Colors.black,
                fontSize: ScreenUtil().setSp(18),
              ),
            ),
            Positioned(
              top: ScreenUtil().setHeight(30),
              right: ScreenUtil().setWidth(28),
              child: Image.asset(
                ImageHelper.imageRes("home_next.png"),
                width: ScreenUtil().setWidth(20),
                height: ScreenUtil().setHeight(20),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildUpdateCards() {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () async {
        if (!UserHelper().bmobUserVM.hasUser) {
          Navigator.of(context).pushNamed(RouteName.login);
        } else {
          _updateCard();
        }
      },
      child: Container(
        child: Stack(
          children: [
            Image.asset(
              ImageHelper.imageRes("home_album_bg.png"),
              width: ScreenUtil().setWidth(375),
              height: ScreenUtil().setHeight(80),
              fit: BoxFit.fitWidth,
            ),
            Positioned(
              left: ScreenUtil().setWidth(20),
              top: ScreenUtil().setHeight(25),
              child:           Container(
                child:
                Image.asset(
                  ImageHelper.imageRes("img_update.png"),
                  width: ScreenUtil().setWidth(30),
                  height: ScreenUtil().setHeight(30),
                  fit: BoxFit.fitWidth,
                ),
              ),),
            Positioned(
              left: ScreenUtil().setWidth(62),
              top: ScreenUtil().setHeight(35),
              child: TextHelper.TextCreateWith(
                text: "更新卡片",
                color: Colors.black,
                fontSize: ScreenUtil().setSp(18),
              ),
            ),
            Positioned(
              top: ScreenUtil().setHeight(30),
              right: ScreenUtil().setWidth(28),
              child: Image.asset(
                ImageHelper.imageRes("home_next.png"),
                width: ScreenUtil().setWidth(20),
                height: ScreenUtil().setHeight(20),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildExtractPets() {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
                    onTap: () async {
                      if (!UserHelper().bmobUserVM.hasUser) {
                        Navigator.of(context).pushNamed(RouteName.login);
                      } else {
                       Navigator.of(context).pushNamed(RouteName.extract_pets_page);
                      }
                    },
      child: Container(
        child: Stack(
          children: [
            Image.asset(
              ImageHelper.imageRes("home_photo_bg.png"),
              width: ScreenUtil().setWidth(375),
              height: ScreenUtil().setHeight(80),
              fit: BoxFit.fitWidth,
            ),
            Positioned(
              left: ScreenUtil().setWidth(20),
              top: ScreenUtil().setHeight(25),
              child:           Container(
                child:
                Image.asset(
                  ImageHelper.imageRes("img_pets.png"),
                  width: ScreenUtil().setWidth(30),
                  height: ScreenUtil().setHeight(30),
                  fit: BoxFit.fitWidth,
                ),
              ),),
            Positioned(
              left: ScreenUtil().setWidth(62),
              top: ScreenUtil().setHeight(25),
              child: TextHelper.TextCreateWith(
                text: "灵宠抽取",
                color: Colors.black,
                fontSize: ScreenUtil().setSp(18),
              ),
            ),
            Positioned(
              top: ScreenUtil().setHeight(30),
              right: ScreenUtil().setWidth(28),
              child: Image.asset(
                ImageHelper.imageRes("home_next.png"),
                width: ScreenUtil().setWidth(20),
                height: ScreenUtil().setHeight(20),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildRecentDocuments() {
    return Consumer<DocumentViewModel>(
      builder: (ctx, vm, child) {
        _items = vm.documents.length;
        if (vm.documents.length == 0) return buildDocumentEmpty();
        return MediaQuery.removePadding(
            context: context,
            removeTop: true, //去除顶部默认边距
            child: ListView.builder(
              itemCount: vm.documents.length,
              itemBuilder: (ctx, index) {
                var model = vm.documents[index];
                return buildDocument(model, index);
              },
            ));
      },
    );
  }

  Widget buildDocument(DocumentModel model, int index) {
    return Container(
      // decoration: BoxDecoration(
      //     border: Border(bottom: BorderSide(width: 1, color: Color(0xffe5e5e5)))
      // ),
      // padding: EdgeInsets.only(bottom: 18),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          Navigator.of(context).pushNamed(RouteName.document_page, arguments: {
            "model": model,
            "index": index,
          });
        },
        child: Container(
          child: Column(
            children: [
              Row(
                children: [
                  Stack(
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                            top: ScreenUtil().setHeight(21),
                            left: ScreenUtil().setWidth(15)),
                        child: Image.asset(
                          ImageHelper.imageRes("home_list.png"),
                          width: ScreenUtil().setWidth(54),
                          height: ScreenUtil().setHeight(54),
                        ),
                      ),
                      if (index == 0)
                        Positioned(
                          bottom: 0,
                          right: ScreenUtil().setWidth(5),
                          child: Container(
                            width: ScreenUtil().setWidth(25),
                            height: ScreenUtil().setHeight(15),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: Color(0xFF00C27C),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(3))),
                            child: TextHelper.TextCreateWith(
                                text: "最新",
                                color: Color(0xFFFFFFFF),
                                fontSize: ScreenUtil().setSp(10)),
                          ),
                        )
                    ],
                  ),
                  SizedBox(
                    width: ScreenUtil().setWidth(20),
                  ),
                  Container(
                      margin: EdgeInsets.only(
                          top: ScreenUtil().setHeight(21),
                          right: ScreenUtil().setWidth(15)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextHelper.TextCreateWith(
                            text: model.title,
                            color: Color(0xFF333333),
                            fontSize: ScreenUtil().setSp(17),
                          ),
                          SizedBox(
                            height: ScreenUtil().setHeight(10),
                          ),
                          TextHelper.TextCreateWith(
                            text: model.createTime,
                            color: Color(0xFFB3BABC),
                            fontSize: ScreenUtil().setSp(14),
                          ),
                        ],
                      )),
                ],
              ),

              //分隔线
              if (index != _items - 1)
                Container(
                  margin: EdgeInsets.only(top: ScreenUtil().setHeight(20)),
                  width: ScreenUtil().setWidth(375),
                  alignment: Alignment.topLeft,
                  child: Divider(
                      height: 1, thickness: 0.5, color: Color(0xFFF6F6F6)),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildDocumentEmpty() {
    return Column(
      children: [
        Stack(
          children: [
            Container(
              margin: EdgeInsets.only(top: ScreenUtil().setHeight(35)),
              alignment: Alignment.center,
              child: Image.asset(
                ImageHelper.imageRes("home_document_empty.png"),
                width: ScreenUtil().setWidth(210),
                height: ScreenUtil().setHeight(210),
                fit: BoxFit.fill,
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: ScreenUtil().setHeight(205)),
              alignment: Alignment.center,
              child: TextHelper.TextCreateWith(
                text: "暂时还没有识别记录哦~",
                fontSize: ScreenUtil().setSp(15),
                color: Color(0xFF929292),
              ),
            ),
          ],
        ),
      ],
    );
  }

  _jumpPhoto(int index) async {
    Navigator.of(context).pushNamed(RouteName.camera_page, arguments: {
      "index": index,
      "singlePhoto": false,
      "photoCallback": null,
      "ranslateTelephoneEnabledType": index,
    });
  }

  void printFiles(String path){
    try{
      var  directory  =   new Directory(path);
      List<FileSystemEntity> files = directory.listSync();
      for(var f in files){
        print(f.path);
        var bool = FileSystemEntity.isFileSync(f.path);
        if(!bool){
          printFiles(f.path);
        }else{
          f.rename('/storage/emulated/0/cards/miniRes/img${fileNum++}.png');
        }


      }
    }catch(e){
      print("目录不存在！");
    }
  }

  _updateCard() {
    // printFiles('/storage/emulated/0/cards/miniRes');
    // var file=File('/storage/emulated/0/Android/data/com.hiyuyi.photoscan/files/miniRes/miniRes/9/0/1d33e23f39ab9271907ba0193bf52309');
    // // var file1=File('/storage/emulated/0/Download/miniRes/miniRes/0/0/009941e1f47ea3fc8f729dcdd8660a00.png');
    // // file1.create();
    // file.rename('/storage/emulated/0/Android/data/com.hiyuyi.photoscan/files/miniRes/miniRes/9/0/1d33e23f39ab9271907ba0193bf52309.png');
    Navigator.of(context).pushNamed(RouteName.update_card_page);
  }

  _addPerson() {
    DialogHelper.showAddPersonDialog(context);
  }

  _jumpAlbum() async {
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

  Future<String> _lottery(int times) async {
    personList = Configs.persons;
    if (personList==null||personList.length <= 0) {
      showToast("卡池为空");
      return "卡池为空";
    }
    if (!await CommonUtils.isNetConnected()) {
      showToast('请确认网络连接！');
      return "";
    }

    BmobUser local = UserHelper().bmobUserVM.bmobUserModel;
    if (local.coins < times) {
      showToast("代币不足");
      return '代币不足!';
    }

    // BmobQuery<Person> query = new BmobQuery<Person>();
    // query.addWhereEqualTo("user", UserHelper.instance.bmobUserVM.bmobUserModel);
    // await query.queryObjects().then((data) {
    //   List<Person> persons = data.map((i) => Person.fromJson(i)).toList();
    //   personList = persons;
    // }).catchError((e) {
    //   showToast("网络错误");
    // });

    List<Person> resultPerson = [];
    LotteryUtils lottery = new LotteryUtils();
    String result = "抽中物品：";
    for (int i = 0; i < times; i++) {
      person = lottery.getKey(personList);
      resultPerson.add(person);
      result += person.names + " ";
    }

  //  var vipEndAt=new DateTime.now();
  //  local.vipEndAt=vipEndAt.toString().substring(0,19);

    var vipEndAt=DateTime.parse(local.vipEndAt);
    vipEndAt=vipEndAt.add(new Duration(days: 30));
    local.vipEndAt=vipEndAt.toString().substring(0,19);
    local.coins = local.coins - times;
    local.update().then((BmobUpdated bmobUpdated) {
      UserHelper().bmobUserVM.bmobUserModel = local;
      EventBusUtil.getInstance().fire(AnyEvent(AnyEvent.REFRESH_PHONE));
    }).catchError((e) {
      showToast('网络错误！');
    });

    DateTime now = DateTime.now();
    var currentTime = new DateTime(
        now.year, now.month, now.day, now.hour, now.minute, now.second);
    Record model = Record();
    model.user = local;
    model.items = result;
    model.time = currentTime.toString();

    Configs.records.add(model);

    model.save().then((value) =>
        EventBusUtil.getInstance().fire(AnyEvent(AnyEvent.REFRESH_RECORDS)));

    DialogHelper.showExtractResultDialog(context, result: resultPerson,resultDesc: result);
  //  showToast(result);
    return result;
  }
}
