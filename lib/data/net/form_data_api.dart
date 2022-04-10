
import 'package:graphic_conversion/data/net/logInterceptor.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

final formDataDio = Dio()
  ..interceptors.add(MyLogInterceptor(
      requestHeader: true, requestBody: true, responseHeader: true, responseBody: true));

class FormDataApi {

  static Future<bool> post({
    String url,
    FormData formData
  }) async {
    try {
      var response = await formDataDio.post(url, data: formData);
      if (response != null && response?.headers["etag"] != null) {
        return true;
      }
    } catch (e) {}
    return false;
  }
}