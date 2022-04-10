// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vip.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Vip _$VipFromJson(Map<String, dynamic> json) {
  return Vip()
    ..createdAt = json['createdAt'] as String
    ..updatedAt = json['updatedAt'] as String
    ..objectId = json['objectId'] as String
    ..ACL = json['ACL'] as Map<String, dynamic>
    ..title = json['title'] as String
    ..price = json['price'] as String
    ..priceSymbol = json['priceSymbol'] as String
    ..averagePrice = json['averagePrice'] as String
    ..wechatPrice = json['wechatPrice'] as String
    ..wechatAveragePrice = json['wechatAveragePrice'] as String
    ..alipayPrice = json['alipayPrice'] as String
    ..alipayAveragePrice = json['alipayAveragePrice'] as String
    ..showAveragePrice = json['showAveragePrice'] as bool
    ..productId = json['productId'] as String
    ..priceNo = json['priceNo'] as int;
}

Map<String, dynamic> _$VipToJson(Vip instance) => <String, dynamic>{
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'objectId': instance.objectId,
      'ACL': instance.ACL,
      'title': instance.title,
      'price': instance.price,
      'priceSymbol': instance.priceSymbol,
      'averagePrice': instance.averagePrice,
      'wechatPrice': instance.wechatPrice,
      'wechatAveragePrice': instance.wechatAveragePrice,
      'alipayPrice': instance.alipayPrice,
      'alipayAveragePrice': instance.alipayAveragePrice,
      'showAveragePrice': instance.showAveragePrice,
      'productId': instance.productId,
      'priceNo': instance.priceNo,
    };
