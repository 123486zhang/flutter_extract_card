import 'package:date_format/date_format.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graphic_conversion/data/net/fizz_api.dart';
import 'package:graphic_conversion/model/app_config.dart';
import 'package:graphic_conversion/ui/helper/dialog_helper.dart';
import 'package:graphic_conversion/ui/helper/user_helper.dart';
import 'package:graphic_conversion/utils/string_utils.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'package:graphic_conversion/configs.dart';
import 'package:graphic_conversion/model/buried_point_model.dart';
import 'package:graphic_conversion/model/vip_model.dart';
import 'package:graphic_conversion/router/router_config.dart';
import 'package:graphic_conversion/ui/helper/buried_point_helper.dart';
import 'package:graphic_conversion/ui/helper/ios_pay_helper.dart';
import 'package:graphic_conversion/ui/helper/resoure_helper.dart';
import 'package:graphic_conversion/utils/common_utils.dart';
import 'package:graphic_conversion/view_model/user_view_model.dart';

import '../../event/any_event.dart';
import '../../event/event_bus_util.dart';
import '../../locatization/localizations.dart';

class VipApplePage extends StatefulWidget {
  final int from;

  const VipApplePage({Key key, this.from = -1}) : super(key: key);

  @override
  _VipApplePageState createState() => _VipApplePageState();
}

class _VipApplePageState extends State<VipApplePage> {
  List<VipModel> _items = [];

  int _selectIndex = 0;

  int _payType = 0;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    BuriedPointHelper.addBuriedPoint(
      eventType: BuriedPointEventType.PAGE_SHOW,
      pageName: "苹果-会员支付页",
    );

    EasyLoading.show();
    if (UserHelper().appConfig == null
        || UserHelper().appConfig.showPriceTypes == null
        || UserHelper().appConfig.showPriceTypes.isEmpty) {
      FIZZApi.requestStartConfig().then((value) {
        UserHelper().appConfig = value;
        dataProcessing();
      });
    } else {
      dataProcessing();
    }

    UserHelper().userVM.getUserInfo();
  }

  void dataProcessing() async {
    IOSPayHelper.appPurchaseConnection();
    List<IAPItem> iapItems = await IOSPayHelper.getProduct();
    EasyLoading.dismiss();
    for (int i = 0; i < UserHelper().appConfig.showPriceTypes.length; i++) {
      ShowPriceType priceModel = UserHelper().appConfig.showPriceTypes[i];
      VipModel item = VipModel();
      switch (priceModel.displayName) {
        case "包月":
          item.title = "月会员";
          item.productId = IOSPayHelper.vipPerMonthProductId;
          item.price = priceModel.applePrice.toString();
          item.priceSymbol = "¥";
          item.priceNo = priceModel.priceNo;
          break;
        case "包季":
          item.title = "季会员";
          item.productId = IOSPayHelper.vipPerSeasonProductId;
          item.price = priceModel.applePrice.toString();
          item.priceSymbol = "¥";
          item.priceNo = priceModel.priceNo;
          break;
        case "包年":
          item.title = "年会员";
          item.productId = IOSPayHelper.vipPerYearProductId;
          item.price = priceModel.applePrice.toString();
          item.priceSymbol = "¥";
          item.priceNo = priceModel.priceNo;
          break;
      }
      _items.add(item);
    }
    setState(() {
      _items.sort((a, b) {
        if (double.parse(a.price) < double.parse(b.price)) return 0;
        return 1;
      });
      if (iapItems != null) {
        iapItems.forEach((iapItem) {
          _items.forEach((item) {
            if (item.productId == iapItem.productId) {
              item.price = iapItem.price;
              item.priceSymbol = "";
              if (iapItem.currency == "USD") {
                item.priceSymbol = "\$";
              } else if (iapItem.currency == "CNY") {
                item.priceSymbol = "¥";
              }
            }
          });
        });
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    BuriedPointHelper.addBuriedPoint(
      eventType: BuriedPointEventType.PAGE_HIDE,
      pageName: "苹果-会员支付页",
    );
    IOSPayHelper.clear();
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
          backgroundColor: Color(0xFFFFFFFF),
          body: Stack(
            children: [
              Stack(
                children: [
                  Container(
                    width: ScreenUtil().setWidth(375),
                    height: ScreenUtil().setHeight(230),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: ColorHelper.colors_VipTopGradient),
                      // border: Border.all(color: Color(0x33FFFFFF), width: 2),
                    ),
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
                                      margin: EdgeInsets.only(
                                          top: ScreenUtil().setHeight(100)),
                                      width: ScreenUtil().setWidth(375),
                                      height: ScreenUtil().setHeight(35),
                                      decoration: BoxDecoration(
                                        color: Color(0xFFFFFFFF),
                                        // border: Border.all(color: Color(0x33FFFFFF), width: 2),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(
                                          left: ScreenUtil().setWidth(170),
                                          top: ScreenUtil().setHeight(99),
                                          right: ScreenUtil().setWidth(170)),
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
                                        margin: EdgeInsets.only(
                                            left: ScreenUtil().setWidth(15)),
                                        alignment: Alignment.topLeft,
                                        child: TextHelper.TextCreateWith(
                                          text: '套餐选择',
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF555555),
                                        ),
                                      ),
                                      Stack(
                                        children: [
                                          buildVipPrice(),
                                          Positioned(
                                            top: 10,
                                            right: 5,
                                            child: Container(
                                              child: Image.asset(
                                                ImageHelper.imageRes(
                                                    "vip_selected_price.png"),
                                                width:
                                                    ScreenUtil().setWidth(55),
                                                height:
                                                    ScreenUtil().setHeight(20),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
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
                                        margin: EdgeInsets.only(
                                            left: ScreenUtil().setWidth(15)),
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
                alignment: Alignment.topLeft,
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.topLeft,
                      margin: EdgeInsets.only(top: ScreenUtil().setHeight(14)),
                      child: TextHelper.TextCreateWith(
                        text: "提取文字不限次",
                        fontSize: 15,
                        isBlod: true,
                        color: Color(0xFF333333),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: ScreenUtil().setHeight(2)),
                      alignment: Alignment.topLeft,
                      child: TextHelper.TextCreateWith(
                        text: "会员专属权益        ",
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
            height: ScreenUtil().setHeight(15),
          ),

          buildAutoRenewalStatement(),

          SizedBox(
            height: ScreenUtil().setHeight(50),
          ),
        ],
      ),
    );
  }

  Widget buildNavigator() {
    return Stack(
      children: [
        Container(
          height: 50,
          alignment: Alignment.center,
          child: TextHelper.TextCreateWith(
              text: "", fontSize: 18, color: Colors.white, isBlod: true),
        ),
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: _goBack,
          child: Container(
            width: 50,
            height: 50,
            padding: EdgeInsets.only(left: 10),
            alignment: Alignment.centerLeft,
            child: Image.asset(
              ImageHelper.imageRes('vip_navigator_back.png'),
              width: 22,
              height: 22,
            ),
          ),
        ),
        Positioned(
          right: 0,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => IOSPayHelper.resumePurchase(
              onSuccess: _payOnSuccess,
              onError: _payOnError,
            ),
            child: Container(
              height: 50,
              width: 100,
              padding: EdgeInsets.only(right: 15),
              alignment: Alignment.centerRight,
              child: TextHelper.TextCreateWith(
                text: "恢复购买",
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ),
        ),

      ],
    );
  }

  Widget buildTipContent() {
    return Container(
      margin: EdgeInsets.only(
        left: 15,
        right: 15,
      ),
      child: Stack(
        children: [
          Container(
            height: 123,
            child: Image.asset(
              ImageHelper.imageRes('vip_tip_bg.png'),
              fit: BoxFit.fitWidth,
            ),
          ),
          Consumer<UserViewModel>(
            builder: (ctx, userVM, child) {
              return Container(
                height: 102,
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                          child: (userVM != null &&
                                  userVM.hasUser &&
                                  userVM.userModel.userHeader.isNotEmpty)
                              ? ImageHelper.imageCreateWith(
                                  url: userVM.userModel.userHeader,
                                  width: 60,
                                  height: 60,
                                  placeholder: "mine_header_default.png",
                                )
                              : Image.asset(
                                  ImageHelper.imageRes('mine_header.png'),
                                  width: 60,
                                  height: 60,
                                ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Offstage(
                            offstage: !userVM.isVip,
                            child: Image.asset(
                              ImageHelper.imageRes("vip_head_mark.png"),
                              width: 17,
                              height: 17,
                            ),
                          ),
                        )
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            StringUtils.isNull(userVM.userModel.nickName)
                                ? StringUtils.isNull(userVM.userModel.mobile)
                                    ? "${Configs.appName}${userVM.userModel.userId ?? ""}"
                                    : userVM.userModel.mobile
                                : userVM.userModel.nickName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                fontWeight: FontWeight.w600),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          TextHelper.TextCreateWith(
                              text: userVM.isVip
                                  ? userVM.userModel.vipEndTime
                                  : "您暂未开通会员",
                              fontSize: 14,
                              color: Color(0xFF393C56)),
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
      margin: EdgeInsets.only(top: 102),
      child: Stack(
        children: [
          Image.asset(
            ImageHelper.imageRes("vip_shoulder.png"),
            width: 375,
            height: 56,
          ),
          Positioned(
            left: 15,
            bottom: 10,
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
          width: 52,
          height: 52,
        ),
        SizedBox(
          height: 10,
        ),
        TextHelper.TextCreateWith(
            text: "提取文字不限次", fontSize: 16, isBlod: true, color: Colors.black),
      ],
    );
  }

  Widget buildVipPrice() {
    return Container(
      height: ScreenUtil().setHeight(120),
      margin: EdgeInsets.only(
          left: ScreenUtil().setWidth(15),
          right: ScreenUtil().setWidth(15),
          top: ScreenUtil().setHeight(20)),
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
                    text: "${model.priceSymbol} ",
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
                        text: model.price,
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: ScreenUtil().setHeight(5),
                ),
                Container(
                  child: TextHelper.TextCreateWith(
                      text:
                          "${(double.parse(model.price) / (index == 0 ? 30 : index == 1 ? 90 : 365)).toStringAsFixed(2)}/天",
                      fontSize: 15,
                      color: Color(0xFFDABCA7)),
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

  Widget buildAutoRenewalStatement() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextHelper.TextCreateWith(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xFF555555),
              text: "自动续费服务声明"),
          TextHelper.TextCreateWith(
            text:
                "付款：自动续费商品包括“月会员/季会员/年会员”，您确认购买后，会从您的苹果iTunes账户扣费；\n续订会员：将根据您购买的时间每月扣费，苹果会自动为您从iTunes账户扣费，成功后有效期自动延长一个周期；\n取消续订：如需取消续订，请在当前订阅周期到期前24小时以前，手动在iTunes/Apple ID设置管理中关闭自动续费功能，到期前24小时内取消，将会收取订阅费用。",
            color: Color(0x99494949),
            fontSize: 12,
          ),
        ],
      ),
    );
  }

  Widget buildPaymentButton() {
    if (_items.isEmpty) return Container();
    if (_items.isEmpty) return Container();
    var model = _items[_selectIndex];
    return Container(
      margin: EdgeInsets.only(bottom: ScreenUtil().setHeight(20)),
      child: Column(
        children: [
          GestureDetector(
            onTap: _applePayment,
            child: Container(
              margin:
                  EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(15)),
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
                    "${model.price}" +
                    JYLocalizations.localizedString("开通") +
                    JYLocalizations.localizedString(model.title) +
                    JYLocalizations.localizedString("会员"),
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
                  style: TextStyle(fontSize: 13, color: Color(0xFF00C27C)),
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
                TextSpan(
                  text: '和',
                  style: TextStyle(
                      fontSize: 13, color: Color(0xFF333333)),
                ),
                TextSpan(
                  text: '自动续费服务规则',
                  style:
                  TextStyle(fontSize: 13, color: Color(0xFF00C27C)),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () async {
                      if (!await CommonUtils.isNetConnected()) {
                        showToast('请确认网络连接!');
                        return;
                      }
                      Navigator.of(context)
                          .pushNamed(RouteName.webview, arguments: {
                        'title': '自动续费服务规则',
                        'url': Configs.URL_ZDXFXY,
                      });
                    },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  _applePayment() {
    var model = _items[_selectIndex];
    BuriedPointHelper.clickBuriedPoint(
      pageName: "苹果-我的页面-会员中心-开通会员",
      clickName: "${model.price}",
    );
    IOSPayHelper.iosPay(
      productId: model.productId,
      onSuccess: _payOnSuccess,
      onError: _payOnError,
    );
  }

  _payOnSuccess() async {
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
    showToast(JYLocalizations.localizedString("支付失败"));
  }

  _goBack() {
    EasyLoading.dismiss();
    if (UserHelper().userVM.isVip) {
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
