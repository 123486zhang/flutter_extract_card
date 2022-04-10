import 'package:graphic_conversion/ui/helper/resoure_helper.dart';
import 'package:flutter/material.dart';

class NavigatorTitle extends StatelessWidget {

  final String title;

  NavigatorTitle({@required this.title});

  @override
  Widget build(BuildContext context) {
    return TextHelper.TextCreateWith(
        text: title,
        fontSize: 17,
        color: ColorHelper.color_navigator,
        isBlod: true
    );
  }
}
