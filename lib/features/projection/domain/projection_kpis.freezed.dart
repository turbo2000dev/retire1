// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'projection_kpis.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ProjectionKpis _$ProjectionKpisFromJson(Map<String, dynamic> json) {
  return _ProjectionKpis.fromJson(json);
}

/// @nodoc
mixin _$ProjectionKpis {
  /// Year when money runs out (null if never runs out)
  int? get yearMoneyRunsOut => throw _privateConstructorUsedError;

  /// Lowest net worth throughout the projection
  double get lowestNetWorth => throw _privateConstructorUsedError;

  /// Year when lowest net worth occurs
  int get yearOfLowestNetWorth => throw _privateConstructorUsedError;

  /// Final net worth at end of projection
  double get finalNetWorth => throw _privateConstructorUsedError;

  /// Total taxes paid across all years
  double get totalTaxesPaid => throw _privateConstructorUsedError;

  /// Total withdrawals across all years
  double get totalWithdrawals => throw _privateConstructorUsedError;

  /// Average effective tax rate (total tax / total income)
  double get averageTaxRate => throw _privateConstructorUsedError;

  /// Serializes this ProjectionKpis to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ProjectionKpis
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProjectionKpisCopyWith<ProjectionKpis> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProjectionKpisCopyWith<$Res> {
  factory $ProjectionKpisCopyWith(
    ProjectionKpis value,
    $Res Function(ProjectionKpis) then,
  ) = _$ProjectionKpisCopyWithImpl<$Res, ProjectionKpis>;
  @useResult
  $Res call({
    int? yearMoneyRunsOut,
    double lowestNetWorth,
    int yearOfLowestNetWorth,
    double finalNetWorth,
    double totalTaxesPaid,
    double totalWithdrawals,
    double averageTaxRate,
  });
}

/// @nodoc
class _$ProjectionKpisCopyWithImpl<$Res, $Val extends ProjectionKpis>
    implements $ProjectionKpisCopyWith<$Res> {
  _$ProjectionKpisCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProjectionKpis
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? yearMoneyRunsOut = freezed,
    Object? lowestNetWorth = null,
    Object? yearOfLowestNetWorth = null,
    Object? finalNetWorth = null,
    Object? totalTaxesPaid = null,
    Object? totalWithdrawals = null,
    Object? averageTaxRate = null,
  }) {
    return _then(
      _value.copyWith(
            yearMoneyRunsOut: freezed == yearMoneyRunsOut
                ? _value.yearMoneyRunsOut
                : yearMoneyRunsOut // ignore: cast_nullable_to_non_nullable
                      as int?,
            lowestNetWorth: null == lowestNetWorth
                ? _value.lowestNetWorth
                : lowestNetWorth // ignore: cast_nullable_to_non_nullable
                      as double,
            yearOfLowestNetWorth: null == yearOfLowestNetWorth
                ? _value.yearOfLowestNetWorth
                : yearOfLowestNetWorth // ignore: cast_nullable_to_non_nullable
                      as int,
            finalNetWorth: null == finalNetWorth
                ? _value.finalNetWorth
                : finalNetWorth // ignore: cast_nullable_to_non_nullable
                      as double,
            totalTaxesPaid: null == totalTaxesPaid
                ? _value.totalTaxesPaid
                : totalTaxesPaid // ignore: cast_nullable_to_non_nullable
                      as double,
            totalWithdrawals: null == totalWithdrawals
                ? _value.totalWithdrawals
                : totalWithdrawals // ignore: cast_nullable_to_non_nullable
                      as double,
            averageTaxRate: null == averageTaxRate
                ? _value.averageTaxRate
                : averageTaxRate // ignore: cast_nullable_to_non_nullable
                      as double,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ProjectionKpisImplCopyWith<$Res>
    implements $ProjectionKpisCopyWith<$Res> {
  factory _$$ProjectionKpisImplCopyWith(
    _$ProjectionKpisImpl value,
    $Res Function(_$ProjectionKpisImpl) then,
  ) = __$$ProjectionKpisImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int? yearMoneyRunsOut,
    double lowestNetWorth,
    int yearOfLowestNetWorth,
    double finalNetWorth,
    double totalTaxesPaid,
    double totalWithdrawals,
    double averageTaxRate,
  });
}

/// @nodoc
class __$$ProjectionKpisImplCopyWithImpl<$Res>
    extends _$ProjectionKpisCopyWithImpl<$Res, _$ProjectionKpisImpl>
    implements _$$ProjectionKpisImplCopyWith<$Res> {
  __$$ProjectionKpisImplCopyWithImpl(
    _$ProjectionKpisImpl _value,
    $Res Function(_$ProjectionKpisImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ProjectionKpis
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? yearMoneyRunsOut = freezed,
    Object? lowestNetWorth = null,
    Object? yearOfLowestNetWorth = null,
    Object? finalNetWorth = null,
    Object? totalTaxesPaid = null,
    Object? totalWithdrawals = null,
    Object? averageTaxRate = null,
  }) {
    return _then(
      _$ProjectionKpisImpl(
        yearMoneyRunsOut: freezed == yearMoneyRunsOut
            ? _value.yearMoneyRunsOut
            : yearMoneyRunsOut // ignore: cast_nullable_to_non_nullable
                  as int?,
        lowestNetWorth: null == lowestNetWorth
            ? _value.lowestNetWorth
            : lowestNetWorth // ignore: cast_nullable_to_non_nullable
                  as double,
        yearOfLowestNetWorth: null == yearOfLowestNetWorth
            ? _value.yearOfLowestNetWorth
            : yearOfLowestNetWorth // ignore: cast_nullable_to_non_nullable
                  as int,
        finalNetWorth: null == finalNetWorth
            ? _value.finalNetWorth
            : finalNetWorth // ignore: cast_nullable_to_non_nullable
                  as double,
        totalTaxesPaid: null == totalTaxesPaid
            ? _value.totalTaxesPaid
            : totalTaxesPaid // ignore: cast_nullable_to_non_nullable
                  as double,
        totalWithdrawals: null == totalWithdrawals
            ? _value.totalWithdrawals
            : totalWithdrawals // ignore: cast_nullable_to_non_nullable
                  as double,
        averageTaxRate: null == averageTaxRate
            ? _value.averageTaxRate
            : averageTaxRate // ignore: cast_nullable_to_non_nullable
                  as double,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ProjectionKpisImpl implements _ProjectionKpis {
  const _$ProjectionKpisImpl({
    this.yearMoneyRunsOut,
    required this.lowestNetWorth,
    required this.yearOfLowestNetWorth,
    required this.finalNetWorth,
    required this.totalTaxesPaid,
    required this.totalWithdrawals,
    required this.averageTaxRate,
  });

  factory _$ProjectionKpisImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProjectionKpisImplFromJson(json);

  /// Year when money runs out (null if never runs out)
  @override
  final int? yearMoneyRunsOut;

  /// Lowest net worth throughout the projection
  @override
  final double lowestNetWorth;

  /// Year when lowest net worth occurs
  @override
  final int yearOfLowestNetWorth;

  /// Final net worth at end of projection
  @override
  final double finalNetWorth;

  /// Total taxes paid across all years
  @override
  final double totalTaxesPaid;

  /// Total withdrawals across all years
  @override
  final double totalWithdrawals;

  /// Average effective tax rate (total tax / total income)
  @override
  final double averageTaxRate;

  @override
  String toString() {
    return 'ProjectionKpis(yearMoneyRunsOut: $yearMoneyRunsOut, lowestNetWorth: $lowestNetWorth, yearOfLowestNetWorth: $yearOfLowestNetWorth, finalNetWorth: $finalNetWorth, totalTaxesPaid: $totalTaxesPaid, totalWithdrawals: $totalWithdrawals, averageTaxRate: $averageTaxRate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProjectionKpisImpl &&
            (identical(other.yearMoneyRunsOut, yearMoneyRunsOut) ||
                other.yearMoneyRunsOut == yearMoneyRunsOut) &&
            (identical(other.lowestNetWorth, lowestNetWorth) ||
                other.lowestNetWorth == lowestNetWorth) &&
            (identical(other.yearOfLowestNetWorth, yearOfLowestNetWorth) ||
                other.yearOfLowestNetWorth == yearOfLowestNetWorth) &&
            (identical(other.finalNetWorth, finalNetWorth) ||
                other.finalNetWorth == finalNetWorth) &&
            (identical(other.totalTaxesPaid, totalTaxesPaid) ||
                other.totalTaxesPaid == totalTaxesPaid) &&
            (identical(other.totalWithdrawals, totalWithdrawals) ||
                other.totalWithdrawals == totalWithdrawals) &&
            (identical(other.averageTaxRate, averageTaxRate) ||
                other.averageTaxRate == averageTaxRate));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    yearMoneyRunsOut,
    lowestNetWorth,
    yearOfLowestNetWorth,
    finalNetWorth,
    totalTaxesPaid,
    totalWithdrawals,
    averageTaxRate,
  );

  /// Create a copy of ProjectionKpis
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProjectionKpisImplCopyWith<_$ProjectionKpisImpl> get copyWith =>
      __$$ProjectionKpisImplCopyWithImpl<_$ProjectionKpisImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ProjectionKpisImplToJson(this);
  }
}

abstract class _ProjectionKpis implements ProjectionKpis {
  const factory _ProjectionKpis({
    final int? yearMoneyRunsOut,
    required final double lowestNetWorth,
    required final int yearOfLowestNetWorth,
    required final double finalNetWorth,
    required final double totalTaxesPaid,
    required final double totalWithdrawals,
    required final double averageTaxRate,
  }) = _$ProjectionKpisImpl;

  factory _ProjectionKpis.fromJson(Map<String, dynamic> json) =
      _$ProjectionKpisImpl.fromJson;

  /// Year when money runs out (null if never runs out)
  @override
  int? get yearMoneyRunsOut;

  /// Lowest net worth throughout the projection
  @override
  double get lowestNetWorth;

  /// Year when lowest net worth occurs
  @override
  int get yearOfLowestNetWorth;

  /// Final net worth at end of projection
  @override
  double get finalNetWorth;

  /// Total taxes paid across all years
  @override
  double get totalTaxesPaid;

  /// Total withdrawals across all years
  @override
  double get totalWithdrawals;

  /// Average effective tax rate (total tax / total income)
  @override
  double get averageTaxRate;

  /// Create a copy of ProjectionKpis
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProjectionKpisImplCopyWith<_$ProjectionKpisImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
