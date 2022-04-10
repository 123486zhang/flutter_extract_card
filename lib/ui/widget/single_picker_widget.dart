import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graphic_conversion/ui/helper/resoure_helper.dart';

class SinglePickerWidget extends StatefulWidget {
  final List<String> values;
  final value;
  final double itemHeight;
  final double height;
  final double width;
  final String unit;
  final Function onChanged;
  final Color backgroundColor;
  final Color color;
  final bool looping;

  const SinglePickerWidget(
      {Key key,
        @required this.values,
        @required this.value,
        @required this.onChanged,
        this.unit,
        this.itemHeight = 86,
        this.backgroundColor = const Color(0xffffffff),
        this.color = const Color(0xff000000),
        this.height = 150.0,
        this.width = 150.0,
        this.looping = true,
      })
      : super(key: key);
  @override
  _SinglePickerWidgetState createState() => _SinglePickerWidgetState();
}

class _SinglePickerWidgetState extends State<SinglePickerWidget> {
  int _selectedColorIndex = 0;
  FixedExtentScrollController scrollController;
  var values;
  var value;

  //设置防抖周期为300毫秒
  Duration durationTime = Duration(milliseconds: 300);
  Timer timer;

  @override
  void initState() {
    super.initState();
    values = widget.values;
    value = widget.value;
    getDefaultValue();
    scrollController =
        FixedExtentScrollController(initialItem: _selectedColorIndex);
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
    timer?.cancel();
  }

  // 获取默认选择值
  getDefaultValue() {
    // 查找要选择的默认值
    for (var i = 0; i < values.length; i++) {
      if (values[i] == value) {
        setState(() {
          _selectedColorIndex = i;
        });
        break;
      }
    }
  }

  // 触发值改变
  void _changed(index) {
    timer?.cancel();
    timer = new Timer(durationTime, () {
      // 触发回调函数
      widget.onChanged(values[index]);
    });
  }

  Widget _buildColorPicker(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      color: widget.backgroundColor,
      child: Stack(
        alignment: Alignment.center,
        children: [
          widget.unit != null
              ? Positioned(
            top: widget.height / 2 - (widget.itemHeight / 2),
            right: 30.0,
            child: Container(
              alignment: Alignment.center,
              height: widget.itemHeight,
              child: Text(
                widget.unit,
                style: TextStyle(
                  color: widget.color,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          )
              : Offstage(
            offstage: true,
          ),
          CupertinoPicker(
            scrollController: scrollController, // 用于读取和控制当前项的FixedxtentScrollController
            itemExtent: widget.itemHeight, // 所有子节点 统一高度
            looping: widget.looping,
            onSelectedItemChanged: (int index) {
              // 当正中间选项改变时的回调
              if (mounted) {
                debugPrint('index--------------$index\nvalue = ${values[index]}');
                // _changed(index);
                widget.onChanged(values[index]);
              }
            },
            children: List<Widget>.generate(values.length, (int index) {
              return Container(
                alignment: Alignment.center,
                height: widget.itemHeight,
                child: Text(
                  values[index],
                  style: TextStyle(
                    color: widget.color,
                    fontSize: 42.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildColorPicker(context);
  }
}