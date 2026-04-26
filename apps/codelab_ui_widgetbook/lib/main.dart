import 'package:codelab_ui_components/codelab_ui_components.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

void main() {
  runApp(const WidgetbookApp());
}

class WidgetbookApp extends StatelessWidget {
  const WidgetbookApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Widgetbook.material(
      addons: [
        MaterialThemeAddon(themes: [
          WidgetbookTheme(name: 'Light', data: AppTheme.light),
          WidgetbookTheme(name: 'Dark', data: AppTheme.dark),
        ]),
        TextScaleAddon(scales: const [1, 1.25, 1.5]),
      ],
      directories: [
        WidgetbookCategory(
          name: 'Theme',
          children: [
            WidgetbookComponent(
              name: 'Tokens',
              useCases: [
                WidgetbookUseCase(
                  name: 'Colors',
                  builder: (context) => _TokensPreview.colors(),
                ),
                WidgetbookUseCase(
                  name: 'Typography',
                  builder: (context) => _TokensPreview.typography(),
                ),
                WidgetbookUseCase(
                  name: 'Spacing',
                  builder: (context) => _TokensPreview.spacing(),
                ),
              ],
            ),
          ],
        ),
        WidgetbookCategory(
          name: 'Atoms',
          children: [
            WidgetbookComponent(
              name: 'Buttons',
              useCases: [
                WidgetbookUseCase(
                  name: 'Variants',
                  builder: (context) => _ButtonShowcase(),
                ),
              ],
            ),
            WidgetbookComponent(
              name: 'Checkbox',
              useCases: [
                WidgetbookUseCase(
                  name: 'Default',
                  builder: (context) => _CheckboxShowcase(),
                ),
              ],
            ),
            WidgetbookComponent(
              name: 'Tag',
              useCases: [
                WidgetbookUseCase(
                  name: 'Default',
                  builder: (context) => _TagShowcase(),
                ),
              ],
            ),
            WidgetbookComponent(
              name: 'Text',
              useCases: [
                WidgetbookUseCase(
                  name: 'Variants',
                  builder: (context) => _TextShowcase(),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class _PreviewScaffold extends StatelessWidget {
  const _PreviewScaffold({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      home: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.xxl),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}

class _TokensPreview {
  static Widget colors() {
    final light = AppColors.light;
    final dark = AppColors.dark;
    Widget colorSwatch(String label, Color color) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: color,
              borderRadius: AppRadius.mdAll,
              border: Border.all(color: Colors.black12),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(label, style: AppTypography.caption()),
        ],
      );
    }

    return _PreviewScaffold(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText.title('Light colors'),
                const SizedBox(height: AppSpacing.md),
                Wrap(
                  spacing: AppSpacing.md,
                  runSpacing: AppSpacing.md,
                  children: [
                    colorSwatch('Background', light.backgroundBase),
                    colorSwatch('Surface', light.surfaceBase),
                    colorSwatch('Accent', light.accentPrimary),
                    colorSwatch('Success', light.successBase),
                    colorSwatch('Warning', light.warningBase),
                    colorSwatch('Error', light.errorBase),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.xxl),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText.title('Dark colors'),
                const SizedBox(height: AppSpacing.md),
                Wrap(
                  spacing: AppSpacing.md,
                  runSpacing: AppSpacing.md,
                  children: [
                    colorSwatch('Background', dark.backgroundBase),
                    colorSwatch('Surface', dark.surfaceBase),
                    colorSwatch('Accent', dark.accentPrimary),
                    colorSwatch('Success', dark.successBase),
                    colorSwatch('Warning', dark.warningBase),
                    colorSwatch('Error', dark.errorBase),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget typography() {
    return _PreviewScaffold(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          AppText.display('Display'),
          SizedBox(height: AppSpacing.sm),
          AppText.headline('Headline'),
          SizedBox(height: AppSpacing.sm),
          AppText.title('Title'),
          SizedBox(height: AppSpacing.sm),
          AppText.subtitle('Subtitle'),
          SizedBox(height: AppSpacing.sm),
          AppText.label('Label'),
          SizedBox(height: AppSpacing.sm),
          AppText('Body'),
          SizedBox(height: AppSpacing.sm),
          AppText('Body Medium', variant: TextVariant.bodyMedium),
          SizedBox(height: AppSpacing.sm),
          AppText.small('Small'),
          SizedBox(height: AppSpacing.sm),
          AppText.caption('Caption'),
          SizedBox(height: AppSpacing.sm),
          AppText.code('Code sample();'),
        ],
      ),
    );
  }

  static Widget spacing() {
    Widget bar(double width, String label) {
      return Row(
        children: [
          Container(
            width: width,
            height: 12,
            decoration: BoxDecoration(
              color: Colors.black12,
              borderRadius: AppRadius.fullAll,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          AppText.small('$label (${width.toInt()}dp)'),
        ],
      );
    }

    return _PreviewScaffold(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText.title('Spacing scale'),
          const SizedBox(height: AppSpacing.md),
          bar(AppSpacing.xs2, 'xs2'),
          const SizedBox(height: AppSpacing.sm),
          bar(AppSpacing.xs, 'xs'),
          const SizedBox(height: AppSpacing.sm),
          bar(AppSpacing.sm2, 'sm2'),
          const SizedBox(height: AppSpacing.sm),
          bar(AppSpacing.sm, 'sm'),
          const SizedBox(height: AppSpacing.sm),
          bar(AppSpacing.md2, 'md2'),
          const SizedBox(height: AppSpacing.sm),
          bar(AppSpacing.md, 'md'),
          const SizedBox(height: AppSpacing.sm),
          bar(AppSpacing.lg2, 'lg2'),
          const SizedBox(height: AppSpacing.sm),
          bar(AppSpacing.lg, 'lg'),
          const SizedBox(height: AppSpacing.sm),
          bar(AppSpacing.xl2, 'xl2'),
          const SizedBox(height: AppSpacing.sm),
          bar(AppSpacing.xl, 'xl'),
          const SizedBox(height: AppSpacing.sm),
          bar(AppSpacing.xxl, 'xxl'),
          const SizedBox(height: AppSpacing.sm),
          bar(AppSpacing.xxl2, 'xxl2'),
          const SizedBox(height: AppSpacing.sm),
          bar(AppSpacing.xxxl, 'xxxl'),
          const SizedBox(height: AppSpacing.sm),
          bar(AppSpacing.huge, 'huge'),
          const SizedBox(height: AppSpacing.sm),
          bar(AppSpacing.massive, 'massive'),
          const SizedBox(height: AppSpacing.sm),
          bar(AppSpacing.giant, 'giant'),
        ],
      ),
    );
  }
}

class _ButtonShowcase extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _PreviewScaffold(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText.title('AppButton variants'),
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: AppSpacing.md,
            runSpacing: AppSpacing.md,
            children: const [
              AppButton(label: 'Primary', onPressed: null),
              AppButton.secondary(label: 'Secondary', onPressed: null),
              AppButton.tertiary(label: 'Tertiary', onPressed: null),
              AppButton.destructive(label: 'Destructive', onPressed: null),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          AppText.subtitle('Sizes'),
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: AppSpacing.md,
            runSpacing: AppSpacing.md,
            children: const [
              AppButton(label: 'Small', size: ButtonSize.sm, onPressed: null),
              AppButton(label: 'Medium', size: ButtonSize.md, onPressed: null),
              AppButton(label: 'Large', size: ButtonSize.lg, onPressed: null),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          AppText.subtitle('Loading / Disabled'),
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: AppSpacing.md,
            runSpacing: AppSpacing.md,
            children: const [
              AppButton(label: 'Loading', isLoading: true, onPressed: null),
              AppButton(label: 'Disabled', isDisabled: true, onPressed: null),
            ],
          ),
        ],
      ),
    );
  }
}

class _CheckboxShowcase extends StatefulWidget {
  @override
  State<_CheckboxShowcase> createState() => _CheckboxShowcaseState();
}

class _CheckboxShowcaseState extends State<_CheckboxShowcase> {
  bool value = true;

  @override
  Widget build(BuildContext context) {
    return _PreviewScaffold(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText.title('Checkbox'),
          const SizedBox(height: AppSpacing.md),
          AppCheckbox(
            value: value,
            onChanged: (v) => setState(() => value = v),
            label: 'Receive updates',
          ),
          const SizedBox(height: AppSpacing.md),
          const AppCheckbox(
            value: false,
            onChanged: null,
            label: 'Disabled',
            isDisabled: true,
          ),
        ],
      ),
    );
  }
}

class _TagShowcase extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _PreviewScaffold(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          AppText.title('Tags'),
          SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              Tag(label: 'Default'),
              Tag(label: 'Selected', isSelected: true),
              Tag(label: 'With icon', icon: Icons.star),
            ],
          ),
        ],
      ),
    );
  }
}

class _TextShowcase extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _PreviewScaffold(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          AppText.title('Text variants'),
          SizedBox(height: AppSpacing.md),
          AppText.caption('Caption'),
          AppText.small('Small'),
          AppText('Body'),
          AppText('Body medium', variant: TextVariant.bodyMedium),
          AppText.label('Label'),
          AppText.subtitle('Subtitle'),
          AppText.title('Title'),
          AppText.headline('Headline'),
          AppText.display('Display'),
          AppText.code('Code sample();'),
        ],
      ),
    );
  }
}

void _noop() {}
