import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:path_provider/path_provider.dart';

class CacheAudioManager {
  /// 获取url字符串的MD5值
  static String getUrlMd5(String url) {
    var content = new Utf8Encoder().convert(url);
    var digest = md5.convert(content);
    return digest.toString();
  }

  /// 获取Image缓存路径
  static Future<String> getCachePath() async {
    Directory dir = await getApplicationDocumentsDirectory();
    Directory cachePath = Directory("${dir.path}/ImageCache/");
    if (!cachePath.existsSync()) {
      cachePath.createSync();
    }
    return cachePath.path;
  }

  /// 判断是否有对应压缩文件存在
  static Future<File> getZipPath(String url) async {
    String cacheDirPath = await getCachePath();
    String urlMd5 = getUrlMd5(url);
    File file = File("$cacheDirPath$urlMd5.zip");
    return file;
  }

  /// 判断是否有对应图片文件存在
  static Future<File> getImagePath(String url) async {
    String cacheDirPath = await getCachePath();
    String urlMd5 = getUrlMd5(url);
    File file = File("$cacheDirPath$urlMd5.png");
    return file;
  }

  /// 判断是否有对应audio缓存文件存在
  static Future<File> getAudioPath(String url) async {
    String cacheDirPath = await getCachePath();
    String urlMd5 = getUrlMd5(url);
    File file = File("$cacheDirPath$urlMd5.mp3");
    return file;
  }

  /// 将下载的audio数据缓存到指定文件
  static Future saveBytesToFile(String url, Uint8List bytes) async {
    String cacheDirPath = await getCachePath();
    String urlMd5 = getUrlMd5(url);
    File file = File("$cacheDirPath/$urlMd5");
    if (!file.existsSync()) {
      file.createSync();
      await file.writeAsBytes(bytes);
    }
  }

  /// 保存图片(通过图片本地地址)
  static Future<File> saveImageToFile(String imagePath) async {
    Uint8List bytes = await File(imagePath).readAsBytes();
    String cacheDirPath = await getCachePath();
    String timeStamp = "${DateTime.now().millisecondsSinceEpoch}";
    File file = File("$cacheDirPath$timeStamp.png");
    if (!file.existsSync()) {
      file.createSync();
      await file.writeAsBytes(bytes);
    }
    return file;
  }

  /// 保存图片(通过图片二进制数据)
  static Future<File> saveImageWithUint8List(Uint8List bytes) async {
    String cacheDirPath = await getCachePath();
    String timeStamp = "${DateTime.now().millisecondsSinceEpoch}";
    File file = File("$cacheDirPath$timeStamp.png");
    if (!file.existsSync()) {
      file.createSync();
      await file.writeAsBytes(bytes);
    }
    return file;
  }

  static Future<String> getImageFile(String lastCompose) async {
    String cacheDirPath = await getCachePath();
    return "$cacheDirPath$lastCompose";
  }

  /// 获取文档缓存路径
  static Future<String> getDocumentCachePath() async {
    Directory dir = await getApplicationDocumentsDirectory();
    Directory cachePath = Directory("${dir.path}/DocumentCache/");
    if (!cachePath.existsSync()) {
      cachePath.createSync();
    }
    return cachePath.path;
  }

  static Future<File> writeDocument({String text, String filePath}) async {
    String cacheDirPath = await getDocumentCachePath();
    final File file = File('$cacheDirPath$filePath.txt');
    if (!file.existsSync()) {
      file.createSync();
      await file.writeAsString(text);
    }
    return file;
  }
}