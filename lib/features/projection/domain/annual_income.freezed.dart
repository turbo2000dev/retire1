// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'annual_income.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

AnnualIncome _$AnnualIncomeFromJson(Map<String, dynamic> json) {
  return _AnnualIncome.fromJson(json);
}

/// @nodoc
mixin _$AnnualIncome {
  /// Employment income (salary/wages)
  double get employment => throw _privateConstructorUsedError;

  /// RRQ (Régime de rentes du Québec / Quebec Pension Plan) benefit
  double get rrq => throw _privateConstructorUsedError;

  /// PSV (Pension de la Sécurité de la vieillesse / Old Age Security) benefit
  double get psv => throw _privateConstructorUsedError;

  /// RRIF/CRI minimum withdrawal (formerly called rrpe)
  double get rrif => throw _privateConstructorUsedError;

  /// RRPE (Régime de retraite du personnel d'encadrement) pension
  double get rrpe => throw _privateConstructorUsedError;

  /// Other income sources (dividends, rental income, survivor benefits, etc.)
  double get other => throw _privateConstructorUsedError;

  /// Serializes this AnnualIncome to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AnnualIncome
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AnnualIncomeCopyWith<AnnualIncome> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AnnualIncomeCopyWith<$Res> {
  factory $AnnualIncomeCopyWith(
    AnnualIncome value,
    $Res Function(AnnualIncome) then,
  ) = _$AnnualIncomeCopyWithImpl<$Res, AnnualIncome>;
  @useResult
  $Res call({
    double employment,
    double rrq,
    double psv,
    double rrif,
    double rrpe,
    double other,
  });
}

/// @nodoc
class _$AnnualIncomeCopyWithImpl<$Res, $Val extends AnnualIncome>
    implements $AnnualIncomeCopyWith<$Res> {
  _$AnnualIncomeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AnnualIncome
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? employment = null,
    Object? rrq = null,
    Object? psv = null,
    Object? rrif = null,
    Object? rrpe = null,
    Object? other = null,
  }) {
    return _then(
      _value.copyWith(
            employment: null == employment
                ? _value.employment
                : employment // ignore: cast_nullable_to_non_nullable
                      as double,
            rrq: null == rrq
                ? _value.rrq
                : rrq // ignore: cast_nullable_to_non_nullable
                      as double,
            psv: null == psv
                ? _value.psv
                : psv // ignore: cast_nullable_to_non_nullable
                      as double,
            rrif: null == rrif
                ? _value.rrif
                : rrif // ignore: cast_nullable_to_non_nullable
                      as double,
            rrpe: null == rrpe
                ? _value.rrpe
                : rrpe // ignore: cast_nullable_to_non_nullable
                      as double,
            other: null == other
                ? _value.other
                : other // ignore: cast_nullable_to_non_nullable
                      as double,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AnnualIncomeImplCopyWith<$Res>
    implements $AnnualIncomeCopyWith<$Res> {
  factory _$$AnnualIncomeImplCopyWith(
    _$AnnualIncomeImpl value,
    $Res Function(_$AnnualIncomeImpl) then,
  ) = __$$AnnualIncomeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    double employment,
    double rrq,
    double psv,
    double rrif,
    double rrpe,
    double other,
  });
}

/// @nodoc
class __$$AnnualIncomeImplCopyWithImpl<$Res>
    extends _$AnnualIncomeCopyWithImpl<$Res, _$AnnualIncomeImpl>
    implements _$$AnnualIncomeImplCopyWith<$Res> {
  __$$AnnualIncomeImplCopyWithImpl(
    _$AnnualIncomeImpl _value,
    $Res Function(_$AnnualIncomeImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AnnualIncome
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? employment = null,
    Object? rrq = null,
    Object? psv = null,
    Object? rrif = null,
    Object? rrpe = null,
    Object? other = null,
  }) {
    return _then(
      _$AnnualIncomeImpl(
        employment: null == employment
            ? _value.employment
            : employment // ignore: cast_nullable_to_non_nullable
                  as double,
        rrq: null == rrq
            ? _value.rrq
            : rrq // ignore: cast_nullable_to_non_nullable
                  as double,
        psv: null == psv
            ? _value.psv
            : psv // ignore: cast_nullable_to_non_nullable
                  as double,
        rrif: null == rrif
            ? _value.rrif
            : rrif // ignore: cast_nullable_to_non_nullable
                  as double,
        rrpe: null == rrpe
            ? _value.rrpe
            : rrpe // ignore: cast_nullable_to_non_nullable
                  as double,
        other: null == other
            ? _value.other
            : other // ignore: cast_nullable_to_non_nullable
                  as double,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AnnualIncomeImpl extends _AnnualIncome {
  const _$AnnualIncomeImpl({
    this.employment = 0.0,
    this.rrq = 0.0,
    this.psv = 0.0,
    this.rrif = 0.0,
    this.rrpe = 0.0,
    this.other = 0.0,
  }) : super._();

  factory _$AnnualIncomeImpl.fromJson(Map<String, dynamic> json) =>
      _$$AnnualIncomeImplFromJson(json);

  /// Employment income (salary/wages)
  @override
  @JsonKey()
  final double employment;

  /// RRQ (Régime de rentes du Québec / Quebec Pension Plan) benefit
  @override
  @JsonKey()
  final double rrq;

  /// PSV (Pension de la Sécurité de la vieillesse / Old Age Security) benefit
  @override
  @JsonKey()
  final double psv;

  /// RRIF/CRI minimum withdrawal (formerly called rrpe)
  @override
  @JsonKey()
  final double rrif;

  /// RRPE (Régime de retraite du personnel d'encadrement) pension
  @override
  @JsonKey()
  final double rrpe;

  /// Other income sources (dividends, rental income, survivor benefits, etc.)
  @override
  @JsonKey()
  final double other;

  @override
  String toString() {
    return 'AnnualIncome(employment: $employment, rrq: $rrq, psv: $psv, rrif: $rrif, rrpe: $rrpe, other: $other)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AnnualIncomeImpl &&
            (identical(other.employment, employment) ||
                other.employment == employment) &&
            (identical(other.rrq, rrq) || other.rrq == rrq) &&
            (identical(other.psv, psv) || other.psv == psv) &&
            (identical(other.rrif, rrif) || other.rrif == rrif) &&
            (identical(other.rrpe, rrpe) || other.rrpe == rrpe) &&
            (identical(other.other, this.other) || other.other == this.other));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, employment, rrq, psv, rrif, rrpe, other);

  /// Create a copy of AnnualIncome
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AnnualIncomeImplCopyWith<_$AnnualIncomeImpl> get copyWith =>
      __$$AnnualIncomeImplCopyWithImpl<_$AnnualIncomeImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AnnualIncomeImplToJson(this);
  }
}

abstract class _AnnualIncome extends AnnualIncome {
  const factory _AnnualIncome({
    final double employment,
    final double rrq,
    final double psv,
    final double rrif,
    final double rrpe,
    final double other,
  }) = _$AnnualIncomeImpl;
  const _AnnualIncome._() : super._();

  factory _AnnualIncome.fromJson(Map<String, dynamic> json) =
      _$AnnualIncomeImpl.fromJson;

  /// Employment income (salary/wages)
  @override
  double get employment;

  /// RRQ (Régime de rentes du Québec / Quebec Pension Plan) benefit
  @override
  double get rrq;

  /// PSV (Pension de la Sécurité de la vieillesse / Old Age Security) benefit
  @override
  double get psv;

  /// RRIF/CRI minimum withdrawal (formerly called rrpe)
  @override
  double get rrif;

  /// RRPE (Régime de retraite du personnel d'encadrement) pension
  @override
  double get rrpe;

  /// Other income sources (dividends, rental income, survivor benefits, etc.)
  @override
  double get other;

  /// Create a copy of AnnualIncome
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AnnualIncomeImplCopyWith<_$AnnualIncomeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
