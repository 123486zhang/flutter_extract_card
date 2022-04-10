import 'dart:io';
import 'dart:ui';

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
import 'package:graphic_conversion/ui/helper/buried_point_helper.dart';
import 'package:graphic_conversion/ui/helper/resoure_helper.dart';
import 'package:graphic_conversion/ui/helper/user_helper.dart';
import 'package:graphic_conversion/utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:graphic_conversion/view_model/document_view_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

class HeadSelectPage extends StatefulWidget {
  @override
  _HeadSelectPageState createState() => _HeadSelectPageState();
}

class _HeadSelectPageState extends State<HeadSelectPage> {
  final ImagePicker _picker = ImagePicker();

  int _itemLength = 0;

  List<String> headImages = [
    'head1.png',
    'head2.png',
    'head3.png',
    'head4.png',
    'head5.png',
    'head6.png',
    'head7.png',
    'head8.png',
    'head9.png',
    'head10.png',
    'head11.png',
    'head12.png',
    'head13.png',
    'head14.png',
    'head15.png',
    'head16.png',
    'head17.png',
    'head18.png',
    'ic_img1.png',
    'ic_img2.png',
    'ic_img3.png',
    'ic_img4.png',
    'ic_img5.png',
    'ic_img6.png',
    'ic_img7.png',
    'ic_img8.png',
    'ic_img9.png',
    'ic_img10.png',
    'ic_img11.png',
    'ic_img12.png'
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
            Expanded(child: buildHeads()),
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
              text: "头像选择",
              fontSize: 18,
              color: Color(0xFF36414B),
              isBlod: true,
            ),
          )
        ],
      ),
    );
  }

  Widget buildHeads() {
    return Container(
      margin: EdgeInsets.only(top: 15, bottom: 20, left: 15, right: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      child: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 20),
        itemCount: headImages.length,
        itemBuilder: (ctx, index) {
          return buildModel(headImages, index);
        },
      ),
    );
  }

  Widget buildModel(List<String> heads, int index) {
    double topLeft = index == 0 ? 10 : 0;
    double topRight = index == 0 ? 10 : 0;
    double bottomLeft = index == _itemLength - 1 ? 10 : 0;
    double bottomRight = index == _itemLength - 1 ? 10 : 0;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            _selectHead(index);
          },
          child: Container(
            width: ScreenUtil().setWidth(80),
            height: ScreenUtil().setHeight(80),
            margin: EdgeInsets.only(
                top: index == 0 ? 0 : ScreenUtil().setHeight(34)),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(30),
              ),
              // border: userVM.hasUser
              //     ? Border.all(color: Color(0xFFFFFFFF), width: 1)
              //     : Border.all(color: Color(0xFFFFFFFF), width: 0)
              // border: Border.all(color: Color(0x33FFFFFF), width: 2),
            ),
            child: ClipOval(
              child: Image.asset(
                ImageHelper.imageRes(heads[index]),
                fit: BoxFit.fill,
                width: ScreenUtil().setWidth(80),
                height: ScreenUtil().setHeight(80),
              ),
            ),
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

  _selectHead(int index) {
    BmobUser local = UserHelper().bmobUserVM.bmobUserModel;
    local.headId = index;
    local.update().then((BmobUpdated bmobUpdated) {
      UserHelper().bmobUserVM.bmobUserModel = local;
      showToast('更换成功！');
      EventBusUtil.getInstance().fire(AnyEvent(AnyEvent.REFRESH_HEAD));
      Navigator.of(context).pop();
    }).catchError((e) {
      showToast('更换失败！');
    });
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

}
