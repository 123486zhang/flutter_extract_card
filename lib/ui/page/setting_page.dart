import 'dart:io';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graphic_conversion/locatization/localizations.dart';
import 'package:graphic_conversion/ui/widget/navigator_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:graphic_conversion/view_model/bmob_user_view_model.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'package:graphic_conversion/channel/android_method_channel.dart';
import 'package:graphic_conversion/channel/ios_method_channel.dart';
import 'package:graphic_conversion/configs.dart';
import 'package:graphic_conversion/router/router_config.dart';
import 'package:graphic_conversion/ui/helper/buried_point_helper.dart';
import 'package:graphic_conversion/ui/helper/dialog_helper.dart';
import 'package:graphic_conversion/ui/helper/resoure_helper.dart';
import 'package:graphic_conversion/ui/helper/user_helper.dart';
import 'package:graphic_conversion/ui/widget/mine_setting_item.dart';
import 'package:graphic_conversion/ui/widget/navigation_back_button.dart';
import 'package:graphic_conversion/utils/common_utils.dart';
import 'package:graphic_conversion/utils/string_utils.dart';
import 'package:graphic_conversion/view_model/user_view_model.dart';
import 'package:graphic_conversion/data/net/fizz_api.dart';

class SettingPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SettingPageState();
  }
}

class SettingPageState extends State<SettingPage> {
  String yszc = Configs.URL_YSZC;
  String yhxy = Configs.URL_YHXY;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF6F6F9),
      appBar: AppBar(
        backgroundColor: Color(0xFFFFFFFF),
        leading: NabigationBackButton.back(context),
        centerTitle: true,
        elevation: 0.5,
        title: NavigatorTitle(
          title: "更多设置",
        ),
      ),
      body: SafeArea(
        child: Consumer<BmobUserViewModel>(
          builder: (context, userVM, child) {
            return Stack(
              children: [
                ListView(
                  children: [
                    Container(
                      margin: EdgeInsets.only(
                          top: ScreenUtil().setHeight(15),
                          left: ScreenUtil().setWidth(15),
                          right: ScreenUtil().setWidth(15)),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                      child: Column(
                        children: <Widget>[
                          // MineSettingItem(
                          //   title: '检查更新',
                          //   icon: ImageHelper.imageRes('mine_check_update.png'),
                          //   onTap: () async {
                          //     BuriedPointHelper.clickBuriedPoint(
                          //       pageName: "设置页面",
                          //       clickName: "检查更新",
                          //     );
                          //     if (!await CommonUtils.isNetConnected()) {
                          //       showToast('请确认网络连接！');
                          //       return;
                          //     }
                          //     if (Platform.isIOS) {
                          //       CommonUtils.openMarket();
                          //     } else {
                          //       if (!CommonUtils.isFastClick()) {
                          //         FIZZApi.requestCheckUpdate().then((onValue) {
                          //           if (onValue != null &&
                          //               (onValue.messageType == 1 ||
                          //                   onValue.messageType == 2)) {
                          //             DialogHelper.showCheckUpdateDialog(
                          //                 context, onValue);
                          //           } else {
                          //             showToast('已经是最新版本!');
                          //           }
                          //         });
                          //       }
                          //     }
                          //   },
                          // ),
                          // MineSettingItem(
                          //   title: '用户协议',
                          //   icon:
                          //   ImageHelper.imageRes('mine_user_agreement.png'),
                          //   onTap: () async {
                          //     if (!await CommonUtils.isNetConnected()) {
                          //       showToast('请确认网络连接！');
                          //       return;
                          //     }
                          //     Navigator.of(context).pushNamed(RouteName.webview,
                          //         arguments: {'title': '用户协议', 'url': yhxy});
                          //   },
                          // ),
                          // MineSettingItem(
                          //   title: '隐私政策',
                          //   icon:
                          //   ImageHelper.imageRes('mine_privacy_policy.png'),
                          //   onTap: () async {
                          //     if (!await CommonUtils.isNetConnected()) {
                          //       showToast('请确认网络连接！');
                          //       return;
                          //     }
                          //     Navigator.of(context).pushNamed(RouteName.webview,
                          //         arguments: {'title': '隐私政策', 'url': yszc});
                          //   },
                          // ),
                          // if (userVM.hasUser)
                          //   Offstage(
                          //     offstage: Platform.isIOS,
                          //     child: MineSettingItem(
                          //       title: '用户参与和用户反馈',
                          //       icon: ImageHelper.imageRes('mine_report.png'),
                          //       onTap: () {
                          //         Navigator.of(context)
                          //             .pushNamed(RouteName.report_info_page);
                          //       },
                          //     ),
                          //   ),
                          MineSettingItem(
                            title: '关于我们',
                            icon: ImageHelper.imageRes('mine_about_us.png'),
                            onTap: () {
                              Navigator.of(context)
                                  .pushNamed(RouteName.aboutus);
                            },
                          ),
                          Offstage(
                            offstage: !userVM.hasUser,
                            child: MineSettingItem(
                              hideDivider: true,
                              title: '注销账号',
                              icon: ImageHelper.imageRes(
                                  'mine_cancel_account.png'),
                              onTap: () async {
                                if (!await CommonUtils.isNetConnected()) {
                                  showToast('请确认网络连接！');
                                  return;
                                }
                                Future.delayed(Duration.zero, () {
                                  DialogHelper.showUnsubscribeDialog(context);
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: ScreenUtil().setHeight(20),
                    ),
                    InkWell(
                      onTap: () async {
                        if (!await CommonUtils.isNetConnected()) {
                          showToast('请确认网络连接!');
                          return;
                        }
                        if (userVM.hasUser) {
                          DialogHelper.showLogOutDialog(context);
                        } else {
                          Navigator.of(context).pushNamed(RouteName.login);
                        }
                      },
                      child: Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.symmetric(
                            horizontal: ScreenUtil().setWidth(15)),
                        height: ScreenUtil().setHeight(45),
                        decoration: BoxDecoration(
                            color: userVM.hasUser
                                ? Colors.white
                                : Color(0xFF00C27C),
                            borderRadius:
                            BorderRadius.all(Radius.circular(10))),
                        child: TextHelper.TextCreateWith(
                            text: userVM.hasUser ? '退出登录' : '登录',
                            color: userVM.hasUser
                                ? Color(0xFFFF2929)
                                : Colors.white,
                            fontSize: 17),
                      ),
                    )
                  ],
                ),
                // Positioned(
                //   bottom: ScreenUtil().setHeight(15),
                //   left: 0,
                //   right: 0,
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.center,
                //     children: [
                //       TextHelper.TextCreateWith(
                //         text: "扫图识字",
                //         fontSize: 13,
                //         color: ColorHelper.color_666,
                //       ),
                //       Container(
                //         margin: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(30)),
                //         width: 0.5,
                //         height: ScreenUtil().setHeight(10),
                //         color: Color(0xFFBBBBBB),
                //       ),
                //       TextHelper.TextCreateWith(
                //         text: JYLocalizations.localizedString("版本号")+" v${Configs.versionName}",
                //         fontSize: 13,
                //         color: ColorHelper.color_666,
                //       )
                //     ],
                //   ),
                // ),
              ],
            );
          },
        ),
      ),
    );
  }
}
