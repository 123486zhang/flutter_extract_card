//此处与类名一致，由指令自动生成代码


import 'package:data_plugin/bmob/table/bmob_user.dart';
import 'package:data_plugin/bmob/table/bmob_object.dart';
import 'package:json_annotation/json_annotation.dart';

part 'pets.g.dart';

@JsonSerializable()
class Pets extends BmobObject {
  int petFragments=0;
  int advancedPills=0;
  int middlePills=0;
  int rareHoly=0;
  int ordinaryHoly=0;
  int extractTimes=0;

  BmobUser user;

  Pets();

  //此处与类名一致，由指令自动生成代码
  factory Pets.fromJson(Map<String, dynamic> json) => _$PetsFromJson(json);

  //此处与类名一致，由指令自动生成代码
  Map<String, dynamic> toJson() => _$PetsToJson(this);

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
