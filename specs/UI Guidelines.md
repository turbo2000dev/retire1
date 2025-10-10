# Responsive Design Guidelines

## Core Concepts

### Breakpoints
```dart
static const double phoneMax = 600;    // < 600px
static const double tabletMax = 1024;  // 600px - 1024px
static const double desktopMin = 1024; // > 1024px
```

### Width Constraints
```dart
static const double maxContentWidth = 1200;  // Overall content
static const double maxFormWidth = 600;      // Forms and inputs
```

## Responsive Widgets Guide

### ResponsiveBuilder
**When to use:** Base component for creating responsive layouts that adapt to different screen sizes.

**How to use:**
```dart
ResponsiveBuilder(
  builder: (context, screenSize) {
    if (screenSize.isPhone) {
      return PhoneLayout();
    }
    return DesktopLayout();
  },
  // Optional specific builders
  phone: (context) => PhoneLayout(),
  tablet: (context) => TabletLayout(),
  desktop: (context) => DesktopLayout(),
)
```

### ResponsiveContainer
**When to use:** For content sections that need width constraints and consistent padding across screen sizes.

**How to use:**
```dart
ResponsiveContainer(
  maxWidth: LayoutBreakpoints.maxFormWidth,
  padding: EdgeInsets.all(24),
  alignment: Alignment.center,
  child: YourContent(),
)
```

### ResponsiveTextField
**When to use:** For form inputs that need to scale appropriately across different screen sizes.

**How to use:**
```dart
ResponsiveTextField(
  controller: textController,
  labelText: 'Input Label',
  helperText: 'Helper text',
  maxLines: 1,
  validator: (value) => validateInput(value),
)
```

### ResponsiveButton
**When to use:** For buttons that need consistent sizing and loading states across devices.

**How to use:**
```dart
ResponsiveButton(
  onPressed: handlePress,
  label: 'Submit',
  isLoading: loading,
  size: ResponsiveButtonSize.medium,
  fillWidth: true,
)
```

### ResponsiveCard
**When to use:** For content cards that need consistent styling and optional expansion states.

**How to use:**
```dart
ResponsiveCard(
  title: Text('Card Title'),
  subtitle: Text('Subtitle'),
  description: Text('Description'),
  badges: [StatusBadge(label: 'Active')],
  expanded: true,
  onTap: handleTap,
)
```

### ResponsiveDialog
**When to use:** For modal dialogs that scale appropriately based on screen size.

**How to use:**
```dart
ResponsiveDialog(
  title: Text('Dialog Title'),
  content: DialogContent(),
  actions: [
    TextButton(onPressed: () {}, child: Text('Cancel')),
    FilledButton(onPressed: () {}, child: Text('Confirm')),
  ],
)
```

### ResponsiveBottomSheet
**When to use:** For bottom sheets that adapt to screen size and support scrollable content.

**How to use:**
```dart
ResponsiveBottomSheet(
  title: Text('Sheet Title'),
  content: SheetContent(),
  scrollable: true,
  showDragHandle: true,
)
```

### ResponsiveCollapsibleSection
**When to use:** For expandable content sections with consistent styling across devices.

**How to use:**
```dart
ResponsiveCollapsibleSection(
  title: Text('Section Title'),
  subtitle: Text('Optional subtitle'),
  initiallyExpanded: true,
  child: SectionContent(),
)
```

### ResponsiveMultiPaneLayout
**When to use:** For complex layouts requiring multiple panes that adapt to screen size.

**How to use:**
```dart
ResponsiveMultiPaneLayout(
  startPane: NavigationPane(),
  centerPane: ContentPane(),
  endPane: DetailPane(),
  centerPaneWidth: 380,
  isCollapsible: true,
)
```

## Best Practices

### Layout Construction
1. Start with phone layout first
2. Use `ResponsiveBuilder` for conditional layouts
3. Use `ResponsiveContainer` for consistent content width constraints
4. Implement proper scaling for constrained environments

### Performance Guidelines
1. Use `const` constructors where possible
2. Leverage `ResponsiveBuilder`'s specific builders (phone, tablet, desktop) for simpler cases
3. Avoid unnecessary widget rebuilds in responsive layouts
4. Test scrolling performance with large lists

### Accessibility
1. Maintain minimum touch target size of 48x48 pixels
2. Use proper text scaling with `TextScaling` utility
3. Implement keyboard navigation support
4. Test with screen readers

### Testing Checklist
- Test on iPhone SE (smallest supported size)
- Test on iPad (both orientations)
- Test on desktop at various widths
- Verify height-constrained environments
- Check orientation changes
- Validate form states
- Test dialog/modal displays
- Verify scrolling behavior

## Common Patterns

### Navigation
- Use bottom navigation for phone layouts (max 5 items)
- Use navigation rail for tablet/desktop
- Support both collapsed and expanded states for navigation rail

### Forms
- Use `ResponsiveTextField` for inputs
- Group related fields with consistent spacing
- Show validation messages inline
- Scale padding based on screen size

### Content Hierarchy
1. Keep essential content visible across all screens
2. Scale content instead of hiding when possible
3. Maintain consistent visual hierarchy
4. Consider both width and height constraints

## Layout Constants Reference

### Spacing
```dart
static const double spacing = 16;
static const double spacingSmall = 8;
static const double spacingLarge = 24;
static const double spacingXLarge = 32;
```

### Navigation
```dart
static const double sideNavRailWidth = 72;
static const double sideNavExtendedWidth = 180;
```

### Input Heights
```dart
static const double inputHeight = 56;
static const double buttonHeight = 48;
```