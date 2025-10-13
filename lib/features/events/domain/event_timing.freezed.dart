// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'event_timing.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

EventTiming _$EventTimingFromJson(Map<String, dynamic> json) {
  switch (json['runtimeType']) {
    case 'relative':
      return RelativeTiming.fromJson(json);
    case 'absolute':
      return AbsoluteTiming.fromJson(json);
    case 'age':
      return AgeTiming.fromJson(json);
    case 'eventRelative':
      return EventRelativeTiming.fromJson(json);

    default:
      throw CheckedFromJsonException(
        json,
        'runtimeType',
        'EventTiming',
        'Invalid union type "${json['runtimeType']}"!',
      );
  }
}

/// @nodoc
mixin _$EventTiming {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(int yearsFromStart) relative,
    required TResult Function(int calendarYear) absolute,
    required TResult Function(String individualId, int age) age,
    required TResult Function(String eventId, EventBoundary boundary)
    eventRelative,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(int yearsFromStart)? relative,
    TResult? Function(int calendarYear)? absolute,
    TResult? Function(String individualId, int age)? age,
    TResult? Function(String eventId, EventBoundary boundary)? eventRelative,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(int yearsFromStart)? relative,
    TResult Function(int calendarYear)? absolute,
    TResult Function(String individualId, int age)? age,
    TResult Function(String eventId, EventBoundary boundary)? eventRelative,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(RelativeTiming value) relative,
    required TResult Function(AbsoluteTiming value) absolute,
    required TResult Function(AgeTiming value) age,
    required TResult Function(EventRelativeTiming value) eventRelative,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(RelativeTiming value)? relative,
    TResult? Function(AbsoluteTiming value)? absolute,
    TResult? Function(AgeTiming value)? age,
    TResult? Function(EventRelativeTiming value)? eventRelative,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(RelativeTiming value)? relative,
    TResult Function(AbsoluteTiming value)? absolute,
    TResult Function(AgeTiming value)? age,
    TResult Function(EventRelativeTiming value)? eventRelative,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;

  /// Serializes this EventTiming to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EventTimingCopyWith<$Res> {
  factory $EventTimingCopyWith(
    EventTiming value,
    $Res Function(EventTiming) then,
  ) = _$EventTimingCopyWithImpl<$Res, EventTiming>;
}

/// @nodoc
class _$EventTimingCopyWithImpl<$Res, $Val extends EventTiming>
    implements $EventTimingCopyWith<$Res> {
  _$EventTimingCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of EventTiming
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$RelativeTimingImplCopyWith<$Res> {
  factory _$$RelativeTimingImplCopyWith(
    _$RelativeTimingImpl value,
    $Res Function(_$RelativeTimingImpl) then,
  ) = __$$RelativeTimingImplCopyWithImpl<$Res>;
  @useResult
  $Res call({int yearsFromStart});
}

/// @nodoc
class __$$RelativeTimingImplCopyWithImpl<$Res>
    extends _$EventTimingCopyWithImpl<$Res, _$RelativeTimingImpl>
    implements _$$RelativeTimingImplCopyWith<$Res> {
  __$$RelativeTimingImplCopyWithImpl(
    _$RelativeTimingImpl _value,
    $Res Function(_$RelativeTimingImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of EventTiming
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? yearsFromStart = null}) {
    return _then(
      _$RelativeTimingImpl(
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
class _$RelativeTimingImpl implements RelativeTiming {
  const _$RelativeTimingImpl({
    required this.yearsFromStart,
    final String? $type,
  }) : $type = $type ?? 'relative';

  factory _$RelativeTimingImpl.fromJson(Map<String, dynamic> json) =>
      _$$RelativeTimingImplFromJson(json);

  @override
  final int yearsFromStart;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'EventTiming.relative(yearsFromStart: $yearsFromStart)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RelativeTimingImpl &&
            (identical(other.yearsFromStart, yearsFromStart) ||
                other.yearsFromStart == yearsFromStart));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, yearsFromStart);

  /// Create a copy of EventTiming
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RelativeTimingImplCopyWith<_$RelativeTimingImpl> get copyWith =>
      __$$RelativeTimingImplCopyWithImpl<_$RelativeTimingImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(int yearsFromStart) relative,
    required TResult Function(int calendarYear) absolute,
    required TResult Function(String individualId, int age) age,
    required TResult Function(String eventId, EventBoundary boundary)
    eventRelative,
  }) {
    return relative(yearsFromStart);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(int yearsFromStart)? relative,
    TResult? Function(int calendarYear)? absolute,
    TResult? Function(String individualId, int age)? age,
    TResult? Function(String eventId, EventBoundary boundary)? eventRelative,
  }) {
    return relative?.call(yearsFromStart);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(int yearsFromStart)? relative,
    TResult Function(int calendarYear)? absolute,
    TResult Function(String individualId, int age)? age,
    TResult Function(String eventId, EventBoundary boundary)? eventRelative,
    required TResult orElse(),
  }) {
    if (relative != null) {
      return relative(yearsFromStart);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(RelativeTiming value) relative,
    required TResult Function(AbsoluteTiming value) absolute,
    required TResult Function(AgeTiming value) age,
    required TResult Function(EventRelativeTiming value) eventRelative,
  }) {
    return relative(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(RelativeTiming value)? relative,
    TResult? Function(AbsoluteTiming value)? absolute,
    TResult? Function(AgeTiming value)? age,
    TResult? Function(EventRelativeTiming value)? eventRelative,
  }) {
    return relative?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(RelativeTiming value)? relative,
    TResult Function(AbsoluteTiming value)? absolute,
    TResult Function(AgeTiming value)? age,
    TResult Function(EventRelativeTiming value)? eventRelative,
    required TResult orElse(),
  }) {
    if (relative != null) {
      return relative(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$RelativeTimingImplToJson(this);
  }
}

abstract class RelativeTiming implements EventTiming {
  const factory RelativeTiming({required final int yearsFromStart}) =
      _$RelativeTimingImpl;

  factory RelativeTiming.fromJson(Map<String, dynamic> json) =
      _$RelativeTimingImpl.fromJson;

  int get yearsFromStart;

  /// Create a copy of EventTiming
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RelativeTimingImplCopyWith<_$RelativeTimingImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$AbsoluteTimingImplCopyWith<$Res> {
  factory _$$AbsoluteTimingImplCopyWith(
    _$AbsoluteTimingImpl value,
    $Res Function(_$AbsoluteTimingImpl) then,
  ) = __$$AbsoluteTimingImplCopyWithImpl<$Res>;
  @useResult
  $Res call({int calendarYear});
}

/// @nodoc
class __$$AbsoluteTimingImplCopyWithImpl<$Res>
    extends _$EventTimingCopyWithImpl<$Res, _$AbsoluteTimingImpl>
    implements _$$AbsoluteTimingImplCopyWith<$Res> {
  __$$AbsoluteTimingImplCopyWithImpl(
    _$AbsoluteTimingImpl _value,
    $Res Function(_$AbsoluteTimingImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of EventTiming
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? calendarYear = null}) {
    return _then(
      _$AbsoluteTimingImpl(
        calendarYear: null == calendarYear
            ? _value.calendarYear
            : calendarYear // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AbsoluteTimingImpl implements AbsoluteTiming {
  const _$AbsoluteTimingImpl({required this.calendarYear, final String? $type})
    : $type = $type ?? 'absolute';

  factory _$AbsoluteTimingImpl.fromJson(Map<String, dynamic> json) =>
      _$$AbsoluteTimingImplFromJson(json);

  @override
  final int calendarYear;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'EventTiming.absolute(calendarYear: $calendarYear)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AbsoluteTimingImpl &&
            (identical(other.calendarYear, calendarYear) ||
                other.calendarYear == calendarYear));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, calendarYear);

  /// Create a copy of EventTiming
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AbsoluteTimingImplCopyWith<_$AbsoluteTimingImpl> get copyWith =>
      __$$AbsoluteTimingImplCopyWithImpl<_$AbsoluteTimingImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(int yearsFromStart) relative,
    required TResult Function(int calendarYear) absolute,
    required TResult Function(String individualId, int age) age,
    required TResult Function(String eventId, EventBoundary boundary)
    eventRelative,
  }) {
    return absolute(calendarYear);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(int yearsFromStart)? relative,
    TResult? Function(int calendarYear)? absolute,
    TResult? Function(String individualId, int age)? age,
    TResult? Function(String eventId, EventBoundary boundary)? eventRelative,
  }) {
    return absolute?.call(calendarYear);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(int yearsFromStart)? relative,
    TResult Function(int calendarYear)? absolute,
    TResult Function(String individualId, int age)? age,
    TResult Function(String eventId, EventBoundary boundary)? eventRelative,
    required TResult orElse(),
  }) {
    if (absolute != null) {
      return absolute(calendarYear);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(RelativeTiming value) relative,
    required TResult Function(AbsoluteTiming value) absolute,
    required TResult Function(AgeTiming value) age,
    required TResult Function(EventRelativeTiming value) eventRelative,
  }) {
    return absolute(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(RelativeTiming value)? relative,
    TResult? Function(AbsoluteTiming value)? absolute,
    TResult? Function(AgeTiming value)? age,
    TResult? Function(EventRelativeTiming value)? eventRelative,
  }) {
    return absolute?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(RelativeTiming value)? relative,
    TResult Function(AbsoluteTiming value)? absolute,
    TResult Function(AgeTiming value)? age,
    TResult Function(EventRelativeTiming value)? eventRelative,
    required TResult orElse(),
  }) {
    if (absolute != null) {
      return absolute(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$AbsoluteTimingImplToJson(this);
  }
}

abstract class AbsoluteTiming implements EventTiming {
  const factory AbsoluteTiming({required final int calendarYear}) =
      _$AbsoluteTimingImpl;

  factory AbsoluteTiming.fromJson(Map<String, dynamic> json) =
      _$AbsoluteTimingImpl.fromJson;

  int get calendarYear;

  /// Create a copy of EventTiming
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AbsoluteTimingImplCopyWith<_$AbsoluteTimingImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$AgeTimingImplCopyWith<$Res> {
  factory _$$AgeTimingImplCopyWith(
    _$AgeTimingImpl value,
    $Res Function(_$AgeTimingImpl) then,
  ) = __$$AgeTimingImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String individualId, int age});
}

/// @nodoc
class __$$AgeTimingImplCopyWithImpl<$Res>
    extends _$EventTimingCopyWithImpl<$Res, _$AgeTimingImpl>
    implements _$$AgeTimingImplCopyWith<$Res> {
  __$$AgeTimingImplCopyWithImpl(
    _$AgeTimingImpl _value,
    $Res Function(_$AgeTimingImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of EventTiming
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? individualId = null, Object? age = null}) {
    return _then(
      _$AgeTimingImpl(
        individualId: null == individualId
            ? _value.individualId
            : individualId // ignore: cast_nullable_to_non_nullable
                  as String,
        age: null == age
            ? _value.age
            : age // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AgeTimingImpl implements AgeTiming {
  const _$AgeTimingImpl({
    required this.individualId,
    required this.age,
    final String? $type,
  }) : $type = $type ?? 'age';

  factory _$AgeTimingImpl.fromJson(Map<String, dynamic> json) =>
      _$$AgeTimingImplFromJson(json);

  @override
  final String individualId;
  @override
  final int age;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'EventTiming.age(individualId: $individualId, age: $age)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AgeTimingImpl &&
            (identical(other.individualId, individualId) ||
                other.individualId == individualId) &&
            (identical(other.age, age) || other.age == age));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, individualId, age);

  /// Create a copy of EventTiming
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AgeTimingImplCopyWith<_$AgeTimingImpl> get copyWith =>
      __$$AgeTimingImplCopyWithImpl<_$AgeTimingImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(int yearsFromStart) relative,
    required TResult Function(int calendarYear) absolute,
    required TResult Function(String individualId, int age) age,
    required TResult Function(String eventId, EventBoundary boundary)
    eventRelative,
  }) {
    return age(individualId, this.age);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(int yearsFromStart)? relative,
    TResult? Function(int calendarYear)? absolute,
    TResult? Function(String individualId, int age)? age,
    TResult? Function(String eventId, EventBoundary boundary)? eventRelative,
  }) {
    return age?.call(individualId, this.age);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(int yearsFromStart)? relative,
    TResult Function(int calendarYear)? absolute,
    TResult Function(String individualId, int age)? age,
    TResult Function(String eventId, EventBoundary boundary)? eventRelative,
    required TResult orElse(),
  }) {
    if (age != null) {
      return age(individualId, this.age);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(RelativeTiming value) relative,
    required TResult Function(AbsoluteTiming value) absolute,
    required TResult Function(AgeTiming value) age,
    required TResult Function(EventRelativeTiming value) eventRelative,
  }) {
    return age(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(RelativeTiming value)? relative,
    TResult? Function(AbsoluteTiming value)? absolute,
    TResult? Function(AgeTiming value)? age,
    TResult? Function(EventRelativeTiming value)? eventRelative,
  }) {
    return age?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(RelativeTiming value)? relative,
    TResult Function(AbsoluteTiming value)? absolute,
    TResult Function(AgeTiming value)? age,
    TResult Function(EventRelativeTiming value)? eventRelative,
    required TResult orElse(),
  }) {
    if (age != null) {
      return age(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$AgeTimingImplToJson(this);
  }
}

abstract class AgeTiming implements EventTiming {
  const factory AgeTiming({
    required final String individualId,
    required final int age,
  }) = _$AgeTimingImpl;

  factory AgeTiming.fromJson(Map<String, dynamic> json) =
      _$AgeTimingImpl.fromJson;

  String get individualId;
  int get age;

  /// Create a copy of EventTiming
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AgeTimingImplCopyWith<_$AgeTimingImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$EventRelativeTimingImplCopyWith<$Res> {
  factory _$$EventRelativeTimingImplCopyWith(
    _$EventRelativeTimingImpl value,
    $Res Function(_$EventRelativeTimingImpl) then,
  ) = __$$EventRelativeTimingImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String eventId, EventBoundary boundary});
}

/// @nodoc
class __$$EventRelativeTimingImplCopyWithImpl<$Res>
    extends _$EventTimingCopyWithImpl<$Res, _$EventRelativeTimingImpl>
    implements _$$EventRelativeTimingImplCopyWith<$Res> {
  __$$EventRelativeTimingImplCopyWithImpl(
    _$EventRelativeTimingImpl _value,
    $Res Function(_$EventRelativeTimingImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of EventTiming
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? eventId = null, Object? boundary = null}) {
    return _then(
      _$EventRelativeTimingImpl(
        eventId: null == eventId
            ? _value.eventId
            : eventId // ignore: cast_nullable_to_non_nullable
                  as String,
        boundary: null == boundary
            ? _value.boundary
            : boundary // ignore: cast_nullable_to_non_nullable
                  as EventBoundary,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$EventRelativeTimingImpl implements EventRelativeTiming {
  const _$EventRelativeTimingImpl({
    required this.eventId,
    required this.boundary,
    final String? $type,
  }) : $type = $type ?? 'eventRelative';

  factory _$EventRelativeTimingImpl.fromJson(Map<String, dynamic> json) =>
      _$$EventRelativeTimingImplFromJson(json);

  @override
  final String eventId;
  @override
  final EventBoundary boundary;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'EventTiming.eventRelative(eventId: $eventId, boundary: $boundary)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EventRelativeTimingImpl &&
            (identical(other.eventId, eventId) || other.eventId == eventId) &&
            (identical(other.boundary, boundary) ||
                other.boundary == boundary));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, eventId, boundary);

  /// Create a copy of EventTiming
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$EventRelativeTimingImplCopyWith<_$EventRelativeTimingImpl> get copyWith =>
      __$$EventRelativeTimingImplCopyWithImpl<_$EventRelativeTimingImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(int yearsFromStart) relative,
    required TResult Function(int calendarYear) absolute,
    required TResult Function(String individualId, int age) age,
    required TResult Function(String eventId, EventBoundary boundary)
    eventRelative,
  }) {
    return eventRelative(eventId, boundary);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(int yearsFromStart)? relative,
    TResult? Function(int calendarYear)? absolute,
    TResult? Function(String individualId, int age)? age,
    TResult? Function(String eventId, EventBoundary boundary)? eventRelative,
  }) {
    return eventRelative?.call(eventId, boundary);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(int yearsFromStart)? relative,
    TResult Function(int calendarYear)? absolute,
    TResult Function(String individualId, int age)? age,
    TResult Function(String eventId, EventBoundary boundary)? eventRelative,
    required TResult orElse(),
  }) {
    if (eventRelative != null) {
      return eventRelative(eventId, boundary);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(RelativeTiming value) relative,
    required TResult Function(AbsoluteTiming value) absolute,
    required TResult Function(AgeTiming value) age,
    required TResult Function(EventRelativeTiming value) eventRelative,
  }) {
    return eventRelative(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(RelativeTiming value)? relative,
    TResult? Function(AbsoluteTiming value)? absolute,
    TResult? Function(AgeTiming value)? age,
    TResult? Function(EventRelativeTiming value)? eventRelative,
  }) {
    return eventRelative?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(RelativeTiming value)? relative,
    TResult Function(AbsoluteTiming value)? absolute,
    TResult Function(AgeTiming value)? age,
    TResult Function(EventRelativeTiming value)? eventRelative,
    required TResult orElse(),
  }) {
    if (eventRelative != null) {
      return eventRelative(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$EventRelativeTimingImplToJson(this);
  }
}

abstract class EventRelativeTiming implements EventTiming {
  const factory EventRelativeTiming({
    required final String eventId,
    required final EventBoundary boundary,
  }) = _$EventRelativeTimingImpl;

  factory EventRelativeTiming.fromJson(Map<String, dynamic> json) =
      _$EventRelativeTimingImpl.fromJson;

  String get eventId;
  EventBoundary get boundary;

  /// Create a copy of EventTiming
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EventRelativeTimingImplCopyWith<_$EventRelativeTimingImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
