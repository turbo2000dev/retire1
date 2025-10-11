import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:retire1/features/auth/domain/user.dart' as domain;

/// Repository for managing user profile data in Firestore and Storage
class UserProfileRepository {
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;
  final firebase_auth.FirebaseAuth _auth;

  UserProfileRepository({
    FirebaseFirestore? firestore,
    FirebaseStorage? storage,
    firebase_auth.FirebaseAuth? auth,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _storage = storage ?? FirebaseStorage.instance,
        _auth = auth ?? firebase_auth.FirebaseAuth.instance;

  /// Get user profile from Firestore
  /// Returns null if profile doesn't exist
  Future<domain.User?> getUserProfile(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();

      if (doc.exists && doc.data() != null) {
        return domain.User.fromJson({
          'id': userId,
          ...doc.data()!,
        });
      }

      return null;
    } catch (e) {
      log('Failed to get user profile', error: e);
      throw UserProfileException('Failed to load user profile: $e');
    }
  }

  /// Save or update user profile in Firestore
  Future<void> saveUserProfile(domain.User user) async {
    try {
      await _firestore.collection('users').doc(user.id).set({
        'email': user.email,
        'displayName': user.displayName,
        'photoUrl': user.photoUrl,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      log('Failed to save user profile', error: e);
      throw UserProfileException('Failed to save user profile: $e');
    }
  }

  /// Update display name (marks as manually edited)
  Future<void> updateDisplayName(String userId, String displayName) async {
    try {
      // Update Firebase Auth profile
      final currentUser = _auth.currentUser;
      if (currentUser != null && currentUser.uid == userId) {
        await currentUser.updateDisplayName(displayName);
      }

      // Update Firestore and mark as manually edited
      await _firestore.collection('users').doc(userId).set({
        'displayName': displayName,
        'displayNameManuallyEdited': true, // Prevent social sign-in from overwriting
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      log('Failed to update display name', error: e);
      throw UserProfileException('Failed to update display name: $e');
    }
  }

  /// Upload profile picture to Firebase Storage and update profile (marks as manually edited)
  Future<String> uploadProfilePicture(String userId, File imageFile) async {
    try {
      // Create a reference to the profile picture location
      final ref = _storage.ref().child('users/$userId/profile.jpg');

      // Upload the file
      await ref.putFile(imageFile);

      // Get the download URL
      final photoUrl = await ref.getDownloadURL();

      // Update Firebase Auth profile
      final currentUser = _auth.currentUser;
      if (currentUser != null && currentUser.uid == userId) {
        await currentUser.updatePhotoURL(photoUrl);
      }

      // Update Firestore and mark as manually edited
      await _firestore.collection('users').doc(userId).set({
        'photoUrl': photoUrl,
        'photoUrlManuallyEdited': true, // Prevent social sign-in from overwriting
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      return photoUrl;
    } catch (e) {
      log('Failed to upload profile picture', error: e);
      throw UserProfileException('Failed to upload profile picture: $e');
    }
  }

  /// Update photo URL (for web or when using a URL instead of file) (marks as manually edited)
  Future<void> updatePhotoUrl(String userId, String photoUrl) async {
    try {
      // Update Firebase Auth profile
      final currentUser = _auth.currentUser;
      if (currentUser != null && currentUser.uid == userId) {
        await currentUser.updatePhotoURL(photoUrl);
      }

      // Update Firestore and mark as manually edited
      await _firestore.collection('users').doc(userId).set({
        'photoUrl': photoUrl,
        'photoUrlManuallyEdited': true, // Prevent social sign-in from overwriting
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      log('Failed to update photo URL', error: e);
      throw UserProfileException('Failed to update photo URL: $e');
    }
  }

  /// Sync Firebase Auth user to Firestore with smart sync logic
  /// Only updates fields that haven't been manually edited by the user
  Future<void> syncAuthUserToFirestore(firebase_auth.User firebaseUser) async {
    try {
      final userId = firebaseUser.uid;

      // Get existing profile from Firestore
      final existingProfile = await getUserProfile(userId);

      // Prepare update data
      final Map<String, dynamic> updateData = {
        'email': firebaseUser.email,
        'updatedAt': FieldValue.serverTimestamp(),
      };

      if (existingProfile == null) {
        // First-time sign-in: save everything from social sign-in
        updateData['displayName'] = firebaseUser.displayName;
        updateData['photoUrl'] = firebaseUser.photoURL;
        updateData['displayNameManuallyEdited'] = false;
        updateData['photoUrlManuallyEdited'] = false;

        log('First-time sync: saving social sign-in data for user $userId');
      } else {
        // Existing user: only update if not manually edited

        // Sync display name if not manually edited AND different from social
        if (!existingProfile.displayNameManuallyEdited &&
            firebaseUser.displayName != null &&
            firebaseUser.displayName != existingProfile.displayName) {
          updateData['displayName'] = firebaseUser.displayName;
          log('Syncing updated display name from social sign-in for user $userId');
        }

        // Sync photo URL if not manually edited AND different from social
        if (!existingProfile.photoUrlManuallyEdited &&
            firebaseUser.photoURL != null &&
            firebaseUser.photoURL != existingProfile.photoUrl) {
          updateData['photoUrl'] = firebaseUser.photoURL;
          log('Syncing updated photo URL from social sign-in for user $userId');
        }
      }

      // Update Firestore
      await _firestore.collection('users').doc(userId).set(
        updateData,
        SetOptions(merge: true),
      );
    } catch (e) {
      log('Failed to sync auth user to Firestore', error: e);
      // Don't throw - this is a background sync operation
    }
  }

  /// Stream of user profile changes
  Stream<domain.User?> watchUserProfile(String userId) {
    return _firestore.collection('users').doc(userId).snapshots().map((doc) {
      if (doc.exists && doc.data() != null) {
        return domain.User.fromJson({
          'id': userId,
          ...doc.data()!,
        });
      }
      return null;
    });
  }
}

/// Custom exception for user profile errors
class UserProfileException implements Exception {
  final String message;

  UserProfileException(this.message);

  @override
  String toString() => message;
}
