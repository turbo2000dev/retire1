import 'package:flutter/material.dart';
import 'package:retire1/core/ui/responsive/layout_breakpoints.dart';
import 'package:retire1/core/ui/responsive/screen_size.dart';

/// A container that adapts its width and padding based on screen size
class ResponsiveContainer extends StatelessWidget {
  /// The child widget to display
  final Widget child;

  /// Maximum width constraint (defaults to maxContentWidth)
  final double? maxWidth;

  /// Whether to apply responsive padding
  final bool applyPadding;

  /// Custom padding (overrides responsive padding)
  final EdgeInsetsGeometry? padding;

  /// Alignment of the content
  final AlignmentGeometry alignment;

  const ResponsiveContainer({
    super.key,
    required this.child,
    this.maxWidth,
    this.applyPadding = true,
    this.padding,
    this.alignment = Alignment.topCenter,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = ScreenSize(context);

    // Determine padding
    EdgeInsetsGeometry effectivePadding;
    if (padding != null) {
      effectivePadding = padding!;
    } else if (applyPadding) {
      effectivePadding = EdgeInsets.all(screenSize.spacing);
    } else {
      effectivePadding = EdgeInsets.zero;
    }

    return Align(
      alignment: alignment,
      child: Container(
        constraints: BoxConstraints(maxWidth: maxWidth ?? LayoutBreakpoints.maxContentWidth),
        padding: effectivePadding,
        child: child,
      ),
    );
  }
}
