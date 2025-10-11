import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:retire1/features/auth/data/user_profile_repository.dart';
import 'package:retire1/features/auth/domain/user.dart';

/// Repository for Firebase authentication operations
class AuthRepository {
  final firebase_auth.FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;
  final UserProfileRepository _profileRepository;

  AuthRepository({
    firebase_auth.FirebaseAuth? firebaseAuth,
    GoogleSignIn? googleSignIn,
    UserProfileRepository? profileRepository,
  })  : _firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance,
        _googleSignIn = googleSignIn ??
            GoogleSignIn(
              scopes: ['email'],
              // serverClientId only for mobile platforms (not web)
              serverClientId: kIsWeb
                  ? null
                  : '455240536437-8lntsoblomq64cf0hgl94kgdvjp26b9k.apps.googleusercontent.com',
            ),
        _profileRepository = profileRepository ?? UserProfileRepository();

  /// Stream of auth state changes
  Stream<User?> get authStateChanges {
    return _firebaseAuth.authStateChanges().map((firebaseUser) {
      return firebaseUser != null ? _convertFirebaseUser(firebaseUser) : null;
    });
  }

  /// Get current user
  User? get currentUser {
    final firebaseUser = _firebaseAuth.currentUser;
    return firebaseUser != null ? _convertFirebaseUser(firebaseUser) : null;
  }

  /// Check if user is logged in
  bool get isLoggedIn => _firebaseAuth.currentUser != null;

  /// Sign in with email and password
  Future<User> login(String email, String password) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user == null) {
        throw AuthException('Login failed: no user returned');
      }

      return _convertFirebaseUser(credential.user!);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw _handleFirebaseAuthException(e);
    } catch (e) {
      throw AuthException('An unexpected error occurred: $e');
    }
  }

  /// Register with email and password
  Future<User> register(
    String email,
    String password,
    String displayName,
  ) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user == null) {
        throw AuthException('Registration failed: no user returned');
      }

      // Update display name
      await credential.user!.updateDisplayName(displayName);
      await credential.user!.reload();

      final updatedUser = _firebaseAuth.currentUser;
      if (updatedUser == null) {
        throw AuthException('Failed to get updated user');
      }

      // Sync to Firestore
      await _profileRepository.syncAuthUserToFirestore(updatedUser);

      return _convertFirebaseUser(updatedUser);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw _handleFirebaseAuthException(e);
    } catch (e) {
      throw AuthException('An unexpected error occurred: $e');
    }
  }

  /// Sign in with Google
  Future<User> signInWithGoogle() async {
    try {
      firebase_auth.UserCredential userCredential;

      if (kIsWeb) {
        // On web, use Firebase's popup sign-in which works better
        // Set custom parameters to force account selection
        final googleProvider = firebase_auth.GoogleAuthProvider();
        googleProvider.setCustomParameters({
          'prompt': 'select_account', // Forces account selection every time
        });

        userCredential = await _firebaseAuth.signInWithPopup(googleProvider);
      } else {
        // On mobile platforms, use google_sign_in package
        final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

        if (googleUser == null) {
          throw AuthException('Google sign-in was cancelled');
        }

        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        final credential = firebase_auth.GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        userCredential = await _firebaseAuth.signInWithCredential(credential);
      }

      if (userCredential.user == null) {
        throw AuthException('Google sign-in failed: no user returned');
      }

      // Sync social sign-in data to Firestore with smart sync logic
      await _profileRepository.syncAuthUserToFirestore(userCredential.user!);

      return _convertFirebaseUser(userCredential.user!);
    } on firebase_auth.FirebaseAuthException catch (e) {
      // Check if user cancelled the popup
      if (e.code == 'popup-closed-by-user') {
        throw AuthException('Google sign-in was cancelled');
      }
      throw _handleFirebaseAuthException(e);
    } catch (e) {
      if (e is AuthException) {
        rethrow;
      }
      throw AuthException('Google sign-in failed: $e');
    }
  }

  /// Sign out
  Future<void> logout() async {
    try {
      // Sign out from both Firebase and Google
      await Future.wait([
        _firebaseAuth.signOut(),
        _googleSignIn.signOut(),
      ]);
    } catch (e) {
      throw AuthException('Logout failed: $e');
    }
  }

  /// Convert Firebase User to domain User
  User _convertFirebaseUser(firebase_auth.User firebaseUser) {
    return User(
      id: firebaseUser.uid,
      email: firebaseUser.email ?? '',
      displayName: firebaseUser.displayName,
      photoUrl: firebaseUser.photoURL,
    );
  }

  /// Handle Firebase Auth exceptions and convert to user-friendly messages
  AuthException _handleFirebaseAuthException(
    firebase_auth.FirebaseAuthException e,
  ) {
    switch (e.code) {
      case 'invalid-email':
        return AuthException('The email address is not valid.');
      case 'user-disabled':
        return AuthException('This user account has been disabled.');
      case 'user-not-found':
        return AuthException('No user found with this email.');
      case 'wrong-password':
        return AuthException('Incorrect password.');
      case 'email-already-in-use':
        return AuthException('An account already exists with this email.');
      case 'operation-not-allowed':
        return AuthException('Email/password accounts are not enabled.');
      case 'weak-password':
        return AuthException('The password is too weak.');
      case 'invalid-credential':
        return AuthException('The credentials are invalid or expired.');
      case 'network-request-failed':
        return AuthException(
          'Network error. Please check your connection and try again.',
        );
      case 'too-many-requests':
        return AuthException(
          'Too many attempts. Please try again later.',
        );
      default:
        return AuthException(
          'Authentication failed: ${e.message ?? e.code}',
        );
    }
  }
}

/// Custom exception for authentication errors
class AuthException implements Exception {
  final String message;

  AuthException(this.message);

  @override
  String toString() => message;
}
