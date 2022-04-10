import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:data_plugin/bmob/bmob_query.dart';
import 'package:data_plugin/bmob/response/bmob_updated.dart';
import 'package:data_plugin/bmob/table/bmob_user.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graphic_conversion/configs.dart';
import 'package:graphic_conversion/data/net/conversion_api.dart';
import 'package:graphic_conversion/data/net/fizz_api.dart';
import 'package:graphic_conversion/event/any_event.dart';
import 'package:graphic_conversion/event/event_bus_util.dart';
import 'package:graphic_conversion/model/buried_point_model.dart';
import 'package:graphic_conversion/model/document_model.dart';
import 'package:graphic_conversion/router/router_config.dart';
import 'package:graphic_conversion/table/record.dart';
import 'package:graphic_conversion/ui/helper/buried_point_helper.dart';
import 'package:graphic_conversion/ui/helper/dialog_helper.dart';
import 'package:graphic_conversion/ui/helper/resoure_helper.dart';
import 'package:graphic_conversion/ui/helper/user_helper.dart';
import 'package:graphic_conversion/ui/manager/cache_audio_manager.dart';
import 'package:graphic_conversion/utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:graphic_conversion/view_model/document_view_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';

class RecentPage extends StatefulWidget {
  @override
  _RecentPageState createState() => _RecentPageState();
}

class _RecentPageState extends State<RecentPage> {
  final ImagePicker _picker = ImagePicker();

  int _itemLength = 0;

  List<Record> records = [];

  StreamSubscription listen;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    listen = EventBusUtil.listener<AnyEvent>((event) {
      switch (event.type) {
        case AnyEvent.REFRESH_RECORDS:
          records.clear();
          records.addAll(Configs.records);
          setState(() {});
          break;
      }
    });


    BmobQuery<Record> query = new BmobQuery<Record>();
    query.addWhereEqualTo("user", UserHelper.instance.bmobUserVM.bmobUserModel);
    query.queryObjects().then((data) {
      records = data.map((i) => Record.fromJson(i)).toList();
      setState(() {});
    }).catchError((e) {});
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
              text: "抽卡记录",
              fontSize: 18,
              color: Color(0xFF36414B),
              isBlod: true,
            ),
          ),
          Positioned(
              right: 25,
              child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () async {
                    BmobQuery<Record> query = new BmobQuery<Record>();
                    query.addWhereEqualTo(
                        "user", UserHelper.instance.bmobUserVM.bmobUserModel);
                    query.queryObjects().then((data) {
                      records = data.map((i) => Record.fromJson(i)).toList();
                      if(records!=null&&records.length>0){
                        for(int i=0;i<records.length;i++){
                          Record localRecord=records[i];
                          localRecord.delete().then((value) => null);
                          if(i==records.length-1){
                            Configs.records.clear();
                            records.clear();
                            setState(() {});
                          }
                        }
                      }

                    }).catchError((e) {});
                  },
                  child:
                  Container(
                    height: 64,
                    alignment: Alignment.center,
                    child: TextHelper.TextCreateWith(
                      text: "清空",
                      fontSize: 16,
                      color: ColorHelper.color_main,
                    ),
                  ),
                  ),),

          Positioned(
            left: 25,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () async {
               _export();
              },
              child:
              Container(
                height: 64,
                alignment: Alignment.center,
                child: TextHelper.TextCreateWith(
                  text: "分享",
                  fontSize: 16,
                  color: ColorHelper.color_main,
                ),
              ),
            ),),
        ],
      ),
    );
  }

  _export() async {
    String shareText='';
    if(records==null||records.length<=0){
      return;
    }
    for(int i=0;i<records.length;i++){
      shareText+=records[i].time.substring(0, 19)+ '\n'+records[i].items+'\n';
    }

    print("result$shareText");
    String filePath = "抽卡记录${DateTime.now().toString().substring(0,19)}";
    File txtFile = await CacheAudioManager.writeDocument(
      text: shareText,
      filePath: filePath,
    );

    _onShare(txtFile.path);

    // DialogHelper.showDocumentSystemShareDialog(context,
    //     callback: (index) {
    //       if (index == 0) {
    //         _onShare(txtFile.path);
    //       } else if (index == 1) {
    //         EasyLoading.show();
    //         ConversionApi.requestShareDoc(contents: [text], translates: []).then((value) async {
    //           if (value != null) {
    //             String docxUrl = value["data"];
    //             String cacheDirPath = await CacheAudioManager.getDocumentCachePath();
    //             String time = "${DateTime.now().millisecondsSinceEpoch}";
    //             File file = File('$cacheDirPath$time.docx');
    //             await DownloadApi.downloadAudio(docxUrl, savePath: file.path);
    //             EasyLoading.dismiss();
    //             _onShare(file.path);
    //           } else {
    //             EasyLoading.dismiss();
    //           }
    //         });
    //       }
    //     }
    // );
  }

  _onShare(String path) async {
    List<String> list = [path];
    final RenderBox box = context.findRenderObject() as RenderBox;
    await Share.shareFiles(list,
        text: "抽奖记录",
        subject: "",
        sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
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
        itemCount: records.length,
        itemBuilder: (ctx, index) {
          return buildModel(records, index);
        },
      ),
    );
  }

  Widget buildModel(List<Record> records, int index) {
    double topLeft = index == 0 ? 10 : 0;
    double topRight = index == 0 ? 10 : 0;
    double bottomLeft = index == _itemLength - 1 ? 10 : 0;
    double bottomRight = index == _itemLength - 1 ? 10 : 0;

    return GestureDetector(
      onTap: () {
        // _selectHead(index);
      },
      child: Container(
        alignment: Alignment.topLeft,
        width: 345,
        height: 90,
        padding: EdgeInsets.all(10),
        margin:
        EdgeInsets.only(top: index == 0 ? 0 : ScreenUtil().setHeight(24)),
        decoration: BoxDecoration(
          color: Color(0x1F00C27C),
          border: Border.all(color: ColorHelper.color_main, width: 1),
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
          // border: userVM.hasUser
          //     ? Border.all(color: Color(0xFFFFFFFF), width: 1)
          //     : Border.all(color: Color(0xFFFFFFFF), width: 0)
          // border: Border.all(color: Color(0x33FFFFFF), width: 2),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextHelper.TextCreateWith(
              text: "${records[index].time.substring(0, 19)}",
              fontSize: 12,
              color: Color(0xFF333333),
            ),
            TextHelper.TextCreateWith(
              text: "${records[index].items}",
              fontSize: 13,
              color: Color(0xFFFF5F5F),
            ),
          ],
        ),
      ),
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
