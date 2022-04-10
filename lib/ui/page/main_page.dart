import 'dart:io';

import 'package:data_plugin/bmob/table/bmob_user.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graphic_conversion/locatization/localizations.dart';
import 'package:graphic_conversion/ui/page/recent_page.dart';
import 'package:graphic_conversion/utils/umeng_utils.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'package:graphic_conversion/channel/ios_method_channel.dart';
import 'package:graphic_conversion/data/local_storage/storage_manager.dart';
import 'package:graphic_conversion/data/net/buried_point_api.dart';
import 'package:graphic_conversion/data/net/wx_api.dart';
import 'package:graphic_conversion/model/buried_point_model.dart';
import 'package:graphic_conversion/router/router_config.dart';
import 'package:graphic_conversion/ui/dialog/agreement_dialog.dart';
import 'package:graphic_conversion/ui/helper/buried_point_helper.dart';
import 'package:graphic_conversion/ui/helper/dialog_helper.dart';
import 'package:graphic_conversion/ui/helper/ios_pay_helper.dart';
import 'package:graphic_conversion/ui/helper/resoure_helper.dart';
import 'package:graphic_conversion/ui/helper/user_helper.dart';
import 'package:graphic_conversion/ui/page/home_page.dart';
import 'package:graphic_conversion/ui/page/mine_page.dart';
import 'package:graphic_conversion/ui/widget/fixed_size_text.dart';
import 'package:fluwx/fluwx.dart' as fluwx;
import 'package:graphic_conversion/view_model/provider/provider_manager.dart';
import 'package:graphic_conversion/view_model/user_view_model.dart';
import 'package:graphic_conversion/data/net/fizz_api.dart';

import '../../configs.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  static DateTime _lastPressed;

  bool _loading = false;

  bool _isAgree = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    navigatorContext = context;

    Configs.PERSONS;
    Configs.RECORDS;
    Configs.PETS;

    _login();

    Future.delayed(Duration.zero, () {
      Navigator.of(context).pushNamed(RouteName.splash).then((value) {
        //未同意隐私政策不加载页面
        setState(() {
          _isAgree = true;
        });

        // /// 启动接口
        // FIZZApi.requestStartConfig().then((value) {
        //   UserHelper().appConfig = value;
        //
        // });
        /// 启动接口
        // FIZZApi.requestStartConfig().then((value) {
        //   UserHelper().appConfig = value;
        //   if (Platform.isAndroid) {
        //     if (value != null && value.messageInfos != null) {
        //       if (value.messageInfos.messageType == 1 ||
        //           value.messageInfos.messageType == 2) {
        //         DialogHelper.showStartUpdateDialog(
        //             context, value.messageInfos); //更新
        //       }
        //     }
        //   }
        // });
      });
    });

    super.initState();
  }

  List<Widget> pages = [
    HomePage(),
    RecentPage(),
    MinePage(),
  ];

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double height = screenHeight * 375 / screenWidth;
    ScreenUtil.instance = ScreenUtil(width: 375, height: height.toInt())
      ..init(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: WillPopScope(
        onWillPop: () async {
          return backApp();
        },
        child: IndexedStack(
          index: _selectedIndex,
          children: _isAgree ? pages : [],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        shape: CircularNotchedRectangle(),
        child: Padding(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Expanded(
                // Expanded包一下，可以撑满剩余空间
                child: _initBottomItem(
                  0,
                  activeIcon: 'tab_home_active.png',
                  icon: 'tab_home_normal.png',
                ),
              ),
              Expanded(
                child: _initBottomItem(
                  1,
                  activeIcon: 'tab_document_active.png',
                  icon: 'tab_document_normal.png',
                  name: JYLocalizations.localizedString('文档'),
                ),
              ),
              Expanded(
                child: _initBottomItem(
                  2,
                  activeIcon: 'tab_mine_active.png',
                  icon: 'tab_mine_normal.png',
                  name: JYLocalizations.localizedString('我的'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Future<bool> backApp() async {
    if (_lastPressed == null ||
        DateTime.now().difference(_lastPressed) > Duration(seconds: 1)) {
      //两次点击间隔超过1秒则重新计时
      showToast('再按一次退出应用');
      _lastPressed = DateTime.now();
      return false;
    }

    return true;
  }

  void _selectItem(int index) {
    if (index == 0 && _selectedIndex == 1) {
      BuriedPointHelper.clickBuriedPoint(
        pageName: "我的页面",
        clickName: "首页",
      );
    } else if (index == 1 && _selectedIndex == 0) {
      BuriedPointHelper.clickBuriedPoint(
        pageName: "首页",
        clickName: "我的页面",
      );
    }
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _initBottomItem(int index,
      {String activeIcon,
      String icon,
      String name,
      bool needShowRedPoint = false}) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        _selectItem(index);
      },
      child: Container(
        decoration: _selectedIndex == index
            ? BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: ColorHelper.colors_HomeGradient),
              )
            : BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: ColorHelper.colors_HomeWhites),
              ),
        height: ScreenUtil().setHeight(57),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: ScreenUtil().setHeight(10)),
              child: Image.asset(
                ImageHelper.imageRes(
                    _selectedIndex == index ? activeIcon : icon),
              ),
              width: ScreenUtil().setWidth(30),
              height: ScreenUtil().setHeight(30),
            ),
            Container(
              margin: EdgeInsets.only(top: ScreenUtil().setHeight(15)),
              child: Divider(
                  height: 2,
                  thickness: 4,
                  color: _selectedIndex == index
                      ? Color(0xFF00C27C)
                      : Color(0xFFFFFFFF)),
            ),
          ],
        ),
      ),
    );
  }

  void _login() {
    if (UserHelper().bmobUserVM.hasUser) {
      BmobUser local = UserHelper().bmobUserVM.bmobUserModel;
      BmobUser user = local;
      user.username = local.username;
      user.password = local.password;
      user.login().then((BmobUser bmobUser) {
        // showSuccess(context, bmobUser.getObjectId() + "\n" + bmobUser.username);
        bmobUser.password=local.password;
        UserHelper().bmobUserVM.bmobUserModel = bmobUser;
      });
    }
  }
}
