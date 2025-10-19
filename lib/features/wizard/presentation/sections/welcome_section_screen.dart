import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retire1/features/wizard/domain/wizard_section_status.dart';
import 'package:retire1/features/wizard/presentation/providers/wizard_progress_provider.dart';

/// Welcome section - Educational introduction to the wizard
class WelcomeSectionScreen extends ConsumerStatefulWidget {
  final void Function(Future<bool> Function()?)? onRegisterCallback;

  const WelcomeSectionScreen({super.key, this.onRegisterCallback});

  @override
  ConsumerState<WelcomeSectionScreen> createState() =>
      _WelcomeSectionScreenState();
}

class _WelcomeSectionScreenState extends ConsumerState<WelcomeSectionScreen> {
  @override
  void initState() {
    super.initState();

    // Register a callback that always returns true (no validation needed)
    widget.onRegisterCallback?.call(() async => true);

    // Mark as complete after first frame (educational section, just needs to be viewed)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(wizardProgressProvider.notifier)
          .updateSectionStatus('welcome', WizardSectionStatus.complete());
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Welcome Section - Coming Soon'));
  }
}
