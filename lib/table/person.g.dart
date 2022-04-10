// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'person.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Person _$PersonFromJson(Map<String, dynamic> json) {
  return Person()
    ..createdAt = json['createdAt'] as String
    ..updatedAt = json['updatedAt'] as String
    ..objectId = json['objectId'] as String
    ..ACL = json['ACL'] as Map<String, dynamic>
    ..numbers = json['numbers'] as int
    ..names = json['names'] as String
    ..weight = json['weight'] as int
    ..level = json['level'] as int
    ..localPath = json['localPath'] as String
    ..user = json['user'] == null
        ? null
        : BmobUser.fromJson(json['user'] as Map<String, dynamic>);
}

Map<String, dynamic> _$PersonToJson(Person instance) => <String, dynamic>{
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'objectId': instance.objectId,
      'ACL': instance.ACL,
      'numbers': instance.numbers,
      'names': instance.names,
      'weight': instance.weight,
      'level': instance.level,
      'localPath': instance.localPath,
      'user': instance.user,
    };
