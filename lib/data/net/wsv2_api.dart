import 'package:graphic_conversion/data/net/base_api.dart';

class WSV2Api {
  static Future post({
    String operate,
    String code = "wsv2",
    dynamic data,
  }) async {
    return BaseApi.post(operate: operate, code: code, data: data);
  }
}