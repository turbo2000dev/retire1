// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'asset.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Asset _$AssetFromJson(Map<String, dynamic> json) {
  switch (json['runtimeType']) {
    case 'realEstate':
      return RealEstateAsset.fromJson(json);
    case 'rrsp':
      return RRSPAccount.fromJson(json);
    case 'celi':
      return CELIAccount.fromJson(json);
    case 'cri':
      return CRIAccount.fromJson(json);
    case 'cash':
      return CashAccount.fromJson(json);

    default:
      throw CheckedFromJsonException(
        json,
        'runtimeType',
        'Asset',
        'Invalid union type "${json['runtimeType']}"!',
      );
  }
}

/// @nodoc
mixin _$Asset {
  String get id => throw _privateConstructorUsedError;
  double get value => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
      String id,
      RealEstateType type,
      double value,
      bool setAtStart,
    )
    realEstate,
    required TResult Function(
      String id,
      String individualId,
      double value,
      double? customReturnRate,
      double? annualContribution,
    )
    rrsp,
    required TResult Function(
      String id,
      String individualId,
      double value,
      double? customReturnRate,
      double? annualContribution,
    )
    celi,
    required TResult Function(
      String id,
      String individualId,
      double value,
      double? contributionRoom,
      double? customReturnRate,
      double? annualContribution,
    )
    cri,
    required TResult Function(
      String id,
      String individualId,
      double value,
      double? customReturnRate,
      double? annualContribution,
    )
    cash,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
      String id,
      RealEstateType type,
      double value,
      bool setAtStart,
    )?
    realEstate,
    TResult? Function(
      String id,
      String individualId,
      double value,
      double? customReturnRate,
      double? annualContribution,
    )?
    rrsp,
    TResult? Function(
      String id,
      String individualId,
      double value,
      double? customReturnRate,
      double? annualContribution,
    )?
    celi,
    TResult? Function(
      String id,
      String individualId,
      double value,
      double? contributionRoom,
      double? customReturnRate,
      double? annualContribution,
    )?
    cri,
    TResult? Function(
      String id,
      String individualId,
      double value,
      double? customReturnRate,
      double? annualContribution,
    )?
    cash,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
      String id,
      RealEstateType type,
      double value,
      bool setAtStart,
    )?
    realEstate,
    TResult Function(
      String id,
      String individualId,
      double value,
      double? customReturnRate,
      double? annualContribution,
    )?
    rrsp,
    TResult Function(
      String id,
      String individualId,
      double value,
      double? customReturnRate,
      double? annualContribution,
    )?
    celi,
    TResult Function(
      String id,
      String individualId,
      double value,
      double? contributionRoom,
      double? customReturnRate,
      double? annualContribution,
    )?
    cri,
    TResult Function(
      String id,
      String individualId,
      double value,
      double? customReturnRate,
      double? annualContribution,
    )?
    cash,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(RealEstateAsset value) realEstate,
    required TResult Function(RRSPAccount value) rrsp,
    required TResult Function(CELIAccount value) celi,
    required TResult Function(CRIAccount value) cri,
    required TResult Function(CashAccount value) cash,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(RealEstateAsset value)? realEstate,
    TResult? Function(RRSPAccount value)? rrsp,
    TResult? Function(CELIAccount value)? celi,
    TResult? Function(CRIAccount value)? cri,
    TResult? Function(CashAccount value)? cash,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(RealEstateAsset value)? realEstate,
    TResult Function(RRSPAccount value)? rrsp,
    TResult Function(CELIAccount value)? celi,
    TResult Function(CRIAccount value)? cri,
    TResult Function(CashAccount value)? cash,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;

  /// Serializes this Asset to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Asset
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AssetCopyWith<Asset> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AssetCopyWith<$Res> {
  factory $AssetCopyWith(Asset value, $Res Function(Asset) then) =
      _$AssetCopyWithImpl<$Res, Asset>;
  @useResult
  $Res call({String id, double value});
}

/// @nodoc
class _$AssetCopyWithImpl<$Res, $Val extends Asset>
    implements $AssetCopyWith<$Res> {
  _$AssetCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Asset
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
abstract class _$$RealEstateAssetImplCopyWith<$Res>
    implements $AssetCopyWith<$Res> {
  factory _$$RealEstateAssetImplCopyWith(
    _$RealEstateAssetImpl value,
    $Res Function(_$RealEstateAssetImpl) then,
  ) = __$$RealEstateAssetImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, RealEstateType type, double value, bool setAtStart});
}

/// @nodoc
class __$$RealEstateAssetImplCopyWithImpl<$Res>
    extends _$AssetCopyWithImpl<$Res, _$RealEstateAssetImpl>
    implements _$$RealEstateAssetImplCopyWith<$Res> {
  __$$RealEstateAssetImplCopyWithImpl(
    _$RealEstateAssetImpl _value,
    $Res Function(_$RealEstateAssetImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Asset
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? value = null,
    Object? setAtStart = null,
  }) {
    return _then(
      _$RealEstateAssetImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as RealEstateType,
        value: null == value
            ? _value.value
            : value // ignore: cast_nullable_to_non_nullable
                  as double,
        setAtStart: null == setAtStart
            ? _value.setAtStart
            : setAtStart // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$RealEstateAssetImpl implements RealEstateAsset {
  const _$RealEstateAssetImpl({
    required this.id,
    required this.type,
    required this.value,
    this.setAtStart = false,
    final String? $type,
  }) : $type = $type ?? 'realEstate';

  factory _$RealEstateAssetImpl.fromJson(Map<String, dynamic> json) =>
      _$$RealEstateAssetImplFromJson(json);

  @override
  final String id;
  @override
  final RealEstateType type;
  @override
  final double value;
  @override
  @JsonKey()
  final bool setAtStart;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'Asset.realEstate(id: $id, type: $type, value: $value, setAtStart: $setAtStart)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RealEstateAssetImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.value, value) || other.value == value) &&
            (identical(other.setAtStart, setAtStart) ||
                other.setAtStart == setAtStart));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, type, value, setAtStart);

  /// Create a copy of Asset
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RealEstateAssetImplCopyWith<_$RealEstateAssetImpl> get copyWith =>
      __$$RealEstateAssetImplCopyWithImpl<_$RealEstateAssetImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
      String id,
      RealEstateType type,
      double value,
      bool setAtStart,
    )
    realEstate,
    required TResult Function(
      String id,
      String individualId,
      double value,
      double? customReturnRate,
      double? annualContribution,
    )
    rrsp,
    required TResult Function(
      String id,
      String individualId,
      double value,
      double? customReturnRate,
      double? annualContribution,
    )
    celi,
    required TResult Function(
      String id,
      String individualId,
      double value,
      double? contributionRoom,
      double? customReturnRate,
      double? annualContribution,
    )
    cri,
    required TResult Function(
      String id,
      String individualId,
      double value,
      double? customReturnRate,
      double? annualContribution,
    )
    cash,
  }) {
    return realEstate(id, type, value, setAtStart);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
      String id,
      RealEstateType type,
      double value,
      bool setAtStart,
    )?
    realEstate,
    TResult? Function(
      String id,
      String individualId,
      double value,
      double? customReturnRate,
      double? annualContribution,
    )?
    rrsp,
    TResult? Function(
      String id,
      String individualId,
      double value,
      double? customReturnRate,
      double? annualContribution,
    )?
    celi,
    TResult? Function(
      String id,
      String individualId,
      double value,
      double? contributionRoom,
      double? customReturnRate,
      double? annualContribution,
    )?
    cri,
    TResult? Function(
      String id,
      String individualId,
      double value,
      double? customReturnRate,
      double? annualContribution,
    )?
    cash,
  }) {
    return realEstate?.call(id, type, value, setAtStart);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
      String id,
      RealEstateType type,
      double value,
      bool setAtStart,
    )?
    realEstate,
    TResult Function(
      String id,
      String individualId,
      double value,
      double? customReturnRate,
      double? annualContribution,
    )?
    rrsp,
    TResult Function(
      String id,
      String individualId,
      double value,
      double? customReturnRate,
      double? annualContribution,
    )?
    celi,
    TResult Function(
      String id,
      String individualId,
      double value,
      double? contributionRoom,
      double? customReturnRate,
      double? annualContribution,
    )?
    cri,
    TResult Function(
      String id,
      String individualId,
      double value,
      double? customReturnRate,
      double? annualContribution,
    )?
    cash,
    required TResult orElse(),
  }) {
    if (realEstate != null) {
      return realEstate(id, type, value, setAtStart);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(RealEstateAsset value) realEstate,
    required TResult Function(RRSPAccount value) rrsp,
    required TResult Function(CELIAccount value) celi,
    required TResult Function(CRIAccount value) cri,
    required TResult Function(CashAccount value) cash,
  }) {
    return realEstate(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(RealEstateAsset value)? realEstate,
    TResult? Function(RRSPAccount value)? rrsp,
    TResult? Function(CELIAccount value)? celi,
    TResult? Function(CRIAccount value)? cri,
    TResult? Function(CashAccount value)? cash,
  }) {
    return realEstate?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(RealEstateAsset value)? realEstate,
    TResult Function(RRSPAccount value)? rrsp,
    TResult Function(CELIAccount value)? celi,
    TResult Function(CRIAccount value)? cri,
    TResult Function(CashAccount value)? cash,
    required TResult orElse(),
  }) {
    if (realEstate != null) {
      return realEstate(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$RealEstateAssetImplToJson(this);
  }
}

abstract class RealEstateAsset implements Asset {
  const factory RealEstateAsset({
    required final String id,
    required final RealEstateType type,
    required final double value,
    final bool setAtStart,
  }) = _$RealEstateAssetImpl;

  factory RealEstateAsset.fromJson(Map<String, dynamic> json) =
      _$RealEstateAssetImpl.fromJson;

  @override
  String get id;
  RealEstateType get type;
  @override
  double get value;
  bool get setAtStart;

  /// Create a copy of Asset
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RealEstateAssetImplCopyWith<_$RealEstateAssetImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$RRSPAccountImplCopyWith<$Res>
    implements $AssetCopyWith<$Res> {
  factory _$$RRSPAccountImplCopyWith(
    _$RRSPAccountImpl value,
    $Res Function(_$RRSPAccountImpl) then,
  ) = __$$RRSPAccountImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String individualId,
    double value,
    double? customReturnRate,
    double? annualContribution,
  });
}

/// @nodoc
class __$$RRSPAccountImplCopyWithImpl<$Res>
    extends _$AssetCopyWithImpl<$Res, _$RRSPAccountImpl>
    implements _$$RRSPAccountImplCopyWith<$Res> {
  __$$RRSPAccountImplCopyWithImpl(
    _$RRSPAccountImpl _value,
    $Res Function(_$RRSPAccountImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Asset
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? individualId = null,
    Object? value = null,
    Object? customReturnRate = freezed,
    Object? annualContribution = freezed,
  }) {
    return _then(
      _$RRSPAccountImpl(
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
        customReturnRate: freezed == customReturnRate
            ? _value.customReturnRate
            : customReturnRate // ignore: cast_nullable_to_non_nullable
                  as double?,
        annualContribution: freezed == annualContribution
            ? _value.annualContribution
            : annualContribution // ignore: cast_nullable_to_non_nullable
                  as double?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$RRSPAccountImpl implements RRSPAccount {
  const _$RRSPAccountImpl({
    required this.id,
    required this.individualId,
    required this.value,
    this.customReturnRate,
    this.annualContribution,
    final String? $type,
  }) : $type = $type ?? 'rrsp';

  factory _$RRSPAccountImpl.fromJson(Map<String, dynamic> json) =>
      _$$RRSPAccountImplFromJson(json);

  @override
  final String id;
  @override
  final String individualId;
  @override
  final double value;
  @override
  final double? customReturnRate;
  @override
  final double? annualContribution;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'Asset.rrsp(id: $id, individualId: $individualId, value: $value, customReturnRate: $customReturnRate, annualContribution: $annualContribution)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RRSPAccountImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.individualId, individualId) ||
                other.individualId == individualId) &&
            (identical(other.value, value) || other.value == value) &&
            (identical(other.customReturnRate, customReturnRate) ||
                other.customReturnRate == customReturnRate) &&
            (identical(other.annualContribution, annualContribution) ||
                other.annualContribution == annualContribution));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    individualId,
    value,
    customReturnRate,
    annualContribution,
  );

  /// Create a copy of Asset
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RRSPAccountImplCopyWith<_$RRSPAccountImpl> get copyWith =>
      __$$RRSPAccountImplCopyWithImpl<_$RRSPAccountImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
      String id,
      RealEstateType type,
      double value,
      bool setAtStart,
    )
    realEstate,
    required TResult Function(
      String id,
      String individualId,
      double value,
      double? customReturnRate,
      double? annualContribution,
    )
    rrsp,
    required TResult Function(
      String id,
      String individualId,
      double value,
      double? customReturnRate,
      double? annualContribution,
    )
    celi,
    required TResult Function(
      String id,
      String individualId,
      double value,
      double? contributionRoom,
      double? customReturnRate,
      double? annualContribution,
    )
    cri,
    required TResult Function(
      String id,
      String individualId,
      double value,
      double? customReturnRate,
      double? annualContribution,
    )
    cash,
  }) {
    return rrsp(id, individualId, value, customReturnRate, annualContribution);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
      String id,
      RealEstateType type,
      double value,
      bool setAtStart,
    )?
    realEstate,
    TResult? Function(
      String id,
      String individualId,
      double value,
      double? customReturnRate,
      double? annualContribution,
    )?
    rrsp,
    TResult? Function(
      String id,
      String individualId,
      double value,
      double? customReturnRate,
      double? annualContribution,
    )?
    celi,
    TResult? Function(
      String id,
      String individualId,
      double value,
      double? contributionRoom,
      double? customReturnRate,
      double? annualContribution,
    )?
    cri,
    TResult? Function(
      String id,
      String individualId,
      double value,
      double? customReturnRate,
      double? annualContribution,
    )?
    cash,
  }) {
    return rrsp?.call(
      id,
      individualId,
      value,
      customReturnRate,
      annualContribution,
    );
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
      String id,
      RealEstateType type,
      double value,
      bool setAtStart,
    )?
    realEstate,
    TResult Function(
      String id,
      String individualId,
      double value,
      double? customReturnRate,
      double? annualContribution,
    )?
    rrsp,
    TResult Function(
      String id,
      String individualId,
      double value,
      double? customReturnRate,
      double? annualContribution,
    )?
    celi,
    TResult Function(
      String id,
      String individualId,
      double value,
      double? contributionRoom,
      double? customReturnRate,
      double? annualContribution,
    )?
    cri,
    TResult Function(
      String id,
      String individualId,
      double value,
      double? customReturnRate,
      double? annualContribution,
    )?
    cash,
    required TResult orElse(),
  }) {
    if (rrsp != null) {
      return rrsp(
        id,
        individualId,
        value,
        customReturnRate,
        annualContribution,
      );
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(RealEstateAsset value) realEstate,
    required TResult Function(RRSPAccount value) rrsp,
    required TResult Function(CELIAccount value) celi,
    required TResult Function(CRIAccount value) cri,
    required TResult Function(CashAccount value) cash,
  }) {
    return rrsp(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(RealEstateAsset value)? realEstate,
    TResult? Function(RRSPAccount value)? rrsp,
    TResult? Function(CELIAccount value)? celi,
    TResult? Function(CRIAccount value)? cri,
    TResult? Function(CashAccount value)? cash,
  }) {
    return rrsp?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(RealEstateAsset value)? realEstate,
    TResult Function(RRSPAccount value)? rrsp,
    TResult Function(CELIAccount value)? celi,
    TResult Function(CRIAccount value)? cri,
    TResult Function(CashAccount value)? cash,
    required TResult orElse(),
  }) {
    if (rrsp != null) {
      return rrsp(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$RRSPAccountImplToJson(this);
  }
}

abstract class RRSPAccount implements Asset {
  const factory RRSPAccount({
    required final String id,
    required final String individualId,
    required final double value,
    final double? customReturnRate,
    final double? annualContribution,
  }) = _$RRSPAccountImpl;

  factory RRSPAccount.fromJson(Map<String, dynamic> json) =
      _$RRSPAccountImpl.fromJson;

  @override
  String get id;
  String get individualId;
  @override
  double get value;
  double? get customReturnRate;
  double? get annualContribution;

  /// Create a copy of Asset
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RRSPAccountImplCopyWith<_$RRSPAccountImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$CELIAccountImplCopyWith<$Res>
    implements $AssetCopyWith<$Res> {
  factory _$$CELIAccountImplCopyWith(
    _$CELIAccountImpl value,
    $Res Function(_$CELIAccountImpl) then,
  ) = __$$CELIAccountImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String individualId,
    double value,
    double? customReturnRate,
    double? annualContribution,
  });
}

/// @nodoc
class __$$CELIAccountImplCopyWithImpl<$Res>
    extends _$AssetCopyWithImpl<$Res, _$CELIAccountImpl>
    implements _$$CELIAccountImplCopyWith<$Res> {
  __$$CELIAccountImplCopyWithImpl(
    _$CELIAccountImpl _value,
    $Res Function(_$CELIAccountImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Asset
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? individualId = null,
    Object? value = null,
    Object? customReturnRate = freezed,
    Object? annualContribution = freezed,
  }) {
    return _then(
      _$CELIAccountImpl(
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
        customReturnRate: freezed == customReturnRate
            ? _value.customReturnRate
            : customReturnRate // ignore: cast_nullable_to_non_nullable
                  as double?,
        annualContribution: freezed == annualContribution
            ? _value.annualContribution
            : annualContribution // ignore: cast_nullable_to_non_nullable
                  as double?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CELIAccountImpl implements CELIAccount {
  const _$CELIAccountImpl({
    required this.id,
    required this.individualId,
    required this.value,
    this.customReturnRate,
    this.annualContribution,
    final String? $type,
  }) : $type = $type ?? 'celi';

  factory _$CELIAccountImpl.fromJson(Map<String, dynamic> json) =>
      _$$CELIAccountImplFromJson(json);

  @override
  final String id;
  @override
  final String individualId;
  @override
  final double value;
  @override
  final double? customReturnRate;
  @override
  final double? annualContribution;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'Asset.celi(id: $id, individualId: $individualId, value: $value, customReturnRate: $customReturnRate, annualContribution: $annualContribution)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CELIAccountImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.individualId, individualId) ||
                other.individualId == individualId) &&
            (identical(other.value, value) || other.value == value) &&
            (identical(other.customReturnRate, customReturnRate) ||
                other.customReturnRate == customReturnRate) &&
            (identical(other.annualContribution, annualContribution) ||
                other.annualContribution == annualContribution));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    individualId,
    value,
    customReturnRate,
    annualContribution,
  );

  /// Create a copy of Asset
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CELIAccountImplCopyWith<_$CELIAccountImpl> get copyWith =>
      __$$CELIAccountImplCopyWithImpl<_$CELIAccountImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
      String id,
      RealEstateType type,
      double value,
      bool setAtStart,
    )
    realEstate,
    required TResult Function(
      String id,
      String individualId,
      double value,
      double? customReturnRate,
      double? annualContribution,
    )
    rrsp,
    required TResult Function(
      String id,
      String individualId,
      double value,
      double? customReturnRate,
      double? annualContribution,
    )
    celi,
    required TResult Function(
      String id,
      String individualId,
      double value,
      double? contributionRoom,
      double? customReturnRate,
      double? annualContribution,
    )
    cri,
    required TResult Function(
      String id,
      String individualId,
      double value,
      double? customReturnRate,
      double? annualContribution,
    )
    cash,
  }) {
    return celi(id, individualId, value, customReturnRate, annualContribution);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
      String id,
      RealEstateType type,
      double value,
      bool setAtStart,
    )?
    realEstate,
    TResult? Function(
      String id,
      String individualId,
      double value,
      double? customReturnRate,
      double? annualContribution,
    )?
    rrsp,
    TResult? Function(
      String id,
      String individualId,
      double value,
      double? customReturnRate,
      double? annualContribution,
    )?
    celi,
    TResult? Function(
      String id,
      String individualId,
      double value,
      double? contributionRoom,
      double? customReturnRate,
      double? annualContribution,
    )?
    cri,
    TResult? Function(
      String id,
      String individualId,
      double value,
      double? customReturnRate,
      double? annualContribution,
    )?
    cash,
  }) {
    return celi?.call(
      id,
      individualId,
      value,
      customReturnRate,
      annualContribution,
    );
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
      String id,
      RealEstateType type,
      double value,
      bool setAtStart,
    )?
    realEstate,
    TResult Function(
      String id,
      String individualId,
      double value,
      double? customReturnRate,
      double? annualContribution,
    )?
    rrsp,
    TResult Function(
      String id,
      String individualId,
      double value,
      double? customReturnRate,
      double? annualContribution,
    )?
    celi,
    TResult Function(
      String id,
      String individualId,
      double value,
      double? contributionRoom,
      double? customReturnRate,
      double? annualContribution,
    )?
    cri,
    TResult Function(
      String id,
      String individualId,
      double value,
      double? customReturnRate,
      double? annualContribution,
    )?
    cash,
    required TResult orElse(),
  }) {
    if (celi != null) {
      return celi(
        id,
        individualId,
        value,
        customReturnRate,
        annualContribution,
      );
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(RealEstateAsset value) realEstate,
    required TResult Function(RRSPAccount value) rrsp,
    required TResult Function(CELIAccount value) celi,
    required TResult Function(CRIAccount value) cri,
    required TResult Function(CashAccount value) cash,
  }) {
    return celi(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(RealEstateAsset value)? realEstate,
    TResult? Function(RRSPAccount value)? rrsp,
    TResult? Function(CELIAccount value)? celi,
    TResult? Function(CRIAccount value)? cri,
    TResult? Function(CashAccount value)? cash,
  }) {
    return celi?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(RealEstateAsset value)? realEstate,
    TResult Function(RRSPAccount value)? rrsp,
    TResult Function(CELIAccount value)? celi,
    TResult Function(CRIAccount value)? cri,
    TResult Function(CashAccount value)? cash,
    required TResult orElse(),
  }) {
    if (celi != null) {
      return celi(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$CELIAccountImplToJson(this);
  }
}

abstract class CELIAccount implements Asset {
  const factory CELIAccount({
    required final String id,
    required final String individualId,
    required final double value,
    final double? customReturnRate,
    final double? annualContribution,
  }) = _$CELIAccountImpl;

  factory CELIAccount.fromJson(Map<String, dynamic> json) =
      _$CELIAccountImpl.fromJson;

  @override
  String get id;
  String get individualId;
  @override
  double get value;
  double? get customReturnRate;
  double? get annualContribution;

  /// Create a copy of Asset
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CELIAccountImplCopyWith<_$CELIAccountImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$CRIAccountImplCopyWith<$Res> implements $AssetCopyWith<$Res> {
  factory _$$CRIAccountImplCopyWith(
    _$CRIAccountImpl value,
    $Res Function(_$CRIAccountImpl) then,
  ) = __$$CRIAccountImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String individualId,
    double value,
    double? contributionRoom,
    double? customReturnRate,
    double? annualContribution,
  });
}

/// @nodoc
class __$$CRIAccountImplCopyWithImpl<$Res>
    extends _$AssetCopyWithImpl<$Res, _$CRIAccountImpl>
    implements _$$CRIAccountImplCopyWith<$Res> {
  __$$CRIAccountImplCopyWithImpl(
    _$CRIAccountImpl _value,
    $Res Function(_$CRIAccountImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Asset
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? individualId = null,
    Object? value = null,
    Object? contributionRoom = freezed,
    Object? customReturnRate = freezed,
    Object? annualContribution = freezed,
  }) {
    return _then(
      _$CRIAccountImpl(
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
        contributionRoom: freezed == contributionRoom
            ? _value.contributionRoom
            : contributionRoom // ignore: cast_nullable_to_non_nullable
                  as double?,
        customReturnRate: freezed == customReturnRate
            ? _value.customReturnRate
            : customReturnRate // ignore: cast_nullable_to_non_nullable
                  as double?,
        annualContribution: freezed == annualContribution
            ? _value.annualContribution
            : annualContribution // ignore: cast_nullable_to_non_nullable
                  as double?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CRIAccountImpl implements CRIAccount {
  const _$CRIAccountImpl({
    required this.id,
    required this.individualId,
    required this.value,
    this.contributionRoom,
    this.customReturnRate,
    this.annualContribution,
    final String? $type,
  }) : $type = $type ?? 'cri';

  factory _$CRIAccountImpl.fromJson(Map<String, dynamic> json) =>
      _$$CRIAccountImplFromJson(json);

  @override
  final String id;
  @override
  final String individualId;
  @override
  final double value;
  @override
  final double? contributionRoom;
  @override
  final double? customReturnRate;
  @override
  final double? annualContribution;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'Asset.cri(id: $id, individualId: $individualId, value: $value, contributionRoom: $contributionRoom, customReturnRate: $customReturnRate, annualContribution: $annualContribution)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CRIAccountImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.individualId, individualId) ||
                other.individualId == individualId) &&
            (identical(other.value, value) || other.value == value) &&
            (identical(other.contributionRoom, contributionRoom) ||
                other.contributionRoom == contributionRoom) &&
            (identical(other.customReturnRate, customReturnRate) ||
                other.customReturnRate == customReturnRate) &&
            (identical(other.annualContribution, annualContribution) ||
                other.annualContribution == annualContribution));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    individualId,
    value,
    contributionRoom,
    customReturnRate,
    annualContribution,
  );

  /// Create a copy of Asset
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CRIAccountImplCopyWith<_$CRIAccountImpl> get copyWith =>
      __$$CRIAccountImplCopyWithImpl<_$CRIAccountImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
      String id,
      RealEstateType type,
      double value,
      bool setAtStart,
    )
    realEstate,
    required TResult Function(
      String id,
      String individualId,
      double value,
      double? customReturnRate,
      double? annualContribution,
    )
    rrsp,
    required TResult Function(
      String id,
      String individualId,
      double value,
      double? customReturnRate,
      double? annualContribution,
    )
    celi,
    required TResult Function(
      String id,
      String individualId,
      double value,
      double? contributionRoom,
      double? customReturnRate,
      double? annualContribution,
    )
    cri,
    required TResult Function(
      String id,
      String individualId,
      double value,
      double? customReturnRate,
      double? annualContribution,
    )
    cash,
  }) {
    return cri(
      id,
      individualId,
      value,
      contributionRoom,
      customReturnRate,
      annualContribution,
    );
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
      String id,
      RealEstateType type,
      double value,
      bool setAtStart,
    )?
    realEstate,
    TResult? Function(
      String id,
      String individualId,
      double value,
      double? customReturnRate,
      double? annualContribution,
    )?
    rrsp,
    TResult? Function(
      String id,
      String individualId,
      double value,
      double? customReturnRate,
      double? annualContribution,
    )?
    celi,
    TResult? Function(
      String id,
      String individualId,
      double value,
      double? contributionRoom,
      double? customReturnRate,
      double? annualContribution,
    )?
    cri,
    TResult? Function(
      String id,
      String individualId,
      double value,
      double? customReturnRate,
      double? annualContribution,
    )?
    cash,
  }) {
    return cri?.call(
      id,
      individualId,
      value,
      contributionRoom,
      customReturnRate,
      annualContribution,
    );
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
      String id,
      RealEstateType type,
      double value,
      bool setAtStart,
    )?
    realEstate,
    TResult Function(
      String id,
      String individualId,
      double value,
      double? customReturnRate,
      double? annualContribution,
    )?
    rrsp,
    TResult Function(
      String id,
      String individualId,
      double value,
      double? customReturnRate,
      double? annualContribution,
    )?
    celi,
    TResult Function(
      String id,
      String individualId,
      double value,
      double? contributionRoom,
      double? customReturnRate,
      double? annualContribution,
    )?
    cri,
    TResult Function(
      String id,
      String individualId,
      double value,
      double? customReturnRate,
      double? annualContribution,
    )?
    cash,
    required TResult orElse(),
  }) {
    if (cri != null) {
      return cri(
        id,
        individualId,
        value,
        contributionRoom,
        customReturnRate,
        annualContribution,
      );
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(RealEstateAsset value) realEstate,
    required TResult Function(RRSPAccount value) rrsp,
    required TResult Function(CELIAccount value) celi,
    required TResult Function(CRIAccount value) cri,
    required TResult Function(CashAccount value) cash,
  }) {
    return cri(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(RealEstateAsset value)? realEstate,
    TResult? Function(RRSPAccount value)? rrsp,
    TResult? Function(CELIAccount value)? celi,
    TResult? Function(CRIAccount value)? cri,
    TResult? Function(CashAccount value)? cash,
  }) {
    return cri?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(RealEstateAsset value)? realEstate,
    TResult Function(RRSPAccount value)? rrsp,
    TResult Function(CELIAccount value)? celi,
    TResult Function(CRIAccount value)? cri,
    TResult Function(CashAccount value)? cash,
    required TResult orElse(),
  }) {
    if (cri != null) {
      return cri(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$CRIAccountImplToJson(this);
  }
}

abstract class CRIAccount implements Asset {
  const factory CRIAccount({
    required final String id,
    required final String individualId,
    required final double value,
    final double? contributionRoom,
    final double? customReturnRate,
    final double? annualContribution,
  }) = _$CRIAccountImpl;

  factory CRIAccount.fromJson(Map<String, dynamic> json) =
      _$CRIAccountImpl.fromJson;

  @override
  String get id;
  String get individualId;
  @override
  double get value;
  double? get contributionRoom;
  double? get customReturnRate;
  double? get annualContribution;

  /// Create a copy of Asset
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CRIAccountImplCopyWith<_$CRIAccountImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$CashAccountImplCopyWith<$Res>
    implements $AssetCopyWith<$Res> {
  factory _$$CashAccountImplCopyWith(
    _$CashAccountImpl value,
    $Res Function(_$CashAccountImpl) then,
  ) = __$$CashAccountImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String individualId,
    double value,
    double? customReturnRate,
    double? annualContribution,
  });
}

/// @nodoc
class __$$CashAccountImplCopyWithImpl<$Res>
    extends _$AssetCopyWithImpl<$Res, _$CashAccountImpl>
    implements _$$CashAccountImplCopyWith<$Res> {
  __$$CashAccountImplCopyWithImpl(
    _$CashAccountImpl _value,
    $Res Function(_$CashAccountImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Asset
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? individualId = null,
    Object? value = null,
    Object? customReturnRate = freezed,
    Object? annualContribution = freezed,
  }) {
    return _then(
      _$CashAccountImpl(
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
        customReturnRate: freezed == customReturnRate
            ? _value.customReturnRate
            : customReturnRate // ignore: cast_nullable_to_non_nullable
                  as double?,
        annualContribution: freezed == annualContribution
            ? _value.annualContribution
            : annualContribution // ignore: cast_nullable_to_non_nullable
                  as double?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CashAccountImpl implements CashAccount {
  const _$CashAccountImpl({
    required this.id,
    required this.individualId,
    required this.value,
    this.customReturnRate,
    this.annualContribution,
    final String? $type,
  }) : $type = $type ?? 'cash';

  factory _$CashAccountImpl.fromJson(Map<String, dynamic> json) =>
      _$$CashAccountImplFromJson(json);

  @override
  final String id;
  @override
  final String individualId;
  @override
  final double value;
  @override
  final double? customReturnRate;
  @override
  final double? annualContribution;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'Asset.cash(id: $id, individualId: $individualId, value: $value, customReturnRate: $customReturnRate, annualContribution: $annualContribution)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CashAccountImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.individualId, individualId) ||
                other.individualId == individualId) &&
            (identical(other.value, value) || other.value == value) &&
            (identical(other.customReturnRate, customReturnRate) ||
                other.customReturnRate == customReturnRate) &&
            (identical(other.annualContribution, annualContribution) ||
                other.annualContribution == annualContribution));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    individualId,
    value,
    customReturnRate,
    annualContribution,
  );

  /// Create a copy of Asset
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CashAccountImplCopyWith<_$CashAccountImpl> get copyWith =>
      __$$CashAccountImplCopyWithImpl<_$CashAccountImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
      String id,
      RealEstateType type,
      double value,
      bool setAtStart,
    )
    realEstate,
    required TResult Function(
      String id,
      String individualId,
      double value,
      double? customReturnRate,
      double? annualContribution,
    )
    rrsp,
    required TResult Function(
      String id,
      String individualId,
      double value,
      double? customReturnRate,
      double? annualContribution,
    )
    celi,
    required TResult Function(
      String id,
      String individualId,
      double value,
      double? contributionRoom,
      double? customReturnRate,
      double? annualContribution,
    )
    cri,
    required TResult Function(
      String id,
      String individualId,
      double value,
      double? customReturnRate,
      double? annualContribution,
    )
    cash,
  }) {
    return cash(id, individualId, value, customReturnRate, annualContribution);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
      String id,
      RealEstateType type,
      double value,
      bool setAtStart,
    )?
    realEstate,
    TResult? Function(
      String id,
      String individualId,
      double value,
      double? customReturnRate,
      double? annualContribution,
    )?
    rrsp,
    TResult? Function(
      String id,
      String individualId,
      double value,
      double? customReturnRate,
      double? annualContribution,
    )?
    celi,
    TResult? Function(
      String id,
      String individualId,
      double value,
      double? contributionRoom,
      double? customReturnRate,
      double? annualContribution,
    )?
    cri,
    TResult? Function(
      String id,
      String individualId,
      double value,
      double? customReturnRate,
      double? annualContribution,
    )?
    cash,
  }) {
    return cash?.call(
      id,
      individualId,
      value,
      customReturnRate,
      annualContribution,
    );
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
      String id,
      RealEstateType type,
      double value,
      bool setAtStart,
    )?
    realEstate,
    TResult Function(
      String id,
      String individualId,
      double value,
      double? customReturnRate,
      double? annualContribution,
    )?
    rrsp,
    TResult Function(
      String id,
      String individualId,
      double value,
      double? customReturnRate,
      double? annualContribution,
    )?
    celi,
    TResult Function(
      String id,
      String individualId,
      double value,
      double? contributionRoom,
      double? customReturnRate,
      double? annualContribution,
    )?
    cri,
    TResult Function(
      String id,
      String individualId,
      double value,
      double? customReturnRate,
      double? annualContribution,
    )?
    cash,
    required TResult orElse(),
  }) {
    if (cash != null) {
      return cash(
        id,
        individualId,
        value,
        customReturnRate,
        annualContribution,
      );
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(RealEstateAsset value) realEstate,
    required TResult Function(RRSPAccount value) rrsp,
    required TResult Function(CELIAccount value) celi,
    required TResult Function(CRIAccount value) cri,
    required TResult Function(CashAccount value) cash,
  }) {
    return cash(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(RealEstateAsset value)? realEstate,
    TResult? Function(RRSPAccount value)? rrsp,
    TResult? Function(CELIAccount value)? celi,
    TResult? Function(CRIAccount value)? cri,
    TResult? Function(CashAccount value)? cash,
  }) {
    return cash?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(RealEstateAsset value)? realEstate,
    TResult Function(RRSPAccount value)? rrsp,
    TResult Function(CELIAccount value)? celi,
    TResult Function(CRIAccount value)? cri,
    TResult Function(CashAccount value)? cash,
    required TResult orElse(),
  }) {
    if (cash != null) {
      return cash(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$CashAccountImplToJson(this);
  }
}

abstract class CashAccount implements Asset {
  const factory CashAccount({
    required final String id,
    required final String individualId,
    required final double value,
    final double? customReturnRate,
    final double? annualContribution,
  }) = _$CashAccountImpl;

  factory CashAccount.fromJson(Map<String, dynamic> json) =
      _$CashAccountImpl.fromJson;

  @override
  String get id;
  String get individualId;
  @override
  double get value;
  double? get customReturnRate;
  double? get annualContribution;

  /// Create a copy of Asset
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CashAccountImplCopyWith<_$CashAccountImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
