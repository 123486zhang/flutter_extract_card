import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graphic_conversion/locatization/localizations.dart';
import 'package:graphic_conversion/ui/helper/resoure_helper.dart';

class PermissionTipDialog extends StatefulWidget {
  final String permissionStr;

  const PermissionTipDialog({
    Key key,
    this.permissionStr,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return PermissionTipDialogState();
  }
}

class PermissionTipDialogState extends State<PermissionTipDialog> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget contentWidget = Padding(
      padding: EdgeInsets.fromLTRB(10, 18, 10, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '扫图识字需要获取以下权限:',
            style: TextStyle(color: Colors.black),
          ),
          widget.permissionStr.contains("存储")
              ? Container(
                  margin: EdgeInsets.only(top: 8),
                  child: Column(
                    children: [
                      Row(
                        children: <Widget>[
                          Image.asset(
                            ImageHelper.imageRes('icon_login_selected.png'),
                            width: 16,
                            height: 16,
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Container(
                            child: Text(
                              '存储权限',
                              style: TextStyle(
                                  color: ColorHelper.color_333, fontSize: 13),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        alignment: Alignment.topLeft,
                        margin: EdgeInsets.only(top: 5),
                        child: Text(
                          '该权限要获取软件内文件的读、写权限，以保证此软件内的功能可正常使用，若您不想使用该功能，您可以拒绝申请。需要使用此权限的功能有选取照片，拍照等功能。',
                          style: TextStyle(
                              color: ColorHelper.color_333,
                              fontSize: 12,
                              height: 1.2),
                          textAlign: TextAlign.start,
                        ),
                      ),
                    ],
                  ))
              : Container(),
          widget.permissionStr.contains("相机")
              ? Container(
                  margin: EdgeInsets.only(top: 8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: <Widget>[
                          Image.asset(
                            ImageHelper.imageRes('icon_login_selected.png'),
                            width: 16,
                            height: 16,
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Container(
                            child: Text(
                              '相机权限',
                              style: TextStyle(
                                  color: ColorHelper.color_333, fontSize: 13),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 5),
                        child: Text(
                          '为获取照片消息，我们需要打开摄像头、获取文件读、写权限，若您不想使用该功能，您可以拒绝申请。拒绝该权限，不影响除联系客服外其他功能的使用。',
                          style: TextStyle(
                            color: ColorHelper.color_333,
                            fontSize: 12,
                            height: 1.2,
                          ),
                          textAlign: TextAlign.start,
                        ),
                      ),
                    ],
                  ))
              : Container(),
          widget.permissionStr.contains("麦克风")
              ? Container(
              margin: EdgeInsets.only(top: 8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: <Widget>[
                      Image.asset(
                        ImageHelper.imageRes('ic_checkbox_selected.png'),
                        width: 16,
                        height: 16,
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Container(
                        child: Text(
                          JYLocalizations.localizedString("麦克风权限"),
                          style: TextStyle(
                              color: ColorHelper.color_333, fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 5),
                    child: Text(
                      JYLocalizations.localizedString('为录取视频声音，将获取手机麦克风权限，若您不想使用该功能，您可以拒绝申请。'),
                      style: TextStyle(
                        color: ColorHelper.color_333,
                        fontSize: 12,
                        height: 1.2,
                      ),
                      textAlign: TextAlign.start,
                    ),
                  ),
                ],
              ))
              : Container(),
          widget.permissionStr.contains("通讯录")
              ? Container(
                  margin: EdgeInsets.only(top: 8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: <Widget>[
                          Image.asset(
                            ImageHelper.imageRes('ic_checkbox_selected.png'),
                            width: 16,
                            height: 16,
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Container(
                            child: Text(
                              '通讯录权限',
                              style: TextStyle(
                                  color: ColorHelper.color_333, fontSize: 13),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        alignment: Alignment.topLeft,
                        margin: EdgeInsets.only(top: 5),
                        child: Text(
                          '为了帮您发现更多好友，我们需要向你申请通讯录读、写权限，如果您不想使用该功能，您可以拒绝申请。拒绝该权限，不影响其他功能的使用。',
                          style: TextStyle(
                              color: ColorHelper.color_333,
                              fontSize: 12,
                              height: 1.2),
                          textAlign: TextAlign.start,
                        ),
                      ),
                    ],
                  ))
              : Container(),
        ],
      ),
    );

    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: CupertinoAlertDialog(
        title: Text('权限申请'),
        content: contentWidget,
        actions: <Widget>[
          CupertinoButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: new Text(
              '拒绝',
              style: TextStyle(color: Colors.black),
            ),
          ),
          CupertinoButton(
            onPressed: () async {
              Navigator.of(context).pop(true);
            },
            child: new Text('同意', style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
  }
}
