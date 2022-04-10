import 'dart:io';

import 'package:flutter/material.dart';
import 'package:graphic_conversion/locatization/localizations.dart';
import 'package:graphic_conversion/ui/helper/resoure_helper.dart';
import 'package:graphic_conversion/ui/widget/navigation_back_button.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPage extends StatefulWidget {
  final String title;
  final String url;

  const WebViewPage({Key key, this.title, this.url}) : super(key: key);

  @override
  State<StatefulWidget> createState() => WebViewState();
}

//AndroidWebView

class WebViewState extends State<WebViewPage> {
  WebViewController _controller;

  @override
  void initState() {
    super.initState();

    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();

    updateProgress();
  }

  @override
  void dispose() {
    lineProgress = 1.0;
    super.dispose();
  }

  double lineProgress = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFFFFFFF),
        leading: NabigationBackButton.back(context),
        centerTitle: true,
        title: TextHelper.TextCreateWith(text:JYLocalizations.localizedString(widget.title), color:Color(0xFF000000)),
        bottom: PreferredSize(
          child: Container(
            child: _progressBar(lineProgress, context),
            height: 1,
          ),
          preferredSize: Size.fromHeight(1.0),
        ),
      ),
      body: WillPopScope(
        onWillPop: () {
          return backApp();
        },
        child: SafeArea(
          bottom: false,
          child: WebView(
            onWebViewCreated: (WebViewController webViewController) {
              _controller = webViewController;
            },
            initialUrl: widget.url,
            onPageFinished: _didFinish,
            javascriptMode: JavascriptMode.unrestricted,
          ),
        ),
      ),
    );
  }

  Future<bool> backApp() async {
    var result = await _controller.canGoBack();
    if (result) {
      _controller.goBack();
      return false;
    } else {
      return true;
    }
  }

  void back() {
    _controller.canGoBack().then((value) {
      if (value) {
        _controller.goBack();
      } else {
        return Navigator.pop(context);
      }
    });
  }

  void _didFinish(String url) {
    setState(() {
      lineProgress = 0.99;
    });
    Future.delayed(Duration(milliseconds: 300), () {
      setState(() {
        lineProgress = 1;
      });
    });
  }

  _progressBar(double progress, BuildContext context) {
    return LinearProgressIndicator(
        backgroundColor: Colors.white70.withOpacity(0),
        value: progress == 1.0 ? 0 : progress,
        valueColor: AlwaysStoppedAnimation(Colors.blue));
  }

  void updateProgress() {
    if (lineProgress < 0.5) {
      setState(() {
        lineProgress += 0.01;
      });
    } else if (lineProgress >= 0.5 && lineProgress <= 0.6) {
      setState(() {
        lineProgress += 0.002;
      });
    } else if (lineProgress > 0.6 && lineProgress <= 0.7) {
      setState(() {
        lineProgress += 0.001;
      });
    } else if (lineProgress > 0.7) {
      return;
    }

    Future.delayed(Duration(milliseconds: 30), () {
      updateProgress();
    });
  }
}
