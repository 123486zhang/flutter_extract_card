
import 'dart:convert';

import 'package:graphic_conversion/data/net/logInterceptor.dart';
import 'package:graphic_conversion/model/watermark_photo_model.dart';
import 'package:graphic_conversion/utils/common_utils.dart';
import 'package:graphic_conversion/utils/string_utils.dart';
import 'package:dio/dio.dart';
import 'package:oktoast/oktoast.dart';

Map<String, dynamic> optHeader = {
  "Content-Type": "application/json",
  "Authorization": "APPCODE dc5f198255ce478b94f77f1a37513b7e"};

final app_key = "e9f82b01badf6fcca66b4e5d3973706045c9fa29";
final app_key_BDMY = "2a25dcd2d4eba5806dd89ffe1ddcc26550f13e32";

final photoDio = Dio()
  ..interceptors.add(MyLogInterceptor(
      requestHeader: true, requestBody: true, responseHeader: true, responseBody: true));

class PhotoApi {

  /// 获取带水印图片
  static const String JY_WatermarkPhoto = "https://apicall.id-photo-verify.com/api/cut_check_pic";
  /// 获取带水印透明像素背景图片
  static const String JY_WatermarkClearPhoto = "https://apicall.id-photo-verify.com/api/sdk_cut_pic";
  /// 获取无水印图片
  static const String JY_UnWatermarkPhoto = "https://apicall.id-photo-verify.com/api/take_cut_pic_v2";

  static Future<WatermarkPhotoModel> requestWatermarkPhoto({String file, int spec_id = 1, List background_color = const [{"start_color": 34303, "color_name": "0085FF", "enc_color": 34303}]}) async {
    Map<String, dynamic> data = {
      "spec_id": spec_id,
      "app_key": app_key,
      "background_color": background_color,
      "file": file,
    };
    try {
      var response = await photoDio.post(JY_WatermarkPhoto, data: data);
      if (response.data["code"] == 200 && response.data["result"] is Map) {
        return WatermarkPhotoModel.fromJson(response.data["result"]);
      } else {
        showToast(response.data["result"]);
      }
    } catch (e) {}
    return null;
  }

  static Future<Map<String, dynamic>> requestWatermarkClearPhoto({String file, int spec_id = 1, CancelToken cancelToken}) async {
    Map<String, dynamic> data = {
      "spec_id": spec_id,
      "app_key": app_key_BDMY,
      "file": file,
    };
    try {
      var response = await photoDio.post(JY_WatermarkClearPhoto, data: data, cancelToken: cancelToken);
      if (response.data["code"] == 200 && response.data["result"] is Map) {
        return response.data["result"];
      } else {
        var error = response.data["result"];
        if (!StringUtils.isNull(error)) {
          showToast(response.data["result"]);
        }
      }
    } catch (e) {}
    return null;
  }

  static Future requestUnWatermarkPhoto({String file_name}) async {
    Map<String, dynamic> data = {
      "file_name": file_name,
      "app_key": app_key,
    };
    try {
      var response = await photoDio.post(JY_UnWatermarkPhoto, data: data);
      var result = response.data["data"];
      if (result != null) {
        return result;
      }
    } catch (e) {}
    return null;
  }
}