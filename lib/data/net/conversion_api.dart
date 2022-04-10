import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:graphic_conversion/data/net/logInterceptor.dart';
import 'package:graphic_conversion/ui/helper/user_helper.dart';
import '../../configs.dart';
import 'base_api.dart';
import 'package:crypto/crypto.dart';

Map<String, dynamic> jsonHeader = {
  "Content-Type": "application/json",// "application/x-www-form-urlencoded",
  "Authorization": UserHelper().userVM.hasUser?"Bearer ${UserHelper().userVM.userModel.Authorization}":"",
};

Map<String, dynamic> optHeader = {
  "Content-Type": "application/json",// "application/x-www-form-urlencoded",
  "Authorization": UserHelper().userVM.hasUser?"Bearer ${UserHelper().userVM.userModel.Authorization}":"",
};

final APP_ID = "25115547";
final API_KEY = "GfDk2dsBx34pRbEmwGxPUPkO";
final SECRET_KEY = "8uYWT6ImTKpEDA6EGKZnK6Ux9BLI6Zw6";

Map<String, dynamic> languageHeader = {
  "Content-Type": "application/x-www-form-urlencoded",
};

final LANGUAGE_APP_ID = "20220105001047275";
final LANGUAGE_API_KEY = "EnjG57iZRr4POAL3QyLf";
final LANGUAGE_SALT = "123456";

final conversionDio = Dio()
  ..interceptors.add(MyLogInterceptor(
      requestHeader: true, requestBody: true, responseHeader: true, responseBody: true));

class ConversionApi {

  /// 获取分享Docx文件链接
  static String JY_Share_Docx = BaseApi.baseUrl + shareDocxUrlPath;
  static const String shareDocxUrlPath = "/mobile/api/appfun/ocr/export";

  static const String recognitionUrlPath = "/mobile/api/appfun/ocr/prediction";
  /// 获取Access Token
  // static const String JY_AccessToken = "https://aip.baidubce.com/oauth/2.0/token";

  static String JY_Fanyi_BaseUrl = "https://fanyi-api.baidu.com/api/trans/vip";
  /// 获取支持语言
  static String JY_Language = "/language";
  /// 获取通用翻译
  static String JY_Translate = "/translate";

  /// 识别
  static const String JY_Recognition = BaseApi.baseUrl + recognitionUrlPath;//  "https://aip.baidubce.com/rest/2.0/ocr/v1/accurate_basic";

  // static Future<String> requestAccessToken() async {
  //   var url = "$JY_AccessToken?grant_type=client_credentials&client_id=$API_KEY&client_secret=$SECRET_KEY";
  //   try {
  //     var response = await conversionDio.post(url,);
  //     if (response.data != null) {
  //       var accessToken = response.data["access_token"];
  //       return accessToken;
  //     }
  //   } catch (e) {}
  //   return null;
  // }

  static Future<Map<String, dynamic>> requestRecognition({String image, int index, CancelToken cancelToken, bool useNewApi = false}) async {
    Map<String, dynamic> data = {
      "image": image,
      "detect_direction": "true",
      "language_type": "auto_detect",
    };
    Map<String, dynamic> result = {};
    result["index"] = index;
    try {
      // var accessToken = await requestAccessToken();
      // if (!StringUtils.isNull(accessToken))
      {
        var url = "$JY_Recognition";//var url = "$JY_Recognition?access_token=$accessToken";
        var response = await conversionDio.post(url, data: useNewApi?jsonEncode(data):data, options: Options(headers: optHeader), cancelToken: cancelToken);//BaseApi.authPost(operate: operate, code: code, data: data); //

        if (response.data != null && response.data["words_result"] != null) {
          result["words_result"] = response.data["words_result"];
          // List result = response.data["words_result"];
          return result;
        }
      }
      // else {
      //   showToast("Access Token获取失败");
      // }
    } catch (e) {}
    return result;
  }

  static Future<Map<String, dynamic>> requestShareDoc({List<TextEditingController> contentControllers, List<TextEditingController> translateControllers, CancelToken cancelToken}) async {

    List ocrResList = [];

    for(int i=0;i<contentControllers.length;i++){
      String translateStr = "";
      if(translateControllers.length>i){
        translateStr = translateControllers[i].text;
      }
      Map<String, dynamic> words1 = {
        "words": contentControllers[i].text +"\n" + translateStr,
      };

      Map<String, dynamic> words_result1 = {
        "words_result": [words1],
        "words_result_num": 13,
        "direction": 0,
        "log_id": 0,
      };

      ocrResList.add(words_result1);
    }

    Map<String, dynamic> basicUserInfoForm = {
      "uuid": Configs.deviceId,
    };

    Map<String, dynamic> data = {
      "ocrResList": ocrResList,
      "basicUserInfoForm": basicUserInfoForm,
    };
    Map<String, dynamic> result = {};
    try {

      var url = "$JY_Share_Docx";
      var response = await conversionDio.post(url, data: jsonEncode(data), options: Options(headers: jsonHeader), cancelToken: cancelToken);

      if (response.data != null) {
        result["data"] = response.data;
        return result;
      }
    } catch (e) {}
    return result;
  }

  static Future<Map<String, dynamic>> requestCurrentLanguage({String q, int index, CancelToken cancelToken}) async {
    String originalStr = LANGUAGE_APP_ID+q+LANGUAGE_SALT+LANGUAGE_API_KEY;
    String sign = generate_MD5(originalStr);
    Map<String, dynamic> data = {
      "q": q,
      "appid": LANGUAGE_APP_ID,
      "salt": LANGUAGE_SALT,
      "sign":sign,
    };
    Map<String, dynamic> result = {};
    result["index"] = index;
    try {
      var url = "$JY_Fanyi_BaseUrl$JY_Language";
      var response = await conversionDio.post(url, data:data, options: Options(headers: languageHeader), cancelToken: cancelToken);
      result["error_code"] = response.data["error_code"];
      if (response.data != null && response.data["error_code"]==0) {
        result["data"] = response.data["data"];
        return result;
      }else{
        result["error_msg"] = response.data["error_msg"];
      }
    } catch (e) {
      result["error_msg"] = e.toString();
    }
    return result;
  }

  static Future<Map<String, dynamic>> requestTranslateToLanguage({String q, int index, CancelToken cancelToken, String from, String to}) async {
    String originalStr = LANGUAGE_APP_ID+q+LANGUAGE_SALT+LANGUAGE_API_KEY;
    String sign = generate_MD5(originalStr);
    Map<String, dynamic> data = {
      "q": q,
      "appid": LANGUAGE_APP_ID,
      "salt": LANGUAGE_SALT,
      "sign":sign,
      "from":from,
      "to":to,
    };
    Map<String, dynamic> result = {};
    result["index"] = index;
    try {
      var url = "$JY_Fanyi_BaseUrl$JY_Translate";
      var response = await conversionDio.post(url, data:data, options: Options(headers: languageHeader), cancelToken: cancelToken);
      if (response.data != null) {
        result["from"] = response.data["from"];
        result["to"] = response.data["to"];
        result["data"] = response.data["trans_result"];
        return result;
      }else{
        result["error_msg"] = response.data["error_msg"];
      }
    } catch (e) {
      result["error_msg"] = e.toString();
    }
    return result;
  }

  // md5 加密
  static String generate_MD5(String data) {
    var content = new Utf8Encoder().convert(data);
    var digest = md5.convert(content);
    // 这里其实就是 digest.toString()
    //return hex.encode(digest.bytes);
    return digest.toString();
  }
}