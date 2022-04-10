// To parse this JSON data, do
//
//     final appConfig = appConfigFromJson(jsonString);

import 'dart:convert';

AppConfig appConfigFromJson(String str) => AppConfig.fromJson(json.decode(str));

String appConfigToJson(AppConfig data) => json.encode(data.toJson());

class AppConfig {
  AppConfig({
    this.messageInfos,
    this.bhinfo,
    this.serviceTip,
    this.startServiceInfo,
    this.payMethod,
    this.showPriceTypes,
    this.banner,
    this.shareurl,
  });

  MessageInfos messageInfos;
  List<dynamic> bhinfo;
  dynamic serviceTip;
  StartServiceInfo startServiceInfo;
  int payMethod;
  List<ShowPriceType> showPriceTypes;
  List<dynamic> banner;
  dynamic shareurl;

  factory AppConfig.fromJson(Map<String, dynamic> json) => AppConfig(
    messageInfos: MessageInfos.fromJson(json["messageInfos"]),
    bhinfo: List<dynamic>.from(json["bhinfo"].map((x) => x)),
    serviceTip: json["serviceTip"],
    startServiceInfo: StartServiceInfo.fromJson(json["startServiceInfo"]),
    payMethod: json["payMethod"],
    showPriceTypes: List<ShowPriceType>.from(json["showPriceTypes"].map((x) => ShowPriceType.fromJson(x))),
    banner: List<dynamic>.from(json["banner"].map((x) => x)),
    shareurl: json["shareurl"],
  );

  Map<String, dynamic> toJson() => {
    "messageInfos": messageInfos.toJson(),
    "bhinfo": List<dynamic>.from(bhinfo.map((x) => x)),
    "serviceTip": serviceTip,
    "startServiceInfo": startServiceInfo.toJson(),
    "payMethod": payMethod,
    "showPriceTypes": List<dynamic>.from(showPriceTypes.map((x) => x.toJson())),
    "banner": List<dynamic>.from(banner.map((x) => x)),
    "shareurl": shareurl,
  };
}

class MessageInfos {
  MessageInfos({
    this.ver,
    this.messageType,
    this.downloadUrl,
    this.title,
  });

  int ver;
  int messageType;
  String downloadUrl;
  String title;

  factory MessageInfos.fromJson(Map<String, dynamic> json) => MessageInfos(
    ver: json["ver"],
    messageType: json["messageType"],
    downloadUrl: json["downloadUrl"],
    title: json["title"],
  );

  Map<String, dynamic> toJson() => {
    "ver": ver,
    "messageType": messageType,
    "downloadUrl": downloadUrl,
    "title": title,
  };
}

class ShowPriceType {
  ShowPriceType({
    this.applePrice,
    this.priceNo,
    this.originalAliPrice,
    this.displayName,
    this.wechatPrice,
    this.originalWechatPrice,
    this.isContinuePay,
    this.aliPrice,
    this.remark,
    this.type,
  });

  double applePrice;
  int priceNo;
  double originalAliPrice;
  String displayName;
  double wechatPrice;
  double originalWechatPrice;
  int isContinuePay;
  double aliPrice;
  String remark;
  int type;

  factory ShowPriceType.fromJson(Map<String, dynamic> json) => ShowPriceType(
    applePrice: json["applePrice"].toDouble(),
    priceNo: json["priceNo"],
    originalAliPrice: json["originalAliPrice"].toDouble(),
    displayName: json["displayName"],
    wechatPrice: json["wechatPrice"].toDouble(),
    originalWechatPrice: json["originalWechatPrice"].toDouble(),
    isContinuePay: json["isContinuePay"],
    aliPrice: json["aliPrice"].toDouble(),
    remark: json["remark"],
    type: json["type"],
  );

  Map<String, dynamic> toJson() => {
    "applePrice": applePrice,
    "priceNo": priceNo,
    "originalAliPrice": originalAliPrice,
    "displayName": displayName,
    "wechatPrice": wechatPrice,
    "originalWechatPrice": originalWechatPrice,
    "isContinuePay": isContinuePay,
    "aliPrice": aliPrice,
    "remark": remark,
    "type": type,
  };
}

class StartServiceInfo {
  StartServiceInfo({
    this.privateUrl,
    this.protocolVer,
    this.shareMessage,
    this.agreementUrl,
  });

  String privateUrl;
  int protocolVer;
  String shareMessage;
  String agreementUrl;

  factory StartServiceInfo.fromJson(Map<String, dynamic> json) => StartServiceInfo(
    privateUrl: json["privateUrl"],
    protocolVer: json["protocolVer"],
    shareMessage: json["shareMessage"],
    agreementUrl: json["agreementUrl"],
  );

  Map<String, dynamic> toJson() => {
    "privateUrl": privateUrl,
    "protocolVer": protocolVer,
    "shareMessage": shareMessage,
    "agreementUrl": agreementUrl,
  };
}
