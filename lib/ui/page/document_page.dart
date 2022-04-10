import 'dart:io';
import 'dart:ui';

import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:graphic_conversion/data/net/conversion_api.dart';
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
import 'package:oktoast/oktoast.dart';

class DocumentPage extends StatefulWidget {
  final DocumentModel model;

  final int index;

  final int translateTelephoneEnabledType;

  DocumentPage(
      {this.model, this.index = -1, this.translateTelephoneEnabledType = -1});

  @override
  _DocumentPageState createState() => _DocumentPageState();
}

class _DocumentPageState extends State<DocumentPage> {
  PageController _pageController = PageController();

  List<TextEditingController> _contentControllers = [];
  List<FocusNode> _focus = [];

  String _title = "";

  int _currentIndex = 0;

  bool _hideVipMask = true;

  bool _isExit = false;

  List _froms = [
    {'id': 1, 'name': '中文', 'value': 'zh'},
    {'id': 2, 'name': 'English', 'value': 'en'},
    {'id': 3, 'name': '日文', 'value': 'jp'},
    {'id': 4, 'name': '韩文', 'value': 'kor'}
  ];
  List _tos = [
    {'id': 1, 'name': 'English', 'value': 'en'},
    {'id': 2, 'name': '日文', 'value': 'jp'},
    {'id': 3, 'name': '韩文', 'value': 'kor'},
    {'id': 4, 'name': '中文', 'value': 'zh'}
  ];

  List _fromDataList;
  List _toDataList;

  int _translateTelephoneEnabledType = 0;

  int _selectedItemFromIndex = -1;
  int _selectedItemToIndex = -1;

  List<TextEditingController> _translateControllers = [];

  bool _editTag = false;
  String _oldContent = "";

  bool _threeSecondsTagFinished = true;
  bool _translateFinished = true;
  bool _isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _fromDataList = _froms
        .map((item) => DropdownMenuItem(
              value: item,
              child: Text(
                item['name'],
                style: TextStyle(color: Color(0xFF333333)),
              ),
            ))
        .toList();

    _toDataList = _tos
        .map((item) => DropdownMenuItem(
              value: item,
              child: Text(
                item['name'],
                style: TextStyle(color: Color(0xFF333333)),
              ),
            ))
        .toList();

    int length = widget.model.contents.length;
    _contentControllers = List<TextEditingController>.generate(length, (index) {
      _focus.add(FocusNode());
      TextEditingController controller = TextEditingController();
      controller.text = widget.model.contents[index];
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

    _translateTelephoneEnabledType = widget.translateTelephoneEnabledType;
    if (_translateTelephoneEnabledType == 0) {
      Future.delayed(Duration(seconds: 1), () {
        _translate();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await _save();
      },
      child: AnnotatedRegion(
        value: SystemUiOverlayStyle.dark,
        child: Scaffold(
          backgroundColor: Color(0xFFF6F6F9),
          body: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: SafeArea(
              child: Column(
                children: _editTag
                    ? [
                        buildEditNavigator(),
                        Expanded(child: buildContentItem(_currentIndex)),
                        SizedBox(
                          height: 47,
                        )
                      ]
                    : [
                        buildNavigator(),
                        // buildTips(),
                        Expanded(
                            child: Stack(
                          children: [
                            Column(
                              children: [
                                Expanded(child: buildContent()),
                                SizedBox(
                                  height: 15,
                                ),
                                buildBottomButton(),
                              ],
                            ),
                            Offstage(
                                offstage: _hideVipMask, child: buildVipMask()),
                          ],
                        )),
                      ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildEditNavigator() {
    return Container(
      color: Colors.white,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: 50,
            margin: EdgeInsets.symmetric(horizontal: 100),
            alignment: Alignment.center,
            child: TextHelper.TextCreateWith(
              text: JYLocalizations.localizedString("修改文档"),
              fontSize: 18,
              color: Colors.black,
              isBlod: true,
              isClip: true,
            ),
          ),
          Positioned(
            left: 0,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                setState(() {
                  _contentControllers[_currentIndex].text = _oldContent;
                  _oldContent = "";
                  _editTag = false;
                });
              },
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
              onTap: () {
                setState(() {
                  _editTag = false;
                });
                if (_translateTelephoneEnabledType == 0) {
                  Future.delayed(Duration(seconds: 1), () async {
                    await _translate();
                    _pageController.animateToPage(_currentIndex,
                        duration: Duration(milliseconds: 500),
                        curve: Curves.ease);
                  });
                }
              },
              child: Container(
                height: 50,
                width: 100,
                padding: EdgeInsets.only(right: 15),
                alignment: Alignment.centerRight,
                child: TextHelper.TextCreateWith(
                  text: "保存",
                  fontSize: 15,
                  color: Color(0xFF00C27C),
                  isBlod: true,
                ),
              ),
            ),
          ),
        ],
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
            margin: EdgeInsets.symmetric(horizontal: 54),
            alignment: Alignment.center,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: Text(_title,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        )
                        // isBlod: true,
                        // isClip: true,
                        ),
                  ),

                  // SizedBox(width: 5,),
                  // Image.asset(
                  //   ImageHelper.imageRes("document_edit.png"),
                  //   width: 18,
                  //   height: 18,
                  // ),

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
              onTap: () => Navigator.of(context).pop(),
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
              child: Container(
                height: 50,
                width: 100,
                padding: EdgeInsets.only(right: 15),
                alignment: Alignment.centerRight,
                child: TextHelper.TextCreateWith(
                  text: "修改标题",
                  fontSize: 15,
                  isBlod: true,
                  color: Color(0xFF00C27C),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDropdownButtonItem(int selectedType) {
    return DropdownButtonHideUnderline(
      //  DropdownButton默认有一条下划线（如上图），此widget去除下划线
      child: DropdownButton(
        items: selectedType == 0 ? _fromDataList : _toDataList,
        hint: Text(selectedType == 0
            ? JYLocalizations.localizedString("自动检测")
            : JYLocalizations.localizedString("请选择")),
        onChanged: (value) {
          print(value);
          setState(() {
            for (int i = 0; i < _fromDataList.length; i++) {
              Map element = _fromDataList[i].value;
              if (element["id"] == value["id"]) {
                if (selectedType == 0) {
                  _selectedItemFromIndex = i;
                } else {
                  _selectedItemToIndex = i;
                }
                break;
              }
            }
          });
          Future.delayed(Duration(seconds: 1), () {
            _translate();
          });
        },
        value: selectedType == 0
            ? (_selectedItemFromIndex >= 0
                ? _fromDataList[_selectedItemFromIndex].value
                : null)
            : (_selectedItemToIndex >= 0
                ? _toDataList[_selectedItemToIndex].value
                : null),
      ),
    );
  }

  Widget buildTranslationWidgets() {
    return Container(
      child: Row(
        children: [
          buildDropdownButtonItem(0),
          Container(
            margin: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
            child: Image.asset(
              ImageHelper.imageRes("document_translate_arrow.png"),
              width: 20,
              height: 20,
            ),
          ),
          buildDropdownButtonItem(1),
        ],
      ),
    );
  }

  Widget buildTips() {
    return Container(
      color: Colors.white,
      height: 50,
      // decoration: BoxDecoration(
      //   color: Color(0xFFEBEBEB),
      //   borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
      // ),
      padding: EdgeInsets.symmetric(horizontal: 33),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _translateTelephoneEnabledType == 0
              ? buildTranslationWidgets()
              : TextHelper.TextCreateWith(
                  text: "识别内容",
                  color: Color(0xFF585858),
                  fontSize: 14,
                ),
          Offstage(
            offstage: widget.model.contents.length == 1,
            child: Container(
              child: Row(
                children: [
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      if (_currentIndex <= 0) return;
                      _currentIndex = _currentIndex - 1;
                      _pageController.animateToPage(_currentIndex,
                          duration: Duration(milliseconds: 500),
                          curve: Curves.ease);
                      if (_translateTelephoneEnabledType == 0 &&
                          _translateControllers[_currentIndex].text.length <=
                              0) {
                        Future.delayed(Duration(seconds: 1), () {
                          _translate();
                        });
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.all(5),
                      child: Image.asset(
                        ImageHelper.imageRes(_currentIndex == 0
                            ? "document_left_disable.png"
                            : "document_left_active.png"),
                        width: 16,
                        height: 16,
                      ),
                    ),
                  ),
                  Container(
                      width: 25,
                      // alignment: Alignment.center,
                      child: Row(
                        children: [
                          TextHelper.TextCreateWith(
                            text: "${_currentIndex + 1}",
                            color: Color(0xFF303030),
                            fontSize: 16,
                          ),
                          TextHelper.TextCreateWith(
                            text: "/${widget.model.contents.length}",
                            color: Color(0xFFC1C1C1),
                            fontSize: 16,
                          ),
                        ],
                      )),
                  // SizedBox(width: 10,),
                  GestureDetector(
                    onTap: () {
                      if (_currentIndex == widget.model.contents.length - 1)
                        return;
                      _currentIndex = _currentIndex + 1;
                      _pageController.animateToPage(_currentIndex,
                          duration: Duration(milliseconds: 500),
                          curve: Curves.ease);
                      if (_translateTelephoneEnabledType == 0 &&
                          _translateControllers[_currentIndex].text.length <=
                              0) {
                        Future.delayed(Duration(seconds: 1), () {
                          _translate();
                        });
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.all(5),
                      child: Image.asset(
                        ImageHelper.imageRes(
                            _currentIndex == widget.model.contents.length - 1
                                ? "document_right_disable.png"
                                : "document_right_active.png"),
                        width: 16,
                        height: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget buildVipMask() {
    return Stack(
      children: [
        Container(
          padding: EdgeInsets.only(bottom: 100),
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
              height: 100,
              color: Colors.white,
            ),
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              ImageHelper.imageRes("vip_icon.png"),
              width: 113,
              height: 104,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextHelper.TextCreateWith(
                  text: "识别剩余内容",
                  color: Color(0xFF8D5A32),
                  fontSize: 18,
                ),
              ],
            ),
            SizedBox(
              height: 27,
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
                    setState(() {});
                  });
                } else {
                  Navigator.of(context)
                      .pushNamed(RouteName.vip_android_page, arguments: {
                    "isBack": true,
                  }).then((value) {
                    setState(() {});
                  });
                }
              },
              child: Container(
                width: 192,
                height: 44,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: Color(0xFFEDD298),
                    borderRadius: BorderRadius.all(Radius.circular(26))),
                child: TextHelper.TextCreateWith(
                  text: "开通会员",
                  color: Color(0xFF905C34),
                  fontSize: 16,
                  isBlod: true,
                ),
              ),
            ),
            SizedBox(
              height: 160,
            ),
          ],
        )
      ],
    );
  }

  Widget buildContent() {
    return Container(
      child: PageView.builder(
          controller: _pageController,
          itemCount: widget.model.contents.length,
          onPageChanged: (index) {
            setState(() {
              _currentIndex = index;
              if (!UserHelper().userVM.isVip && _currentIndex > 0) {
                _hideVipMask = false;
              } else {
                _hideVipMask = true;
              }
              if (_translateTelephoneEnabledType == 0 &&
                  _translateControllers[_currentIndex].text.length <= 0) {
                Future.delayed(Duration(seconds: 1), () {
                  _translate();
                });
              }
            });
          },
          itemBuilder: (ctx, index) {
            return _translateTelephoneEnabledType == 0
                ? buildContentAndTranslateItem(index)
                : buildContentItem(index);
          }),
    );
  }

  Widget buildContentItem(int index) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10))),
      margin: EdgeInsets.only(left: 15, top: 15, right: 15),
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: TextField(
        // onTap: (){
        //   FocusScope.of(context).requestFocus(new FocusNode());
        // },
        // enableInteractiveSelection: false,
        focusNode: _focus[index],
        controller: _contentControllers[index],
        style: TextStyle(fontSize: 17, color: Color(0xFF333333)),
        maxLines: null,
        decoration: InputDecoration(
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget buildContentAndTranslateItem(int index) {
    double otherHeightExceptTextfield = 266;
    double textfieldHeight = (MediaQuery.of(context).size.height - otherHeightExceptTextfield) /2;
    return Container(
        child: Stack(
      children: [
        Column(
          children: [
            SizedBox(
              height: 15,
            ),
            Container(
              height: textfieldHeight,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(15))),
              margin: EdgeInsets.symmetric(horizontal: 15),
              padding: EdgeInsets.only(left: 15, right: 15, bottom: 20),
              child: TextField(
                // enabled: false,
                onTap: () {
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
            SizedBox(
              height: 9,
            ),
            Stack(
              children: [
                Container(
                  height: textfieldHeight,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(15))),
                  margin: EdgeInsets.symmetric(horizontal: 15),
                  padding: EdgeInsets.only(left: 15, right: 15, bottom: 30),
                  child: TextField(
                    // enabled: false,
                    onTap: () {
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
                  right: 5,
                  bottom: 0,
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
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
              ],
            )
          ],
        ),
        Positioned(
          right: 5,
          top: textfieldHeight - 30,
          child: Row(
            children: [
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  setState(() {
                    _oldContent = _contentControllers[_currentIndex].text;
                    _editTag = true;
                  });
                  Future.delayed(Duration(seconds: 1), () {
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
                onTap: () {
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
      ],
    ));
  }

  Widget buildBottomButton() {
    return Container(
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Offstage(
            offstage: widget.model.contents.length == 1,
            child: Container(
              margin: EdgeInsets.only(left: 10),
              child: Row(
                children: [
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      if (!CommonUtils.isFastClick3()) {
                        if (_currentIndex <= 0) return;
                        _currentIndex = _currentIndex - 1;
                        _pageController.animateToPage(_currentIndex,
                            duration: Duration(milliseconds: 500),
                            curve: Curves.ease);
                        if (_translateTelephoneEnabledType == 0 &&
                            _translateControllers[_currentIndex].text.length <=
                                0) {
                          Future.delayed(Duration(seconds: 1), () {
                            _translate();
                          });
                        }
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.all(5),
                      child: Image.asset(
                        ImageHelper.imageRes(_currentIndex == 0
                            ? "document_left_disable.png"
                            : "document_left_active.png"),
                        width: 16,
                        height: 16,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: widget.model.contents.length >= 10 ? 15 : 25,
                  ),
                  Container(
                      width: widget.model.contents.length >= 10 ? 35 : 25,
                      // alignment: Alignment.center,
                      child: Row(
                        children: [
                          TextHelper.TextCreateWith(
                            text: "${_currentIndex + 1}",
                            color: Color(0xFF303030),
                            fontSize: 16,
                          ),
                          TextHelper.TextCreateWith(
                            text: "/${widget.model.contents.length}",
                            color: Color(0xFFC1C1C1),
                            fontSize: 16,
                          ),
                        ],
                      )),
                  SizedBox(
                    width: widget.model.contents.length >= 10 ? 15 : 25,
                  ),
                  // SizedBox(width: 10,),
                  GestureDetector(
                    onTap: () {
                      if (!CommonUtils.isFastClick4()) {
                        if (_currentIndex == widget.model.contents.length - 1)
                          return;
                        _currentIndex = _currentIndex + 1;
                        _pageController.animateToPage(_currentIndex,
                            duration: Duration(milliseconds: 500),
                            curve: Curves.ease);
                        if (_translateTelephoneEnabledType == 0 &&
                            _translateControllers[_currentIndex].text.length <=
                                0) {
                          Future.delayed(Duration(seconds: 1), () {
                            _translate();
                          });
                        }
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.all(5),
                      child: Image.asset(
                        ImageHelper.imageRes(
                            _currentIndex == widget.model.contents.length - 1
                                ? "document_right_disable.png"
                                : "document_right_active.png"),
                        width: 16,
                        height: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
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
                      margin: EdgeInsets.only(
                          left: widget.model.contents.length == 1 ? 35 : 40),
                      child: Image.asset(
                        ImageHelper.imageRes("document_share.png"),
                        width: 25,
                        height: 25,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          top: 5,
                          left: widget.model.contents.length == 1 ? 35 : 40),
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
            onTap: _save,
            child: Container(
              width: widget.model.contents.length == 1 ? 180 : 115,
              margin: EdgeInsets.only(
                  bottom: 27,
                  top: 22,
                  left: widget.model.contents.length == 1 ? 50 : 15,
                  right: 20),
              height: 45,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: Color(0xFF00C27C),
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: TextHelper.TextCreateWith(
                text: "保存",
                color: Colors.white,
                fontSize: 16,
                isBlod: true,
              ),
            ),
          ),
        ],
      ),
    );
    // return Container(
    //   color: Colors.white,
    //   padding: EdgeInsets.only(bottom: 35, left: 15, right: 15),
    //   child: Row(
    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //     children: [
    //       Offstage(
    //         offstage: false,// _translateTelephoneEnabledType==0,
    //         child: GestureDetector(
    //           onTap: _translate,
    //           child: Container(
    //               width: 52,
    //               height: 52,
    //               alignment: Alignment.center,
    //               // decoration: BoxDecoration(
    //               //     color: Color(0xFFE9EFFF),
    //               //     borderRadius: BorderRadius.all(Radius.circular(26))
    //               // ),
    //               child: Column(
    //                 children: [
    //                   Container(
    //                     margin: EdgeInsets.only(top: 2),
    //                     child: Image.asset(
    //                       ImageHelper.imageRes("feature_image3.png"),
    //                       width: 26,
    //                       height: 26,
    //                     ),
    //                   ),
    //                   TextHelper.TextCreateWith(
    //                     text: "翻译",
    //                     color: Color(0xFF666666),
    //                     fontSize: 15,
    //                     // isBlod: true,
    //                   ),
    //                 ],
    //               )
    //           ),
    //         ),
    //       ),
    //       GestureDetector(
    //         onTap: _copy,
    //         child: Container(
    //           width: 156,//_translateTelephoneEnabledType==0?208:
    //           height: 52,
    //           alignment: Alignment.center,
    //           decoration: BoxDecoration(
    //               color: Color(0xFFE9EFFF),
    //               borderRadius: BorderRadius.all(Radius.circular(26))
    //           ),
    //           child: TextHelper.TextCreateWith(
    //             text: "一键复制",//全部页面内容
    //             color: Color(0xFF2F68F8),
    //             fontSize: 16,
    //             isBlod: true,
    //           ),
    //         ),
    //       ),
    //       GestureDetector(
    //         onTap: _export,
    //         child: Container(
    //           width: 132,
    //           height: 52,
    //           alignment: Alignment.center,
    //           decoration: BoxDecoration(
    //               color: ColorHelper.color_main,
    //               borderRadius: BorderRadius.all(Radius.circular(26))
    //           ),
    //           child: TextHelper.TextCreateWith(
    //             text: "导出",
    //             color: Colors.white,
    //             fontSize: 16,
    //             isBlod: true,
    //           ),
    //         ),
    //       )
    //     ],
    //   ),
    // );
  }

  _copy() {
    BuriedPointHelper.clickBuriedPoint(
      pageName: "编辑文本页面",
      clickName: "复制文字",
    );
    String text = "";
    if (!UserHelper().userVM.isVip) {
      text = _contentControllers[0].text + "\n";
      if (_translateTelephoneEnabledType == 0) {
        text = _translateControllers[0].text + "\n";
      }
    } else {
      _contentControllers.forEach((controller) {
        text = text + controller.text + "\n";
      });
      if (_translateTelephoneEnabledType == 0) {
        _translateControllers.forEach((controller) {
          text = text + controller.text + "\n";
        });
      }
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
      text = _contentControllers[0].text + "\n";
      if (_translateTelephoneEnabledType == 0) {
        text = _translateControllers[0].text + "\n";
      }
    } else {
      _contentControllers.forEach((controller) {
        text = text + controller.text + "\n";
      });
      if (_translateTelephoneEnabledType == 0) {
        _translateControllers.forEach((controller) {
          text = text + controller.text + "\n";
        });
      }
    }
    String filePath = "${DateTime.now().millisecondsSinceEpoch}";
    File file = await CacheAudioManager.writeDocument(
      text: text,
      filePath: filePath,
    );

    DialogHelper.showDocumentShareDialog1(context,
        file: file,
        contentControllers: _contentControllers,
        translateControllers: _translateControllers, callback: (index) {
      if (index == 0) {
        BuriedPointHelper.clickBuriedPoint(
          pageName: "编辑文本页面",
          clickName: "txt分享",
        );
      } else if (index == 2) {
        BuriedPointHelper.clickBuriedPoint(
          pageName: "编辑文本页面",
          clickName: "word分享",
        );
      }
    });
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
    List<String> translateContents = [];
    if (_translateTelephoneEnabledType == 0) {
      _translateControllers.forEach((controller) {
        translateContents.add(controller.text);
      });
    }
    model.contents = contents;
    model.translateContents = translateContents;
    model.createTime = formatDate(
        DateTime.now(), [yyyy, '-', mm, '-', dd, ' ', HH, ':', nn, ':', ss]);
    print("indexsass=>${widget.index}");
    if (widget.index == -1) {
      if (model.imagePaths != null && model.imagePaths.length > 0) {
        File file =
            await CacheAudioManager.saveImageToFile(model.imagePaths[0]);
        model.imagePath = file.path;
      }
      UserHelper().documentVM.addDocument(model);
    } else {
      UserHelper().documentVM.changeDocument(index: widget.index, model: model);
    }
    _isExit = true;
    EasyLoading.dismiss();
    CommonUtils.showToastInfo("保存成功");
    Navigator.of(context).popUntil(
      ModalRoute.withName(RouteName.main),
    );
  }

  void requestTranslateToLanguage(
      String q, String from, String to, int currentIndex) {
    ConversionApi.requestTranslateToLanguage(
            q: q, index: currentIndex, from: from, to: to)
        .then((value) {
      print(value);
      List dataMap = value["data"];
      String dst = "";
      for (int i = 0; i < dataMap.length; i++) {
        dst = dst + dataMap[i]["dst"] + "\n";
      }
      _translateControllers[currentIndex].text = dst;
      EasyLoadingDismiss(false, true);
      setState(() {
        _translateTelephoneEnabledType = 0;
      });
    });
  }

  void requestCurrentLanguage(String q, int currentIndex) {
    ConversionApi.requestCurrentLanguage(q: q, index: currentIndex)
        .then((value) {
      if (value == null) {
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
      for (int i = 0; i < _toDataList.length; i++) {
        if (_toDataList[i].value["value"] == to) {
          _selectedItemToIndex = i;
          break;
        }
      }
      requestTranslateToLanguage(q, from, to, currentIndex);
    });
  }

  void EasyLoadingDismiss(bool threeSecondsTag, bool translateTag) {
    if (threeSecondsTag) {
      _threeSecondsTagFinished = true;
    }
    if (translateTag) {
      _translateFinished = true;
    }
    if (_threeSecondsTagFinished && _translateFinished) {
      EasyLoading.dismiss();
    }
  }

  _translate() async {
    if (!_isExit) {
      _threeSecondsTagFinished = false;
      _translateFinished = false;
      if (!_isLoading) {
        EasyLoading.show();
        _isLoading = true;
      }
      Future.delayed(Duration(seconds: 3), () async {
       // await EasyLoadingDismiss(true, false);
        await EasyLoading.dismiss();
        _isLoading = false;
      });
      int i = _currentIndex;
      int currentIndex = i;
      String q = "";
      // for(int i = 0;i<widget.model.contents.length;i++)
      {
        q = q + _contentControllers[i].text; // widget.model.contents[i];
      }
      if (_selectedItemFromIndex < 0 && _selectedItemToIndex < 0) {
        requestCurrentLanguage(q, currentIndex);
      } else {
        String from = "auto";
        if (_selectedItemFromIndex >= 0) {
          from = _fromDataList[_selectedItemFromIndex].value["value"];
        }
        String to = "zh";
        if (_selectedItemToIndex >= 0) {
          to = _toDataList[_selectedItemToIndex].value["value"];
        }
        to = _toDataList[_selectedItemToIndex].value["value"];
        requestTranslateToLanguage(q, from, to, currentIndex);
      }
    }
  }
}
