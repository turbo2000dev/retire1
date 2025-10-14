// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tax_calculation.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

TaxCalculation _$TaxCalculationFromJson(Map<String, dynamic> json) {
  return _TaxCalculation.fromJson(json);
}

/// @nodoc
mixin _$TaxCalculation {
  /// Total income before any deductions
  double get grossIncome => throw _privateConstructorUsedError;

  /// Income subject to tax (after deductions like RRSP)
  double get taxableIncome => throw _privateConstructorUsedError;

  /// Federal tax owing (after credits applied)
  double get federalTax => throw _privateConstructorUsedError;

  /// Quebec provincial tax owing (after credits applied)
  double get quebecTax => throw _privateConstructorUsedError;

  /// Total tax owing (federal + Quebec)
  double get totalTax => throw _privateConstructorUsedError;

  /// Effective tax rate as a percentage (totalTax / grossIncome * 100)
  double get effectiveRate => throw _privateConstructorUsedError;

  /// Serializes this TaxCalculation to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TaxCalculation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TaxCalculationCopyWith<TaxCalculation> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TaxCalculationCopyWith<$Res> {
  factory $TaxCalculationCopyWith(
    TaxCalculation value,
    $Res Function(TaxCalculation) then,
  ) = _$TaxCalculationCopyWithImpl<$Res, TaxCalculation>;
  @useResult
  $Res call({
    double grossIncome,
    double taxableIncome,
    double federalTax,
    double quebecTax,
    double totalTax,
    double effectiveRate,
  });
}

/// @nodoc
class _$TaxCalculationCopyWithImpl<$Res, $Val extends TaxCalculation>
    implements $TaxCalculationCopyWith<$Res> {
  _$TaxCalculationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TaxCalculation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? grossIncome = null,
    Object? taxableIncome = null,
    Object? federalTax = null,
    Object? quebecTax = null,
    Object? totalTax = null,
    Object? effectiveRate = null,
  }) {
    return _then(
      _value.copyWith(
            grossIncome: null == grossIncome
                ? _value.grossIncome
                : grossIncome // ignore: cast_nullable_to_non_nullable
                      as double,
            taxableIncome: null == taxableIncome
                ? _value.taxableIncome
                : taxableIncome // ignore: cast_nullable_to_non_nullable
                      as double,
            federalTax: null == federalTax
                ? _value.federalTax
                : federalTax // ignore: cast_nullable_to_non_nullable
                      as double,
            quebecTax: null == quebecTax
                ? _value.quebecTax
                : quebecTax // ignore: cast_nullable_to_non_nullable
                      as double,
            totalTax: null == totalTax
                ? _value.totalTax
                : totalTax // ignore: cast_nullable_to_non_nullable
                      as double,
            effectiveRate: null == effectiveRate
                ? _value.effectiveRate
                : effectiveRate // ignore: cast_nullable_to_non_nullable
                      as double,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TaxCalculationImplCopyWith<$Res>
    implements $TaxCalculationCopyWith<$Res> {
  factory _$$TaxCalculationImplCopyWith(
    _$TaxCalculationImpl value,
    $Res Function(_$TaxCalculationImpl) then,
  ) = __$$TaxCalculationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    double grossIncome,
    double taxableIncome,
    double federalTax,
    double quebecTax,
    double totalTax,
    double effectiveRate,
  });
}

/// @nodoc
class __$$TaxCalculationImplCopyWithImpl<$Res>
    extends _$TaxCalculationCopyWithImpl<$Res, _$TaxCalculationImpl>
    implements _$$TaxCalculationImplCopyWith<$Res> {
  __$$TaxCalculationImplCopyWithImpl(
    _$TaxCalculationImpl _value,
    $Res Function(_$TaxCalculationImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TaxCalculation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? grossIncome = null,
    Object? taxableIncome = null,
    Object? federalTax = null,
    Object? quebecTax = null,
    Object? totalTax = null,
    Object? effectiveRate = null,
  }) {
    return _then(
      _$TaxCalculationImpl(
        grossIncome: null == grossIncome
            ? _value.grossIncome
            : grossIncome // ignore: cast_nullable_to_non_nullable
                  as double,
        taxableIncome: null == taxableIncome
            ? _value.taxableIncome
            : taxableIncome // ignore: cast_nullable_to_non_nullable
                  as double,
        federalTax: null == federalTax
            ? _value.federalTax
            : federalTax // ignore: cast_nullable_to_non_nullable
                  as double,
        quebecTax: null == quebecTax
            ? _value.quebecTax
            : quebecTax // ignore: cast_nullable_to_non_nullable
                  as double,
        totalTax: null == totalTax
            ? _value.totalTax
            : totalTax // ignore: cast_nullable_to_non_nullable
                  as double,
        effectiveRate: null == effectiveRate
            ? _value.effectiveRate
            : effectiveRate // ignore: cast_nullable_to_non_nullable
                  as double,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TaxCalculationImpl implements _TaxCalculation {
  const _$TaxCalculationImpl({
    required this.grossIncome,
    required this.taxableIncome,
    required this.federalTax,
    required this.quebecTax,
    required this.totalTax,
    required this.effectiveRate,
  });

  factory _$TaxCalculationImpl.fromJson(Map<String, dynamic> json) =>
      _$$TaxCalculationImplFromJson(json);

  /// Total income before any deductions
  @override
  final double grossIncome;

  /// Income subject to tax (after deductions like RRSP)
  @override
  final double taxableIncome;

  /// Federal tax owing (after credits applied)
  @override
  final double federalTax;

  /// Quebec provincial tax owing (after credits applied)
  @override
  final double quebecTax;

  /// Total tax owing (federal + Quebec)
  @override
  final double totalTax;

  /// Effective tax rate as a percentage (totalTax / grossIncome * 100)
  @override
  final double effectiveRate;

  @override
  String toString() {
    return 'TaxCalculation(grossIncome: $grossIncome, taxableIncome: $taxableIncome, federalTax: $federalTax, quebecTax: $quebecTax, totalTax: $totalTax, effectiveRate: $effectiveRate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TaxCalculationImpl &&
            (identical(other.grossIncome, grossIncome) ||
                other.grossIncome == grossIncome) &&
            (identical(other.taxableIncome, taxableIncome) ||
                other.taxableIncome == taxableIncome) &&
            (identical(other.federalTax, federalTax) ||
                other.federalTax == federalTax) &&
            (identical(other.quebecTax, quebecTax) ||
                other.quebecTax == quebecTax) &&
            (identical(other.totalTax, totalTax) ||
                other.totalTax == totalTax) &&
            (identical(other.effectiveRate, effectiveRate) ||
                other.effectiveRate == effectiveRate));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    grossIncome,
    taxableIncome,
    federalTax,
    quebecTax,
    totalTax,
    effectiveRate,
  );

  /// Create a copy of TaxCalculation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TaxCalculationImplCopyWith<_$TaxCalculationImpl> get copyWith =>
      __$$TaxCalculationImplCopyWithImpl<_$TaxCalculationImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$TaxCalculationImplToJson(this);
  }
}

abstract class _TaxCalculation implements TaxCalculation {
  const factory _TaxCalculation({
    required final double grossIncome,
    required final double taxableIncome,
    required final double federalTax,
    required final double quebecTax,
    required final double totalTax,
    required final double effectiveRate,
  }) = _$TaxCalculationImpl;

  factory _TaxCalculation.fromJson(Map<String, dynamic> json) =
      _$TaxCalculationImpl.fromJson;

  /// Total income before any deductions
  @override
  double get grossIncome;

  /// Income subject to tax (after deductions like RRSP)
  @override
  double get taxableIncome;

  /// Federal tax owing (after credits applied)
  @override
  double get federalTax;

  /// Quebec provincial tax owing (after credits applied)
  @override
  double get quebecTax;

  /// Total tax owing (federal + Quebec)
  @override
  double get totalTax;

  /// Effective tax rate as a percentage (totalTax / grossIncome * 100)
  @override
  double get effectiveRate;

  /// Create a copy of TaxCalculation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TaxCalculationImplCopyWith<_$TaxCalculationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
