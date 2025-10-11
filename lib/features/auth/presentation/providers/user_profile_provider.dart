import 'dart:developer';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retire1/features/auth/data/user_profile_repository.dart';
import 'package:retire1/features/auth/domain/user.dart';
import 'package:retire1/features/auth/presentation/providers/auth_provider.dart';

/// Provider for user profile repository
final userProfileRepositoryProvider = Provider<UserProfileRepository>((ref) {
  return UserProfileRepository();
});

/// User profile notifier
class UserProfileNotifier extends StateNotifier<AsyncValue<User?>> {
  final UserProfileRepository _repository;
  final String? _userId;

  UserProfileNotifier(this._repository, this._userId)
      : super(const AsyncValue.loading()) {
    _loadProfile();
  }

  /// Load user profile from Firestore
  Future<void> _loadProfile() async {
    if (_userId == null) {
      state = const AsyncValue.data(null);
      return;
    }

    try {
      final profile = await _repository.getUserProfile(_userId);
      state = AsyncValue.data(profile);
    } catch (e, stack) {
      log('Failed to load user profile', error: e, stackTrace: stack);
      state = AsyncValue.error(e, stack);
    }
  }

  /// Update display name
  Future<void> updateDisplayName(String displayName) async {
    if (_userId == null) {
      log('Cannot update display name: user not logged in');
      return;
    }

    final currentProfile = state.value;
    if (currentProfile == null) return;

    // Optimistically update the state
    state = AsyncValue.data(
      currentProfile.copyWith(displayName: displayName),
    );

    try {
      await _repository.updateDisplayName(_userId, displayName);
    } catch (e, stack) {
      log('Failed to update display name', error: e, stackTrace: stack);
      // Revert to previous profile on error
      state = AsyncValue.data(currentProfile);
      state = AsyncValue.error(e, stack);
    }
  }

  /// Upload profile picture
  Future<void> uploadProfilePicture(File imageFile) async {
    if (_userId == null) {
      log('Cannot upload profile picture: user not logged in');
      return;
    }

    final currentProfile = state.value;
    if (currentProfile == null) return;

    try {
      final photoUrl = await _repository.uploadProfilePicture(_userId, imageFile);

      // Update state with new photo URL
      state = AsyncValue.data(
        currentProfile.copyWith(photoUrl: photoUrl),
      );
    } catch (e, stack) {
      log('Failed to upload profile picture', error: e, stackTrace: stack);
      state = AsyncValue.error(e, stack);
      // Reset to previous state after showing error
      Future.delayed(const Duration(seconds: 2), () {
        state = AsyncValue.data(currentProfile);
      });
    }
  }

  /// Update photo URL (for web platform or URL-based images)
  Future<void> updatePhotoUrl(String photoUrl) async {
    if (_userId == null) {
      log('Cannot update photo URL: user not logged in');
      return;
    }

    final currentProfile = state.value;
    if (currentProfile == null) return;

    // Optimistically update the state
    state = AsyncValue.data(
      currentProfile.copyWith(photoUrl: photoUrl),
    );

    try {
      await _repository.updatePhotoUrl(_userId, photoUrl);
    } catch (e, stack) {
      log('Failed to update photo URL', error: e, stackTrace: stack);
      // Revert to previous profile on error
      state = AsyncValue.data(currentProfile);
      state = AsyncValue.error(e, stack);
    }
  }

  /// Save complete user profile
  Future<void> saveProfile(User user) async {
    try {
      await _repository.saveUserProfile(user);
      state = AsyncValue.data(user);
    } catch (e, stack) {
      log('Failed to save user profile', error: e, stackTrace: stack);
      state = AsyncValue.error(e, stack);
    }
  }

  /// Reload profile from Firestore
  Future<void> reload() async {
    await _loadProfile();
  }
}

/// Provider for user profile state
final userProfileProvider =
    StateNotifierProvider<UserProfileNotifier, AsyncValue<User?>>((ref) {
  final repository = ref.watch(userProfileRepositoryProvider);
  final authState = ref.watch(authNotifierProvider);

  // Get user ID from auth state
  final userId = authState is Authenticated ? authState.user.id : null;

  return UserProfileNotifier(repository, userId);
});

/// Provider for current user (merged from auth and profile)
final currentUserProvider = Provider<User?>((ref) {
  final authState = ref.watch(authNotifierProvider);
  final profileAsync = ref.watch(userProfileProvider);

  if (authState is! Authenticated) {
    return null;
  }

  // Use profile data if available, otherwise use auth data
  return profileAsync.when(
    data: (profile) => profile ?? authState.user,
    loading: () => authState.user,
    error: (_, __) => authState.user,
  );
});
