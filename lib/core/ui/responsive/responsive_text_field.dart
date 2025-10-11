import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A text field that adapts its appearance based on screen size
class ResponsiveTextField extends StatelessWidget {
  /// The controller for the text field
  final TextEditingController? controller;

  /// The label text
  final String? label;

  /// The hint text
  final String? hint;

  /// The helper text
  final String? helperText;

  /// The error text
  final String? errorText;

  /// Whether the field is required
  final bool required;

  /// Whether the text should be obscured (for passwords)
  final bool obscureText;

  /// The keyboard type
  final TextInputType? keyboardType;

  /// Input formatters
  final List<TextInputFormatter>? inputFormatters;

  /// Validator function
  final String? Function(String?)? validator;

  /// On changed callback
  final void Function(String)? onChanged;

  /// On submitted callback
  final void Function(String)? onSubmitted;

  /// Prefix icon
  final Widget? prefixIcon;

  /// Suffix icon
  final Widget? suffixIcon;

  /// Maximum lines (1 for single line, null for multiline)
  final int? maxLines;

  /// Minimum lines (for multiline fields)
  final int? minLines;

  /// Whether the field is enabled
  final bool enabled;

  /// Auto focus
  final bool autofocus;

  /// Text capitalization
  final TextCapitalization textCapitalization;

  const ResponsiveTextField({
    super.key,
    this.controller,
    this.label,
    this.hint,
    this.helperText,
    this.errorText,
    this.required = false,
    this.obscureText = false,
    this.keyboardType,
    this.inputFormatters,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.prefixIcon,
    this.suffixIcon,
    this.maxLines = 1,
    this.minLines,
    this.enabled = true,
    this.autofocus = false,
    this.textCapitalization = TextCapitalization.none,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      validator: validator,
      onChanged: onChanged,
      onFieldSubmitted: onSubmitted,
      maxLines: obscureText ? 1 : maxLines,
      minLines: minLines,
      enabled: enabled,
      autofocus: autofocus,
      textCapitalization: textCapitalization,
      decoration: InputDecoration(
        labelText: label != null && required ? '$label *' : label,
        hintText: hint,
        helperText: helperText,
        errorText: errorText,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        border: const OutlineInputBorder(),
      ),
    );
  }
}
