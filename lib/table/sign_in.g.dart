// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sign_in.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SignIn _$SignInFromJson(Map<String, dynamic> json) {
  return SignIn()
    ..createdAt = json['createdAt'] as String
    ..updatedAt = json['updatedAt'] as String
    ..objectId = json['objectId'] as String
    ..ACL = json['ACL'] as Map<String, dynamic>
    ..mon = json['mon'] as bool
    ..tue = json['tue'] as bool
    ..web = json['web'] as bool
    ..thur = json['thur'] as bool
    ..fri = json['fri'] as bool
    ..sat = json['sat'] as bool
    ..sun = json['sun'] as bool
    ..user = json['user'] == null
        ? null
        : BmobUser.fromJson(json['user'] as Map<String, dynamic>);
}

Map<String, dynamic> _$SignInToJson(SignIn instance) => <String, dynamic>{
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'objectId': instance.objectId,
      'ACL': instance.ACL,
      'mon': instance.mon,
      'tue': instance.tue,
      'web': instance.web,
      'thur': instance.thur,
      'fri': instance.fri,
      'sat': instance.sat,
      'sun': instance.sun,
      'user': instance.user,
    };
