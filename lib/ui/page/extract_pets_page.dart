import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:data_plugin/bmob/bmob_query.dart';
import 'package:data_plugin/bmob/response/bmob_updated.dart';
import 'package:data_plugin/bmob/table/bmob_user.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graphic_conversion/event/any_event.dart';
import 'package:graphic_conversion/event/event_bus_util.dart';
import 'package:graphic_conversion/locatization/localizations.dart';
import 'package:graphic_conversion/table/person.dart';
import 'package:graphic_conversion/table/record.dart';
import 'package:graphic_conversion/table/pets.dart';
import 'package:graphic_conversion/ui/widget/navigator_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:graphic_conversion/utils/lottery_utils.dart';
import 'package:graphic_conversion/view_model/bmob_user_view_model.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'package:graphic_conversion/channel/android_method_channel.dart';
import 'package:graphic_conversion/channel/ios_method_channel.dart';
import 'package:graphic_conversion/configs.dart';
import 'package:graphic_conversion/router/router_config.dart';
import 'package:graphic_conversion/ui/helper/buried_point_helper.dart';
import 'package:graphic_conversion/ui/helper/dialog_helper.dart';
import 'package:graphic_conversion/ui/helper/resoure_helper.dart';
import 'package:graphic_conversion/ui/helper/user_helper.dart';
import 'package:graphic_conversion/utils/common_utils.dart';

class ExtractPetsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ExtractPetsPageState();
  }
}

class ExtractPetsPageState extends State<ExtractPetsPage> {
  BmobUser _local;
  List<Person> personList = [];
  Person person;
  StreamSubscription listen;

  AudioCache player=AudioCache();
  AudioPlayer audioPlayer=AudioPlayer();

  @override
  void initState() {
    super.initState();

    player.fixedPlayer=audioPlayer;
    _local = UserHelper.instance.bmobUserVM.bmobUserModel;

    listen = EventBusUtil.listener<AnyEvent>((event) {
      switch (event.type) {
        case AnyEvent.REFRESH_RECORDS:
          setState(() {});
          break;
        case AnyEvent.REFRESH_HEAD:
          setState(() {});
          break;
      }
    });

    player.loop('sounds/pet.mp3');
    // //强制横屏
    // SystemChrome.setPreferredOrientations(
    //     [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
  }

  @override
  void dispose() {
    super.dispose();

    if(audioPlayer.state==PlayerState.PLAYING) {
      audioPlayer.stop();
    }

    // //强制竖屏
    // SystemChrome.setPreferredOrientations(
    //     [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
    // SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values); //显示状态栏、
    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    //   statusBarColor: Colors.transparent,
    // ));
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: RotatedBox(
          quarterTurns: 1,
          child: Scaffold(
            extendBodyBehindAppBar: true,
            backgroundColor: Colors.transparent, //把scaffold的背景色改成透明
            body: Stack(
              children: [
                Image.asset(
                  ImageHelper.imageRes("pets_bg.png"),
                  width: 900,
                  height: 500,
                  fit: BoxFit.fill,
                ),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () async {
                    Navigator.of(context).pop();
                  },
                  child: Positioned(
                    left: 0,
                    top: 0,
                    child: Container(
                      width: 150,
                      height: 30,
                    ),
                  ),
                ),
                Positioned(
                  right: 38,
                  top: 6,
                  child: Container(
                    child: TextHelper.TextCreateWith(
                      text:
                          _local.petCoins == null ? '0' : '${_local.petCoins}',
                      color: Color(0xfff59e64),
                      fontSize: 12,
                    ),
                  ),
                ),
                Positioned(
                  right: 130,
                  top: 6,
                  child: Container(
                    child: TextHelper.TextCreateWith(
                      text: '${_local.coins}',
                      color: Color(0xfff3bd58),
                      fontSize: 12,
                    ),
                  ),
                ),
                Positioned(
                  right: 224,
                  top: 6,
                  child: Container(
                    child: TextHelper.TextCreateWith(
                      text: '1000000',
                      color: Color(0xfff6d355),
                      fontSize: 12,
                    ),
                  ),
                ),
                Positioned(
                  right: 263,
                  bottom: 50,
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () async {
                      _lottery(1);
                    },
                    child: Container(
                      width: 60,
                      height: 60,
                    ),
                  ),
                ),
                Positioned(
                  right: 140,
                  bottom: 50,
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () async {
                      _lottery(5);
                    },
                    child: Container(
                      width: 60,
                      height: 60,
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
  }

  _lottery(int times) async {
    personList = Configs.pets;
    if (personList == null || personList.length <= 0) {
      showToast('网络错误！');
    }
    if (!await CommonUtils.isNetConnected()) {
      showToast('请确认网络连接！');
    }

    BmobUser local = UserHelper().bmobUserVM.bmobUserModel;
    if (local.coins < times) {
      showToast('代币不足！');
    }

    Pets pet = Pets();
    pet.user = local;
    bool isSave = true;
    BmobQuery<Pets> query = BmobQuery();
    query.addWhereEqualTo("user", local);
    await query.queryObjects().then((data) {
      // showSuccess(context, data.toString());
      List<Pets> pets = data.map((i) => Pets.fromJson(i)).toList();
      if (pets == null || pets.length == 0) {
        isSave = true;
      } else {
        pet = pets[0];
        isSave = false;
      }
    }).catchError((e) {
      isSave = true;
    });

    List<Person> resultPerson = [];
    LotteryUtils lottery = new LotteryUtils();
    String result = "抽中物品：";
    List<String> item = Configs.petItems;
    for (int i = 0; i < times; i++) {
      person = lottery.getKey(personList);
      if (person.names == item[0]) {
        pet.petFragments += 60;
      } else if (person.names == item[1]) {
        pet.petFragments += 10;
      } else if (person.names == item[2]) {
        pet.petFragments += 5;
      } else if (person.names == item[3]) {
        pet.advancedPills += 2;
      } else if (person.names == item[4]) {
        pet.middlePills += 8;
      } else if (person.names == item[5]) {
        pet.rareHoly++;
      } else if (person.names == item[6]) {
        pet.ordinaryHoly++;
      }
      pet.extractTimes++;

      resultPerson.add(person);
      result += person.names + " ";
    }

    if (isSave) {
      pet.save();
    } else {
      pet.update();
    }

    local.petCoins = local.petCoins + times * 60;
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

    setState(() {});

    DialogHelper.showExtractResultDialog(context,
        result: resultPerson, resultDesc: result, isVertical: false,type: 1);
    // showToast(result);
  }
}
