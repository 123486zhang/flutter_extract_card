import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluwx/fluwx.dart' as fluwx;
import 'package:graphic_conversion/data/local_storage/storage_manager.dart';
import 'package:graphic_conversion/event/any_event.dart';
import 'package:graphic_conversion/event/event_bus_util.dart';
import 'package:graphic_conversion/ui/helper/dialog_helper.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'package:graphic_conversion/data/net/fizz_api.dart';
import 'package:graphic_conversion/model/wx_user.dart';
import 'package:graphic_conversion/ui/helper/user_helper.dart';
import 'package:graphic_conversion/utils/common_utils.dart';
import 'package:graphic_conversion/view_model/provider/provider_manager.dart';
import 'package:graphic_conversion/view_model/user_view_model.dart';

import '../../main.dart';

var wxDio = new Dio();

const String appId = 'wxb2f3207d0a4e734f';
const String appSecret = '3f38a814c3c80f802da92be855ec30a0';
const String universalLink = 'https://wsv1.fuguizhukj.cn/photoscan/';

class WxApi {
 static init() async {
   fluwx.registerWxApi(
       appId: appId,
       universalLink: universalLink,
       doOnIOS: true,
       doOnAndroid: true);
   UserHelper().iOSCanOpenWX = await fluwx.isWeChatInstalled;
   debugPrint("is installed ${UserHelper().iOSCanOpenWX}");

   listenWeChatResponseEventHandler();
 }

 static listenWeChatResponseEventHandler() {
   print("wechat listen1");
   fluwx.weChatResponseEventHandler.distinct((a, b) => a == b).listen((res) {
     if (res is fluwx.WeChatAuthResponse) {
       EasyLoading.dismiss();
       int errCode = res.errCode;
       debugPrint('微信登录返回值：ErrCode :$errCode  code:${res.code}');
       if (errCode == 0) {
         String code = res.code;
         WxApi.getUserInfo(code).then((value) {
           EasyLoading.show();
           print("wechat listen2");
           FIZZApi.requestWeChatLogin(value).then((value) async {
             if (value != null) {
               UserViewModel userVM = Provider.of<UserViewModel>(rootContext, listen: false);
               userVM.userModel = value;
               UserHelper().documentVM.init();
               await userVM.getUserInfo();
               EasyLoading.dismiss();
               Navigator.of(navigatorContext).pop();
               EventBusUtil.getInstance().fire(AnyEvent(AnyEvent.REFRESH_VIP));
               showToast('登录成功！');
               bool isFirstPop=StorageManager.sharedPreferences.getBool("isFirstPop");
               if(isFirstPop==null){
                 isFirstPop=true;
               }
               if((isFirstPop)&&(userVM.userModel.mobile==null||userVM.userModel.mobile.length==0)){
                 DialogHelper.showBindPhoneDialog(navigatorContext);
                 StorageManager.sharedPreferences.setBool("isFirstPop",false);
               }
             } else {
               EasyLoading.dismiss();
             }
           });
         });
       } else if (errCode == -4) {
         showToast("用户拒绝授权");
       } else if (errCode == -2) {
         showToast("用户取消授权");
       }
     }
   });
 }

 static sendWeChatAuth() {
   debugPrint('sendWeChatAuth=>-----------------');
   fluwx
       .sendWeChatAuth(scope: "snsapi_userinfo", state: "wechat_sdk_demo_test")
       .then((data) {
     debugPrint('sendWeChatAuth=>${data.toString()}');
   });
 }


 // access_token->  {
// "access_token":"30_g94qgPk8mDlG7EFZtaKe8QS-_5rj9MEqkLaoNgjPBQp7WHmo2W0oCnHT3x-FqQcdptWerLTxWweKegjcZZOYFviNY5Ns1gbrFgjLs8J1plA",
// "expires_in":7200,
// "refresh_token":"30_UmaAh1wuiW46erRTDDAeETGXB5fBU-tQ_p9FlhdJX7gZBkU3KRXo9i3b32ETn1g8VmUgku92yJn_5da0kfhCtRsK1MpgQCq-32J0lYQPWX0",
// "openid":"oGcVjwKpGvX8BC4GRGoib_wyhV8A",
// "scope":"snsapi_userinfo",
// "unionid":"omRZhwiWuYnIJo4m4R4QiitbDhJw"
// }

// userinfo->  {
// "openid":"oGcVjwKpGvX8BC4GRGoib_wyhV8A",
// "nickname":"喝粥不加糖",
// "sex":2,
// "language":"zh_CN",
// "city":"朝阳",
// "province":"北京",
// "country":"中国",
// "headimgurl":"http:\/\/thirdwx.qlogo.cn\/mmopen\/vi_32\/Q0j4TwGTfTJKzIcE9GD5BViacSj2azXaADibCCLQz7t6CQiazVj9v5d4ymrtz9wMOmL4kK7ECpuzN8jysTgRUf7hg\/132",
// "privilege":[],
// "unionid":"omRZhwiWuYnIJo4m4R4QiitbDhJw"
// }
 static Future<WeChatUser> getUserInfo(String code) async {
   debugPrint('code->$code');

   var accessTokenResponse = await wxDio.post(
     'https://api.weixin.qq.com/sns/oauth2/access_token',
     queryParameters: {
       'appid': appId,
       'secret': appSecret,
       'code': code,
       'grant_type': 'authorization_code',
     },
   );

   var accessToken = jsonDecode(accessTokenResponse.data);
   debugPrint('getAccessToken->$accessToken');

   if (accessToken['errcode'] != null) {
     return null;
   }

   String token = accessToken['access_token'];
   String openid = accessToken['openid'];

   var userInfoResponse = await wxDio.post(
     'https://api.weixin.qq.com/sns/userinfo',
     queryParameters: {
       'access_token': token,
       'openid': openid,
       'lang': 'zh_CN', //国家地区语言版本，zh_CN 简体，zh_TW 繁体，en 英语，默认为 zh-CN
     },
   );

   var userInfo = jsonDecode(userInfoResponse.data);

   debugPrint('getUserInfo->$userInfo');

   if (userInfo['errcode'] != null) {
     return null;
   }

   WeChatUser wxUser = WeChatUser();
   wxUser.unionId = accessToken['unionid'];
   wxUser.openId = accessToken['openid'];
   wxUser.accessToken = accessToken['access_token'];
   wxUser.refreshToken = accessToken['refresh_token'];
   wxUser.expires_in = accessToken['expires_in'];

   wxUser.name = userInfo['nickname'];
   wxUser.iconurl = userInfo['headimgurl'];
   wxUser.country = userInfo['country'];
   wxUser.city = userInfo['city'];
   wxUser.province = userInfo['province'];
   wxUser.language = userInfo['language'];
   wxUser.gender = userInfo['sex'].toString();

   debugPrint('wxUser->${wxUser.toJson()}');

   return wxUser;
 }

}
