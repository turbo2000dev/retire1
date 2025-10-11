import 'package:flutter/material.dart';

/// Size variants for the responsive button
enum ResponsiveButtonSize {
  small,
  medium,
  large,
}

/// A button that adapts its size based on configuration
class ResponsiveButton extends StatelessWidget {
  /// The button text or child widget
  final Widget child;

  /// On pressed callback
  final VoidCallback? onPressed;

  /// Button size variant
  final ResponsiveButtonSize size;

  /// Whether the button should fill the available width
  final bool fillWidth;

  /// Whether the button is in loading state
  final bool isLoading;

  /// Button style (elevated, outlined, or text)
  final _ResponsiveButtonStyle _style;

  /// Custom icon to display before the text
  final IconData? icon;

  const ResponsiveButton({
    super.key,
    required this.child,
    required this.onPressed,
    this.size = ResponsiveButtonSize.medium,
    this.fillWidth = false,
    this.isLoading = false,
    this.icon,
  }) : _style = _ResponsiveButtonStyle.elevated;

  const ResponsiveButton.outlined({
    super.key,
    required this.child,
    required this.onPressed,
    this.size = ResponsiveButtonSize.medium,
    this.fillWidth = false,
    this.isLoading = false,
    this.icon,
  }) : _style = _ResponsiveButtonStyle.outlined;

  const ResponsiveButton.text({
    super.key,
    required this.child,
    required this.onPressed,
    this.size = ResponsiveButtonSize.medium,
    this.fillWidth = false,
    this.isLoading = false,
    this.icon,
  }) : _style = _ResponsiveButtonStyle.text;

  EdgeInsets get _padding {
    switch (size) {
      case ResponsiveButtonSize.small:
        return const EdgeInsets.symmetric(horizontal: 12, vertical: 8);
      case ResponsiveButtonSize.medium:
        return const EdgeInsets.symmetric(horizontal: 20, vertical: 12);
      case ResponsiveButtonSize.large:
        return const EdgeInsets.symmetric(horizontal: 24, vertical: 16);
    }
  }

  double get _fontSize {
    switch (size) {
      case ResponsiveButtonSize.small:
        return 14;
      case ResponsiveButtonSize.medium:
        return 16;
      case ResponsiveButtonSize.large:
        return 18;
    }
  }

  double get _iconSize {
    switch (size) {
      case ResponsiveButtonSize.small:
        return 18;
      case ResponsiveButtonSize.medium:
        return 20;
      case ResponsiveButtonSize.large:
        return 24;
    }
  }

  Widget _buildButtonContent(BuildContext context) {
    if (isLoading) {
      return SizedBox(
        width: _iconSize,
        height: _iconSize,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(
            _style == _ResponsiveButtonStyle.elevated
                ? Colors.white
                : Theme.of(context).colorScheme.primary,
          ),
        ),
      );
    }

    if (icon != null) {
      return Row(
        mainAxisSize: fillWidth ? MainAxisSize.max : MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: _iconSize),
          const SizedBox(width: 8),
          child,
        ],
      );
    }

    return child;
  }

  @override
  Widget build(BuildContext context) {
    final buttonStyle = ButtonStyle(
      padding: WidgetStateProperty.all(_padding),
      textStyle: WidgetStateProperty.all(
        TextStyle(fontSize: _fontSize),
      ),
      minimumSize: fillWidth
          ? WidgetStateProperty.all(const Size(double.infinity, 0))
          : null,
    );

    final content = _buildButtonContent(context);
    final effectiveOnPressed = isLoading ? null : onPressed;

    switch (_style) {
      case _ResponsiveButtonStyle.elevated:
        return ElevatedButton(
          onPressed: effectiveOnPressed,
          style: buttonStyle,
          child: content,
        );
      case _ResponsiveButtonStyle.outlined:
        return OutlinedButton(
          onPressed: effectiveOnPressed,
          style: buttonStyle,
          child: content,
        );
      case _ResponsiveButtonStyle.text:
        return TextButton(
          onPressed: effectiveOnPressed,
          style: buttonStyle,
          child: content,
        );
    }
  }
}

enum _ResponsiveButtonStyle {
  elevated,
  outlined,
  text,
}
