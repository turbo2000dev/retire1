import 'package:flutter/material.dart';
import 'screen_size.dart';

/// Shows a responsive bottom sheet that adapts to screen size
Future<T?> showResponsiveBottomSheet<T>({
  required BuildContext context,
  required Widget Function(BuildContext) builder,
  bool isDismissible = true,
  bool enableDrag = true,
}) {
  final screenSize = ScreenSize(context);

  // On phone: show as bottom sheet
  // On tablet/desktop: show as modal dialog
  if (screenSize.isPhone) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16),
        ),
      ),
      builder: (context) => ResponsiveBottomSheet(
        child: builder(context),
      ),
    );
  } else {
    return showDialog<T>(
      context: context,
      barrierDismissible: isDismissible,
      builder: (context) => Dialog(
        child: Container(
          constraints: BoxConstraints(
            maxWidth: screenSize.isTablet ? 500 : 600,
            maxHeight: screenSize.height * 0.9,
          ),
          child: builder(context),
        ),
      ),
    );
  }
}

/// A bottom sheet with drag handle and responsive sizing
class ResponsiveBottomSheet extends StatelessWidget {
  /// The content of the bottom sheet
  final Widget child;

  /// Whether to show the drag handle
  final bool showDragHandle;

  const ResponsiveBottomSheet({
    super.key,
    required this.child,
    this.showDragHandle = true,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = ScreenSize(context);

    return Container(
      constraints: BoxConstraints(
        maxHeight: screenSize.height * 0.9,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(16),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showDragHandle)
            Padding(
              padding: const EdgeInsets.only(top: 12, bottom: 4),
              child: Container(
                width: 32,
                height: 4,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          Flexible(
            child: child,
          ),
        ],
      ),
    );
  }
}

/// Standard bottom sheet content layout with title and scrollable content
class ResponsiveBottomSheetContent extends StatelessWidget {
  /// The title of the bottom sheet
  final String title;

  /// The main content (scrollable)
  final Widget content;

  /// Optional action buttons
  final List<Widget> actions;

  const ResponsiveBottomSheetContent({
    super.key,
    required this.title,
    required this.content,
    this.actions = const [],
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
          child: Text(
            title,
            style: theme.textTheme.titleLarge,
          ),
        ),

        // Scrollable content
        Flexible(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: content,
          ),
        ),

        // Actions
        if (actions.isNotEmpty)
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                for (int i = 0; i < actions.length; i++) ...[
                  if (i > 0) const SizedBox(width: 8),
                  actions[i],
                ],
              ],
            ),
          ),
      ],
    );
  }
}
