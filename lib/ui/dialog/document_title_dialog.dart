import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graphic_conversion/ui/helper/resoure_helper.dart';
import 'package:graphic_conversion/utils/string_utils.dart';
import 'package:oktoast/oktoast.dart';

typedef TitleCallback = void Function(String title);

class DocumentTitleDialog extends StatefulWidget {
  final String title;
  final TitleCallback callback;

  DocumentTitleDialog({this.title, this.callback});

  @override
  _DocumentTitleDialogState createState() => _DocumentTitleDialogState();
}

class _DocumentTitleDialogState extends State<DocumentTitleDialog> {

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
              borderRadius: BorderRadius.all(Radius.circular(15)),
              color: Colors.white),
          margin: EdgeInsets.only(top: ScreenUtil().setHeight(45)),
          width: ScreenUtil().setWidth(300),
          child: Stack(
            alignment: Alignment.topRight,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Stack(children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child:Container(
                        alignment: Alignment.topRight,
                        margin: EdgeInsets.only(top: ScreenUtil().setHeight(10),right: ScreenUtil().setWidth(10)),
                        child: Image.asset(
                          ImageHelper.imageRes('icon_cancel.png'),
                          width: ScreenUtil().setWidth(35),
                          height: ScreenUtil().setHeight(35),
                        ) ,),
                    ),
                    Container(
                      alignment: Alignment.topCenter,
                      margin: EdgeInsets.only(top: ScreenUtil().setHeight(25)),
                      child:
                    TextHelper.TextCreateWith(
                      text: "修改标题",
                      fontSize: 19,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF333333),
                    ),),
                  ],),
                  SizedBox(
                    height: ScreenUtil().setHeight(20),),
                  Container(
                    height: ScreenUtil().setHeight(50),
                    margin: EdgeInsets.symmetric(
                        horizontal: ScreenUtil().setWidth(20)),
                    padding: EdgeInsets.symmetric(
                        horizontal: ScreenUtil().setWidth(20)),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(25)),
                      color: Color(0xFFF4F4F4),
                    ),
                    child: TextField(
                      textAlign: TextAlign.center,
                      onChanged: (value) {
                        if (value.length >= 8) {
                          showToast("最多输入8个字符");
                        }
                      },
                      maxLength: 8,
                      style: TextStyle(fontSize: 17, color: Color(0xFF333333)),
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
                      if (StringUtils.isNull(_titleController.text)) {
                        showToast("请输入您的文档名称");
                        return;
                      }
                      if (widget.callback != null) {
                        if(_titleController.text.length>8){
                          showToast("最多输入8个字符");
                        }else {
                          showToast('保存成功');
                          Navigator.of(context).pop();
                          widget.callback(_titleController.text);
                        }
                      }
                    },
                    child: Container(
                      margin: EdgeInsets.only(top: ScreenUtil().setHeight(30),
                          bottom: ScreenUtil().setHeight(25)),
                      height: ScreenUtil().setHeight(50),
                      width: ScreenUtil().setWidth(132),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Color(0xFF00C27C),
                          borderRadius:
                          BorderRadius.all(Radius.circular(10))),
                      child: TextHelper.TextCreateWith(
                        text: "保存",
                        fontSize: 16,
                        isBlod: true,
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              ),
              // GestureDetector(
              //   behavior: HitTestBehavior.opaque,
              //   onTap: () {
              //     Navigator.of(context).pop();
              //   },
              //   child: Container(
              //     width: 50,
              //     height: 50,
              //     alignment: Alignment.center,
              //     child: Image.asset(
              //       ImageHelper.imageRes("vip_close.png"),
              //       width: 16,
              //       height: 16,
              //     ),
              //   ),
              // )
            ],
          ),
        ),
      ),
    );
  }
}
