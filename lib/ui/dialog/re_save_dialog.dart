
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graphic_conversion/locatization/localizations.dart';
import 'package:graphic_conversion/ui/helper/resoure_helper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ReSaveDialog extends StatefulWidget {
  const ReSaveDialog({
    Key key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ReSaveDialogState();
  }
}

class ReSaveDialogState extends State<ReSaveDialog> {
  @override
  Widget build(BuildContext context) {
    return new Material(
      //创建透明层
      type: MaterialType.transparency, //透明类型
      child: new Center(
        //保证控件居中效果
        child: new SizedBox(
          width: ScreenUtil().setWidth(246),
          height: ScreenUtil().setHeight(150),
          child: Container(
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: Color(0xFFFFFFFF),
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                ),
                Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: ScreenUtil().setHeight(30), left: ScreenUtil().setWidth(34), right: ScreenUtil().setWidth(24)),
                      alignment: Alignment.center,
                      child: Text(
                        JYLocalizations.localizedString('您转文字的内容还未保存，确定要退出吗？'),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15,
                          color: Color(0xFF000000),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: ScreenUtil().setHeight(25)),
                      child: Divider(
                          height: 0.8,
                          thickness: 0.8,
                          color: Color(0xFFEEEEEE)),
                    ),
                    Expanded(
                        child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () async {
                              Navigator.of(context).pop(false);
                            },
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  boxShadow: <BoxShadow>[
                                    BoxShadow(
                                      color: Colors.grey[300],
                                    ),
                                  ],
                                  color: Color(0xFFFFFFFF),
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(10))),
                              child: TextHelper.TextCreateWith(
                                  text: "取消",
                                  fontSize: 15,
                                  color: Color(0xFF000000)),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () async {
                              Navigator.of(context).pop(true);
                            },
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  boxShadow: <BoxShadow>[
                                    BoxShadow(
                                      color: Colors.grey[300],
                                    ),
                                  ],
                                  color: Color(0xFFFFFFFF),
                                  borderRadius: BorderRadius.only(
                                      bottomRight: Radius.circular(10))),
                              child: TextHelper.TextCreateWith(
                                color: Color(0xFF000000),
                                text: "确定",
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
