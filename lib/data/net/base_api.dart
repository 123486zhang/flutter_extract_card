
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:oktoast/oktoast.dart';
import 'package:graphic_conversion/configs.dart';
import 'package:graphic_conversion/data/net/logInterceptor.dart';
import 'package:graphic_conversion/ui/helper/user_helper.dart';
import 'package:graphic_conversion/utils/common_utils.dart';

Map<String, dynamic> optHeader = {
  'content-type': 'application/json',
};

final dio = new Dio(BaseOptions(baseUrl: BaseApi.baseUrl, connectTimeout: 20000, headers: optHeader))
  ..interceptors.add(MyLogInterceptor(
      requestHeader: true, requestBody: true, responseHeader: true, responseBody: true));


class BaseApi {
  /// 测试
  //static const String baseUrl = "";
  /// 正式
  static const String baseUrl = "https://platform";


  /// 基础路径
  static const String basePath = "/mobile/api/united/sendnew";

  static Map<String, dynamic> getCommonParameters() {
    Map<String, dynamic> commonParameters = {};
    commonParameters['messageId'] = '';
    commonParameters['productId'] = Configs.PRODUCT_ID;
    commonParameters['channelNo'] = Configs.channelId;
    commonParameters['platform'] = Configs.platform;
    commonParameters['timeStamp'] = (DateTime.now().millisecondsSinceEpoch / 1000).round();
    commonParameters["innerVersion"] = Configs.versionCode;
    if (UserHelper().userVM.hasUser) {
      commonParameters['userCode'] = UserHelper().userVM.userModel.userCode;
      commonParameters['accessToken'] = UserHelper().userVM.userModel.accessToken;
    }
    return commonParameters;
  }

  ///成功返回数据,失败返回null
  static Future post({
    @required String operate,
    @required String code,
    dynamic data,
    Options options,
    bool showErrorMessage = true,
  }) async {
    var apiUrl = "${BaseApi.baseUrl}${BaseApi.basePath}";
    Map<String, dynamic> requestBody = getCommonParameters();
    requestBody['data'] = jsonEncode(data);
    requestBody['operate'] = operate;
    requestBody['code'] = code;
    if (operate.startsWith("http")) {
      requestBody['operate'] = "";
      apiUrl = operate;
    }
    var requestData = jsonEncode(requestBody);
    if (!await CommonUtils.isNetConnected()) {
      showToast('网络连接失败');
      throw DioError(error: '网络连接失败');
    }
    var response = await dio.post(apiUrl, data: requestData, options: options);
    if (response.data['msgCode'] == 0) {
      var result = jsonDecode(response.data["data"]);
      if (result is Map && result["state"] == "failed") {
        if (showErrorMessage&&(response.data['message']!=null&&response.data['message']!='')) showToast(response.data['message']);
      } else {
        return result;
      }
    } else {
      if (showErrorMessage) showToast(response.data['message']);
    }
    return null;
  }

  static Future authPost({
    @required String operate,
    @required String code,
    dynamic data,
  }) async {
    Options options = Options(headers: {
      "Authorization": UserHelper().userVM.hasUser?"Bearer ${UserHelper().userVM.userModel.Authorization}":""
    });
    try {
      var response = await BaseApi.post(
        operate: operate,
        code: code,
        data: data,
        options: options,
      );
      return response;
    } catch (e) {}
    return null;
  }

  /// 成功返回数据,失败返回null
  static Future get(String url, {Map data}) async {
    try {
      var response = await dio.get(url, queryParameters: data);

      if (response.statusCode == 200 &&
          response.data is Map &&
          response.data['Status'] == 1) {
        return response.data;
      }
    } catch (e) {
      return null;
    }
    return null;
  }
}
