import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retire1/features/auth/data/auth_repository.dart';
import 'package:retire1/features/auth/data/auth_repository_mock.dart';
import 'package:retire1/features/auth/domain/user.dart';

/// Auth state sealed class
sealed class AuthState {
  const AuthState();
}

/// Initial/unauthenticated state
class Unauthenticated extends AuthState {
  const Unauthenticated();
}

/// Loading state (during login/register)
class AuthLoading extends AuthState {
  const AuthLoading();
}

/// Authenticated state with user
class Authenticated extends AuthState {
  final User user;
  const Authenticated(this.user);
}

/// Error state
class AuthError extends AuthState {
  final String message;
  const AuthError(this.message);
}

/// Auth repository provider (Firebase)
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository();
});

/// Mock auth repository provider (for testing)
final authRepositoryMockProvider = Provider<AuthRepositoryMock>((ref) {
  return AuthRepositoryMock();
});

/// Stream provider for auth state changes
final authStateStreamProvider = StreamProvider<User?>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return repository.authStateChanges;
});

/// Auth state notifier with Firebase auth state listener
class AuthNotifier extends Notifier<AuthState> {
  @override
  AuthState build() {
    final repository = ref.read(authRepositoryProvider);

    // Listen to auth state changes stream
    ref.listen(authStateStreamProvider, (previous, next) {
      next.whenData((user) {
        if (user != null) {
          // Only update if not loading or showing error message
          if (state is! AuthLoading && state is! AuthError) {
            state = Authenticated(user);
          }
        } else {
          // Only set to unauthenticated if not loading or showing error
          if (state is! AuthLoading && state is! AuthError) {
            state = const Unauthenticated();
          }
        }
      });
    });

    // Set initial state based on current user
    final currentUser = repository.currentUser;
    if (currentUser != null) {
      return Authenticated(currentUser);
    }
    return const Unauthenticated();
  }

  /// Login with email and password
  Future<void> login(String email, String password) async {
    state = const AuthLoading();

    try {
      final repository = ref.read(authRepositoryProvider);
      final user = await repository.login(email, password);
      state = Authenticated(user);
    } catch (e) {
      state = AuthError(e.toString().replaceAll('Exception: ', ''));
      // Reset to unauthenticated after showing error
      Future.delayed(const Duration(seconds: 3), () {
        if (state is AuthError) {
          state = const Unauthenticated();
        }
      });
    }
  }

  /// Register with email, password, and display name
  Future<void> register(String email, String password, String displayName) async {
    state = const AuthLoading();

    try {
      final repository = ref.read(authRepositoryProvider);
      final user = await repository.register(email, password, displayName);
      state = Authenticated(user);
    } catch (e) {
      state = AuthError(e.toString().replaceAll('Exception: ', ''));
      // Reset to unauthenticated after showing error
      Future.delayed(const Duration(seconds: 3), () {
        if (state is AuthError) {
          state = const Unauthenticated();
        }
      });
    }
  }

  /// Sign in with Google
  Future<void> signInWithGoogle() async {
    state = const AuthLoading();

    try {
      final repository = ref.read(authRepositoryProvider);
      final user = await repository.signInWithGoogle();
      state = Authenticated(user);
    } catch (e) {
      state = AuthError(e.toString().replaceAll('Exception: ', ''));
      // Reset to unauthenticated after showing error
      Future.delayed(const Duration(seconds: 3), () {
        if (state is AuthError) {
          state = const Unauthenticated();
        }
      });
    }
  }

  /// Logout
  Future<void> logout() async {
    state = const AuthLoading();

    try {
      final repository = ref.read(authRepositoryProvider);
      await repository.logout();
      state = const Unauthenticated();
    } catch (e) {
      state = AuthError(e.toString().replaceAll('Exception: ', ''));
    }
  }

  /// Get current user (if authenticated)
  User? get currentUser {
    final currentState = state;
    if (currentState is Authenticated) {
      return currentState.user;
    }
    return null;
  }

  /// Check if user is authenticated
  bool get isAuthenticated => state is Authenticated;
}

/// Auth notifier provider
final authNotifierProvider = NotifierProvider<AuthNotifier, AuthState>(() {
  return AuthNotifier();
});
