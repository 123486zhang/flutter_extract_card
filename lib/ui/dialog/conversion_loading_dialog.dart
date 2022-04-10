import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graphic_conversion/ui/helper/resoure_helper.dart';

class ConversionLoadingDialog extends StatefulWidget {

  @override
  _ConversionLoadingDialogState createState() => _ConversionLoadingDialogState();
}

class _ConversionLoadingDialogState extends State<ConversionLoadingDialog> {

  double lineProgress = 0.0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    updateProgress();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    lineProgress = 1.0;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Center(
        child: Container(
          width: ScreenUtil().setWidth(335),
          height:  ScreenUtil().setHeight(108),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(12)),
            color: Color(0xFFFFFFFF),
          ),
          child: Stack(
            children: [
              Column(
                children: [
                  Stack(children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child:Container(
                        alignment: Alignment.topRight,
                        margin: EdgeInsets.only(top: ScreenUtil().setHeight(5),right: ScreenUtil().setWidth(5)),
                        child: Image.asset(
                          ImageHelper.imageRes('icon_cancel.png'),
                          width: ScreenUtil().setWidth(25),
                          height: ScreenUtil().setHeight(25),
                        ),),
                    ),
                    Container(
                      alignment: Alignment.topCenter,
                      margin: EdgeInsets.only(top: ScreenUtil().setHeight(30)),
                      child:
                        TextHelper.TextCreateWith(
                          text: "正在识别中，请稍等...",
                          fontSize: 15,
                          color: Color(0xFF333333),
                        ),
                    ),
                  ],),
                  SizedBox(height: ScreenUtil().setHeight(15),),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal:  ScreenUtil().setWidth(20)),
                    child: Row(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(3)),
                            child: Container(
                              height: ScreenUtil().setHeight(5),
                              child: _progressBar(lineProgress, context),
                            ),
                          ),
                        ),
                        Container(
                          width:  ScreenUtil().setWidth(35),
                          alignment: Alignment.centerRight,
                          child: TextHelper.TextCreateWith(
                            text: "${(lineProgress * 100).floor()}%",
                            fontSize: 11,
                            color: Color(0xFF333333),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _didFinish(String url) {
    setState(() {
      lineProgress = 0.99;
    });
    Future.delayed(Duration(milliseconds: 300), () {
      setState(() {
        lineProgress = 1;
      });
    });
  }

  _progressBar(double progress, BuildContext context) {
    return LinearProgressIndicator(
        backgroundColor: Color(0x1A00C27C),
        value: progress,
        valueColor: AlwaysStoppedAnimation(Color(0xFF00C27C)));
  }

  void updateProgress() {
    if (!mounted) return;
    if (lineProgress < 0.5) {
      setState(() {
        lineProgress += 0.01;
      });
    } else if (lineProgress >= 0.5 && lineProgress <= 0.8) {
      setState(() {
        lineProgress += 0.002;
      });
    } else if (lineProgress > 0.8 && lineProgress <= 0.99) {
      setState(() {
        lineProgress += 0.001;
      });
    } else if (lineProgress > 0.99) {
      return;
    }

    Future.delayed(Duration(milliseconds: 30), () {
      updateProgress();
    });
  }
}