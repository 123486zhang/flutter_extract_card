import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class MyLogInterceptor extends Interceptor {
  MyLogInterceptor({
    this.request = true,
    this.requestHeader = true,
    this.requestBody = false,
    this.responseHeader = true,
    this.responseBody = false,
    this.error = true,
    this.logPrint = print,
  });

  /// Print request [Options]
  bool request;

  /// Print request header [Options.headers]
  bool requestHeader;

  /// Print request data [Options.data]
  bool requestBody;

  /// Print [Response.data]
  bool responseBody;

  /// Print [Response.headers]
  bool responseHeader;

  /// Print error message
  bool error;

  /// Log printer; defaults print log to console.
  /// In flutter, you'd better use debugPrint.
  /// you can also write log in a file, for example:
  ///```dart
  ///  var file=File("./log.txt");
  ///  var sink=file.openWrite();
  ///  dio.interceptors.add(LogInterceptor(logPrint: sink.writeln));
  ///  ...
  ///  await sink.close();
  ///```
  void Function(Object object) logPrint;

  @override
  Future onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    var log = '*** Request ***\n';
    log = _printKV(log, 'uri', options.uri);

    if (request) {
      log = _printKV(log, 'method', options.method);
      // log = _printKV(log, 'responseType', options.responseType?.toString());
      // log = _printKV(log, 'followRedirects', options.followRedirects);
      // log = _printKV(log, 'connectTimeout', options.connectTimeout);
      // log = _printKV(log, 'receiveTimeout', options.receiveTimeout);
      // log = _printKV(log, 'extra', options.extra);
    }
    if (requestHeader) {
      log += 'headers:\n';
      options.headers.forEach((key, v) => log = _printKV(log, ' $key', v));
    }
    if (requestBody) {
      log += 'data:\n';
      log += options.data.toString();
    }
    logPrint('\n');
    debugPrint(log);

    return super.onRequest(options, handler);
  }

  @override
  Future onError(DioError err, ErrorInterceptorHandler handler) async {
    if (error) {
      var log = '*** DioError ***:\n';
      log += 'uri: ${err.requestOptions.uri}\n';
      log += '$err\n';
      if (err.response != null) {
        log = _printResponse(log, err.response);
      }
      log += '\n';
      debugPrint(log);
    }
    return super.onError(err, handler);
  }

  @override
  Future onResponse(Response response, ResponseInterceptorHandler handler) async {
    var log = '*** Response ***\n';
    log = _printResponse(log, response);
    debugPrint(log);
    return super.onResponse(response, handler);
  }

  String _printResponse(String log, Response response) {
    log = _printKV(log, 'uri', response.requestOptions.uri);
    if (responseHeader) {
      log = _printKV(log, 'statusCode', response.statusCode);
      // if (response.isRedirect == true) {
      //   log = _printKV(log, 'redirect', response.realUri);
      // }
      // if (response.headers != null) {
      //   log += 'headers:\n';
      //   response.headers.forEach((key, v) => log = _printKV(log, ' $key', v.join(',')));
      // }
    }
    if (responseBody) {
      log += 'Response Text:\n';
      log += response.toString();
    }
    log += '\n';
    return log;
  }

  String _printKV(String log, String key, Object v) {
    return log += '$key: $v \n';
  }
}
