// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'individual.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Individual _$IndividualFromJson(Map<String, dynamic> json) {
  return _Individual.fromJson(json);
}

/// @nodoc
mixin _$Individual {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  DateTime get birthdate => throw _privateConstructorUsedError;
  double get employmentIncome =>
      throw _privateConstructorUsedError; // Annual salary
  int get rrqStartAge =>
      throw _privateConstructorUsedError; // RRQ start age (60-70)
  int get psvStartAge =>
      throw _privateConstructorUsedError; // PSV start age (65-70, OAS age)
  double get rrqAnnualBenefit => throw _privateConstructorUsedError;

  /// Serializes this Individual to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Individual
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $IndividualCopyWith<Individual> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $IndividualCopyWith<$Res> {
  factory $IndividualCopyWith(
    Individual value,
    $Res Function(Individual) then,
  ) = _$IndividualCopyWithImpl<$Res, Individual>;
  @useResult
  $Res call({
    String id,
    String name,
    DateTime birthdate,
    double employmentIncome,
    int rrqStartAge,
    int psvStartAge,
    double rrqAnnualBenefit,
  });
}

/// @nodoc
class _$IndividualCopyWithImpl<$Res, $Val extends Individual>
    implements $IndividualCopyWith<$Res> {
  _$IndividualCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Individual
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? birthdate = null,
    Object? employmentIncome = null,
    Object? rrqStartAge = null,
    Object? psvStartAge = null,
    Object? rrqAnnualBenefit = null,
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
            birthdate: null == birthdate
                ? _value.birthdate
                : birthdate // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            employmentIncome: null == employmentIncome
                ? _value.employmentIncome
                : employmentIncome // ignore: cast_nullable_to_non_nullable
                      as double,
            rrqStartAge: null == rrqStartAge
                ? _value.rrqStartAge
                : rrqStartAge // ignore: cast_nullable_to_non_nullable
                      as int,
            psvStartAge: null == psvStartAge
                ? _value.psvStartAge
                : psvStartAge // ignore: cast_nullable_to_non_nullable
                      as int,
            rrqAnnualBenefit: null == rrqAnnualBenefit
                ? _value.rrqAnnualBenefit
                : rrqAnnualBenefit // ignore: cast_nullable_to_non_nullable
                      as double,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$IndividualImplCopyWith<$Res>
    implements $IndividualCopyWith<$Res> {
  factory _$$IndividualImplCopyWith(
    _$IndividualImpl value,
    $Res Function(_$IndividualImpl) then,
  ) = __$$IndividualImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    DateTime birthdate,
    double employmentIncome,
    int rrqStartAge,
    int psvStartAge,
    double rrqAnnualBenefit,
  });
}

/// @nodoc
class __$$IndividualImplCopyWithImpl<$Res>
    extends _$IndividualCopyWithImpl<$Res, _$IndividualImpl>
    implements _$$IndividualImplCopyWith<$Res> {
  __$$IndividualImplCopyWithImpl(
    _$IndividualImpl _value,
    $Res Function(_$IndividualImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Individual
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? birthdate = null,
    Object? employmentIncome = null,
    Object? rrqStartAge = null,
    Object? psvStartAge = null,
    Object? rrqAnnualBenefit = null,
  }) {
    return _then(
      _$IndividualImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        birthdate: null == birthdate
            ? _value.birthdate
            : birthdate // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        employmentIncome: null == employmentIncome
            ? _value.employmentIncome
            : employmentIncome // ignore: cast_nullable_to_non_nullable
                  as double,
        rrqStartAge: null == rrqStartAge
            ? _value.rrqStartAge
            : rrqStartAge // ignore: cast_nullable_to_non_nullable
                  as int,
        psvStartAge: null == psvStartAge
            ? _value.psvStartAge
            : psvStartAge // ignore: cast_nullable_to_non_nullable
                  as int,
        rrqAnnualBenefit: null == rrqAnnualBenefit
            ? _value.rrqAnnualBenefit
            : rrqAnnualBenefit // ignore: cast_nullable_to_non_nullable
                  as double,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$IndividualImpl extends _Individual {
  const _$IndividualImpl({
    required this.id,
    required this.name,
    required this.birthdate,
    this.employmentIncome = 0.0,
    this.rrqStartAge = 65,
    this.psvStartAge = 65,
    this.rrqAnnualBenefit = 16000.0,
  }) : super._();

  factory _$IndividualImpl.fromJson(Map<String, dynamic> json) =>
      _$$IndividualImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final DateTime birthdate;
  @override
  @JsonKey()
  final double employmentIncome;
  // Annual salary
  @override
  @JsonKey()
  final int rrqStartAge;
  // RRQ start age (60-70)
  @override
  @JsonKey()
  final int psvStartAge;
  // PSV start age (65-70, OAS age)
  @override
  @JsonKey()
  final double rrqAnnualBenefit;

  @override
  String toString() {
    return 'Individual(id: $id, name: $name, birthdate: $birthdate, employmentIncome: $employmentIncome, rrqStartAge: $rrqStartAge, psvStartAge: $psvStartAge, rrqAnnualBenefit: $rrqAnnualBenefit)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$IndividualImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.birthdate, birthdate) ||
                other.birthdate == birthdate) &&
            (identical(other.employmentIncome, employmentIncome) ||
                other.employmentIncome == employmentIncome) &&
            (identical(other.rrqStartAge, rrqStartAge) ||
                other.rrqStartAge == rrqStartAge) &&
            (identical(other.psvStartAge, psvStartAge) ||
                other.psvStartAge == psvStartAge) &&
            (identical(other.rrqAnnualBenefit, rrqAnnualBenefit) ||
                other.rrqAnnualBenefit == rrqAnnualBenefit));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    birthdate,
    employmentIncome,
    rrqStartAge,
    psvStartAge,
    rrqAnnualBenefit,
  );

  /// Create a copy of Individual
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$IndividualImplCopyWith<_$IndividualImpl> get copyWith =>
      __$$IndividualImplCopyWithImpl<_$IndividualImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$IndividualImplToJson(this);
  }
}

abstract class _Individual extends Individual {
  const factory _Individual({
    required final String id,
    required final String name,
    required final DateTime birthdate,
    final double employmentIncome,
    final int rrqStartAge,
    final int psvStartAge,
    final double rrqAnnualBenefit,
  }) = _$IndividualImpl;
  const _Individual._() : super._();

  factory _Individual.fromJson(Map<String, dynamic> json) =
      _$IndividualImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  DateTime get birthdate;
  @override
  double get employmentIncome; // Annual salary
  @override
  int get rrqStartAge; // RRQ start age (60-70)
  @override
  int get psvStartAge; // PSV start age (65-70, OAS age)
  @override
  double get rrqAnnualBenefit;

  /// Create a copy of Individual
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$IndividualImplCopyWith<_$IndividualImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
