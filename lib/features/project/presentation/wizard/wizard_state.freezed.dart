// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'wizard_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$WizardState {
  // Current step in the wizard (0-based index)
  int get currentStep =>
      throw _privateConstructorUsedError; // Project ID that wizard is populating
  String get projectId =>
      throw _privateConstructorUsedError; // Step 1: Individuals (1-2 individuals)
  Individual? get individual1 => throw _privateConstructorUsedError;
  Individual? get individual2 =>
      throw _privateConstructorUsedError; // Step 2: Revenue Sources (tracked per individual)
  WizardRevenueSourcesData get revenueSources =>
      throw _privateConstructorUsedError; // Step 3: Assets
  List<WizardAssetData> get assets =>
      throw _privateConstructorUsedError; // Step 4: Expenses
  WizardExpensesData get expenses =>
      throw _privateConstructorUsedError; // Step 5: Scenarios (which scenario templates to create)
  WizardScenariosData get scenarios => throw _privateConstructorUsedError;

  /// Create a copy of WizardState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WizardStateCopyWith<WizardState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WizardStateCopyWith<$Res> {
  factory $WizardStateCopyWith(
    WizardState value,
    $Res Function(WizardState) then,
  ) = _$WizardStateCopyWithImpl<$Res, WizardState>;
  @useResult
  $Res call({
    int currentStep,
    String projectId,
    Individual? individual1,
    Individual? individual2,
    WizardRevenueSourcesData revenueSources,
    List<WizardAssetData> assets,
    WizardExpensesData expenses,
    WizardScenariosData scenarios,
  });

  $IndividualCopyWith<$Res>? get individual1;
  $IndividualCopyWith<$Res>? get individual2;
  $WizardRevenueSourcesDataCopyWith<$Res> get revenueSources;
  $WizardExpensesDataCopyWith<$Res> get expenses;
  $WizardScenariosDataCopyWith<$Res> get scenarios;
}

/// @nodoc
class _$WizardStateCopyWithImpl<$Res, $Val extends WizardState>
    implements $WizardStateCopyWith<$Res> {
  _$WizardStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WizardState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentStep = null,
    Object? projectId = null,
    Object? individual1 = freezed,
    Object? individual2 = freezed,
    Object? revenueSources = null,
    Object? assets = null,
    Object? expenses = null,
    Object? scenarios = null,
  }) {
    return _then(
      _value.copyWith(
            currentStep: null == currentStep
                ? _value.currentStep
                : currentStep // ignore: cast_nullable_to_non_nullable
                      as int,
            projectId: null == projectId
                ? _value.projectId
                : projectId // ignore: cast_nullable_to_non_nullable
                      as String,
            individual1: freezed == individual1
                ? _value.individual1
                : individual1 // ignore: cast_nullable_to_non_nullable
                      as Individual?,
            individual2: freezed == individual2
                ? _value.individual2
                : individual2 // ignore: cast_nullable_to_non_nullable
                      as Individual?,
            revenueSources: null == revenueSources
                ? _value.revenueSources
                : revenueSources // ignore: cast_nullable_to_non_nullable
                      as WizardRevenueSourcesData,
            assets: null == assets
                ? _value.assets
                : assets // ignore: cast_nullable_to_non_nullable
                      as List<WizardAssetData>,
            expenses: null == expenses
                ? _value.expenses
                : expenses // ignore: cast_nullable_to_non_nullable
                      as WizardExpensesData,
            scenarios: null == scenarios
                ? _value.scenarios
                : scenarios // ignore: cast_nullable_to_non_nullable
                      as WizardScenariosData,
          )
          as $Val,
    );
  }

  /// Create a copy of WizardState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $IndividualCopyWith<$Res>? get individual1 {
    if (_value.individual1 == null) {
      return null;
    }

    return $IndividualCopyWith<$Res>(_value.individual1!, (value) {
      return _then(_value.copyWith(individual1: value) as $Val);
    });
  }

  /// Create a copy of WizardState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $IndividualCopyWith<$Res>? get individual2 {
    if (_value.individual2 == null) {
      return null;
    }

    return $IndividualCopyWith<$Res>(_value.individual2!, (value) {
      return _then(_value.copyWith(individual2: value) as $Val);
    });
  }

  /// Create a copy of WizardState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $WizardRevenueSourcesDataCopyWith<$Res> get revenueSources {
    return $WizardRevenueSourcesDataCopyWith<$Res>(_value.revenueSources, (
      value,
    ) {
      return _then(_value.copyWith(revenueSources: value) as $Val);
    });
  }

  /// Create a copy of WizardState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $WizardExpensesDataCopyWith<$Res> get expenses {
    return $WizardExpensesDataCopyWith<$Res>(_value.expenses, (value) {
      return _then(_value.copyWith(expenses: value) as $Val);
    });
  }

  /// Create a copy of WizardState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $WizardScenariosDataCopyWith<$Res> get scenarios {
    return $WizardScenariosDataCopyWith<$Res>(_value.scenarios, (value) {
      return _then(_value.copyWith(scenarios: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$WizardStateImplCopyWith<$Res>
    implements $WizardStateCopyWith<$Res> {
  factory _$$WizardStateImplCopyWith(
    _$WizardStateImpl value,
    $Res Function(_$WizardStateImpl) then,
  ) = __$$WizardStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int currentStep,
    String projectId,
    Individual? individual1,
    Individual? individual2,
    WizardRevenueSourcesData revenueSources,
    List<WizardAssetData> assets,
    WizardExpensesData expenses,
    WizardScenariosData scenarios,
  });

  @override
  $IndividualCopyWith<$Res>? get individual1;
  @override
  $IndividualCopyWith<$Res>? get individual2;
  @override
  $WizardRevenueSourcesDataCopyWith<$Res> get revenueSources;
  @override
  $WizardExpensesDataCopyWith<$Res> get expenses;
  @override
  $WizardScenariosDataCopyWith<$Res> get scenarios;
}

/// @nodoc
class __$$WizardStateImplCopyWithImpl<$Res>
    extends _$WizardStateCopyWithImpl<$Res, _$WizardStateImpl>
    implements _$$WizardStateImplCopyWith<$Res> {
  __$$WizardStateImplCopyWithImpl(
    _$WizardStateImpl _value,
    $Res Function(_$WizardStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of WizardState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentStep = null,
    Object? projectId = null,
    Object? individual1 = freezed,
    Object? individual2 = freezed,
    Object? revenueSources = null,
    Object? assets = null,
    Object? expenses = null,
    Object? scenarios = null,
  }) {
    return _then(
      _$WizardStateImpl(
        currentStep: null == currentStep
            ? _value.currentStep
            : currentStep // ignore: cast_nullable_to_non_nullable
                  as int,
        projectId: null == projectId
            ? _value.projectId
            : projectId // ignore: cast_nullable_to_non_nullable
                  as String,
        individual1: freezed == individual1
            ? _value.individual1
            : individual1 // ignore: cast_nullable_to_non_nullable
                  as Individual?,
        individual2: freezed == individual2
            ? _value.individual2
            : individual2 // ignore: cast_nullable_to_non_nullable
                  as Individual?,
        revenueSources: null == revenueSources
            ? _value.revenueSources
            : revenueSources // ignore: cast_nullable_to_non_nullable
                  as WizardRevenueSourcesData,
        assets: null == assets
            ? _value._assets
            : assets // ignore: cast_nullable_to_non_nullable
                  as List<WizardAssetData>,
        expenses: null == expenses
            ? _value.expenses
            : expenses // ignore: cast_nullable_to_non_nullable
                  as WizardExpensesData,
        scenarios: null == scenarios
            ? _value.scenarios
            : scenarios // ignore: cast_nullable_to_non_nullable
                  as WizardScenariosData,
      ),
    );
  }
}

/// @nodoc

class _$WizardStateImpl implements _WizardState {
  const _$WizardStateImpl({
    this.currentStep = 0,
    required this.projectId,
    this.individual1,
    this.individual2,
    this.revenueSources = const WizardRevenueSourcesData(),
    final List<WizardAssetData> assets = const [],
    this.expenses = const WizardExpensesData(),
    this.scenarios = const WizardScenariosData(),
  }) : _assets = assets;

  // Current step in the wizard (0-based index)
  @override
  @JsonKey()
  final int currentStep;
  // Project ID that wizard is populating
  @override
  final String projectId;
  // Step 1: Individuals (1-2 individuals)
  @override
  final Individual? individual1;
  @override
  final Individual? individual2;
  // Step 2: Revenue Sources (tracked per individual)
  @override
  @JsonKey()
  final WizardRevenueSourcesData revenueSources;
  // Step 3: Assets
  final List<WizardAssetData> _assets;
  // Step 3: Assets
  @override
  @JsonKey()
  List<WizardAssetData> get assets {
    if (_assets is EqualUnmodifiableListView) return _assets;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_assets);
  }

  // Step 4: Expenses
  @override
  @JsonKey()
  final WizardExpensesData expenses;
  // Step 5: Scenarios (which scenario templates to create)
  @override
  @JsonKey()
  final WizardScenariosData scenarios;

  @override
  String toString() {
    return 'WizardState(currentStep: $currentStep, projectId: $projectId, individual1: $individual1, individual2: $individual2, revenueSources: $revenueSources, assets: $assets, expenses: $expenses, scenarios: $scenarios)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WizardStateImpl &&
            (identical(other.currentStep, currentStep) ||
                other.currentStep == currentStep) &&
            (identical(other.projectId, projectId) ||
                other.projectId == projectId) &&
            (identical(other.individual1, individual1) ||
                other.individual1 == individual1) &&
            (identical(other.individual2, individual2) ||
                other.individual2 == individual2) &&
            (identical(other.revenueSources, revenueSources) ||
                other.revenueSources == revenueSources) &&
            const DeepCollectionEquality().equals(other._assets, _assets) &&
            (identical(other.expenses, expenses) ||
                other.expenses == expenses) &&
            (identical(other.scenarios, scenarios) ||
                other.scenarios == scenarios));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    currentStep,
    projectId,
    individual1,
    individual2,
    revenueSources,
    const DeepCollectionEquality().hash(_assets),
    expenses,
    scenarios,
  );

  /// Create a copy of WizardState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WizardStateImplCopyWith<_$WizardStateImpl> get copyWith =>
      __$$WizardStateImplCopyWithImpl<_$WizardStateImpl>(this, _$identity);
}

abstract class _WizardState implements WizardState {
  const factory _WizardState({
    final int currentStep,
    required final String projectId,
    final Individual? individual1,
    final Individual? individual2,
    final WizardRevenueSourcesData revenueSources,
    final List<WizardAssetData> assets,
    final WizardExpensesData expenses,
    final WizardScenariosData scenarios,
  }) = _$WizardStateImpl;

  // Current step in the wizard (0-based index)
  @override
  int get currentStep; // Project ID that wizard is populating
  @override
  String get projectId; // Step 1: Individuals (1-2 individuals)
  @override
  Individual? get individual1;
  @override
  Individual? get individual2; // Step 2: Revenue Sources (tracked per individual)
  @override
  WizardRevenueSourcesData get revenueSources; // Step 3: Assets
  @override
  List<WizardAssetData> get assets; // Step 4: Expenses
  @override
  WizardExpensesData get expenses; // Step 5: Scenarios (which scenario templates to create)
  @override
  WizardScenariosData get scenarios;

  /// Create a copy of WizardState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WizardStateImplCopyWith<_$WizardStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$WizardRevenueSourcesData {
  // Individual 1 revenue sources
  bool get individual1HasRrq => throw _privateConstructorUsedError;
  bool get individual1HasPsv => throw _privateConstructorUsedError;
  bool get individual1HasRrpe => throw _privateConstructorUsedError;
  bool get individual1HasEmployment => throw _privateConstructorUsedError;
  bool get individual1HasOther =>
      throw _privateConstructorUsedError; // Individual 2 revenue sources (if applicable)
  bool get individual2HasRrq => throw _privateConstructorUsedError;
  bool get individual2HasPsv => throw _privateConstructorUsedError;
  bool get individual2HasRrpe => throw _privateConstructorUsedError;
  bool get individual2HasEmployment => throw _privateConstructorUsedError;
  bool get individual2HasOther =>
      throw _privateConstructorUsedError; // RRQ details for Individual 1
  int get individual1RrqStartAge => throw _privateConstructorUsedError;
  double get individual1RrqAmountAt60 => throw _privateConstructorUsedError;
  double get individual1RrqAmountAt65 =>
      throw _privateConstructorUsedError; // PSV details for Individual 1
  int get individual1PsvStartAge =>
      throw _privateConstructorUsedError; // RRPE details for Individual 1
  DateTime? get individual1RrpeStartDate =>
      throw _privateConstructorUsedError; // RRQ details for Individual 2
  int get individual2RrqStartAge => throw _privateConstructorUsedError;
  double get individual2RrqAmountAt60 => throw _privateConstructorUsedError;
  double get individual2RrqAmountAt65 =>
      throw _privateConstructorUsedError; // PSV details for Individual 2
  int get individual2PsvStartAge =>
      throw _privateConstructorUsedError; // RRPE details for Individual 2
  DateTime? get individual2RrpeStartDate => throw _privateConstructorUsedError;

  /// Create a copy of WizardRevenueSourcesData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WizardRevenueSourcesDataCopyWith<WizardRevenueSourcesData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WizardRevenueSourcesDataCopyWith<$Res> {
  factory $WizardRevenueSourcesDataCopyWith(
    WizardRevenueSourcesData value,
    $Res Function(WizardRevenueSourcesData) then,
  ) = _$WizardRevenueSourcesDataCopyWithImpl<$Res, WizardRevenueSourcesData>;
  @useResult
  $Res call({
    bool individual1HasRrq,
    bool individual1HasPsv,
    bool individual1HasRrpe,
    bool individual1HasEmployment,
    bool individual1HasOther,
    bool individual2HasRrq,
    bool individual2HasPsv,
    bool individual2HasRrpe,
    bool individual2HasEmployment,
    bool individual2HasOther,
    int individual1RrqStartAge,
    double individual1RrqAmountAt60,
    double individual1RrqAmountAt65,
    int individual1PsvStartAge,
    DateTime? individual1RrpeStartDate,
    int individual2RrqStartAge,
    double individual2RrqAmountAt60,
    double individual2RrqAmountAt65,
    int individual2PsvStartAge,
    DateTime? individual2RrpeStartDate,
  });
}

/// @nodoc
class _$WizardRevenueSourcesDataCopyWithImpl<
  $Res,
  $Val extends WizardRevenueSourcesData
>
    implements $WizardRevenueSourcesDataCopyWith<$Res> {
  _$WizardRevenueSourcesDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WizardRevenueSourcesData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? individual1HasRrq = null,
    Object? individual1HasPsv = null,
    Object? individual1HasRrpe = null,
    Object? individual1HasEmployment = null,
    Object? individual1HasOther = null,
    Object? individual2HasRrq = null,
    Object? individual2HasPsv = null,
    Object? individual2HasRrpe = null,
    Object? individual2HasEmployment = null,
    Object? individual2HasOther = null,
    Object? individual1RrqStartAge = null,
    Object? individual1RrqAmountAt60 = null,
    Object? individual1RrqAmountAt65 = null,
    Object? individual1PsvStartAge = null,
    Object? individual1RrpeStartDate = freezed,
    Object? individual2RrqStartAge = null,
    Object? individual2RrqAmountAt60 = null,
    Object? individual2RrqAmountAt65 = null,
    Object? individual2PsvStartAge = null,
    Object? individual2RrpeStartDate = freezed,
  }) {
    return _then(
      _value.copyWith(
            individual1HasRrq: null == individual1HasRrq
                ? _value.individual1HasRrq
                : individual1HasRrq // ignore: cast_nullable_to_non_nullable
                      as bool,
            individual1HasPsv: null == individual1HasPsv
                ? _value.individual1HasPsv
                : individual1HasPsv // ignore: cast_nullable_to_non_nullable
                      as bool,
            individual1HasRrpe: null == individual1HasRrpe
                ? _value.individual1HasRrpe
                : individual1HasRrpe // ignore: cast_nullable_to_non_nullable
                      as bool,
            individual1HasEmployment: null == individual1HasEmployment
                ? _value.individual1HasEmployment
                : individual1HasEmployment // ignore: cast_nullable_to_non_nullable
                      as bool,
            individual1HasOther: null == individual1HasOther
                ? _value.individual1HasOther
                : individual1HasOther // ignore: cast_nullable_to_non_nullable
                      as bool,
            individual2HasRrq: null == individual2HasRrq
                ? _value.individual2HasRrq
                : individual2HasRrq // ignore: cast_nullable_to_non_nullable
                      as bool,
            individual2HasPsv: null == individual2HasPsv
                ? _value.individual2HasPsv
                : individual2HasPsv // ignore: cast_nullable_to_non_nullable
                      as bool,
            individual2HasRrpe: null == individual2HasRrpe
                ? _value.individual2HasRrpe
                : individual2HasRrpe // ignore: cast_nullable_to_non_nullable
                      as bool,
            individual2HasEmployment: null == individual2HasEmployment
                ? _value.individual2HasEmployment
                : individual2HasEmployment // ignore: cast_nullable_to_non_nullable
                      as bool,
            individual2HasOther: null == individual2HasOther
                ? _value.individual2HasOther
                : individual2HasOther // ignore: cast_nullable_to_non_nullable
                      as bool,
            individual1RrqStartAge: null == individual1RrqStartAge
                ? _value.individual1RrqStartAge
                : individual1RrqStartAge // ignore: cast_nullable_to_non_nullable
                      as int,
            individual1RrqAmountAt60: null == individual1RrqAmountAt60
                ? _value.individual1RrqAmountAt60
                : individual1RrqAmountAt60 // ignore: cast_nullable_to_non_nullable
                      as double,
            individual1RrqAmountAt65: null == individual1RrqAmountAt65
                ? _value.individual1RrqAmountAt65
                : individual1RrqAmountAt65 // ignore: cast_nullable_to_non_nullable
                      as double,
            individual1PsvStartAge: null == individual1PsvStartAge
                ? _value.individual1PsvStartAge
                : individual1PsvStartAge // ignore: cast_nullable_to_non_nullable
                      as int,
            individual1RrpeStartDate: freezed == individual1RrpeStartDate
                ? _value.individual1RrpeStartDate
                : individual1RrpeStartDate // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            individual2RrqStartAge: null == individual2RrqStartAge
                ? _value.individual2RrqStartAge
                : individual2RrqStartAge // ignore: cast_nullable_to_non_nullable
                      as int,
            individual2RrqAmountAt60: null == individual2RrqAmountAt60
                ? _value.individual2RrqAmountAt60
                : individual2RrqAmountAt60 // ignore: cast_nullable_to_non_nullable
                      as double,
            individual2RrqAmountAt65: null == individual2RrqAmountAt65
                ? _value.individual2RrqAmountAt65
                : individual2RrqAmountAt65 // ignore: cast_nullable_to_non_nullable
                      as double,
            individual2PsvStartAge: null == individual2PsvStartAge
                ? _value.individual2PsvStartAge
                : individual2PsvStartAge // ignore: cast_nullable_to_non_nullable
                      as int,
            individual2RrpeStartDate: freezed == individual2RrpeStartDate
                ? _value.individual2RrpeStartDate
                : individual2RrpeStartDate // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$WizardRevenueSourcesDataImplCopyWith<$Res>
    implements $WizardRevenueSourcesDataCopyWith<$Res> {
  factory _$$WizardRevenueSourcesDataImplCopyWith(
    _$WizardRevenueSourcesDataImpl value,
    $Res Function(_$WizardRevenueSourcesDataImpl) then,
  ) = __$$WizardRevenueSourcesDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    bool individual1HasRrq,
    bool individual1HasPsv,
    bool individual1HasRrpe,
    bool individual1HasEmployment,
    bool individual1HasOther,
    bool individual2HasRrq,
    bool individual2HasPsv,
    bool individual2HasRrpe,
    bool individual2HasEmployment,
    bool individual2HasOther,
    int individual1RrqStartAge,
    double individual1RrqAmountAt60,
    double individual1RrqAmountAt65,
    int individual1PsvStartAge,
    DateTime? individual1RrpeStartDate,
    int individual2RrqStartAge,
    double individual2RrqAmountAt60,
    double individual2RrqAmountAt65,
    int individual2PsvStartAge,
    DateTime? individual2RrpeStartDate,
  });
}

/// @nodoc
class __$$WizardRevenueSourcesDataImplCopyWithImpl<$Res>
    extends
        _$WizardRevenueSourcesDataCopyWithImpl<
          $Res,
          _$WizardRevenueSourcesDataImpl
        >
    implements _$$WizardRevenueSourcesDataImplCopyWith<$Res> {
  __$$WizardRevenueSourcesDataImplCopyWithImpl(
    _$WizardRevenueSourcesDataImpl _value,
    $Res Function(_$WizardRevenueSourcesDataImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of WizardRevenueSourcesData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? individual1HasRrq = null,
    Object? individual1HasPsv = null,
    Object? individual1HasRrpe = null,
    Object? individual1HasEmployment = null,
    Object? individual1HasOther = null,
    Object? individual2HasRrq = null,
    Object? individual2HasPsv = null,
    Object? individual2HasRrpe = null,
    Object? individual2HasEmployment = null,
    Object? individual2HasOther = null,
    Object? individual1RrqStartAge = null,
    Object? individual1RrqAmountAt60 = null,
    Object? individual1RrqAmountAt65 = null,
    Object? individual1PsvStartAge = null,
    Object? individual1RrpeStartDate = freezed,
    Object? individual2RrqStartAge = null,
    Object? individual2RrqAmountAt60 = null,
    Object? individual2RrqAmountAt65 = null,
    Object? individual2PsvStartAge = null,
    Object? individual2RrpeStartDate = freezed,
  }) {
    return _then(
      _$WizardRevenueSourcesDataImpl(
        individual1HasRrq: null == individual1HasRrq
            ? _value.individual1HasRrq
            : individual1HasRrq // ignore: cast_nullable_to_non_nullable
                  as bool,
        individual1HasPsv: null == individual1HasPsv
            ? _value.individual1HasPsv
            : individual1HasPsv // ignore: cast_nullable_to_non_nullable
                  as bool,
        individual1HasRrpe: null == individual1HasRrpe
            ? _value.individual1HasRrpe
            : individual1HasRrpe // ignore: cast_nullable_to_non_nullable
                  as bool,
        individual1HasEmployment: null == individual1HasEmployment
            ? _value.individual1HasEmployment
            : individual1HasEmployment // ignore: cast_nullable_to_non_nullable
                  as bool,
        individual1HasOther: null == individual1HasOther
            ? _value.individual1HasOther
            : individual1HasOther // ignore: cast_nullable_to_non_nullable
                  as bool,
        individual2HasRrq: null == individual2HasRrq
            ? _value.individual2HasRrq
            : individual2HasRrq // ignore: cast_nullable_to_non_nullable
                  as bool,
        individual2HasPsv: null == individual2HasPsv
            ? _value.individual2HasPsv
            : individual2HasPsv // ignore: cast_nullable_to_non_nullable
                  as bool,
        individual2HasRrpe: null == individual2HasRrpe
            ? _value.individual2HasRrpe
            : individual2HasRrpe // ignore: cast_nullable_to_non_nullable
                  as bool,
        individual2HasEmployment: null == individual2HasEmployment
            ? _value.individual2HasEmployment
            : individual2HasEmployment // ignore: cast_nullable_to_non_nullable
                  as bool,
        individual2HasOther: null == individual2HasOther
            ? _value.individual2HasOther
            : individual2HasOther // ignore: cast_nullable_to_non_nullable
                  as bool,
        individual1RrqStartAge: null == individual1RrqStartAge
            ? _value.individual1RrqStartAge
            : individual1RrqStartAge // ignore: cast_nullable_to_non_nullable
                  as int,
        individual1RrqAmountAt60: null == individual1RrqAmountAt60
            ? _value.individual1RrqAmountAt60
            : individual1RrqAmountAt60 // ignore: cast_nullable_to_non_nullable
                  as double,
        individual1RrqAmountAt65: null == individual1RrqAmountAt65
            ? _value.individual1RrqAmountAt65
            : individual1RrqAmountAt65 // ignore: cast_nullable_to_non_nullable
                  as double,
        individual1PsvStartAge: null == individual1PsvStartAge
            ? _value.individual1PsvStartAge
            : individual1PsvStartAge // ignore: cast_nullable_to_non_nullable
                  as int,
        individual1RrpeStartDate: freezed == individual1RrpeStartDate
            ? _value.individual1RrpeStartDate
            : individual1RrpeStartDate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        individual2RrqStartAge: null == individual2RrqStartAge
            ? _value.individual2RrqStartAge
            : individual2RrqStartAge // ignore: cast_nullable_to_non_nullable
                  as int,
        individual2RrqAmountAt60: null == individual2RrqAmountAt60
            ? _value.individual2RrqAmountAt60
            : individual2RrqAmountAt60 // ignore: cast_nullable_to_non_nullable
                  as double,
        individual2RrqAmountAt65: null == individual2RrqAmountAt65
            ? _value.individual2RrqAmountAt65
            : individual2RrqAmountAt65 // ignore: cast_nullable_to_non_nullable
                  as double,
        individual2PsvStartAge: null == individual2PsvStartAge
            ? _value.individual2PsvStartAge
            : individual2PsvStartAge // ignore: cast_nullable_to_non_nullable
                  as int,
        individual2RrpeStartDate: freezed == individual2RrpeStartDate
            ? _value.individual2RrpeStartDate
            : individual2RrpeStartDate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc

class _$WizardRevenueSourcesDataImpl implements _WizardRevenueSourcesData {
  const _$WizardRevenueSourcesDataImpl({
    this.individual1HasRrq = true,
    this.individual1HasPsv = true,
    this.individual1HasRrpe = false,
    this.individual1HasEmployment = false,
    this.individual1HasOther = false,
    this.individual2HasRrq = true,
    this.individual2HasPsv = true,
    this.individual2HasRrpe = false,
    this.individual2HasEmployment = false,
    this.individual2HasOther = false,
    this.individual1RrqStartAge = 65,
    this.individual1RrqAmountAt60 = 12000.0,
    this.individual1RrqAmountAt65 = 16000.0,
    this.individual1PsvStartAge = 65,
    this.individual1RrpeStartDate,
    this.individual2RrqStartAge = 65,
    this.individual2RrqAmountAt60 = 12000.0,
    this.individual2RrqAmountAt65 = 16000.0,
    this.individual2PsvStartAge = 65,
    this.individual2RrpeStartDate,
  });

  // Individual 1 revenue sources
  @override
  @JsonKey()
  final bool individual1HasRrq;
  @override
  @JsonKey()
  final bool individual1HasPsv;
  @override
  @JsonKey()
  final bool individual1HasRrpe;
  @override
  @JsonKey()
  final bool individual1HasEmployment;
  @override
  @JsonKey()
  final bool individual1HasOther;
  // Individual 2 revenue sources (if applicable)
  @override
  @JsonKey()
  final bool individual2HasRrq;
  @override
  @JsonKey()
  final bool individual2HasPsv;
  @override
  @JsonKey()
  final bool individual2HasRrpe;
  @override
  @JsonKey()
  final bool individual2HasEmployment;
  @override
  @JsonKey()
  final bool individual2HasOther;
  // RRQ details for Individual 1
  @override
  @JsonKey()
  final int individual1RrqStartAge;
  @override
  @JsonKey()
  final double individual1RrqAmountAt60;
  @override
  @JsonKey()
  final double individual1RrqAmountAt65;
  // PSV details for Individual 1
  @override
  @JsonKey()
  final int individual1PsvStartAge;
  // RRPE details for Individual 1
  @override
  final DateTime? individual1RrpeStartDate;
  // RRQ details for Individual 2
  @override
  @JsonKey()
  final int individual2RrqStartAge;
  @override
  @JsonKey()
  final double individual2RrqAmountAt60;
  @override
  @JsonKey()
  final double individual2RrqAmountAt65;
  // PSV details for Individual 2
  @override
  @JsonKey()
  final int individual2PsvStartAge;
  // RRPE details for Individual 2
  @override
  final DateTime? individual2RrpeStartDate;

  @override
  String toString() {
    return 'WizardRevenueSourcesData(individual1HasRrq: $individual1HasRrq, individual1HasPsv: $individual1HasPsv, individual1HasRrpe: $individual1HasRrpe, individual1HasEmployment: $individual1HasEmployment, individual1HasOther: $individual1HasOther, individual2HasRrq: $individual2HasRrq, individual2HasPsv: $individual2HasPsv, individual2HasRrpe: $individual2HasRrpe, individual2HasEmployment: $individual2HasEmployment, individual2HasOther: $individual2HasOther, individual1RrqStartAge: $individual1RrqStartAge, individual1RrqAmountAt60: $individual1RrqAmountAt60, individual1RrqAmountAt65: $individual1RrqAmountAt65, individual1PsvStartAge: $individual1PsvStartAge, individual1RrpeStartDate: $individual1RrpeStartDate, individual2RrqStartAge: $individual2RrqStartAge, individual2RrqAmountAt60: $individual2RrqAmountAt60, individual2RrqAmountAt65: $individual2RrqAmountAt65, individual2PsvStartAge: $individual2PsvStartAge, individual2RrpeStartDate: $individual2RrpeStartDate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WizardRevenueSourcesDataImpl &&
            (identical(other.individual1HasRrq, individual1HasRrq) ||
                other.individual1HasRrq == individual1HasRrq) &&
            (identical(other.individual1HasPsv, individual1HasPsv) ||
                other.individual1HasPsv == individual1HasPsv) &&
            (identical(other.individual1HasRrpe, individual1HasRrpe) ||
                other.individual1HasRrpe == individual1HasRrpe) &&
            (identical(
                  other.individual1HasEmployment,
                  individual1HasEmployment,
                ) ||
                other.individual1HasEmployment == individual1HasEmployment) &&
            (identical(other.individual1HasOther, individual1HasOther) ||
                other.individual1HasOther == individual1HasOther) &&
            (identical(other.individual2HasRrq, individual2HasRrq) ||
                other.individual2HasRrq == individual2HasRrq) &&
            (identical(other.individual2HasPsv, individual2HasPsv) ||
                other.individual2HasPsv == individual2HasPsv) &&
            (identical(other.individual2HasRrpe, individual2HasRrpe) ||
                other.individual2HasRrpe == individual2HasRrpe) &&
            (identical(
                  other.individual2HasEmployment,
                  individual2HasEmployment,
                ) ||
                other.individual2HasEmployment == individual2HasEmployment) &&
            (identical(other.individual2HasOther, individual2HasOther) ||
                other.individual2HasOther == individual2HasOther) &&
            (identical(other.individual1RrqStartAge, individual1RrqStartAge) ||
                other.individual1RrqStartAge == individual1RrqStartAge) &&
            (identical(
                  other.individual1RrqAmountAt60,
                  individual1RrqAmountAt60,
                ) ||
                other.individual1RrqAmountAt60 == individual1RrqAmountAt60) &&
            (identical(
                  other.individual1RrqAmountAt65,
                  individual1RrqAmountAt65,
                ) ||
                other.individual1RrqAmountAt65 == individual1RrqAmountAt65) &&
            (identical(other.individual1PsvStartAge, individual1PsvStartAge) ||
                other.individual1PsvStartAge == individual1PsvStartAge) &&
            (identical(
                  other.individual1RrpeStartDate,
                  individual1RrpeStartDate,
                ) ||
                other.individual1RrpeStartDate == individual1RrpeStartDate) &&
            (identical(other.individual2RrqStartAge, individual2RrqStartAge) ||
                other.individual2RrqStartAge == individual2RrqStartAge) &&
            (identical(
                  other.individual2RrqAmountAt60,
                  individual2RrqAmountAt60,
                ) ||
                other.individual2RrqAmountAt60 == individual2RrqAmountAt60) &&
            (identical(
                  other.individual2RrqAmountAt65,
                  individual2RrqAmountAt65,
                ) ||
                other.individual2RrqAmountAt65 == individual2RrqAmountAt65) &&
            (identical(other.individual2PsvStartAge, individual2PsvStartAge) ||
                other.individual2PsvStartAge == individual2PsvStartAge) &&
            (identical(
                  other.individual2RrpeStartDate,
                  individual2RrpeStartDate,
                ) ||
                other.individual2RrpeStartDate == individual2RrpeStartDate));
  }

  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    individual1HasRrq,
    individual1HasPsv,
    individual1HasRrpe,
    individual1HasEmployment,
    individual1HasOther,
    individual2HasRrq,
    individual2HasPsv,
    individual2HasRrpe,
    individual2HasEmployment,
    individual2HasOther,
    individual1RrqStartAge,
    individual1RrqAmountAt60,
    individual1RrqAmountAt65,
    individual1PsvStartAge,
    individual1RrpeStartDate,
    individual2RrqStartAge,
    individual2RrqAmountAt60,
    individual2RrqAmountAt65,
    individual2PsvStartAge,
    individual2RrpeStartDate,
  ]);

  /// Create a copy of WizardRevenueSourcesData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WizardRevenueSourcesDataImplCopyWith<_$WizardRevenueSourcesDataImpl>
  get copyWith =>
      __$$WizardRevenueSourcesDataImplCopyWithImpl<
        _$WizardRevenueSourcesDataImpl
      >(this, _$identity);
}

abstract class _WizardRevenueSourcesData implements WizardRevenueSourcesData {
  const factory _WizardRevenueSourcesData({
    final bool individual1HasRrq,
    final bool individual1HasPsv,
    final bool individual1HasRrpe,
    final bool individual1HasEmployment,
    final bool individual1HasOther,
    final bool individual2HasRrq,
    final bool individual2HasPsv,
    final bool individual2HasRrpe,
    final bool individual2HasEmployment,
    final bool individual2HasOther,
    final int individual1RrqStartAge,
    final double individual1RrqAmountAt60,
    final double individual1RrqAmountAt65,
    final int individual1PsvStartAge,
    final DateTime? individual1RrpeStartDate,
    final int individual2RrqStartAge,
    final double individual2RrqAmountAt60,
    final double individual2RrqAmountAt65,
    final int individual2PsvStartAge,
    final DateTime? individual2RrpeStartDate,
  }) = _$WizardRevenueSourcesDataImpl;

  // Individual 1 revenue sources
  @override
  bool get individual1HasRrq;
  @override
  bool get individual1HasPsv;
  @override
  bool get individual1HasRrpe;
  @override
  bool get individual1HasEmployment;
  @override
  bool get individual1HasOther; // Individual 2 revenue sources (if applicable)
  @override
  bool get individual2HasRrq;
  @override
  bool get individual2HasPsv;
  @override
  bool get individual2HasRrpe;
  @override
  bool get individual2HasEmployment;
  @override
  bool get individual2HasOther; // RRQ details for Individual 1
  @override
  int get individual1RrqStartAge;
  @override
  double get individual1RrqAmountAt60;
  @override
  double get individual1RrqAmountAt65; // PSV details for Individual 1
  @override
  int get individual1PsvStartAge; // RRPE details for Individual 1
  @override
  DateTime? get individual1RrpeStartDate; // RRQ details for Individual 2
  @override
  int get individual2RrqStartAge;
  @override
  double get individual2RrqAmountAt60;
  @override
  double get individual2RrqAmountAt65; // PSV details for Individual 2
  @override
  int get individual2PsvStartAge; // RRPE details for Individual 2
  @override
  DateTime? get individual2RrpeStartDate;

  /// Create a copy of WizardRevenueSourcesData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WizardRevenueSourcesDataImplCopyWith<_$WizardRevenueSourcesDataImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$WizardAssetData {
  String get id => throw _privateConstructorUsedError;
  double get value => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String id, double value) realEstate,
    required TResult Function(
      String id,
      String individualId,
      double value,
      double? annualContribution,
    )
    rrsp,
    required TResult Function(
      String id,
      String individualId,
      double value,
      double? annualContribution,
    )
    celi,
    required TResult Function(String id, String individualId, double value) cri,
    required TResult Function(String id, String individualId, double value)
    cash,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String id, double value)? realEstate,
    TResult? Function(
      String id,
      String individualId,
      double value,
      double? annualContribution,
    )?
    rrsp,
    TResult? Function(
      String id,
      String individualId,
      double value,
      double? annualContribution,
    )?
    celi,
    TResult? Function(String id, String individualId, double value)? cri,
    TResult? Function(String id, String individualId, double value)? cash,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String id, double value)? realEstate,
    TResult Function(
      String id,
      String individualId,
      double value,
      double? annualContribution,
    )?
    rrsp,
    TResult Function(
      String id,
      String individualId,
      double value,
      double? annualContribution,
    )?
    celi,
    TResult Function(String id, String individualId, double value)? cri,
    TResult Function(String id, String individualId, double value)? cash,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(WizardRealEstateData value) realEstate,
    required TResult Function(WizardRrspData value) rrsp,
    required TResult Function(WizardCeliData value) celi,
    required TResult Function(WizardCriData value) cri,
    required TResult Function(WizardCashData value) cash,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(WizardRealEstateData value)? realEstate,
    TResult? Function(WizardRrspData value)? rrsp,
    TResult? Function(WizardCeliData value)? celi,
    TResult? Function(WizardCriData value)? cri,
    TResult? Function(WizardCashData value)? cash,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(WizardRealEstateData value)? realEstate,
    TResult Function(WizardRrspData value)? rrsp,
    TResult Function(WizardCeliData value)? celi,
    TResult Function(WizardCriData value)? cri,
    TResult Function(WizardCashData value)? cash,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;

  /// Create a copy of WizardAssetData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WizardAssetDataCopyWith<WizardAssetData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WizardAssetDataCopyWith<$Res> {
  factory $WizardAssetDataCopyWith(
    WizardAssetData value,
    $Res Function(WizardAssetData) then,
  ) = _$WizardAssetDataCopyWithImpl<$Res, WizardAssetData>;
  @useResult
  $Res call({String id, double value});
}

/// @nodoc
class _$WizardAssetDataCopyWithImpl<$Res, $Val extends WizardAssetData>
    implements $WizardAssetDataCopyWith<$Res> {
  _$WizardAssetDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WizardAssetData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? id = null, Object? value = null}) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            value: null == value
                ? _value.value
                : value // ignore: cast_nullable_to_non_nullable
                      as double,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$WizardRealEstateDataImplCopyWith<$Res>
    implements $WizardAssetDataCopyWith<$Res> {
  factory _$$WizardRealEstateDataImplCopyWith(
    _$WizardRealEstateDataImpl value,
    $Res Function(_$WizardRealEstateDataImpl) then,
  ) = __$$WizardRealEstateDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, double value});
}

/// @nodoc
class __$$WizardRealEstateDataImplCopyWithImpl<$Res>
    extends _$WizardAssetDataCopyWithImpl<$Res, _$WizardRealEstateDataImpl>
    implements _$$WizardRealEstateDataImplCopyWith<$Res> {
  __$$WizardRealEstateDataImplCopyWithImpl(
    _$WizardRealEstateDataImpl _value,
    $Res Function(_$WizardRealEstateDataImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of WizardAssetData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? id = null, Object? value = null}) {
    return _then(
      _$WizardRealEstateDataImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        value: null == value
            ? _value.value
            : value // ignore: cast_nullable_to_non_nullable
                  as double,
      ),
    );
  }
}

/// @nodoc

class _$WizardRealEstateDataImpl implements WizardRealEstateData {
  const _$WizardRealEstateDataImpl({required this.id, required this.value});

  @override
  final String id;
  @override
  final double value;

  @override
  String toString() {
    return 'WizardAssetData.realEstate(id: $id, value: $value)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WizardRealEstateDataImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.value, value) || other.value == value));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, value);

  /// Create a copy of WizardAssetData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WizardRealEstateDataImplCopyWith<_$WizardRealEstateDataImpl>
  get copyWith =>
      __$$WizardRealEstateDataImplCopyWithImpl<_$WizardRealEstateDataImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String id, double value) realEstate,
    required TResult Function(
      String id,
      String individualId,
      double value,
      double? annualContribution,
    )
    rrsp,
    required TResult Function(
      String id,
      String individualId,
      double value,
      double? annualContribution,
    )
    celi,
    required TResult Function(String id, String individualId, double value) cri,
    required TResult Function(String id, String individualId, double value)
    cash,
  }) {
    return realEstate(id, value);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String id, double value)? realEstate,
    TResult? Function(
      String id,
      String individualId,
      double value,
      double? annualContribution,
    )?
    rrsp,
    TResult? Function(
      String id,
      String individualId,
      double value,
      double? annualContribution,
    )?
    celi,
    TResult? Function(String id, String individualId, double value)? cri,
    TResult? Function(String id, String individualId, double value)? cash,
  }) {
    return realEstate?.call(id, value);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String id, double value)? realEstate,
    TResult Function(
      String id,
      String individualId,
      double value,
      double? annualContribution,
    )?
    rrsp,
    TResult Function(
      String id,
      String individualId,
      double value,
      double? annualContribution,
    )?
    celi,
    TResult Function(String id, String individualId, double value)? cri,
    TResult Function(String id, String individualId, double value)? cash,
    required TResult orElse(),
  }) {
    if (realEstate != null) {
      return realEstate(id, value);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(WizardRealEstateData value) realEstate,
    required TResult Function(WizardRrspData value) rrsp,
    required TResult Function(WizardCeliData value) celi,
    required TResult Function(WizardCriData value) cri,
    required TResult Function(WizardCashData value) cash,
  }) {
    return realEstate(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(WizardRealEstateData value)? realEstate,
    TResult? Function(WizardRrspData value)? rrsp,
    TResult? Function(WizardCeliData value)? celi,
    TResult? Function(WizardCriData value)? cri,
    TResult? Function(WizardCashData value)? cash,
  }) {
    return realEstate?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(WizardRealEstateData value)? realEstate,
    TResult Function(WizardRrspData value)? rrsp,
    TResult Function(WizardCeliData value)? celi,
    TResult Function(WizardCriData value)? cri,
    TResult Function(WizardCashData value)? cash,
    required TResult orElse(),
  }) {
    if (realEstate != null) {
      return realEstate(this);
    }
    return orElse();
  }
}

abstract class WizardRealEstateData implements WizardAssetData {
  const factory WizardRealEstateData({
    required final String id,
    required final double value,
  }) = _$WizardRealEstateDataImpl;

  @override
  String get id;
  @override
  double get value;

  /// Create a copy of WizardAssetData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WizardRealEstateDataImplCopyWith<_$WizardRealEstateDataImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$WizardRrspDataImplCopyWith<$Res>
    implements $WizardAssetDataCopyWith<$Res> {
  factory _$$WizardRrspDataImplCopyWith(
    _$WizardRrspDataImpl value,
    $Res Function(_$WizardRrspDataImpl) then,
  ) = __$$WizardRrspDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String individualId,
    double value,
    double? annualContribution,
  });
}

/// @nodoc
class __$$WizardRrspDataImplCopyWithImpl<$Res>
    extends _$WizardAssetDataCopyWithImpl<$Res, _$WizardRrspDataImpl>
    implements _$$WizardRrspDataImplCopyWith<$Res> {
  __$$WizardRrspDataImplCopyWithImpl(
    _$WizardRrspDataImpl _value,
    $Res Function(_$WizardRrspDataImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of WizardAssetData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? individualId = null,
    Object? value = null,
    Object? annualContribution = freezed,
  }) {
    return _then(
      _$WizardRrspDataImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        individualId: null == individualId
            ? _value.individualId
            : individualId // ignore: cast_nullable_to_non_nullable
                  as String,
        value: null == value
            ? _value.value
            : value // ignore: cast_nullable_to_non_nullable
                  as double,
        annualContribution: freezed == annualContribution
            ? _value.annualContribution
            : annualContribution // ignore: cast_nullable_to_non_nullable
                  as double?,
      ),
    );
  }
}

/// @nodoc

class _$WizardRrspDataImpl implements WizardRrspData {
  const _$WizardRrspDataImpl({
    required this.id,
    required this.individualId,
    required this.value,
    this.annualContribution,
  });

  @override
  final String id;
  @override
  final String individualId;
  // References Individual 1 or 2
  @override
  final double value;
  @override
  final double? annualContribution;

  @override
  String toString() {
    return 'WizardAssetData.rrsp(id: $id, individualId: $individualId, value: $value, annualContribution: $annualContribution)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WizardRrspDataImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.individualId, individualId) ||
                other.individualId == individualId) &&
            (identical(other.value, value) || other.value == value) &&
            (identical(other.annualContribution, annualContribution) ||
                other.annualContribution == annualContribution));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, id, individualId, value, annualContribution);

  /// Create a copy of WizardAssetData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WizardRrspDataImplCopyWith<_$WizardRrspDataImpl> get copyWith =>
      __$$WizardRrspDataImplCopyWithImpl<_$WizardRrspDataImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String id, double value) realEstate,
    required TResult Function(
      String id,
      String individualId,
      double value,
      double? annualContribution,
    )
    rrsp,
    required TResult Function(
      String id,
      String individualId,
      double value,
      double? annualContribution,
    )
    celi,
    required TResult Function(String id, String individualId, double value) cri,
    required TResult Function(String id, String individualId, double value)
    cash,
  }) {
    return rrsp(id, individualId, value, annualContribution);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String id, double value)? realEstate,
    TResult? Function(
      String id,
      String individualId,
      double value,
      double? annualContribution,
    )?
    rrsp,
    TResult? Function(
      String id,
      String individualId,
      double value,
      double? annualContribution,
    )?
    celi,
    TResult? Function(String id, String individualId, double value)? cri,
    TResult? Function(String id, String individualId, double value)? cash,
  }) {
    return rrsp?.call(id, individualId, value, annualContribution);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String id, double value)? realEstate,
    TResult Function(
      String id,
      String individualId,
      double value,
      double? annualContribution,
    )?
    rrsp,
    TResult Function(
      String id,
      String individualId,
      double value,
      double? annualContribution,
    )?
    celi,
    TResult Function(String id, String individualId, double value)? cri,
    TResult Function(String id, String individualId, double value)? cash,
    required TResult orElse(),
  }) {
    if (rrsp != null) {
      return rrsp(id, individualId, value, annualContribution);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(WizardRealEstateData value) realEstate,
    required TResult Function(WizardRrspData value) rrsp,
    required TResult Function(WizardCeliData value) celi,
    required TResult Function(WizardCriData value) cri,
    required TResult Function(WizardCashData value) cash,
  }) {
    return rrsp(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(WizardRealEstateData value)? realEstate,
    TResult? Function(WizardRrspData value)? rrsp,
    TResult? Function(WizardCeliData value)? celi,
    TResult? Function(WizardCriData value)? cri,
    TResult? Function(WizardCashData value)? cash,
  }) {
    return rrsp?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(WizardRealEstateData value)? realEstate,
    TResult Function(WizardRrspData value)? rrsp,
    TResult Function(WizardCeliData value)? celi,
    TResult Function(WizardCriData value)? cri,
    TResult Function(WizardCashData value)? cash,
    required TResult orElse(),
  }) {
    if (rrsp != null) {
      return rrsp(this);
    }
    return orElse();
  }
}

abstract class WizardRrspData implements WizardAssetData {
  const factory WizardRrspData({
    required final String id,
    required final String individualId,
    required final double value,
    final double? annualContribution,
  }) = _$WizardRrspDataImpl;

  @override
  String get id;
  String get individualId; // References Individual 1 or 2
  @override
  double get value;
  double? get annualContribution;

  /// Create a copy of WizardAssetData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WizardRrspDataImplCopyWith<_$WizardRrspDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$WizardCeliDataImplCopyWith<$Res>
    implements $WizardAssetDataCopyWith<$Res> {
  factory _$$WizardCeliDataImplCopyWith(
    _$WizardCeliDataImpl value,
    $Res Function(_$WizardCeliDataImpl) then,
  ) = __$$WizardCeliDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String individualId,
    double value,
    double? annualContribution,
  });
}

/// @nodoc
class __$$WizardCeliDataImplCopyWithImpl<$Res>
    extends _$WizardAssetDataCopyWithImpl<$Res, _$WizardCeliDataImpl>
    implements _$$WizardCeliDataImplCopyWith<$Res> {
  __$$WizardCeliDataImplCopyWithImpl(
    _$WizardCeliDataImpl _value,
    $Res Function(_$WizardCeliDataImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of WizardAssetData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? individualId = null,
    Object? value = null,
    Object? annualContribution = freezed,
  }) {
    return _then(
      _$WizardCeliDataImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        individualId: null == individualId
            ? _value.individualId
            : individualId // ignore: cast_nullable_to_non_nullable
                  as String,
        value: null == value
            ? _value.value
            : value // ignore: cast_nullable_to_non_nullable
                  as double,
        annualContribution: freezed == annualContribution
            ? _value.annualContribution
            : annualContribution // ignore: cast_nullable_to_non_nullable
                  as double?,
      ),
    );
  }
}

/// @nodoc

class _$WizardCeliDataImpl implements WizardCeliData {
  const _$WizardCeliDataImpl({
    required this.id,
    required this.individualId,
    required this.value,
    this.annualContribution,
  });

  @override
  final String id;
  @override
  final String individualId;
  @override
  final double value;
  @override
  final double? annualContribution;

  @override
  String toString() {
    return 'WizardAssetData.celi(id: $id, individualId: $individualId, value: $value, annualContribution: $annualContribution)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WizardCeliDataImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.individualId, individualId) ||
                other.individualId == individualId) &&
            (identical(other.value, value) || other.value == value) &&
            (identical(other.annualContribution, annualContribution) ||
                other.annualContribution == annualContribution));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, id, individualId, value, annualContribution);

  /// Create a copy of WizardAssetData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WizardCeliDataImplCopyWith<_$WizardCeliDataImpl> get copyWith =>
      __$$WizardCeliDataImplCopyWithImpl<_$WizardCeliDataImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String id, double value) realEstate,
    required TResult Function(
      String id,
      String individualId,
      double value,
      double? annualContribution,
    )
    rrsp,
    required TResult Function(
      String id,
      String individualId,
      double value,
      double? annualContribution,
    )
    celi,
    required TResult Function(String id, String individualId, double value) cri,
    required TResult Function(String id, String individualId, double value)
    cash,
  }) {
    return celi(id, individualId, value, annualContribution);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String id, double value)? realEstate,
    TResult? Function(
      String id,
      String individualId,
      double value,
      double? annualContribution,
    )?
    rrsp,
    TResult? Function(
      String id,
      String individualId,
      double value,
      double? annualContribution,
    )?
    celi,
    TResult? Function(String id, String individualId, double value)? cri,
    TResult? Function(String id, String individualId, double value)? cash,
  }) {
    return celi?.call(id, individualId, value, annualContribution);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String id, double value)? realEstate,
    TResult Function(
      String id,
      String individualId,
      double value,
      double? annualContribution,
    )?
    rrsp,
    TResult Function(
      String id,
      String individualId,
      double value,
      double? annualContribution,
    )?
    celi,
    TResult Function(String id, String individualId, double value)? cri,
    TResult Function(String id, String individualId, double value)? cash,
    required TResult orElse(),
  }) {
    if (celi != null) {
      return celi(id, individualId, value, annualContribution);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(WizardRealEstateData value) realEstate,
    required TResult Function(WizardRrspData value) rrsp,
    required TResult Function(WizardCeliData value) celi,
    required TResult Function(WizardCriData value) cri,
    required TResult Function(WizardCashData value) cash,
  }) {
    return celi(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(WizardRealEstateData value)? realEstate,
    TResult? Function(WizardRrspData value)? rrsp,
    TResult? Function(WizardCeliData value)? celi,
    TResult? Function(WizardCriData value)? cri,
    TResult? Function(WizardCashData value)? cash,
  }) {
    return celi?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(WizardRealEstateData value)? realEstate,
    TResult Function(WizardRrspData value)? rrsp,
    TResult Function(WizardCeliData value)? celi,
    TResult Function(WizardCriData value)? cri,
    TResult Function(WizardCashData value)? cash,
    required TResult orElse(),
  }) {
    if (celi != null) {
      return celi(this);
    }
    return orElse();
  }
}

abstract class WizardCeliData implements WizardAssetData {
  const factory WizardCeliData({
    required final String id,
    required final String individualId,
    required final double value,
    final double? annualContribution,
  }) = _$WizardCeliDataImpl;

  @override
  String get id;
  String get individualId;
  @override
  double get value;
  double? get annualContribution;

  /// Create a copy of WizardAssetData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WizardCeliDataImplCopyWith<_$WizardCeliDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$WizardCriDataImplCopyWith<$Res>
    implements $WizardAssetDataCopyWith<$Res> {
  factory _$$WizardCriDataImplCopyWith(
    _$WizardCriDataImpl value,
    $Res Function(_$WizardCriDataImpl) then,
  ) = __$$WizardCriDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String individualId, double value});
}

/// @nodoc
class __$$WizardCriDataImplCopyWithImpl<$Res>
    extends _$WizardAssetDataCopyWithImpl<$Res, _$WizardCriDataImpl>
    implements _$$WizardCriDataImplCopyWith<$Res> {
  __$$WizardCriDataImplCopyWithImpl(
    _$WizardCriDataImpl _value,
    $Res Function(_$WizardCriDataImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of WizardAssetData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? individualId = null,
    Object? value = null,
  }) {
    return _then(
      _$WizardCriDataImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        individualId: null == individualId
            ? _value.individualId
            : individualId // ignore: cast_nullable_to_non_nullable
                  as String,
        value: null == value
            ? _value.value
            : value // ignore: cast_nullable_to_non_nullable
                  as double,
      ),
    );
  }
}

/// @nodoc

class _$WizardCriDataImpl implements WizardCriData {
  const _$WizardCriDataImpl({
    required this.id,
    required this.individualId,
    required this.value,
  });

  @override
  final String id;
  @override
  final String individualId;
  @override
  final double value;

  @override
  String toString() {
    return 'WizardAssetData.cri(id: $id, individualId: $individualId, value: $value)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WizardCriDataImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.individualId, individualId) ||
                other.individualId == individualId) &&
            (identical(other.value, value) || other.value == value));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, individualId, value);

  /// Create a copy of WizardAssetData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WizardCriDataImplCopyWith<_$WizardCriDataImpl> get copyWith =>
      __$$WizardCriDataImplCopyWithImpl<_$WizardCriDataImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String id, double value) realEstate,
    required TResult Function(
      String id,
      String individualId,
      double value,
      double? annualContribution,
    )
    rrsp,
    required TResult Function(
      String id,
      String individualId,
      double value,
      double? annualContribution,
    )
    celi,
    required TResult Function(String id, String individualId, double value) cri,
    required TResult Function(String id, String individualId, double value)
    cash,
  }) {
    return cri(id, individualId, value);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String id, double value)? realEstate,
    TResult? Function(
      String id,
      String individualId,
      double value,
      double? annualContribution,
    )?
    rrsp,
    TResult? Function(
      String id,
      String individualId,
      double value,
      double? annualContribution,
    )?
    celi,
    TResult? Function(String id, String individualId, double value)? cri,
    TResult? Function(String id, String individualId, double value)? cash,
  }) {
    return cri?.call(id, individualId, value);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String id, double value)? realEstate,
    TResult Function(
      String id,
      String individualId,
      double value,
      double? annualContribution,
    )?
    rrsp,
    TResult Function(
      String id,
      String individualId,
      double value,
      double? annualContribution,
    )?
    celi,
    TResult Function(String id, String individualId, double value)? cri,
    TResult Function(String id, String individualId, double value)? cash,
    required TResult orElse(),
  }) {
    if (cri != null) {
      return cri(id, individualId, value);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(WizardRealEstateData value) realEstate,
    required TResult Function(WizardRrspData value) rrsp,
    required TResult Function(WizardCeliData value) celi,
    required TResult Function(WizardCriData value) cri,
    required TResult Function(WizardCashData value) cash,
  }) {
    return cri(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(WizardRealEstateData value)? realEstate,
    TResult? Function(WizardRrspData value)? rrsp,
    TResult? Function(WizardCeliData value)? celi,
    TResult? Function(WizardCriData value)? cri,
    TResult? Function(WizardCashData value)? cash,
  }) {
    return cri?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(WizardRealEstateData value)? realEstate,
    TResult Function(WizardRrspData value)? rrsp,
    TResult Function(WizardCeliData value)? celi,
    TResult Function(WizardCriData value)? cri,
    TResult Function(WizardCashData value)? cash,
    required TResult orElse(),
  }) {
    if (cri != null) {
      return cri(this);
    }
    return orElse();
  }
}

abstract class WizardCriData implements WizardAssetData {
  const factory WizardCriData({
    required final String id,
    required final String individualId,
    required final double value,
  }) = _$WizardCriDataImpl;

  @override
  String get id;
  String get individualId;
  @override
  double get value;

  /// Create a copy of WizardAssetData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WizardCriDataImplCopyWith<_$WizardCriDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$WizardCashDataImplCopyWith<$Res>
    implements $WizardAssetDataCopyWith<$Res> {
  factory _$$WizardCashDataImplCopyWith(
    _$WizardCashDataImpl value,
    $Res Function(_$WizardCashDataImpl) then,
  ) = __$$WizardCashDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String individualId, double value});
}

/// @nodoc
class __$$WizardCashDataImplCopyWithImpl<$Res>
    extends _$WizardAssetDataCopyWithImpl<$Res, _$WizardCashDataImpl>
    implements _$$WizardCashDataImplCopyWith<$Res> {
  __$$WizardCashDataImplCopyWithImpl(
    _$WizardCashDataImpl _value,
    $Res Function(_$WizardCashDataImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of WizardAssetData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? individualId = null,
    Object? value = null,
  }) {
    return _then(
      _$WizardCashDataImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        individualId: null == individualId
            ? _value.individualId
            : individualId // ignore: cast_nullable_to_non_nullable
                  as String,
        value: null == value
            ? _value.value
            : value // ignore: cast_nullable_to_non_nullable
                  as double,
      ),
    );
  }
}

/// @nodoc

class _$WizardCashDataImpl implements WizardCashData {
  const _$WizardCashDataImpl({
    required this.id,
    required this.individualId,
    required this.value,
  });

  @override
  final String id;
  @override
  final String individualId;
  @override
  final double value;

  @override
  String toString() {
    return 'WizardAssetData.cash(id: $id, individualId: $individualId, value: $value)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WizardCashDataImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.individualId, individualId) ||
                other.individualId == individualId) &&
            (identical(other.value, value) || other.value == value));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, individualId, value);

  /// Create a copy of WizardAssetData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WizardCashDataImplCopyWith<_$WizardCashDataImpl> get copyWith =>
      __$$WizardCashDataImplCopyWithImpl<_$WizardCashDataImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String id, double value) realEstate,
    required TResult Function(
      String id,
      String individualId,
      double value,
      double? annualContribution,
    )
    rrsp,
    required TResult Function(
      String id,
      String individualId,
      double value,
      double? annualContribution,
    )
    celi,
    required TResult Function(String id, String individualId, double value) cri,
    required TResult Function(String id, String individualId, double value)
    cash,
  }) {
    return cash(id, individualId, value);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String id, double value)? realEstate,
    TResult? Function(
      String id,
      String individualId,
      double value,
      double? annualContribution,
    )?
    rrsp,
    TResult? Function(
      String id,
      String individualId,
      double value,
      double? annualContribution,
    )?
    celi,
    TResult? Function(String id, String individualId, double value)? cri,
    TResult? Function(String id, String individualId, double value)? cash,
  }) {
    return cash?.call(id, individualId, value);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String id, double value)? realEstate,
    TResult Function(
      String id,
      String individualId,
      double value,
      double? annualContribution,
    )?
    rrsp,
    TResult Function(
      String id,
      String individualId,
      double value,
      double? annualContribution,
    )?
    celi,
    TResult Function(String id, String individualId, double value)? cri,
    TResult Function(String id, String individualId, double value)? cash,
    required TResult orElse(),
  }) {
    if (cash != null) {
      return cash(id, individualId, value);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(WizardRealEstateData value) realEstate,
    required TResult Function(WizardRrspData value) rrsp,
    required TResult Function(WizardCeliData value) celi,
    required TResult Function(WizardCriData value) cri,
    required TResult Function(WizardCashData value) cash,
  }) {
    return cash(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(WizardRealEstateData value)? realEstate,
    TResult? Function(WizardRrspData value)? rrsp,
    TResult? Function(WizardCeliData value)? celi,
    TResult? Function(WizardCriData value)? cri,
    TResult? Function(WizardCashData value)? cash,
  }) {
    return cash?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(WizardRealEstateData value)? realEstate,
    TResult Function(WizardRrspData value)? rrsp,
    TResult Function(WizardCeliData value)? celi,
    TResult Function(WizardCriData value)? cri,
    TResult Function(WizardCashData value)? cash,
    required TResult orElse(),
  }) {
    if (cash != null) {
      return cash(this);
    }
    return orElse();
  }
}

abstract class WizardCashData implements WizardAssetData {
  const factory WizardCashData({
    required final String id,
    required final String individualId,
    required final double value,
  }) = _$WizardCashDataImpl;

  @override
  String get id;
  String get individualId;
  @override
  double get value;

  /// Create a copy of WizardAssetData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WizardCashDataImplCopyWith<_$WizardCashDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$WizardExpensesData {
  double get housingAmount => throw _privateConstructorUsedError;
  double get transportAmount => throw _privateConstructorUsedError;
  double get dailyLivingAmount => throw _privateConstructorUsedError;
  double get recreationAmount => throw _privateConstructorUsedError;
  double get healthAmount => throw _privateConstructorUsedError;
  double get familyAmount =>
      throw _privateConstructorUsedError; // Timing: when expenses start
  ExpenseStartTiming get startTiming => throw _privateConstructorUsedError;
  int? get customStartYear => throw _privateConstructorUsedError;

  /// Create a copy of WizardExpensesData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WizardExpensesDataCopyWith<WizardExpensesData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WizardExpensesDataCopyWith<$Res> {
  factory $WizardExpensesDataCopyWith(
    WizardExpensesData value,
    $Res Function(WizardExpensesData) then,
  ) = _$WizardExpensesDataCopyWithImpl<$Res, WizardExpensesData>;
  @useResult
  $Res call({
    double housingAmount,
    double transportAmount,
    double dailyLivingAmount,
    double recreationAmount,
    double healthAmount,
    double familyAmount,
    ExpenseStartTiming startTiming,
    int? customStartYear,
  });
}

/// @nodoc
class _$WizardExpensesDataCopyWithImpl<$Res, $Val extends WizardExpensesData>
    implements $WizardExpensesDataCopyWith<$Res> {
  _$WizardExpensesDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WizardExpensesData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? housingAmount = null,
    Object? transportAmount = null,
    Object? dailyLivingAmount = null,
    Object? recreationAmount = null,
    Object? healthAmount = null,
    Object? familyAmount = null,
    Object? startTiming = null,
    Object? customStartYear = freezed,
  }) {
    return _then(
      _value.copyWith(
            housingAmount: null == housingAmount
                ? _value.housingAmount
                : housingAmount // ignore: cast_nullable_to_non_nullable
                      as double,
            transportAmount: null == transportAmount
                ? _value.transportAmount
                : transportAmount // ignore: cast_nullable_to_non_nullable
                      as double,
            dailyLivingAmount: null == dailyLivingAmount
                ? _value.dailyLivingAmount
                : dailyLivingAmount // ignore: cast_nullable_to_non_nullable
                      as double,
            recreationAmount: null == recreationAmount
                ? _value.recreationAmount
                : recreationAmount // ignore: cast_nullable_to_non_nullable
                      as double,
            healthAmount: null == healthAmount
                ? _value.healthAmount
                : healthAmount // ignore: cast_nullable_to_non_nullable
                      as double,
            familyAmount: null == familyAmount
                ? _value.familyAmount
                : familyAmount // ignore: cast_nullable_to_non_nullable
                      as double,
            startTiming: null == startTiming
                ? _value.startTiming
                : startTiming // ignore: cast_nullable_to_non_nullable
                      as ExpenseStartTiming,
            customStartYear: freezed == customStartYear
                ? _value.customStartYear
                : customStartYear // ignore: cast_nullable_to_non_nullable
                      as int?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$WizardExpensesDataImplCopyWith<$Res>
    implements $WizardExpensesDataCopyWith<$Res> {
  factory _$$WizardExpensesDataImplCopyWith(
    _$WizardExpensesDataImpl value,
    $Res Function(_$WizardExpensesDataImpl) then,
  ) = __$$WizardExpensesDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    double housingAmount,
    double transportAmount,
    double dailyLivingAmount,
    double recreationAmount,
    double healthAmount,
    double familyAmount,
    ExpenseStartTiming startTiming,
    int? customStartYear,
  });
}

/// @nodoc
class __$$WizardExpensesDataImplCopyWithImpl<$Res>
    extends _$WizardExpensesDataCopyWithImpl<$Res, _$WizardExpensesDataImpl>
    implements _$$WizardExpensesDataImplCopyWith<$Res> {
  __$$WizardExpensesDataImplCopyWithImpl(
    _$WizardExpensesDataImpl _value,
    $Res Function(_$WizardExpensesDataImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of WizardExpensesData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? housingAmount = null,
    Object? transportAmount = null,
    Object? dailyLivingAmount = null,
    Object? recreationAmount = null,
    Object? healthAmount = null,
    Object? familyAmount = null,
    Object? startTiming = null,
    Object? customStartYear = freezed,
  }) {
    return _then(
      _$WizardExpensesDataImpl(
        housingAmount: null == housingAmount
            ? _value.housingAmount
            : housingAmount // ignore: cast_nullable_to_non_nullable
                  as double,
        transportAmount: null == transportAmount
            ? _value.transportAmount
            : transportAmount // ignore: cast_nullable_to_non_nullable
                  as double,
        dailyLivingAmount: null == dailyLivingAmount
            ? _value.dailyLivingAmount
            : dailyLivingAmount // ignore: cast_nullable_to_non_nullable
                  as double,
        recreationAmount: null == recreationAmount
            ? _value.recreationAmount
            : recreationAmount // ignore: cast_nullable_to_non_nullable
                  as double,
        healthAmount: null == healthAmount
            ? _value.healthAmount
            : healthAmount // ignore: cast_nullable_to_non_nullable
                  as double,
        familyAmount: null == familyAmount
            ? _value.familyAmount
            : familyAmount // ignore: cast_nullable_to_non_nullable
                  as double,
        startTiming: null == startTiming
            ? _value.startTiming
            : startTiming // ignore: cast_nullable_to_non_nullable
                  as ExpenseStartTiming,
        customStartYear: freezed == customStartYear
            ? _value.customStartYear
            : customStartYear // ignore: cast_nullable_to_non_nullable
                  as int?,
      ),
    );
  }
}

/// @nodoc

class _$WizardExpensesDataImpl implements _WizardExpensesData {
  const _$WizardExpensesDataImpl({
    this.housingAmount = 0.0,
    this.transportAmount = 0.0,
    this.dailyLivingAmount = 0.0,
    this.recreationAmount = 0.0,
    this.healthAmount = 0.0,
    this.familyAmount = 0.0,
    this.startTiming = ExpenseStartTiming.now,
    this.customStartYear,
  });

  @override
  @JsonKey()
  final double housingAmount;
  @override
  @JsonKey()
  final double transportAmount;
  @override
  @JsonKey()
  final double dailyLivingAmount;
  @override
  @JsonKey()
  final double recreationAmount;
  @override
  @JsonKey()
  final double healthAmount;
  @override
  @JsonKey()
  final double familyAmount;
  // Timing: when expenses start
  @override
  @JsonKey()
  final ExpenseStartTiming startTiming;
  @override
  final int? customStartYear;

  @override
  String toString() {
    return 'WizardExpensesData(housingAmount: $housingAmount, transportAmount: $transportAmount, dailyLivingAmount: $dailyLivingAmount, recreationAmount: $recreationAmount, healthAmount: $healthAmount, familyAmount: $familyAmount, startTiming: $startTiming, customStartYear: $customStartYear)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WizardExpensesDataImpl &&
            (identical(other.housingAmount, housingAmount) ||
                other.housingAmount == housingAmount) &&
            (identical(other.transportAmount, transportAmount) ||
                other.transportAmount == transportAmount) &&
            (identical(other.dailyLivingAmount, dailyLivingAmount) ||
                other.dailyLivingAmount == dailyLivingAmount) &&
            (identical(other.recreationAmount, recreationAmount) ||
                other.recreationAmount == recreationAmount) &&
            (identical(other.healthAmount, healthAmount) ||
                other.healthAmount == healthAmount) &&
            (identical(other.familyAmount, familyAmount) ||
                other.familyAmount == familyAmount) &&
            (identical(other.startTiming, startTiming) ||
                other.startTiming == startTiming) &&
            (identical(other.customStartYear, customStartYear) ||
                other.customStartYear == customStartYear));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    housingAmount,
    transportAmount,
    dailyLivingAmount,
    recreationAmount,
    healthAmount,
    familyAmount,
    startTiming,
    customStartYear,
  );

  /// Create a copy of WizardExpensesData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WizardExpensesDataImplCopyWith<_$WizardExpensesDataImpl> get copyWith =>
      __$$WizardExpensesDataImplCopyWithImpl<_$WizardExpensesDataImpl>(
        this,
        _$identity,
      );
}

abstract class _WizardExpensesData implements WizardExpensesData {
  const factory _WizardExpensesData({
    final double housingAmount,
    final double transportAmount,
    final double dailyLivingAmount,
    final double recreationAmount,
    final double healthAmount,
    final double familyAmount,
    final ExpenseStartTiming startTiming,
    final int? customStartYear,
  }) = _$WizardExpensesDataImpl;

  @override
  double get housingAmount;
  @override
  double get transportAmount;
  @override
  double get dailyLivingAmount;
  @override
  double get recreationAmount;
  @override
  double get healthAmount;
  @override
  double get familyAmount; // Timing: when expenses start
  @override
  ExpenseStartTiming get startTiming;
  @override
  int? get customStartYear;

  /// Create a copy of WizardExpensesData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WizardExpensesDataImplCopyWith<_$WizardExpensesDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$WizardScenariosData {
  bool get createBase =>
      throw _privateConstructorUsedError; // Always true (required)
  bool get createOptimistic => throw _privateConstructorUsedError;
  bool get createPessimistic => throw _privateConstructorUsedError;
  bool get createEarlyRetirement => throw _privateConstructorUsedError;
  bool get createLateRetirement => throw _privateConstructorUsedError;

  /// Create a copy of WizardScenariosData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WizardScenariosDataCopyWith<WizardScenariosData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WizardScenariosDataCopyWith<$Res> {
  factory $WizardScenariosDataCopyWith(
    WizardScenariosData value,
    $Res Function(WizardScenariosData) then,
  ) = _$WizardScenariosDataCopyWithImpl<$Res, WizardScenariosData>;
  @useResult
  $Res call({
    bool createBase,
    bool createOptimistic,
    bool createPessimistic,
    bool createEarlyRetirement,
    bool createLateRetirement,
  });
}

/// @nodoc
class _$WizardScenariosDataCopyWithImpl<$Res, $Val extends WizardScenariosData>
    implements $WizardScenariosDataCopyWith<$Res> {
  _$WizardScenariosDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WizardScenariosData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? createBase = null,
    Object? createOptimistic = null,
    Object? createPessimistic = null,
    Object? createEarlyRetirement = null,
    Object? createLateRetirement = null,
  }) {
    return _then(
      _value.copyWith(
            createBase: null == createBase
                ? _value.createBase
                : createBase // ignore: cast_nullable_to_non_nullable
                      as bool,
            createOptimistic: null == createOptimistic
                ? _value.createOptimistic
                : createOptimistic // ignore: cast_nullable_to_non_nullable
                      as bool,
            createPessimistic: null == createPessimistic
                ? _value.createPessimistic
                : createPessimistic // ignore: cast_nullable_to_non_nullable
                      as bool,
            createEarlyRetirement: null == createEarlyRetirement
                ? _value.createEarlyRetirement
                : createEarlyRetirement // ignore: cast_nullable_to_non_nullable
                      as bool,
            createLateRetirement: null == createLateRetirement
                ? _value.createLateRetirement
                : createLateRetirement // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$WizardScenariosDataImplCopyWith<$Res>
    implements $WizardScenariosDataCopyWith<$Res> {
  factory _$$WizardScenariosDataImplCopyWith(
    _$WizardScenariosDataImpl value,
    $Res Function(_$WizardScenariosDataImpl) then,
  ) = __$$WizardScenariosDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    bool createBase,
    bool createOptimistic,
    bool createPessimistic,
    bool createEarlyRetirement,
    bool createLateRetirement,
  });
}

/// @nodoc
class __$$WizardScenariosDataImplCopyWithImpl<$Res>
    extends _$WizardScenariosDataCopyWithImpl<$Res, _$WizardScenariosDataImpl>
    implements _$$WizardScenariosDataImplCopyWith<$Res> {
  __$$WizardScenariosDataImplCopyWithImpl(
    _$WizardScenariosDataImpl _value,
    $Res Function(_$WizardScenariosDataImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of WizardScenariosData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? createBase = null,
    Object? createOptimistic = null,
    Object? createPessimistic = null,
    Object? createEarlyRetirement = null,
    Object? createLateRetirement = null,
  }) {
    return _then(
      _$WizardScenariosDataImpl(
        createBase: null == createBase
            ? _value.createBase
            : createBase // ignore: cast_nullable_to_non_nullable
                  as bool,
        createOptimistic: null == createOptimistic
            ? _value.createOptimistic
            : createOptimistic // ignore: cast_nullable_to_non_nullable
                  as bool,
        createPessimistic: null == createPessimistic
            ? _value.createPessimistic
            : createPessimistic // ignore: cast_nullable_to_non_nullable
                  as bool,
        createEarlyRetirement: null == createEarlyRetirement
            ? _value.createEarlyRetirement
            : createEarlyRetirement // ignore: cast_nullable_to_non_nullable
                  as bool,
        createLateRetirement: null == createLateRetirement
            ? _value.createLateRetirement
            : createLateRetirement // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc

class _$WizardScenariosDataImpl implements _WizardScenariosData {
  const _$WizardScenariosDataImpl({
    this.createBase = true,
    this.createOptimistic = false,
    this.createPessimistic = false,
    this.createEarlyRetirement = false,
    this.createLateRetirement = false,
  });

  @override
  @JsonKey()
  final bool createBase;
  // Always true (required)
  @override
  @JsonKey()
  final bool createOptimistic;
  @override
  @JsonKey()
  final bool createPessimistic;
  @override
  @JsonKey()
  final bool createEarlyRetirement;
  @override
  @JsonKey()
  final bool createLateRetirement;

  @override
  String toString() {
    return 'WizardScenariosData(createBase: $createBase, createOptimistic: $createOptimistic, createPessimistic: $createPessimistic, createEarlyRetirement: $createEarlyRetirement, createLateRetirement: $createLateRetirement)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WizardScenariosDataImpl &&
            (identical(other.createBase, createBase) ||
                other.createBase == createBase) &&
            (identical(other.createOptimistic, createOptimistic) ||
                other.createOptimistic == createOptimistic) &&
            (identical(other.createPessimistic, createPessimistic) ||
                other.createPessimistic == createPessimistic) &&
            (identical(other.createEarlyRetirement, createEarlyRetirement) ||
                other.createEarlyRetirement == createEarlyRetirement) &&
            (identical(other.createLateRetirement, createLateRetirement) ||
                other.createLateRetirement == createLateRetirement));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    createBase,
    createOptimistic,
    createPessimistic,
    createEarlyRetirement,
    createLateRetirement,
  );

  /// Create a copy of WizardScenariosData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WizardScenariosDataImplCopyWith<_$WizardScenariosDataImpl> get copyWith =>
      __$$WizardScenariosDataImplCopyWithImpl<_$WizardScenariosDataImpl>(
        this,
        _$identity,
      );
}

abstract class _WizardScenariosData implements WizardScenariosData {
  const factory _WizardScenariosData({
    final bool createBase,
    final bool createOptimistic,
    final bool createPessimistic,
    final bool createEarlyRetirement,
    final bool createLateRetirement,
  }) = _$WizardScenariosDataImpl;

  @override
  bool get createBase; // Always true (required)
  @override
  bool get createOptimistic;
  @override
  bool get createPessimistic;
  @override
  bool get createEarlyRetirement;
  @override
  bool get createLateRetirement;

  /// Create a copy of WizardScenariosData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WizardScenariosDataImplCopyWith<_$WizardScenariosDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
