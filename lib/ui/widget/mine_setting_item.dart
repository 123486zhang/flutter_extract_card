import 'package:flutter/material.dart';
import 'package:graphic_conversion/ui/helper/resoure_helper.dart';

class MineSettingItem extends StatelessWidget {
  MineSettingItem(
      {Key key,
        this.onTap,
        this.icon,
        this.title,
        this.hideDivider = true
      })
      : assert(onTap != null),
        assert(icon != null),
        assert(title != null),
        super(key: key);

  final GestureTapCallback onTap;

  final String icon;

  final String title;

  final bool hideDivider;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(15.0, 20.0, 15.0, 20.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  icon,
                  width: 30,
                  height: 30,
                ),
                SizedBox(width: 5,),
                Expanded(
                  child: TextHelper.TextCreateWith(text:
                    title,
                      color: Color(0xFF333333),
                      fontSize: 17,
                  ),
                ),
                Image.asset(
                  ImageHelper.imageRes("mine_forward.png"),
                  width: 16,
                  height: 16,
                ),
              ],
            ),
          ),
        ),
        Offstage(
          offstage: hideDivider,
          child: Divider(height: 1, thickness: 0.5, color: Color(0xFF394256))
        ),
      ],
    );
  }
}