//此处与类名一致，由指令自动生成代码


import 'package:data_plugin/bmob/table/bmob_user.dart';
import 'package:data_plugin/bmob/table/bmob_object.dart';
import 'package:json_annotation/json_annotation.dart';

part 'person.g.dart';

@JsonSerializable()
class Person extends BmobObject {
  int numbers; //唯一编号
  String names;
  int weight; //权重
  int level; //0,1,2,3
  String localPath;
  BmobUser user;

  Person();

  //此处与类名一致，由指令自动生成代码
  factory Person.fromJson(Map<String, dynamic> json) => _$PersonFromJson(json);

  //此处与类名一致，由指令自动生成代码
  Map<String, dynamic> toJson() => _$PersonToJson(this);

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
