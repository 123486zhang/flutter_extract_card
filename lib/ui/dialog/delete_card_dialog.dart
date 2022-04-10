import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graphic_conversion/event/any_event.dart';
import 'package:graphic_conversion/event/event_bus_util.dart';
import 'package:graphic_conversion/table/person.dart';
import 'package:oktoast/oktoast.dart';
import 'package:graphic_conversion/ui/helper/resoure_helper.dart';
import 'package:graphic_conversion/ui/helper/user_helper.dart';

import '../../configs.dart';

class DeleteCardDialog extends StatefulWidget {
  final String content;
  final Person person;

  const DeleteCardDialog({
    Key key,
    this.content,
    this.person,
  }) : super(key: key);

  @override
  _DeleteCardDialogState createState() => _DeleteCardDialogState();
}

class _DeleteCardDialogState extends State<DeleteCardDialog> {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Material(
      type: MaterialType.transparency,
      child: Container(
        padding: EdgeInsets.symmetric(
            vertical: ScreenUtil().setHeight(20),
            horizontal: ScreenUtil().setWidth(20)),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Container(
          width: ScreenUtil().setWidth(270),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                child: Text(
                  '温馨提示',
                  style: TextStyle(
                      fontSize: 19,
                      color: ColorHelper.color_333,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.only(
                    top: ScreenUtil().setHeight(28),
                    bottom: ScreenUtil().setHeight(38)),
                child: Text(
                  widget.content,
                  style: TextStyle(
                    fontSize: 17,
                    color: ColorHelper.color_333,
                  ),
                ),
              ),
              Row(
                children: <Widget>[
                  Expanded(
                      child: GestureDetector(
                    onTap: () async {
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      height: ScreenUtil().setHeight(45),
                      alignment: Alignment(0, 0),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(30))),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            '取消',
                            style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF666666)),
                          ),
                        ],
                      ),
                    ),
                  )),
                  SizedBox(
                    width: ScreenUtil().setWidth(15),
                  ),
                  Expanded(
                      child: GestureDetector(
                    onTap: () async {
                      Person person = widget.person;
                      person.delete().then((value) {
                        Configs.persons.remove(person);
                        EventBusUtil.getInstance().fire(AnyEvent(AnyEvent.REFRESH_CARDS));
                        Navigator.of(context).pop();
                        showToast('删除成功');
                      }).catchError((e) {
                        showToast('删除失败');
                      });
                    },
                    child: Container(
                      height: ScreenUtil().setHeight(45),
                      alignment: Alignment(0, 0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                          color: Colors.white),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            '确认',
                            style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF00C27C)),
                          ),
                        ],
                      ),
                    ),
                  )),
                ],
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
