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

  /// Total taxable income for the year (household)
  double get taxableIncome => throw _privateConstructorUsedError;

  /// Federal tax owing for the year (household)
  double get federalTax => throw _privateConstructorUsedError;

  /// Quebec provincial tax owing for the year (household)
  double get quebecTax => throw _privateConstructorUsedError;

  /// Total tax owing for the year (household, federal + Quebec)
  double get totalTax => throw _privateConstructorUsedError;

  /// After-tax income (total income - total tax)
  double get afterTaxIncome => throw _privateConstructorUsedError;

  /// Total expenses for the year
  double get totalExpenses => throw _privateConstructorUsedError;

  /// Expenses by category (keyed by category name)
  /// Keys: 'housing', 'transport', 'dailyLiving', 'recreation', 'health', 'family'
  Map<String, double> get expensesByCategory =>
      throw _privateConstructorUsedError;

  /// Withdrawals by account (keyed by asset ID)
  Map<String, double> get withdrawalsByAccount =>
      throw _privateConstructorUsedError;

  /// Contributions by account (keyed by asset ID)
  Map<String, double> get contributionsByAccount =>
      throw _privateConstructorUsedError;

  /// Total withdrawals for the year
  double get totalWithdrawals => throw _privateConstructorUsedError;

  /// Total contributions for the year
  double get totalContributions => throw _privateConstructorUsedError;

  /// CELI contribution room remaining at end of year
  double get celiContributionRoom => throw _privateConstructorUsedError;

  /// Net cash flow (income - expenses - taxes)
  double get netCashFlow => throw _privateConstructorUsedError;

  /// Assets at start of year
  Map<String, double> get assetsStartOfYear =>
      throw _privateConstructorUsedError;

  /// Assets at end of year
  Map<String, double> get assetsEndOfYear => throw _privateConstructorUsedError;

  /// Asset returns for the year (keyed by asset ID)
  Map<String, double> get assetReturns => throw _privateConstructorUsedError;

  /// Total net worth at start of year
  double get netWorthStartOfYear => throw _privateConstructorUsedError;

  /// Total net worth at end of year
  double get netWorthEndOfYear => throw _privateConstructorUsedError;

  /// Events that occurred during this year
  List<String> get eventsOccurred => throw _privateConstructorUsedError;

  /// Whether there was a shortfall this year (insufficient funds to cover expenses)
  bool get hasShortfall => throw _privateConstructorUsedError;

  /// Amount of shortfall if hasShortfall is true
  double get shortfallAmount => throw _privateConstructorUsedError;

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
    double taxableIncome,
    double federalTax,
    double quebecTax,
    double totalTax,
    double afterTaxIncome,
    double totalExpenses,
    Map<String, double> expensesByCategory,
    Map<String, double> withdrawalsByAccount,
    Map<String, double> contributionsByAccount,
    double totalWithdrawals,
    double totalContributions,
    double celiContributionRoom,
    double netCashFlow,
    Map<String, double> assetsStartOfYear,
    Map<String, double> assetsEndOfYear,
    Map<String, double> assetReturns,
    double netWorthStartOfYear,
    double netWorthEndOfYear,
    List<String> eventsOccurred,
    bool hasShortfall,
    double shortfallAmount,
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
    Object? taxableIncome = null,
    Object? federalTax = null,
    Object? quebecTax = null,
    Object? totalTax = null,
    Object? afterTaxIncome = null,
    Object? totalExpenses = null,
    Object? expensesByCategory = null,
    Object? withdrawalsByAccount = null,
    Object? contributionsByAccount = null,
    Object? totalWithdrawals = null,
    Object? totalContributions = null,
    Object? celiContributionRoom = null,
    Object? netCashFlow = null,
    Object? assetsStartOfYear = null,
    Object? assetsEndOfYear = null,
    Object? assetReturns = null,
    Object? netWorthStartOfYear = null,
    Object? netWorthEndOfYear = null,
    Object? eventsOccurred = null,
    Object? hasShortfall = null,
    Object? shortfallAmount = null,
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
            afterTaxIncome: null == afterTaxIncome
                ? _value.afterTaxIncome
                : afterTaxIncome // ignore: cast_nullable_to_non_nullable
                      as double,
            totalExpenses: null == totalExpenses
                ? _value.totalExpenses
                : totalExpenses // ignore: cast_nullable_to_non_nullable
                      as double,
            expensesByCategory: null == expensesByCategory
                ? _value.expensesByCategory
                : expensesByCategory // ignore: cast_nullable_to_non_nullable
                      as Map<String, double>,
            withdrawalsByAccount: null == withdrawalsByAccount
                ? _value.withdrawalsByAccount
                : withdrawalsByAccount // ignore: cast_nullable_to_non_nullable
                      as Map<String, double>,
            contributionsByAccount: null == contributionsByAccount
                ? _value.contributionsByAccount
                : contributionsByAccount // ignore: cast_nullable_to_non_nullable
                      as Map<String, double>,
            totalWithdrawals: null == totalWithdrawals
                ? _value.totalWithdrawals
                : totalWithdrawals // ignore: cast_nullable_to_non_nullable
                      as double,
            totalContributions: null == totalContributions
                ? _value.totalContributions
                : totalContributions // ignore: cast_nullable_to_non_nullable
                      as double,
            celiContributionRoom: null == celiContributionRoom
                ? _value.celiContributionRoom
                : celiContributionRoom // ignore: cast_nullable_to_non_nullable
                      as double,
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
            assetReturns: null == assetReturns
                ? _value.assetReturns
                : assetReturns // ignore: cast_nullable_to_non_nullable
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
            hasShortfall: null == hasShortfall
                ? _value.hasShortfall
                : hasShortfall // ignore: cast_nullable_to_non_nullable
                      as bool,
            shortfallAmount: null == shortfallAmount
                ? _value.shortfallAmount
                : shortfallAmount // ignore: cast_nullable_to_non_nullable
                      as double,
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
    double taxableIncome,
    double federalTax,
    double quebecTax,
    double totalTax,
    double afterTaxIncome,
    double totalExpenses,
    Map<String, double> expensesByCategory,
    Map<String, double> withdrawalsByAccount,
    Map<String, double> contributionsByAccount,
    double totalWithdrawals,
    double totalContributions,
    double celiContributionRoom,
    double netCashFlow,
    Map<String, double> assetsStartOfYear,
    Map<String, double> assetsEndOfYear,
    Map<String, double> assetReturns,
    double netWorthStartOfYear,
    double netWorthEndOfYear,
    List<String> eventsOccurred,
    bool hasShortfall,
    double shortfallAmount,
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
    Object? taxableIncome = null,
    Object? federalTax = null,
    Object? quebecTax = null,
    Object? totalTax = null,
    Object? afterTaxIncome = null,
    Object? totalExpenses = null,
    Object? expensesByCategory = null,
    Object? withdrawalsByAccount = null,
    Object? contributionsByAccount = null,
    Object? totalWithdrawals = null,
    Object? totalContributions = null,
    Object? celiContributionRoom = null,
    Object? netCashFlow = null,
    Object? assetsStartOfYear = null,
    Object? assetsEndOfYear = null,
    Object? assetReturns = null,
    Object? netWorthStartOfYear = null,
    Object? netWorthEndOfYear = null,
    Object? eventsOccurred = null,
    Object? hasShortfall = null,
    Object? shortfallAmount = null,
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
        afterTaxIncome: null == afterTaxIncome
            ? _value.afterTaxIncome
            : afterTaxIncome // ignore: cast_nullable_to_non_nullable
                  as double,
        totalExpenses: null == totalExpenses
            ? _value.totalExpenses
            : totalExpenses // ignore: cast_nullable_to_non_nullable
                  as double,
        expensesByCategory: null == expensesByCategory
            ? _value._expensesByCategory
            : expensesByCategory // ignore: cast_nullable_to_non_nullable
                  as Map<String, double>,
        withdrawalsByAccount: null == withdrawalsByAccount
            ? _value._withdrawalsByAccount
            : withdrawalsByAccount // ignore: cast_nullable_to_non_nullable
                  as Map<String, double>,
        contributionsByAccount: null == contributionsByAccount
            ? _value._contributionsByAccount
            : contributionsByAccount // ignore: cast_nullable_to_non_nullable
                  as Map<String, double>,
        totalWithdrawals: null == totalWithdrawals
            ? _value.totalWithdrawals
            : totalWithdrawals // ignore: cast_nullable_to_non_nullable
                  as double,
        totalContributions: null == totalContributions
            ? _value.totalContributions
            : totalContributions // ignore: cast_nullable_to_non_nullable
                  as double,
        celiContributionRoom: null == celiContributionRoom
            ? _value.celiContributionRoom
            : celiContributionRoom // ignore: cast_nullable_to_non_nullable
                  as double,
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
        assetReturns: null == assetReturns
            ? _value._assetReturns
            : assetReturns // ignore: cast_nullable_to_non_nullable
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
        hasShortfall: null == hasShortfall
            ? _value.hasShortfall
            : hasShortfall // ignore: cast_nullable_to_non_nullable
                  as bool,
        shortfallAmount: null == shortfallAmount
            ? _value.shortfallAmount
            : shortfallAmount // ignore: cast_nullable_to_non_nullable
                  as double,
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
    this.taxableIncome = 0.0,
    this.federalTax = 0.0,
    this.quebecTax = 0.0,
    this.totalTax = 0.0,
    this.afterTaxIncome = 0.0,
    required this.totalExpenses,
    final Map<String, double> expensesByCategory = const {},
    final Map<String, double> withdrawalsByAccount = const {},
    final Map<String, double> contributionsByAccount = const {},
    this.totalWithdrawals = 0.0,
    this.totalContributions = 0.0,
    this.celiContributionRoom = 0.0,
    required this.netCashFlow,
    required final Map<String, double> assetsStartOfYear,
    required final Map<String, double> assetsEndOfYear,
    final Map<String, double> assetReturns = const {},
    required this.netWorthStartOfYear,
    required this.netWorthEndOfYear,
    required final List<String> eventsOccurred,
    this.hasShortfall = false,
    this.shortfallAmount = 0.0,
  }) : _incomeByIndividual = incomeByIndividual,
       _expensesByCategory = expensesByCategory,
       _withdrawalsByAccount = withdrawalsByAccount,
       _contributionsByAccount = contributionsByAccount,
       _assetsStartOfYear = assetsStartOfYear,
       _assetsEndOfYear = assetsEndOfYear,
       _assetReturns = assetReturns,
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

  /// Total taxable income for the year (household)
  @override
  @JsonKey()
  final double taxableIncome;

  /// Federal tax owing for the year (household)
  @override
  @JsonKey()
  final double federalTax;

  /// Quebec provincial tax owing for the year (household)
  @override
  @JsonKey()
  final double quebecTax;

  /// Total tax owing for the year (household, federal + Quebec)
  @override
  @JsonKey()
  final double totalTax;

  /// After-tax income (total income - total tax)
  @override
  @JsonKey()
  final double afterTaxIncome;

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

  /// Withdrawals by account (keyed by asset ID)
  final Map<String, double> _withdrawalsByAccount;

  /// Withdrawals by account (keyed by asset ID)
  @override
  @JsonKey()
  Map<String, double> get withdrawalsByAccount {
    if (_withdrawalsByAccount is EqualUnmodifiableMapView)
      return _withdrawalsByAccount;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_withdrawalsByAccount);
  }

  /// Contributions by account (keyed by asset ID)
  final Map<String, double> _contributionsByAccount;

  /// Contributions by account (keyed by asset ID)
  @override
  @JsonKey()
  Map<String, double> get contributionsByAccount {
    if (_contributionsByAccount is EqualUnmodifiableMapView)
      return _contributionsByAccount;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_contributionsByAccount);
  }

  /// Total withdrawals for the year
  @override
  @JsonKey()
  final double totalWithdrawals;

  /// Total contributions for the year
  @override
  @JsonKey()
  final double totalContributions;

  /// CELI contribution room remaining at end of year
  @override
  @JsonKey()
  final double celiContributionRoom;

  /// Net cash flow (income - expenses - taxes)
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

  /// Asset returns for the year (keyed by asset ID)
  final Map<String, double> _assetReturns;

  /// Asset returns for the year (keyed by asset ID)
  @override
  @JsonKey()
  Map<String, double> get assetReturns {
    if (_assetReturns is EqualUnmodifiableMapView) return _assetReturns;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_assetReturns);
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

  /// Whether there was a shortfall this year (insufficient funds to cover expenses)
  @override
  @JsonKey()
  final bool hasShortfall;

  /// Amount of shortfall if hasShortfall is true
  @override
  @JsonKey()
  final double shortfallAmount;

  @override
  String toString() {
    return 'YearlyProjection(year: $year, yearsFromStart: $yearsFromStart, primaryAge: $primaryAge, spouseAge: $spouseAge, incomeByIndividual: $incomeByIndividual, totalIncome: $totalIncome, taxableIncome: $taxableIncome, federalTax: $federalTax, quebecTax: $quebecTax, totalTax: $totalTax, afterTaxIncome: $afterTaxIncome, totalExpenses: $totalExpenses, expensesByCategory: $expensesByCategory, withdrawalsByAccount: $withdrawalsByAccount, contributionsByAccount: $contributionsByAccount, totalWithdrawals: $totalWithdrawals, totalContributions: $totalContributions, celiContributionRoom: $celiContributionRoom, netCashFlow: $netCashFlow, assetsStartOfYear: $assetsStartOfYear, assetsEndOfYear: $assetsEndOfYear, assetReturns: $assetReturns, netWorthStartOfYear: $netWorthStartOfYear, netWorthEndOfYear: $netWorthEndOfYear, eventsOccurred: $eventsOccurred, hasShortfall: $hasShortfall, shortfallAmount: $shortfallAmount)';
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
            (identical(other.taxableIncome, taxableIncome) ||
                other.taxableIncome == taxableIncome) &&
            (identical(other.federalTax, federalTax) ||
                other.federalTax == federalTax) &&
            (identical(other.quebecTax, quebecTax) ||
                other.quebecTax == quebecTax) &&
            (identical(other.totalTax, totalTax) ||
                other.totalTax == totalTax) &&
            (identical(other.afterTaxIncome, afterTaxIncome) ||
                other.afterTaxIncome == afterTaxIncome) &&
            (identical(other.totalExpenses, totalExpenses) ||
                other.totalExpenses == totalExpenses) &&
            const DeepCollectionEquality().equals(
              other._expensesByCategory,
              _expensesByCategory,
            ) &&
            const DeepCollectionEquality().equals(
              other._withdrawalsByAccount,
              _withdrawalsByAccount,
            ) &&
            const DeepCollectionEquality().equals(
              other._contributionsByAccount,
              _contributionsByAccount,
            ) &&
            (identical(other.totalWithdrawals, totalWithdrawals) ||
                other.totalWithdrawals == totalWithdrawals) &&
            (identical(other.totalContributions, totalContributions) ||
                other.totalContributions == totalContributions) &&
            (identical(other.celiContributionRoom, celiContributionRoom) ||
                other.celiContributionRoom == celiContributionRoom) &&
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
            const DeepCollectionEquality().equals(
              other._assetReturns,
              _assetReturns,
            ) &&
            (identical(other.netWorthStartOfYear, netWorthStartOfYear) ||
                other.netWorthStartOfYear == netWorthStartOfYear) &&
            (identical(other.netWorthEndOfYear, netWorthEndOfYear) ||
                other.netWorthEndOfYear == netWorthEndOfYear) &&
            const DeepCollectionEquality().equals(
              other._eventsOccurred,
              _eventsOccurred,
            ) &&
            (identical(other.hasShortfall, hasShortfall) ||
                other.hasShortfall == hasShortfall) &&
            (identical(other.shortfallAmount, shortfallAmount) ||
                other.shortfallAmount == shortfallAmount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    year,
    yearsFromStart,
    primaryAge,
    spouseAge,
    const DeepCollectionEquality().hash(_incomeByIndividual),
    totalIncome,
    taxableIncome,
    federalTax,
    quebecTax,
    totalTax,
    afterTaxIncome,
    totalExpenses,
    const DeepCollectionEquality().hash(_expensesByCategory),
    const DeepCollectionEquality().hash(_withdrawalsByAccount),
    const DeepCollectionEquality().hash(_contributionsByAccount),
    totalWithdrawals,
    totalContributions,
    celiContributionRoom,
    netCashFlow,
    const DeepCollectionEquality().hash(_assetsStartOfYear),
    const DeepCollectionEquality().hash(_assetsEndOfYear),
    const DeepCollectionEquality().hash(_assetReturns),
    netWorthStartOfYear,
    netWorthEndOfYear,
    const DeepCollectionEquality().hash(_eventsOccurred),
    hasShortfall,
    shortfallAmount,
  ]);

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
    final double taxableIncome,
    final double federalTax,
    final double quebecTax,
    final double totalTax,
    final double afterTaxIncome,
    required final double totalExpenses,
    final Map<String, double> expensesByCategory,
    final Map<String, double> withdrawalsByAccount,
    final Map<String, double> contributionsByAccount,
    final double totalWithdrawals,
    final double totalContributions,
    final double celiContributionRoom,
    required final double netCashFlow,
    required final Map<String, double> assetsStartOfYear,
    required final Map<String, double> assetsEndOfYear,
    final Map<String, double> assetReturns,
    required final double netWorthStartOfYear,
    required final double netWorthEndOfYear,
    required final List<String> eventsOccurred,
    final bool hasShortfall,
    final double shortfallAmount,
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

  /// Total taxable income for the year (household)
  @override
  double get taxableIncome;

  /// Federal tax owing for the year (household)
  @override
  double get federalTax;

  /// Quebec provincial tax owing for the year (household)
  @override
  double get quebecTax;

  /// Total tax owing for the year (household, federal + Quebec)
  @override
  double get totalTax;

  /// After-tax income (total income - total tax)
  @override
  double get afterTaxIncome;

  /// Total expenses for the year
  @override
  double get totalExpenses;

  /// Expenses by category (keyed by category name)
  /// Keys: 'housing', 'transport', 'dailyLiving', 'recreation', 'health', 'family'
  @override
  Map<String, double> get expensesByCategory;

  /// Withdrawals by account (keyed by asset ID)
  @override
  Map<String, double> get withdrawalsByAccount;

  /// Contributions by account (keyed by asset ID)
  @override
  Map<String, double> get contributionsByAccount;

  /// Total withdrawals for the year
  @override
  double get totalWithdrawals;

  /// Total contributions for the year
  @override
  double get totalContributions;

  /// CELI contribution room remaining at end of year
  @override
  double get celiContributionRoom;

  /// Net cash flow (income - expenses - taxes)
  @override
  double get netCashFlow;

  /// Assets at start of year
  @override
  Map<String, double> get assetsStartOfYear;

  /// Assets at end of year
  @override
  Map<String, double> get assetsEndOfYear;

  /// Asset returns for the year (keyed by asset ID)
  @override
  Map<String, double> get assetReturns;

  /// Total net worth at start of year
  @override
  double get netWorthStartOfYear;

  /// Total net worth at end of year
  @override
  double get netWorthEndOfYear;

  /// Events that occurred during this year
  @override
  List<String> get eventsOccurred;

  /// Whether there was a shortfall this year (insufficient funds to cover expenses)
  @override
  bool get hasShortfall;

  /// Amount of shortfall if hasShortfall is true
  @override
  double get shortfallAmount;

  /// Create a copy of YearlyProjection
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$YearlyProjectionImplCopyWith<_$YearlyProjectionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
