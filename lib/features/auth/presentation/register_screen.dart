import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:retire1/core/ui/responsive/responsive_button.dart';
import 'package:retire1/core/ui/responsive/responsive_container.dart';
import 'package:retire1/core/ui/responsive/responsive_text_field.dart';
import 'package:retire1/core/ui/responsive/layout_breakpoints.dart';
import 'package:retire1/core/router/app_router.dart';
import 'package:retire1/features/auth/presentation/providers/auth_provider.dart';

/// Registration screen for creating new accounts
class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _displayNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _displayNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  String? _validateDisplayName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Display name is required';
    }
    if (value.length < 2) {
      return 'Display name must be at least 2 characters';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  String _getPasswordStrength(String password) {
    if (password.isEmpty) return '';
    if (password.length < 6) return 'Weak';
    if (password.length < 8) return 'Fair';
    if (password.length >= 8 && password.contains(RegExp(r'[A-Z]')) && password.contains(RegExp(r'[0-9]'))) {
      return 'Strong';
    }
    return 'Good';
  }

  Color _getPasswordStrengthColor(String strength) {
    switch (strength) {
      case 'Weak':
        return Colors.red;
      case 'Fair':
        return Colors.orange;
      case 'Good':
        return Colors.blue;
      case 'Strong':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  Future<void> _handleRegister() async {
    if (_formKey.currentState!.validate()) {
      await ref.read(authNotifierProvider.notifier).register(
            _emailController.text,
            _passwordController.text,
            _displayNameController.text,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    final theme = Theme.of(context);

    // Listen for successful authentication
    ref.listen<AuthState>(authNotifierProvider, (previous, next) {
      if (next is Authenticated) {
        context.go(AppRoutes.dashboard);
      }
    });

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go(AppRoutes.login),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: ResponsiveContainer(
              maxWidth: 500, // Constrain form width for better UX
              padding: const EdgeInsets.all(LayoutBreakpoints.spacingComfortable),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Title
                    Text(
                      'Create Account',
                      style: theme.textTheme.headlineMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Sign up to get started',
                      style: theme.textTheme.bodyLarge,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),

                    // Display name field
                    ResponsiveTextField(
                      controller: _displayNameController,
                      label: 'Display Name',
                      validator: _validateDisplayName,
                      prefixIcon: const Icon(Icons.person_outlined),
                    ),
                    const SizedBox(height: 16),

                    // Email field
                    ResponsiveTextField(
                      controller: _emailController,
                      label: 'Email',
                      keyboardType: TextInputType.emailAddress,
                      validator: _validateEmail,
                      prefixIcon: const Icon(Icons.email_outlined),
                    ),
                    const SizedBox(height: 16),

                    // Password field with strength indicator
                    ResponsiveTextField(
                      controller: _passwordController,
                      label: 'Password',
                      obscureText: _obscurePassword,
                      validator: _validatePassword,
                      prefixIcon: const Icon(Icons.lock_outlined),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword ? Icons.visibility : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                      onChanged: (_) => setState(() {}),
                    ),
                    if (_passwordController.text.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 8, left: 12),
                        child: Row(
                          children: [
                            Text(
                              'Password strength: ',
                              style: theme.textTheme.bodySmall,
                            ),
                            Text(
                              _getPasswordStrength(_passwordController.text),
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: _getPasswordStrengthColor(
                                  _getPasswordStrength(_passwordController.text),
                                ),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 16),

                    // Confirm password field
                    ResponsiveTextField(
                      controller: _confirmPasswordController,
                      label: 'Confirm Password',
                      obscureText: _obscureConfirmPassword,
                      validator: _validateConfirmPassword,
                      prefixIcon: const Icon(Icons.lock_outlined),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureConfirmPassword ? Icons.visibility : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureConfirmPassword = !_obscureConfirmPassword;
                          });
                        },
                      ),
                      onSubmitted: (_) => _handleRegister(),
                    ),
                    const SizedBox(height: 24),

                    // Error message
                    if (authState is AuthError)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Text(
                          authState.message,
                          style: TextStyle(color: theme.colorScheme.error),
                          textAlign: TextAlign.center,
                        ),
                      ),

                    // Register button
                    Center(
                      child: ResponsiveButton(
                        onPressed: authState is AuthLoading ? null : _handleRegister,
                        isLoading: authState is AuthLoading,
                        size: ResponsiveButtonSize.large,
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 32),
                          child: Text('Create Account'),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Login link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Already have an account? ',
                          style: theme.textTheme.bodyMedium,
                        ),
                        TextButton(
                          onPressed: () {
                            context.go(AppRoutes.login);
                          },
                          child: const Text('Sign In'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
