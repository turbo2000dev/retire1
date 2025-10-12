import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:retire1/features/events/domain/event_timing.dart';

part 'event.freezed.dart';
part 'event.g.dart';

/// Event types using Freezed unions
@freezed
class Event with _$Event {
  /// Retirement event - an individual retires
  const factory Event.retirement({
    required String id,
    required String individualId,
    required EventTiming timing,
  }) = RetirementEvent;

  /// Death event - an individual dies
  const factory Event.death({
    required String id,
    required String individualId,
    required EventTiming timing,
  }) = DeathEvent;

  /// Real estate transaction - buying/selling property
  /// Either assetSoldId or assetPurchasedId can be null (but not both)
  const factory Event.realEstateTransaction({
    required String id,
    required EventTiming timing,
    String? assetSoldId, // Real estate asset being sold
    String? assetPurchasedId, // Real estate asset being purchased
    required String
        withdrawAccountId, // Cash account to withdraw from (for purchase) or deposit to (for sale)
    required String
        depositAccountId, // Cash account to deposit sale proceeds or withdraw purchase funds
  }) = RealEstateTransactionEvent;

  factory Event.fromJson(Map<String, dynamic> json) => _$EventFromJson(json);
}
