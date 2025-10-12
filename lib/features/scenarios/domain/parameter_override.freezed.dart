// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'parameter_override.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ParameterOverride _$ParameterOverrideFromJson(Map<String, dynamic> json) {
  switch (json['runtimeType']) {
    case 'assetValue':
      return AssetValueOverride.fromJson(json);
    case 'eventTiming':
      return EventTimingOverride.fromJson(json);

    default:
      throw CheckedFromJsonException(
        json,
        'runtimeType',
        'ParameterOverride',
        'Invalid union type "${json['runtimeType']}"!',
      );
  }
}

/// @nodoc
mixin _$ParameterOverride {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String assetId, double value) assetValue,
    required TResult Function(String eventId, int yearsFromStart) eventTiming,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String assetId, double value)? assetValue,
    TResult? Function(String eventId, int yearsFromStart)? eventTiming,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String assetId, double value)? assetValue,
    TResult Function(String eventId, int yearsFromStart)? eventTiming,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AssetValueOverride value) assetValue,
    required TResult Function(EventTimingOverride value) eventTiming,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AssetValueOverride value)? assetValue,
    TResult? Function(EventTimingOverride value)? eventTiming,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AssetValueOverride value)? assetValue,
    TResult Function(EventTimingOverride value)? eventTiming,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;

  /// Serializes this ParameterOverride to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ParameterOverrideCopyWith<$Res> {
  factory $ParameterOverrideCopyWith(
    ParameterOverride value,
    $Res Function(ParameterOverride) then,
  ) = _$ParameterOverrideCopyWithImpl<$Res, ParameterOverride>;
}

/// @nodoc
class _$ParameterOverrideCopyWithImpl<$Res, $Val extends ParameterOverride>
    implements $ParameterOverrideCopyWith<$Res> {
  _$ParameterOverrideCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ParameterOverride
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$AssetValueOverrideImplCopyWith<$Res> {
  factory _$$AssetValueOverrideImplCopyWith(
    _$AssetValueOverrideImpl value,
    $Res Function(_$AssetValueOverrideImpl) then,
  ) = __$$AssetValueOverrideImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String assetId, double value});
}

/// @nodoc
class __$$AssetValueOverrideImplCopyWithImpl<$Res>
    extends _$ParameterOverrideCopyWithImpl<$Res, _$AssetValueOverrideImpl>
    implements _$$AssetValueOverrideImplCopyWith<$Res> {
  __$$AssetValueOverrideImplCopyWithImpl(
    _$AssetValueOverrideImpl _value,
    $Res Function(_$AssetValueOverrideImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ParameterOverride
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? assetId = null, Object? value = null}) {
    return _then(
      _$AssetValueOverrideImpl(
        assetId: null == assetId
            ? _value.assetId
            : assetId // ignore: cast_nullable_to_non_nullable
                  as String,
        value: null == value
            ? _value.value
            : value // ignore: cast_nullable_to_non_nullable
                  as double,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AssetValueOverrideImpl implements AssetValueOverride {
  const _$AssetValueOverrideImpl({
    required this.assetId,
    required this.value,
    final String? $type,
  }) : $type = $type ?? 'assetValue';

  factory _$AssetValueOverrideImpl.fromJson(Map<String, dynamic> json) =>
      _$$AssetValueOverrideImplFromJson(json);

  @override
  final String assetId;
  @override
  final double value;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'ParameterOverride.assetValue(assetId: $assetId, value: $value)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AssetValueOverrideImpl &&
            (identical(other.assetId, assetId) || other.assetId == assetId) &&
            (identical(other.value, value) || other.value == value));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, assetId, value);

  /// Create a copy of ParameterOverride
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AssetValueOverrideImplCopyWith<_$AssetValueOverrideImpl> get copyWith =>
      __$$AssetValueOverrideImplCopyWithImpl<_$AssetValueOverrideImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String assetId, double value) assetValue,
    required TResult Function(String eventId, int yearsFromStart) eventTiming,
  }) {
    return assetValue(assetId, value);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String assetId, double value)? assetValue,
    TResult? Function(String eventId, int yearsFromStart)? eventTiming,
  }) {
    return assetValue?.call(assetId, value);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String assetId, double value)? assetValue,
    TResult Function(String eventId, int yearsFromStart)? eventTiming,
    required TResult orElse(),
  }) {
    if (assetValue != null) {
      return assetValue(assetId, value);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AssetValueOverride value) assetValue,
    required TResult Function(EventTimingOverride value) eventTiming,
  }) {
    return assetValue(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AssetValueOverride value)? assetValue,
    TResult? Function(EventTimingOverride value)? eventTiming,
  }) {
    return assetValue?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AssetValueOverride value)? assetValue,
    TResult Function(EventTimingOverride value)? eventTiming,
    required TResult orElse(),
  }) {
    if (assetValue != null) {
      return assetValue(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$AssetValueOverrideImplToJson(this);
  }
}

abstract class AssetValueOverride implements ParameterOverride {
  const factory AssetValueOverride({
    required final String assetId,
    required final double value,
  }) = _$AssetValueOverrideImpl;

  factory AssetValueOverride.fromJson(Map<String, dynamic> json) =
      _$AssetValueOverrideImpl.fromJson;

  String get assetId;
  double get value;

  /// Create a copy of ParameterOverride
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AssetValueOverrideImplCopyWith<_$AssetValueOverrideImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$EventTimingOverrideImplCopyWith<$Res> {
  factory _$$EventTimingOverrideImplCopyWith(
    _$EventTimingOverrideImpl value,
    $Res Function(_$EventTimingOverrideImpl) then,
  ) = __$$EventTimingOverrideImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String eventId, int yearsFromStart});
}

/// @nodoc
class __$$EventTimingOverrideImplCopyWithImpl<$Res>
    extends _$ParameterOverrideCopyWithImpl<$Res, _$EventTimingOverrideImpl>
    implements _$$EventTimingOverrideImplCopyWith<$Res> {
  __$$EventTimingOverrideImplCopyWithImpl(
    _$EventTimingOverrideImpl _value,
    $Res Function(_$EventTimingOverrideImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ParameterOverride
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? eventId = null, Object? yearsFromStart = null}) {
    return _then(
      _$EventTimingOverrideImpl(
        eventId: null == eventId
            ? _value.eventId
            : eventId // ignore: cast_nullable_to_non_nullable
                  as String,
        yearsFromStart: null == yearsFromStart
            ? _value.yearsFromStart
            : yearsFromStart // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$EventTimingOverrideImpl implements EventTimingOverride {
  const _$EventTimingOverrideImpl({
    required this.eventId,
    required this.yearsFromStart,
    final String? $type,
  }) : $type = $type ?? 'eventTiming';

  factory _$EventTimingOverrideImpl.fromJson(Map<String, dynamic> json) =>
      _$$EventTimingOverrideImplFromJson(json);

  @override
  final String eventId;
  @override
  final int yearsFromStart;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'ParameterOverride.eventTiming(eventId: $eventId, yearsFromStart: $yearsFromStart)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EventTimingOverrideImpl &&
            (identical(other.eventId, eventId) || other.eventId == eventId) &&
            (identical(other.yearsFromStart, yearsFromStart) ||
                other.yearsFromStart == yearsFromStart));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, eventId, yearsFromStart);

  /// Create a copy of ParameterOverride
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$EventTimingOverrideImplCopyWith<_$EventTimingOverrideImpl> get copyWith =>
      __$$EventTimingOverrideImplCopyWithImpl<_$EventTimingOverrideImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String assetId, double value) assetValue,
    required TResult Function(String eventId, int yearsFromStart) eventTiming,
  }) {
    return eventTiming(eventId, yearsFromStart);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String assetId, double value)? assetValue,
    TResult? Function(String eventId, int yearsFromStart)? eventTiming,
  }) {
    return eventTiming?.call(eventId, yearsFromStart);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String assetId, double value)? assetValue,
    TResult Function(String eventId, int yearsFromStart)? eventTiming,
    required TResult orElse(),
  }) {
    if (eventTiming != null) {
      return eventTiming(eventId, yearsFromStart);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AssetValueOverride value) assetValue,
    required TResult Function(EventTimingOverride value) eventTiming,
  }) {
    return eventTiming(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AssetValueOverride value)? assetValue,
    TResult? Function(EventTimingOverride value)? eventTiming,
  }) {
    return eventTiming?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AssetValueOverride value)? assetValue,
    TResult Function(EventTimingOverride value)? eventTiming,
    required TResult orElse(),
  }) {
    if (eventTiming != null) {
      return eventTiming(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$EventTimingOverrideImplToJson(this);
  }
}

abstract class EventTimingOverride implements ParameterOverride {
  const factory EventTimingOverride({
    required final String eventId,
    required final int yearsFromStart,
  }) = _$EventTimingOverrideImpl;

  factory EventTimingOverride.fromJson(Map<String, dynamic> json) =
      _$EventTimingOverrideImpl.fromJson;

  String get eventId;
  int get yearsFromStart;

  /// Create a copy of ParameterOverride
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EventTimingOverrideImplCopyWith<_$EventTimingOverrideImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
