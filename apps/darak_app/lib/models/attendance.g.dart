// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attendance.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AttendanceImpl _$$AttendanceImplFromJson(Map<String, dynamic> json) =>
    _$AttendanceImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      type: $enumDecode(_$AttendanceTypeEnumMap, json['type']),
      date: DateTime.parse(json['date'] as String),
      status: $enumDecode(_$AttendanceStatusEnumMap, json['status']),
      note: json['note'] as String?,
      groupId: json['groupId'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      deletedAt: json['deletedAt'] == null
          ? null
          : DateTime.parse(json['deletedAt'] as String),
    );

Map<String, dynamic> _$$AttendanceImplToJson(_$AttendanceImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'type': _$AttendanceTypeEnumMap[instance.type]!,
      'date': instance.date.toIso8601String(),
      'status': _$AttendanceStatusEnumMap[instance.status]!,
      'note': instance.note,
      'groupId': instance.groupId,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'deletedAt': instance.deletedAt?.toIso8601String(),
    };

const _$AttendanceTypeEnumMap = {
  AttendanceType.onlySundayService: 'onlySundayService',
  AttendanceType.prayerMeeting: 'prayer_meeting',
  AttendanceType.specialEvent: 'special_event',
};

const _$AttendanceStatusEnumMap = {
  AttendanceStatus.present: 'present',
  AttendanceStatus.absent: 'absent',
  AttendanceStatus.late: 'late',
  AttendanceStatus.excused: 'excused',
  AttendanceStatus.etc: 'etc',
};
