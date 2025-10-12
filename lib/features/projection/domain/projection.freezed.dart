// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'projection.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Projection _$ProjectionFromJson(Map<String, dynamic> json) {
  return _Projection.fromJson(json);
}

/// @nodoc
mixin _$Projection {
  /// ID of the scenario this projection is for
  String get scenarioId => throw _privateConstructorUsedError;

  /// ID of the project this projection belongs to
  String get projectId => throw _privateConstructorUsedError;

  /// Start year of the projection
  int get startYear => throw _privateConstructorUsedError;

  /// End year of the projection
  int get endYear => throw _privateConstructorUsedError;

  /// Whether projection is in current or constant dollars
  bool get useConstantDollars => throw _privateConstructorUsedError;

  /// Assumed inflation rate (as decimal, e.g., 0.02 for 2%)
  double get inflationRate => throw _privateConstructorUsedError;

  /// Yearly projections from start to end
  List<YearlyProjection> get years => throw _privateConstructorUsedError;

  /// When this projection was calculated
  DateTime get calculatedAt => throw _privateConstructorUsedError;

  /// Serializes this Projection to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Projection
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProjectionCopyWith<Projection> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProjectionCopyWith<$Res> {
  factory $ProjectionCopyWith(
    Projection value,
    $Res Function(Projection) then,
  ) = _$ProjectionCopyWithImpl<$Res, Projection>;
  @useResult
  $Res call({
    String scenarioId,
    String projectId,
    int startYear,
    int endYear,
    bool useConstantDollars,
    double inflationRate,
    List<YearlyProjection> years,
    DateTime calculatedAt,
  });
}

/// @nodoc
class _$ProjectionCopyWithImpl<$Res, $Val extends Projection>
    implements $ProjectionCopyWith<$Res> {
  _$ProjectionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Projection
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? scenarioId = null,
    Object? projectId = null,
    Object? startYear = null,
    Object? endYear = null,
    Object? useConstantDollars = null,
    Object? inflationRate = null,
    Object? years = null,
    Object? calculatedAt = null,
  }) {
    return _then(
      _value.copyWith(
            scenarioId: null == scenarioId
                ? _value.scenarioId
                : scenarioId // ignore: cast_nullable_to_non_nullable
                      as String,
            projectId: null == projectId
                ? _value.projectId
                : projectId // ignore: cast_nullable_to_non_nullable
                      as String,
            startYear: null == startYear
                ? _value.startYear
                : startYear // ignore: cast_nullable_to_non_nullable
                      as int,
            endYear: null == endYear
                ? _value.endYear
                : endYear // ignore: cast_nullable_to_non_nullable
                      as int,
            useConstantDollars: null == useConstantDollars
                ? _value.useConstantDollars
                : useConstantDollars // ignore: cast_nullable_to_non_nullable
                      as bool,
            inflationRate: null == inflationRate
                ? _value.inflationRate
                : inflationRate // ignore: cast_nullable_to_non_nullable
                      as double,
            years: null == years
                ? _value.years
                : years // ignore: cast_nullable_to_non_nullable
                      as List<YearlyProjection>,
            calculatedAt: null == calculatedAt
                ? _value.calculatedAt
                : calculatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ProjectionImplCopyWith<$Res>
    implements $ProjectionCopyWith<$Res> {
  factory _$$ProjectionImplCopyWith(
    _$ProjectionImpl value,
    $Res Function(_$ProjectionImpl) then,
  ) = __$$ProjectionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String scenarioId,
    String projectId,
    int startYear,
    int endYear,
    bool useConstantDollars,
    double inflationRate,
    List<YearlyProjection> years,
    DateTime calculatedAt,
  });
}

/// @nodoc
class __$$ProjectionImplCopyWithImpl<$Res>
    extends _$ProjectionCopyWithImpl<$Res, _$ProjectionImpl>
    implements _$$ProjectionImplCopyWith<$Res> {
  __$$ProjectionImplCopyWithImpl(
    _$ProjectionImpl _value,
    $Res Function(_$ProjectionImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Projection
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? scenarioId = null,
    Object? projectId = null,
    Object? startYear = null,
    Object? endYear = null,
    Object? useConstantDollars = null,
    Object? inflationRate = null,
    Object? years = null,
    Object? calculatedAt = null,
  }) {
    return _then(
      _$ProjectionImpl(
        scenarioId: null == scenarioId
            ? _value.scenarioId
            : scenarioId // ignore: cast_nullable_to_non_nullable
                  as String,
        projectId: null == projectId
            ? _value.projectId
            : projectId // ignore: cast_nullable_to_non_nullable
                  as String,
        startYear: null == startYear
            ? _value.startYear
            : startYear // ignore: cast_nullable_to_non_nullable
                  as int,
        endYear: null == endYear
            ? _value.endYear
            : endYear // ignore: cast_nullable_to_non_nullable
                  as int,
        useConstantDollars: null == useConstantDollars
            ? _value.useConstantDollars
            : useConstantDollars // ignore: cast_nullable_to_non_nullable
                  as bool,
        inflationRate: null == inflationRate
            ? _value.inflationRate
            : inflationRate // ignore: cast_nullable_to_non_nullable
                  as double,
        years: null == years
            ? _value._years
            : years // ignore: cast_nullable_to_non_nullable
                  as List<YearlyProjection>,
        calculatedAt: null == calculatedAt
            ? _value.calculatedAt
            : calculatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ProjectionImpl implements _Projection {
  const _$ProjectionImpl({
    required this.scenarioId,
    required this.projectId,
    required this.startYear,
    required this.endYear,
    required this.useConstantDollars,
    required this.inflationRate,
    required final List<YearlyProjection> years,
    required this.calculatedAt,
  }) : _years = years;

  factory _$ProjectionImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProjectionImplFromJson(json);

  /// ID of the scenario this projection is for
  @override
  final String scenarioId;

  /// ID of the project this projection belongs to
  @override
  final String projectId;

  /// Start year of the projection
  @override
  final int startYear;

  /// End year of the projection
  @override
  final int endYear;

  /// Whether projection is in current or constant dollars
  @override
  final bool useConstantDollars;

  /// Assumed inflation rate (as decimal, e.g., 0.02 for 2%)
  @override
  final double inflationRate;

  /// Yearly projections from start to end
  final List<YearlyProjection> _years;

  /// Yearly projections from start to end
  @override
  List<YearlyProjection> get years {
    if (_years is EqualUnmodifiableListView) return _years;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_years);
  }

  /// When this projection was calculated
  @override
  final DateTime calculatedAt;

  @override
  String toString() {
    return 'Projection(scenarioId: $scenarioId, projectId: $projectId, startYear: $startYear, endYear: $endYear, useConstantDollars: $useConstantDollars, inflationRate: $inflationRate, years: $years, calculatedAt: $calculatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProjectionImpl &&
            (identical(other.scenarioId, scenarioId) ||
                other.scenarioId == scenarioId) &&
            (identical(other.projectId, projectId) ||
                other.projectId == projectId) &&
            (identical(other.startYear, startYear) ||
                other.startYear == startYear) &&
            (identical(other.endYear, endYear) || other.endYear == endYear) &&
            (identical(other.useConstantDollars, useConstantDollars) ||
                other.useConstantDollars == useConstantDollars) &&
            (identical(other.inflationRate, inflationRate) ||
                other.inflationRate == inflationRate) &&
            const DeepCollectionEquality().equals(other._years, _years) &&
            (identical(other.calculatedAt, calculatedAt) ||
                other.calculatedAt == calculatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    scenarioId,
    projectId,
    startYear,
    endYear,
    useConstantDollars,
    inflationRate,
    const DeepCollectionEquality().hash(_years),
    calculatedAt,
  );

  /// Create a copy of Projection
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProjectionImplCopyWith<_$ProjectionImpl> get copyWith =>
      __$$ProjectionImplCopyWithImpl<_$ProjectionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProjectionImplToJson(this);
  }
}

abstract class _Projection implements Projection {
  const factory _Projection({
    required final String scenarioId,
    required final String projectId,
    required final int startYear,
    required final int endYear,
    required final bool useConstantDollars,
    required final double inflationRate,
    required final List<YearlyProjection> years,
    required final DateTime calculatedAt,
  }) = _$ProjectionImpl;

  factory _Projection.fromJson(Map<String, dynamic> json) =
      _$ProjectionImpl.fromJson;

  /// ID of the scenario this projection is for
  @override
  String get scenarioId;

  /// ID of the project this projection belongs to
  @override
  String get projectId;

  /// Start year of the projection
  @override
  int get startYear;

  /// End year of the projection
  @override
  int get endYear;

  /// Whether projection is in current or constant dollars
  @override
  bool get useConstantDollars;

  /// Assumed inflation rate (as decimal, e.g., 0.02 for 2%)
  @override
  double get inflationRate;

  /// Yearly projections from start to end
  @override
  List<YearlyProjection> get years;

  /// When this projection was calculated
  @override
  DateTime get calculatedAt;

  /// Create a copy of Projection
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProjectionImplCopyWith<_$ProjectionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
