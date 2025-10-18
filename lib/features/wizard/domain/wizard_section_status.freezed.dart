// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'wizard_section_status.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

WizardSectionStatus _$WizardSectionStatusFromJson(Map<String, dynamic> json) {
  return _WizardSectionStatus.fromJson(json);
}

/// @nodoc
mixin _$WizardSectionStatus {
  WizardSectionState get state => throw _privateConstructorUsedError;
  DateTime? get lastVisited => throw _privateConstructorUsedError;
  DateTime? get completedAt => throw _privateConstructorUsedError;
  List<String> get validationWarnings => throw _privateConstructorUsedError;

  /// Serializes this WizardSectionStatus to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WizardSectionStatus
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WizardSectionStatusCopyWith<WizardSectionStatus> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WizardSectionStatusCopyWith<$Res> {
  factory $WizardSectionStatusCopyWith(
    WizardSectionStatus value,
    $Res Function(WizardSectionStatus) then,
  ) = _$WizardSectionStatusCopyWithImpl<$Res, WizardSectionStatus>;
  @useResult
  $Res call({
    WizardSectionState state,
    DateTime? lastVisited,
    DateTime? completedAt,
    List<String> validationWarnings,
  });
}

/// @nodoc
class _$WizardSectionStatusCopyWithImpl<$Res, $Val extends WizardSectionStatus>
    implements $WizardSectionStatusCopyWith<$Res> {
  _$WizardSectionStatusCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WizardSectionStatus
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? state = null,
    Object? lastVisited = freezed,
    Object? completedAt = freezed,
    Object? validationWarnings = null,
  }) {
    return _then(
      _value.copyWith(
            state: null == state
                ? _value.state
                : state // ignore: cast_nullable_to_non_nullable
                      as WizardSectionState,
            lastVisited: freezed == lastVisited
                ? _value.lastVisited
                : lastVisited // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            completedAt: freezed == completedAt
                ? _value.completedAt
                : completedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            validationWarnings: null == validationWarnings
                ? _value.validationWarnings
                : validationWarnings // ignore: cast_nullable_to_non_nullable
                      as List<String>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$WizardSectionStatusImplCopyWith<$Res>
    implements $WizardSectionStatusCopyWith<$Res> {
  factory _$$WizardSectionStatusImplCopyWith(
    _$WizardSectionStatusImpl value,
    $Res Function(_$WizardSectionStatusImpl) then,
  ) = __$$WizardSectionStatusImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    WizardSectionState state,
    DateTime? lastVisited,
    DateTime? completedAt,
    List<String> validationWarnings,
  });
}

/// @nodoc
class __$$WizardSectionStatusImplCopyWithImpl<$Res>
    extends _$WizardSectionStatusCopyWithImpl<$Res, _$WizardSectionStatusImpl>
    implements _$$WizardSectionStatusImplCopyWith<$Res> {
  __$$WizardSectionStatusImplCopyWithImpl(
    _$WizardSectionStatusImpl _value,
    $Res Function(_$WizardSectionStatusImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of WizardSectionStatus
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? state = null,
    Object? lastVisited = freezed,
    Object? completedAt = freezed,
    Object? validationWarnings = null,
  }) {
    return _then(
      _$WizardSectionStatusImpl(
        state: null == state
            ? _value.state
            : state // ignore: cast_nullable_to_non_nullable
                  as WizardSectionState,
        lastVisited: freezed == lastVisited
            ? _value.lastVisited
            : lastVisited // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        completedAt: freezed == completedAt
            ? _value.completedAt
            : completedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        validationWarnings: null == validationWarnings
            ? _value._validationWarnings
            : validationWarnings // ignore: cast_nullable_to_non_nullable
                  as List<String>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$WizardSectionStatusImpl extends _WizardSectionStatus {
  const _$WizardSectionStatusImpl({
    required this.state,
    this.lastVisited,
    this.completedAt,
    final List<String> validationWarnings = const [],
  }) : _validationWarnings = validationWarnings,
       super._();

  factory _$WizardSectionStatusImpl.fromJson(Map<String, dynamic> json) =>
      _$$WizardSectionStatusImplFromJson(json);

  @override
  final WizardSectionState state;
  @override
  final DateTime? lastVisited;
  @override
  final DateTime? completedAt;
  final List<String> _validationWarnings;
  @override
  @JsonKey()
  List<String> get validationWarnings {
    if (_validationWarnings is EqualUnmodifiableListView)
      return _validationWarnings;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_validationWarnings);
  }

  @override
  String toString() {
    return 'WizardSectionStatus(state: $state, lastVisited: $lastVisited, completedAt: $completedAt, validationWarnings: $validationWarnings)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WizardSectionStatusImpl &&
            (identical(other.state, state) || other.state == state) &&
            (identical(other.lastVisited, lastVisited) ||
                other.lastVisited == lastVisited) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt) &&
            const DeepCollectionEquality().equals(
              other._validationWarnings,
              _validationWarnings,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    state,
    lastVisited,
    completedAt,
    const DeepCollectionEquality().hash(_validationWarnings),
  );

  /// Create a copy of WizardSectionStatus
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WizardSectionStatusImplCopyWith<_$WizardSectionStatusImpl> get copyWith =>
      __$$WizardSectionStatusImplCopyWithImpl<_$WizardSectionStatusImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$WizardSectionStatusImplToJson(this);
  }
}

abstract class _WizardSectionStatus extends WizardSectionStatus {
  const factory _WizardSectionStatus({
    required final WizardSectionState state,
    final DateTime? lastVisited,
    final DateTime? completedAt,
    final List<String> validationWarnings,
  }) = _$WizardSectionStatusImpl;
  const _WizardSectionStatus._() : super._();

  factory _WizardSectionStatus.fromJson(Map<String, dynamic> json) =
      _$WizardSectionStatusImpl.fromJson;

  @override
  WizardSectionState get state;
  @override
  DateTime? get lastVisited;
  @override
  DateTime? get completedAt;
  @override
  List<String> get validationWarnings;

  /// Create a copy of WizardSectionStatus
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WizardSectionStatusImplCopyWith<_$WizardSectionStatusImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
