// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'church.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ChurchImpl _$$ChurchImplFromJson(Map<String, dynamic> json) => _$ChurchImpl(
  id: json['id'] as String,
  name: json['name'] as String,
  address: json['address'] as String,
  addressDetail: json['addressDetail'] as String?,
  latitude: (json['latitude'] as num?)?.toDouble(),
  longitude: (json['longitude'] as num?)?.toDouble(),
  seniorPastor: json['seniorPastor'] as String,
  denomination: json['denomination'] as String,
  requestMemo: json['requestMemo'] as String,
  requestedBy: json['requestedBy'] as String,
  status: $enumDecode(_$ChurchStatusEnumMap, json['status']),
  rejectionReason: json['rejectionReason'] as String?,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
  approvedAt: json['approvedAt'] == null
      ? null
      : DateTime.parse(json['approvedAt'] as String),
);

Map<String, dynamic> _$$ChurchImplToJson(_$ChurchImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'address': instance.address,
      'addressDetail': instance.addressDetail,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'seniorPastor': instance.seniorPastor,
      'denomination': instance.denomination,
      'requestMemo': instance.requestMemo,
      'requestedBy': instance.requestedBy,
      'status': _$ChurchStatusEnumMap[instance.status]!,
      'rejectionReason': instance.rejectionReason,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'approvedAt': instance.approvedAt?.toIso8601String(),
    };

const _$ChurchStatusEnumMap = {
  ChurchStatus.pending: 'pending',
  ChurchStatus.approved: 'approved',
  ChurchStatus.rejected: 'rejected',
};
