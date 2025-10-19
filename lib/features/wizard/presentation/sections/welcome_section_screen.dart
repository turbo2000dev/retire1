import 'package:flutter/material.dart';

/// Welcome section - Educational introduction to the wizard
class WelcomeSectionScreen extends StatelessWidget {
  final void Function(Future<bool> Function()?)? onRegisterCallback;

  const WelcomeSectionScreen({
    super.key,
    this.onRegisterCallback,
  });

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Welcome Section - Coming Soon'),
    );
  }
}
