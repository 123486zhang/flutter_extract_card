import 'dart:io';

import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:graphic_conversion/model/document_model.dart';
import 'package:graphic_conversion/router/router_config.dart';
import 'package:graphic_conversion/ui/helper/buried_point_helper.dart';
import 'package:graphic_conversion/ui/helper/dialog_helper.dart';
import 'package:graphic_conversion/ui/helper/resoure_helper.dart';
import 'package:graphic_conversion/ui/helper/user_helper.dart';
import 'package:graphic_conversion/ui/manager/cache_audio_manager.dart';
import 'package:graphic_conversion/utils/common_utils.dart';
import 'package:graphic_conversion/utils/string_utils.dart';
import 'package:oktoast/oktoast.dart';
import 'package:url_launcher/url_launcher.dart';

class TelephonePage extends StatefulWidget {
  final DocumentModel model;

  final int index;

  TelephonePage({this.model, this.index = -1});

  @override
  _TelephonePageState createState() => _TelephonePageState();
}

class _TelephonePageState extends State<TelephonePage> {
  List<TextEditingController> _contentControllers = [];
  List<TextEditingController> _translateControllers = [];

  TextEditingController _contentController = TextEditingController();
  FocusNode _contentFocus = FocusNode();

  String _title = "";

  List<String> _tags = ["号码识别", "原内容"];

  int _selectedTagIndex = 0;

  List<TextEditingController> _mobileControllers = [];

  var _canTap = true;

  List<FocusNode> _focus = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _mobileControllers = List<TextEditingController>.generate(
        widget.model.mobiles.length, (index) => TextEditingController());

    int length = widget.model.mobiles.length;

    _contentControllers = List<TextEditingController>.generate(length, (index) {
      _focus.add(FocusNode());
      TextEditingController controller = TextEditingController();
      controller.text = widget.model.mobiles[index];
      return controller;
    });

    _translateControllers =
        List<TextEditingController>.generate(length, (index) {
      TextEditingController controller = TextEditingController();
      controller.text = "";
      if (widget.model.translateContents != null &&
          widget.model.translateContents.length > index) {
        controller.text = widget.model.translateContents[index];
      }
      return controller;
    });

    _title = widget.model.title;
  }

  List<String> _getMobiles(String string) {
    var result = "";
    string = string.replaceAll(" ", "");
    RegExp exp = RegExp(
        r'((13[0-9])|(14[0-9])|(15[0-9])|(16[0-9])|(17[0-9])|(18[0-9])|(19[0-9]))\d{8}|(0\d{2,3}-?\d{7,8})');
    Iterable<Match> matches = exp.allMatches(string);
    List<String> mobiles = [];
    for (Match m in matches) {
      String match = m.group(0);
      debugPrint("match = $match");
      mobiles.add(match);
    }
    return mobiles;
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle.dark,
      child: WillPopScope(
        onWillPop: () async {
          return _goBack();
        },
        child: Scaffold(
          backgroundColor: Color(0xFFF6F6F9),
          body: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: SafeArea(
              child: Column(
                children: [
                  buildNavigator(),
                  // buildTags(),
                  Expanded(child: buildContent()),
                  SizedBox(
                    height: 22,
                  ),
                  buildCopyAndExportButtons(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildNavigator() {
    return Container(
      color: Colors.white,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: 50,
            margin: EdgeInsets.symmetric(horizontal: 100),
            alignment: Alignment.center,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                BuriedPointHelper.clickBuriedPoint(
                  pageName: "编辑文本页面",
                  clickName: "改标题",
                );
                DialogHelper.showDocumentTitleDialog(context, title: _title,
                    callback: (title) {
                  setState(() {
                    _title = title;
                  });
                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextHelper.TextCreateWith(
                    text: _title,
                    fontSize: 18,
                    color: Colors.black,
                    isBlod: true,
                    isClip: true,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Image.asset(
                    ImageHelper.imageRes("document_edit.png"),
                    width: 18,
                    height: 18,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 0,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: _goBack,
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
            ),
          ),
          Positioned(
            right: 0,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: _save,
              child: Container(
                height: 50,
                width: 100,
                padding: EdgeInsets.only(right: 20),
                alignment: Alignment.centerRight,
                child: TextHelper.TextCreateWith(
                  text: "保存",
                  fontSize: 15,
                  color: Color(0xFF00C27C),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTags() {
    return Container(
      child: Row(
        children: List<Widget>.generate(
            _tags.length, (index) => buildTagItem(index: index)),
      ),
    );
  }

  Widget buildTagItem({int index}) {
    String text = _tags[index];
    double fontSize = 17;
    Color color = Color(0xFF999999);
    bool isShowLine = false;
    bool isBlod = false;
    if (_selectedTagIndex == index) {
      fontSize = 19;
      color = Color(0xFF333333);
      isShowLine = true;
      isBlod = true;
    }
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          if (_selectedTagIndex == 0 && index == 1) {
            BuriedPointHelper.clickBuriedPoint(
              pageName: "号码识别页面",
              clickName: "原内容",
            );
          }
          setState(() {
            _selectedTagIndex = index;
          });
        },
        child: Container(
          child: Column(
            children: [
              TextHelper.TextCreateWith(
                  text: text, fontSize: fontSize, color: color, isBlod: isBlod),
              SizedBox(
                height: 10,
              ),
              Offstage(
                offstage: !isShowLine,
                child: Container(
                  width: 48,
                  height: 3,
                  color: Color(0xFF0074FE),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTips() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            ImageHelper.imageRes("document_tips.png"),
            width: 20,
            height: 20,
          ),
          SizedBox(
            width: 5,
          ),
          TextHelper.TextCreateWith(
            text: "点击文字可编辑",
            color: Color(0xFF0074FE),
            fontSize: 15,
          )
        ],
      ),
    );
  }

  Widget buildContent() {
    if (_selectedTagIndex == 0) {
      return buildMobileContent();
    }
    return buildOriginContent();
  }

  Widget buildMobileContent() {
    if (widget.model.mobiles.length == 0) {
      return Center(
        child: TextHelper.TextCreateWith(
          text: "暂未识别到手机号码~",
          fontSize: 16,
          color: Color(0xFFC7D4E5),
        ),
      );
    }
    return Container(
      child: Container(
        margin: EdgeInsets.only(top: 12),
        child: ListView.builder(
          padding: EdgeInsets.symmetric(horizontal: 15),
          itemCount: widget.model.mobiles.length,
          itemBuilder: (ctx, index) {
            var mobile = widget.model.mobiles[index];
            var controller = _mobileControllers[index];
            if (StringUtils.isNull(controller.text)) controller.text = mobile;
            return buildMobileItem(controller, index);
          },
        ),
      ),
    );
  }

  Widget buildMobileItem(TextEditingController controller, index) {
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.only(top: 10),
          height: 80,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(10))),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      padding: EdgeInsets.only(left: 13),
                      child: TextField(
                        onTap: () {
                          FocusScope.of(context).requestFocus(new FocusNode());
                        },
                        enableInteractiveSelection: false,
                        style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF333333),
                            fontWeight: FontWeight.w600),
                        controller: controller,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(11)
                        ],
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          isCollapsed: true,
                        ),
                      ),
                    ),
                    // TextHelper.TextCreateWith(
                    //   text: "点击号码可编辑",
                    //   color: Color(0xFF999999),
                    //   fontSize: 15,
                    // ),
                  ],
                ),
              ),
              GestureDetector(
                  onTap: () {
                    BuriedPointHelper.clickBuriedPoint(
                      pageName: "号码识别页面",
                      clickName: "复制号码",
                    );
                    DialogHelper.showDocumentTelephoneDialog(context,
                        telephone: controller.text, callback: (text) {
                      setState(() {
                        controller.text = text;
                      });
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.only(left: 8),
                    child: Image.asset(
                      ImageHelper.imageRes("document_edit.png"),
                      width: 25,
                      height: 25,
                    ),
                  )),
              GestureDetector(
                  onTap: () {
                    BuriedPointHelper.clickBuriedPoint(
                      pageName: "号码识别页面",
                      clickName: "复制号码",
                    );
                    Clipboard.setData(ClipboardData(text: controller.text));
                    CommonUtils.showToastInfo('复制成功');
                    FocusScope.of(context).requestFocus();
                  },
                  child: Container(
                    margin: EdgeInsets.only(left: 73),
                    child: Image.asset(
                      ImageHelper.imageRes("document_copy_blue.png"),
                      width: 25,
                      height: 25,
                    ),
                  )),
              SizedBox(
                width: 12,
              ),
              GestureDetector(
                onTap: () {
                  BuriedPointHelper.clickBuriedPoint(
                    pageName: "号码识别页面",
                    clickName: "拨打电话",
                  );
                  _callPhoneNumberAction(controller.text, 1);
                  FocusScope.of(context).requestFocus();
                },
                child: Image.asset(
                  ImageHelper.imageRes("document_message.png"),
                  width: 25,
                  height: 25,
                ),
              ),
              SizedBox(
                width: 12,
              ),
              GestureDetector(
                onTap: () {
                  BuriedPointHelper.clickBuriedPoint(
                    pageName: "号码识别页面",
                    clickName: "拨打电话",
                  );
                  _callPhoneNumberAction(controller.text, 0);
                  FocusScope.of(context).requestFocus();
                },
                child: Image.asset(
                  ImageHelper.imageRes("document_phone.png"),
                  width: 25,
                  height: 25,
                ),
              ),
              SizedBox(
                width: 13,
              ),
            ],
          ),
        ),
        if (index == 0)
          Positioned(
            right: 0,
            top: 10,
            child: Container(
              height: 20,
              width: 39,
              decoration: BoxDecoration(
                  color: Color(0xFF00C27C),
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(10),
                      bottomLeft: Radius.circular(10))),
            ),
          ),
        if (index == 0)
          Positioned(
            top: 12,
            right: 9,
            child: TextHelper.TextCreateWith(
              text: "最新",
              fontSize: 10,
              color: Color(0xFFFFFFFF),
            ),
          )
      ],
    );
  }

  Widget buildOriginContent() {
    if (StringUtils.isNull(widget.model.content)) {
      return Center(
        child: TextHelper.TextCreateWith(
          text: "暂未识别到内容~",
          fontSize: 16,
          color: Color(0xFFC7D4E5),
        ),
      );
    }
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Expanded(
            child: TextField(
              focusNode: _contentFocus,
              style: TextStyle(fontSize: 17, color: Color(0xFF333333)),
              controller: _contentController,
              maxLines: null,
              decoration: InputDecoration(
                border: InputBorder.none,
              ),
            ),
          ),
          buildTips(),
        ],
      ),
    );
  }

  Widget buildCopyAndExportButtons() {
    return Container(
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          GestureDetector(
            onTap: _export,
            child: Stack(
              children: [
                Container(
                  width: 50,
                  height: 50,
                ),
                Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 35),
                      child: Image.asset(
                        ImageHelper.imageRes("document_share.png"),
                        width: 25,
                        height: 25,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 5, left: 35),
                      child: TextHelper.TextCreateWith(
                        text: "分享",
                        color: Color(0xFF333333),
                        fontSize: 13,
                        isBlod: true,
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: _copy,
            child: Container(
              width: 180,
              margin: EdgeInsets.only(bottom: 27, top: 22, left: 50),
              height: 45,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: Color(0xFF00C27C),
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: TextHelper.TextCreateWith(
                text: "一键复制",
                color: Colors.white,
                fontSize: 16,
                isBlod: true,
              ),
            ),
          ),
        ],
      ),
    );
  }

  _copy() {
    BuriedPointHelper.clickBuriedPoint(
      pageName: _selectedTagIndex == 0 ? "号码识别页面" : "编辑文本页面",
      clickName: "全部复制",
    );
    String text = "";
    if (_selectedTagIndex == 0) {
      _mobileControllers.forEach((controller) {
        text = text + controller.text + "\n";
      });
    } else {
      text = _contentController.text;
    }

    Clipboard.setData(ClipboardData(text: text));
    CommonUtils.showToastInfo('复制成功');
    FocusScope.of(context).requestFocus();
  }

  _export() async {
    BuriedPointHelper.clickBuriedPoint(
      pageName: "编辑文本页面",
      clickName: "导出",
    );
    String text = "";

    if (!UserHelper().userVM.isVip) {
      text = _mobileControllers[0].text;
    } else {
      _mobileControllers.forEach((controller) {
        text = text + controller.text + "\n";
      });
    }

    String filePath = "${DateTime.now().millisecondsSinceEpoch}";
    File file = await CacheAudioManager.writeDocument(
      text: text,
      filePath: filePath,
    );

    print("text==>${text}");

    DialogHelper.showDocumentShareDialog1(context,
        file: file,
        contentControllers: _contentControllers,
        translateControllers: _translateControllers, callback: (index) {
      if (index == 0) {
        BuriedPointHelper.clickBuriedPoint(
          pageName: "编辑文本页面",
          clickName: "txt分享",
        );
      } else if (index == 1) {
        BuriedPointHelper.clickBuriedPoint(
          pageName: "编辑文本页面",
          clickName: "docx分享",
        );
      }
    }, title: _title);
  }

  _save() async {
    BuriedPointHelper.clickBuriedPoint(
      pageName: "编辑文本页面",
      clickName: "保存",
    );
    // if (StringUtils.isNull(_titleController.text)){
    //   CommonUtils.showToastInfo("请输入您的文档名称");
    //   return;
    // }
    // if (StringUtils.isNull(_contentController.text)){
    //   CommonUtils.showToastInfo("请输入您的文档内容");
    //   return;
    // }
    DocumentModel model = widget.model;
    model.title = _title;
    model.content = widget.model.content; //  _contentController.text;
    model.createTime = formatDate(
        DateTime.now(), [yyyy, '-', mm, '-', dd, ' ', HH, ':', nn, ':', ss]);
    List<String> mobiles = [];
    _mobileControllers.forEach((controller) {
      mobiles.add(controller.text);
    });
    model.mobiles = mobiles;
    model.translateContents = [];

    print("indexTest==>${widget.index}");

    if (widget.index == -1) {
      File file = await CacheAudioManager.saveImageToFile(model.imagePath);
      model.imagePath = file.path;
      UserHelper().documentVM.addDocument(model);
    } else {
      UserHelper().documentVM.changeDocument(index: widget.index, model: model);
    }
    // Navigator.of(context).pushNamedAndRemoveUntil(
    //   RouteName.document_record_page,
    //   ModalRoute.withName(RouteName.main),
    // );
    CommonUtils.showToastInfo("保存成功");
    Navigator.of(context).popUntil(
      ModalRoute.withName(RouteName.main),
    );
  }

  void _callPhoneNumberAction(String phone, int type) async {
    debugPrint("拨打电话");
    if (_canTap) {
      _canTap = false;
      Future.delayed(Duration(seconds: 1), () {
        _canTap = true;
      });
      var url = type == 0 ? 'tel:${phone}' : 'sms:${phone}';
      // if (phone.length != 11) {
      //   CommonUtils.showToastInfo('该电话无法进行拨打');
      //   return;
      // }
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        CommonUtils.showToastInfo('该电话已失效');
      }
    }
  }

  _goBack() {
    DialogHelper.showTipsDialog(context,
        message: "退出后刚刚编辑的内容将不会被保存。",
        disable: "直接退出",
        disableCall: () {
          if (widget.index == -1) {
            Navigator.of(context).popUntil(
              ModalRoute.withName(RouteName.main),
            );
          } else {
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          }
        },
        prominent: "保存后退出",
        prominentCall: () async {
          _save();
        });
  }
}
