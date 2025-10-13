// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'project.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Project _$ProjectFromJson(Map<String, dynamic> json) {
  return _Project.fromJson(json);
}

/// @nodoc
mixin _$Project {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get ownerId => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;
  List<Individual> get individuals =>
      throw _privateConstructorUsedError; // Economic assumptions (rates in decimal form, e.g., 0.02 = 2%)
  double get inflationRate => throw _privateConstructorUsedError;
  double get reerReturnRate => throw _privateConstructorUsedError;
  double get celiReturnRate => throw _privateConstructorUsedError;
  double get criReturnRate => throw _privateConstructorUsedError;
  double get cashReturnRate => throw _privateConstructorUsedError;

  /// Serializes this Project to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Project
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProjectCopyWith<Project> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProjectCopyWith<$Res> {
  factory $ProjectCopyWith(Project value, $Res Function(Project) then) =
      _$ProjectCopyWithImpl<$Res, Project>;
  @useResult
  $Res call({
    String id,
    String name,
    String ownerId,
    String? description,
    DateTime createdAt,
    DateTime updatedAt,
    List<Individual> individuals,
    double inflationRate,
    double reerReturnRate,
    double celiReturnRate,
    double criReturnRate,
    double cashReturnRate,
  });
}

/// @nodoc
class _$ProjectCopyWithImpl<$Res, $Val extends Project>
    implements $ProjectCopyWith<$Res> {
  _$ProjectCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Project
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? ownerId = null,
    Object? description = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? individuals = null,
    Object? inflationRate = null,
    Object? reerReturnRate = null,
    Object? celiReturnRate = null,
    Object? criReturnRate = null,
    Object? cashReturnRate = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            ownerId: null == ownerId
                ? _value.ownerId
                : ownerId // ignore: cast_nullable_to_non_nullable
                      as String,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            updatedAt: null == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            individuals: null == individuals
                ? _value.individuals
                : individuals // ignore: cast_nullable_to_non_nullable
                      as List<Individual>,
            inflationRate: null == inflationRate
                ? _value.inflationRate
                : inflationRate // ignore: cast_nullable_to_non_nullable
                      as double,
            reerReturnRate: null == reerReturnRate
                ? _value.reerReturnRate
                : reerReturnRate // ignore: cast_nullable_to_non_nullable
                      as double,
            celiReturnRate: null == celiReturnRate
                ? _value.celiReturnRate
                : celiReturnRate // ignore: cast_nullable_to_non_nullable
                      as double,
            criReturnRate: null == criReturnRate
                ? _value.criReturnRate
                : criReturnRate // ignore: cast_nullable_to_non_nullable
                      as double,
            cashReturnRate: null == cashReturnRate
                ? _value.cashReturnRate
                : cashReturnRate // ignore: cast_nullable_to_non_nullable
                      as double,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ProjectImplCopyWith<$Res> implements $ProjectCopyWith<$Res> {
  factory _$$ProjectImplCopyWith(
    _$ProjectImpl value,
    $Res Function(_$ProjectImpl) then,
  ) = __$$ProjectImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    String ownerId,
    String? description,
    DateTime createdAt,
    DateTime updatedAt,
    List<Individual> individuals,
    double inflationRate,
    double reerReturnRate,
    double celiReturnRate,
    double criReturnRate,
    double cashReturnRate,
  });
}

/// @nodoc
class __$$ProjectImplCopyWithImpl<$Res>
    extends _$ProjectCopyWithImpl<$Res, _$ProjectImpl>
    implements _$$ProjectImplCopyWith<$Res> {
  __$$ProjectImplCopyWithImpl(
    _$ProjectImpl _value,
    $Res Function(_$ProjectImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Project
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? ownerId = null,
    Object? description = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? individuals = null,
    Object? inflationRate = null,
    Object? reerReturnRate = null,
    Object? celiReturnRate = null,
    Object? criReturnRate = null,
    Object? cashReturnRate = null,
  }) {
    return _then(
      _$ProjectImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        ownerId: null == ownerId
            ? _value.ownerId
            : ownerId // ignore: cast_nullable_to_non_nullable
                  as String,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        updatedAt: null == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        individuals: null == individuals
            ? _value._individuals
            : individuals // ignore: cast_nullable_to_non_nullable
                  as List<Individual>,
        inflationRate: null == inflationRate
            ? _value.inflationRate
            : inflationRate // ignore: cast_nullable_to_non_nullable
                  as double,
        reerReturnRate: null == reerReturnRate
            ? _value.reerReturnRate
            : reerReturnRate // ignore: cast_nullable_to_non_nullable
                  as double,
        celiReturnRate: null == celiReturnRate
            ? _value.celiReturnRate
            : celiReturnRate // ignore: cast_nullable_to_non_nullable
                  as double,
        criReturnRate: null == criReturnRate
            ? _value.criReturnRate
            : criReturnRate // ignore: cast_nullable_to_non_nullable
                  as double,
        cashReturnRate: null == cashReturnRate
            ? _value.cashReturnRate
            : cashReturnRate // ignore: cast_nullable_to_non_nullable
                  as double,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ProjectImpl implements _Project {
  const _$ProjectImpl({
    required this.id,
    required this.name,
    required this.ownerId,
    this.description,
    required this.createdAt,
    required this.updatedAt,
    final List<Individual> individuals = const [],
    this.inflationRate = 0.02,
    this.reerReturnRate = 0.05,
    this.celiReturnRate = 0.05,
    this.criReturnRate = 0.05,
    this.cashReturnRate = 0.015,
  }) : _individuals = individuals;

  factory _$ProjectImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProjectImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String ownerId;
  @override
  final String? description;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  final List<Individual> _individuals;
  @override
  @JsonKey()
  List<Individual> get individuals {
    if (_individuals is EqualUnmodifiableListView) return _individuals;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_individuals);
  }

  // Economic assumptions (rates in decimal form, e.g., 0.02 = 2%)
  @override
  @JsonKey()
  final double inflationRate;
  @override
  @JsonKey()
  final double reerReturnRate;
  @override
  @JsonKey()
  final double celiReturnRate;
  @override
  @JsonKey()
  final double criReturnRate;
  @override
  @JsonKey()
  final double cashReturnRate;

  @override
  String toString() {
    return 'Project(id: $id, name: $name, ownerId: $ownerId, description: $description, createdAt: $createdAt, updatedAt: $updatedAt, individuals: $individuals, inflationRate: $inflationRate, reerReturnRate: $reerReturnRate, celiReturnRate: $celiReturnRate, criReturnRate: $criReturnRate, cashReturnRate: $cashReturnRate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProjectImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.ownerId, ownerId) || other.ownerId == ownerId) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            const DeepCollectionEquality().equals(
              other._individuals,
              _individuals,
            ) &&
            (identical(other.inflationRate, inflationRate) ||
                other.inflationRate == inflationRate) &&
            (identical(other.reerReturnRate, reerReturnRate) ||
                other.reerReturnRate == reerReturnRate) &&
            (identical(other.celiReturnRate, celiReturnRate) ||
                other.celiReturnRate == celiReturnRate) &&
            (identical(other.criReturnRate, criReturnRate) ||
                other.criReturnRate == criReturnRate) &&
            (identical(other.cashReturnRate, cashReturnRate) ||
                other.cashReturnRate == cashReturnRate));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    ownerId,
    description,
    createdAt,
    updatedAt,
    const DeepCollectionEquality().hash(_individuals),
    inflationRate,
    reerReturnRate,
    celiReturnRate,
    criReturnRate,
    cashReturnRate,
  );

  /// Create a copy of Project
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProjectImplCopyWith<_$ProjectImpl> get copyWith =>
      __$$ProjectImplCopyWithImpl<_$ProjectImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProjectImplToJson(this);
  }
}

abstract class _Project implements Project {
  const factory _Project({
    required final String id,
    required final String name,
    required final String ownerId,
    final String? description,
    required final DateTime createdAt,
    required final DateTime updatedAt,
    final List<Individual> individuals,
    final double inflationRate,
    final double reerReturnRate,
    final double celiReturnRate,
    final double criReturnRate,
    final double cashReturnRate,
  }) = _$ProjectImpl;

  factory _Project.fromJson(Map<String, dynamic> json) = _$ProjectImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get ownerId;
  @override
  String? get description;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;
  @override
  List<Individual> get individuals; // Economic assumptions (rates in decimal form, e.g., 0.02 = 2%)
  @override
  double get inflationRate;
  @override
  double get reerReturnRate;
  @override
  double get celiReturnRate;
  @override
  double get criReturnRate;
  @override
  double get cashReturnRate;

  /// Create a copy of Project
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProjectImplCopyWith<_$ProjectImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
