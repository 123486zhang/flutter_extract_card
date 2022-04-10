// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pets.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Pets _$PetsFromJson(Map<String, dynamic> json) {
  return Pets()
    ..createdAt = json['createdAt'] as String
    ..updatedAt = json['updatedAt'] as String
    ..objectId = json['objectId'] as String
    ..ACL = json['ACL'] as Map<String, dynamic>
    ..petFragments = json['petFragments'] as int
    ..advancedPills = json['advancedPills'] as int
    ..middlePills = json['middlePills'] as int
    ..rareHoly = json['rareHoly'] as int
    ..ordinaryHoly = json['ordinaryHoly'] as int
    ..extractTimes = json['extractTimes'] as int
    ..user = json['user'] == null
        ? null
        : BmobUser.fromJson(json['user'] as Map<String, dynamic>);
}

Map<String, dynamic> _$PetsToJson(Pets instance) => <String, dynamic>{
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'objectId': instance.objectId,
      'ACL': instance.ACL,
      'petFragments': instance.petFragments,
      'advancedPills': instance.advancedPills,
      'middlePills': instance.middlePills,
      'rareHoly': instance.rareHoly,
      'ordinaryHoly': instance.ordinaryHoly,
      'extractTimes': instance.extractTimes,
      'user': instance.user,
    };
