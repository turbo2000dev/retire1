import 'package:freezed_annotation/freezed_annotation.dart';

part 'asset.freezed.dart';
part 'asset.g.dart';

/// Asset type for real estate properties
enum RealEstateType {
  house,
  condo,
  cottage,
  land,
  commercial,
  other,
}

/// Asset domain model using Freezed unions for different asset types
@freezed
class Asset with _$Asset {
  /// Real estate asset (house, condo, cottage, etc.)
  const factory Asset.realEstate({
    required String id,
    required RealEstateType type,
    required double value,
    @Default(false) bool setAtStart,
    double? customReturnRate,
  }) = RealEstateAsset;

  /// RRSP (Registered Retirement Savings Plan) account
  const factory Asset.rrsp({
    required String id,
    required String individualId,
    required double value,
    double? customReturnRate,
    double? annualContribution,
  }) = RRSPAccount;

  /// CELI (Tax-Free Savings Account / TFSA) account
  const factory Asset.celi({
    required String id,
    required String individualId,
    required double value,
    double? customReturnRate,
    double? annualContribution,
  }) = CELIAccount;

  /// CRI/FRV (Compte de Retraite Immobilisé / Fonds de Revenu Viager) account
  const factory Asset.cri({
    required String id,
    required String individualId,
    required double value,
    double? contributionRoom,
    double? customReturnRate,
    double? annualContribution,
  }) = CRIAccount;

  /// Cash/savings account
  const factory Asset.cash({
    required String id,
    required String individualId,
    required double value,
    double? customReturnRate,
    double? annualContribution,
  }) = CashAccount;

  factory Asset.fromJson(Map<String, dynamic> json) => _$AssetFromJson(json);
}
