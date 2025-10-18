// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'wizard_section.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

WizardSection _$WizardSectionFromJson(Map<String, dynamic> json) {
  return _WizardSection.fromJson(json);
}

/// @nodoc
mixin _$WizardSection {
  String get id => throw _privateConstructorUsedError;
  String get titleKey => throw _privateConstructorUsedError;
  String get descriptionKey => throw _privateConstructorUsedError;
  WizardSectionCategory get category => throw _privateConstructorUsedError;
  bool get isRequired => throw _privateConstructorUsedError;
  bool get isEducational => throw _privateConstructorUsedError;
  int get orderIndex => throw _privateConstructorUsedError;
  String? get dependsOnSectionId => throw _privateConstructorUsedError;

  /// Serializes this WizardSection to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WizardSection
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WizardSectionCopyWith<WizardSection> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WizardSectionCopyWith<$Res> {
  factory $WizardSectionCopyWith(
    WizardSection value,
    $Res Function(WizardSection) then,
  ) = _$WizardSectionCopyWithImpl<$Res, WizardSection>;
  @useResult
  $Res call({
    String id,
    String titleKey,
    String descriptionKey,
    WizardSectionCategory category,
    bool isRequired,
    bool isEducational,
    int orderIndex,
    String? dependsOnSectionId,
  });
}

/// @nodoc
class _$WizardSectionCopyWithImpl<$Res, $Val extends WizardSection>
    implements $WizardSectionCopyWith<$Res> {
  _$WizardSectionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WizardSection
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? titleKey = null,
    Object? descriptionKey = null,
    Object? category = null,
    Object? isRequired = null,
    Object? isEducational = null,
    Object? orderIndex = null,
    Object? dependsOnSectionId = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            titleKey: null == titleKey
                ? _value.titleKey
                : titleKey // ignore: cast_nullable_to_non_nullable
                      as String,
            descriptionKey: null == descriptionKey
                ? _value.descriptionKey
                : descriptionKey // ignore: cast_nullable_to_non_nullable
                      as String,
            category: null == category
                ? _value.category
                : category // ignore: cast_nullable_to_non_nullable
                      as WizardSectionCategory,
            isRequired: null == isRequired
                ? _value.isRequired
                : isRequired // ignore: cast_nullable_to_non_nullable
                      as bool,
            isEducational: null == isEducational
                ? _value.isEducational
                : isEducational // ignore: cast_nullable_to_non_nullable
                      as bool,
            orderIndex: null == orderIndex
                ? _value.orderIndex
                : orderIndex // ignore: cast_nullable_to_non_nullable
                      as int,
            dependsOnSectionId: freezed == dependsOnSectionId
                ? _value.dependsOnSectionId
                : dependsOnSectionId // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$WizardSectionImplCopyWith<$Res>
    implements $WizardSectionCopyWith<$Res> {
  factory _$$WizardSectionImplCopyWith(
    _$WizardSectionImpl value,
    $Res Function(_$WizardSectionImpl) then,
  ) = __$$WizardSectionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String titleKey,
    String descriptionKey,
    WizardSectionCategory category,
    bool isRequired,
    bool isEducational,
    int orderIndex,
    String? dependsOnSectionId,
  });
}

/// @nodoc
class __$$WizardSectionImplCopyWithImpl<$Res>
    extends _$WizardSectionCopyWithImpl<$Res, _$WizardSectionImpl>
    implements _$$WizardSectionImplCopyWith<$Res> {
  __$$WizardSectionImplCopyWithImpl(
    _$WizardSectionImpl _value,
    $Res Function(_$WizardSectionImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of WizardSection
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? titleKey = null,
    Object? descriptionKey = null,
    Object? category = null,
    Object? isRequired = null,
    Object? isEducational = null,
    Object? orderIndex = null,
    Object? dependsOnSectionId = freezed,
  }) {
    return _then(
      _$WizardSectionImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        titleKey: null == titleKey
            ? _value.titleKey
            : titleKey // ignore: cast_nullable_to_non_nullable
                  as String,
        descriptionKey: null == descriptionKey
            ? _value.descriptionKey
            : descriptionKey // ignore: cast_nullable_to_non_nullable
                  as String,
        category: null == category
            ? _value.category
            : category // ignore: cast_nullable_to_non_nullable
                  as WizardSectionCategory,
        isRequired: null == isRequired
            ? _value.isRequired
            : isRequired // ignore: cast_nullable_to_non_nullable
                  as bool,
        isEducational: null == isEducational
            ? _value.isEducational
            : isEducational // ignore: cast_nullable_to_non_nullable
                  as bool,
        orderIndex: null == orderIndex
            ? _value.orderIndex
            : orderIndex // ignore: cast_nullable_to_non_nullable
                  as int,
        dependsOnSectionId: freezed == dependsOnSectionId
            ? _value.dependsOnSectionId
            : dependsOnSectionId // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$WizardSectionImpl implements _WizardSection {
  const _$WizardSectionImpl({
    required this.id,
    required this.titleKey,
    required this.descriptionKey,
    required this.category,
    required this.isRequired,
    required this.isEducational,
    this.orderIndex = 0,
    this.dependsOnSectionId,
  });

  factory _$WizardSectionImpl.fromJson(Map<String, dynamic> json) =>
      _$$WizardSectionImplFromJson(json);

  @override
  final String id;
  @override
  final String titleKey;
  @override
  final String descriptionKey;
  @override
  final WizardSectionCategory category;
  @override
  final bool isRequired;
  @override
  final bool isEducational;
  @override
  @JsonKey()
  final int orderIndex;
  @override
  final String? dependsOnSectionId;

  @override
  String toString() {
    return 'WizardSection(id: $id, titleKey: $titleKey, descriptionKey: $descriptionKey, category: $category, isRequired: $isRequired, isEducational: $isEducational, orderIndex: $orderIndex, dependsOnSectionId: $dependsOnSectionId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WizardSectionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.titleKey, titleKey) ||
                other.titleKey == titleKey) &&
            (identical(other.descriptionKey, descriptionKey) ||
                other.descriptionKey == descriptionKey) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.isRequired, isRequired) ||
                other.isRequired == isRequired) &&
            (identical(other.isEducational, isEducational) ||
                other.isEducational == isEducational) &&
            (identical(other.orderIndex, orderIndex) ||
                other.orderIndex == orderIndex) &&
            (identical(other.dependsOnSectionId, dependsOnSectionId) ||
                other.dependsOnSectionId == dependsOnSectionId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    titleKey,
    descriptionKey,
    category,
    isRequired,
    isEducational,
    orderIndex,
    dependsOnSectionId,
  );

  /// Create a copy of WizardSection
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WizardSectionImplCopyWith<_$WizardSectionImpl> get copyWith =>
      __$$WizardSectionImplCopyWithImpl<_$WizardSectionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WizardSectionImplToJson(this);
  }
}

abstract class _WizardSection implements WizardSection {
  const factory _WizardSection({
    required final String id,
    required final String titleKey,
    required final String descriptionKey,
    required final WizardSectionCategory category,
    required final bool isRequired,
    required final bool isEducational,
    final int orderIndex,
    final String? dependsOnSectionId,
  }) = _$WizardSectionImpl;

  factory _WizardSection.fromJson(Map<String, dynamic> json) =
      _$WizardSectionImpl.fromJson;

  @override
  String get id;
  @override
  String get titleKey;
  @override
  String get descriptionKey;
  @override
  WizardSectionCategory get category;
  @override
  bool get isRequired;
  @override
  bool get isEducational;
  @override
  int get orderIndex;
  @override
  String? get dependsOnSectionId;

  /// Create a copy of WizardSection
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WizardSectionImplCopyWith<_$WizardSectionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
