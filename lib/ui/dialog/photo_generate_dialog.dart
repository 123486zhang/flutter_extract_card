import 'package:graphic_conversion/ui/helper/resoure_helper.dart';
import 'package:flutter/material.dart';

class PhotoGenerateDialog extends StatefulWidget {

  final VoidCallback callback;

  PhotoGenerateDialog({this.callback});

  @override
  _PhotoGenerateDialogState createState() => _PhotoGenerateDialogState();
}

class _PhotoGenerateDialogState extends State<PhotoGenerateDialog> {

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
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Container(
          width: 335,
          padding: EdgeInsets.symmetric(horizontal: 25),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(15)),
            color: Colors.white,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 30,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextHelper.TextCreateWith(
                    text: "正在处理图片，请稍候......",
                    fontSize: 15,
                    color: ColorHelper.color_999,
                  ),
                ],
              ),
              SizedBox(height: 20,),
              SizedBox(
                height: 5,
                child: _progressBar(lineProgress, context),
              ),
              SizedBox(height: 20,),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  Navigator.of(context).pop();
                  if (widget.callback != null) {
                    widget.callback();
                  }
                },
                child: Container(
                  alignment: Alignment.center,
                  height: 44,
                  child: TextHelper.TextCreateWith(
                    text: "取消",
                    fontSize: 15,
                  ),
                ),
              ),
              SizedBox(height: 10,),
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
        backgroundColor: Color(0xFFEFF2F8),
        value: progress == 1.0 ? 0 : progress,
        valueColor: AlwaysStoppedAnimation(Colors.blue));
  }

  void updateProgress() {
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
