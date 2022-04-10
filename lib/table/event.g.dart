// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Event _$EventFromJson(Map<String, dynamic> json) {
  return Event()
    ..createdAt = json['createdAt'] as String
    ..updatedAt = json['updatedAt'] as String
    ..objectId = json['objectId'] as String
    ..ACL = json['ACL'] as Map<String, dynamic>
    ..type = json['type'] as int
    ..start = json['start'] as String
    ..stop = json['stop'] as String
    ..isOpen = json['isOpen'] as bool;
}

Map<String, dynamic> _$EventToJson(Event instance) => <String, dynamic>{
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'objectId': instance.objectId,
      'ACL': instance.ACL,
      'type': instance.type,
      'start': instance.start,
      'stop': instance.stop,
      'isOpen': instance.isOpen,
    };
