import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider to manage theme mode state (default to light)
final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.light);

/// Application theme configuration
/// Uses Material 3 design with light and dark themes
class AppTheme {
  // Private constructor to prevent instantiation
  AppTheme._();

  /// Light color scheme using Material 3
  static const ColorScheme _lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFF0062A1), // Blue
    onPrimary: Color(0xFFFFFFFF),
    primaryContainer: Color(0xFFCCE5FF),
    onPrimaryContainer: Color(0xFF001D35),
    secondary: Color(0xFF6750A4), // Purple
    onSecondary: Color(0xFFFFFFFF),
    secondaryContainer: Color(0xFFE8DDFF),
    onSecondaryContainer: Color(0xFF22005D),
    tertiary: Color(0xFF006E26), // Green
    onTertiary: Color(0xFFFFFFFF),
    tertiaryContainer: Color(0xFF96F899),
    onTertiaryContainer: Color(0xFF002107),
    error: Color(0xFFBA1A1A),
    onError: Color(0xFFFFFFFF),
    errorContainer: Color(0xFFFFDAD6),
    onErrorContainer: Color(0xFF410002),
    surface: Color(0xFFFFFBFE),
    onSurface: Color(0xFF1C1B1F),
    surfaceContainerHighest: Color(0xFFE7E0EC),
    onSurfaceVariant: Color(0xFF49454F),
    outline: Color(0xFF79747E),
    outlineVariant: Color(0xFFCAC4D0),
    shadow: Color(0xFF000000),
    scrim: Color(0xFF000000),
    inverseSurface: Color(0xFF313033),
    onInverseSurface: Color(0xFFF4EFF4),
    inversePrimary: Color(0xFF90CAF9),
  );

  /// Dark color scheme using Material 3
  static const ColorScheme _darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFF90CAF9), // Light blue
    onPrimary: Color(0xFF003258),
    primaryContainer: Color(0xFF004A77),
    onPrimaryContainer: Color(0xFFCCE5FF),
    secondary: Color(0xFFB39DDB), // Light purple
    onSecondary: Color(0xFF3A2F5A),
    secondaryContainer: Color(0xFF514572),
    onSecondaryContainer: Color(0xFFE8DDFF),
    tertiary: Color(0xFFA5D6A7), // Light green
    onTertiary: Color(0xFF0D3C0F),
    tertiaryContainer: Color(0xFF255527),
    onTertiaryContainer: Color(0xFFC0F2C2),
    error: Color(0xFFCF6679),
    onError: Color(0xFF690005),
    errorContainer: Color(0xFF93000A),
    onErrorContainer: Color(0xFFFFDAD6),
    surface: Color(0xFF121212),
    onSurface: Color(0xFFE0E0E0),
    surfaceContainerHighest: Color(0xFF2C2C2C),
    onSurfaceVariant: Color(0xFFCAC4CF),
    outline: Color(0xFF948F99),
    outlineVariant: Color(0xFF49454E),
    shadow: Color(0xFF000000),
    scrim: Color(0xFF000000),
    inverseSurface: Color(0xFFE6E1E5),
    onInverseSurface: Color(0xFF313033),
    inversePrimary: Color(0xFF0062A1),
  );

  /// Typography configuration
  static const TextTheme _textTheme = TextTheme(
    displayLarge: TextStyle(
      fontSize: 57,
      fontWeight: FontWeight.w400,
      letterSpacing: -0.25,
    ),
    displayMedium: TextStyle(fontSize: 45, fontWeight: FontWeight.w400),
    displaySmall: TextStyle(fontSize: 36, fontWeight: FontWeight.w400),
    headlineLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.w400),
    headlineMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.w400),
    headlineSmall: TextStyle(fontSize: 24, fontWeight: FontWeight.w400),
    titleLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
    titleMedium: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.15,
    ),
    titleSmall: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.1,
    ),
    bodyLarge: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.5,
    ),
    bodyMedium: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.25,
    ),
    bodySmall: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.4,
    ),
    labelLarge: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.1,
    ),
    labelMedium: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.5,
    ),
    labelSmall: TextStyle(
      fontSize: 11,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.5,
    ),
  );

  /// Main dark theme for the application
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: _darkColorScheme,
      textTheme: _textTheme,

      // AppBar theme
      appBarTheme: AppBarTheme(
        centerTitle: false,
        elevation: 0,
        backgroundColor: _darkColorScheme.surface,
        foregroundColor: _darkColorScheme.onSurface,
        titleTextStyle: _textTheme.titleLarge?.copyWith(
          color: _darkColorScheme.onSurface,
        ),
      ),

      // Card theme
      cardTheme: CardThemeData(
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: _darkColorScheme.surfaceContainerHighest,
      ),

      // Elevated button theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: _textTheme.labelLarge,
        ),
      ),

      // Text button theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: _textTheme.labelLarge,
        ),
      ),

      // Outlined button theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: _textTheme.labelLarge,
          side: BorderSide(color: _darkColorScheme.outline),
        ),
      ),

      // Input decoration theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: _darkColorScheme.surfaceContainerHighest,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: _darkColorScheme.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: _darkColorScheme.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: _darkColorScheme.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: _darkColorScheme.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: _darkColorScheme.error, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        labelStyle: _textTheme.bodyLarge,
        hintStyle: _textTheme.bodyLarge?.copyWith(
          color: _darkColorScheme.onSurfaceVariant,
        ),
      ),

      // Dialog theme
      dialogTheme: DialogThemeData(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: _darkColorScheme.surface,
        titleTextStyle: _textTheme.headlineSmall?.copyWith(
          color: _darkColorScheme.onSurface,
        ),
        contentTextStyle: _textTheme.bodyMedium?.copyWith(
          color: _darkColorScheme.onSurface,
        ),
      ),

      // Bottom sheet theme
      bottomSheetTheme: BottomSheetThemeData(
        elevation: 3,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        backgroundColor: _darkColorScheme.surface,
      ),

      // Navigation bar theme (for bottom navigation)
      navigationBarTheme: NavigationBarThemeData(
        elevation: 3,
        backgroundColor: _darkColorScheme.surface,
        indicatorColor: _darkColorScheme.primaryContainer,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return _textTheme.labelMedium?.copyWith(
              color: _darkColorScheme.onSurface,
            );
          }
          return _textTheme.labelMedium?.copyWith(
            color: _darkColorScheme.onSurfaceVariant,
          );
        }),
      ),

      // Navigation rail theme (for tablet/desktop)
      navigationRailTheme: NavigationRailThemeData(
        elevation: 0,
        backgroundColor: _darkColorScheme.surface,
        indicatorColor: _darkColorScheme.primaryContainer,
        selectedIconTheme: IconThemeData(
          color: _darkColorScheme.onPrimaryContainer,
        ),
        unselectedIconTheme: IconThemeData(
          color: _darkColorScheme.onSurfaceVariant,
        ),
        selectedLabelTextStyle: _textTheme.labelMedium?.copyWith(
          color: _darkColorScheme.onSurface,
        ),
        unselectedLabelTextStyle: _textTheme.labelMedium?.copyWith(
          color: _darkColorScheme.onSurfaceVariant,
        ),
      ),

      // Floating action button theme
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        elevation: 3,
        backgroundColor: _darkColorScheme.primaryContainer,
        foregroundColor: _darkColorScheme.onPrimaryContainer,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),

      // Divider theme
      dividerTheme: DividerThemeData(
        color: _darkColorScheme.outlineVariant,
        thickness: 1,
        space: 1,
      ),

      // Chip theme
      chipTheme: ChipThemeData(
        backgroundColor: _darkColorScheme.surfaceContainerHighest,
        selectedColor: _darkColorScheme.primaryContainer,
        labelStyle: _textTheme.labelLarge?.copyWith(
          color: _darkColorScheme.onSurface,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  /// Main light theme for the application
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: _lightColorScheme,
      textTheme: _textTheme,

      // AppBar theme
      appBarTheme: AppBarTheme(
        centerTitle: false,
        elevation: 0,
        backgroundColor: _lightColorScheme.surface,
        foregroundColor: _lightColorScheme.onSurface,
        titleTextStyle: _textTheme.titleLarge?.copyWith(
          color: _lightColorScheme.onSurface,
        ),
      ),

      // Card theme
      cardTheme: CardThemeData(
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: _lightColorScheme.surfaceContainerHighest,
      ),

      // Elevated button theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: _textTheme.labelLarge,
        ),
      ),

      // Text button theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: _textTheme.labelLarge,
        ),
      ),

      // Outlined button theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: _textTheme.labelLarge,
          side: BorderSide(color: _lightColorScheme.outline),
        ),
      ),

      // Input decoration theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: _lightColorScheme.surfaceContainerHighest,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: _lightColorScheme.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: _lightColorScheme.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: _lightColorScheme.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: _lightColorScheme.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: _lightColorScheme.error, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        labelStyle: _textTheme.bodyLarge,
        hintStyle: _textTheme.bodyLarge?.copyWith(
          color: _lightColorScheme.onSurfaceVariant,
        ),
      ),

      // Dialog theme
      dialogTheme: DialogThemeData(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: _lightColorScheme.surface,
        titleTextStyle: _textTheme.headlineSmall?.copyWith(
          color: _lightColorScheme.onSurface,
        ),
        contentTextStyle: _textTheme.bodyMedium?.copyWith(
          color: _lightColorScheme.onSurface,
        ),
      ),

      // Bottom sheet theme
      bottomSheetTheme: BottomSheetThemeData(
        elevation: 3,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        backgroundColor: _lightColorScheme.surface,
      ),

      // Navigation bar theme (for bottom navigation)
      navigationBarTheme: NavigationBarThemeData(
        elevation: 3,
        backgroundColor: _lightColorScheme.surface,
        indicatorColor: _lightColorScheme.primaryContainer,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return _textTheme.labelMedium?.copyWith(
              color: _lightColorScheme.onSurface,
            );
          }
          return _textTheme.labelMedium?.copyWith(
            color: _lightColorScheme.onSurfaceVariant,
          );
        }),
      ),

      // Navigation rail theme (for tablet/desktop)
      navigationRailTheme: NavigationRailThemeData(
        elevation: 0,
        backgroundColor: _lightColorScheme.surface,
        indicatorColor: _lightColorScheme.primaryContainer,
        selectedIconTheme: IconThemeData(
          color: _lightColorScheme.onPrimaryContainer,
        ),
        unselectedIconTheme: IconThemeData(
          color: _lightColorScheme.onSurfaceVariant,
        ),
        selectedLabelTextStyle: _textTheme.labelMedium?.copyWith(
          color: _lightColorScheme.onSurface,
        ),
        unselectedLabelTextStyle: _textTheme.labelMedium?.copyWith(
          color: _lightColorScheme.onSurfaceVariant,
        ),
      ),

      // Floating action button theme
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        elevation: 3,
        backgroundColor: _lightColorScheme.primaryContainer,
        foregroundColor: _lightColorScheme.onPrimaryContainer,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),

      // Divider theme
      dividerTheme: DividerThemeData(
        color: _lightColorScheme.outlineVariant,
        thickness: 1,
        space: 1,
      ),

      // Chip theme
      chipTheme: ChipThemeData(
        backgroundColor: _lightColorScheme.surfaceContainerHighest,
        selectedColor: _lightColorScheme.primaryContainer,
        labelStyle: _textTheme.labelLarge?.copyWith(
          color: _lightColorScheme.onSurface,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}
