import 'dart:convert';
import 'dart:io';

import 'package:graphic_conversion/configs.dart';
import 'package:graphic_conversion/data/net/base_api.dart';
import 'package:graphic_conversion/data/net/form_data_api.dart';
import 'package:graphic_conversion/model/app_config.dart';
import 'package:graphic_conversion/model/check_upgrade.dart';
import 'package:graphic_conversion/model/order_model.dart';
import 'package:graphic_conversion/model/upload_image_model.dart';
import 'package:graphic_conversion/model/user_model.dart';
import 'package:graphic_conversion/model/wx_user.dart';
import 'package:graphic_conversion/ui/helper/user_helper.dart';
import 'package:graphic_conversion/ui/manager/cache_audio_manager.dart';
import 'package:graphic_conversion/view_model/provider/provider_manager.dart';
import 'package:dio/dio.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

class FIZZApi {
  static const String code = "fizz";

  /// 启动接口（获取App配置信息）
  static const String JY_StartConfig = "/free/start/config";
  /// 获取用户信息
  static const String JY_GetUserInfo = "/auth/user/basicUserInfo";
  /// 未登录获取用户信息
  static const String JY_GetUserInfoYK = "/free/user/basicUserInfoYK";
  /// 微信登录
  static const String JY_WeChatLogin = "/free/user/wechatLoginUm";
  /// 获取手机验证码
  static const String JY_GetSMSCode = "/free/sms/getSmsCode";
  /// 短信验证码登录
  static const String JY_SMSLogin = "/free/user/sms/login";
  /// apple账号登录
  static const String JY_AppleLogin = "/free/user/appleLogin";
  /// 用户注销
  static const String JY_UserCancel = "/auth/user/cance";
  /// 绑定手机号
  static const String JY_PhoneBind = "/auth/user/bindPhone";
  /// 检查更新
  static const String JY_CheckUpdate = "/free/system/upgrade";
  /// 未登录苹果内购验证
  static const String JY_ApplePayValidateReceiptYK = "${BaseApi.baseUrl}/mobile/api/free/pay/inPurchaseValidateYK";
  /// 苹果内购验证
  static const String JY_ApplePayValidateReceipt = "${BaseApi.baseUrl}/mobile/api/free/pay/inPurchaseValidateNew";
  /// Android支付
  static const String JY_AndroidPay = "/auth/pay/perOrder";
  /// 证件照保存
  static const String JY_SavePhoto = "/free/photo/createOrder";
  /// 扫图识字订单修改
  static const String JY_EditOrder = "/free/photo/editOrder";
  /// 证件照订单列表
  static const String JY_OrderList = "/free/photo/orderList";
  /// 支付成功后前端回调
  static const String JY_OrderCall = "/free/photo/orderCall";
  /// 证件照发送邮箱
  static const String JY_SendEmail = "/free/photo/sendEmail";
  /// 图片上传
  static const String JY_UploadImage = "/free/upload/filehandle";
  /// 查询功能是否可以使用
  static const String JY_FunctionCanUse = "/free/funUse/functionCanUse";
  /// 记录功能使用次数
  static const String JY_FunctionSave = "/free/funUse/save/count";
  /// 功能ID
  static const int JY_FunctionId = Configs.FunctionId;
  /// 使用G码
  static const String JY_UseGcode = "/free/start/freeCode";

  /// 粉丝加群二维码图片
  static const String JY_ProductQrcode = "/free/start/productQrcode";

  /// 苹果未登录需要添加后缀
  static const String JY_AppleAnonymousUrlSuffix = "YK";


  static Future post({
    String operate,
    String code = code,
    dynamic data,
  }) async {
    return BaseApi.post(operate: operate, code: code, data: data);
  }

  static Future authPost({
    String operate,
    String code = code,
    dynamic data,
  }) async {
    return BaseApi.authPost(operate: operate, code: code, data: data);
  }

  static Future<AppConfig> requestStartConfig() async {
    Map<String, dynamic> data = {};
    try {
      var response = await FIZZApi.post(
        operate: JY_StartConfig,
        data: data,
      );
      return AppConfig.fromJson(response);
    } catch (e) {}
    return null;
  }

  static Future<Map<String, dynamic>> requestGetUserInfo() async {
    Map<String, dynamic> data = {
      "androidId": Configs.deviceId,
      "imei": "",
      "uuid": Configs.deviceId,
    };
    try {
      var response = await FIZZApi.authPost(
        operate: (Platform.isIOS&&!UserHelper().userVM.hasUser) ? JY_GetUserInfoYK : JY_GetUserInfo,
        data: data,
      );
      return response;
    } catch (e) {}
    return null;
  }

  static Future<UserModel> requestWeChatLogin(WeChatUser weChatUser) async {
    Map<String, dynamic> data = {
      'unionId': weChatUser.unionId,
      'openId': weChatUser.openId,
      'name': weChatUser.name,
      'userHeader': weChatUser.iconurl,
      'gender': weChatUser.gender,
      'city': weChatUser.city,
      'province': weChatUser.province,
      'country': weChatUser.country,
      'language': weChatUser.language,
      'accessToken': weChatUser.accessToken,
      'refreshToken': weChatUser.refreshToken,
      'expiresIn': weChatUser.expires_in.toString(),
      "uuid": Configs.deviceId,
    };
    try {
      var response = await FIZZApi.post(
        operate: JY_WeChatLogin+((Platform.isIOS&&!UserHelper().userVM.hasUser)?JY_AppleAnonymousUrlSuffix:""),
        data: data,
      );
      return UserModel.fromLoginMap(response);
    } catch (e) {}
    return null;
  }

  //1绑定 2重置密码  3登录
  static Future<bool> requestGetSMSCode({String phone, int type}) async {
    Map<String, dynamic> data = {
      'phone': phone,
      'type': type,
      "uuid": Configs.deviceId,
    };
    try {
      var response = await FIZZApi.post(
        operate: JY_GetSMSCode,
        data: data,
      );
      if (response != null) {
        return true;
      }
    } catch (e) {}
    return false;
  }

  static Future<UserModel> requestSMSLogin({String phone, String smsCode}) async {
    Map<String, dynamic> data = {
      'phone': phone,
      'smsCode': smsCode,
      "uuid": Configs.deviceId,
    };
    try {
      var response = await FIZZApi.post(
        operate: JY_SMSLogin+((Platform.isIOS&&!UserHelper().userVM.hasUser)?JY_AppleAnonymousUrlSuffix:""),
        data: data,
      );
      return UserModel.fromLoginMap(response);
    } catch (e) {}
    return null;
  }

  static Future<UserModel> requestAppleLogin({String appleToken, String nikeName, String uid}) async {
    Map<String, dynamic> data = {
      'appleToken': appleToken,
      'nikeName': nikeName,
      "uuid": Configs.deviceId,
    };
    try {
      var response = await FIZZApi.post(
        operate: JY_AppleLogin+((Platform.isIOS&&!UserHelper().userVM.hasUser)?JY_AppleAnonymousUrlSuffix:""),
        data: data,
      );
      return UserModel.fromLoginMap(response);
    } catch (e) {}
    return null;
  }

  static Future<bool> requestUserCancel() async {
    Map<String, dynamic> data = {
    };
    try {
      var response = await FIZZApi.authPost(
        operate: JY_UserCancel,
        data: data,
      );
      return response["isDisable"] == 1;
    } catch (e) {}
    return false;
  }

  static Future<Map<String, dynamic>> requestPhoneBind({String mobile, String valCode}) async {
    Map<String, dynamic> data = {
      "mobile": mobile,
      "valCode": valCode,
    };
    try {
      var response = await FIZZApi.authPost(
        operate: JY_PhoneBind,
        data: data,
      );
      return response;
    } catch (e) {}
    return null;
  }

  static Future<MessageInfos> requestCheckUpdate() async {
    Map<String, dynamic> data = {};
    try {
      var response = await FIZZApi.post(
        operate: JY_CheckUpdate,
        data: data,
      );
      if (response != null && response is Map) {
        return MessageInfos.fromJson(response);
      }
    } catch (e) {}
    return null;
  }

  static Future<Map<String, dynamic>> requestApplePayValidateReceipt(
      {String receipt, int packageId}) async {
    var isSendBoxString = "1";
    if (receipt.contains("Sandbox")) {
      isSendBoxString = "0";
    }
    // Map<String, dynamic> data = {
    //   "receipt": receipt,
    //   "receiptType": isSendBoxString,
    //   "rechargeType": 1,
    //   "orderNo": orderNo,
    //   "packageId": 44,
    // };
    Map<String, dynamic> requestBody = BaseApi.getCommonParameters();
    requestBody["receipt"] = receipt;
    requestBody["receiptType"] = isSendBoxString;
    requestBody["rechargeType"] = 0;
    requestBody["orderNo"] = "";
    requestBody["packageId"] = packageId;
    requestBody['data'] = [];
    requestBody['operate'] = "";
    requestBody['code'] = code;

    try {
      var requestData = jsonEncode(requestBody);
      var response = await dio.post((Platform.isIOS&&!UserHelper().userVM.hasUser)?JY_ApplePayValidateReceiptYK:JY_ApplePayValidateReceipt, data: requestData);
      if (response.data['msgCode'] == 0) {
        return jsonDecode(response.data["data"]);
      }
    } catch (e) {}
    return null;
  }

  static Future<OrderModel> requestSavePhoto({String url, String urlPrint, String orderName, String imageSize, String imagePixel, String fileName, String clearColorUrl, String originUrl}) async {
    Map<String, dynamic> data = {
      "urlWm": url,
      "urlPrintWm": urlPrint,
      "orderName": orderName,
      "imageSize": imageSize,
      "imagePixel": imagePixel,
      "fileName": fileName,
      "clearColorUrl": clearColorUrl,
      "originUrl": originUrl,
      "packageId": 44,
    };
    try {
      var response = await FIZZApi.post(
        operate: JY_SavePhoto,
        data: data,
      );
      return OrderModel.fromJson(response["orderInfo"]);
    } catch (e) {}
    return null;
  }

  static Future<OrderModel> requestEditOrder({String url, String urlPrint, String orderNo, String imageSize, String imagePixel, String fileName, String orderName}) async {
    Map<String, dynamic> data = {
      "urlWm": url,
      "urlPrintWm": urlPrint,
      "orderName": orderName,
      "orderNo": orderNo,
      "imageSize": imageSize,
      "imagePixel": imagePixel,
      "fileName": fileName,
    };
    try {
      var response = await FIZZApi.post(
        operate: JY_EditOrder,
        data: data,
      );
      return OrderModel.fromJson(response["orderInfo"]);
    } catch (e) {}
    return null;
  }

  static Future<OrderModel> requestOrderCall({String url, String urlPrint, String orderNo}) async {
    Map<String, dynamic> data = {
      "url": url,
      "urlPrint": urlPrint,
      "orderNo": orderNo
    };
    try {
      var response = await FIZZApi.post(
        operate: JY_OrderCall,
        data: data,
      );
      return OrderModel.fromJson(response["orderInfo"]);
    } catch (e) {}
    return null;
  }

  static Future<Map<String, dynamic>> requestSendEmail({String filename, String subject, String receive, String msg, String orderNo}) async {
    Map<String, dynamic> data = {
      "receive": receive,
      "fileName": filename,
      "subject": subject,
      "msg": msg,
      "orderNo": orderNo,
    };
    try {
      var response = await FIZZApi.post(
        operate: JY_SendEmail,
        data: data,
      );
      return response;
    } catch (e) {}
    return null;
  }

  static Future<UploadImageModel> requestUploadImage({String imagePath}) async {
    File file = File(imagePath);
    var size = await file.length();
    Map<String, dynamic> data = {
      "fileType": "tool",
      "fileName": "${DateTime.now().millisecondsSinceEpoch}.png",
      "size": size,
    };
    try {
      var response = await FIZZApi.post(
        operate: JY_UploadImage,
        data: data,
      );
      if (response != null && response is Map) {
        UploadImageModel model = UploadImageModel.fromJson(response);
        if (model.type == 1) { /// 阿里云
          FormData formData = FormData.fromMap({
            "key": model.key,
            "policy": model.encodePolicy,
            "OSSAccessKeyId": model.accessKeyId,
            "Signature": model.signaturecom,
            "file": await MultipartFile.fromFile(imagePath),
          });
          var aliResponse = await FormDataApi.post(
            url: model.uploadUrl,
            formData: formData,
          );
          if (aliResponse) {
            return model;
          }
        }
      }
    } catch (e) {}
    return null;
  }

  static Future<bool> requestFunctionCanUse() async {
    Map<String, dynamic> data = {
      "functionId": JY_FunctionId,
      "androidId": Configs.deviceId,
    };
    try {
      var response = await FIZZApi.post(
        operate: JY_FunctionCanUse,
        data: data,
      );
      if (response["Status"] == 1) {
        int totalCanUseCount = response["TotalCanUseCount"];
        int usedCount = response["UsedCount"];
        int result = totalCanUseCount - usedCount;
        return result > 0;
      }
    } catch (e) {}
    return false;
  }

  static Future<Map<String, dynamic>> requestFunctionSave() async {
    Map<String, dynamic> data = {
      "functionId": JY_FunctionId,
      "androidId": Configs.deviceId,
      "usedCount": 1
    };
    try {
      var response = await FIZZApi.post(
        operate: JY_FunctionSave,
        data: data,
      );
      return response;
    } catch (e) {}
    return null;
  }

  static Future<bool> requestUseGCode(String gcode) async {
    Map<String, dynamic> data = {
      "fcode": gcode,
    };
    try {
      var response = await FIZZApi.post(
        operate: JY_UseGcode,
        data: data,
      );
      print("=====${response.toString()}");
      return response["status"] == 1;
    } catch (e) {}
    return false;
  }

  static Future<Map<String, dynamic>> requestProductQrcode() async {
    Map<String, dynamic> data = {};
    try {
      var response = await FIZZApi.post(
        operate: JY_ProductQrcode,
        data: data,
      );
      if (response != null && response is Map) {
        return response;
      }
    } catch (e) {}
    return null;
  }
}