import 'package:flutter/material.dart';

class AutomaticRotation extends StatefulWidget {

  final int seconds;

  final Widget child;

  final bool rotation;

  AutomaticRotation({this.child, this.seconds = 2, this.rotation = true});

  @override
  _AutomaticRotationState createState() => _AutomaticRotationState();
}

class _AutomaticRotationState extends State<AutomaticRotation> with SingleTickerProviderStateMixin {

  AnimationController controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    controller = AnimationController(duration: Duration(seconds: widget.seconds), vsync: this);
    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        //重置起点
        controller.reset();
        //开启
        controller.forward();
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.rotation) {
      controller.forward();
    } else {
      controller.stop();
    }
    return RotationTransition(
      turns: controller,
      child: ClipOval(
        child: widget.child,
      ),
    );
  }
}
