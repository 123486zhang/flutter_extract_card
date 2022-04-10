// To parse this JSON data, do
//
//     final uploadImageModel = uploadImageModelFromJson(jsonString);

import 'dart:convert';

UploadImageModel uploadImageModelFromJson(String str) => UploadImageModel.fromJson(json.decode(str));

String uploadImageModelToJson(UploadImageModel data) => json.encode(data.toJson());

class UploadImageModel {
  UploadImageModel({
    this.accessKeyId,
    this.encodePolicy,
    this.uploadUrl,
    this.imageUrl,
    this.signaturecom,
    this.type,
    this.key,
  });

  String accessKeyId;
  String encodePolicy;
  String uploadUrl;
  String imageUrl;
  String signaturecom;
  int type;
  String key;

  factory UploadImageModel.fromJson(Map<String, dynamic> json) => UploadImageModel(
    accessKeyId: json["accessKeyId"],
    encodePolicy: json["encodePolicy"],
    uploadUrl: json["uploadUrl"],
    imageUrl: json["imageUrl"],
    signaturecom: json["signaturecom"],
    type: json["type"],
    key: json["key"],
  );

  Map<String, dynamic> toJson() => {
    "accessKeyId": accessKeyId,
    "encodePolicy": encodePolicy,
    "uploadUrl": uploadUrl,
    "imageUrl": imageUrl,
    "signaturecom": signaturecom,
    "type": type,
    "key": key,
  };
}
