import 'package:data_plugin/bmob/response/bmob_saved.dart';
import 'package:data_plugin/bmob/response/bmob_updated.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graphic_conversion/event/any_event.dart';
import 'package:graphic_conversion/event/event_bus_util.dart';
import 'package:graphic_conversion/table/person.dart';
import 'package:graphic_conversion/ui/helper/resoure_helper.dart';
import 'package:graphic_conversion/ui/helper/user_helper.dart';
import 'package:graphic_conversion/utils/string_utils.dart';
import 'package:oktoast/oktoast.dart';

import '../../configs.dart';

typedef PersonCallback = void Function(String name,String weight);

class UpdatePersonDialog extends StatefulWidget {
  final PersonCallback callback;
  final String name;
  final String weight;
  final Person person;

  UpdatePersonDialog({ this.callback,this.name,this.weight,this.person});

  @override
  _UpdatePersonDialogState createState() => _UpdatePersonDialogState();
}

class _UpdatePersonDialogState extends State<UpdatePersonDialog> {

  TextEditingController _nameController = TextEditingController();
  TextEditingController _weightController = TextEditingController();

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
    // TODO: implement initState
    super.initState();
    _nameController.text=widget.name;
    _weightController.text=widget.weight;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(15)),
              color: Colors.white),
          margin: EdgeInsets.only(top: ScreenUtil().setHeight(45)),
          width: ScreenUtil().setWidth(300),
          child: Stack(
            alignment: Alignment.topRight,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Stack(children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child:Container(
                        alignment: Alignment.topRight,
                        margin: EdgeInsets.only(top: ScreenUtil().setHeight(10),right: ScreenUtil().setWidth(10)),
                        child: Image.asset(
                          ImageHelper.imageRes('icon_cancel.png'),
                          width: ScreenUtil().setWidth(35),
                          height: ScreenUtil().setHeight(35),
                        ) ,),
                    ),
                    Container(
                      alignment: Alignment.topCenter,
                      margin: EdgeInsets.only(top: ScreenUtil().setHeight(25)),
                      child:
                    TextHelper.TextCreateWith(
                      text: "更新卡片",
                      isBlod:true,
                      fontSize: 19,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF333333),
                    ),),
                  ],),
                  SizedBox(
                    height: ScreenUtil().setHeight(20),),
                  Container(
                    height: ScreenUtil().setHeight(50),
                    margin: EdgeInsets.symmetric(
                        horizontal: ScreenUtil().setWidth(20)),
                    padding: EdgeInsets.symmetric(
                        horizontal: ScreenUtil().setWidth(20)),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(25)),
                      color: Color(0xFFF4F4F4),
                    ),
                    child: TextField(
                      textAlign: TextAlign.start,
                      onChanged: (value) {
                      },
                      style: TextStyle(fontSize: 17, color: Color(0xFFFF5F5F)),
                      controller: _nameController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        counterText: "",
                        hintText:widget.name,
                      ),
                    ),
                  ),

                  SizedBox(
                    height: ScreenUtil().setHeight(20),),
                  Container(
                    height: ScreenUtil().setHeight(50),
                    margin: EdgeInsets.symmetric(
                        horizontal: ScreenUtil().setWidth(20)),
                    padding: EdgeInsets.symmetric(
                        horizontal: ScreenUtil().setWidth(20)),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(25)),
                      color: Color(0xFFF4F4F4),
                    ),
                    child: TextField(
                      textAlign: TextAlign.start,
                      onChanged: (value) {
                      },
                      style: TextStyle(fontSize: 17, color: Color(0xFF000000)),
                      controller: _weightController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        counterText: "",
                        hintText:widget.weight,
                      ),
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [ WhitelistingTextInputFormatter.digitsOnly],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (StringUtils.isNull(_nameController.text)) {
                        showToast("卡片名不能为空");
                        return;
                      }

                      if (StringUtils.isNull(_weightController.text)) {
                        showToast("权重不能为空");
                        return;
                      }

                      if (_weightController.text==widget.weight&&_nameController.text==widget.name) {
                        showToast("无更新内容");
                        return;
                      }
                      _updatePerson();
                    },
                    child: Container(
                      margin: EdgeInsets.only(top: ScreenUtil().setHeight(30),
                          bottom: ScreenUtil().setHeight(25)),
                      height: ScreenUtil().setHeight(50),
                      width: ScreenUtil().setWidth(162),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Color(0xFF00C27C),
                          borderRadius:
                          BorderRadius.all(Radius.circular(25))),
                      child: TextHelper.TextCreateWith(
                        text: "更新",
                        fontSize: 16,
                        isBlod: true,
                        color: Colors.white,
                      ),
                    ),
                  )
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
    );
  }

  _updatePerson(){
    Person person=widget.person;
    Configs.persons.remove(person);
    person.user=UserHelper.instance.bmobUserVM.bmobUserModel;
    person.names=_nameController.text;
    person.weight=int.parse(_weightController.text);
    person.update().then((BmobUpdated bmobUpdated) {
      EventBusUtil.getInstance().fire(AnyEvent(AnyEvent.REFRESH_CARDS));
      Navigator.of(context).pop();
      Configs.persons.add(person);
      showToast("更新成功");
    }).catchError((e) {
      showToast("更新失败");
    });
  }
}
