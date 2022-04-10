import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graphic_conversion/channel/android_method_channel.dart';
import 'package:graphic_conversion/ui/helper/resoure_helper.dart';

class PermissionDialog extends StatefulWidget {
  final String permissionStr;

  const PermissionDialog({
    Key key,
    this.permissionStr,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return PermissionDialogState();
  }
}

class PermissionDialogState extends State<PermissionDialog> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Material(
      type: MaterialType.transparency,
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xFFFFFFFF),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Container(
          width: 310,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 26,
              ),
              Center(
                  child: TextHelper.TextCreateWith(
                text: "温馨提示",
                fontSize: 20,
                isBlod: true,
                color: Color(0xFF000000),
              )),
              Container(
                  alignment: Alignment.center,
                  padding:
                      EdgeInsets.only(top: 20, bottom: 20, left: 30, right: 30),
                  child: TextHelper.TextCreateWith(
                    text: "检测到您未开启相关权限，请手动开启",
                    fontSize: 16,
                    color: Color(0xFF000000),
                  )),
              Divider(height: 0.5, thickness: 0.5, color: Color(0xFFE0E0E0)),
              Row(
                children: <Widget>[
                  Expanded(
                      child: GestureDetector(
                    onTap: () async {
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color(0xFFFFFFFF),
                        borderRadius:
                            BorderRadius.only(bottomLeft: Radius.circular(10)),
                      ),
                      height: 57,
                      alignment: Alignment(0, 0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          TextHelper.TextCreateWith(
                              text: "取消",
                              fontSize: 15,
                              color: Color(0xFF565656))
                        ],
                      ),
                    ),
                  )),
                  Container(
                    color: Color(0xFFE0E0E0),
                    width: 0.5,
                    height: 57,
                  ),
                  Expanded(
                      child: GestureDetector(
                    onTap: () async {
                      AndroidMethodChannel.goPermissionSetting();
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color(0xFFFFFFFF),
                        borderRadius:
                            BorderRadius.only(bottomRight: Radius.circular(10)),
                      ),
                      height: 57,
                      alignment: Alignment(0, 0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          TextHelper.TextCreateWith(
                              text: "去设置",
                              fontSize: 15,
                              color: ColorHelper.color_main)
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
