import 'package:graphic_conversion/data/net/fizz_api.dart';
import 'package:graphic_conversion/model/order_model.dart';
import 'package:graphic_conversion/ui/helper/buried_point_helper.dart';
import 'package:graphic_conversion/ui/helper/resoure_helper.dart';
import 'package:graphic_conversion/utils/string_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:oktoast/oktoast.dart';

class SendEmailDialog extends StatefulWidget {

  final OrderModel model;
  final VoidCallback callback;

  SendEmailDialog({this.model, this.callback});

  @override
  _SendEmailDialogState createState() => _SendEmailDialogState();
}

class _SendEmailDialogState extends State<SendEmailDialog> {

  final TextEditingController _emailAddressController = TextEditingController();
  final TextEditingController _fileNameController = TextEditingController();
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _fileNameController.text = "证件照(${widget.model.orderName})";
    _subjectController.text = "证件照";
    _bodyController.text = "扫图识字为您准备的最美证照，请查收~";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 10,),
                  Stack(
                    alignment: Alignment.centerLeft,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextHelper.TextCreateWith(
                            text: "发送到邮箱",
                            fontSize: 17,
                            isBlod: true,
                          ),
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
                          alignment: Alignment.centerLeft,
                          child: Image.asset(
                            ImageHelper.imageRes('navigator_back.png'),
                            width: 22,
                            height: 22,
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 15,),
                  Row(
                    children: [
                      Image.asset(
                        ImageHelper.imageRes("save_send_email.png"),
                        width: 16,
                        height: 16,
                      ),
                      SizedBox(width: 5,),
                      TextHelper.TextCreateWith(
                        text: "为了保证照片能正常发送，请输入有效的邮箱地址",
                        fontSize: 13,
                        color: Color(0xFFEF0000),
                      ),
                    ],
                  ),
                  SizedBox(height: 20,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          TextHelper.TextCreateWith(
                            text: "电子邮件",
                            fontSize: 15,
                            isBlod: true,
                          ),
                          TextHelper.TextCreateWith(
                            text: "*",
                            fontSize: 15,
                            color: Color(0xFFFF2929),
                            isBlod: true,
                          ),
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: Color(0xFFFAFAFA),
                          border: Border.all(color: Color(0xFFEEEEEE), width: 1),
                        ),
                        width: 257,
                        height: 40,
                        child: TextField(
                          style: TextStyle(
                              fontSize: 15,
                              color: ColorHelper.color_333),
                          controller: _emailAddressController,
                          decoration: InputDecoration(
                            hintText: '请输入您的邮箱',
                            hintStyle: TextStyle(
                              fontSize: 15,
                              color: ColorHelper.color_999,
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 15,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextHelper.TextCreateWith(
                        text: "文件名",
                        fontSize: 15,
                        isBlod: true,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: Color(0xFFFAFAFA),
                          border: Border.all(color: Color(0xFFEEEEEE), width: 1),
                        ),
                        width: 257,
                        height: 40,
                        child: TextField(
                          style: TextStyle(
                              fontSize: 15,
                              color: ColorHelper.color_333),
                          controller: _fileNameController,
                          decoration: InputDecoration(
                            hintText: '请输入您的文件名',
                            hintStyle: TextStyle(
                              fontSize: 15,
                              color: ColorHelper.color_999,
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 15,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextHelper.TextCreateWith(
                        text: "主题",
                        fontSize: 15,
                        isBlod: true,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: Color(0xFFFAFAFA),
                          border: Border.all(color: Color(0xFFEEEEEE), width: 1),
                        ),
                        width: 257,
                        height: 40,
                        child: TextField(
                          style: TextStyle(
                              fontSize: 15,
                              color: ColorHelper.color_333),
                          controller: _subjectController,
                          decoration: InputDecoration(
                            hintText: '请输入您的主题',
                            hintStyle: TextStyle(
                              fontSize: 15,
                              color: ColorHelper.color_999,
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 15,),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: Color(0xFFFAFAFA),
                      border: Border.all(color: Color(0xFFEEEEEE), width: 1),
                    ),
                    height: 90,
                    child: TextField(
                      style: TextStyle(
                          fontSize: 15,
                          color: ColorHelper.color_333),
                      controller: _bodyController,
                      decoration: InputDecoration(
                        hintText: '请输入您的内容',
                        hintStyle: TextStyle(
                          fontSize: 15,
                          color: ColorHelper.color_999,
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  SizedBox(height: 20,),
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      BuriedPointHelper.clickBuriedPoint(
                        pageName: "订单详情页",
                        clickName: "邮箱发送成功",
                      );
                      if (StringUtils.isNull(_emailAddressController.text)){
                        showToast("请输入您的邮箱");
                        return;
                      }
                      EasyLoading.show();
                      FIZZApi.requestSendEmail(
                        receive: _emailAddressController.text,
                        filename: _fileNameController.text,
                        subject: _subjectController.text,
                        msg: _bodyController.text,
                        orderNo: widget.model.orderNo,
                      ).then((value) {
                        EasyLoading.dismiss();
                        Navigator.of(context).pop();
                        if (widget.callback != null) {
                          widget.callback();
                        }
                      });
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: 45,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        color: Color(0xFF2953FF),
                      ),
                      child: TextHelper.TextCreateWith(
                        text: "发送至邮箱",
                        fontSize: 17,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: 15,),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
