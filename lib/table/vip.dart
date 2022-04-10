//此处与类名一致，由指令自动生成代码


import 'package:data_plugin/bmob/table/bmob_user.dart';
import 'package:data_plugin/bmob/table/bmob_object.dart';
import 'package:json_annotation/json_annotation.dart';

part 'vip.g.dart';

@JsonSerializable()
class Vip extends BmobObject {
  String title;
  String price;
  String priceSymbol;
  String averagePrice;
  String wechatPrice;
  String wechatAveragePrice;
  String alipayPrice;
  String alipayAveragePrice;
  bool showAveragePrice;
  String productId;
  int priceNo;

  Vip();

  //此处与类名一致，由指令自动生成代码
  factory Vip.fromJson(Map<String, dynamic> json) => _$VipFromJson(json);

  //此处与类名一致，由指令自动生成代码
  Map<String, dynamic> toJson() => _$VipToJson(this);

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
