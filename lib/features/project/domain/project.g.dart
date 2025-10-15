// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProjectImpl _$$ProjectImplFromJson(Map<String, dynamic> json) =>
    _$ProjectImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      ownerId: json['ownerId'] as String,
      description: json['description'] as String?,
      createdAt: _dateTimeFromJson(json['createdAt']),
      updatedAt: _dateTimeFromJson(json['updatedAt']),
      individuals:
          (json['individuals'] as List<dynamic>?)
              ?.map((e) => Individual.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      inflationRate: (json['inflationRate'] as num?)?.toDouble() ?? 0.02,
      reerReturnRate: (json['reerReturnRate'] as num?)?.toDouble() ?? 0.05,
      celiReturnRate: (json['celiReturnRate'] as num?)?.toDouble() ?? 0.05,
      criReturnRate: (json['criReturnRate'] as num?)?.toDouble() ?? 0.05,
      cashReturnRate: (json['cashReturnRate'] as num?)?.toDouble() ?? 0.015,
    );

Map<String, dynamic> _$$ProjectImplToJson(_$ProjectImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'ownerId': instance.ownerId,
      'description': instance.description,
      'createdAt': _dateTimeToJson(instance.createdAt),
      'updatedAt': _dateTimeToJson(instance.updatedAt),
      'individuals': instance.individuals.map((e) => e.toJson()).toList(),
      'inflationRate': instance.inflationRate,
      'reerReturnRate': instance.reerReturnRate,
      'celiReturnRate': instance.celiReturnRate,
      'criReturnRate': instance.criReturnRate,
      'cashReturnRate': instance.cashReturnRate,
    };
