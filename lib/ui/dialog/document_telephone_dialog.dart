import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:graphic_conversion/ui/helper/buried_point_helper.dart';
import 'package:graphic_conversion/ui/helper/resoure_helper.dart';
import 'package:graphic_conversion/utils/string_utils.dart';
import 'package:oktoast/oktoast.dart';

typedef TelephoneCallback = void Function(String title);

class DocumentTelephoneDialog extends StatefulWidget {
  final String title;
  final TelephoneCallback callback;

  DocumentTelephoneDialog({this.title, this.callback});

  @override
  _DocumentTelephoneDialogState createState() => _DocumentTelephoneDialogState();
}

class _DocumentTelephoneDialogState extends State<DocumentTelephoneDialog> {

  TextEditingController _titleController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _titleController.text = widget.title;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(18)),
              color: Colors.white),
          margin: EdgeInsets.only(top: 45),
          width: 300,
          child: Stack(
            alignment: Alignment.topRight,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 37,),
                  TextHelper.TextCreateWith(
                    text: "修改号码",
                    fontSize: 20,
                    isBlod: true,
                    color: Colors.black,
                  ),
                  SizedBox(height: 23,),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 18),
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(25)),
                      color: Color(0xFFF4F4F4),
                    ),
                    child: TextField(
                      textAlign: TextAlign.center,
                      onChanged: (value) {
                        if (value.length > 11) {
                          showToast("最多输入11个字符");
                        }
                      },
                      maxLength: 11,
                      style: TextStyle(fontSize: 16, color: Color(0xFF333333),fontWeight: FontWeight.w600),
                      controller: _titleController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        counterText: "",
                      ),
                      // inputFormatters: [
                      //   LengthLimitingTextInputFormatter(6)
                      // ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (StringUtils.isNull(_titleController.text)){
                        showToast("请输入电话号码");
                        return;
                      }
                      if(widget.callback != null) {
                        widget.callback(_titleController.text);
                      }
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      margin: EdgeInsets.only(top: 32, left: 90, right: 90, bottom: 25),
                      height: 50,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Color(0xFF00C27C),
                          borderRadius:
                          BorderRadius.all(Radius.circular(10))),
                      child: TextHelper.TextCreateWith(
                        text: "保存",
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              ),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Container(
                  width: 50,
                  height: 50,
                  alignment: Alignment.center,
                  child: Image.asset(
                    ImageHelper.imageRes("edit_close.png"),
                    width: 16,
                    height: 16,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
