import 'package:flutter_riverpod/flutter_riverpod.dart';
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

/// Auth repository provider
final authRepositoryProvider = Provider<AuthRepositoryMock>((ref) {
  return AuthRepositoryMock();
});

/// Auth state notifier
class AuthNotifier extends Notifier<AuthState> {
  @override
  AuthState build() {
    // Check if user is already logged in
    final repository = ref.read(authRepositoryProvider);
    if (repository.isLoggedIn && repository.currentUser != null) {
      return Authenticated(repository.currentUser!);
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
