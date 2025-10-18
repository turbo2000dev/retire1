// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'wizard_progress.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

WizardProgress _$WizardProgressFromJson(Map<String, dynamic> json) {
  return _WizardProgress.fromJson(json);
}

/// @nodoc
mixin _$WizardProgress {
  String get projectId => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get currentSectionId => throw _privateConstructorUsedError;
  Map<String, WizardSectionStatus> get sectionStatuses =>
      throw _privateConstructorUsedError;
  DateTime get lastUpdated => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  bool? get wizardCompleted => throw _privateConstructorUsedError;
  DateTime? get completedAt => throw _privateConstructorUsedError;

  /// Serializes this WizardProgress to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WizardProgress
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WizardProgressCopyWith<WizardProgress> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WizardProgressCopyWith<$Res> {
  factory $WizardProgressCopyWith(
    WizardProgress value,
    $Res Function(WizardProgress) then,
  ) = _$WizardProgressCopyWithImpl<$Res, WizardProgress>;
  @useResult
  $Res call({
    String projectId,
    String userId,
    String currentSectionId,
    Map<String, WizardSectionStatus> sectionStatuses,
    DateTime lastUpdated,
    DateTime createdAt,
    bool? wizardCompleted,
    DateTime? completedAt,
  });
}

/// @nodoc
class _$WizardProgressCopyWithImpl<$Res, $Val extends WizardProgress>
    implements $WizardProgressCopyWith<$Res> {
  _$WizardProgressCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WizardProgress
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? projectId = null,
    Object? userId = null,
    Object? currentSectionId = null,
    Object? sectionStatuses = null,
    Object? lastUpdated = null,
    Object? createdAt = null,
    Object? wizardCompleted = freezed,
    Object? completedAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            projectId: null == projectId
                ? _value.projectId
                : projectId // ignore: cast_nullable_to_non_nullable
                      as String,
            userId: null == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                      as String,
            currentSectionId: null == currentSectionId
                ? _value.currentSectionId
                : currentSectionId // ignore: cast_nullable_to_non_nullable
                      as String,
            sectionStatuses: null == sectionStatuses
                ? _value.sectionStatuses
                : sectionStatuses // ignore: cast_nullable_to_non_nullable
                      as Map<String, WizardSectionStatus>,
            lastUpdated: null == lastUpdated
                ? _value.lastUpdated
                : lastUpdated // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            wizardCompleted: freezed == wizardCompleted
                ? _value.wizardCompleted
                : wizardCompleted // ignore: cast_nullable_to_non_nullable
                      as bool?,
            completedAt: freezed == completedAt
                ? _value.completedAt
                : completedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$WizardProgressImplCopyWith<$Res>
    implements $WizardProgressCopyWith<$Res> {
  factory _$$WizardProgressImplCopyWith(
    _$WizardProgressImpl value,
    $Res Function(_$WizardProgressImpl) then,
  ) = __$$WizardProgressImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String projectId,
    String userId,
    String currentSectionId,
    Map<String, WizardSectionStatus> sectionStatuses,
    DateTime lastUpdated,
    DateTime createdAt,
    bool? wizardCompleted,
    DateTime? completedAt,
  });
}

/// @nodoc
class __$$WizardProgressImplCopyWithImpl<$Res>
    extends _$WizardProgressCopyWithImpl<$Res, _$WizardProgressImpl>
    implements _$$WizardProgressImplCopyWith<$Res> {
  __$$WizardProgressImplCopyWithImpl(
    _$WizardProgressImpl _value,
    $Res Function(_$WizardProgressImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of WizardProgress
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? projectId = null,
    Object? userId = null,
    Object? currentSectionId = null,
    Object? sectionStatuses = null,
    Object? lastUpdated = null,
    Object? createdAt = null,
    Object? wizardCompleted = freezed,
    Object? completedAt = freezed,
  }) {
    return _then(
      _$WizardProgressImpl(
        projectId: null == projectId
            ? _value.projectId
            : projectId // ignore: cast_nullable_to_non_nullable
                  as String,
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        currentSectionId: null == currentSectionId
            ? _value.currentSectionId
            : currentSectionId // ignore: cast_nullable_to_non_nullable
                  as String,
        sectionStatuses: null == sectionStatuses
            ? _value._sectionStatuses
            : sectionStatuses // ignore: cast_nullable_to_non_nullable
                  as Map<String, WizardSectionStatus>,
        lastUpdated: null == lastUpdated
            ? _value.lastUpdated
            : lastUpdated // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        wizardCompleted: freezed == wizardCompleted
            ? _value.wizardCompleted
            : wizardCompleted // ignore: cast_nullable_to_non_nullable
                  as bool?,
        completedAt: freezed == completedAt
            ? _value.completedAt
            : completedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$WizardProgressImpl extends _WizardProgress {
  const _$WizardProgressImpl({
    required this.projectId,
    required this.userId,
    this.currentSectionId = 'welcome',
    final Map<String, WizardSectionStatus> sectionStatuses = const {},
    required this.lastUpdated,
    required this.createdAt,
    this.wizardCompleted,
    this.completedAt,
  }) : _sectionStatuses = sectionStatuses,
       super._();

  factory _$WizardProgressImpl.fromJson(Map<String, dynamic> json) =>
      _$$WizardProgressImplFromJson(json);

  @override
  final String projectId;
  @override
  final String userId;
  @override
  @JsonKey()
  final String currentSectionId;
  final Map<String, WizardSectionStatus> _sectionStatuses;
  @override
  @JsonKey()
  Map<String, WizardSectionStatus> get sectionStatuses {
    if (_sectionStatuses is EqualUnmodifiableMapView) return _sectionStatuses;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_sectionStatuses);
  }

  @override
  final DateTime lastUpdated;
  @override
  final DateTime createdAt;
  @override
  final bool? wizardCompleted;
  @override
  final DateTime? completedAt;

  @override
  String toString() {
    return 'WizardProgress(projectId: $projectId, userId: $userId, currentSectionId: $currentSectionId, sectionStatuses: $sectionStatuses, lastUpdated: $lastUpdated, createdAt: $createdAt, wizardCompleted: $wizardCompleted, completedAt: $completedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WizardProgressImpl &&
            (identical(other.projectId, projectId) ||
                other.projectId == projectId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.currentSectionId, currentSectionId) ||
                other.currentSectionId == currentSectionId) &&
            const DeepCollectionEquality().equals(
              other._sectionStatuses,
              _sectionStatuses,
            ) &&
            (identical(other.lastUpdated, lastUpdated) ||
                other.lastUpdated == lastUpdated) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.wizardCompleted, wizardCompleted) ||
                other.wizardCompleted == wizardCompleted) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    projectId,
    userId,
    currentSectionId,
    const DeepCollectionEquality().hash(_sectionStatuses),
    lastUpdated,
    createdAt,
    wizardCompleted,
    completedAt,
  );

  /// Create a copy of WizardProgress
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WizardProgressImplCopyWith<_$WizardProgressImpl> get copyWith =>
      __$$WizardProgressImplCopyWithImpl<_$WizardProgressImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$WizardProgressImplToJson(this);
  }
}

abstract class _WizardProgress extends WizardProgress {
  const factory _WizardProgress({
    required final String projectId,
    required final String userId,
    final String currentSectionId,
    final Map<String, WizardSectionStatus> sectionStatuses,
    required final DateTime lastUpdated,
    required final DateTime createdAt,
    final bool? wizardCompleted,
    final DateTime? completedAt,
  }) = _$WizardProgressImpl;
  const _WizardProgress._() : super._();

  factory _WizardProgress.fromJson(Map<String, dynamic> json) =
      _$WizardProgressImpl.fromJson;

  @override
  String get projectId;
  @override
  String get userId;
  @override
  String get currentSectionId;
  @override
  Map<String, WizardSectionStatus> get sectionStatuses;
  @override
  DateTime get lastUpdated;
  @override
  DateTime get createdAt;
  @override
  bool? get wizardCompleted;
  @override
  DateTime? get completedAt;

  /// Create a copy of WizardProgress
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WizardProgressImplCopyWith<_$WizardProgressImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
