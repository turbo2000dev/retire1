// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'yearly_projection.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

YearlyProjection _$YearlyProjectionFromJson(Map<String, dynamic> json) {
  return _YearlyProjection.fromJson(json);
}

/// @nodoc
mixin _$YearlyProjection {
  /// Calendar year
  int get year => throw _privateConstructorUsedError;

  /// Years from start of projection (0-indexed)
  int get yearsFromStart => throw _privateConstructorUsedError;

  /// Age of primary individual at start of year
  int? get primaryAge => throw _privateConstructorUsedError;

  /// Age of spouse at start of year (if applicable)
  int? get spouseAge => throw _privateConstructorUsedError;

  /// Income by individual (keyed by individual ID)
  Map<String, AnnualIncome> get incomeByIndividual =>
      throw _privateConstructorUsedError;

  /// Total income for the year (household)
  double get totalIncome => throw _privateConstructorUsedError;

  /// Total expenses for the year
  double get totalExpenses => throw _privateConstructorUsedError;

  /// Expenses by category (keyed by category name)
  /// Keys: 'housing', 'transport', 'dailyLiving', 'recreation', 'health', 'family'
  Map<String, double> get expensesByCategory =>
      throw _privateConstructorUsedError;

  /// Net cash flow (income - expenses)
  double get netCashFlow => throw _privateConstructorUsedError;

  /// Assets at start of year
  Map<String, double> get assetsStartOfYear =>
      throw _privateConstructorUsedError;

  /// Assets at end of year
  Map<String, double> get assetsEndOfYear => throw _privateConstructorUsedError;

  /// Total net worth at start of year
  double get netWorthStartOfYear => throw _privateConstructorUsedError;

  /// Total net worth at end of year
  double get netWorthEndOfYear => throw _privateConstructorUsedError;

  /// Events that occurred during this year
  List<String> get eventsOccurred => throw _privateConstructorUsedError;

  /// Serializes this YearlyProjection to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of YearlyProjection
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $YearlyProjectionCopyWith<YearlyProjection> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $YearlyProjectionCopyWith<$Res> {
  factory $YearlyProjectionCopyWith(
    YearlyProjection value,
    $Res Function(YearlyProjection) then,
  ) = _$YearlyProjectionCopyWithImpl<$Res, YearlyProjection>;
  @useResult
  $Res call({
    int year,
    int yearsFromStart,
    int? primaryAge,
    int? spouseAge,
    Map<String, AnnualIncome> incomeByIndividual,
    double totalIncome,
    double totalExpenses,
    Map<String, double> expensesByCategory,
    double netCashFlow,
    Map<String, double> assetsStartOfYear,
    Map<String, double> assetsEndOfYear,
    double netWorthStartOfYear,
    double netWorthEndOfYear,
    List<String> eventsOccurred,
  });
}

/// @nodoc
class _$YearlyProjectionCopyWithImpl<$Res, $Val extends YearlyProjection>
    implements $YearlyProjectionCopyWith<$Res> {
  _$YearlyProjectionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of YearlyProjection
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? year = null,
    Object? yearsFromStart = null,
    Object? primaryAge = freezed,
    Object? spouseAge = freezed,
    Object? incomeByIndividual = null,
    Object? totalIncome = null,
    Object? totalExpenses = null,
    Object? expensesByCategory = null,
    Object? netCashFlow = null,
    Object? assetsStartOfYear = null,
    Object? assetsEndOfYear = null,
    Object? netWorthStartOfYear = null,
    Object? netWorthEndOfYear = null,
    Object? eventsOccurred = null,
  }) {
    return _then(
      _value.copyWith(
            year: null == year
                ? _value.year
                : year // ignore: cast_nullable_to_non_nullable
                      as int,
            yearsFromStart: null == yearsFromStart
                ? _value.yearsFromStart
                : yearsFromStart // ignore: cast_nullable_to_non_nullable
                      as int,
            primaryAge: freezed == primaryAge
                ? _value.primaryAge
                : primaryAge // ignore: cast_nullable_to_non_nullable
                      as int?,
            spouseAge: freezed == spouseAge
                ? _value.spouseAge
                : spouseAge // ignore: cast_nullable_to_non_nullable
                      as int?,
            incomeByIndividual: null == incomeByIndividual
                ? _value.incomeByIndividual
                : incomeByIndividual // ignore: cast_nullable_to_non_nullable
                      as Map<String, AnnualIncome>,
            totalIncome: null == totalIncome
                ? _value.totalIncome
                : totalIncome // ignore: cast_nullable_to_non_nullable
                      as double,
            totalExpenses: null == totalExpenses
                ? _value.totalExpenses
                : totalExpenses // ignore: cast_nullable_to_non_nullable
                      as double,
            expensesByCategory: null == expensesByCategory
                ? _value.expensesByCategory
                : expensesByCategory // ignore: cast_nullable_to_non_nullable
                      as Map<String, double>,
            netCashFlow: null == netCashFlow
                ? _value.netCashFlow
                : netCashFlow // ignore: cast_nullable_to_non_nullable
                      as double,
            assetsStartOfYear: null == assetsStartOfYear
                ? _value.assetsStartOfYear
                : assetsStartOfYear // ignore: cast_nullable_to_non_nullable
                      as Map<String, double>,
            assetsEndOfYear: null == assetsEndOfYear
                ? _value.assetsEndOfYear
                : assetsEndOfYear // ignore: cast_nullable_to_non_nullable
                      as Map<String, double>,
            netWorthStartOfYear: null == netWorthStartOfYear
                ? _value.netWorthStartOfYear
                : netWorthStartOfYear // ignore: cast_nullable_to_non_nullable
                      as double,
            netWorthEndOfYear: null == netWorthEndOfYear
                ? _value.netWorthEndOfYear
                : netWorthEndOfYear // ignore: cast_nullable_to_non_nullable
                      as double,
            eventsOccurred: null == eventsOccurred
                ? _value.eventsOccurred
                : eventsOccurred // ignore: cast_nullable_to_non_nullable
                      as List<String>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$YearlyProjectionImplCopyWith<$Res>
    implements $YearlyProjectionCopyWith<$Res> {
  factory _$$YearlyProjectionImplCopyWith(
    _$YearlyProjectionImpl value,
    $Res Function(_$YearlyProjectionImpl) then,
  ) = __$$YearlyProjectionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int year,
    int yearsFromStart,
    int? primaryAge,
    int? spouseAge,
    Map<String, AnnualIncome> incomeByIndividual,
    double totalIncome,
    double totalExpenses,
    Map<String, double> expensesByCategory,
    double netCashFlow,
    Map<String, double> assetsStartOfYear,
    Map<String, double> assetsEndOfYear,
    double netWorthStartOfYear,
    double netWorthEndOfYear,
    List<String> eventsOccurred,
  });
}

/// @nodoc
class __$$YearlyProjectionImplCopyWithImpl<$Res>
    extends _$YearlyProjectionCopyWithImpl<$Res, _$YearlyProjectionImpl>
    implements _$$YearlyProjectionImplCopyWith<$Res> {
  __$$YearlyProjectionImplCopyWithImpl(
    _$YearlyProjectionImpl _value,
    $Res Function(_$YearlyProjectionImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of YearlyProjection
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? year = null,
    Object? yearsFromStart = null,
    Object? primaryAge = freezed,
    Object? spouseAge = freezed,
    Object? incomeByIndividual = null,
    Object? totalIncome = null,
    Object? totalExpenses = null,
    Object? expensesByCategory = null,
    Object? netCashFlow = null,
    Object? assetsStartOfYear = null,
    Object? assetsEndOfYear = null,
    Object? netWorthStartOfYear = null,
    Object? netWorthEndOfYear = null,
    Object? eventsOccurred = null,
  }) {
    return _then(
      _$YearlyProjectionImpl(
        year: null == year
            ? _value.year
            : year // ignore: cast_nullable_to_non_nullable
                  as int,
        yearsFromStart: null == yearsFromStart
            ? _value.yearsFromStart
            : yearsFromStart // ignore: cast_nullable_to_non_nullable
                  as int,
        primaryAge: freezed == primaryAge
            ? _value.primaryAge
            : primaryAge // ignore: cast_nullable_to_non_nullable
                  as int?,
        spouseAge: freezed == spouseAge
            ? _value.spouseAge
            : spouseAge // ignore: cast_nullable_to_non_nullable
                  as int?,
        incomeByIndividual: null == incomeByIndividual
            ? _value._incomeByIndividual
            : incomeByIndividual // ignore: cast_nullable_to_non_nullable
                  as Map<String, AnnualIncome>,
        totalIncome: null == totalIncome
            ? _value.totalIncome
            : totalIncome // ignore: cast_nullable_to_non_nullable
                  as double,
        totalExpenses: null == totalExpenses
            ? _value.totalExpenses
            : totalExpenses // ignore: cast_nullable_to_non_nullable
                  as double,
        expensesByCategory: null == expensesByCategory
            ? _value._expensesByCategory
            : expensesByCategory // ignore: cast_nullable_to_non_nullable
                  as Map<String, double>,
        netCashFlow: null == netCashFlow
            ? _value.netCashFlow
            : netCashFlow // ignore: cast_nullable_to_non_nullable
                  as double,
        assetsStartOfYear: null == assetsStartOfYear
            ? _value._assetsStartOfYear
            : assetsStartOfYear // ignore: cast_nullable_to_non_nullable
                  as Map<String, double>,
        assetsEndOfYear: null == assetsEndOfYear
            ? _value._assetsEndOfYear
            : assetsEndOfYear // ignore: cast_nullable_to_non_nullable
                  as Map<String, double>,
        netWorthStartOfYear: null == netWorthStartOfYear
            ? _value.netWorthStartOfYear
            : netWorthStartOfYear // ignore: cast_nullable_to_non_nullable
                  as double,
        netWorthEndOfYear: null == netWorthEndOfYear
            ? _value.netWorthEndOfYear
            : netWorthEndOfYear // ignore: cast_nullable_to_non_nullable
                  as double,
        eventsOccurred: null == eventsOccurred
            ? _value._eventsOccurred
            : eventsOccurred // ignore: cast_nullable_to_non_nullable
                  as List<String>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$YearlyProjectionImpl implements _YearlyProjection {
  const _$YearlyProjectionImpl({
    required this.year,
    required this.yearsFromStart,
    required this.primaryAge,
    required this.spouseAge,
    final Map<String, AnnualIncome> incomeByIndividual = const {},
    required this.totalIncome,
    required this.totalExpenses,
    final Map<String, double> expensesByCategory = const {},
    required this.netCashFlow,
    required final Map<String, double> assetsStartOfYear,
    required final Map<String, double> assetsEndOfYear,
    required this.netWorthStartOfYear,
    required this.netWorthEndOfYear,
    required final List<String> eventsOccurred,
  }) : _incomeByIndividual = incomeByIndividual,
       _expensesByCategory = expensesByCategory,
       _assetsStartOfYear = assetsStartOfYear,
       _assetsEndOfYear = assetsEndOfYear,
       _eventsOccurred = eventsOccurred;

  factory _$YearlyProjectionImpl.fromJson(Map<String, dynamic> json) =>
      _$$YearlyProjectionImplFromJson(json);

  /// Calendar year
  @override
  final int year;

  /// Years from start of projection (0-indexed)
  @override
  final int yearsFromStart;

  /// Age of primary individual at start of year
  @override
  final int? primaryAge;

  /// Age of spouse at start of year (if applicable)
  @override
  final int? spouseAge;

  /// Income by individual (keyed by individual ID)
  final Map<String, AnnualIncome> _incomeByIndividual;

  /// Income by individual (keyed by individual ID)
  @override
  @JsonKey()
  Map<String, AnnualIncome> get incomeByIndividual {
    if (_incomeByIndividual is EqualUnmodifiableMapView)
      return _incomeByIndividual;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_incomeByIndividual);
  }

  /// Total income for the year (household)
  @override
  final double totalIncome;

  /// Total expenses for the year
  @override
  final double totalExpenses;

  /// Expenses by category (keyed by category name)
  /// Keys: 'housing', 'transport', 'dailyLiving', 'recreation', 'health', 'family'
  final Map<String, double> _expensesByCategory;

  /// Expenses by category (keyed by category name)
  /// Keys: 'housing', 'transport', 'dailyLiving', 'recreation', 'health', 'family'
  @override
  @JsonKey()
  Map<String, double> get expensesByCategory {
    if (_expensesByCategory is EqualUnmodifiableMapView)
      return _expensesByCategory;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_expensesByCategory);
  }

  /// Net cash flow (income - expenses)
  @override
  final double netCashFlow;

  /// Assets at start of year
  final Map<String, double> _assetsStartOfYear;

  /// Assets at start of year
  @override
  Map<String, double> get assetsStartOfYear {
    if (_assetsStartOfYear is EqualUnmodifiableMapView)
      return _assetsStartOfYear;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_assetsStartOfYear);
  }

  /// Assets at end of year
  final Map<String, double> _assetsEndOfYear;

  /// Assets at end of year
  @override
  Map<String, double> get assetsEndOfYear {
    if (_assetsEndOfYear is EqualUnmodifiableMapView) return _assetsEndOfYear;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_assetsEndOfYear);
  }

  /// Total net worth at start of year
  @override
  final double netWorthStartOfYear;

  /// Total net worth at end of year
  @override
  final double netWorthEndOfYear;

  /// Events that occurred during this year
  final List<String> _eventsOccurred;

  /// Events that occurred during this year
  @override
  List<String> get eventsOccurred {
    if (_eventsOccurred is EqualUnmodifiableListView) return _eventsOccurred;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_eventsOccurred);
  }

  @override
  String toString() {
    return 'YearlyProjection(year: $year, yearsFromStart: $yearsFromStart, primaryAge: $primaryAge, spouseAge: $spouseAge, incomeByIndividual: $incomeByIndividual, totalIncome: $totalIncome, totalExpenses: $totalExpenses, expensesByCategory: $expensesByCategory, netCashFlow: $netCashFlow, assetsStartOfYear: $assetsStartOfYear, assetsEndOfYear: $assetsEndOfYear, netWorthStartOfYear: $netWorthStartOfYear, netWorthEndOfYear: $netWorthEndOfYear, eventsOccurred: $eventsOccurred)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$YearlyProjectionImpl &&
            (identical(other.year, year) || other.year == year) &&
            (identical(other.yearsFromStart, yearsFromStart) ||
                other.yearsFromStart == yearsFromStart) &&
            (identical(other.primaryAge, primaryAge) ||
                other.primaryAge == primaryAge) &&
            (identical(other.spouseAge, spouseAge) ||
                other.spouseAge == spouseAge) &&
            const DeepCollectionEquality().equals(
              other._incomeByIndividual,
              _incomeByIndividual,
            ) &&
            (identical(other.totalIncome, totalIncome) ||
                other.totalIncome == totalIncome) &&
            (identical(other.totalExpenses, totalExpenses) ||
                other.totalExpenses == totalExpenses) &&
            const DeepCollectionEquality().equals(
              other._expensesByCategory,
              _expensesByCategory,
            ) &&
            (identical(other.netCashFlow, netCashFlow) ||
                other.netCashFlow == netCashFlow) &&
            const DeepCollectionEquality().equals(
              other._assetsStartOfYear,
              _assetsStartOfYear,
            ) &&
            const DeepCollectionEquality().equals(
              other._assetsEndOfYear,
              _assetsEndOfYear,
            ) &&
            (identical(other.netWorthStartOfYear, netWorthStartOfYear) ||
                other.netWorthStartOfYear == netWorthStartOfYear) &&
            (identical(other.netWorthEndOfYear, netWorthEndOfYear) ||
                other.netWorthEndOfYear == netWorthEndOfYear) &&
            const DeepCollectionEquality().equals(
              other._eventsOccurred,
              _eventsOccurred,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    year,
    yearsFromStart,
    primaryAge,
    spouseAge,
    const DeepCollectionEquality().hash(_incomeByIndividual),
    totalIncome,
    totalExpenses,
    const DeepCollectionEquality().hash(_expensesByCategory),
    netCashFlow,
    const DeepCollectionEquality().hash(_assetsStartOfYear),
    const DeepCollectionEquality().hash(_assetsEndOfYear),
    netWorthStartOfYear,
    netWorthEndOfYear,
    const DeepCollectionEquality().hash(_eventsOccurred),
  );

  /// Create a copy of YearlyProjection
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$YearlyProjectionImplCopyWith<_$YearlyProjectionImpl> get copyWith =>
      __$$YearlyProjectionImplCopyWithImpl<_$YearlyProjectionImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$YearlyProjectionImplToJson(this);
  }
}

abstract class _YearlyProjection implements YearlyProjection {
  const factory _YearlyProjection({
    required final int year,
    required final int yearsFromStart,
    required final int? primaryAge,
    required final int? spouseAge,
    final Map<String, AnnualIncome> incomeByIndividual,
    required final double totalIncome,
    required final double totalExpenses,
    final Map<String, double> expensesByCategory,
    required final double netCashFlow,
    required final Map<String, double> assetsStartOfYear,
    required final Map<String, double> assetsEndOfYear,
    required final double netWorthStartOfYear,
    required final double netWorthEndOfYear,
    required final List<String> eventsOccurred,
  }) = _$YearlyProjectionImpl;

  factory _YearlyProjection.fromJson(Map<String, dynamic> json) =
      _$YearlyProjectionImpl.fromJson;

  /// Calendar year
  @override
  int get year;

  /// Years from start of projection (0-indexed)
  @override
  int get yearsFromStart;

  /// Age of primary individual at start of year
  @override
  int? get primaryAge;

  /// Age of spouse at start of year (if applicable)
  @override
  int? get spouseAge;

  /// Income by individual (keyed by individual ID)
  @override
  Map<String, AnnualIncome> get incomeByIndividual;

  /// Total income for the year (household)
  @override
  double get totalIncome;

  /// Total expenses for the year
  @override
  double get totalExpenses;

  /// Expenses by category (keyed by category name)
  /// Keys: 'housing', 'transport', 'dailyLiving', 'recreation', 'health', 'family'
  @override
  Map<String, double> get expensesByCategory;

  /// Net cash flow (income - expenses)
  @override
  double get netCashFlow;

  /// Assets at start of year
  @override
  Map<String, double> get assetsStartOfYear;

  /// Assets at end of year
  @override
  Map<String, double> get assetsEndOfYear;

  /// Total net worth at start of year
  @override
  double get netWorthStartOfYear;

  /// Total net worth at end of year
  @override
  double get netWorthEndOfYear;

  /// Events that occurred during this year
  @override
  List<String> get eventsOccurred;

  /// Create a copy of YearlyProjection
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$YearlyProjectionImplCopyWith<_$YearlyProjectionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
