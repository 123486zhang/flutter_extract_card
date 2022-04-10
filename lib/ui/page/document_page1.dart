import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:graphic_conversion/event/any_event.dart';
import 'package:graphic_conversion/event/event_bus_util.dart';
import 'package:date_format/date_format.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graphic_conversion/data/net/conversion_api.dart';
import 'package:graphic_conversion/data/net/fizz_api.dart';
import 'package:graphic_conversion/locatization/localizations.dart';
import 'package:graphic_conversion/model/document_model.dart';
import 'package:graphic_conversion/router/router_config.dart';
import 'package:graphic_conversion/ui/helper/buried_point_helper.dart';
import 'package:graphic_conversion/ui/helper/dialog_helper.dart';
import 'package:graphic_conversion/ui/helper/resoure_helper.dart';
import 'package:graphic_conversion/ui/helper/user_helper.dart';
import 'package:graphic_conversion/ui/manager/cache_audio_manager.dart';
import 'package:graphic_conversion/utils/common_utils.dart';
import 'package:graphic_conversion/utils/string_utils.dart';
import 'package:keyboard_avoider/keyboard_avoider.dart';
import 'package:oktoast/oktoast.dart';
import 'package:path_provider/path_provider.dart';

class DocumentPage extends StatefulWidget {
  final DocumentModel model;

  final int index;

  final int translateTelephoneEnabledType;

  DocumentPage({this.model, this.index = -1, this.translateTelephoneEnabledType = -1});

  @override
  _DocumentPageState createState() => _DocumentPageState();
}

class _DocumentPageState extends State<DocumentPage> {
  StreamSubscription _subscription;

  PageController _pageController = PageController();

  List<TextEditingController> _contentControllers = [];

  String _title = "";

  int _currentIndex = 0;

  bool _hideVipMask = true;

  List _froms = [{'id': 1, 'name': '中文', 'value':'zh'}, {'id': 2, 'name': 'English', 'value':'en'}, {'id': 3, 'name': '日文', 'value':'jp'}, {'id': 4, 'name': '韩文', 'value':'kor'}];
  List _tos = [{'id': 1, 'name': 'English', 'value':'en'}, {'id': 2, 'name': '日文', 'value':'jp'}, {'id': 3, 'name': '韩文', 'value':'kor'}, {'id': 4, 'name': '中文','value':'zh'}];

  List _fromDataList;
  List _toDataList;

  int _translateTelephoneEnabledType = 0;

  int _selectedItemFromIndex = -1;
  int _selectedItemToIndex = -1;

  List<TextEditingController> _translateControllers = [];

  List<String> _imagePath = [];

  List<String> _photos = [];

  List<String> _contents = [];

  List<CancelToken> _cancelTokens = [];

  int _conversionCount = 0;

  String _pageName = "";

  bool _editTag = false;
  String _oldContent = "";

  List<FocusNode> _focus = [];

  bool _threeSecondsTagFinished = true;
  bool _translateFinished = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _subscription = EventBusUtil.listener<AnyEvent>((event) {
      switch (event.type) {
        case AnyEvent.REFRESH_VIP:
          setState(() {
            _conversion();
          });
          break;
      }
    });

    _pageName = "文档识别页";

    _contentControllers = List<TextEditingController>.generate(
        widget.model.contents.length, (index) {
      TextEditingController controller = TextEditingController();
      controller.text = widget.model.contents[index];
      return controller;
    });
    _title = widget.model.title;
    _imagePath = widget.model.imagePaths;

    _fromDataList = _froms.map((item) => DropdownMenuItem(
      value: item,
      child: Text(item['name'], style: TextStyle(color: Color(0xFF333333)),),
    )).toList();

    _toDataList = _tos.map((item) => DropdownMenuItem(
      value: item,
      child: Text(item['name'], style: TextStyle(color: Color(0xFF333333)),),
    )).toList();

    int length = widget.model.contents.length;
    _contentControllers = List<TextEditingController>.generate(
        length,
            (index) {
          _focus.add(FocusNode());
          TextEditingController controller = TextEditingController();
          controller.text = widget.model.contents[index];
          return controller;
        });
    _translateControllers = List<TextEditingController>.generate(
        length,
            (index) {
          TextEditingController controller = TextEditingController();
          controller.text = "";
          if(widget.model.translateContents!=null&&widget.model.translateContents.length>index) {
            controller.text = widget.model.translateContents[index];
          }
          return controller;
        });

    _title = widget.model.title;

    _translateTelephoneEnabledType = widget.translateTelephoneEnabledType;
    if(_translateTelephoneEnabledType==0) {
      Future.delayed(Duration(seconds: 1), (){
        _translate();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return _goBack();
      },
      child: AnnotatedRegion(
        value: SystemUiOverlayStyle.dark,
        child: Scaffold(
          body:  KeyboardAvoider(
            autoScroll: true,
            child:GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                FocusScope.of(context).requestFocus(FocusNode());
              },
              child: SafeArea(
                child: Column(
                  children: [
                    buildNavigator(),
                    Stack(
                      children: [
                        Column(
                          children: [
                            buildContent(),
                            buildCopyButton(),
                          ],
                        ),
                        Offstage(offstage: _hideVipMask, child: buildVipMask()),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildNavigator() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          height: ScreenUtil().setHeight(66),
          margin: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(100)),
          alignment: Alignment.center,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: null,
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
                // IntrinsicWidth(
                //   child: TextField(
                //     focusNode: _titleFocus,
                //     textAlign: TextAlign.center,
                //     style: TextStyle(fontSize: 18, color: Color(0xFF000000), fontWeight: FontWeight.bold,),
                //     controller: _titleController,
                //     decoration: InputDecoration(
                //       border: InputBorder.none,
                //       counterText: "",
                //       suffixIcon: Padding(
                //         padding: EdgeInsets.symmetric(vertical: 15),
                //         child: Image.asset(
                //           ImageHelper.imageRes("document_edit.png"),
                //           width: 15,
                //           height: 15,
                //         ),
                //       )
                //     ),
                //   ),
                // ),
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
              width: ScreenUtil().setWidth(50),
              height: ScreenUtil().setHeight(50),
              padding: EdgeInsets.only(left: ScreenUtil().setWidth(15)),
              alignment: Alignment.centerLeft,
              child: Image.asset(
                ImageHelper.imageRes('navigator_back.png'),
                width: ScreenUtil().setWidth(22),
                height: ScreenUtil().setHeight(22),
              ),
            ),
          ),
        ),
        Positioned(
          right: 0,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              if (_hideVipMask) {
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
              }
            },
            child: _hideVipMask
                ? Container(
                    height: ScreenUtil().setHeight(50),
                    width: ScreenUtil().setWidth(100),
                    padding: EdgeInsets.only(right: ScreenUtil().setWidth(15)),
                    alignment: Alignment.centerRight,
                    child: TextHelper.TextCreateWith(
                      text: "修改标题",
                      fontSize: 16,
                      color: Color(0xFF00C27C),
                    ),
                  )
                : Container(
                    height: ScreenUtil().setHeight(50),
                    width: ScreenUtil().setWidth(100),
                    padding: EdgeInsets.only(right: 15),
                    alignment: Alignment.centerRight,
                  ),
          ),
        ),
      ],
    );
  }

  Widget buildTips() {
    return Positioned(
        bottom: 0,
        left: widget.model.contents.length>=10?ScreenUtil().setWidth(123):ScreenUtil().setWidth(132),
        child: Container(
          alignment: Alignment.bottomCenter,
          transformAlignment: Alignment.bottomCenter,
          margin: EdgeInsets.only(bottom: ScreenUtil().setHeight(21)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Offstage(
                offstage: widget.model.contents.length == 1,
                child: Row(
                  children: [
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        if (_currentIndex == 0) return;
                        _pageController.animateToPage(_currentIndex - 1,
                            duration: Duration(milliseconds: 500),
                            curve: Curves.ease);
                      },
                      child: Container(
                        child: Image.asset(
                          ImageHelper.imageRes(_currentIndex == 0
                              ? "document_left_disable.png"
                              : "document_left_active.png"),
                          width: ScreenUtil().setWidth(16),
                          height: ScreenUtil().setHeight(16),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: ScreenUtil().setWidth(25),
                    ),
                    Container(
                      alignment: Alignment.centerRight,
                      child: TextHelper.TextCreateWith(
                        text: "${_currentIndex + 1}",
                        color: Color(0xFF333333),
                        fontSize: 19,
                        fontWeight: FontWeight.w500
                      ),
                    ),
                    TextHelper.TextCreateWith(
                      text: "/${widget.model.contents.length}",
                      color: Color(0xFF999999),
                      fontSize: 19,
                        fontWeight: FontWeight.w500
                    ),
                    SizedBox(
                      width: ScreenUtil().setWidth(25),
                    ),
                    GestureDetector(
                      onTap: () {
                        if (_currentIndex == widget.model.contents.length - 1)
                          return;
                        _pageController.animateToPage(_currentIndex + 1,
                            duration: Duration(milliseconds: 500),
                            curve: Curves.ease);
                      },
                      child: Container(
                        child: Image.asset(
                          ImageHelper.imageRes(
                              _currentIndex == widget.model.contents.length - 1
                                  ? "document_right_disable.png"
                                  : "document_right_active.png"),
                          width: ScreenUtil().setWidth(16),
                          height: ScreenUtil().setHeight(16),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ));
  }

  Widget buildVipMask() {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double height = screenHeight * 375/screenWidth;
    double diff=812-height;
    return Stack(
      children: [
        Container(
          height: ScreenUtil().setHeight(720-diff.toInt()),
          padding: EdgeInsets.only(bottom: ScreenUtil().setHeight(100)),
          child: ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
              child: Opacity(
                opacity: 0.2,
                child: Container(
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Opacity(
            opacity: 0.8,
            child: Container(
              height: ScreenUtil().setHeight(100),
              color: Colors.white,
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: ScreenUtil().setHeight(150)),
          child:Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              ImageHelper.imageRes("vip_icon.png"),
              width: ScreenUtil().setWidth(120),
              height: ScreenUtil().setHeight(120),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextHelper.TextCreateWith(
                  text: "识别剩余内容",
                  color: Color(0xFF8B5F00),
                  fontSize: 15,
                ),
              ],
            ),
            SizedBox(
              height: ScreenUtil().setWidth(15),
            ),
            GestureDetector(
              onTap: () {
                BuriedPointHelper.clickBuriedPoint(
                  pageName: "编辑文本页面",
                  clickName: "开通会员",
                );
                if (Platform.isIOS) {
                  Navigator.of(context)
                      .pushNamed(RouteName.vip_apple_page, arguments: {
                    "isBack": true,
                  }).then((value) {
                    setState(() {
                      if (value) _conversion();
                    });
                  });
                } else {
                  Navigator.of(context)
                      .pushNamed(RouteName.vip_android_page, arguments: {
                    "from": 1,
                  }).then((value) {
                    setState(() {
                      print("pay Result==>$value");
                      //if (UserHelper.instance.userVM.isVip) _conversion();
                    });
                  });
                }
              },
              child: Container(
                width: ScreenUtil().setWidth(192),
                height: ScreenUtil().setHeight(44),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: Color(0xFFFFE09E),
                    borderRadius: BorderRadius.all(Radius.circular(93))),
                child: TextHelper.TextCreateWith(
                  text: "开通会员",
                  color: Color(0xFF9B6300),
                  fontSize: 17,
                  isBlod: true,
                ),
              ),
            ),
            SizedBox(
              height: ScreenUtil().setHeight(160),
            ),
          ],
        ),
        )
      ],
    );
  }

  Widget buildContent() {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double height = screenHeight * 375/screenWidth;
    double diff=812-height;
    return Container(
      height: ScreenUtil().setHeight(630)-diff.toInt(),
      child: PageView.builder(
          controller: _pageController,
          itemCount: widget.model.contents.length,
          // setState(() {
          //   //开通会员后跳转到转换时的页面
          //   _hideVipMask=true;
          // });

          onPageChanged: (index) {
            setState(() {
              _currentIndex = index;
              if (!UserHelper().userVM.isVip && _currentIndex > 0) {
                _hideVipMask = false;
              } else {
                _hideVipMask = true;
              }
              if(_translateTelephoneEnabledType==0&&_translateControllers[_currentIndex].text.length<=0) {
                Future.delayed(Duration(seconds: 1), (){
                  _translate();
                });
              }
            });
          },

          itemBuilder: (ctx, index) {
            return _translateTelephoneEnabledType==0? buildContentAndTranslateItem(index) : buildContentItem(index);
          }),

    );
  }

  Widget buildContentAndTranslateItem(int index) {
    double otherHeightExceptTextfield = 316;
    double textfieldHeight = (MediaQuery.of(context).size.height - otherHeightExceptTextfield) /2;
    return Container(
        child: Stack(
          children: [
            Column(
              children: [
                Container(
                  height: textfieldHeight,
                  color: Color(0xFFF5F5F5),
                  margin: EdgeInsets.symmetric(horizontal: 15),
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: TextField(
                    // enabled: false,
                    onTap: (){
                      FocusScope.of(context).requestFocus(new FocusNode());
                    },
                    enableInteractiveSelection: false,
                    controller: _contentControllers[index],
                    style: TextStyle(fontSize: 17, color: Color(0xFF333333)),
                    maxLines: null,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                    ),
                  ),
                ),
                SizedBox(height: 18,),
                Stack(children: [
                  Container(
                    height: textfieldHeight,
                    color: Color(0xFFF5F5F5),
                    margin: EdgeInsets.symmetric(horizontal: 15),
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: TextField(
                      // enabled: false,
                      onTap: (){
                        FocusScope.of(context).requestFocus(new FocusNode());
                      },
                      enableInteractiveSelection: false,
                      controller: _translateControllers[index],
                      style: TextStyle(fontSize: 17, color: Color(0xFF333333)),
                      maxLines: null,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  Positioned(
                    right: 15,
                    top: textfieldHeight*2-50+18,
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: (){
                        BuriedPointHelper.clickBuriedPoint(
                          pageName: "编辑文本页面",
                          clickName: "复制翻译文字",
                        );
                        String text = _translateControllers[_currentIndex].text;
                        Clipboard.setData(ClipboardData(text: text));
                        showToast('已复制到剪切板');
                        FocusScope.of(context).requestFocus();
                      },
                      child: Container(
                        width: 50,
                        height: 50,
                        padding: EdgeInsets.only(right: 10),
                        alignment: Alignment.centerLeft,
                        child: Image.asset(
                          ImageHelper.imageRes('document_copy.png'),
                          width: 22,
                          height: 22,
                        ),
                      ),
                    ),
                  ),
                ],)
              ],
            ),
            Positioned(
              right: 5,
              top: textfieldHeight-50,
              child: Row(children: [
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: (){
                    setState(() {
                      _oldContent = _contentControllers[_currentIndex].text;
                      _editTag = true;
                    });

                    Future.delayed(Duration(seconds: 1), (){
                      FocusScope.of(context).requestFocus(_focus[_currentIndex]);
                    });
                  },
                  child: Container(
                    width: 50,
                    height: 50,
                    padding: EdgeInsets.only(left: 10),
                    alignment: Alignment.centerLeft,
                    child: Image.asset(
                      ImageHelper.imageRes('document_edit.png'),
                      width: 22,
                      height: 22,
                    ),
                  ),
                ),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: (){
                    BuriedPointHelper.clickBuriedPoint(
                      pageName: "编辑文本页面",
                      clickName: "复制识别文字",
                    );
                    String text = _contentControllers[_currentIndex].text;
                    Clipboard.setData(ClipboardData(text: text));
                    showToast('已复制到剪切板');
                    FocusScope.of(context).requestFocus();
                  },
                  child: Container(
                    width: 50,
                    height: 50,
                    padding: EdgeInsets.only(right: 10),
                    alignment: Alignment.centerLeft,
                    child: Image.asset(
                      ImageHelper.imageRes('document_copy.png'),
                      width: 22,
                      height: 22,
                    ),
                  ),
                ),
              ],
              ),
            ),
          ],)


    );
  }

  _translate() async {
    _threeSecondsTagFinished = false;
    _translateFinished = false;
    EasyLoading.show();
    Future.delayed(Duration(seconds: 3), () async {
      EasyLoadingDismiss(true, false);
    });
    int i = _currentIndex;
    int currentIndex = i;
    String q = "";
    // for(int i = 0;i<widget.model.contents.length;i++)
        {
      q = q + _contentControllers[i].text;// widget.model.contents[i];
    }
    if(_selectedItemFromIndex<0&&_selectedItemToIndex<0) {
      requestCurrentLanguage(q, currentIndex);
    }else{
      String from = "auto";
      if(_selectedItemFromIndex>=0) {
        from = _fromDataList[_selectedItemFromIndex].value["value"];
      }
      String to = "zh";
      if(_selectedItemToIndex>=0) {
        to = _toDataList[_selectedItemToIndex].value["value"];
      }
      to = _toDataList[_selectedItemToIndex].value["value"];
      requestTranslateToLanguage(q, from, to, currentIndex);
    }
  }

  void requestTranslateToLanguage(String q, String from, String to, int currentIndex){
    ConversionApi.requestTranslateToLanguage(q: q, index: currentIndex, from: from, to: to).then((value) {
      print(value);
      List dataMap = value["data"];
      String dst = "";
      for(int i=0;i<dataMap.length;i++){
        dst = dst + dataMap[i]["dst"]+"\n";
      }
      _translateControllers[currentIndex].text = dst;
      EasyLoadingDismiss(false, true);
      setState(() {
        _translateTelephoneEnabledType = 0;
      });
    });
  }

  void requestCurrentLanguage(String q, int currentIndex){
    ConversionApi.requestCurrentLanguage(q: q, index: currentIndex).then((value) {
      if(value==null){
        showToast(JYLocalizations.localizedString("翻译失败！"));
        EasyLoadingDismiss(false, true);
        return;
      }
      print(value);
      String from = "auto";
      String to = "zh";
      if (value["data"] != null) {
        if (value["data"].length > 0) {
          if (value["data"]["src"] == "zh") {
            to = "en";
          }
        }
      }
      for(int i=0;i<_toDataList.length;i++){
        if(_toDataList[i].value["value"]==to){
          _selectedItemToIndex = i;
          break;
        }
      }
      requestTranslateToLanguage(q, from, to, currentIndex);
    });
  }


  void EasyLoadingDismiss(bool threeSecondsTag, bool translateTag){
    if(threeSecondsTag){
      _threeSecondsTagFinished = true;
    }
    if(translateTag){
      _translateFinished = true;
    }
    if(_threeSecondsTagFinished&&_translateFinished) {
      EasyLoading.dismiss();
    }
  }

  Widget buildContentItem(int index) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double height = screenHeight * 375/screenWidth;
    double diff=812-height;
    return Column(
      children: [
        Stack(
          children: [
            Container(
              height: ScreenUtil().setHeight(630-diff.toInt()),
              alignment: Alignment.topLeft,
              color: Color(0xFFF6F6F9),
              padding: EdgeInsets.only(
                  left: ScreenUtil().setWidth(15),
                  right: ScreenUtil().setWidth(15),
                  bottom: ScreenUtil().setHeight(50)),
              child: TextField(
                style: TextStyle(fontSize: 16, color: Color(0xFF333333)),
                controller: _contentControllers[index],
                maxLines: null,
                decoration: InputDecoration(
                  border: InputBorder.none,
                ),
              ),
            ),
            buildTips(),
          ],
        ),
      ],
    );
  }

  Widget buildCopyButton() {
    return Container(
      height: ScreenUtil().setHeight(85),
      alignment: Alignment.topLeft,
      margin: EdgeInsets.only(
          left: ScreenUtil().setWidth(43), right: ScreenUtil().setWidth(20)),
      padding: EdgeInsets.only(top: ScreenUtil().setHeight(20)),
      child: Column(
        children: [
          Container(
            alignment: Alignment.topLeft,
            child: Row(
              children: [
                Column(
                  children: [
                    GestureDetector(
                      onTap: _copy,
                      child: Container(
                        alignment: Alignment.topLeft,
                        child: Image.asset(
                          ImageHelper.imageRes("document_copy.png"),
                          width: ScreenUtil().setWidth(25),
                          height: ScreenUtil().setHeight(25),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: _copy,
                      child: Container(
                        margin: EdgeInsets.only(top:ScreenUtil().setHeight(5)),
                        alignment: Alignment.topLeft,
                        child: Container(
                          child: TextHelper.TextCreateWith(
                            text: "复制",
                            color: Color(0xFF333333),
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    GestureDetector(
                      onTap: _export,
                      child: Container(
                        alignment: Alignment.topLeft,
                        margin:
                            EdgeInsets.only(left: ScreenUtil().setWidth(41)),
                        child: Image.asset(
                          ImageHelper.imageRes("document_share.png"),
                          width: ScreenUtil().setWidth(25),
                          height: ScreenUtil().setHeight(25),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: _export,
                      child: Container(
                        alignment: Alignment.topLeft,
                        margin: EdgeInsets.only(left: ScreenUtil().setWidth(40),top:ScreenUtil().setHeight(5)),
                        child:   Container(
                          alignment: Alignment.topLeft,
                          margin: EdgeInsets.only(
                          ),
                          child: TextHelper.TextCreateWith(
                            text: "分享",
                            color: Color(0xFF333333),
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: _save,
                  child: Container(
                    width: ScreenUtil().setWidth(180),
                    height: ScreenUtil().setHeight(45),
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(left: ScreenUtil().setWidth(40)),
                    decoration: BoxDecoration(
                        color: Color(0XFF00C27C),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: TextHelper.TextCreateWith(
                      text: "保存",
                      color: Colors.white,
                      fontSize: 15,
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  _copy() {
    BuriedPointHelper.clickBuriedPoint(
      pageName: "编辑文本页面",
      clickName: "复制文字",
    );
    String text = "";
    if (!UserHelper().userVM.isVip) {
      text = _contentControllers[0].text;
    } else {
      _contentControllers.forEach((controller) {
        text = text + controller.text + "\n";
      });
    }
    Clipboard.setData(ClipboardData(text: text));
    showToast('已复制到剪切板');
    FocusScope.of(context).requestFocus();
  }

  _export() async {
    BuriedPointHelper.clickBuriedPoint(
      pageName: "编辑文本页面",
      clickName: "导出",
    );
    String text = "";
    if (!UserHelper().userVM.isVip) {
      text = _contentControllers[0].text;
    } else {
      _contentControllers.forEach((controller) {
        text = text + controller.text + "\n";
      });
    }
    String filePath = "${DateTime.now().millisecondsSinceEpoch}";
    File file = await CacheAudioManager.writeDocument(
      text: text,
      filePath: filePath,
    );
    DialogHelper.showDocumentShareDialog(context, file: file,
        callback: (index) {
      if (index == 0) {
        BuriedPointHelper.clickBuriedPoint(
          pageName: "编辑文本页面",
          clickName: "微信好友",
        );
      } else if (index == 2) {
        BuriedPointHelper.clickBuriedPoint(
          pageName: "编辑文本页面",
          clickName: "微信收藏",
        );
      }
    });
  }

  _goBack() {
    if (!_hideVipMask) {
      _pageController.animateToPage(_currentIndex - 1,
          duration: Duration(milliseconds: 500), curve: Curves.ease);
      _hideVipMask = true;
      setState(() {});
    } else {
      DialogHelper.showReSaveDialog(context).then((value) {
        if (value) {
          Navigator.of(context).pop();
        }
      });
    }
  }

  _save() async {
    BuriedPointHelper.clickBuriedPoint(
      pageName: "编辑文本页面",
      clickName: "保存",
    );
    // if (StringUtils.isNull(_titleController.text)){
    //   showToast("请输入您的文档名称");
    //   return;
    // }
    if (_contentControllers.length == 1 &&
        StringUtils.isNull(_contentControllers[0].text)) {
      showToast("请输入您的文档内容");
      return;
    }
    DocumentModel model = widget.model;
    model.title = _title;
    List<String> contents = [];
    _contentControllers.forEach((controller) {
      contents.add(controller.text);
    });
    model.contents = contents;
    model.createTime = formatDate(
        DateTime.now(), [yyyy, '-', mm, '-', dd, ' ', HH, ':', nn, ':', ss]);
    if (widget.index == -1) {
      File file = await CacheAudioManager.saveImageToFile(model.imagePaths[0]);
      model.imagePath = file.path;
      UserHelper().documentVM.addDocument(model);
    } else {
      UserHelper().documentVM.changeDocument(index: widget.index, model: model);
    }
    showToast('保存成功');
    Navigator.of(context).popUntil(
      ModalRoute.withName(RouteName.main),
    );
  }

  _conversion() async {
    BuriedPointHelper.clickBuriedPoint(
      pageName: _pageName,
      clickName: "开通会员-开始识别",
    );
    // if (!await CommonUtils.isLogin(context)) return;
    // if (!UserHelper().userVM.isVip) {
    //   bool isCanUse = await FIZZApi.requestFunctionCanUse(); //是否可使用 ，需要改id
    //   if (!isCanUse) {
    //     DialogHelper.showVipDialog(context);
    //     return;
    //   }
    // }

    _contents = [];
    _cancelTokens = [];
    _conversionCount = 0;
    DialogHelper.showConversionLoadingDialog(context).then((value) {
      debugPrint("手动取消");
      _cancelTokens.forEach((token) {
        token.cancel();
      });
    });
    // EasyLoading.show(status: "正在识别中，请稍等");
    for (int i = 0; i < _imagePath.length; i++) {
      String photoPath = _imagePath[i];
      _contents.add("");

      int resultIndex = 0;
      var content = "";
      //普通用户仅可使用一张
      File file = File(photoPath);
      Uint8List bytes = await file.readAsBytes();
      String base64 = base64Encode(bytes);
      int quality = 100;
      while (base64.length > 4000000) {
        debugPrint("压缩前：${base64.length}");
        bytes = await FlutterImageCompress.compressWithList(bytes,
            quality: quality);
        base64 = base64Encode(bytes);
        debugPrint("压缩后：${base64.length}");
        quality = quality - 5;
      }
      CancelToken cancelToken = CancelToken();
      _cancelTokens.add(cancelToken);
      var value = await ConversionApi.requestRecognition(
          image: base64, index: i, cancelToken: cancelToken);
      _conversionCount++;
      resultIndex = value["index"];
      if (value["words_result"] != null) {
        for (Map map in value["words_result"]) {
          content = content + map["words"] + "\n";
        }
      }

      if (StringUtils.isNull(content))
        content = JYLocalizations.localizedString("（该张图片格式不符合规范或内容有误，无法识别!）");
      _contents.removeAt(resultIndex);
      _contents.insert(resultIndex, content);
      print("test number:==>$i");
    }
    _conversionComplete();
  }

  _conversionComplete() {
    // if (_conversionCount != _photos.length) return;
    Navigator.pop(DialogHelper.dialogContext);
    FIZZApi.requestFunctionSave();
    DocumentModel model = DocumentModel();
    model.title = "文档";
    model.contents = _contents;
    model.imagePath = _imagePath[0];
    model.imagePaths = _imagePath;
    model.currentIndex = _currentIndex;
    Navigator.of(context)
        .pushReplacementNamed(RouteName.document_page, arguments: {
      "model": model,
      "index": -1,
    });
  }
}
