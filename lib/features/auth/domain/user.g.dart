// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserImpl _$$UserImplFromJson(Map<String, dynamic> json) => _$UserImpl(
  id: json['id'] as String,
  email: json['email'] as String,
  displayName: json['displayName'] as String?,
  photoUrl: json['photoUrl'] as String?,
  displayNameManuallyEdited:
      json['displayNameManuallyEdited'] as bool? ?? false,
  photoUrlManuallyEdited: json['photoUrlManuallyEdited'] as bool? ?? false,
);

Map<String, dynamic> _$$UserImplToJson(_$UserImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'displayName': instance.displayName,
      'photoUrl': instance.photoUrl,
      'displayNameManuallyEdited': instance.displayNameManuallyEdited,
      'photoUrlManuallyEdited': instance.photoUrlManuallyEdited,
    };
