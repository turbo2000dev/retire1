// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'expense.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Expense _$ExpenseFromJson(Map<String, dynamic> json) {
  switch (json['runtimeType']) {
    case 'housing':
      return HousingExpense.fromJson(json);
    case 'transport':
      return TransportExpense.fromJson(json);
    case 'dailyLiving':
      return DailyLivingExpense.fromJson(json);
    case 'recreation':
      return RecreationExpense.fromJson(json);
    case 'health':
      return HealthExpense.fromJson(json);
    case 'family':
      return FamilyExpense.fromJson(json);

    default:
      throw CheckedFromJsonException(
        json,
        'runtimeType',
        'Expense',
        'Invalid union type "${json['runtimeType']}"!',
      );
  }
}

/// @nodoc
mixin _$Expense {
  String get id => throw _privateConstructorUsedError;
  EventTiming get startTiming => throw _privateConstructorUsedError;
  EventTiming get endTiming =>
      throw _privateConstructorUsedError; // Required: default to projectionEnd()
  double get annualAmount => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
      String id,
      EventTiming startTiming,
      EventTiming endTiming,
      double annualAmount,
    )
    housing,
    required TResult Function(
      String id,
      EventTiming startTiming,
      EventTiming endTiming,
      double annualAmount,
    )
    transport,
    required TResult Function(
      String id,
      EventTiming startTiming,
      EventTiming endTiming,
      double annualAmount,
    )
    dailyLiving,
    required TResult Function(
      String id,
      EventTiming startTiming,
      EventTiming endTiming,
      double annualAmount,
    )
    recreation,
    required TResult Function(
      String id,
      EventTiming startTiming,
      EventTiming endTiming,
      double annualAmount,
    )
    health,
    required TResult Function(
      String id,
      EventTiming startTiming,
      EventTiming endTiming,
      double annualAmount,
    )
    family,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
      String id,
      EventTiming startTiming,
      EventTiming endTiming,
      double annualAmount,
    )?
    housing,
    TResult? Function(
      String id,
      EventTiming startTiming,
      EventTiming endTiming,
      double annualAmount,
    )?
    transport,
    TResult? Function(
      String id,
      EventTiming startTiming,
      EventTiming endTiming,
      double annualAmount,
    )?
    dailyLiving,
    TResult? Function(
      String id,
      EventTiming startTiming,
      EventTiming endTiming,
      double annualAmount,
    )?
    recreation,
    TResult? Function(
      String id,
      EventTiming startTiming,
      EventTiming endTiming,
      double annualAmount,
    )?
    health,
    TResult? Function(
      String id,
      EventTiming startTiming,
      EventTiming endTiming,
      double annualAmount,
    )?
    family,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
      String id,
      EventTiming startTiming,
      EventTiming endTiming,
      double annualAmount,
    )?
    housing,
    TResult Function(
      String id,
      EventTiming startTiming,
      EventTiming endTiming,
      double annualAmount,
    )?
    transport,
    TResult Function(
      String id,
      EventTiming startTiming,
      EventTiming endTiming,
      double annualAmount,
    )?
    dailyLiving,
    TResult Function(
      String id,
      EventTiming startTiming,
      EventTiming endTiming,
      double annualAmount,
    )?
    recreation,
    TResult Function(
      String id,
      EventTiming startTiming,
      EventTiming endTiming,
      double annualAmount,
    )?
    health,
    TResult Function(
      String id,
      EventTiming startTiming,
      EventTiming endTiming,
      double annualAmount,
    )?
    family,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(HousingExpense value) housing,
    required TResult Function(TransportExpense value) transport,
    required TResult Function(DailyLivingExpense value) dailyLiving,
    required TResult Function(RecreationExpense value) recreation,
    required TResult Function(HealthExpense value) health,
    required TResult Function(FamilyExpense value) family,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(HousingExpense value)? housing,
    TResult? Function(TransportExpense value)? transport,
    TResult? Function(DailyLivingExpense value)? dailyLiving,
    TResult? Function(RecreationExpense value)? recreation,
    TResult? Function(HealthExpense value)? health,
    TResult? Function(FamilyExpense value)? family,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(HousingExpense value)? housing,
    TResult Function(TransportExpense value)? transport,
    TResult Function(DailyLivingExpense value)? dailyLiving,
    TResult Function(RecreationExpense value)? recreation,
    TResult Function(HealthExpense value)? health,
    TResult Function(FamilyExpense value)? family,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;

  /// Serializes this Expense to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Expense
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ExpenseCopyWith<Expense> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ExpenseCopyWith<$Res> {
  factory $ExpenseCopyWith(Expense value, $Res Function(Expense) then) =
      _$ExpenseCopyWithImpl<$Res, Expense>;
  @useResult
  $Res call({
    String id,
    EventTiming startTiming,
    EventTiming endTiming,
    double annualAmount,
  });

  $EventTimingCopyWith<$Res> get startTiming;
  $EventTimingCopyWith<$Res> get endTiming;
}

/// @nodoc
class _$ExpenseCopyWithImpl<$Res, $Val extends Expense>
    implements $ExpenseCopyWith<$Res> {
  _$ExpenseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Expense
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? startTiming = null,
    Object? endTiming = null,
    Object? annualAmount = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            startTiming: null == startTiming
                ? _value.startTiming
                : startTiming // ignore: cast_nullable_to_non_nullable
                      as EventTiming,
            endTiming: null == endTiming
                ? _value.endTiming
                : endTiming // ignore: cast_nullable_to_non_nullable
                      as EventTiming,
            annualAmount: null == annualAmount
                ? _value.annualAmount
                : annualAmount // ignore: cast_nullable_to_non_nullable
                      as double,
          )
          as $Val,
    );
  }

  /// Create a copy of Expense
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $EventTimingCopyWith<$Res> get startTiming {
    return $EventTimingCopyWith<$Res>(_value.startTiming, (value) {
      return _then(_value.copyWith(startTiming: value) as $Val);
    });
  }

  /// Create a copy of Expense
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $EventTimingCopyWith<$Res> get endTiming {
    return $EventTimingCopyWith<$Res>(_value.endTiming, (value) {
      return _then(_value.copyWith(endTiming: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$HousingExpenseImplCopyWith<$Res>
    implements $ExpenseCopyWith<$Res> {
  factory _$$HousingExpenseImplCopyWith(
    _$HousingExpenseImpl value,
    $Res Function(_$HousingExpenseImpl) then,
  ) = __$$HousingExpenseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    EventTiming startTiming,
    EventTiming endTiming,
    double annualAmount,
  });

  @override
  $EventTimingCopyWith<$Res> get startTiming;
  @override
  $EventTimingCopyWith<$Res> get endTiming;
}

/// @nodoc
class __$$HousingExpenseImplCopyWithImpl<$Res>
    extends _$ExpenseCopyWithImpl<$Res, _$HousingExpenseImpl>
    implements _$$HousingExpenseImplCopyWith<$Res> {
  __$$HousingExpenseImplCopyWithImpl(
    _$HousingExpenseImpl _value,
    $Res Function(_$HousingExpenseImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Expense
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? startTiming = null,
    Object? endTiming = null,
    Object? annualAmount = null,
  }) {
    return _then(
      _$HousingExpenseImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        startTiming: null == startTiming
            ? _value.startTiming
            : startTiming // ignore: cast_nullable_to_non_nullable
                  as EventTiming,
        endTiming: null == endTiming
            ? _value.endTiming
            : endTiming // ignore: cast_nullable_to_non_nullable
                  as EventTiming,
        annualAmount: null == annualAmount
            ? _value.annualAmount
            : annualAmount // ignore: cast_nullable_to_non_nullable
                  as double,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$HousingExpenseImpl implements HousingExpense {
  const _$HousingExpenseImpl({
    required this.id,
    required this.startTiming,
    required this.endTiming,
    required this.annualAmount,
    final String? $type,
  }) : $type = $type ?? 'housing';

  factory _$HousingExpenseImpl.fromJson(Map<String, dynamic> json) =>
      _$$HousingExpenseImplFromJson(json);

  @override
  final String id;
  @override
  final EventTiming startTiming;
  @override
  final EventTiming endTiming;
  // Required: default to projectionEnd()
  @override
  final double annualAmount;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'Expense.housing(id: $id, startTiming: $startTiming, endTiming: $endTiming, annualAmount: $annualAmount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HousingExpenseImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.startTiming, startTiming) ||
                other.startTiming == startTiming) &&
            (identical(other.endTiming, endTiming) ||
                other.endTiming == endTiming) &&
            (identical(other.annualAmount, annualAmount) ||
                other.annualAmount == annualAmount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, startTiming, endTiming, annualAmount);

  /// Create a copy of Expense
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HousingExpenseImplCopyWith<_$HousingExpenseImpl> get copyWith =>
      __$$HousingExpenseImplCopyWithImpl<_$HousingExpenseImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
      String id,
      EventTiming startTiming,
      EventTiming endTiming,
      double annualAmount,
    )
    housing,
    required TResult Function(
      String id,
      EventTiming startTiming,
      EventTiming endTiming,
      double annualAmount,
    )
    transport,
    required TResult Function(
      String id,
      EventTiming startTiming,
      EventTiming endTiming,
      double annualAmount,
    )
    dailyLiving,
    required TResult Function(
      String id,
      EventTiming startTiming,
      EventTiming endTiming,
      double annualAmount,
    )
    recreation,
    required TResult Function(
      String id,
      EventTiming startTiming,
      EventTiming endTiming,
      double annualAmount,
    )
    health,
    required TResult Function(
      String id,
      EventTiming startTiming,
      EventTiming endTiming,
      double annualAmount,
    )
    family,
  }) {
    return housing(id, startTiming, endTiming, annualAmount);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
      String id,
      EventTiming startTiming,
      EventTiming endTiming,
      double annualAmount,
    )?
    housing,
    TResult? Function(
      String id,
      EventTiming startTiming,
      EventTiming endTiming,
      double annualAmount,
    )?
    transport,
    TResult? Function(
      String id,
      EventTiming startTiming,
      EventTiming endTiming,
      double annualAmount,
    )?
    dailyLiving,
    TResult? Function(
      String id,
      EventTiming startTiming,
      EventTiming endTiming,
      double annualAmount,
    )?
    recreation,
    TResult? Function(
      String id,
      EventTiming startTiming,
      EventTiming endTiming,
      double annualAmount,
    )?
    health,
    TResult? Function(
      String id,
      EventTiming startTiming,
      EventTiming endTiming,
      double annualAmount,
    )?
    family,
  }) {
    return housing?.call(id, startTiming, endTiming, annualAmount);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
      String id,
      EventTiming startTiming,
      EventTiming endTiming,
      double annualAmount,
    )?
    housing,
    TResult Function(
      String id,
      EventTiming startTiming,
      EventTiming endTiming,
      double annualAmount,
    )?
    transport,
    TResult Function(
      String id,
      EventTiming startTiming,
      EventTiming endTiming,
      double annualAmount,
    )?
    dailyLiving,
    TResult Function(
      String id,
      EventTiming startTiming,
      EventTiming endTiming,
      double annualAmount,
    )?
    recreation,
    TResult Function(
      String id,
      EventTiming startTiming,
      EventTiming endTiming,
      double annualAmount,
    )?
    health,
    TResult Function(
      String id,
      EventTiming startTiming,
      EventTiming endTiming,
      double annualAmount,
    )?
    family,
    required TResult orElse(),
  }) {
    if (housing != null) {
      return housing(id, startTiming, endTiming, annualAmount);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(HousingExpense value) housing,
    required TResult Function(TransportExpense value) transport,
    required TResult Function(DailyLivingExpense value) dailyLiving,
    required TResult Function(RecreationExpense value) recreation,
    required TResult Function(HealthExpense value) health,
    required TResult Function(FamilyExpense value) family,
  }) {
    return housing(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(HousingExpense value)? housing,
    TResult? Function(TransportExpense value)? transport,
    TResult? Function(DailyLivingExpense value)? dailyLiving,
    TResult? Function(RecreationExpense value)? recreation,
    TResult? Function(HealthExpense value)? health,
    TResult? Function(FamilyExpense value)? family,
  }) {
    return housing?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(HousingExpense value)? housing,
    TResult Function(TransportExpense value)? transport,
    TResult Function(DailyLivingExpense value)? dailyLiving,
    TResult Function(RecreationExpense value)? recreation,
    TResult Function(HealthExpense value)? health,
    TResult Function(FamilyExpense value)? family,
    required TResult orElse(),
  }) {
    if (housing != null) {
      return housing(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$HousingExpenseImplToJson(this);
  }
}

abstract class HousingExpense implements Expense {
  const factory HousingExpense({
    required final String id,
    required final EventTiming startTiming,
    required final EventTiming endTiming,
    required final double annualAmount,
  }) = _$HousingExpenseImpl;

  factory HousingExpense.fromJson(Map<String, dynamic> json) =
      _$HousingExpenseImpl.fromJson;

  @override
  String get id;
  @override
  EventTiming get startTiming;
  @override
  EventTiming get endTiming; // Required: default to projectionEnd()
  @override
  double get annualAmount;

  /// Create a copy of Expense
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HousingExpenseImplCopyWith<_$HousingExpenseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$TransportExpenseImplCopyWith<$Res>
    implements $ExpenseCopyWith<$Res> {
  factory _$$TransportExpenseImplCopyWith(
    _$TransportExpenseImpl value,
    $Res Function(_$TransportExpenseImpl) then,
  ) = __$$TransportExpenseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    EventTiming startTiming,
    EventTiming endTiming,
    double annualAmount,
  });

  @override
  $EventTimingCopyWith<$Res> get startTiming;
  @override
  $EventTimingCopyWith<$Res> get endTiming;
}

/// @nodoc
class __$$TransportExpenseImplCopyWithImpl<$Res>
    extends _$ExpenseCopyWithImpl<$Res, _$TransportExpenseImpl>
    implements _$$TransportExpenseImplCopyWith<$Res> {
  __$$TransportExpenseImplCopyWithImpl(
    _$TransportExpenseImpl _value,
    $Res Function(_$TransportExpenseImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Expense
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? startTiming = null,
    Object? endTiming = null,
    Object? annualAmount = null,
  }) {
    return _then(
      _$TransportExpenseImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        startTiming: null == startTiming
            ? _value.startTiming
            : startTiming // ignore: cast_nullable_to_non_nullable
                  as EventTiming,
        endTiming: null == endTiming
            ? _value.endTiming
            : endTiming // ignore: cast_nullable_to_non_nullable
                  as EventTiming,
        annualAmount: null == annualAmount
            ? _value.annualAmount
            : annualAmount // ignore: cast_nullable_to_non_nullable
                  as double,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TransportExpenseImpl implements TransportExpense {
  const _$TransportExpenseImpl({
    required this.id,
    required this.startTiming,
    required this.endTiming,
    required this.annualAmount,
    final String? $type,
  }) : $type = $type ?? 'transport';

  factory _$TransportExpenseImpl.fromJson(Map<String, dynamic> json) =>
      _$$TransportExpenseImplFromJson(json);

  @override
  final String id;
  @override
  final EventTiming startTiming;
  @override
  final EventTiming endTiming;
  @override
  final double annualAmount;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'Expense.transport(id: $id, startTiming: $startTiming, endTiming: $endTiming, annualAmount: $annualAmount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TransportExpenseImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.startTiming, startTiming) ||
                other.startTiming == startTiming) &&
            (identical(other.endTiming, endTiming) ||
                other.endTiming == endTiming) &&
            (identical(other.annualAmount, annualAmount) ||
                other.annualAmount == annualAmount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, startTiming, endTiming, annualAmount);

  /// Create a copy of Expense
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TransportExpenseImplCopyWith<_$TransportExpenseImpl> get copyWith =>
      __$$TransportExpenseImplCopyWithImpl<_$TransportExpenseImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
      String id,
      EventTiming startTiming,
      EventTiming endTiming,
      double annualAmount,
    )
    housing,
    required TResult Function(
      String id,
      EventTiming startTiming,
      EventTiming endTiming,
      double annualAmount,
    )
    transport,
    required TResult Function(
      String id,
      EventTiming startTiming,
      EventTiming endTiming,
      double annualAmount,
    )
    dailyLiving,
    required TResult Function(
      String id,
      EventTiming startTiming,
      EventTiming endTiming,
      double annualAmount,
    )
    recreation,
    required TResult Function(
      String id,
      EventTiming startTiming,
      EventTiming endTiming,
      double annualAmount,
    )
    health,
    required TResult Function(
      String id,
      EventTiming startTiming,
      EventTiming endTiming,
      double annualAmount,
    )
    family,
  }) {
    return transport(id, startTiming, endTiming, annualAmount);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
      String id,
      EventTiming startTiming,
      EventTiming endTiming,
      double annualAmount,
    )?
    housing,
    TResult? Function(
      String id,
      EventTiming startTiming,
      EventTiming endTiming,
      double annualAmount,
    )?
    transport,
    TResult? Function(
      String id,
      EventTiming startTiming,
      EventTiming endTiming,
      double annualAmount,
    )?
    dailyLiving,
    TResult? Function(
      String id,
      EventTiming startTiming,
      EventTiming endTiming,
      double annualAmount,
    )?
    recreation,
    TResult? Function(
      String id,
      EventTiming startTiming,
      EventTiming endTiming,
      double annualAmount,
    )?
    health,
    TResult? Function(
      String id,
      EventTiming startTiming,
      EventTiming endTiming,
      double annualAmount,
    )?
    family,
  }) {
    return transport?.call(id, startTiming, endTiming, annualAmount);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
      String id,
      EventTiming startTiming,
      EventTiming endTiming,
      double annualAmount,
    )?
    housing,
    TResult Function(
      String id,
      EventTiming startTiming,
      EventTiming endTiming,
      double annualAmount,
    )?
    transport,
    TResult Function(
      String id,
      EventTiming startTiming,
      EventTiming endTiming,
      double annualAmount,
    )?
    dailyLiving,
    TResult Function(
      String id,
      EventTiming startTiming,
      EventTiming endTiming,
      double annualAmount,
    )?
    recreation,
    TResult Function(
      String id,
      EventTiming startTiming,
      EventTiming endTiming,
      double annualAmount,
    )?
    health,
    TResult Function(
      String id,
      EventTiming startTiming,
      EventTiming endTiming,
      double annualAmount,
    )?
    family,
    required TResult orElse(),
  }) {
    if (transport != null) {
      return transport(id, startTiming, endTiming, annualAmount);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(HousingExpense value) housing,
    required TResult Function(TransportExpense value) transport,
    required TResult Function(DailyLivingExpense value) dailyLiving,
    required TResult Function(RecreationExpense value) recreation,
    required TResult Function(HealthExpense value) health,
    required TResult Function(FamilyExpense value) family,
  }) {
    return transport(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(HousingExpense value)? housing,
    TResult? Function(TransportExpense value)? transport,
    TResult? Function(DailyLivingExpense value)? dailyLiving,
    TResult? Function(RecreationExpense value)? recreation,
    TResult? Function(HealthExpense value)? health,
    TResult? Function(FamilyExpense value)? family,
  }) {
    return transport?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(HousingExpense value)? housing,
    TResult Function(TransportExpense value)? transport,
    TResult Function(DailyLivingExpense value)? dailyLiving,
    TResult Function(RecreationExpense value)? recreation,
    TResult Function(HealthExpense value)? health,
    TResult Function(FamilyExpense value)? family,
    required TResult orElse(),
  }) {
    if (transport != null) {
      return transport(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$TransportExpenseImplToJson(this);
  }
}

abstract class TransportExpense implements Expense {
  const factory TransportExpense({
    required final String id,
    required final EventTiming startTiming,
    required final EventTiming endTiming,
    required final double annualAmount,
  }) = _$TransportExpenseImpl;

  factory TransportExpense.fromJson(Map<String, dynamic> json) =
      _$TransportExpenseImpl.fromJson;

  @override
  String get id;
  @override
  EventTiming get startTiming;
  @override
  EventTiming get endTiming;
  @override
  double get annualAmount;

  /// Create a copy of Expense
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TransportExpenseImplCopyWith<_$TransportExpenseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$DailyLivingExpenseImplCopyWith<$Res>
    implements $ExpenseCopyWith<$Res> {
  factory _$$DailyLivingExpenseImplCopyWith(
    _$DailyLivingExpenseImpl value,
    $Res Function(_$DailyLivingExpenseImpl) then,
  ) = __$$DailyLivingExpenseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    EventTiming startTiming,
    EventTiming endTiming,
    double annualAmount,
  });

  @override
  $EventTimingCopyWith<$Res> get startTiming;
  @override
  $EventTimingCopyWith<$Res> get endTiming;
}

/// @nodoc
class __$$DailyLivingExpenseImplCopyWithImpl<$Res>
    extends _$ExpenseCopyWithImpl<$Res, _$DailyLivingExpenseImpl>
    implements _$$DailyLivingExpenseImplCopyWith<$Res> {
  __$$DailyLivingExpenseImplCopyWithImpl(
    _$DailyLivingExpenseImpl _value,
    $Res Function(_$DailyLivingExpenseImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Expense
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? startTiming = null,
    Object? endTiming = null,
    Object? annualAmount = null,
  }) {
    return _then(
      _$DailyLivingExpenseImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        startTiming: null == startTiming
            ? _value.startTiming
            : startTiming // ignore: cast_nullable_to_non_nullable
                  as EventTiming,
        endTiming: null == endTiming
            ? _value.endTiming
            : endTiming // ignore: cast_nullable_to_non_nullable
                  as EventTiming,
        annualAmount: null == annualAmount
            ? _value.annualAmount
            : annualAmount // ignore: cast_nullable_to_non_nullable
                  as double,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$DailyLivingExpenseImpl implements DailyLivingExpense {
  const _$DailyLivingExpenseImpl({
    required this.id,
    required this.startTiming,
    required this.endTiming,
    required this.annualAmount,
    final String? $type,
  }) : $type = $type ?? 'dailyLiving';

  factory _$DailyLivingExpenseImpl.fromJson(Map<String, dynamic> json) =>
      _$$DailyLivingExpenseImplFromJson(json);

  @override
  final String id;
  @override
  final EventTiming startTiming;
  @override
  final EventTiming endTiming;
  @override
  final double annualAmount;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'Expense.dailyLiving(id: $id, startTiming: $startTiming, endTiming: $endTiming, annualAmount: $annualAmount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DailyLivingExpenseImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.startTiming, startTiming) ||
                other.startTiming == startTiming) &&
            (identical(other.endTiming, endTiming) ||
                other.endTiming == endTiming) &&
            (identical(other.annualAmount, annualAmount) ||
                other.annualAmount == annualAmount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, startTiming, endTiming, annualAmount);

  /// Create a copy of Expense
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DailyLivingExpenseImplCopyWith<_$DailyLivingExpenseImpl> get copyWith =>
      __$$DailyLivingExpenseImplCopyWithImpl<_$DailyLivingExpenseImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
      String id,
      EventTiming startTiming,
      EventTiming endTiming,
      double annualAmount,
    )
    housing,
    required TResult Function(
      String id,
      EventTiming startTiming,
      EventTiming endTiming,
      double annualAmount,
    )
    transport,
    required TResult Function(
      String id,
      EventTiming startTiming,
      EventTiming endTiming,
      double annualAmount,
    )
    dailyLiving,
    required TResult Function(
      String id,
      EventTiming startTiming,
      EventTiming endTiming,
      double annualAmount,
    )
    recreation,
    required TResult Function(
      String id,
      EventTiming startTiming,
      EventTiming endTiming,
      double annualAmount,
    )
    health,
    required TResult Function(
      String id,
      EventTiming startTiming,
      EventTiming endTiming,
      double annualAmount,
    )
    family,
  }) {
    return dailyLiving(id, startTiming, endTiming, annualAmount);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
      String id,
      EventTiming startTiming,
      EventTiming endTiming,
      double annualAmount,
    )?
    housing,
    TResult? Function(
      String id,
      EventTiming startTiming,
      EventTiming endTiming,
      double annualAmount,
    )?
    transport,
    TResult? Function(
      String id,
      EventTiming startTiming,
      EventTiming endTiming,
      double annualAmount,
    )?
    dailyLiving,
    TResult? Function(
      String id,
      EventTiming startTiming,
      EventTiming endTiming,
      double annualAmount,
    )?
    recreation,
    TResult? Function(
      String id,
      EventTiming startTiming,
      EventTiming endTiming,
      double annualAmount,
    )?
    health,
    TResult? Function(
      String id,
      EventTiming startTiming,
      EventTiming endTiming,
      double annualAmount,
    )?
    family,
  }) {
    return dailyLiving?.call(id, startTiming, endTiming, annualAmount);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
      String id,
      EventTiming startTiming,
      EventTiming endTiming,
      double annualAmount,
    )?
    housing,
    TResult Function(
      String id,
      EventTiming startTiming,
      EventTiming endTiming,
      double annualAmount,
    )?
    transport,
    TResult Function(
      String id,
      EventTiming startTiming,
      EventTiming endTiming,
      double annualAmount,
    )?
    dailyLiving,
    TResult Function(
      String id,
      EventTiming startTiming,
      EventTiming endTiming,
      double annualAmount,
    )?
    recreation,
    TResult Function(
      String id,
      EventTiming startTiming,
      EventTiming endTiming,
      double annualAmount,
    )?
    health,
    TResult Function(
      String id,
      EventTiming startTiming,
      EventTiming endTiming,
      double annualAmount,
    )?
    family,
    required TResult orElse(),
  }) {
    if (dailyLiving != null) {
      return dailyLiving(id, startTiming, endTiming, annualAmount);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(HousingExpense value) housing,
    required TResult Function(TransportExpense value) transport,
    required TResult Function(DailyLivingExpense value) dailyLiving,
    required TResult Function(RecreationExpense value) recreation,
    required TResult Function(HealthExpense value) health,
    required TResult Function(FamilyExpense value) family,
  }) {
    return dailyLiving(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(HousingExpense value)? housing,
    TResult? Function(TransportExpense value)? transport,
    TResult? Function(DailyLivingExpense value)? dailyLiving,
    TResult? Function(RecreationExpense value)? recreation,
    TResult? Function(HealthExpense value)? health,
    TResult? Function(FamilyExpense value)? family,
  }) {
    return dailyLiving?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(HousingExpense value)? housing,
    TResult Function(TransportExpense value)? transport,
    TResult Function(DailyLivingExpense value)? dailyLiving,
    TResult Function(RecreationExpense value)? recreation,
    TResult Function(HealthExpense value)? health,
    TResult Function(FamilyExpense value)? family,
    required TResult orElse(),
  }) {
    if (dailyLiving != null) {
      return dailyLiving(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$DailyLivingExpenseImplToJson(this);
  }
}

abstract class DailyLivingExpense implements Expense {
  const factory DailyLivingExpense({
    required final String id,
    required final EventTiming startTiming,
    required final EventTiming endTiming,
    required final double annualAmount,
  }) = _$DailyLivingExpenseImpl;

  factory DailyLivingExpense.fromJson(Map<String, dynamic> json) =
      _$DailyLivingExpenseImpl.fromJson;

  @override
  String get id;
  @override
  EventTiming get startTiming;
  @override
  EventTiming get endTiming;
  @override
  double get annualAmount;

  /// Create a copy of Expense
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DailyLivingExpenseImplCopyWith<_$DailyLivingExpenseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$RecreationExpenseImplCopyWith<$Res>
    implements $ExpenseCopyWith<$Res> {
  factory _$$RecreationExpenseImplCopyWith(
    _$RecreationExpenseImpl value,
    $Res Function(_$RecreationExpenseImpl) then,
  ) = __$$RecreationExpenseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    EventTiming startTiming,
    EventTiming endTiming,
    double annualAmount,
  });

  @override
  $EventTimingCopyWith<$Res> get startTiming;
  @override
  $EventTimingCopyWith<$Res> get endTiming;
}

/// @nodoc
class __$$RecreationExpenseImplCopyWithImpl<$Res>
    extends _$ExpenseCopyWithImpl<$Res, _$RecreationExpenseImpl>
    implements _$$RecreationExpenseImplCopyWith<$Res> {
  __$$RecreationExpenseImplCopyWithImpl(
    _$RecreationExpenseImpl _value,
    $Res Function(_$RecreationExpenseImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Expense
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? startTiming = null,
    Object? endTiming = null,
    Object? annualAmount = null,
  }) {
    return _then(
      _$RecreationExpenseImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        startTiming: null == startTiming
            ? _value.startTiming
            : startTiming // ignore: cast_nullable_to_non_nullable
                  as EventTiming,
        endTiming: null == endTiming
            ? _value.endTiming
            : endTiming // ignore: cast_nullable_to_non_nullable
                  as EventTiming,
        annualAmount: null == annualAmount
            ? _value.annualAmount
            : annualAmount // ignore: cast_nullable_to_non_nullable
                  as double,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$RecreationExpenseImpl implements RecreationExpense {
  const _$RecreationExpenseImpl({
    required this.id,
    required this.startTiming,
    required this.endTiming,
    required this.annualAmount,
    final String? $type,
  }) : $type = $type ?? 'recreation';

  factory _$RecreationExpenseImpl.fromJson(Map<String, dynamic> json) =>
      _$$RecreationExpenseImplFromJson(json);

  @override
  final String id;
  @override
  final EventTiming startTiming;
  @override
  final EventTiming endTiming;
  @override
  final double annualAmount;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'Expense.recreation(id: $id, startTiming: $startTiming, endTiming: $endTiming, annualAmount: $annualAmount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RecreationExpenseImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.startTiming, startTiming) ||
                other.startTiming == startTiming) &&
            (identical(other.endTiming, endTiming) ||
                other.endTiming == endTiming) &&
            (identical(other.annualAmount, annualAmount) ||
                other.annualAmount == annualAmount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, startTiming, endTiming, annualAmount);

  /// Create a copy of Expense
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RecreationExpenseImplCopyWith<_$RecreationExpenseImpl> get copyWith =>
      __$$RecreationExpenseImplCopyWithImpl<_$RecreationExpenseImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
      String id,
      EventTiming startTiming,
      EventTiming endTiming,
      double annualAmount,
    )
    housing,
    required TResult Function(
      String id,
      EventTiming startTiming,
      EventTiming endTiming,
      double annualAmount,
    )
    transport,
    required TResult Function(
      String id,
      EventTiming startTiming,
      EventTiming endTiming,
      double annualAmount,
    )
    dailyLiving,
    required TResult Function(
      String id,
      EventTiming startTiming,
      EventTiming endTiming,
      double annualAmount,
    )
    recreation,
    required TResult Function(
      String id,
      EventTiming startTiming,
      EventTiming endTiming,
      double annualAmount,
    )
    health,
    required TResult Function(
      String id,
      EventTiming startTiming,
      EventTiming endTiming,
      double annualAmount,
    )
    family,
  }) {
    return recreation(id, startTiming, endTiming, annualAmount);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
      String id,
      EventTiming startTiming,
      EventTiming endTiming,
      double annualAmount,
    )?
    housing,
    TResult? Function(
      String id,
      EventTiming startTiming,
      EventTiming endTiming,
      double annualAmount,
    )?
    transport,
    TResult? Function(
      String id,
      EventTiming startTiming,
      EventTiming endTiming,
      double annualAmount,
    )?
    dailyLiving,
    TResult? Function(
      String id,
      EventTiming startTiming,
      EventTiming endTiming,
      double annualAmount,
    )?
    recreation,
    TResult? Function(
      String id,
      EventTiming startTiming,
      EventTiming endTiming,
      double annualAmount,
    )?
    health,
    TResult? Function(
      String id,
      EventTiming startTiming,
      EventTiming endTiming,
      double annualAmount,
    )?
    family,
  }) {
    return recreation?.call(id, startTiming, endTiming, annualAmount);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
      String id,
      EventTiming startTiming,
      EventTiming endTiming,
      double annualAmount,
    )?
    housing,
    TResult Function(
      String id,
      EventTiming startTiming,
      EventTiming endTiming,
      double annualAmount,
    )?
    transport,
    TResult Function(
      String id,
      EventTiming startTiming,
      EventTiming endTiming,
      double annualAmount,
    )?
    dailyLiving,
    TResult Function(
      String id,
      EventTiming startTiming,
      EventTiming endTiming,
      double annualAmount,
    )?
    recreation,
    TResult Function(
      String id,
      EventTiming startTiming,
      EventTiming endTiming,
      double annualAmount,
    )?
    health,
    TResult Function(
      String id,
      EventTiming startTiming,
      EventTiming endTiming,
      double annualAmount,
    )?
    family,
    required TResult orElse(),
  }) {
    if (recreation != null) {
      return recreation(id, startTiming, endTiming, annualAmount);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(HousingExpense value) housing,
    required TResult Function(TransportExpense value) transport,
    required TResult Function(DailyLivingExpense value) dailyLiving,
    required TResult Function(RecreationExpense value) recreation,
    required TResult Function(HealthExpense value) health,
    required TResult Function(FamilyExpense value) family,
  }) {
    return recreation(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(HousingExpense value)? housing,
    TResult? Function(TransportExpense value)? transport,
    TResult? Function(DailyLivingExpense value)? dailyLiving,
    TResult? Function(RecreationExpense value)? recreation,
    TResult? Function(HealthExpense value)? health,
    TResult? Function(FamilyExpense value)? family,
  }) {
    return recreation?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(HousingExpense value)? housing,
    TResult Function(TransportExpense value)? transport,
    TResult Function(DailyLivingExpense value)? dailyLiving,
    TResult Function(RecreationExpense value)? recreation,
    TResult Function(HealthExpense value)? health,
    TResult Function(FamilyExpense value)? family,
    required TResult orElse(),
  }) {
    if (recreation != null) {
      return recreation(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$RecreationExpenseImplToJson(this);
  }
}

abstract class RecreationExpense implements Expense {
  const factory RecreationExpense({
    required final String id,
    required final EventTiming startTiming,
    required final EventTiming endTiming,
    required final double annualAmount,
  }) = _$RecreationExpenseImpl;

  factory RecreationExpense.fromJson(Map<String, dynamic> json) =
      _$RecreationExpenseImpl.fromJson;

  @override
  String get id;
  @override
  EventTiming get startTiming;
  @override
  EventTiming get endTiming;
  @override
  double get annualAmount;

  /// Create a copy of Expense
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RecreationExpenseImplCopyWith<_$RecreationExpenseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$HealthExpenseImplCopyWith<$Res>
    implements $ExpenseCopyWith<$Res> {
  factory _$$HealthExpenseImplCopyWith(
    _$HealthExpenseImpl value,
    $Res Function(_$HealthExpenseImpl) then,
  ) = __$$HealthExpenseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    EventTiming startTiming,
    EventTiming endTiming,
    double annualAmount,
  });

  @override
  $EventTimingCopyWith<$Res> get startTiming;
  @override
  $EventTimingCopyWith<$Res> get endTiming;
}

/// @nodoc
class __$$HealthExpenseImplCopyWithImpl<$Res>
    extends _$ExpenseCopyWithImpl<$Res, _$HealthExpenseImpl>
    implements _$$HealthExpenseImplCopyWith<$Res> {
  __$$HealthExpenseImplCopyWithImpl(
    _$HealthExpenseImpl _value,
    $Res Function(_$HealthExpenseImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Expense
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? startTiming = null,
    Object? endTiming = null,
    Object? annualAmount = null,
  }) {
    return _then(
      _$HealthExpenseImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        startTiming: null == startTiming
            ? _value.startTiming
            : startTiming // ignore: cast_nullable_to_non_nullable
                  as EventTiming,
        endTiming: null == endTiming
            ? _value.endTiming
            : endTiming // ignore: cast_nullable_to_non_nullable
                  as EventTiming,
        annualAmount: null == annualAmount
            ? _value.annualAmount
            : annualAmount // ignore: cast_nullable_to_non_nullable
                  as double,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$HealthExpenseImpl implements HealthExpense {
  const _$HealthExpenseImpl({
    required this.id,
    required this.startTiming,
    required this.endTiming,
    required this.annualAmount,
    final String? $type,
  }) : $type = $type ?? 'health';

  factory _$HealthExpenseImpl.fromJson(Map<String, dynamic> json) =>
      _$$HealthExpenseImplFromJson(json);

  @override
  final String id;
  @override
  final EventTiming startTiming;
  @override
  final EventTiming endTiming;
  @override
  final double annualAmount;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'Expense.health(id: $id, startTiming: $startTiming, endTiming: $endTiming, annualAmount: $annualAmount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HealthExpenseImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.startTiming, startTiming) ||
                other.startTiming == startTiming) &&
            (identical(other.endTiming, endTiming) ||
                other.endTiming == endTiming) &&
            (identical(other.annualAmount, annualAmount) ||
                other.annualAmount == annualAmount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, startTiming, endTiming, annualAmount);

  /// Create a copy of Expense
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HealthExpenseImplCopyWith<_$HealthExpenseImpl> get copyWith =>
      __$$HealthExpenseImplCopyWithImpl<_$HealthExpenseImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
      String id,
      EventTiming startTiming,
      EventTiming endTiming,
      double annualAmount,
    )
    housing,
    required TResult Function(
      String id,
      EventTiming startTiming,
      EventTiming endTiming,
      double annualAmount,
    )
    transport,
    required TResult Function(
      String id,
      EventTiming startTiming,
      EventTiming endTiming,
      double annualAmount,
    )
    dailyLiving,
    required TResult Function(
      String id,
      EventTiming startTiming,
      EventTiming endTiming,
      double annualAmount,
    )
    recreation,
    required TResult Function(
      String id,
      EventTiming startTiming,
      EventTiming endTiming,
      double annualAmount,
    )
    health,
    required TResult Function(
      String id,
      EventTiming startTiming,
      EventTiming endTiming,
      double annualAmount,
    )
    family,
  }) {
    return health(id, startTiming, endTiming, annualAmount);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
      String id,
      EventTiming startTiming,
      EventTiming endTiming,
      double annualAmount,
    )?
    housing,
    TResult? Function(
      String id,
      EventTiming startTiming,
      EventTiming endTiming,
      double annualAmount,
    )?
    transport,
    TResult? Function(
      String id,
      EventTiming startTiming,
      EventTiming endTiming,
      double annualAmount,
    )?
    dailyLiving,
    TResult? Function(
      String id,
      EventTiming startTiming,
      EventTiming endTiming,
      double annualAmount,
    )?
    recreation,
    TResult? Function(
      String id,
      EventTiming startTiming,
      EventTiming endTiming,
      double annualAmount,
    )?
    health,
    TResult? Function(
      String id,
      EventTiming startTiming,
      EventTiming endTiming,
      double annualAmount,
    )?
    family,
  }) {
    return health?.call(id, startTiming, endTiming, annualAmount);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
      String id,
      EventTiming startTiming,
      EventTiming endTiming,
      double annualAmount,
    )?
    housing,
    TResult Function(
      String id,
      EventTiming startTiming,
      EventTiming endTiming,
      double annualAmount,
    )?
    transport,
    TResult Function(
      String id,
      EventTiming startTiming,
      EventTiming endTiming,
      double annualAmount,
    )?
    dailyLiving,
    TResult Function(
      String id,
      EventTiming startTiming,
      EventTiming endTiming,
      double annualAmount,
    )?
    recreation,
    TResult Function(
      String id,
      EventTiming startTiming,
      EventTiming endTiming,
      double annualAmount,
    )?
    health,
    TResult Function(
      String id,
      EventTiming startTiming,
      EventTiming endTiming,
      double annualAmount,
    )?
    family,
    required TResult orElse(),
  }) {
    if (health != null) {
      return health(id, startTiming, endTiming, annualAmount);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(HousingExpense value) housing,
    required TResult Function(TransportExpense value) transport,
    required TResult Function(DailyLivingExpense value) dailyLiving,
    required TResult Function(RecreationExpense value) recreation,
    required TResult Function(HealthExpense value) health,
    required TResult Function(FamilyExpense value) family,
  }) {
    return health(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(HousingExpense value)? housing,
    TResult? Function(TransportExpense value)? transport,
    TResult? Function(DailyLivingExpense value)? dailyLiving,
    TResult? Function(RecreationExpense value)? recreation,
    TResult? Function(HealthExpense value)? health,
    TResult? Function(FamilyExpense value)? family,
  }) {
    return health?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(HousingExpense value)? housing,
    TResult Function(TransportExpense value)? transport,
    TResult Function(DailyLivingExpense value)? dailyLiving,
    TResult Function(RecreationExpense value)? recreation,
    TResult Function(HealthExpense value)? health,
    TResult Function(FamilyExpense value)? family,
    required TResult orElse(),
  }) {
    if (health != null) {
      return health(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$HealthExpenseImplToJson(this);
  }
}

abstract class HealthExpense implements Expense {
  const factory HealthExpense({
    required final String id,
    required final EventTiming startTiming,
    required final EventTiming endTiming,
    required final double annualAmount,
  }) = _$HealthExpenseImpl;

  factory HealthExpense.fromJson(Map<String, dynamic> json) =
      _$HealthExpenseImpl.fromJson;

  @override
  String get id;
  @override
  EventTiming get startTiming;
  @override
  EventTiming get endTiming;
  @override
  double get annualAmount;

  /// Create a copy of Expense
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HealthExpenseImplCopyWith<_$HealthExpenseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$FamilyExpenseImplCopyWith<$Res>
    implements $ExpenseCopyWith<$Res> {
  factory _$$FamilyExpenseImplCopyWith(
    _$FamilyExpenseImpl value,
    $Res Function(_$FamilyExpenseImpl) then,
  ) = __$$FamilyExpenseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    EventTiming startTiming,
    EventTiming endTiming,
    double annualAmount,
  });

  @override
  $EventTimingCopyWith<$Res> get startTiming;
  @override
  $EventTimingCopyWith<$Res> get endTiming;
}

/// @nodoc
class __$$FamilyExpenseImplCopyWithImpl<$Res>
    extends _$ExpenseCopyWithImpl<$Res, _$FamilyExpenseImpl>
    implements _$$FamilyExpenseImplCopyWith<$Res> {
  __$$FamilyExpenseImplCopyWithImpl(
    _$FamilyExpenseImpl _value,
    $Res Function(_$FamilyExpenseImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Expense
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? startTiming = null,
    Object? endTiming = null,
    Object? annualAmount = null,
  }) {
    return _then(
      _$FamilyExpenseImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        startTiming: null == startTiming
            ? _value.startTiming
            : startTiming // ignore: cast_nullable_to_non_nullable
                  as EventTiming,
        endTiming: null == endTiming
            ? _value.endTiming
            : endTiming // ignore: cast_nullable_to_non_nullable
                  as EventTiming,
        annualAmount: null == annualAmount
            ? _value.annualAmount
            : annualAmount // ignore: cast_nullable_to_non_nullable
                  as double,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$FamilyExpenseImpl implements FamilyExpense {
  const _$FamilyExpenseImpl({
    required this.id,
    required this.startTiming,
    required this.endTiming,
    required this.annualAmount,
    final String? $type,
  }) : $type = $type ?? 'family';

  factory _$FamilyExpenseImpl.fromJson(Map<String, dynamic> json) =>
      _$$FamilyExpenseImplFromJson(json);

  @override
  final String id;
  @override
  final EventTiming startTiming;
  @override
  final EventTiming endTiming;
  @override
  final double annualAmount;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'Expense.family(id: $id, startTiming: $startTiming, endTiming: $endTiming, annualAmount: $annualAmount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FamilyExpenseImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.startTiming, startTiming) ||
                other.startTiming == startTiming) &&
            (identical(other.endTiming, endTiming) ||
                other.endTiming == endTiming) &&
            (identical(other.annualAmount, annualAmount) ||
                other.annualAmount == annualAmount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, startTiming, endTiming, annualAmount);

  /// Create a copy of Expense
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FamilyExpenseImplCopyWith<_$FamilyExpenseImpl> get copyWith =>
      __$$FamilyExpenseImplCopyWithImpl<_$FamilyExpenseImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
      String id,
      EventTiming startTiming,
      EventTiming endTiming,
      double annualAmount,
    )
    housing,
    required TResult Function(
      String id,
      EventTiming startTiming,
      EventTiming endTiming,
      double annualAmount,
    )
    transport,
    required TResult Function(
      String id,
      EventTiming startTiming,
      EventTiming endTiming,
      double annualAmount,
    )
    dailyLiving,
    required TResult Function(
      String id,
      EventTiming startTiming,
      EventTiming endTiming,
      double annualAmount,
    )
    recreation,
    required TResult Function(
      String id,
      EventTiming startTiming,
      EventTiming endTiming,
      double annualAmount,
    )
    health,
    required TResult Function(
      String id,
      EventTiming startTiming,
      EventTiming endTiming,
      double annualAmount,
    )
    family,
  }) {
    return family(id, startTiming, endTiming, annualAmount);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
      String id,
      EventTiming startTiming,
      EventTiming endTiming,
      double annualAmount,
    )?
    housing,
    TResult? Function(
      String id,
      EventTiming startTiming,
      EventTiming endTiming,
      double annualAmount,
    )?
    transport,
    TResult? Function(
      String id,
      EventTiming startTiming,
      EventTiming endTiming,
      double annualAmount,
    )?
    dailyLiving,
    TResult? Function(
      String id,
      EventTiming startTiming,
      EventTiming endTiming,
      double annualAmount,
    )?
    recreation,
    TResult? Function(
      String id,
      EventTiming startTiming,
      EventTiming endTiming,
      double annualAmount,
    )?
    health,
    TResult? Function(
      String id,
      EventTiming startTiming,
      EventTiming endTiming,
      double annualAmount,
    )?
    family,
  }) {
    return family?.call(id, startTiming, endTiming, annualAmount);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
      String id,
      EventTiming startTiming,
      EventTiming endTiming,
      double annualAmount,
    )?
    housing,
    TResult Function(
      String id,
      EventTiming startTiming,
      EventTiming endTiming,
      double annualAmount,
    )?
    transport,
    TResult Function(
      String id,
      EventTiming startTiming,
      EventTiming endTiming,
      double annualAmount,
    )?
    dailyLiving,
    TResult Function(
      String id,
      EventTiming startTiming,
      EventTiming endTiming,
      double annualAmount,
    )?
    recreation,
    TResult Function(
      String id,
      EventTiming startTiming,
      EventTiming endTiming,
      double annualAmount,
    )?
    health,
    TResult Function(
      String id,
      EventTiming startTiming,
      EventTiming endTiming,
      double annualAmount,
    )?
    family,
    required TResult orElse(),
  }) {
    if (family != null) {
      return family(id, startTiming, endTiming, annualAmount);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(HousingExpense value) housing,
    required TResult Function(TransportExpense value) transport,
    required TResult Function(DailyLivingExpense value) dailyLiving,
    required TResult Function(RecreationExpense value) recreation,
    required TResult Function(HealthExpense value) health,
    required TResult Function(FamilyExpense value) family,
  }) {
    return family(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(HousingExpense value)? housing,
    TResult? Function(TransportExpense value)? transport,
    TResult? Function(DailyLivingExpense value)? dailyLiving,
    TResult? Function(RecreationExpense value)? recreation,
    TResult? Function(HealthExpense value)? health,
    TResult? Function(FamilyExpense value)? family,
  }) {
    return family?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(HousingExpense value)? housing,
    TResult Function(TransportExpense value)? transport,
    TResult Function(DailyLivingExpense value)? dailyLiving,
    TResult Function(RecreationExpense value)? recreation,
    TResult Function(HealthExpense value)? health,
    TResult Function(FamilyExpense value)? family,
    required TResult orElse(),
  }) {
    if (family != null) {
      return family(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$FamilyExpenseImplToJson(this);
  }
}

abstract class FamilyExpense implements Expense {
  const factory FamilyExpense({
    required final String id,
    required final EventTiming startTiming,
    required final EventTiming endTiming,
    required final double annualAmount,
  }) = _$FamilyExpenseImpl;

  factory FamilyExpense.fromJson(Map<String, dynamic> json) =
      _$FamilyExpenseImpl.fromJson;

  @override
  String get id;
  @override
  EventTiming get startTiming;
  @override
  EventTiming get endTiming;
  @override
  double get annualAmount;

  /// Create a copy of Expense
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FamilyExpenseImplCopyWith<_$FamilyExpenseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
