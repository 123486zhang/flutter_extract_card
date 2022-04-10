import 'package:data_plugin/bmob/response/bmob_handled.dart';
import 'package:data_plugin/bmob/table/bmob_user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graphic_conversion/data/local_storage/storage_manager.dart';
import 'package:oktoast/oktoast.dart';
import 'package:graphic_conversion/data/net/fizz_api.dart';
import 'package:graphic_conversion/ui/helper/resoure_helper.dart';
import 'package:graphic_conversion/ui/helper/user_helper.dart';

class UnsubscribeDialog extends StatefulWidget {
  final String wxString;
  final String phoneString;

  const UnsubscribeDialog({
    Key key,
    this.wxString,
    this.phoneString,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return UnsubscribeDialogState();
  }
}

class UnsubscribeDialogState extends State<UnsubscribeDialog> {
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
                  '是否注销该账号？',
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
                      EasyLoading.show();
                      BmobUser local = UserHelper().bmobUserVM.bmobUserModel;
                      local.delete().then((BmobHandled bmobHandled) {
                        EasyLoading.dismiss();
                        showToast("注销成功");
                        Navigator.of(context).pop();
                        UserHelper().clearUserInfo();
                      }).catchError((e) {
                        EasyLoading.dismiss();
                        showToast("注销失败");
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
                            '注销账号',
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
                            '我再看看',
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
