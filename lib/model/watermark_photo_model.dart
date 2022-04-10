// To parse this JSON data, do
//
//     final watermarkPhotoModel = watermarkPhotoModelFromJson(jsonString);

import 'dart:convert';

WatermarkPhotoModel watermarkPhotoModelFromJson(String str) => WatermarkPhotoModel.fromJson(json.decode(str));

String watermarkPhotoModelToJson(WatermarkPhotoModel data) => json.encode(data.toJson());

class WatermarkPhotoModel {
  WatermarkPhotoModel({
    this.check,
    this.checkResult,
    this.fileName,
    this.fileNamePrint,
    this.fileNamePrintWm,
    this.fileNameWm,
    this.imgWmUrlList,
    this.isPrint,
    this.oneSheetNum,
    this.printWmUrlList,
    this.size,
    this.sizePrint,
    this.sourceFile,
  });

  int check;
  CheckResult checkResult;
  List<String> fileName;
  List<String> fileNamePrint;
  List<String> fileNamePrintWm;
  List<String> fileNameWm;
  List<String> imgWmUrlList;
  int isPrint;
  int oneSheetNum;
  List<String> printWmUrlList;
  List<int> size;
  List<int> sizePrint;
  String sourceFile;

  factory WatermarkPhotoModel.fromJson(Map<String, dynamic> json) => WatermarkPhotoModel(
    check: json["check"],
    checkResult: CheckResult.fromJson(json["check_result"]),
    fileName: List<String>.from(json["file_name"].map((x) => x)),
    fileNamePrint: json["file_name_print"] == null ? [] : List<String>.from(json["file_name_print"].map((x) => x)),
    fileNamePrintWm: json["file_name_print_wm"] == null ? [] : List<String>.from(json["file_name_print_wm"].map((x) => x)),
    fileNameWm: json["file_name_wm"] == null ? [] : List<String>.from(json["file_name_wm"].map((x) => x)),
    imgWmUrlList: List<String>.from(json["img_wm_url_list"].map((x) => x)),
    isPrint: json["is_print"],
    oneSheetNum: json["one_sheet_num"],
    printWmUrlList: json["print_wm_url_list"] == null ? [] : List<String>.from(json["print_wm_url_list"].map((x) => x)),
    size: List<int>.from(json["size"].map((x) => x)),
    sizePrint: json["size_print"] == null ? [] : List<int>.from(json["size_print"].map((x) => x)),
    sourceFile: json["source_file"],
  );

  Map<String, dynamic> toJson() => {
    "check": check,
    "check_result": checkResult.toJson(),
    "file_name": List<dynamic>.from(fileName.map((x) => x)),
    "file_name_print": List<dynamic>.from(fileNamePrint.map((x) => x)),
    "file_name_print_wm": List<dynamic>.from(fileNamePrintWm.map((x) => x)),
    "file_name_wm": List<dynamic>.from(fileNameWm.map((x) => x)),
    "img_wm_url_list": List<dynamic>.from(imgWmUrlList.map((x) => x)),
    "is_print": isPrint,
    "one_sheet_num": oneSheetNum,
    "print_wm_url_list": List<dynamic>.from(printWmUrlList.map((x) => x)),
    "size": List<dynamic>.from(size.map((x) => x)),
    "size_print": List<dynamic>.from(sizePrint.map((x) => x)),
    "source_file": sourceFile,
  };
}

class CheckResult {
  CheckResult({
    this.backgroundColor,
    this.clothesSimilar,
    this.earOcclusion,
    this.eyesClose,
    this.faceBlur,
    this.faceCenter,
    this.faceNoise,
    this.facialPose,
    this.fileSize,
    this.headposePitch,
    this.headposeRoll,
    this.headposeYaw,
    this.name,
    this.photoFormat,
    this.pxAndMm,
    this.shoulderEqual,
    this.sightLine,
    this.specId,
  });

  int backgroundColor;
  int clothesSimilar;
  int earOcclusion;
  int eyesClose;
  int faceBlur;
  int faceCenter;
  int faceNoise;
  int facialPose;
  int fileSize;
  int headposePitch;
  int headposeRoll;
  int headposeYaw;
  String name;
  int photoFormat;
  int pxAndMm;
  int shoulderEqual;
  int sightLine;
  int specId;

  factory CheckResult.fromJson(Map<String, dynamic> json) => CheckResult(
    backgroundColor: json["background_color"],
    clothesSimilar: json["clothes_similar"],
    earOcclusion: json["ear_occlusion"],
    eyesClose: json["eyes_close"],
    faceBlur: json["face_blur"],
    faceCenter: json["face_center"],
    faceNoise: json["face_noise"],
    facialPose: json["facial_pose"],
    fileSize: json["file_size"],
    headposePitch: json["headpose_pitch"],
    headposeRoll: json["headpose_roll"],
    headposeYaw: json["headpose_yaw"],
    name: json["name"],
    photoFormat: json["photo_format"],
    pxAndMm: json["px_and_mm"],
    shoulderEqual: json["shoulder_equal"],
    sightLine: json["sight_line"],
    specId: json["spec_id"],
  );

  Map<String, dynamic> toJson() => {
    "background_color": backgroundColor,
    "clothes_similar": clothesSimilar,
    "ear_occlusion": earOcclusion,
    "eyes_close": eyesClose,
    "face_blur": faceBlur,
    "face_center": faceCenter,
    "face_noise": faceNoise,
    "facial_pose": facialPose,
    "file_size": fileSize,
    "headpose_pitch": headposePitch,
    "headpose_roll": headposeRoll,
    "headpose_yaw": headposeYaw,
    "name": name,
    "photo_format": photoFormat,
    "px_and_mm": pxAndMm,
    "shoulder_equal": shoulderEqual,
    "sight_line": sightLine,
    "spec_id": specId,
  };
}
