// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Record _$RecordFromJson(Map<String, dynamic> json) {
  return Record()
    ..createdAt = json['createdAt'] as String
    ..updatedAt = json['updatedAt'] as String
    ..objectId = json['objectId'] as String
    ..ACL = json['ACL'] as Map<String, dynamic>
    ..time = json['time'] as String
    ..items = json['items'] as String
    ..user = json['user'] == null
        ? null
        : BmobUser.fromJson(json['user'] as Map<String, dynamic>);
}

Map<String, dynamic> _$RecordToJson(Record instance) => <String, dynamic>{
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'objectId': instance.objectId,
      'ACL': instance.ACL,
      'time': instance.time,
      'items': instance.items,
      'user': instance.user,
    };
