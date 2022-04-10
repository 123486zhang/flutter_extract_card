import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:graphic_conversion/configs.dart';
import 'package:graphic_conversion/locatization/localizations.dart';
import 'package:graphic_conversion/ui/helper/resoure_helper.dart';

class AgreementEnsureDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Widget contentWidget = Padding(
        padding: EdgeInsets.fromLTRB(10, 18, 10, 0),
        child: TextHelper.TextCreateWith(text:
          '若您不同意本隐私政策,很遗憾我们将无法为您提供服务！',
          fontSize: 15, height: 1.4,color: Colors.black
        ));

    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: CupertinoAlertDialog(
        title: TextHelper.TextCreateWith(text:JYLocalizations.localizedString('您需要同意本隐私政策才能继续使用 扫图识字'), color: Colors.black, fontSize: 17),
        content: contentWidget,
        actions: <Widget>[
          CupertinoButton(
            onPressed: () {
              SystemNavigator.pop();
            },
            child: TextHelper.TextCreateWith(text:
              '退出应用',
              color: Colors.black,
            ),
          ),
          CupertinoButton(
            onPressed: () async {
              Navigator.of(context).pop(true);
            },
            child: TextHelper.TextCreateWith(text:'查看协议', color: Colors.black),
          ),
        ],
      ),
    );
  }
}
