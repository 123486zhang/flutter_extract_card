import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:data_plugin/bmob/bmob_query.dart';
import 'package:data_plugin/bmob/response/bmob_updated.dart';
import 'package:data_plugin/bmob/table/bmob_user.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graphic_conversion/channel/android_method_channel.dart';
import 'package:graphic_conversion/channel/ios_method_channel.dart';
import 'package:graphic_conversion/configs.dart';
import 'package:graphic_conversion/data/local_storage/storage_manager.dart';
import 'package:graphic_conversion/event/any_event.dart';
import 'package:graphic_conversion/event/event_bus_util.dart';
import 'package:graphic_conversion/locatization/localizations.dart';
import 'package:graphic_conversion/model/buried_point_model.dart';
import 'package:graphic_conversion/ui/helper/dialog_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluwx/fluwx.dart';
import 'package:graphic_conversion/ui/helper/user_helper.dart';
import 'package:graphic_conversion/view_model/bmob_user_view_model.dart';
import 'package:graphic_conversion/view_model/document_view_model.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'package:graphic_conversion/data/net/wx_api.dart';
import 'package:graphic_conversion/router/router_config.dart';
import 'package:graphic_conversion/ui/helper/buried_point_helper.dart';
import 'package:graphic_conversion/ui/helper/resoure_helper.dart';
import 'package:graphic_conversion/table/sign_in.dart';
import 'package:graphic_conversion/ui/widget/mine_setting_item.dart';
import 'package:graphic_conversion/utils/common_utils.dart';

class MinePage extends StatefulWidget {
  @override
  _MinePageState createState() => _MinePageState();
}

class _MinePageState extends State<MinePage> {
  StreamSubscription listen;
  List<String> headImages = [
    'head1.png',
    'head2.png',
    'head3.png',
    'head4.png',
    'head5.png',
    'head6.png',
    'head7.png',
    'head8.png',
    'head9.png',
    'head10.png',
    'head11.png',
    'head12.png',
    'head13.png',
    'head14.png',
    'head15.png',
    'head16.png',
    'head17.png',
    'head18.png',
    'ic_img1.png',
    'ic_img2.png',
    'ic_img3.png',
    'ic_img4.png',
    'ic_img5.png',
    'ic_img6.png',
    'ic_img7.png',
    'ic_img8.png',
    'ic_img9.png',
    'ic_img10.png',
    'ic_img11.png',
    'ic_img12.png'
  ];

  List<String> backImages = [
    'img_1.png',
    'img_2.png',
    'img_3.png',
    'img_4.png',
    'img_5.png',
    'img_6.png',
    'img_7.png',
    'img_8.png',
  ];

  String _image;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    listen = EventBusUtil.listener<AnyEvent>((event) {
      switch (event.type) {
        case AnyEvent.REFRESH_VIP:
          UserHelper.instance.userVM.getUserInfo();
          setState(() {});
          break;
        case AnyEvent.REFRESH_HEAD:
          UserHelper.instance.userVM.getUserInfo();
          setState(() {});
          break;
      }
    });

    BmobUserViewModel userVM =
        Provider.of<BmobUserViewModel>(context, listen: false);

    // if (headId == null || headId == 0) {
    //   headId = Random().nextInt(headImages.length);
    //   BmobUser local = UserHelper().bmobUserVM.bmobUserModel;
    //   local.headId = headId;
    //   local.update().then((BmobUpdated bmobUpdated) {
    //     UserHelper().bmobUserVM.bmobUserModel = local;
    //   }).catchError((e) {});
    //
    //   setState(() {
    //     _image = headImages[headId];
    //   });
    // } else {
    //   setState(() {
    //     _image = headImages[headId];
    //   });
    // }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    BuriedPointHelper.addBuriedPoint(
      eventType: BuriedPointEventType.PAGE_HIDE,
      pageName: "我的页面",
    );
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: Platform.isAndroid
          ? SystemUiOverlayStyle(statusBarColor: Colors.transparent)
          : SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: Color(0xFFFFFFFF),
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                Stack(
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (!UserHelper().bmobUserVM.hasUser) {
                          Navigator.of(context).pushNamed(RouteName.login);
                        } else {
                          Navigator.of(context)
                              .pushNamed(RouteName.back_select_page);
                        }
                      },
                      child: Container(
                        child: UserHelper().bmobUserVM.hasUser &&
                                UserHelper().bmobUserVM.bmobUserModel.backId !=
                                    -1
                            ? Image.asset(
                                ImageHelper.imageRes(backImages[UserHelper()
                                    .bmobUserVM
                                    .bmobUserModel
                                    .backId]),
                                fit: BoxFit.fill,
                                width: ScreenUtil().setWidth(375),
                                height: ScreenUtil().setHeight(268),
                              )
                            : Image.asset(
                                ImageHelper.imageRes("home_top_bg1.png"),
                                width: ScreenUtil().setWidth(375),
                                height: ScreenUtil().setHeight(268),
                                fit: BoxFit.fill,
                              ),
                      ),
                    ),
                    Positioned(left: 0, top: 0, child: buildUserInfo()),
                    Positioned(
                        bottom: 25,
                        left: 0,
                        right: 0,
                        child: buildVipContent()),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        width: ScreenUtil().setWidth(375),
                        height: ScreenUtil().setHeight(25),
                        decoration: BoxDecoration(
                          color: Color(0xFFFFFFFF),
                          // border: Border.all(color: Color(0x33FFFFFF), width: 2),
                        ),
                      ),
                    ),
                    Positioned(
                        bottom: 1,
                        left: 0,
                        right: 0,
                        child: Image.asset(
                          ImageHelper.imageRes("icon_trangle_bottom.png"),
                          width: ScreenUtil().setWidth(35),
                          height: ScreenUtil().setHeight(25),
                        )),
                  ],
                ),
                buildMineType(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildUserInfo() {
    return Consumer<BmobUserViewModel>(builder: (ctx, userVM, child) {
      if (userVM.hasUser) {}
      return InkWell(
        onTap: () {
          if (userVM.hasUser) {
            return;
          }
          Navigator.of(context).pushNamed(RouteName.login);
        },
        child: Container(
          // margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 40),
          padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(15)),
          child: Row(
            children: [
              GestureDetector(
                onTap: () {
                  if (!userVM.hasUser) {
                    Navigator.of(context).pushNamed(RouteName.login);
                  } else {
                    Navigator.of(context).pushNamed(RouteName.head_select_page);
                  }
                },
                child: Container(
                  margin: EdgeInsets.only(top: ScreenUtil().setHeight(74)),
                  width: ScreenUtil().setWidth(60),
                  height: ScreenUtil().setHeight(60),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                    // border: userVM.hasUser
                    //     ? Border.all(color: Color(0xFFFFFFFF), width: 1)
                    //     : Border.all(color: Color(0xFFFFFFFF), width: 0)
                    // border: Border.all(color: Color(0x33FFFFFF), width: 2),
                  ),
                  child: ClipOval(
                    child: userVM.hasUser && userVM.bmobUserModel.headId != -1
                        ? Image.asset(
                            ImageHelper.imageRes(
                                headImages[userVM.bmobUserModel.headId]),
                            fit: BoxFit.fill,
                            width: ScreenUtil().setWidth(60),
                            height: ScreenUtil().setHeight(60),
                          )
                        : Image.asset(
                            ImageHelper.imageRes('mine_header_default.png')),
                  ),
                ),
              ),
              SizedBox(
                width: ScreenUtil().setWidth(15),
              ),
              Container(
                margin: EdgeInsets.only(top: ScreenUtil().setHeight(74)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userVM.hasUser
                          ? userVM.bmobUserModel.username
                          : JYLocalizations.localizedString("立即登录"),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: ScreenUtil().setSp(19),
                          fontWeight: FontWeight.w600),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: ScreenUtil().setHeight(5)),
                      child: Text(
                        userVM.hasUser
                            ? 'ID：${userVM.bmobUserModel.objectId} Coins:${userVM.bmobUserModel.coins}'
                            : '登录后使用更多功能',
                        style: TextStyle(
                          color: Color(0xFFFFFFFF),
                          fontSize: ScreenUtil().setSp(15),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget buildVipContent() {
    return Consumer<BmobUserViewModel>(builder: (ctx, userVM, child) {
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () async {
          if (Platform.isIOS) {
            Navigator.of(context)
                .pushNamed(RouteName.vip_apple_page, arguments: {
              "isBack": false,
            });
          } else {
            if (!await CommonUtils.isLogin(context)) return;
            Navigator.of(context)
                .pushNamed(RouteName.vip_android_page, arguments: {
              "from": -1,
            });
          }
        },
        child: Container(
          height: ScreenUtil().setHeight(86),
          child: Stack(
            children: [
              Container(
                margin:
                    EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(15)),
                height: ScreenUtil().setHeight(86),
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: ColorHelper.colors_VipGradient),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15))),
              ),
              Container(
                alignment: Alignment.center,
                child: Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: ScreenUtil().setWidth(35)),
                      child: Image.asset(
                        ImageHelper.imageRes("mine_vip_icon.png"),
                        width: ScreenUtil().setWidth(24),
                        height: ScreenUtil().setHeight(24),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: ScreenUtil().setWidth(15)),
                      child: TextHelper.TextCreateWith(
                          text: userVM.hasUser && !userVM.isExpire
                              ? '您的会员${userVM.vipEndAt.substring(0,10)}到期'
                              : '立即开通 · VIP会员',
                          color: Color(0xffe9cf9e),
                          fontSize: ScreenUtil().setSp(16),
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(
                    left: ScreenUtil().setWidth(262),
                    top: ScreenUtil().setHeight(29)),
                width: ScreenUtil().setWidth(88),
                height: ScreenUtil().setHeight(32),
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: ColorHelper.colors_OpenVipGradient),
                    borderRadius: BorderRadius.all(Radius.circular(16))),
                child: TextHelper.TextCreateWith(
                    text: '查看特权',
                    color: Color(0xFF311708),
                    fontSize: ScreenUtil().setSp(13),
                    fontWeight: FontWeight.bold),
              ),
              // Container(
              //   margin: EdgeInsets.only(
              //       top: ScreenUtil().setHeight(54),
              //       left: ScreenUtil().setWidth(35)),
              //   child: TextHelper.TextCreateWith(
              //       text: userVM.hasUser
              //           ? '永久会员'
              //           : '点亮会员标志，享受尊贵特权',
              //       color: Color(0xFFC0C6D2),
              //       fontSize: ScreenUtil().setSp(13),
              //       fontWeight: FontWeight.w400),
              // ),
            ],
          ),
        ),
      );
    });
  }

  Widget buildMineType() {
    return Consumer<BmobUserViewModel>(builder: (ctx, userVM, child) {
      return Container(
        margin: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(15)),
        decoration: BoxDecoration(
            color: Color(0xFFFFFFFF),
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Column(
          children: [
            // MineSettingItem(
            //   title: '客服中心',
            //   icon: ImageHelper.imageRes('mine_contact_service.png'),
            //   onTap: () async {
            //     BuriedPointHelper.clickBuriedPoint(
            //       pageName: "我的页面",
            //       clickName: "客服中心",
            //     );
            //     if (!await CommonUtils.isNetConnected()) {
            //       showToast('请确认网络连接！');
            //       return;
            //     }
            //
            //     var token = "";
            //     var phone = "";
            //     var nickName = "";
            //     var version = '${Configs.PRODUCT_ID}';
            //     if (userVM.hasUser) {
            //       token = StringUtils.getStringValue(userVM.userModel.userId);
            //       phone = StringUtils.getStringValue(userVM.userModel.mobile);
            //       nickName =
            //           StringUtils.getStringValue(userVM.userModel.nickName);
            //     }
            //     if (Platform.isIOS) {
            //       IOSMethodChannel.connetUs(
            //         token: token,
            //         phone: phone,
            //         nickName: nickName,
            //         version: version,
            //       );
            //     } else {
            //       CommonUtils.checkPermission(context, "存储").then((value) {
            //         if (value) {
            //           AndroidMethodChannel.startKf();
            //         }
            //       });
            //     }
            //   },
            // ),
            MineSettingItem(
              title: '签到',
              icon: ImageHelper.imageRes('mine_feedback_suggestions.png'),
              onTap: () async {
                if (!await CommonUtils.isLogin(context)) return;
                if (!await CommonUtils.isNetConnected()) {
                  showToast('请确认网络连接！');
                  return;
                }
                _goSignIn();
              },
            ),
            Offstage(
              offstage: false,
              child: MineSettingItem(
                icon: ImageHelper.imageRes("mine_free_use.png"),
                title: "免费使用",
                onTap: () async {
                  BuriedPointHelper.clickBuriedPoint(
                    pageName: "我的页面",
                    clickName: "免费使用",
                  );
                  if (!await CommonUtils.isLogin(context)) return;
                  Navigator.of(context).pushNamed(RouteName.g_page);
                },
              ),
            ),

            if (userVM.bmobUserModel.isAdmin != null &&
                userVM.bmobUserModel.isAdmin)
              MineSettingItem(
                icon: ImageHelper.imageRes("mine_free_use.png"),
                title: "添加免费码",
                onTap: () async {
                  if (!await CommonUtils.isLogin(context)) return;
                  Navigator.of(context).pushNamed(RouteName.add_g_page);
                },
              ),
            // Offstage(
            //   offstage: true,
            //   child: MineSettingItem(
            //     icon: ImageHelper.imageRes("mine_Invite_friends.png"),
            //     title: "分享我们",
            //     onTap: () {
            //       BuriedPointHelper.clickBuriedPoint(
            //         pageName: "我的页面",
            //         clickName: "分享我们",
            //       );
            //       _shareWeChat();
            //     },
            //   ),
            // ),
            MineSettingItem(
                icon: ImageHelper.imageRes("mine_bind_phone.png"),
                title: "绑定手机号",
                hideDivider: true,
                onTap: () {
                  if (!UserHelper().bmobUserVM.hasUser) {
                    Navigator.of(context).pushNamed(RouteName.login);
                  } else {
                    BuriedPointHelper.clickBuriedPoint(
                      pageName: "我的页面",
                      clickName: "绑定手机号",
                    );
                    Navigator.of(context).pushNamed(RouteName.bind_phone_page);
                  }
                }),
            MineSettingItem(
              icon: ImageHelper.imageRes("mine_setting.png"),
              title: "更多设置",
              hideDivider: true,
              onTap: () {
                BuriedPointHelper.clickBuriedPoint(
                  pageName: "我的页面",
                  clickName: "更多设置",
                );
                Navigator.of(context).pushNamed(RouteName.setting);
              },
            ),
          ],
        ),
      );
    });
  }

  _goSignIn() {
    BmobUser local = UserHelper.instance.bmobUserVM.bmobUserModel;
    BmobQuery<SignIn> query = BmobQuery();
    query.addWhereEqualTo("user", local);
    query.queryObjects().then((data) {
      // showSuccess(context, data.toString());
      List<SignIn> sign = data.map((i) => SignIn().fromJsons(i)).toList();
      if (sign == null || sign.length == 0) {
        int weekday = DateTime.now().weekday - 1;
        SignIn mySign = SignIn();
        mySign.mon = false;
        mySign.tue = false;
        mySign.web = false;
        mySign.thur = false;
        mySign.fri = false;
        mySign.sat = false;
        mySign.sun = false;
        switch (weekday) {
          case 0:
            mySign.mon = true;
            break;
          case 1:
            mySign.tue = true;
            break;
          case 2:
            mySign.web = true;
            break;
          case 3:
            mySign.thur = true;
            break;
          case 4:
            mySign.fri = true;
            break;
          case 5:
            mySign.sat = true;
            break;
          case 6:
            mySign.sun = true;
            break;
        }

        if (local.isVip) {
          local.coins += 500;
        } else {
          local.coins += 100;
        }

        mySign.user = local;

        local.update().then((BmobUpdated bmobUpdated) {
          UserHelper().bmobUserVM.bmobUserModel = local;
          mySign.save().then((value) {
            showToast('签到成功');
            setState(() {});
          });
        }).catchError((e) {
          showToast('签到失败');
        });
      } else {
        SignIn mySign = sign[0];
        int weekday = DateTime.now().weekday - 1;
        switch (weekday) {
          case 0:
            if (mySign.mon) {
              showToast('不能重复签到');
            } else {
              mySign.tue = false;
              mySign.web = false;
              mySign.thur = false;
              mySign.fri = false;
              mySign.sat = false;
              mySign.sun = false;
              mySign.mon = true;

              if (local.isVip) {
                local.coins += 500;
              } else {
                local.coins += 100;
              }

              mySign.user = local;
              local.update().then((BmobUpdated bmobUpdated) {
                UserHelper().bmobUserVM.bmobUserModel = local;
                mySign.update().then((value) {
                  showToast('签到成功');
                  setState(() {});
                });
              }).catchError((e) {
                showToast('签到失败');
              });
            }
            break;
          case 1:
            if (mySign.tue) {
              showToast('不能重复签到');
            } else {
              mySign.tue = true;
              mySign.web = false;
              mySign.thur = false;
              mySign.fri = false;
              mySign.sat = false;
              mySign.sun = false;
              mySign.mon = false;

              if (local.isVip) {
                local.coins += 500;
              } else {
                local.coins += 100;
              }

              mySign.user = local;
              local.update().then((BmobUpdated bmobUpdated) {
                UserHelper().bmobUserVM.bmobUserModel = local;
                mySign.update().then((value) {
                  showToast('签到成功');
                  setState(() {});
                });
              }).catchError((e) {
                showToast('签到失败');
              });
            }
            break;
          case 2:
            if (mySign.web) {
              showToast('不能重复签到');
            } else {
              mySign.tue = false;
              mySign.web = true;
              mySign.thur = false;
              mySign.fri = false;
              mySign.sat = false;
              mySign.sun = false;
              mySign.mon = false;

              if (local.isVip) {
                local.coins += 500;
              } else {
                local.coins += 100;
              }

              mySign.user = local;
              local.update().then((BmobUpdated bmobUpdated) {
                UserHelper().bmobUserVM.bmobUserModel = local;
                mySign.update().then((value) {
                  showToast('签到成功');
                  setState(() {});
                });
              }).catchError((e) {
                showToast('签到失败');
              });
            }
            break;
          case 3:
            if (mySign.thur) {
              showToast('不能重复签到');
            } else {
              mySign.tue = false;
              mySign.web = false;
              mySign.thur = true;
              mySign.fri = false;
              mySign.sat = false;
              mySign.sun = false;
              mySign.mon = false;

              if (local.isVip) {
                local.coins += 500;
              } else {
                local.coins += 100;
              }

              mySign.user = local;
              local.update().then((BmobUpdated bmobUpdated) {
                UserHelper().bmobUserVM.bmobUserModel = local;
                mySign.update().then((value) {
                  showToast('签到成功');
                  setState(() {});
                });
              }).catchError((e) {
                showToast('签到失败');
              });
            }
            break;
          case 4:
            if (mySign.fri) {
              showToast('不能重复签到');
            } else {
              mySign.tue = false;
              mySign.web = false;
              mySign.thur = false;
              mySign.fri = true;
              mySign.sat = false;
              mySign.sun = false;
              mySign.mon = false;

              if (local.isVip) {
                local.coins += 500;
              } else {
                local.coins += 100;
              }

              mySign.user = local;
              local.update().then((BmobUpdated bmobUpdated) {
                UserHelper().bmobUserVM.bmobUserModel = local;
                mySign.update().then((value) {
                  showToast('签到成功');
                  setState(() {});
                });
              }).catchError((e) {
                showToast('签到失败');
              });
            }
            break;
          case 5:
            if (mySign.sat) {
              showToast('不能重复签到');
            } else {
              mySign.tue = false;
              mySign.web = false;
              mySign.thur = false;
              mySign.fri = false;
              mySign.sat = true;
              mySign.sun = false;
              mySign.mon = false;

              if (local.isVip) {
                local.coins += 500;
              } else {
                local.coins += 100;
              }

              mySign.user = local;
              local.update().then((BmobUpdated bmobUpdated) {
                UserHelper().bmobUserVM.bmobUserModel = local;
                mySign.update().then((value) {
                  showToast('签到成功');
                  setState(() {});
                });
              }).catchError((e) {
                showToast('签到失败');
              });
            }
            break;
          case 6:
            if (mySign.sun) {
              showToast('不能重复签到');
            } else {
              mySign.tue = false;
              mySign.web = false;
              mySign.thur = false;
              mySign.fri = false;
              mySign.sat = false;
              mySign.sun = true;
              mySign.mon = false;

              if (local.isVip) {
                local.coins += 500;
              } else {
                local.coins += 100;
              }

              mySign.user = local;
              local.update().then((BmobUpdated bmobUpdated) {
                UserHelper().bmobUserVM.bmobUserModel = local;
                mySign.update().then((value) {
                  showToast('签到成功');
                  setState(() {});
                });
              }).catchError((e) {
                showToast('签到失败');
              });
            }
            break;
        }
      }
    }).catchError((e) {
      showToast('网络错误');
    });
  }
}
