
import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';
import 'package:graphic_conversion/data/net/fizz_api.dart';
import 'package:graphic_conversion/model/app_config.dart';
import 'package:graphic_conversion/ui/helper/user_helper.dart';

enum PayType {
  vipPerMonth,
  vipPerSeason,
  vipPerYear,
}

class IOSPayHelper {
  static List<IAPItem> _items = [];

  final VoidCallback onSuccess;

  final VoidCallback onError;

  String packageId;

  static int time = 0;

  static const String vipPerMonthProductId = "vipPerMonth";
  static const String vipPerSeasonProductId = "vipPerSeason";
  static const String vipPerYearProductId = "vipPerYear";

  static StreamSubscription _purchaseUpdatedSubscription;
  static StreamSubscription _purchaseErrorSubscription;
  static StreamSubscription _conectionSubscription;
  static IOSPayHelper _helper;

  IOSPayHelper({this.onSuccess, this.onError});

  static void iosPay({
    @required String productId,
    VoidCallback onSuccess,
    VoidCallback onError,
  }) async {
    EasyLoading.show(status: "正在连接app store");
    await IOSPayHelper.getProduct();
    _helper = IOSPayHelper(onSuccess: onSuccess, onError: onError);
    _helper.requestPurchase(productId);
  }

  static List<String> getProductIdentify() {
    return [vipPerMonthProductId, vipPerSeasonProductId, vipPerYearProductId];
  }

  static clear() {
    if (_helper != null) {
      _helper = null;
    }
  }

  void dispose() async {
    debugPrint("IOSPayHelper-----dispose");
    if (_conectionSubscription != null) {
      _conectionSubscription.cancel();
      _conectionSubscription = null;
    }
    await FlutterInappPurchase.instance.endConnection;
  }

  static Future<List<IAPItem>> getProduct() async {
    var idList = IOSPayHelper.getProductIdentify();
    List<IAPItem> items =
        await FlutterInappPurchase.instance.getProducts(idList);
    debugPrint("内购读取完成" + items.toString());
   _items = items;
   return _items;
  }

  void requestPurchase(String id) {
    debugPrint("开始请求ios内购${id}");
    FlutterInappPurchase.instance.requestPurchase(id);
  }

  static void appPurchaseConnection () async {
    if (_purchaseUpdatedSubscription != null) return;
    if (_helper != null) EasyLoading.show(status: "正在连接app store");
    await FlutterInappPurchase.instance.initConnection;

    /// 连接状态监听
    _conectionSubscription = FlutterInappPurchase.connectionUpdated.listen((connected) {
      debugPrint('连接状态监听');
      if (_helper != null) EasyLoading.dismiss();
    });

    /// appStore购买状态监听
    _purchaseUpdatedSubscription = FlutterInappPurchase.purchaseUpdated.listen((productItem) async {
      debugPrint('appStore购买状态监听---$productItem');
      if (productItem != null) {
        if (_helper != null) {
          EasyLoading.showSuccess("购买成功");
        }
        IOSPayHelper.verifyPaymentResults(productItem);
      }
    });

    /// 错误监听
    _purchaseErrorSubscription = FlutterInappPurchase.purchaseError.listen((purchaseError) async {
      debugPrint('purchase-error: $purchaseError');
//      await FlutterInappPurchase?.instance?.endConnection;

      /// 购买错误回调
      debugPrint('购买失败');
      if (_helper != null) {
        EasyLoading.showError("购买失败");
        _helper.onError();
      }

    });
  }

  static void verifyPaymentResults(PurchasedItem purchasedItem) async {
    if (_helper != null) EasyLoading.show(status: "正在验证付款信息");
    debugPrint('进入了支付成功的回调');
    List<ShowPriceType> showPriceTypes = UserHelper().appConfig.showPriceTypes;
    ShowPriceType showPriceType = showPriceTypes!=null&&showPriceTypes.length>0?showPriceTypes[0]:null;
    String payInfo = purchasedItem.transactionReceipt;
    int packageId = 81;
    if (purchasedItem.productId == vipPerMonthProductId) {
      showPriceType = showPriceTypes!=null&&showPriceTypes.length>0?showPriceTypes[0]:null;
      packageId = 81;
    } else if (purchasedItem.productId == vipPerSeasonProductId) {
      showPriceType = showPriceTypes!=null&&showPriceTypes.length>1?showPriceTypes[1]:null;
      packageId = 82;
    } else if (purchasedItem.productId == vipPerYearProductId) {
      showPriceType = showPriceTypes!=null&&showPriceTypes.length>2?showPriceTypes[2]:null;
      packageId = 83;
    }
    packageId = showPriceType!=null?showPriceType.priceNo:81;

    FIZZApi.requestApplePayValidateReceipt(receipt: payInfo, packageId: packageId).then((value) async {
      if (value != null && value["state"] == "success") {
        debugPrint('开始上传');
        await FlutterInappPurchase.instance.finishTransaction(purchasedItem);
        if (_helper != null) {
          EasyLoading.showSuccess("购买成功");
          _helper.onSuccess();
          _helper = null;
        }
      } else if (value == null || value["state"] == "failed") {
        if (_helper != null) {
          EasyLoading.showError("验证失败");
          _helper.onError();
          _helper = null;
        }
      }
    });
  }

  /// 恢复购买
  static resumePurchase({
    VoidCallback onSuccess,
    VoidCallback onError,
  }) {
    EasyLoading.show(status: "正在恢复购买");
    _helper = IOSPayHelper(onSuccess: onSuccess, onError: onError);
    FlutterInappPurchase.instance.getAvailablePurchases().then((value) {
      if (value != null && value.isNotEmpty) {
        for (int i = 0; i < value.length; i++) {
          if (i == value.length -1) {
            verifyPaymentResults(value[i]);
          } else {
            FlutterInappPurchase.instance.finishTransaction(value[i]);
          }
        }
      } else {
        EasyLoading.showInfo("没有可恢复的购买记录");
      }
    });
  }
}
