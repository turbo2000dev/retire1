// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Event _$EventFromJson(Map<String, dynamic> json) {
  switch (json['runtimeType']) {
    case 'retirement':
      return RetirementEvent.fromJson(json);
    case 'death':
      return DeathEvent.fromJson(json);
    case 'realEstateTransaction':
      return RealEstateTransactionEvent.fromJson(json);

    default:
      throw CheckedFromJsonException(
        json,
        'runtimeType',
        'Event',
        'Invalid union type "${json['runtimeType']}"!',
      );
  }
}

/// @nodoc
mixin _$Event {
  String get id => throw _privateConstructorUsedError;
  EventTiming get timing => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
      String id,
      String individualId,
      EventTiming timing,
    )
    retirement,
    required TResult Function(
      String id,
      String individualId,
      EventTiming timing,
    )
    death,
    required TResult Function(
      String id,
      EventTiming timing,
      String? assetSoldId,
      String? assetPurchasedId,
      String withdrawAccountId,
      String depositAccountId,
    )
    realEstateTransaction,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String id, String individualId, EventTiming timing)?
    retirement,
    TResult? Function(String id, String individualId, EventTiming timing)?
    death,
    TResult? Function(
      String id,
      EventTiming timing,
      String? assetSoldId,
      String? assetPurchasedId,
      String withdrawAccountId,
      String depositAccountId,
    )?
    realEstateTransaction,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String id, String individualId, EventTiming timing)?
    retirement,
    TResult Function(String id, String individualId, EventTiming timing)? death,
    TResult Function(
      String id,
      EventTiming timing,
      String? assetSoldId,
      String? assetPurchasedId,
      String withdrawAccountId,
      String depositAccountId,
    )?
    realEstateTransaction,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(RetirementEvent value) retirement,
    required TResult Function(DeathEvent value) death,
    required TResult Function(RealEstateTransactionEvent value)
    realEstateTransaction,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(RetirementEvent value)? retirement,
    TResult? Function(DeathEvent value)? death,
    TResult? Function(RealEstateTransactionEvent value)? realEstateTransaction,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(RetirementEvent value)? retirement,
    TResult Function(DeathEvent value)? death,
    TResult Function(RealEstateTransactionEvent value)? realEstateTransaction,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;

  /// Serializes this Event to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Event
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $EventCopyWith<Event> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EventCopyWith<$Res> {
  factory $EventCopyWith(Event value, $Res Function(Event) then) =
      _$EventCopyWithImpl<$Res, Event>;
  @useResult
  $Res call({String id, EventTiming timing});

  $EventTimingCopyWith<$Res> get timing;
}

/// @nodoc
class _$EventCopyWithImpl<$Res, $Val extends Event>
    implements $EventCopyWith<$Res> {
  _$EventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Event
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? id = null, Object? timing = null}) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            timing: null == timing
                ? _value.timing
                : timing // ignore: cast_nullable_to_non_nullable
                      as EventTiming,
          )
          as $Val,
    );
  }

  /// Create a copy of Event
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $EventTimingCopyWith<$Res> get timing {
    return $EventTimingCopyWith<$Res>(_value.timing, (value) {
      return _then(_value.copyWith(timing: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$RetirementEventImplCopyWith<$Res>
    implements $EventCopyWith<$Res> {
  factory _$$RetirementEventImplCopyWith(
    _$RetirementEventImpl value,
    $Res Function(_$RetirementEventImpl) then,
  ) = __$$RetirementEventImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String individualId, EventTiming timing});

  @override
  $EventTimingCopyWith<$Res> get timing;
}

/// @nodoc
class __$$RetirementEventImplCopyWithImpl<$Res>
    extends _$EventCopyWithImpl<$Res, _$RetirementEventImpl>
    implements _$$RetirementEventImplCopyWith<$Res> {
  __$$RetirementEventImplCopyWithImpl(
    _$RetirementEventImpl _value,
    $Res Function(_$RetirementEventImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Event
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? individualId = null,
    Object? timing = null,
  }) {
    return _then(
      _$RetirementEventImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        individualId: null == individualId
            ? _value.individualId
            : individualId // ignore: cast_nullable_to_non_nullable
                  as String,
        timing: null == timing
            ? _value.timing
            : timing // ignore: cast_nullable_to_non_nullable
                  as EventTiming,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$RetirementEventImpl implements RetirementEvent {
  const _$RetirementEventImpl({
    required this.id,
    required this.individualId,
    required this.timing,
    final String? $type,
  }) : $type = $type ?? 'retirement';

  factory _$RetirementEventImpl.fromJson(Map<String, dynamic> json) =>
      _$$RetirementEventImplFromJson(json);

  @override
  final String id;
  @override
  final String individualId;
  @override
  final EventTiming timing;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'Event.retirement(id: $id, individualId: $individualId, timing: $timing)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RetirementEventImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.individualId, individualId) ||
                other.individualId == individualId) &&
            (identical(other.timing, timing) || other.timing == timing));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, individualId, timing);

  /// Create a copy of Event
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RetirementEventImplCopyWith<_$RetirementEventImpl> get copyWith =>
      __$$RetirementEventImplCopyWithImpl<_$RetirementEventImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
      String id,
      String individualId,
      EventTiming timing,
    )
    retirement,
    required TResult Function(
      String id,
      String individualId,
      EventTiming timing,
    )
    death,
    required TResult Function(
      String id,
      EventTiming timing,
      String? assetSoldId,
      String? assetPurchasedId,
      String withdrawAccountId,
      String depositAccountId,
    )
    realEstateTransaction,
  }) {
    return retirement(id, individualId, timing);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String id, String individualId, EventTiming timing)?
    retirement,
    TResult? Function(String id, String individualId, EventTiming timing)?
    death,
    TResult? Function(
      String id,
      EventTiming timing,
      String? assetSoldId,
      String? assetPurchasedId,
      String withdrawAccountId,
      String depositAccountId,
    )?
    realEstateTransaction,
  }) {
    return retirement?.call(id, individualId, timing);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String id, String individualId, EventTiming timing)?
    retirement,
    TResult Function(String id, String individualId, EventTiming timing)? death,
    TResult Function(
      String id,
      EventTiming timing,
      String? assetSoldId,
      String? assetPurchasedId,
      String withdrawAccountId,
      String depositAccountId,
    )?
    realEstateTransaction,
    required TResult orElse(),
  }) {
    if (retirement != null) {
      return retirement(id, individualId, timing);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(RetirementEvent value) retirement,
    required TResult Function(DeathEvent value) death,
    required TResult Function(RealEstateTransactionEvent value)
    realEstateTransaction,
  }) {
    return retirement(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(RetirementEvent value)? retirement,
    TResult? Function(DeathEvent value)? death,
    TResult? Function(RealEstateTransactionEvent value)? realEstateTransaction,
  }) {
    return retirement?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(RetirementEvent value)? retirement,
    TResult Function(DeathEvent value)? death,
    TResult Function(RealEstateTransactionEvent value)? realEstateTransaction,
    required TResult orElse(),
  }) {
    if (retirement != null) {
      return retirement(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$RetirementEventImplToJson(this);
  }
}

abstract class RetirementEvent implements Event {
  const factory RetirementEvent({
    required final String id,
    required final String individualId,
    required final EventTiming timing,
  }) = _$RetirementEventImpl;

  factory RetirementEvent.fromJson(Map<String, dynamic> json) =
      _$RetirementEventImpl.fromJson;

  @override
  String get id;
  String get individualId;
  @override
  EventTiming get timing;

  /// Create a copy of Event
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RetirementEventImplCopyWith<_$RetirementEventImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$DeathEventImplCopyWith<$Res> implements $EventCopyWith<$Res> {
  factory _$$DeathEventImplCopyWith(
    _$DeathEventImpl value,
    $Res Function(_$DeathEventImpl) then,
  ) = __$$DeathEventImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String individualId, EventTiming timing});

  @override
  $EventTimingCopyWith<$Res> get timing;
}

/// @nodoc
class __$$DeathEventImplCopyWithImpl<$Res>
    extends _$EventCopyWithImpl<$Res, _$DeathEventImpl>
    implements _$$DeathEventImplCopyWith<$Res> {
  __$$DeathEventImplCopyWithImpl(
    _$DeathEventImpl _value,
    $Res Function(_$DeathEventImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Event
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? individualId = null,
    Object? timing = null,
  }) {
    return _then(
      _$DeathEventImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        individualId: null == individualId
            ? _value.individualId
            : individualId // ignore: cast_nullable_to_non_nullable
                  as String,
        timing: null == timing
            ? _value.timing
            : timing // ignore: cast_nullable_to_non_nullable
                  as EventTiming,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$DeathEventImpl implements DeathEvent {
  const _$DeathEventImpl({
    required this.id,
    required this.individualId,
    required this.timing,
    final String? $type,
  }) : $type = $type ?? 'death';

  factory _$DeathEventImpl.fromJson(Map<String, dynamic> json) =>
      _$$DeathEventImplFromJson(json);

  @override
  final String id;
  @override
  final String individualId;
  @override
  final EventTiming timing;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'Event.death(id: $id, individualId: $individualId, timing: $timing)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DeathEventImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.individualId, individualId) ||
                other.individualId == individualId) &&
            (identical(other.timing, timing) || other.timing == timing));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, individualId, timing);

  /// Create a copy of Event
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DeathEventImplCopyWith<_$DeathEventImpl> get copyWith =>
      __$$DeathEventImplCopyWithImpl<_$DeathEventImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
      String id,
      String individualId,
      EventTiming timing,
    )
    retirement,
    required TResult Function(
      String id,
      String individualId,
      EventTiming timing,
    )
    death,
    required TResult Function(
      String id,
      EventTiming timing,
      String? assetSoldId,
      String? assetPurchasedId,
      String withdrawAccountId,
      String depositAccountId,
    )
    realEstateTransaction,
  }) {
    return death(id, individualId, timing);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String id, String individualId, EventTiming timing)?
    retirement,
    TResult? Function(String id, String individualId, EventTiming timing)?
    death,
    TResult? Function(
      String id,
      EventTiming timing,
      String? assetSoldId,
      String? assetPurchasedId,
      String withdrawAccountId,
      String depositAccountId,
    )?
    realEstateTransaction,
  }) {
    return death?.call(id, individualId, timing);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String id, String individualId, EventTiming timing)?
    retirement,
    TResult Function(String id, String individualId, EventTiming timing)? death,
    TResult Function(
      String id,
      EventTiming timing,
      String? assetSoldId,
      String? assetPurchasedId,
      String withdrawAccountId,
      String depositAccountId,
    )?
    realEstateTransaction,
    required TResult orElse(),
  }) {
    if (death != null) {
      return death(id, individualId, timing);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(RetirementEvent value) retirement,
    required TResult Function(DeathEvent value) death,
    required TResult Function(RealEstateTransactionEvent value)
    realEstateTransaction,
  }) {
    return death(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(RetirementEvent value)? retirement,
    TResult? Function(DeathEvent value)? death,
    TResult? Function(RealEstateTransactionEvent value)? realEstateTransaction,
  }) {
    return death?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(RetirementEvent value)? retirement,
    TResult Function(DeathEvent value)? death,
    TResult Function(RealEstateTransactionEvent value)? realEstateTransaction,
    required TResult orElse(),
  }) {
    if (death != null) {
      return death(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$DeathEventImplToJson(this);
  }
}

abstract class DeathEvent implements Event {
  const factory DeathEvent({
    required final String id,
    required final String individualId,
    required final EventTiming timing,
  }) = _$DeathEventImpl;

  factory DeathEvent.fromJson(Map<String, dynamic> json) =
      _$DeathEventImpl.fromJson;

  @override
  String get id;
  String get individualId;
  @override
  EventTiming get timing;

  /// Create a copy of Event
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DeathEventImplCopyWith<_$DeathEventImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$RealEstateTransactionEventImplCopyWith<$Res>
    implements $EventCopyWith<$Res> {
  factory _$$RealEstateTransactionEventImplCopyWith(
    _$RealEstateTransactionEventImpl value,
    $Res Function(_$RealEstateTransactionEventImpl) then,
  ) = __$$RealEstateTransactionEventImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    EventTiming timing,
    String? assetSoldId,
    String? assetPurchasedId,
    String withdrawAccountId,
    String depositAccountId,
  });

  @override
  $EventTimingCopyWith<$Res> get timing;
}

/// @nodoc
class __$$RealEstateTransactionEventImplCopyWithImpl<$Res>
    extends _$EventCopyWithImpl<$Res, _$RealEstateTransactionEventImpl>
    implements _$$RealEstateTransactionEventImplCopyWith<$Res> {
  __$$RealEstateTransactionEventImplCopyWithImpl(
    _$RealEstateTransactionEventImpl _value,
    $Res Function(_$RealEstateTransactionEventImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Event
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? timing = null,
    Object? assetSoldId = freezed,
    Object? assetPurchasedId = freezed,
    Object? withdrawAccountId = null,
    Object? depositAccountId = null,
  }) {
    return _then(
      _$RealEstateTransactionEventImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        timing: null == timing
            ? _value.timing
            : timing // ignore: cast_nullable_to_non_nullable
                  as EventTiming,
        assetSoldId: freezed == assetSoldId
            ? _value.assetSoldId
            : assetSoldId // ignore: cast_nullable_to_non_nullable
                  as String?,
        assetPurchasedId: freezed == assetPurchasedId
            ? _value.assetPurchasedId
            : assetPurchasedId // ignore: cast_nullable_to_non_nullable
                  as String?,
        withdrawAccountId: null == withdrawAccountId
            ? _value.withdrawAccountId
            : withdrawAccountId // ignore: cast_nullable_to_non_nullable
                  as String,
        depositAccountId: null == depositAccountId
            ? _value.depositAccountId
            : depositAccountId // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$RealEstateTransactionEventImpl implements RealEstateTransactionEvent {
  const _$RealEstateTransactionEventImpl({
    required this.id,
    required this.timing,
    this.assetSoldId,
    this.assetPurchasedId,
    required this.withdrawAccountId,
    required this.depositAccountId,
    final String? $type,
  }) : $type = $type ?? 'realEstateTransaction';

  factory _$RealEstateTransactionEventImpl.fromJson(
    Map<String, dynamic> json,
  ) => _$$RealEstateTransactionEventImplFromJson(json);

  @override
  final String id;
  @override
  final EventTiming timing;
  @override
  final String? assetSoldId;
  // Real estate asset being sold
  @override
  final String? assetPurchasedId;
  // Real estate asset being purchased
  @override
  final String withdrawAccountId;
  // Cash account to withdraw from (for purchase) or deposit to (for sale)
  @override
  final String depositAccountId;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'Event.realEstateTransaction(id: $id, timing: $timing, assetSoldId: $assetSoldId, assetPurchasedId: $assetPurchasedId, withdrawAccountId: $withdrawAccountId, depositAccountId: $depositAccountId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RealEstateTransactionEventImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.timing, timing) || other.timing == timing) &&
            (identical(other.assetSoldId, assetSoldId) ||
                other.assetSoldId == assetSoldId) &&
            (identical(other.assetPurchasedId, assetPurchasedId) ||
                other.assetPurchasedId == assetPurchasedId) &&
            (identical(other.withdrawAccountId, withdrawAccountId) ||
                other.withdrawAccountId == withdrawAccountId) &&
            (identical(other.depositAccountId, depositAccountId) ||
                other.depositAccountId == depositAccountId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    timing,
    assetSoldId,
    assetPurchasedId,
    withdrawAccountId,
    depositAccountId,
  );

  /// Create a copy of Event
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RealEstateTransactionEventImplCopyWith<_$RealEstateTransactionEventImpl>
  get copyWith =>
      __$$RealEstateTransactionEventImplCopyWithImpl<
        _$RealEstateTransactionEventImpl
      >(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
      String id,
      String individualId,
      EventTiming timing,
    )
    retirement,
    required TResult Function(
      String id,
      String individualId,
      EventTiming timing,
    )
    death,
    required TResult Function(
      String id,
      EventTiming timing,
      String? assetSoldId,
      String? assetPurchasedId,
      String withdrawAccountId,
      String depositAccountId,
    )
    realEstateTransaction,
  }) {
    return realEstateTransaction(
      id,
      timing,
      assetSoldId,
      assetPurchasedId,
      withdrawAccountId,
      depositAccountId,
    );
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String id, String individualId, EventTiming timing)?
    retirement,
    TResult? Function(String id, String individualId, EventTiming timing)?
    death,
    TResult? Function(
      String id,
      EventTiming timing,
      String? assetSoldId,
      String? assetPurchasedId,
      String withdrawAccountId,
      String depositAccountId,
    )?
    realEstateTransaction,
  }) {
    return realEstateTransaction?.call(
      id,
      timing,
      assetSoldId,
      assetPurchasedId,
      withdrawAccountId,
      depositAccountId,
    );
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String id, String individualId, EventTiming timing)?
    retirement,
    TResult Function(String id, String individualId, EventTiming timing)? death,
    TResult Function(
      String id,
      EventTiming timing,
      String? assetSoldId,
      String? assetPurchasedId,
      String withdrawAccountId,
      String depositAccountId,
    )?
    realEstateTransaction,
    required TResult orElse(),
  }) {
    if (realEstateTransaction != null) {
      return realEstateTransaction(
        id,
        timing,
        assetSoldId,
        assetPurchasedId,
        withdrawAccountId,
        depositAccountId,
      );
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(RetirementEvent value) retirement,
    required TResult Function(DeathEvent value) death,
    required TResult Function(RealEstateTransactionEvent value)
    realEstateTransaction,
  }) {
    return realEstateTransaction(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(RetirementEvent value)? retirement,
    TResult? Function(DeathEvent value)? death,
    TResult? Function(RealEstateTransactionEvent value)? realEstateTransaction,
  }) {
    return realEstateTransaction?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(RetirementEvent value)? retirement,
    TResult Function(DeathEvent value)? death,
    TResult Function(RealEstateTransactionEvent value)? realEstateTransaction,
    required TResult orElse(),
  }) {
    if (realEstateTransaction != null) {
      return realEstateTransaction(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$RealEstateTransactionEventImplToJson(this);
  }
}

abstract class RealEstateTransactionEvent implements Event {
  const factory RealEstateTransactionEvent({
    required final String id,
    required final EventTiming timing,
    final String? assetSoldId,
    final String? assetPurchasedId,
    required final String withdrawAccountId,
    required final String depositAccountId,
  }) = _$RealEstateTransactionEventImpl;

  factory RealEstateTransactionEvent.fromJson(Map<String, dynamic> json) =
      _$RealEstateTransactionEventImpl.fromJson;

  @override
  String get id;
  @override
  EventTiming get timing;
  String? get assetSoldId; // Real estate asset being sold
  String? get assetPurchasedId; // Real estate asset being purchased
  String
  get withdrawAccountId; // Cash account to withdraw from (for purchase) or deposit to (for sale)
  String get depositAccountId;

  /// Create a copy of Event
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RealEstateTransactionEventImplCopyWith<_$RealEstateTransactionEventImpl>
  get copyWith => throw _privateConstructorUsedError;
}
