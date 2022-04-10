//此处与类名一致，由指令自动生成代码

import 'package:data_plugin/bmob/table/bmob_user.dart';
import 'package:data_plugin/bmob/table/bmob_object.dart';
import 'package:json_annotation/json_annotation.dart';

part 'sign_in.g.dart';

@JsonSerializable()
class SignIn extends BmobObject {
  bool mon;
  bool tue;
  bool web;
  bool thur;
  bool fri;
  bool sat;
  bool sun;
  BmobUser user;

  SignIn();

  //此处与类名一致，由指令自动生成代码
  factory SignIn.fromJson(Map<String, dynamic> json) =>
      _$SignInFromJson(json);

  SignIn fromJsons(Map<String,dynamic> json) {
    return  _$SignInFromJson(json);
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
  Map<String, dynamic> toJson() => _$SignInToJson(this);

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
