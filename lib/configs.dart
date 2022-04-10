import 'dart:io';

import 'package:data_plugin/bmob/bmob_query.dart';
import 'package:flutter/cupertino.dart';
import 'package:graphic_conversion/table/person.dart';
import 'package:graphic_conversion/table/record.dart';
import 'package:graphic_conversion/ui/helper/user_helper.dart';
import 'package:graphic_conversion/view_model/provider/provider_manager.dart';
import 'package:package_info/package_info.dart';
import 'package:graphic_conversion/channel/android_method_channel.dart';
import 'package:graphic_conversion/channel/ios_method_channel.dart';

import 'locatization/localizations.dart';

class Configs {
  static const String URL_YSZC_ZH = '';
  static const String URL_YHXY_ZH = '';
  static const String URL_YSZC_EN = '';
  static const String URL_YHXY_EN = '';

  static const String URL_ZDXFXY_ZH = '';
  static const String URL_ZDXFXY_EN = '';

  static String URL_FEEDBOOK_ZH = '';
  static const String URL_FEEDBOOK_EN = '';

  static const int PRODUCT_ID = 163;
  static const String iOS_App_ID = "";   //iOSAppID
  static const int FunctionId = 10023;

  static List<Person> persons;

  static List<Person> pets=[];

  static List<Record> records;

  static List<String> petItems=['狴犴*1','狴犴碎片*10','狴犴碎片*5','高级灵兽丹*2','中级灵兽丹*8',
    '随机2星稀有圣物*1','随机2星普通圣物*1'];
  static List<String> petImages=['pet1.png','pet2.png','pet3.png','pet4.png','pet5.png','pet6.png','pet7.png'];

  static Future<List<Person>> get PERSONS async {
    BmobQuery<Person> query = new BmobQuery<Person>();
    query.addWhereEqualTo("user", UserHelper.instance.bmobUserVM.bmobUserModel);
     await query.queryObjects().then((data) {persons = data.map((i) => Person.fromJson(i)).toList();
    }).catchError((e) {
    });
     return persons;
  }

  static List<Person> get PETS  {
    pets.clear();
    Person pet=Person();
    pet.names=petItems[0];
    pet.weight=3;
    pet.level=2;
    pet.localPath=petImages[0];
    pets.add(pet);

    pet=Person();
    pet.names=petItems[1];
    pet.weight=10;
    pet.level=2;
    pet.localPath=petImages[1];
    pets.add(pet);

    pet=Person();
    pet.names=petItems[2];
    pet.localPath=petImages[2];
    pet.weight=15;
    pet.level=2;
    pets.add(pet);

    pet=Person();
    pet.names=petItems[3];
    pet.localPath=petImages[3];
    pet.weight=20;
    pet.level=1;
    pets.add(pet);

    pet=Person();
    pet.names=petItems[4];
    pet.localPath=petImages[4];
    pet.weight=27;
    pet.level=0;
    pets.add(pet);

    pet=Person();
    pet.names=petItems[5];
    pet.localPath=petImages[5];
    pet.weight=10;
    pet.level=0;
    pets.add(pet);

    pet=Person();
    pet.names=petItems[6];
    pet.localPath=petImages[6];
    pet.weight=15;
    pet.level=0;
    pets.add(pet);

    return pets;
  }

  static Future<List<Record>> get RECORDS async {
    BmobQuery<Record> query = new BmobQuery<Record>();
    query.addWhereEqualTo("user", UserHelper.instance.bmobUserVM.bmobUserModel);
    await query.queryObjects().then((data) {records = data.map((i) => Record.fromJson(i)).toList();
    }).catchError((e) {
      records=[];
    });
    return records;
  }



  static String get URL_YSZC {
    if (JYLocalizations.currentLocalIsEnglish()) {
      return URL_YSZC_EN;
    }
    return URL_YSZC_ZH;
  }

  static String get URL_YHXY {
    if (JYLocalizations.currentLocalIsEnglish()) {
      return URL_YHXY_EN;
    }
    return URL_YHXY_ZH;
  }

  static String get URL_ZDXFXY {
    if (JYLocalizations.currentLocalIsEnglish()) {
      return URL_ZDXFXY_EN;
    }
    return URL_ZDXFXY_ZH;
  }

  static String get URL_FEEDBOOK {
    if (JYLocalizations.currentLocalIsEnglish()) {
      return URL_FEEDBOOK_EN;
    }
    return URL_FEEDBOOK_ZH;
     }
  ///APP名称
  static String appName_ZH = '幻想大陆抽卡模拟';
  static String appName_EN = 'Fantasy simulate';
  static String appName0 = '';

  static String get appName {
    if(appName0.isNotEmpty){
      return appName0;
    }
    if(navigatorContext!=null) {
      if (JYLocalizations.currentLocalIsEnglish())
      {
        return appName_EN;
      }
      return appName_ZH;
    }
    return appName_ZH;
  }

  static set appName(String value) {
    if(navigatorContext!=null) {
      if (JYLocalizations.currentLocalIsEnglish())
      {
        appName_EN = value;
      }else {
        appName_ZH = value;
      }
    }
    appName0 = value;
  }

  ///安卓包名
  ///
  static String packageName = 'com.fantasy.simulate';

  ///版本名
  static String versionName = '1.0.0';

  ///版本号
  static int versionCode = 100;

  ///渠道号  待定
  static int channelId = 0;
  static String channelName = '0';

  static String deviceId = '';

  static String platform = '';

  static init() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    if (Platform.isAndroid) {
      appName = packageInfo.appName;
      channelName = await AndroidMethodChannel.getChannelId();
      channelId = int.parse(channelName);
      deviceId = await AndroidMethodChannel.getAndroidId();
      platform = "android";
    } else if (Platform.isIOS) {
      appName = "幻想大陆抽卡模拟";
      channelName = "999000";
      channelId = int.parse(channelName);
      deviceId = await IOSMethodChannel.getUUid();
      platform = "iOS";
    }
    packageName = packageInfo.packageName;
    versionName = packageInfo.version;
    versionCode = int.parse(packageInfo.version.replaceAll(".", ""));

    debugPrint(
        "${appName} + ${packageName} + ${versionName} + $channelName + $channelId");
  }
}
