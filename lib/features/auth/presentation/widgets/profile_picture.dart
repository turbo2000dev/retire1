import 'dart:io';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:retire1/features/auth/presentation/providers/user_profile_provider.dart';

/// Widget for displaying and editing profile picture
class ProfilePicture extends ConsumerWidget {
  final String? photoUrl;
  final String? displayName;
  final double size;
  final bool editable;

  const ProfilePicture({
    super.key,
    this.photoUrl,
    this.displayName,
    this.size = 80,
    this.editable = false,
  });

  Future<void> _pickImage(BuildContext context, WidgetRef ref) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 85,
      );

      if (image == null) return;

      if (!context.mounted) return;

      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      try {
        if (kIsWeb) {
          // For web, we'll use the image path as URL (this is a simplified approach)
          // In production, you'd want to upload to Firebase Storage
          final bytes = await image.readAsBytes();
          final base64Image = 'data:image/jpeg;base64,${bytes.toString()}';
          await ref
              .read(userProfileProvider.notifier)
              .updatePhotoUrl(base64Image);
        } else {
          // For mobile/desktop, upload the file
          final file = File(image.path);
          await ref
              .read(userProfileProvider.notifier)
              .uploadProfilePicture(file);
        }

        if (context.mounted) {
          Navigator.of(context).pop(); // Close loading dialog
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profile picture updated')),
          );
        }
      } catch (e) {
        if (context.mounted) {
          Navigator.of(context).pop(); // Close loading dialog
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Failed to upload image: $e')));
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to pick image: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    Widget avatarContent;

    if (photoUrl != null && photoUrl!.isNotEmpty) {
      avatarContent = CircleAvatar(
        radius: size / 2,
        backgroundImage: NetworkImage(photoUrl!),
        backgroundColor: theme.colorScheme.surfaceContainerHighest,
      );
    } else {
      // Show initials if no photo
      final initials = _getInitials(displayName);
      avatarContent = CircleAvatar(
        radius: size / 2,
        backgroundColor: theme.colorScheme.primary,
        child: Text(
          initials,
          style: theme.textTheme.headlineMedium?.copyWith(
            color: theme.colorScheme.onPrimary,
            fontSize: size / 3,
          ),
        ),
      );
    }

    if (!editable) {
      return avatarContent;
    }

    // Editable version with camera icon overlay
    return Stack(
      children: [
        avatarContent,
        Positioned(
          bottom: 0,
          right: 0,
          child: Material(
            color: theme.colorScheme.primary,
            shape: const CircleBorder(),
            child: InkWell(
              onTap: () => _pickImage(context, ref),
              customBorder: const CircleBorder(),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Icon(
                  Icons.camera_alt,
                  size: size / 4,
                  color: theme.colorScheme.onPrimary,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  String _getInitials(String? name) {
    if (name == null || name.isEmpty) return '?';

    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
    }
    return name[0].toUpperCase();
  }
}
