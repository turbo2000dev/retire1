// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

AppSettings _$AppSettingsFromJson(Map<String, dynamic> json) {
  return _AppSettings.fromJson(json);
}

/// @nodoc
mixin _$AppSettings {
  /// User ID that these settings belong to
  String get userId => throw _privateConstructorUsedError;

  /// Selected language code (e.g., 'en', 'fr')
  String get languageCode => throw _privateConstructorUsedError;

  /// Auto-open Excel files after export (default: true)
  bool get autoOpenExcelFiles => throw _privateConstructorUsedError;

  /// Timestamp of last update
  DateTime? get lastUpdated => throw _privateConstructorUsedError;

  /// Serializes this AppSettings to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AppSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AppSettingsCopyWith<AppSettings> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppSettingsCopyWith<$Res> {
  factory $AppSettingsCopyWith(
    AppSettings value,
    $Res Function(AppSettings) then,
  ) = _$AppSettingsCopyWithImpl<$Res, AppSettings>;
  @useResult
  $Res call({
    String userId,
    String languageCode,
    bool autoOpenExcelFiles,
    DateTime? lastUpdated,
  });
}

/// @nodoc
class _$AppSettingsCopyWithImpl<$Res, $Val extends AppSettings>
    implements $AppSettingsCopyWith<$Res> {
  _$AppSettingsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AppSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? languageCode = null,
    Object? autoOpenExcelFiles = null,
    Object? lastUpdated = freezed,
  }) {
    return _then(
      _value.copyWith(
            userId: null == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                      as String,
            languageCode: null == languageCode
                ? _value.languageCode
                : languageCode // ignore: cast_nullable_to_non_nullable
                      as String,
            autoOpenExcelFiles: null == autoOpenExcelFiles
                ? _value.autoOpenExcelFiles
                : autoOpenExcelFiles // ignore: cast_nullable_to_non_nullable
                      as bool,
            lastUpdated: freezed == lastUpdated
                ? _value.lastUpdated
                : lastUpdated // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AppSettingsImplCopyWith<$Res>
    implements $AppSettingsCopyWith<$Res> {
  factory _$$AppSettingsImplCopyWith(
    _$AppSettingsImpl value,
    $Res Function(_$AppSettingsImpl) then,
  ) = __$$AppSettingsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String userId,
    String languageCode,
    bool autoOpenExcelFiles,
    DateTime? lastUpdated,
  });
}

/// @nodoc
class __$$AppSettingsImplCopyWithImpl<$Res>
    extends _$AppSettingsCopyWithImpl<$Res, _$AppSettingsImpl>
    implements _$$AppSettingsImplCopyWith<$Res> {
  __$$AppSettingsImplCopyWithImpl(
    _$AppSettingsImpl _value,
    $Res Function(_$AppSettingsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AppSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? languageCode = null,
    Object? autoOpenExcelFiles = null,
    Object? lastUpdated = freezed,
  }) {
    return _then(
      _$AppSettingsImpl(
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        languageCode: null == languageCode
            ? _value.languageCode
            : languageCode // ignore: cast_nullable_to_non_nullable
                  as String,
        autoOpenExcelFiles: null == autoOpenExcelFiles
            ? _value.autoOpenExcelFiles
            : autoOpenExcelFiles // ignore: cast_nullable_to_non_nullable
                  as bool,
        lastUpdated: freezed == lastUpdated
            ? _value.lastUpdated
            : lastUpdated // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AppSettingsImpl implements _AppSettings {
  const _$AppSettingsImpl({
    required this.userId,
    this.languageCode = 'en',
    this.autoOpenExcelFiles = true,
    this.lastUpdated,
  });

  factory _$AppSettingsImpl.fromJson(Map<String, dynamic> json) =>
      _$$AppSettingsImplFromJson(json);

  /// User ID that these settings belong to
  @override
  final String userId;

  /// Selected language code (e.g., 'en', 'fr')
  @override
  @JsonKey()
  final String languageCode;

  /// Auto-open Excel files after export (default: true)
  @override
  @JsonKey()
  final bool autoOpenExcelFiles;

  /// Timestamp of last update
  @override
  final DateTime? lastUpdated;

  @override
  String toString() {
    return 'AppSettings(userId: $userId, languageCode: $languageCode, autoOpenExcelFiles: $autoOpenExcelFiles, lastUpdated: $lastUpdated)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AppSettingsImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.languageCode, languageCode) ||
                other.languageCode == languageCode) &&
            (identical(other.autoOpenExcelFiles, autoOpenExcelFiles) ||
                other.autoOpenExcelFiles == autoOpenExcelFiles) &&
            (identical(other.lastUpdated, lastUpdated) ||
                other.lastUpdated == lastUpdated));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    userId,
    languageCode,
    autoOpenExcelFiles,
    lastUpdated,
  );

  /// Create a copy of AppSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AppSettingsImplCopyWith<_$AppSettingsImpl> get copyWith =>
      __$$AppSettingsImplCopyWithImpl<_$AppSettingsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AppSettingsImplToJson(this);
  }
}

abstract class _AppSettings implements AppSettings {
  const factory _AppSettings({
    required final String userId,
    final String languageCode,
    final bool autoOpenExcelFiles,
    final DateTime? lastUpdated,
  }) = _$AppSettingsImpl;

  factory _AppSettings.fromJson(Map<String, dynamic> json) =
      _$AppSettingsImpl.fromJson;

  /// User ID that these settings belong to
  @override
  String get userId;

  /// Selected language code (e.g., 'en', 'fr')
  @override
  String get languageCode;

  /// Auto-open Excel files after export (default: true)
  @override
  bool get autoOpenExcelFiles;

  /// Timestamp of last update
  @override
  DateTime? get lastUpdated;

  /// Create a copy of AppSettings
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AppSettingsImplCopyWith<_$AppSettingsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
