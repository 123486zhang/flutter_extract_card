// To parse this JSON data, do
//
//     final photoSizeModel = photoSizeModelFromJson(jsonString);

import 'dart:convert';

PhotoSizeModel photoSizeModelFromJson(String str) => PhotoSizeModel.fromJson(json.decode(str));

String photoSizeModelToJson(PhotoSizeModel data) => json.encode(data.toJson());

class PhotoSizeModel {
  PhotoSizeModel({
    this.title,
    this.size,
    this.specId,
  });

  String title;
  String size;
  int specId;

  factory PhotoSizeModel.fromJson(Map<String, dynamic> json) => PhotoSizeModel(
    title: json["title"],
    size: json["size"],
    specId: json["spec_id"],
  );

  Map<String, dynamic> toJson() => {
    "title": title,
    "size": size,
    "spec_id": specId,
  };
}
