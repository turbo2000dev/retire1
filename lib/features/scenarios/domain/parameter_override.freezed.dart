// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'parameter_override.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ParameterOverride _$ParameterOverrideFromJson(Map<String, dynamic> json) {
  switch (json['runtimeType']) {
    case 'assetValue':
      return AssetValueOverride.fromJson(json);
    case 'eventTiming':
      return EventTimingOverride.fromJson(json);
    case 'expenseAmount':
      return ExpenseAmountOverride.fromJson(json);
    case 'expenseTiming':
      return ExpenseTimingOverride.fromJson(json);

    default:
      throw CheckedFromJsonException(
        json,
        'runtimeType',
        'ParameterOverride',
        'Invalid union type "${json['runtimeType']}"!',
      );
  }
}

/// @nodoc
mixin _$ParameterOverride {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String assetId, double value) assetValue,
    required TResult Function(String eventId, int yearsFromStart) eventTiming,
    required TResult Function(
      String expenseId,
      double? overrideAmount,
      double? amountMultiplier,
    )
    expenseAmount,
    required TResult Function(
      String expenseId,
      EventTiming? overrideStartTiming,
      EventTiming? overrideEndTiming,
    )
    expenseTiming,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String assetId, double value)? assetValue,
    TResult? Function(String eventId, int yearsFromStart)? eventTiming,
    TResult? Function(
      String expenseId,
      double? overrideAmount,
      double? amountMultiplier,
    )?
    expenseAmount,
    TResult? Function(
      String expenseId,
      EventTiming? overrideStartTiming,
      EventTiming? overrideEndTiming,
    )?
    expenseTiming,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String assetId, double value)? assetValue,
    TResult Function(String eventId, int yearsFromStart)? eventTiming,
    TResult Function(
      String expenseId,
      double? overrideAmount,
      double? amountMultiplier,
    )?
    expenseAmount,
    TResult Function(
      String expenseId,
      EventTiming? overrideStartTiming,
      EventTiming? overrideEndTiming,
    )?
    expenseTiming,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AssetValueOverride value) assetValue,
    required TResult Function(EventTimingOverride value) eventTiming,
    required TResult Function(ExpenseAmountOverride value) expenseAmount,
    required TResult Function(ExpenseTimingOverride value) expenseTiming,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AssetValueOverride value)? assetValue,
    TResult? Function(EventTimingOverride value)? eventTiming,
    TResult? Function(ExpenseAmountOverride value)? expenseAmount,
    TResult? Function(ExpenseTimingOverride value)? expenseTiming,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AssetValueOverride value)? assetValue,
    TResult Function(EventTimingOverride value)? eventTiming,
    TResult Function(ExpenseAmountOverride value)? expenseAmount,
    TResult Function(ExpenseTimingOverride value)? expenseTiming,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;

  /// Serializes this ParameterOverride to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ParameterOverrideCopyWith<$Res> {
  factory $ParameterOverrideCopyWith(
    ParameterOverride value,
    $Res Function(ParameterOverride) then,
  ) = _$ParameterOverrideCopyWithImpl<$Res, ParameterOverride>;
}

/// @nodoc
class _$ParameterOverrideCopyWithImpl<$Res, $Val extends ParameterOverride>
    implements $ParameterOverrideCopyWith<$Res> {
  _$ParameterOverrideCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ParameterOverride
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$AssetValueOverrideImplCopyWith<$Res> {
  factory _$$AssetValueOverrideImplCopyWith(
    _$AssetValueOverrideImpl value,
    $Res Function(_$AssetValueOverrideImpl) then,
  ) = __$$AssetValueOverrideImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String assetId, double value});
}

/// @nodoc
class __$$AssetValueOverrideImplCopyWithImpl<$Res>
    extends _$ParameterOverrideCopyWithImpl<$Res, _$AssetValueOverrideImpl>
    implements _$$AssetValueOverrideImplCopyWith<$Res> {
  __$$AssetValueOverrideImplCopyWithImpl(
    _$AssetValueOverrideImpl _value,
    $Res Function(_$AssetValueOverrideImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ParameterOverride
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? assetId = null, Object? value = null}) {
    return _then(
      _$AssetValueOverrideImpl(
        assetId: null == assetId
            ? _value.assetId
            : assetId // ignore: cast_nullable_to_non_nullable
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
@JsonSerializable()
class _$AssetValueOverrideImpl implements AssetValueOverride {
  const _$AssetValueOverrideImpl({
    required this.assetId,
    required this.value,
    final String? $type,
  }) : $type = $type ?? 'assetValue';

  factory _$AssetValueOverrideImpl.fromJson(Map<String, dynamic> json) =>
      _$$AssetValueOverrideImplFromJson(json);

  @override
  final String assetId;
  @override
  final double value;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'ParameterOverride.assetValue(assetId: $assetId, value: $value)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AssetValueOverrideImpl &&
            (identical(other.assetId, assetId) || other.assetId == assetId) &&
            (identical(other.value, value) || other.value == value));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, assetId, value);

  /// Create a copy of ParameterOverride
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AssetValueOverrideImplCopyWith<_$AssetValueOverrideImpl> get copyWith =>
      __$$AssetValueOverrideImplCopyWithImpl<_$AssetValueOverrideImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String assetId, double value) assetValue,
    required TResult Function(String eventId, int yearsFromStart) eventTiming,
    required TResult Function(
      String expenseId,
      double? overrideAmount,
      double? amountMultiplier,
    )
    expenseAmount,
    required TResult Function(
      String expenseId,
      EventTiming? overrideStartTiming,
      EventTiming? overrideEndTiming,
    )
    expenseTiming,
  }) {
    return assetValue(assetId, value);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String assetId, double value)? assetValue,
    TResult? Function(String eventId, int yearsFromStart)? eventTiming,
    TResult? Function(
      String expenseId,
      double? overrideAmount,
      double? amountMultiplier,
    )?
    expenseAmount,
    TResult? Function(
      String expenseId,
      EventTiming? overrideStartTiming,
      EventTiming? overrideEndTiming,
    )?
    expenseTiming,
  }) {
    return assetValue?.call(assetId, value);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String assetId, double value)? assetValue,
    TResult Function(String eventId, int yearsFromStart)? eventTiming,
    TResult Function(
      String expenseId,
      double? overrideAmount,
      double? amountMultiplier,
    )?
    expenseAmount,
    TResult Function(
      String expenseId,
      EventTiming? overrideStartTiming,
      EventTiming? overrideEndTiming,
    )?
    expenseTiming,
    required TResult orElse(),
  }) {
    if (assetValue != null) {
      return assetValue(assetId, value);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AssetValueOverride value) assetValue,
    required TResult Function(EventTimingOverride value) eventTiming,
    required TResult Function(ExpenseAmountOverride value) expenseAmount,
    required TResult Function(ExpenseTimingOverride value) expenseTiming,
  }) {
    return assetValue(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AssetValueOverride value)? assetValue,
    TResult? Function(EventTimingOverride value)? eventTiming,
    TResult? Function(ExpenseAmountOverride value)? expenseAmount,
    TResult? Function(ExpenseTimingOverride value)? expenseTiming,
  }) {
    return assetValue?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AssetValueOverride value)? assetValue,
    TResult Function(EventTimingOverride value)? eventTiming,
    TResult Function(ExpenseAmountOverride value)? expenseAmount,
    TResult Function(ExpenseTimingOverride value)? expenseTiming,
    required TResult orElse(),
  }) {
    if (assetValue != null) {
      return assetValue(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$AssetValueOverrideImplToJson(this);
  }
}

abstract class AssetValueOverride implements ParameterOverride {
  const factory AssetValueOverride({
    required final String assetId,
    required final double value,
  }) = _$AssetValueOverrideImpl;

  factory AssetValueOverride.fromJson(Map<String, dynamic> json) =
      _$AssetValueOverrideImpl.fromJson;

  String get assetId;
  double get value;

  /// Create a copy of ParameterOverride
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AssetValueOverrideImplCopyWith<_$AssetValueOverrideImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$EventTimingOverrideImplCopyWith<$Res> {
  factory _$$EventTimingOverrideImplCopyWith(
    _$EventTimingOverrideImpl value,
    $Res Function(_$EventTimingOverrideImpl) then,
  ) = __$$EventTimingOverrideImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String eventId, int yearsFromStart});
}

/// @nodoc
class __$$EventTimingOverrideImplCopyWithImpl<$Res>
    extends _$ParameterOverrideCopyWithImpl<$Res, _$EventTimingOverrideImpl>
    implements _$$EventTimingOverrideImplCopyWith<$Res> {
  __$$EventTimingOverrideImplCopyWithImpl(
    _$EventTimingOverrideImpl _value,
    $Res Function(_$EventTimingOverrideImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ParameterOverride
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? eventId = null, Object? yearsFromStart = null}) {
    return _then(
      _$EventTimingOverrideImpl(
        eventId: null == eventId
            ? _value.eventId
            : eventId // ignore: cast_nullable_to_non_nullable
                  as String,
        yearsFromStart: null == yearsFromStart
            ? _value.yearsFromStart
            : yearsFromStart // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$EventTimingOverrideImpl implements EventTimingOverride {
  const _$EventTimingOverrideImpl({
    required this.eventId,
    required this.yearsFromStart,
    final String? $type,
  }) : $type = $type ?? 'eventTiming';

  factory _$EventTimingOverrideImpl.fromJson(Map<String, dynamic> json) =>
      _$$EventTimingOverrideImplFromJson(json);

  @override
  final String eventId;
  @override
  final int yearsFromStart;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'ParameterOverride.eventTiming(eventId: $eventId, yearsFromStart: $yearsFromStart)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EventTimingOverrideImpl &&
            (identical(other.eventId, eventId) || other.eventId == eventId) &&
            (identical(other.yearsFromStart, yearsFromStart) ||
                other.yearsFromStart == yearsFromStart));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, eventId, yearsFromStart);

  /// Create a copy of ParameterOverride
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$EventTimingOverrideImplCopyWith<_$EventTimingOverrideImpl> get copyWith =>
      __$$EventTimingOverrideImplCopyWithImpl<_$EventTimingOverrideImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String assetId, double value) assetValue,
    required TResult Function(String eventId, int yearsFromStart) eventTiming,
    required TResult Function(
      String expenseId,
      double? overrideAmount,
      double? amountMultiplier,
    )
    expenseAmount,
    required TResult Function(
      String expenseId,
      EventTiming? overrideStartTiming,
      EventTiming? overrideEndTiming,
    )
    expenseTiming,
  }) {
    return eventTiming(eventId, yearsFromStart);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String assetId, double value)? assetValue,
    TResult? Function(String eventId, int yearsFromStart)? eventTiming,
    TResult? Function(
      String expenseId,
      double? overrideAmount,
      double? amountMultiplier,
    )?
    expenseAmount,
    TResult? Function(
      String expenseId,
      EventTiming? overrideStartTiming,
      EventTiming? overrideEndTiming,
    )?
    expenseTiming,
  }) {
    return eventTiming?.call(eventId, yearsFromStart);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String assetId, double value)? assetValue,
    TResult Function(String eventId, int yearsFromStart)? eventTiming,
    TResult Function(
      String expenseId,
      double? overrideAmount,
      double? amountMultiplier,
    )?
    expenseAmount,
    TResult Function(
      String expenseId,
      EventTiming? overrideStartTiming,
      EventTiming? overrideEndTiming,
    )?
    expenseTiming,
    required TResult orElse(),
  }) {
    if (eventTiming != null) {
      return eventTiming(eventId, yearsFromStart);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AssetValueOverride value) assetValue,
    required TResult Function(EventTimingOverride value) eventTiming,
    required TResult Function(ExpenseAmountOverride value) expenseAmount,
    required TResult Function(ExpenseTimingOverride value) expenseTiming,
  }) {
    return eventTiming(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AssetValueOverride value)? assetValue,
    TResult? Function(EventTimingOverride value)? eventTiming,
    TResult? Function(ExpenseAmountOverride value)? expenseAmount,
    TResult? Function(ExpenseTimingOverride value)? expenseTiming,
  }) {
    return eventTiming?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AssetValueOverride value)? assetValue,
    TResult Function(EventTimingOverride value)? eventTiming,
    TResult Function(ExpenseAmountOverride value)? expenseAmount,
    TResult Function(ExpenseTimingOverride value)? expenseTiming,
    required TResult orElse(),
  }) {
    if (eventTiming != null) {
      return eventTiming(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$EventTimingOverrideImplToJson(this);
  }
}

abstract class EventTimingOverride implements ParameterOverride {
  const factory EventTimingOverride({
    required final String eventId,
    required final int yearsFromStart,
  }) = _$EventTimingOverrideImpl;

  factory EventTimingOverride.fromJson(Map<String, dynamic> json) =
      _$EventTimingOverrideImpl.fromJson;

  String get eventId;
  int get yearsFromStart;

  /// Create a copy of ParameterOverride
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EventTimingOverrideImplCopyWith<_$EventTimingOverrideImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ExpenseAmountOverrideImplCopyWith<$Res> {
  factory _$$ExpenseAmountOverrideImplCopyWith(
    _$ExpenseAmountOverrideImpl value,
    $Res Function(_$ExpenseAmountOverrideImpl) then,
  ) = __$$ExpenseAmountOverrideImplCopyWithImpl<$Res>;
  @useResult
  $Res call({
    String expenseId,
    double? overrideAmount,
    double? amountMultiplier,
  });
}

/// @nodoc
class __$$ExpenseAmountOverrideImplCopyWithImpl<$Res>
    extends _$ParameterOverrideCopyWithImpl<$Res, _$ExpenseAmountOverrideImpl>
    implements _$$ExpenseAmountOverrideImplCopyWith<$Res> {
  __$$ExpenseAmountOverrideImplCopyWithImpl(
    _$ExpenseAmountOverrideImpl _value,
    $Res Function(_$ExpenseAmountOverrideImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ParameterOverride
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? expenseId = null,
    Object? overrideAmount = freezed,
    Object? amountMultiplier = freezed,
  }) {
    return _then(
      _$ExpenseAmountOverrideImpl(
        expenseId: null == expenseId
            ? _value.expenseId
            : expenseId // ignore: cast_nullable_to_non_nullable
                  as String,
        overrideAmount: freezed == overrideAmount
            ? _value.overrideAmount
            : overrideAmount // ignore: cast_nullable_to_non_nullable
                  as double?,
        amountMultiplier: freezed == amountMultiplier
            ? _value.amountMultiplier
            : amountMultiplier // ignore: cast_nullable_to_non_nullable
                  as double?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ExpenseAmountOverrideImpl implements ExpenseAmountOverride {
  const _$ExpenseAmountOverrideImpl({
    required this.expenseId,
    this.overrideAmount,
    this.amountMultiplier,
    final String? $type,
  }) : $type = $type ?? 'expenseAmount';

  factory _$ExpenseAmountOverrideImpl.fromJson(Map<String, dynamic> json) =>
      _$$ExpenseAmountOverrideImplFromJson(json);

  @override
  final String expenseId;
  @override
  final double? overrideAmount;
  // Absolute amount (e.g., $25,000)
  @override
  final double? amountMultiplier;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'ParameterOverride.expenseAmount(expenseId: $expenseId, overrideAmount: $overrideAmount, amountMultiplier: $amountMultiplier)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExpenseAmountOverrideImpl &&
            (identical(other.expenseId, expenseId) ||
                other.expenseId == expenseId) &&
            (identical(other.overrideAmount, overrideAmount) ||
                other.overrideAmount == overrideAmount) &&
            (identical(other.amountMultiplier, amountMultiplier) ||
                other.amountMultiplier == amountMultiplier));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, expenseId, overrideAmount, amountMultiplier);

  /// Create a copy of ParameterOverride
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ExpenseAmountOverrideImplCopyWith<_$ExpenseAmountOverrideImpl>
  get copyWith =>
      __$$ExpenseAmountOverrideImplCopyWithImpl<_$ExpenseAmountOverrideImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String assetId, double value) assetValue,
    required TResult Function(String eventId, int yearsFromStart) eventTiming,
    required TResult Function(
      String expenseId,
      double? overrideAmount,
      double? amountMultiplier,
    )
    expenseAmount,
    required TResult Function(
      String expenseId,
      EventTiming? overrideStartTiming,
      EventTiming? overrideEndTiming,
    )
    expenseTiming,
  }) {
    return expenseAmount(expenseId, overrideAmount, amountMultiplier);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String assetId, double value)? assetValue,
    TResult? Function(String eventId, int yearsFromStart)? eventTiming,
    TResult? Function(
      String expenseId,
      double? overrideAmount,
      double? amountMultiplier,
    )?
    expenseAmount,
    TResult? Function(
      String expenseId,
      EventTiming? overrideStartTiming,
      EventTiming? overrideEndTiming,
    )?
    expenseTiming,
  }) {
    return expenseAmount?.call(expenseId, overrideAmount, amountMultiplier);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String assetId, double value)? assetValue,
    TResult Function(String eventId, int yearsFromStart)? eventTiming,
    TResult Function(
      String expenseId,
      double? overrideAmount,
      double? amountMultiplier,
    )?
    expenseAmount,
    TResult Function(
      String expenseId,
      EventTiming? overrideStartTiming,
      EventTiming? overrideEndTiming,
    )?
    expenseTiming,
    required TResult orElse(),
  }) {
    if (expenseAmount != null) {
      return expenseAmount(expenseId, overrideAmount, amountMultiplier);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AssetValueOverride value) assetValue,
    required TResult Function(EventTimingOverride value) eventTiming,
    required TResult Function(ExpenseAmountOverride value) expenseAmount,
    required TResult Function(ExpenseTimingOverride value) expenseTiming,
  }) {
    return expenseAmount(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AssetValueOverride value)? assetValue,
    TResult? Function(EventTimingOverride value)? eventTiming,
    TResult? Function(ExpenseAmountOverride value)? expenseAmount,
    TResult? Function(ExpenseTimingOverride value)? expenseTiming,
  }) {
    return expenseAmount?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AssetValueOverride value)? assetValue,
    TResult Function(EventTimingOverride value)? eventTiming,
    TResult Function(ExpenseAmountOverride value)? expenseAmount,
    TResult Function(ExpenseTimingOverride value)? expenseTiming,
    required TResult orElse(),
  }) {
    if (expenseAmount != null) {
      return expenseAmount(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$ExpenseAmountOverrideImplToJson(this);
  }
}

abstract class ExpenseAmountOverride implements ParameterOverride {
  const factory ExpenseAmountOverride({
    required final String expenseId,
    final double? overrideAmount,
    final double? amountMultiplier,
  }) = _$ExpenseAmountOverrideImpl;

  factory ExpenseAmountOverride.fromJson(Map<String, dynamic> json) =
      _$ExpenseAmountOverrideImpl.fromJson;

  String get expenseId;
  double? get overrideAmount; // Absolute amount (e.g., $25,000)
  double? get amountMultiplier;

  /// Create a copy of ParameterOverride
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ExpenseAmountOverrideImplCopyWith<_$ExpenseAmountOverrideImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ExpenseTimingOverrideImplCopyWith<$Res> {
  factory _$$ExpenseTimingOverrideImplCopyWith(
    _$ExpenseTimingOverrideImpl value,
    $Res Function(_$ExpenseTimingOverrideImpl) then,
  ) = __$$ExpenseTimingOverrideImplCopyWithImpl<$Res>;
  @useResult
  $Res call({
    String expenseId,
    EventTiming? overrideStartTiming,
    EventTiming? overrideEndTiming,
  });

  $EventTimingCopyWith<$Res>? get overrideStartTiming;
  $EventTimingCopyWith<$Res>? get overrideEndTiming;
}

/// @nodoc
class __$$ExpenseTimingOverrideImplCopyWithImpl<$Res>
    extends _$ParameterOverrideCopyWithImpl<$Res, _$ExpenseTimingOverrideImpl>
    implements _$$ExpenseTimingOverrideImplCopyWith<$Res> {
  __$$ExpenseTimingOverrideImplCopyWithImpl(
    _$ExpenseTimingOverrideImpl _value,
    $Res Function(_$ExpenseTimingOverrideImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ParameterOverride
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? expenseId = null,
    Object? overrideStartTiming = freezed,
    Object? overrideEndTiming = freezed,
  }) {
    return _then(
      _$ExpenseTimingOverrideImpl(
        expenseId: null == expenseId
            ? _value.expenseId
            : expenseId // ignore: cast_nullable_to_non_nullable
                  as String,
        overrideStartTiming: freezed == overrideStartTiming
            ? _value.overrideStartTiming
            : overrideStartTiming // ignore: cast_nullable_to_non_nullable
                  as EventTiming?,
        overrideEndTiming: freezed == overrideEndTiming
            ? _value.overrideEndTiming
            : overrideEndTiming // ignore: cast_nullable_to_non_nullable
                  as EventTiming?,
      ),
    );
  }

  /// Create a copy of ParameterOverride
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $EventTimingCopyWith<$Res>? get overrideStartTiming {
    if (_value.overrideStartTiming == null) {
      return null;
    }

    return $EventTimingCopyWith<$Res>(_value.overrideStartTiming!, (value) {
      return _then(_value.copyWith(overrideStartTiming: value));
    });
  }

  /// Create a copy of ParameterOverride
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $EventTimingCopyWith<$Res>? get overrideEndTiming {
    if (_value.overrideEndTiming == null) {
      return null;
    }

    return $EventTimingCopyWith<$Res>(_value.overrideEndTiming!, (value) {
      return _then(_value.copyWith(overrideEndTiming: value));
    });
  }
}

/// @nodoc
@JsonSerializable()
class _$ExpenseTimingOverrideImpl implements ExpenseTimingOverride {
  const _$ExpenseTimingOverrideImpl({
    required this.expenseId,
    this.overrideStartTiming,
    this.overrideEndTiming,
    final String? $type,
  }) : $type = $type ?? 'expenseTiming';

  factory _$ExpenseTimingOverrideImpl.fromJson(Map<String, dynamic> json) =>
      _$$ExpenseTimingOverrideImplFromJson(json);

  @override
  final String expenseId;
  @override
  final EventTiming? overrideStartTiming;
  @override
  final EventTiming? overrideEndTiming;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'ParameterOverride.expenseTiming(expenseId: $expenseId, overrideStartTiming: $overrideStartTiming, overrideEndTiming: $overrideEndTiming)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExpenseTimingOverrideImpl &&
            (identical(other.expenseId, expenseId) ||
                other.expenseId == expenseId) &&
            (identical(other.overrideStartTiming, overrideStartTiming) ||
                other.overrideStartTiming == overrideStartTiming) &&
            (identical(other.overrideEndTiming, overrideEndTiming) ||
                other.overrideEndTiming == overrideEndTiming));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    expenseId,
    overrideStartTiming,
    overrideEndTiming,
  );

  /// Create a copy of ParameterOverride
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ExpenseTimingOverrideImplCopyWith<_$ExpenseTimingOverrideImpl>
  get copyWith =>
      __$$ExpenseTimingOverrideImplCopyWithImpl<_$ExpenseTimingOverrideImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String assetId, double value) assetValue,
    required TResult Function(String eventId, int yearsFromStart) eventTiming,
    required TResult Function(
      String expenseId,
      double? overrideAmount,
      double? amountMultiplier,
    )
    expenseAmount,
    required TResult Function(
      String expenseId,
      EventTiming? overrideStartTiming,
      EventTiming? overrideEndTiming,
    )
    expenseTiming,
  }) {
    return expenseTiming(expenseId, overrideStartTiming, overrideEndTiming);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String assetId, double value)? assetValue,
    TResult? Function(String eventId, int yearsFromStart)? eventTiming,
    TResult? Function(
      String expenseId,
      double? overrideAmount,
      double? amountMultiplier,
    )?
    expenseAmount,
    TResult? Function(
      String expenseId,
      EventTiming? overrideStartTiming,
      EventTiming? overrideEndTiming,
    )?
    expenseTiming,
  }) {
    return expenseTiming?.call(
      expenseId,
      overrideStartTiming,
      overrideEndTiming,
    );
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String assetId, double value)? assetValue,
    TResult Function(String eventId, int yearsFromStart)? eventTiming,
    TResult Function(
      String expenseId,
      double? overrideAmount,
      double? amountMultiplier,
    )?
    expenseAmount,
    TResult Function(
      String expenseId,
      EventTiming? overrideStartTiming,
      EventTiming? overrideEndTiming,
    )?
    expenseTiming,
    required TResult orElse(),
  }) {
    if (expenseTiming != null) {
      return expenseTiming(expenseId, overrideStartTiming, overrideEndTiming);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AssetValueOverride value) assetValue,
    required TResult Function(EventTimingOverride value) eventTiming,
    required TResult Function(ExpenseAmountOverride value) expenseAmount,
    required TResult Function(ExpenseTimingOverride value) expenseTiming,
  }) {
    return expenseTiming(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AssetValueOverride value)? assetValue,
    TResult? Function(EventTimingOverride value)? eventTiming,
    TResult? Function(ExpenseAmountOverride value)? expenseAmount,
    TResult? Function(ExpenseTimingOverride value)? expenseTiming,
  }) {
    return expenseTiming?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AssetValueOverride value)? assetValue,
    TResult Function(EventTimingOverride value)? eventTiming,
    TResult Function(ExpenseAmountOverride value)? expenseAmount,
    TResult Function(ExpenseTimingOverride value)? expenseTiming,
    required TResult orElse(),
  }) {
    if (expenseTiming != null) {
      return expenseTiming(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$ExpenseTimingOverrideImplToJson(this);
  }
}

abstract class ExpenseTimingOverride implements ParameterOverride {
  const factory ExpenseTimingOverride({
    required final String expenseId,
    final EventTiming? overrideStartTiming,
    final EventTiming? overrideEndTiming,
  }) = _$ExpenseTimingOverrideImpl;

  factory ExpenseTimingOverride.fromJson(Map<String, dynamic> json) =
      _$ExpenseTimingOverrideImpl.fromJson;

  String get expenseId;
  EventTiming? get overrideStartTiming;
  EventTiming? get overrideEndTiming;

  /// Create a copy of ParameterOverride
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ExpenseTimingOverrideImplCopyWith<_$ExpenseTimingOverrideImpl>
  get copyWith => throw _privateConstructorUsedError;
}
