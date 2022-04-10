
import 'package:dio/dio.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:graphic_conversion/ui/manager/cache_audio_manager.dart';
import 'package:graphic_conversion/utils/string_utils.dart';

final downloadDio = Dio();

class DownloadApi {
  static Future downloadImage(String url, {String savePath, bool showLoading = false, ProgressCallback onReceiveProgress}) async {
    if (showLoading) EasyLoading.show();
    if (StringUtils.isNull(savePath)) {
      var file = await CacheAudioManager.getImagePath(url);
      savePath = file.path;
    }
    await downloadDio.download(
        url,
        savePath,
        onReceiveProgress: onReceiveProgress
    );
    if (showLoading) EasyLoading.dismiss();
  }

  static Future downloadDocument(String url,{String savePath, bool showLoading = false, ProgressCallback onReceiveProgress}) async {
    if (showLoading) EasyLoading.show();
    print("download Doc");
    if (StringUtils.isNull(savePath)) {
      savePath = await CacheAudioManager.getDocumentCachePath();
    }
    await downloadDio.download(
        url,
        savePath,
        onReceiveProgress: onReceiveProgress
    );
    if (showLoading) EasyLoading.dismiss();
  }
}