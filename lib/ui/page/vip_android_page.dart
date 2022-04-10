import 'dart:async';
import 'dart:io';

import 'package:data_plugin/bmob/bmob_query.dart';
import 'package:data_plugin/bmob/response/bmob_error.dart';
import 'package:data_plugin/bmob/response/bmob_updated.dart';
import 'package:data_plugin/bmob/table/bmob_user.dart';
import 'package:data_plugin/utils/dialog_util.dart';
import 'package:graphic_conversion/event/any_event.dart';
import 'package:graphic_conversion/event/event_bus_util.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graphic_conversion/data/net/fizz_api.dart';
import 'package:graphic_conversion/locatization/localizations.dart';
import 'package:graphic_conversion/table/free_code.dart';
import 'package:graphic_conversion/table/vip.dart';
import 'package:graphic_conversion/ui/helper/dialog_helper.dart';
import 'package:graphic_conversion/utils/string_utils.dart';
import 'package:graphic_conversion/view_model/bmob_user_view_model.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'package:graphic_conversion/channel/android_method_channel.dart';
import 'package:graphic_conversion/configs.dart';
import 'package:graphic_conversion/model/app_config.dart';
import 'package:graphic_conversion/model/buried_point_model.dart';
import 'package:graphic_conversion/model/vip_model.dart';
import 'package:graphic_conversion/router/router_config.dart';
import 'package:graphic_conversion/ui/helper/buried_point_helper.dart';
import 'package:graphic_conversion/ui/helper/ios_pay_helper.dart';
import 'package:graphic_conversion/ui/helper/resoure_helper.dart';
import 'package:graphic_conversion/ui/helper/user_helper.dart';
import 'package:graphic_conversion/utils/common_utils.dart';
import 'package:graphic_conversion/view_model/user_view_model.dart';

class VipAndroidPage extends StatefulWidget {

  final int from;

  const VipAndroidPage({Key key, this.from = -1}) : super(key: key);


  @override
  _VipAndroidPageState createState() => _VipAndroidPageState();
}

class _VipAndroidPageState extends State<VipAndroidPage> {
  List<VipModel> _items = [];
  List<FreeCode> codes = [];

  int _selectIndex = 2;

  int _payType = 0;

  List<Vip> vipModels;

  TextEditingController _controller ;
  bool _textState = false;

  List<String> headImages = [
    'head1.png',
    'head2.png',
    'head3.png',
    'head4.png',
    'head5.png',
    'head6.png',
    'head7.png',
    'head8.png',
    'head9.png',
    'head10.png',
    'head11.png',
    'head12.png',
    'head13.png',
    'head14.png',
    'head15.png',
    'head16.png',
    'head17.png',
    'head18.png',
    'ic_img1.png',
    'ic_img2.png',
    'ic_img3.png',
    'ic_img4.png',
    'ic_img5.png',
    'ic_img6.png',
    'ic_img7.png',
    'ic_img8.png',
    'ic_img9.png',
    'ic_img10.png',
    'ic_img11.png',
    'ic_img12.png'
  ];

  List<String> backImages = [
    'img_1.png',
    'img_2.png',
    'img_3.png',
    'img_4.png',
    'img_5.png',
    'img_6.png',
    'img_7.png',
    'img_8.png',
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    BuriedPointHelper.addBuriedPoint(
      eventType: BuriedPointEventType.PAGE_SHOW,
      pageName: "安卓-会员支付页",
    );

    // if (UserHelper().appConfig == null ||
    //     UserHelper().appConfig.showPriceTypes == null ||
    //     UserHelper().appConfig.showPriceTypes.isEmpty) {
    //   EasyLoading.show();
    //   FIZZApi.requestStartConfig().then((value) {
    //     UserHelper().appConfig = value;
    //     EasyLoading.dismiss();
    //     dataProcessing();
    //   });
    // } else {
    //   dataProcessing();
    // }

   // UserHelper().userVM.getUserInfo();
    _controller = TextEditingController();
    _addTextListener();  //监听输入变化
    dataProcessing();
  }

  _addTextListener() {
    _controller.addListener(() {
      setState(() {});
      if (_controller.text.length >0) {
        _textState = true;
      } else {
        _textState = false;
      }
    });
    return _textState;
  }

  Future<void> dataProcessing() async {
    BmobQuery<Vip> query = new BmobQuery<Vip>();
    await query.queryObjects().then((data) {vipModels = data.map((i) => Vip.fromJson(i)).toList();
    }).catchError((e) {
      showToast('网络错误！');
    });

    for (int i = 0; i < vipModels.length; i++) {
      Vip priceModel=vipModels[i];
      VipModel item = VipModel();
      switch (priceModel.title) {
        case "包周":
          item.title = JYLocalizations.localizedString("1周");
          item.wechatPrice = priceModel.wechatPrice.toString();
          item.wechatAveragePrice = priceModel.wechatAveragePrice.toString();
          item.alipayPrice = priceModel.alipayPrice.toString();
          item.alipayAveragePrice = priceModel.alipayAveragePrice.toString();
          item.showAveragePrice = true;
          item.priceNo = priceModel.priceNo;
          break;
        case "包月":
          item.title = JYLocalizations.localizedString("1个月");
          item.wechatPrice = priceModel.wechatPrice.toString();
          item.wechatAveragePrice = priceModel.wechatAveragePrice.toString();
          item.alipayPrice = priceModel.alipayPrice.toString();
          item.alipayAveragePrice = priceModel.alipayAveragePrice.toString();
          item.showAveragePrice = false;
          item.priceNo = priceModel.priceNo;
          break;
        case "包季":
          item.title = "3个月";
          item.wechatPrice = priceModel.wechatPrice.toString();
          item.wechatAveragePrice = priceModel.wechatAveragePrice.toString();
          item.alipayPrice = priceModel.alipayPrice.toString();
          item.alipayAveragePrice = priceModel.alipayAveragePrice.toString();
          item.showAveragePrice = true;
          item.priceNo = priceModel.priceNo;
          break;
        case "包年":
          item.title = "1年";
          item.wechatPrice = priceModel.wechatPrice.toString();
          item.wechatAveragePrice = priceModel.wechatAveragePrice.toString();
          item.alipayPrice = priceModel.alipayPrice.toString();
          item.alipayAveragePrice = priceModel.alipayAveragePrice.toString();
          item.showAveragePrice = true;
          item.priceNo = priceModel.priceNo;
          break;
      }
      _items.add(item);
    }
    setState(() {
      _items.sort((a, b) {
        if (double.parse(a.wechatPrice) < double.parse(b.wechatPrice)) return 0;
        return 1;
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    BuriedPointHelper.addBuriedPoint(
      eventType: BuriedPointEventType.PAGE_HIDE,
      pageName: "安卓-会员支付页",
    );
    if (_controller != null) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return _goBack();
      },
      child: AnnotatedRegion(
        value: SystemUiOverlayStyle.light,
        child: Scaffold(
            resizeToAvoidBottomInset:false,
          backgroundColor: Color(0xFFFFFFFF),
          body: Stack(
            children: [
              Stack(
                children: [
                  Container(
                    width: ScreenUtil().setWidth(375),
                    height: ScreenUtil().setHeight(230),
                    child: UserHelper().bmobUserVM.hasUser &&
                        UserHelper().bmobUserVM.bmobUserModel.backId !=
                            -1
                        ? Image.asset(
                      ImageHelper.imageRes(backImages[UserHelper()
                          .bmobUserVM
                          .bmobUserModel
                          .backId]),
                      fit: BoxFit.fill,
                      width: ScreenUtil().setWidth(375),
                      height: ScreenUtil().setHeight(268),
                    )
                        : Image.asset(
                      ImageHelper.imageRes("home_top_bg1.png"),
                      width: ScreenUtil().setWidth(375),
                      height: ScreenUtil().setHeight(268),
                      fit: BoxFit.fill,
                    ),
                    // decoration: BoxDecoration(
                    //   gradient: LinearGradient(
                    //       begin: Alignment.topCenter,
                    //       end: Alignment.bottomCenter,
                    //       colors: ColorHelper.colors_VipTopGradient),
                    //   // border: Border.all(color: Color(0x33FFFFFF), width: 2),
                    // ),
                  ),
                ],
              ),
              SafeArea(
                child: Stack(
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        buildNavigator(),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                SizedBox(
                                  height: ScreenUtil().setHeight(20),
                                ),
                                Stack(
                                  children: [
                                   buildTipContent(),
                                    Container(
                                      margin: EdgeInsets.only(top: ScreenUtil().setHeight(100)),
                                      width: ScreenUtil().setWidth(375),
                                      height: ScreenUtil().setHeight(35),
                                      decoration: BoxDecoration(
                                        color: Color(0xFFFFFFFF),
                                        // border: Border.all(color: Color(0x33FFFFFF), width: 2),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(left: ScreenUtil().setWidth(170),top: ScreenUtil().setHeight(99),right: ScreenUtil().setWidth(170)),
                                      child: Image.asset(
                                        ImageHelper.imageRes(
                                            'icons_vip_bottom.png'),
                                        width: ScreenUtil().setWidth(35),
                                        height: ScreenUtil().setHeight(35),
                                      ),
                                    ),
                                    //  buildShoulder(),
                                  ],
                                ),
                                Container(
                                  alignment: Alignment.topLeft,
                                  color: Colors.white,
                                  child: Column(
                                    children: [

                                      Container(
                                        margin: EdgeInsets.only(left: ScreenUtil().setWidth(15)),
                                        alignment: Alignment.topLeft,
                                        child: TextHelper.TextCreateWith(
                                          text: '套餐选择',
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF555555),
                                        ),
                                      ),
                                      Stack(children: [
                                        buildVipPrice(),
                                        Positioned(
                                          top: 10,
                                          right: 5,
                                          child:Container(
                                            child: Image.asset(
                                              ImageHelper.imageRes("vip_selected_price.png"),
                                              width: ScreenUtil().setWidth(55),
                                              height: ScreenUtil().setHeight(20),
                                            ),
                                          ),
                                        ),
                                      ],),
                                      //  buildVipIcon(),
                                      //  SizedBox(height: 30,),
                                      SizedBox(
                                        height: ScreenUtil().setHeight(20),
                                      ),
                                      Container(
                                        width: ScreenUtil().setWidth(375),
                                        height: ScreenUtil().setHeight(5),
                                        decoration: BoxDecoration(
                                          color: Color(0xFFF9F9F9),
                                          // border: Border.all(color: Color(0x33FFFFFF), width: 2),
                                        ),
                                      ),
                                      SizedBox(
                                        height: ScreenUtil().setHeight(20),
                                      ),

                                      Container(
                                        margin: EdgeInsets.only(left: ScreenUtil().setWidth(15)),
                                        alignment: Alignment.topLeft,
                                        child: TextHelper.TextCreateWith(
                                          text: '会员专属权益',
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF555555),
                                        ),
                                      ),

                                      buildPaymentType(),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        buildPaymentButton(),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildNavigator() {
    return Stack(
      children: [
        Container(
          height: ScreenUtil().setHeight(56),
          alignment: Alignment.center,
        ),
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: _goBack,
          child: Container(
            width: ScreenUtil().setWidth(56),
            height: ScreenUtil().setHeight(56),
            padding: EdgeInsets.only(left: ScreenUtil().setWidth(15),top: ScreenUtil().setHeight(28)),
            alignment: Alignment.centerLeft,
            child: Image.asset(
              ImageHelper.imageRes('vip_navigator_back.png'),
              width: ScreenUtil().setWidth(22),
              height: ScreenUtil().setHeight(22),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildTipContent() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(16)),
      child: Stack(
        children: [
          Container(
            height: ScreenUtil().setHeight(101),
            width: ScreenUtil().setWidth(375),
            child: Image.asset(
              ImageHelper.imageRes('vip_tip_bg.png'),
              fit: BoxFit.fill,
            ),
          ),
          Consumer<BmobUserViewModel>(
            builder: (ctx, userVM, child) {
              return Container(
                height: ScreenUtil().setHeight(101),
                alignment: Alignment.topLeft,
                padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(20)),
                child: Row(
                  children: [
                    Stack(
                      children: [
                        // ClipRRect(
                        //   borderRadius: BorderRadius.all(Radius.circular(30)),
                        //   child: ImageHelper.imageCreateWith(
                        //     url: userVM.userModel.userHeader,
                        //     width: ScreenUtil().setWidth(50),
                        //     height: ScreenUtil().setHeight(50),
                        //     placeholder: "mine_header_default.png",
                        //   ),
                        // ),
                        Container(
                          width: ScreenUtil().setWidth(60),
                          height: ScreenUtil().setHeight(60),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                            // border: userVM.hasUser
                            //     ? Border.all(color: Color(0xFFFFFFFF), width: 1)
                            //     : Border.all(color: Color(0xFFFFFFFF), width: 0)
                            // border: Border.all(color: Color(0x33FFFFFF), width: 2),
                          ),
                          child: ClipOval(
                            child: userVM.hasUser && userVM.bmobUserModel.headId != -1
                                ? Image.asset(
                              ImageHelper.imageRes(
                                  headImages[userVM.bmobUserModel.headId]),
                              fit: BoxFit.fill,
                              width: ScreenUtil().setWidth(60),
                              height: ScreenUtil().setHeight(60),
                            )
                                : Image.asset(
                                ImageHelper.imageRes('mine_header_default.png')),
                          ),
                        ),
                        // Positioned(
                        //   bottom: 0,
                        //   right: 0,
                        //   child: Offstage(
                        //     offstage: !userVM.isVip,
                        //     child: Image.asset(
                        //       ImageHelper.imageRes("vip_head_mark.png"),
                        //       width: 17,
                        //       height: 17,
                        //     ),
                        //   ),
                        // )
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.only(left: ScreenUtil().setWidth(15)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextHelper.TextCreateWith(
                            text: userVM.bmobUserModel.username,
                            fontSize: 17,
                            color: Color(0xFF512C19),
                            isBlod: true,
                          ),
                          SizedBox(
                            height: ScreenUtil().setHeight(5),
                          ),
                          TextHelper.TextCreateWith(
                            text: userVM.hasUser && !userVM.isExpire
                                ? '您的会员${userVM.vipEndAt.substring(0,10)}到期'
                                : '立即开通 · VIP会员',
                            fontSize: 15,
                            color: Color(0xFF512C19),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              );
            },
          )
        ],
      ),
    );
  }

  Widget buildShoulder() {
    return Container(
      margin: EdgeInsets.only(top: ScreenUtil().setHeight(100)),
      child: Stack(
        children: [
          Image.asset(
            ImageHelper.imageRes("vip_shoulder.png"),
            width: ScreenUtil().setWidth(375),
            height: ScreenUtil().setHeight(56),
          ),
          Positioned(
            left: ScreenUtil().setWidth(15),
            bottom: ScreenUtil().setHeight(10),
            child: TextHelper.TextCreateWith(
              text: "会员特权",
              fontSize: 18,
              isBlod: true,
            ),
          )
        ],
      ),
    );
  }

  Widget buildVipIcon() {
    return Column(
      children: [
        Image.asset(
          ImageHelper.imageRes("vip_tip.png"),
          width: ScreenUtil().setWidth(52),
          height: ScreenUtil().setHeight(52),
        ),
        SizedBox(
          height: ScreenUtil().setHeight(10),
        ),
        TextHelper.TextCreateWith(
            text: "提取文字不限次", fontSize: 16, isBlod: true, color: Colors.black),
      ],
    );
  }

  Widget buildVipPrice() {
    return Container(
      height: ScreenUtil().setHeight(120),
      margin: EdgeInsets.only(left: ScreenUtil().setWidth(15),right:ScreenUtil().setWidth(15),top: ScreenUtil().setHeight(20) ),
      child: GridView.builder(
        padding: EdgeInsets.zero,
        primary: false,
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 110 / 134,
          crossAxisSpacing: 8,
        ),
        itemCount: _items.length,
        itemBuilder: (ctx, index) {
          return buildVipPriceItem(index);
        },
      ),
    );
  }

  Widget buildVipPriceItem(int index) {
    var model = _items[index];
    bool isSelected = index == _selectIndex;
    Color textColor = isSelected ? Color(0xFF512C19) : Color(0xFF512C19);
    Color priceColor = Color(0xFFFF4F4D);
    Color rawPriceColor = Color(0xFFDABCA7);
    Color detailColor = isSelected ? Color(0x99512F1D) : Color(0x99FEEAB5);
    Color borderColor = isSelected ? Color(0x99376DF7) : Color(0x99C5C5C5);
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectIndex = index;
        });
      },
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          Container(
            width: ScreenUtil().setWidth(100),
            height: ScreenUtil().setHeight(120),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                color: isSelected ? Color(0xFFFDF8EE) : Color(0xFFF9F9F9),
                border: Border.all(
                    color: isSelected ? Color(0xFFDEB876) : Color(0xFFE6E6E6),
                    width: isSelected ? 2 : 1)),
            child: Column(
              children: [
                SizedBox(
                  height: ScreenUtil().setHeight(15),
                ),
                TextHelper.TextCreateWith(
                    text: model.title,
                    fontSize: 17,
                    isBlod: true,
                    color: textColor),
                SizedBox(
                  height: ScreenUtil().setHeight(10),
                ),
                RichText(
                  text: TextSpan(
                    text: "¥ ",
                    style: TextStyle(
                        color: priceColor,
                        fontSize: 17,
                        fontWeight: FontWeight.bold),
                    children: [
                      TextSpan(
                        style: TextStyle(
                            color: priceColor,
                            fontSize: 26,
                            fontWeight: FontWeight.bold),
                        text: _payType == 0
                            ? model.wechatPrice
                            : model.alipayPrice,
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: ScreenUtil().setHeight(5),
                ),
                Container(
                  child: TextHelper.TextCreateWith(
                      text: "${(double.parse(model.wechatPrice)/(index==0?30:index==1?90:365)).toStringAsFixed(2)}/天", fontSize: 15, color: Color(0xFFDABCA7)),
                ),
                // Offstage(
                //   offstage: true,
                //   child: RichText(
                //     text: TextSpan(
                //       text: "¥ ",
                //       style: TextStyle(
                //           color: priceColor,
                //           fontSize: 9,
                //           fontWeight: FontWeight.bold),
                //       children: [
                //         TextSpan(
                //           style: TextStyle(
                //               color: priceColor,
                //               fontSize: 12,
                //               fontWeight: FontWeight.normal),
                //           text:
                //               "${_payType == 0 ? model.wechatAveragePrice : model.alipayAveragePrice}/月",
                //         )
                //       ],
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
          // Positioned(
          //   top: -1,
          //   right: 0,
          //   child: index==2?Container(
          //     child: Image.asset(
          //       ImageHelper.imageRes("vip_selected_price.png"),
          //       width: ScreenUtil().setWidth(55),
          //       height: ScreenUtil().setHeight(20),
          //     ),
          //   ):Container(),
          // ),
        ],
      ),
    );
  }

  Widget buildPaymentType() {
    return Container(
      alignment: Alignment.topLeft,
      margin: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(15)),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                margin: EdgeInsets.only(top: ScreenUtil().setHeight(15)),
                child: Image.asset(
                  ImageHelper.imageRes("icon_items.png"),
                  width: ScreenUtil().setWidth(50),
                  height: ScreenUtil().setHeight(50),
                ),
              ),
              SizedBox(
                width: ScreenUtil().setWidth(15),
              ),
              Container(
                alignment: Alignment.center,
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: ScreenUtil().setHeight(14)),
                      child: TextHelper.TextCreateWith(
                        text: "使用所有功能          ",
                        fontSize: 15,
                        isBlod: true,
                        color: Color(0xFF333333),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: ScreenUtil().setHeight(2)),
                      child: TextHelper.TextCreateWith(
                        text: "每日签到赠送500代币",
                        fontSize: 13,
                        color: Color(0xFFC29647),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // TextHelper.TextCreateWith(
          //   text: "选择您的支付方式",
          //   fontSize: 16,
          //   isBlod: true,
          // ),
          SizedBox(
            height: ScreenUtil().setHeight(30),
          ),

          Container(
            alignment: Alignment.topLeft,
            child: TextHelper.TextCreateWith(
              text: "选择您的支付方式",
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xFF555555),
            ),
          ),


          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(children: [
                Container(
                  width: ScreenUtil().setWidth(296),
                  height: ScreenUtil().setHeight(45),
                  margin: EdgeInsets.only(top: 30),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                        color: _textState?Color(0xfff0cc8b):Color(0xffffe9bc), width: 0.8),
                  ),
                  child: TextField(
                    controller: _controller,
                    maxLines: 1,
                    inputFormatters: [
                      if (Platform.isAndroid)
                        LengthLimitingTextInputFormatter(8),
                      FilteringTextInputFormatter.allow(
                          RegExp('[0-9a-zA-Z]')),
                    ],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                      hintText: '请输入免费码',
                      hintStyle: TextStyle(fontSize: 16),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child:        Container(
                        child: Image.asset(
                          ImageHelper.imageRes(_textState
                              ? 'ic_checkbox_selected.png'
                              : 'ic_checkbox_disable.png'),
                          width: ScreenUtil().setWidth(20),
                          height: ScreenUtil().setHeight(20),
                        ),
                      ),)
              ],),

            // GestureDetector(
            //   behavior: HitTestBehavior.opaque,
            //   onTap: () {
            //     setState(() {
            //       _payType = 0;
            //     });
            //   },
            //   child: Stack(
            //     children: [
            //       Container(
            //         margin: EdgeInsets.only(top: ScreenUtil().setHeight(15)),
            //         width: ScreenUtil().setWidth(165),
            //         height: ScreenUtil().setHeight(55),
            //         decoration: BoxDecoration(
            //           borderRadius: BorderRadius.all(Radius.circular(10)),
            //           color: Color(0xFFFFFFFF),
            //           border: Border.all(color: Color(0xFFE6E6E6), width: ScreenUtil().setWidth(1)),
            //         ),
            //       ),
            //       Container(
            //         margin: EdgeInsets.only(top: ScreenUtil().setHeight(30), left: ScreenUtil().setWidth(22)),
            //         child: Image.asset(
            //           ImageHelper.imageRes("vip_wechat.png"),
            //           width: ScreenUtil().setWidth(25),
            //           height: ScreenUtil().setHeight(25),
            //         ),
            //       ),
            //       Container(
            //         alignment: Alignment.topLeft,
            //         margin: EdgeInsets.only(top: ScreenUtil().setHeight(30), left: ScreenUtil().setWidth(54)),
            //         child: TextHelper.TextCreateWith(
            //           text: "微信支付",
            //           fontSize: 15,
            //           color: Color(0xFF333333),
            //         ),
            //       ),
            //       // if(_payType==0)
            //       // Container(
            //       //   margin: EdgeInsets.only(top: ScreenUtil().setHeight(15), left: ScreenUtil().setWidth(125)),
            //       //   child: Image.asset(
            //       //     ImageHelper.imageRes("icon_discount.png"),
            //       //     width: ScreenUtil().setWidth(40),
            //       //     height: ScreenUtil().setHeight(15),
            //       //   ),
            //       // ),
            //       Container(
            //         margin: EdgeInsets.only(top: ScreenUtil().setHeight(50), left: ScreenUtil().setWidth(145)),
            //         child: Image.asset(
            //           ImageHelper.imageRes(_payType == 0
            //               ? 'ic_checkbox_selected.png'
            //               : 'ic_checkbox_disable.png'),
            //           width: ScreenUtil().setWidth(20),
            //           height: ScreenUtil().setHeight(20),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            // GestureDetector(
            //   behavior: HitTestBehavior.opaque,
            //   onTap: () {
            //     setState(() {
            //       _payType = 1;
            //     });
            //   },
            //   child: Stack(
            //     children: [
            //       Container(
            //         margin: EdgeInsets.only(top: ScreenUtil().setHeight(15), left: ScreenUtil().setWidth(15)),
            //         width: ScreenUtil().setWidth(165),
            //         height: ScreenUtil().setHeight(55),
            //         decoration: BoxDecoration(
            //           borderRadius: BorderRadius.all(Radius.circular(10)),
            //           color: Color(0xFFFFFFFF),
            //           border: Border.all(color: Color(0xFFE6E6E6), width: ScreenUtil().setWidth(1)),
            //         ),
            //       ),
            //       Container(
            //         margin: EdgeInsets.only(top: ScreenUtil().setHeight(30), left: ScreenUtil().setWidth(37)),
            //         child: Image.asset(
            //           ImageHelper.imageRes("vip_alipay.png"),
            //           width: ScreenUtil().setWidth(25),
            //           height: ScreenUtil().setHeight(25),
            //         ),
            //       ),
            //       Container(
            //         alignment: Alignment.topLeft,
            //         margin: EdgeInsets.only(top: ScreenUtil().setHeight(30), left: ScreenUtil().setWidth(69)),
            //         child: TextHelper.TextCreateWith(
            //           text: "支付宝支付",
            //           fontSize: 15,
            //           color: Color(0xFF333333),
            //         ),
            //       ),
            //       // if(_payType==1)
            //       // Container(
            //       //   margin: EdgeInsets.only(top: ScreenUtil().setHeight(15), left: ScreenUtil().setWidth(140)),
            //       //   child: Image.asset(
            //       //     ImageHelper.imageRes("icon_discount.png"),
            //       //     width: ScreenUtil().setWidth(40),
            //       //     height: ScreenUtil().setHeight(15),
            //       //   ),
            //       // ),
            //       Container(
            //         margin: EdgeInsets.only(top: ScreenUtil().setHeight(50), left: ScreenUtil().setWidth(160)),
            //         child: Image.asset(
            //           ImageHelper.imageRes(_payType == 1
            //               ? 'ic_checkbox_selected.png'
            //               : 'ic_checkbox_disable.png'),
            //           width: ScreenUtil().setWidth(20),
            //           height: ScreenUtil().setHeight(20),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
          ],),

        ],
      ),
    );
  }

  Widget buildPaymentButton() {
    if (_items.isEmpty) return Container();  if (_items.isEmpty) return Container();
    var model = _items[_selectIndex];
    return Container(
      margin: EdgeInsets.only(bottom: ScreenUtil().setHeight(20)),
      child: Column(
        children: [
          GestureDetector(
            onTap: _applePayment,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(15)),
              height: ScreenUtil().setHeight(50),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: ColorHelper.colors_VipBtnGradient),
                  borderRadius: BorderRadius.all(Radius.circular(55))),
              child: TextHelper.TextCreateWith(
                text: JYLocalizations.localizedString("支付") +
                    "${_payType == 0 ? model.wechatPrice : model.alipayPrice}" +
                    JYLocalizations.localizedString("开通") +
                    JYLocalizations.localizedString(model.title)+  JYLocalizations.localizedString("会员") ,
                fontSize: 17,
                color: Color(0xFF512C19),
              ),
            ),
          ),
          SizedBox(
            height: ScreenUtil().setHeight(10),
          ),
          Text.rich(
            TextSpan(
              text: JYLocalizations.localizedString('开通会员默认您已同意'),
              style: TextStyle(fontSize: 13, color: Color(0xFF333333)),
              children: <TextSpan>[
                TextSpan(
                  text: JYLocalizations.localizedString('会员用户协议'),
                  style: TextStyle(fontSize: 13, color: Color(0xfff0cc8b)),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () async {
                      if (!await CommonUtils.isNetConnected()) {
                        showToast('请确认网络连接!');
                        return;
                      }
                      Navigator.of(context)
                          .pushNamed(RouteName.webview, arguments: {
                        'title': '用户协议',
                        'url': Configs.URL_YHXY,
                      });
                    },
                ),
                // TextSpan(
                //   text: '和',
                //   style: TextStyle(
                //       fontSize: 13, color: Color(0xFF333333)),
                // ),
                // TextSpan(
                //   text: '自动续费服务规则',
                //   style:
                //   TextStyle(fontSize: 13, color: Color(0xFF00C27C)),
                //   recognizer: TapGestureRecognizer()
                //     ..onTap = () async {
                //       if (!await CommonUtils.isNetConnected()) {
                //         showToast('请确认网络连接!');
                //         return;
                //       }
                //       Navigator.of(context)
                //           .pushNamed(RouteName.webview, arguments: {
                //         'title': '自动续费服务规则',
                //         'url': Configs.URL_ZDXFXY,
                //       });
                //     },
                // ),
              ],
            ),
          )
        ],
      ),
    );
  }

  _applePayment() async {
    var model = _items[_selectIndex];
    var vipDays;
    var payType = _payType == 0 ? "微信支付" : "支付宝支付";
    var price = _payType == 0 ? model.wechatPrice : model.alipayPrice;
    BmobUser local = UserHelper().bmobUserVM.bmobUserModel;

    var vipEndAt;
    if(local.isVip){
      vipEndAt=DateTime.parse(local.vipEndAt);
    }else{
      vipEndAt=DateTime.now();
    }

    if(_selectIndex==0){
      vipEndAt=vipEndAt.add(new Duration(days: 30));
      vipDays=30;
    }else if(_selectIndex==1){
      vipEndAt=vipEndAt.add(new Duration(days: 90));
      vipDays=90;
    }else if(_selectIndex==2){
      vipEndAt=vipEndAt.add(new Duration(days: 365));
      vipDays=365;
    }

    BuriedPointHelper.clickBuriedPoint(
      pageName: "安卓-我的页面-会员中心-开通会员",
      clickName: "$payType-$price",
    );



    if(_controller.text.length<=0){
      showToast('免费码不能为空');
      return;
    }

    print("wechat info=>${_payType }");
    int stype = model.priceNo;

    String code = _controller.text;
    if (code.length > 8) {
      showToast('免费码不能超过8位');
      return;
    }

    BmobQuery<FreeCode> bmobQuery = BmobQuery();
    bmobQuery.addWhereEqualTo("code", code);
    bmobQuery.queryObjects().then((data) {
      List<FreeCode> codes = data.map((i) => FreeCode().fromJsons(i)).toList();
      if(codes==null ||codes.length==0) {
        showToast('免费码不存在');
        return;
      }
      for (FreeCode freeCode in codes) {
        if (!freeCode.isUse) {
          if(freeCode.coins!=vipDays){
            showToast('免费码类型不合法');
            return;
          }

          int coninsRaw=local.coins;
          int coins=freeCode.coins*10+coninsRaw;
          local.coins=coins;

          if(local.isVip&&DateTime.parse(local.vipEndAt).year>2050){
            _payOnError();
          }else{
            local.isVip=true;
            local.vipEndAt=vipEndAt.toString().substring(0,19);
            local.update().then((BmobUpdated bmobUpdated) {
              UserHelper().bmobUserVM.bmobUserModel = local;
              EventBusUtil.getInstance().fire(AnyEvent(AnyEvent.REFRESH_PHONE));
              _payOnSuccess();
            }).catchError((e) {
              showToast('网络错误');
            });
          }

          FreeCode myCode=freeCode;
          myCode.isUse=true;
          myCode.user=local;

          myCode.update().then((BmobUpdated bmobUpdated) {
          }).catchError((e) {
            showError(context, BmobError.convert(e).error);
          });
        }else{
          showToast('已被使用');
        }
      }
    }).catchError((e) {
      showToast('网络错误');
    });




    // if (_payType == 0) {
    //   UserViewModel userVM = Provider.of<UserViewModel>(context, listen: false);
    //   String beforeTime = userVM.userModel.vipEndTime;
    //
    //   ///VIP结束时间
    //
    //   // print("==>微信支付之前vip时间：$beforeTime");
    //
    //   _wechatPayStateTimer =
    //   new Timer.periodic(new Duration(milliseconds: 1000), (timer) {
    //     setState(() {
    //       FIZZApi.requestGetUserInfo().then((value) {
    //         if (value == null) return;
    //         var model = userVM.userModel;
    //         model.vipType = CommonUtils.noNull(value["vipType"].toString());
    //         model.vipEndTime = CommonUtils.noNull(value["vipEndTime"]);
    //         model.mobile = CommonUtils.noNull(value["mobile"]);
    //         userVM.userModel = model;
    //
    //         //  print("==>微信支付之后vip时间：${model.vipEndTime}");
    //
    //         //刷新
    //         if (beforeTime != model.vipEndTime) {
    //           if(widget.from==1){
    //             EventBusUtil.getInstance().fire(AnyEvent(AnyEvent.REFRESH_VIP));
    //             Navigator.of(context).pop();
    //             _wechatPayStateTimer?.cancel();
    //           }else{
    //             EasyLoading.show();
    //             Future.delayed(Duration(seconds: 2), () async {
    //               EasyLoading.dismiss();
    //               setState(() {
    //                 Navigator.of(context).pop();
    //                 showToast(JYLocalizations.localizedString("开通会员成功"));
    //                 _wechatPayStateTimer?.cancel();
    //               });
    //             });
    //           }
    //         }
    //       });
    //     });
    //   });
    // }

    // var result = await AndroidMethodChannel.pay(
    //   payType: _payType == 0 ? 1 : 0,
    //   stype: stype,
    //   userId: UserHelper().userVM.userModel.userId,
    //   md5: UserHelper().userVM.userModel.Authorization,
    // );
    // debugPrint(
    //     "安卓支付 ---- result = $result, uid = ${UserHelper().userVM.userModel.userId}");
    // if (result) {
    //   _payOnSuccess();
    // } else {
    //   _payOnError();
    // }
  }

  _payOnSuccess() {
    EasyLoading.show();
    Future.delayed(Duration(seconds: 2), () async {
      await UserHelper().userVM.getUserInfo();
      EasyLoading.dismiss();
      Navigator.of(context).pop();
      showToast(JYLocalizations.localizedString("开通会员成功"));
      EventBusUtil.getInstance().fire(AnyEvent(AnyEvent.REFRESH_VIP));
    });
  }

  _payOnError() {
    showToast(JYLocalizations.localizedString("超过最大期限"));
  }

  _getCodes() async {
    BmobQuery<FreeCode> query = new BmobQuery<FreeCode>();
    await query.queryObjects().then((data) {
      List<FreeCode> freeCodes = data.map((i) => FreeCode().fromJsons(i)).toList();
      codes.clear();
      codes.addAll(freeCodes);
      if(mounted) {
        setState(() {
        });
      }
    }).catchError((e) {
      showToast("网络错误");
    });
  }

  _goBack() {
    EasyLoading.dismiss();
    if (UserHelper().bmobUserVM.bmobUserModel.isVip) {
      Navigator.of(context).pop();
      return;
    }
    DialogHelper.showVipRetainDialog(context).then((value) {
      if (value) {
        Navigator.of(context).pop();
      }
    });
  }
}
