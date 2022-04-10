import 'package:graphic_conversion/utils/string_utils.dart';

class VipModel {
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

  static VipModel fromJson(Map<String, dynamic> map) {
    if (map == null) return null;
    VipModel vipModel = VipModel();
    vipModel.title = StringUtils.getStringValue(map['title']);
    vipModel.price = StringUtils.getStringValue(map['price']);
    vipModel.averagePrice = StringUtils.getStringValue(map['averagePrice']);
    vipModel.wechatPrice = StringUtils.getStringValue(map['wechatPrice']);
    vipModel.wechatAveragePrice = StringUtils.getStringValue(map['wechatAveragePrice']);
    vipModel.alipayPrice = StringUtils.getStringValue(map['alipayPrice']);
    vipModel.alipayAveragePrice = StringUtils.getStringValue(map['alipayAveragePrice']);
    vipModel.showAveragePrice = map['showAveragePrice'];
    vipModel.productId = StringUtils.getStringValue(map['productId']);
    return vipModel;
  }

  Map<String, dynamic> toJson() => {
    "title": title,
    "price": price,
    "averagePrice": averagePrice,
    "wechatPrice": wechatPrice,
    "wechatAveragePrice": wechatAveragePrice,
    "alipayPrice": alipayPrice,
    "alipayAveragePrice": alipayAveragePrice,
    "showAveragePrice": showAveragePrice,
    "productId": productId,
  };
}