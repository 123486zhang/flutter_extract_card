import 'package:flutter/material.dart';
import 'package:graphic_conversion/ui/helper/resoure_helper.dart';


class NabigationBackButton {
  static Widget back(BuildContext context, {VoidCallback callback}){
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        if (callback != null) {
          callback();
        } else {
          Navigator.of(context).pop();
        }
      },
      child: Container(
        width: 50,
        height: 50,
        padding: EdgeInsets.only(left: 10),
        alignment: Alignment.centerLeft,
        child: Image.asset(
          ImageHelper.imageRes('navigator_back.png'),
          width: 22,
          height: 22,
        ),
      ),
    );
  }
}