import 'package:data_plugin/bmob/bmob_query.dart';
import 'package:data_plugin/bmob/response/bmob_saved.dart';
import 'package:data_plugin/bmob/response/bmob_updated.dart';
import 'package:data_plugin/bmob/table/bmob_user.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graphic_conversion/event/any_event.dart';
import 'package:graphic_conversion/event/event_bus_util.dart';
import 'package:graphic_conversion/table/person.dart';
import 'package:graphic_conversion/table/pets.dart';
import 'package:graphic_conversion/table/record.dart';
import 'package:graphic_conversion/ui/helper/resoure_helper.dart';
import 'package:graphic_conversion/ui/helper/user_helper.dart';
import 'package:graphic_conversion/utils/common_utils.dart';
import 'package:graphic_conversion/utils/lottery_utils.dart';
import 'package:graphic_conversion/utils/string_utils.dart';
import 'package:oktoast/oktoast.dart';

import '../../configs.dart';

class ExtractResultDialog extends StatefulWidget {
  final List<Person> result;
  final String resultDesc;
  final bool isVertical;
  final int type;

  ExtractResultDialog(
      {this.result, this.resultDesc, this.isVertical, this.type});

  @override
  _ExtractResultDialogState createState() => _ExtractResultDialogState();
}

class _ExtractResultDialogState extends State<ExtractResultDialog> {
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

  List<Person> _result = [];
  String _resultDesc;
  bool _isVertical = true;
  List<Person> personList = [];
  Person person;
  int _type = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _result = widget.result;
    _resultDesc = widget.resultDesc;
    _isVertical = widget.isVertical == null ? true : widget.isVertical;
    _type = widget.type == null ? 0 : widget.type;
  }

  @override
  Widget build(BuildContext context) {
    return RotatedBox(
      quarterTurns: _isVertical ? 0 : 1,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                color: Colors.white),
            margin: EdgeInsets.only(top: ScreenUtil().setHeight(45)),
            width: ScreenUtil().setWidth(325),
            child: Stack(
              alignment: Alignment.topRight,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Stack(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Container(
                            alignment: Alignment.topRight,
                            margin: EdgeInsets.only(
                                top: ScreenUtil().setHeight(10),
                                right: ScreenUtil().setWidth(10)),
                            child: Image.asset(
                              ImageHelper.imageRes('icon_cancel.png'),
                              width: ScreenUtil().setWidth(35),
                              height: ScreenUtil().setHeight(35),
                            ),
                          ),
                        ),
                        Container(
                          alignment: Alignment.topCenter,
                          margin:
                              EdgeInsets.only(top: ScreenUtil().setHeight(15)),
                          child: TextHelper.TextCreateWith(
                            text: "恭喜获得",
                            isBlod: true,
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFFF6642A),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: ScreenUtil().setHeight(30),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 50,
                          width:_type==0?
                              _result.length > 5 ? 300 : _result.length * 60.0: _result.length > 4 ? 300 : (_result.length+1) * 60.0,
                          child: buildResults(),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: ScreenUtil().setHeight(20),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      child: TextHelper.TextCreateWith(
                        text: "${_resultDesc}",
                        fontSize: 14,
                        color: Color(0xFF00C27C),
                      ),
                    ),
                    SizedBox(
                      height: ScreenUtil().setHeight(20),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Container(
                            margin: EdgeInsets.only(
                                bottom: ScreenUtil().setHeight(25)),
                            height: ScreenUtil().setHeight(50),
                            width: ScreenUtil().setWidth(122),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: Color(0x0D00C27C),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            child: TextHelper.TextCreateWith(
                              text: "确认",
                              fontSize: 16,
                              color: Color(0xFF00C27C),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            _lottery(_result.length);
                          },
                          child: Container(
                            margin: EdgeInsets.only(
                                bottom: ScreenUtil().setHeight(25)),
                            height: ScreenUtil().setHeight(50),
                            width: ScreenUtil().setWidth(122),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: Color(0xFF00C27C),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            child: TextHelper.TextCreateWith(
                              text: "再抽${_result.length}次",
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
                // GestureDetector(
                //   behavior: HitTestBehavior.opaque,
                //   onTap: () {
                //     Navigator.of(context).pop();
                //   },
                //   child: Container(
                //     width: 50,
                //     height: 50,
                //     alignment: Alignment.center,
                //     child: Image.asset(
                //       ImageHelper.imageRes("vip_close.png"),
                //       width: 16,
                //       height: 16,
                //     ),
                //   ),
                // )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildResults() {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _type == 0 ? _result.length : _result.length + 1,
        itemBuilder: (ctx, index) {
          return buildModel(_result, index);
        },
      ),
    );
  }

  Widget buildModel(List<Person> persons, int index) {
    Color borderColor=Color(0xFF00C27C);
    Color bgColor=Color(0x1F00C27C);
    if(index<_result.length&&_type==1) {
      if(persons[index].level==2){
        borderColor = Color(0xFFFAF50D);
        bgColor=Color(0x1FFAF50D);
      }else if(persons[index].level==1){
        borderColor = Color(0xFF8A4ED0);
        bgColor=Color(0x1F8A4ED0);
      }else if(persons[index].level==0){
        borderColor = Color(0xFF01B2DE);
        bgColor=Color(0x1F01B2DE);
      }
    }
    return GestureDetector(
      onTap: () {
        // _selectHead(index);
      },
      child: index == _result.length
          ? Container(
              alignment: Alignment.center,
              width: 50,
              height: 50,
              margin: EdgeInsets.only(left: 5, right: 5),
              decoration: BoxDecoration(
                // color: bgColor,
                border: Border.all(color: borderColor, width: 2),
                color: bgColor,
                borderRadius: BorderRadius.all(
                  Radius.circular(2),
                ),
                // border: userVM.hasUser
                //     ? Border.all(color: Color(0xFFFFFFFF), width: 1)
                //     : Border.all(color: Color(0xFFFFFFFF), width: 0)
                // border: Border.all(color: Color(0x33FFFFFF), width: 2),
              ),
              child: Stack(
                children: [
                  Image.asset(
                    ImageHelper.imageRes('pet0.png'),
                    width: 50,
                    height: 50,
                    fit: BoxFit.fill,
                  ),
                  Positioned(
                    left: 5,
                    right:5,
                    top: 5,
                    bottom: 5,
                    child:       TextHelper.TextCreateWith(
                      text: "",
                      fontSize: ScreenUtil().setSp(10),
                      color: borderColor,
                    ),),
                ],
              ),
            )
          : Container(
              alignment: Alignment.center,
              width: 50,
              height: 50,
              margin: EdgeInsets.only(left: 5, right: 5),
              decoration: BoxDecoration(
                // color: bgColor,
                border: Border.all(color: borderColor, width: 2),
                color: bgColor,
                borderRadius: BorderRadius.all(
                  Radius.circular(2),
                ),
                // border: userVM.hasUser
                //     ? Border.all(color: Color(0xFFFFFFFF), width: 1)
                //     : Border.all(color: Color(0xFFFFFFFF), width: 0)
                // border: Border.all(color: Color(0x33FFFFFF), width: 2),
              ),
              child: Stack(
                children: [
                  Image.asset(
                    ImageHelper.imageRes('${_result[index].localPath}'),
                    width: 50,
                    height: 50,
                    fit: BoxFit.fill,
                  ),
      Positioned(
        left: 5,
        right:5,
        top: 5,
        bottom: 5,
        child:       TextHelper.TextCreateWith(
        text: "${persons[index].names}",
        fontSize: ScreenUtil().setSp(10),
        color: borderColor,
      ),),
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

  _lottery(int times) async {
    Pets pet = Pets();
    List<String> item = Configs.petItems;
    BmobUser local = UserHelper().bmobUserVM.bmobUserModel;
    if (_type == 1) {
      personList = Configs.pets;
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
    } else {
      personList = Configs.persons;
    }
    if (personList == null || personList.length <= 0) {
      showToast('网络错误！');
    }
    if (!await CommonUtils.isNetConnected()) {
      showToast('请确认网络连接！');
    }

    if (local.coins < times) {
      showToast('代币不足！');
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

      if (_type == 1) {
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
      }

      resultPerson.add(person);
      result += person.names + " ";
    }

    if (_type == 1) local.petCoins = local.petCoins + times * 60;
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

    setState(() {
      _result = resultPerson;
      _resultDesc = result;
    });
    //  showToast(result);
  }
}
