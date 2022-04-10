
import 'dart:convert';

import 'package:graphic_conversion/data/net/base_api.dart';
import 'package:dio/dio.dart';
import 'package:oktoast/oktoast.dart';
import 'package:graphic_conversion/configs.dart';
import 'package:graphic_conversion/data/net/logInterceptor.dart';
import 'package:graphic_conversion/model/buried_point_model.dart';
import 'package:graphic_conversion/ui/helper/buried_point_helper.dart';
import 'package:graphic_conversion/ui/helper/user_helper.dart';
import 'package:graphic_conversion/utils/common_utils.dart';
import 'package:graphic_conversion/utils/string_utils.dart';

class BuriedPointApi {

  /// 启动接口
  static const String JY_AppStart = "/free/start/cnewurl";

  /// 埋点
  static const String JY_BuriedPoint = "/free/action/handlenew";

  static Future post({
    String operate,
    String code = "fizz",
    dynamic data,
  }) async {
    return BaseApi.post(operate: operate, code: code, data: data, showErrorMessage: false);
  }

  /// 启动接口
  static Future requestAppStart() async {
    Map<String, dynamic> data = {};
    try {
      var response = await BuriedPointApi.post(
        operate: JY_AppStart,
        data: data,
      );
      return response;
    } catch (e) {}
    return null;
  }

  /// 上传公共参数
  static Future requestCommonParams() async {
    Map<String, dynamic> data = {
      "type": 0,
      "smid": Configs.deviceId,
      "channelId": Configs.channelId,
      "productId": Configs.PRODUCT_ID,
      "appVer": Configs.versionCode,
      "createdAt": DateTime.now().toString(),
      "systemVer": "",
      "wxVer": "",
      "phoneModel": "",
      "brand": "",
      "networkType": "",
      "userCode": UserHelper().userVM.hasUser ? UserHelper().userVM.userModel.userCode : "",
      "userId": UserHelper().userVM.hasUser ? UserHelper().userVM.userModel.userCode : "",
    };
    try {
      var response = await BuriedPointApi.post(
        operate: StringUtils.isNull(BuriedPointHelper.buriedPointUrl)?JY_BuriedPoint:BuriedPointHelper.buriedPointUrl,
        data: [data],
      );
      return response;
    } catch (e) {}
    return null;
  }

  static Future<bool> requestUploadBuriedPoint(List<BuriedPointModel> buriedPointDataList) async {
    List dataList = [];
    buriedPointDataList.forEach((model) {
      Map<String, dynamic> data = {
        "type": 1,
        "smid": Configs.deviceId,
        "userId": UserHelper().userVM.hasUser ? UserHelper().userVM.userModel.userCode : "",
        "channelId": Configs.channelId,
        "productId": Configs.PRODUCT_ID,
        "appVer": Configs.versionCode,
        "scriptVer": "",
        "eventType": StringUtils.getStringValue(buriedPointEventTypeNameValues.reverse[model.eventType]),
        "pageName": StringUtils.getStringValue(model.pageName),
        "clickName": StringUtils.getStringValue(model.clickName),
        "eventTime": StringUtils.getStringValue(model.createdAt),
        "extraJson": "",
      };
      dataList.add(data);
    });

    try {
      var response = await BuriedPointApi.post(
        operate: StringUtils.isNull(BuriedPointHelper.buriedPointUrl)?JY_BuriedPoint:BuriedPointHelper.buriedPointUrl,
        data: dataList,
      );
      return true;
    } catch (e) {}
    return false;
  }
}