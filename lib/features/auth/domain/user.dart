import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

/// User domain model
@freezed
class User with _$User {
  const factory User({
    required String id,
    required String email,
    String? displayName,
    String? photoUrl,
    // Track if user manually edited these fields (to prevent social sign-in from overwriting)
    @Default(false) bool displayNameManuallyEdited,
    @Default(false) bool photoUrlManuallyEdited,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
