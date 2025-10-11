import 'package:flutter/material.dart';
import 'package:retire1/core/ui/responsive/screen_size.dart';

/// Shows a responsive dialog that adapts to screen size
Future<T?> showResponsiveDialog<T>({
  required BuildContext context,
  required Widget Function(BuildContext) builder,
  bool barrierDismissible = true,
}) {
  return showDialog<T>(
    context: context,
    barrierDismissible: barrierDismissible,
    builder: (context) => ResponsiveDialog(child: builder(context)),
  );
}

/// A dialog that adapts its width based on screen size
class ResponsiveDialog extends StatelessWidget {
  /// The content of the dialog
  final Widget child;

  const ResponsiveDialog({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final screenSize = ScreenSize(context);

    double dialogWidth;
    if (screenSize.isPhone) {
      // Nearly full width on phone
      dialogWidth = screenSize.width * 0.9;
    } else if (screenSize.isTablet) {
      // 70% width on tablet
      dialogWidth = screenSize.width * 0.7;
    } else {
      // Fixed max width on desktop
      dialogWidth = 600;
    }

    return Dialog(
      child: Container(
        constraints: BoxConstraints(maxWidth: dialogWidth, maxHeight: screenSize.height * 0.9),
        child: child,
      ),
    );
  }
}

/// A standard dialog content layout with title, content, and actions
class ResponsiveDialogContent extends StatelessWidget {
  /// The title of the dialog
  final String title;

  /// The main content
  final Widget content;

  /// Action buttons (typically Cancel/Confirm)
  final List<Widget> actions;

  /// Optional icon to display in the title
  final IconData? icon;

  const ResponsiveDialogContent({
    super.key,
    required this.title,
    required this.content,
    this.actions = const [],
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title section
        Padding(
          padding: const EdgeInsets.all(24.0),
          child: Row(
            children: [
              if (icon != null) ...[Icon(icon, color: theme.colorScheme.primary, size: 28), const SizedBox(width: 16)],
              Expanded(child: Text(title, style: theme.textTheme.headlineSmall)),
            ],
          ),
        ),

        // Content section (scrollable)
        Flexible(
          child: SingleChildScrollView(padding: const EdgeInsets.symmetric(horizontal: 24.0), child: content),
        ),

        // Actions section
        if (actions.isNotEmpty)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                for (int i = 0; i < actions.length; i++) ...[if (i > 0) const SizedBox(width: 8), actions[i]],
              ],
            ),
          ),
      ],
    );
  }
}
