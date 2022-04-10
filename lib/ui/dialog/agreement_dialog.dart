
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:graphic_conversion/configs.dart';
import 'package:graphic_conversion/locatization/localizations.dart';
import 'package:graphic_conversion/router/router_config.dart';
import 'package:graphic_conversion/ui/helper/resoure_helper.dart';
import 'package:graphic_conversion/utils/common_utils.dart';
import 'package:oktoast/oktoast.dart';

const String kAgreement = 'agreement';
const String isShowAgreement = 'isShowAgreement';

class AgreementDialog extends StatefulWidget {
  final String yhxy;
  final String yszc;

  const AgreementDialog({
    Key key,
    this.yhxy,
    this.yszc,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return AgreementDialogState();
  }
}

class AgreementDialogState extends State<AgreementDialog> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget contentWidget = Padding(
      padding: EdgeInsets.fromLTRB(10, 18, 10, 0),
      child: Text.rich(
        TextSpan(
            text:'${JYLocalizations.localizedString("欢迎使用")}${JYLocalizations.localizedString('扫图识字')}！${JYLocalizations.localizedString("隐私保护指引内容")}',
            style: TextStyle(fontSize: 15, height: 1.4),
            children: <TextSpan>[
              TextSpan(
                text: JYLocalizations.localizedString('《用户协议》'),
                style: TextStyle(
                  color: Color(0xFF00C27C),
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () async {
                    if (!await CommonUtils.isNetConnected()) {
                    showToast('请确认网络连接!');
                    return;
                    }
                    Navigator.of(context).pushNamed(RouteName.webview,
                        arguments: {'title': '用户协议', 'url': widget.yhxy});
                  },
              ),
              TextSpan(
                text: JYLocalizations.localizedString('和'),
              ),
              TextSpan(
                text: JYLocalizations.localizedString('《隐私政策》'),
                style: TextStyle(color: Color(0xFF00C27C)),
                recognizer: TapGestureRecognizer()
                  ..onTap = () async {
                    if (!await CommonUtils.isNetConnected()) {
                    showToast('请确认网络连接!');
                    return;
                    }
                    Navigator.of(context).pushNamed(RouteName.webview,
                        arguments: {'title': '隐私政策', 'url': widget.yszc});
                  },
              ),
            ]),
        textAlign: TextAlign.start,
      ),
    );

    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: CupertinoAlertDialog(
        title: TextHelper.TextCreateWith(text:'个人隐私保护指引', color: Colors.black, fontSize: 17),
        content: contentWidget,
        actions: <Widget>[
          CupertinoButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: TextHelper.TextCreateWith(text:
              '不同意',
              color: Colors.black,
            ),
          ),
          CupertinoButton(
            onPressed: () async {
              Navigator.of(context).pop(true);
            },
            child: TextHelper.TextCreateWith(text:'同意',color: Colors.black),
          ),
        ],
      ),
    );
  }
}
