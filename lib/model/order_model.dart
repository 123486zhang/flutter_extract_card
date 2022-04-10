// To parse this JSON data, do
//
//     final orderModel = orderModelFromJson(jsonString);

import 'dart:convert';

import 'package:graphic_conversion/model/watermark_photo_model.dart';

OrderModel orderModelFromJson(String str) => OrderModel.fromJson(json.decode(str));

String orderModelToJson(OrderModel data) => json.encode(data.toJson());

class OrderModel {
  OrderModel({
    this.orderNo,
    this.urlWm,
    this.productId,
    this.channelNo,
    this.urlPrint,
    this.updateTime,
    this.urlPrintWm,
    this.userId,
    this.url,
    this.rechargeMoney,
    this.payType,
    this.des,
    this.createTime,
    this.id,
    this.rechargeType,
    this.status,
    this.orderName,
    this.imageSize,
    this.imagePixel,
    this.fileName,
    this.clearColorUrl,
    this.originUrl,
  });

  String orderNo;
  String urlWm;
  int productId;
  int channelNo;
  String urlPrint;
  String updateTime;
  String urlPrintWm;
  String userId;
  String url;
  double rechargeMoney;
  int payType;
  String des;
  String createTime;
  int id;
  int rechargeType;
  int status;
  String orderName;
  String imageSize;
  String imagePixel;
  String fileName;
  String clearColorUrl;
  String originUrl;

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;
    OrderModel model = OrderModel();
    model.fileName = json["fileName"];
    model.orderNo = json["orderNo"];
    model.urlWm = json["urlWm"];
    model.imagePixel = json["imagePixel"];
    model.productId = json["productId"];
    model.channelNo = json["channelNo"];
    model.urlPrint = json["urlPrint"];
    model.updateTime = json["updateTime"];
    model.urlPrintWm = json["urlPrintWm"];
    model.userId = json["userId"];
    model.url = json["url"];
    model.rechargeMoney = json["rechargeMoney"] / 1.0;
    model.payType = json["payType"];
    model.des = json["des"];
    model.createTime = json["createTime"];
    model.id = json["id"];
    model.imageSize = json["imageSize"];
    model.rechargeType = json["rechargeType"];
    model.status = json["status"];
    model.orderName = json["orderName"];
    model.clearColorUrl = json["clearColorUrl"];
    model.originUrl = json["originUrl"];
    return model;
  }

  // factory OrderModel.fromJson(Map<String, dynamic> json) => OrderModel(
  //   fileName: json["fileName"],
  //   orderNo: json["orderNo"],
  //   urlWm: json["urlWm"],
  //   imagePixel: json["imagePixel"],
  //   productId: json["productId"],
  //   channelNo: json["channelNo"],
  //   urlPrint: json["urlPrint"],
  //   updateTime: json["updateTime"],
  //   urlPrintWm: json["urlPrintWm"],
  //   userId: json["userId"],
  //   url: json["url"],
  //   rechargeMoney: json["rechargeMoney"],
  //   payType: json["payType"],
  //   des: json["des"],
  //   createTime: json["createTime"],
  //   id: json["id"],
  //   imageSize: json["imageSize"],
  //   rechargeType: json["rechargeType"],
  //   status: json["status"],
  //   orderName: json["orderName"],
  // );

  Map<String, dynamic> toJson() => {
    "orderNo": orderNo,
    "urlWm": urlWm,
    "productId": productId,
    "channelNo": channelNo,
    "urlPrint": urlPrint,
    "updateTime": updateTime,
    "urlPrintWm": urlPrintWm,
    "userId": userId,
    "url": url,
    "rechargeMoney": rechargeMoney,
    "payType": payType,
    "des": des,
    "createTime": createTime,
    "id": id,
    "rechargeType": rechargeType,
    "status": status,
    "orderName": orderName,
    "imageSize": imageSize,
    "imagePixel": imagePixel,
    "fileName": fileName,
    "clearColorUrl": clearColorUrl,
    "originUrl": originUrl,
  };

  static OrderModel convertModelWithWatermarkPhotoModel(WatermarkPhotoModel photoModel) {
    if (photoModel == null) return null;
    OrderModel model = OrderModel();
    model.urlWm = photoModel.imgWmUrlList[0];
    model.urlPrintWm = photoModel.printWmUrlList[0];
    model.fileName = photoModel.fileName[0];
    model.imagePixel = "${photoModel.size[0]}*${photoModel.size[1]}px";
    return model;
  }
}
