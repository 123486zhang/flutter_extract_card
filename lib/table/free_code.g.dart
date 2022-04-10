// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'free_code.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FreeCode _$FreeCodeFromJson(Map<String, dynamic> json) {
  return FreeCode()
    ..createdAt = json['createdAt'] as String
    ..updatedAt = json['updatedAt'] as String
    ..objectId = json['objectId'] as String
    ..ACL = json['ACL'] as Map<String, dynamic>
    ..code = json['code'] as String
    ..coins = json['coins'] as int
    ..isUse = json['isUse'] as bool
    ..user = json['user'] == null
        ? null
        : BmobUser.fromJson(json['user'] as Map<String, dynamic>);
}

Map<String, dynamic> _$FreeCodeToJson(FreeCode instance) => <String, dynamic>{
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'objectId': instance.objectId,
      'ACL': instance.ACL,
      'code': instance.code,
      'coins': instance.coins,
      'isUse': instance.isUse,
      'user': instance.user,
    };
