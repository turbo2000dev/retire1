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

    // Register a callback that marks section complete when user clicks Next
    widget.onRegisterCallback?.call(() async {
      await ref
          .read(wizardProgressProvider.notifier)
          .updateSectionStatus('welcome', WizardSectionStatus.complete());
      return true;
    });

    // Mark as in progress after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(wizardProgressProvider.notifier)
          .updateSectionStatus('welcome', WizardSectionStatus.inProgress());
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Welcome Section - Coming Soon'));
  }
}
