//此处与类名一致，由指令自动生成代码

import 'package:data_plugin/bmob/table/bmob_user.dart';
import 'package:data_plugin/bmob/table/bmob_object.dart';
import 'package:json_annotation/json_annotation.dart';

part 'free_code.g.dart';

@JsonSerializable()
class FreeCode extends BmobObject {
  String code;
  int coins;
  bool isUse=false;
  BmobUser user;

  FreeCode();

  //此处与类名一致，由指令自动生成代码
  factory FreeCode.fromJson(Map<String, dynamic> json) =>
      _$FreeCodeFromJson(json);

  FreeCode fromJsons(Map<String,dynamic> json) {
    return  _$FreeCodeFromJson(json);
  }

  // FreeCode fromJsons(Map<String, dynamic> json) {
  //   return FreeCode()
  //     ..createdAt = json['createdAt'] as String
  //     ..updatedAt = json['updatedAt'] as String
  //     ..objectId = json['objectId'] as String
  //     ..ACL = json['ACL'] as Map<String, dynamic>
  //     ..code = json['code'] as String
  //     ..coins = json['coins'] as int
  //     ..isUse = json['isUse'] as bool
  //     ..user = json['user'] == null
  //         ? null
  //         : BmobUser.fromJson(json['user'] as Map<String, dynamic>);
  // }

  //此处与类名一致，由指令自动生成代码
  Map<String, dynamic> toJson() => _$FreeCodeToJson(this);

  @override
  Map getParams() {
    Map<String, dynamic> map = toJson();
    Map<String, dynamic> data = new Map();
    //去除空值
    map.forEach((key, value) {
      if (value != null) {
        data[key] = value;
      }
    });
    return map;
  }
}
