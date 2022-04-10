// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bmob_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BmobUser _$BmobUserFromJson(Map<String, dynamic> json) {
  return BmobUser()
    ..createdAt = json['createdAt'] as String
    ..updatedAt = json['updatedAt'] as String
    ..objectId = json['objectId'] as String
    ..ACL = json['ACL'] as Map<String, dynamic>
    ..username = json['username'] as String
    ..password = json['password'] as String
    ..email = json['email'] as String
    ..emailVerified = json['emailVerified'] as bool
    ..mobilePhoneNumber = json['mobilePhoneNumber'] as String
    ..coins = json['coins'] as int
    ..petCoins = json['petCoins'] as int
    ..isVip = json['isVip'] as bool
    ..vipEndAt= json['vipEndAt'] as String
    ..headId = json['headId'] as int
    ..backId = json['backId'] as int
    ..isAdmin = json['isAdmin'] as bool
    ..mobilePhoneNumberVerified = json['mobilePhoneNumberVerified'] as bool
    ..sessionToken = json['sessionToken'] as String;
}

Map<String, dynamic> _$BmobUserToJson(BmobUser instance) => <String, dynamic>{
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'objectId': instance.objectId,
      'ACL': instance.ACL,
      'username': instance.username,
      'password': instance.password,
      'email': instance.email,
      'isVip': instance.isVip,
      'vipEndAt': instance.vipEndAt,
      'coins': instance.coins,
      'petCoins': instance.petCoins,
      'emailVerified': instance.emailVerified,
      'mobilePhoneNumber': instance.mobilePhoneNumber,
      'mobilePhoneNumberVerified': instance.mobilePhoneNumberVerified,
      'sessionToken': instance.sessionToken,
      'headId': instance.headId,
      'isAdmin': instance.isAdmin,
      'backId': instance.backId
    };
