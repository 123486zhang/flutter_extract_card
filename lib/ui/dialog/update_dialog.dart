import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:oktoast/oktoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:graphic_conversion/channel/android_method_channel.dart';
import 'package:graphic_conversion/ui/helper/dialog_helper.dart';

class UpdateDialog extends StatefulWidget {
  final String message;
  final String url;
  final bool isForce;

  const UpdateDialog({
    Key key,
    this.message,
    this.url,
    this.isForce,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return UpdateDialogState();
  }
}

class UpdateDialogState extends State<UpdateDialog> {
  int upState = 0; //0提示，1下载中，2安装中，
  int progress = 34;

  static String _downloadPath = '';
  static String _filename = 'update.apk';
  static String _taskId = '';
  var _listen;
  ReceivePort _port = new ReceivePort();

  @override
  void initState() {
    super.initState();

    _bindBackgroundIsolate();
    FlutterDownloader.registerCallback(downloadCallback);

    _prepareDownload();
  }

  @override
  void dispose() {
    _unbindBackgroundIsolate();
    super.dispose();
  }

  void _bindBackgroundIsolate() {
    bool isSuccess = IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
    if (!isSuccess) {
      _unbindBackgroundIsolate();
      _bindBackgroundIsolate();
      return;
    }
    _port.listen((dynamic data) async {
      String id = data[0];
      DownloadTaskStatus status = data[1];
      int progress = data[2];
      debugPrint(
          'download--registerPortWithName---id=$id--status=${status.value}----progress=$progress');

      if (status == DownloadTaskStatus.complete) {
        // 更新弹窗提示，确认后进行安装
        setState(() {
          this.upState = 2;
        });
        installApk();
        debugPrint(
            '==============_installApkz: $_taskId  $_downloadPath /$_filename');
      } else if (status == DownloadTaskStatus.running) {
        setState(() {
          this.upState = 1;
          this.progress = progress;
        });
      } else if (status.value > 3) {
        setState(() {
          this.upState = 0;
          this.progress = 0;
        });
        _retryDownload(id);
      }
    });
  }

  void _unbindBackgroundIsolate() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
  }

  @override
  Widget build(BuildContext context) {
    Widget contentWidget = Text(
      widget.message.replaceAll("\\|", "\n"),
      style: TextStyle(
        fontSize: 15,
        height: 1.4,
      ),
    );

    Widget progressWidget = Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        SizedBox(
          height: 5,
          child: LinearProgressIndicator(
            value: this.progress / 100,
            backgroundColor: Colors.grey,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 5),
          child: Text('${this.progress}%'),
        ),
      ],
    );

    Widget cancelWidget = CupertinoButton(
      onPressed: () {
        if (_taskId != null) {}
        Navigator.of(context).pop();
      },
      child: new Text(
        '取消',
        style: TextStyle(color: Colors.black),
      ),
    );

    Widget ensureWidget = CupertinoButton(
      onPressed: () {
        if (Platform.isAndroid) {
          AndroidMethodChannel.handlePermission("存储").then((value) {
            if (value == true) {
              if (this.upState == 0) {
                startUpdate();
              } else if (this.upState == 2) {
                installApk();
              }
            } else {
              DialogHelper.showPermissionTipDialog(context, "存储").then((value) {
                if (value == true) {
                  if (this.upState == 0) {
                    startUpdate();
                  } else if (this.upState == 2) {
                    installApk();
                  }
                }
              });
            }
          });
        } else {
          if (this.upState == 0) {
            startUpdate();
          } else if (this.upState == 2) {
            installApk();
          }
        }
      },
      child: new Text(
          this.upState == 0 ? '立即更新' : this.upState == 1 ? '下载中' : '安装',
          style: TextStyle(color: Colors.black)),
    );

    List<Widget> getButtons() {
      if (widget.isForce) {
        return <Widget>[ensureWidget];
      } else {
        return <Widget>[cancelWidget, ensureWidget];
      }
    }

    return WillPopScope(
      onWillPop: () async {
        //强制更新，不让返回
        return !widget.isForce;
      },
      child: CupertinoAlertDialog(
        title: Text('更新提示'),
        content: Padding(
          padding: EdgeInsets.fromLTRB(18, 18, 18, 0),
          child: upState == 0 ? contentWidget : progressWidget,
        ),
        actions: getButtons(),
      ),
    );
  }

  startUpdate() async {
    if (upState != 0) {
      return;
    }
    final bool _permissionReady = await _checkPermission();
    if (_permissionReady) {
      await _prepareDownload();
      if (_downloadPath.isNotEmpty) {
        await download();
      }
    }
  }

  // 下载前的准备
  Future<void> _prepareDownload() async {
    var exDir = await getExternalStorageDirectory();

    _downloadPath = (exDir.path) + '/Download';
    final savedDir = Directory(_downloadPath);
    bool hasExisted = await savedDir.exists();
    if (!hasExisted) {
      savedDir.create();
    }
    debugPrint('--------------------downloadPath: $_downloadPath');
  }

  // 下载apk
  Future<void> download() async {
    final bool _permissionReady = await _checkPermission();
    if (_permissionReady) {
      _taskId = await FlutterDownloader.enqueue(
          url: this.widget.url,
          savedDir: _downloadPath,
          fileName: _filename,
          showNotification: true,
          openFileFromNotification: true);
    } else {
      showToast('权限拒绝！');
      debugPrint('-----------------未授权');
    }
  }

  installApk() {
    FlutterDownloader.open(taskId: _taskId);
  }

  // 下载完成之后的回调
  static downloadCallback(id, status, progress) {
    debugPrint(
        'download--downloadCallback---id=$id--status=${status.value}----progress=$progress');

    final SendPort send =
        IsolateNameServer.lookupPortByName('downloader_send_port');
    send.send([id, status, progress]);
  }

// 检查权限
  Future<bool> _checkPermission() async {
    bool checkPermission = await AndroidMethodChannel.checkPermission("存储");
    if (!checkPermission) {
      bool requestPermission = await AndroidMethodChannel.requestPermission("存储");
      if (requestPermission) {
        return true;
      } else {
        return false;
      }
    } else {
      return true;
    }
  }

  void _retryDownload(String taskId) async {
    _taskId = await FlutterDownloader.retry(taskId: taskId);
  }
}
