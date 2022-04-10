//此处与类名一致，由指令自动生成代码


import 'package:data_plugin/bmob/table/bmob_user.dart';
import 'package:data_plugin/bmob/table/bmob_object.dart';
import 'package:json_annotation/json_annotation.dart';

part 'record.g.dart';

@JsonSerializable()
class Record extends BmobObject {
  String time;
  String items;
  BmobUser user;

  Record();

  //此处与类名一致，由指令自动生成代码
  factory Record.fromJson(Map<String, dynamic> json) => _$RecordFromJson(json);

  //此处与类名一致，由指令自动生成代码
  Map<String, dynamic> toJson() => _$RecordToJson(this);

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
