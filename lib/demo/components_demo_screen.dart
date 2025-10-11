import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retire1/core/ui/responsive/responsive_bottom_sheet.dart';
import 'package:retire1/core/ui/responsive/responsive_builder.dart';
import 'package:retire1/core/ui/responsive/responsive_button.dart';
import 'package:retire1/core/ui/responsive/responsive_card.dart';
import 'package:retire1/core/ui/responsive/responsive_collapsible_section.dart';
import 'package:retire1/core/ui/responsive/responsive_container.dart';
import 'package:retire1/core/ui/responsive/responsive_dialog.dart';
import 'package:retire1/core/ui/responsive/responsive_text_field.dart';
import 'package:retire1/main.dart';

/// Demo screen showcasing all responsive components
class ComponentsDemoScreen extends ConsumerStatefulWidget {
  const ComponentsDemoScreen({super.key});

  @override
  ConsumerState<ComponentsDemoScreen> createState() => _ComponentsDemoScreenState();
}

class _ComponentsDemoScreenState extends ConsumerState<ComponentsDemoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _textController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _showSampleDialog() {
    showResponsiveDialog(
      context: context,
      builder: (context) => ResponsiveDialogContent(
        title: 'Sample Dialog',
        icon: Icons.info_outline,
        content: const Text(
          'This is a responsive dialog that adapts its width based on screen size. '
          'On phone it takes most of the width, on tablet 70%, and on desktop it has a fixed max width.',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
          ElevatedButton(onPressed: () => Navigator.of(context).pop(), child: const Text('OK')),
        ],
      ),
    );
  }

  void _showSampleBottomSheet() {
    showResponsiveBottomSheet(
      context: context,
      builder: (context) => ResponsiveBottomSheetContent(
        title: 'Sample Bottom Sheet',
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('This bottom sheet shows as a modal sheet on phone and as a dialog on tablet/desktop.'),
            const SizedBox(height: 16),
            ResponsiveTextField(label: 'Enter something', hint: 'Type here...'),
          ],
        ),
        actions: [TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Close'))],
      ),
    );
  }

  void _simulateLoading() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeModeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Components Demo'),
        actions: [
          IconButton(
            icon: Icon(themeMode == ThemeMode.light ? Icons.dark_mode : Icons.light_mode),
            onPressed: () {
              ref.read(themeModeProvider.notifier).state = themeMode == ThemeMode.light
                  ? ThemeMode.dark
                  : ThemeMode.light;
            },
            tooltip: themeMode == ThemeMode.light ? 'Switch to Dark Mode' : 'Switch to Light Mode',
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: ResponsiveContainer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),

              // Buttons Section
              ResponsiveCollapsibleSection(
                title: 'Buttons',
                subtitle: 'Different button sizes and variants',
                icon: Icons.touch_app,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    const Text('Button Sizes:'),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        ResponsiveButton(
                          size: ResponsiveButtonSize.small,
                          onPressed: () {},
                          child: const Text('Small'),
                        ),
                        ResponsiveButton(
                          size: ResponsiveButtonSize.medium,
                          onPressed: () {},
                          child: const Text('Medium'),
                        ),
                        ResponsiveButton(
                          size: ResponsiveButtonSize.large,
                          onPressed: () {},
                          child: const Text('Large'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text('Button Variants:'),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        ResponsiveButton(onPressed: () {}, child: const Text('Elevated')),
                        ResponsiveButton.outlined(onPressed: () {}, child: const Text('Outlined')),
                        ResponsiveButton.text(onPressed: () {}, child: const Text('Text')),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text('Button States:'),
                    const SizedBox(height: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ResponsiveButton(
                          fillWidth: true,
                          onPressed: () {},
                          icon: Icons.check,
                          child: const Text('With Icon'),
                        ),
                        const SizedBox(height: 8),
                        ResponsiveButton(
                          fillWidth: true,
                          onPressed: _simulateLoading,
                          isLoading: _isLoading,
                          child: const Text('Loading State'),
                        ),
                        const SizedBox(height: 8),
                        ResponsiveButton(fillWidth: true, onPressed: null, child: const Text('Disabled')),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Text Fields Section
              ResponsiveCollapsibleSection(
                title: 'Text Fields',
                subtitle: 'Form inputs with validation',
                icon: Icons.text_fields,
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const SizedBox(height: 8),
                      ResponsiveTextField(
                        controller: _textController,
                        label: 'Email',
                        hint: 'Enter your email',
                        required: true,
                        keyboardType: TextInputType.emailAddress,
                        prefixIcon: const Icon(Icons.email),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Email is required';
                          }
                          if (!value.contains('@')) {
                            return 'Invalid email format';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      ResponsiveTextField(
                        label: 'Password',
                        hint: 'Enter password',
                        required: true,
                        obscureText: true,
                        prefixIcon: const Icon(Icons.lock),
                        suffixIcon: const Icon(Icons.visibility),
                      ),
                      const SizedBox(height: 16),
                      ResponsiveTextField(
                        label: 'Bio',
                        hint: 'Tell us about yourself',
                        maxLines: 4,
                        helperText: 'Optional multiline field',
                      ),
                      const SizedBox(height: 16),
                      ResponsiveButton(
                        fillWidth: true,
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Form is valid!')));
                          }
                        },
                        child: const Text('Validate Form'),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Cards Section
              ResponsiveCollapsibleSection(
                title: 'Cards',
                subtitle: 'Content cards with various configurations',
                icon: Icons.card_membership,
                child: Column(
                  children: [
                    const SizedBox(height: 8),
                    ResponsiveCard(
                      title: 'Simple Card',
                      subtitle: 'With title and subtitle',
                      description: 'This is a basic card with title, subtitle, and description.',
                      leading: const CircleAvatar(child: Icon(Icons.person)),
                      trailing: IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
                    ),
                    const SizedBox(height: 12),
                    ResponsiveCard(
                      title: 'Expandable Card',
                      subtitle: 'Tap to expand/collapse',
                      expandable: true,
                      initiallyExpanded: false,
                      description:
                          'This content is hidden until you expand the card. '
                          'It can contain any amount of text or widgets.',
                      badge: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'New',
                          style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onPrimaryContainer),
                        ),
                      ),
                      child: Column(
                        children: [
                          const Divider(),
                          ListTile(
                            leading: const Icon(Icons.settings),
                            title: const Text('Additional content'),
                            subtitle: const Text('Can include any widget'),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    ResponsiveCard(
                      title: 'Tappable Card',
                      description: 'This card has an onTap handler',
                      leading: const Icon(Icons.touch_app, size: 32),
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Card tapped!')));
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Dialogs & Sheets Section
              ResponsiveCollapsibleSection(
                title: 'Dialogs & Bottom Sheets',
                subtitle: 'Adaptive modal components',
                icon: Icons.chat_bubble_outline,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 8),
                    const Text(
                      'These components adapt based on screen size:',
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                    const SizedBox(height: 12),
                    ResponsiveButton.outlined(
                      fillWidth: true,
                      onPressed: _showSampleDialog,
                      icon: Icons.open_in_new,
                      child: const Text('Show Dialog'),
                    ),
                    const SizedBox(height: 8),
                    ResponsiveButton.outlined(
                      fillWidth: true,
                      onPressed: _showSampleBottomSheet,
                      icon: Icons.vertical_align_bottom,
                      child: const Text('Show Bottom Sheet'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Responsive Builder Section
              ResponsiveCollapsibleSection(
                title: 'Responsive Builder',
                subtitle: 'Different layouts for different screen sizes',
                icon: Icons.devices,
                child: Column(
                  children: [
                    const SizedBox(height: 8),
                    ResponsiveBuilder(
                      phone: (context, screenSize) => Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(color: Colors.blue.shade100, borderRadius: BorderRadius.circular(8)),
                        child: Row(
                          children: [
                            Icon(Icons.phone_android, color: Colors.blue.shade700),
                            const SizedBox(width: 12),
                            const Expanded(child: Text('Phone Layout: Vertical stack, full width')),
                          ],
                        ),
                      ),
                      tablet: (context, screenSize) => Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(color: Colors.green.shade100, borderRadius: BorderRadius.circular(8)),
                        child: Row(
                          children: [
                            Icon(Icons.tablet, color: Colors.green.shade700),
                            const SizedBox(width: 12),
                            const Expanded(child: Text('Tablet Layout: Medium spacing, balanced')),
                          ],
                        ),
                      ),
                      desktop: (context, screenSize) => Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.purple.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.computer, color: Colors.purple.shade700),
                            const SizedBox(width: 12),
                            const Expanded(child: Text('Desktop Layout: Wide, spacious, multi-column')),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
