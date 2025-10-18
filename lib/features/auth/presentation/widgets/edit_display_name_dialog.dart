import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retire1/features/auth/presentation/providers/user_profile_provider.dart';

/// Dialog for editing user's display name
class EditDisplayNameDialog extends ConsumerStatefulWidget {
  final String currentDisplayName;

  const EditDisplayNameDialog({super.key, required this.currentDisplayName});

  @override
  ConsumerState<EditDisplayNameDialog> createState() =>
      _EditDisplayNameDialogState();
}

class _EditDisplayNameDialogState extends ConsumerState<EditDisplayNameDialog> {
  late TextEditingController _controller;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.currentDisplayName);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final displayName = _controller.text.trim();

    if (displayName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Display name cannot be empty')),
      );
      return;
    }

    if (displayName == widget.currentDisplayName) {
      Navigator.of(context).pop();
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      await ref
          .read(userProfileProvider.notifier)
          .updateDisplayName(displayName);

      if (mounted) {
        Navigator.of(context).pop(true);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Display name updated')));
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update display name: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Display Name'),
      content: TextField(
        controller: _controller,
        decoration: const InputDecoration(
          labelText: 'Display Name',
          hintText: 'Enter your name',
        ),
        autofocus: true,
        enabled: !_isSaving,
        onSubmitted: (_) => _save(),
      ),
      actions: [
        TextButton(
          onPressed: _isSaving ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _isSaving ? null : _save,
          child: _isSaving
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Save'),
        ),
      ],
    );
  }
}
