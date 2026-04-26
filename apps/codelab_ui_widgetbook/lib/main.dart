import 'package:codelab_ui_components/codelab_ui_components.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/material.dart' hide Badge, DropdownMenu;
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:widgetbook/widgetbook.dart';

// Представительский Widgetbook для всех компонентов codelab_ui_components.
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
        TextScaleAddon(min: 1, max: 1.5),
      ],
      directories: [
        _themeCategory,
        _foundationsCategory,
        _atomsCategory,
        _moleculesCategory,
        _organismsCategory,
        _layoutCategory,
        _iconsCategory,
      ],
    );
  }
}

// ==========================================================================
// Categories
// ==========================================================================

final _themeCategory = WidgetbookCategory(
  name: 'Theme',
  children: [
    WidgetbookComponent(
      name: 'Tokens',
      useCases: [
        WidgetbookUseCase(name: 'Colors', builder: (_) => _TokensPreview.colors()),
        WidgetbookUseCase(name: 'Typography', builder: (_) => _TokensPreview.typography()),
        WidgetbookUseCase(name: 'Spacing', builder: (_) => _TokensPreview.spacing()),
      ],
    ),
  ],
);

final _foundationsCategory = WidgetbookCategory(
  name: 'Foundations',
  children: [
    WidgetbookComponent(name: 'Surface', useCases: [WidgetbookUseCase(name: 'Variants', builder: (_) => _SurfacePreview())]),
    WidgetbookComponent(name: 'FocusRing', useCases: [WidgetbookUseCase(name: 'States', builder: (_) => _FocusRingPreview())]),
    WidgetbookComponent(name: 'Icons', useCases: [WidgetbookUseCase(name: 'Sizes', builder: (_) => _IconPreview())]),
    WidgetbookComponent(name: 'Skeleton', useCases: [WidgetbookUseCase(name: 'Loaders', builder: (_) => _SkeletonPreview())]),
    WidgetbookComponent(name: 'Loaders', useCases: [WidgetbookUseCase(name: 'Progress', builder: (_) => _LoadersPreview())]),
  ],
);

final _atomsCategory = WidgetbookCategory(
  name: 'Atoms',
  children: [
    WidgetbookComponent(name: 'Button', useCases: [WidgetbookUseCase(name: 'Variants', builder: (_) => _ButtonShowcase())]),
    WidgetbookComponent(name: 'IconButton', useCases: [WidgetbookUseCase(name: 'Variants', builder: (_) => _IconButtonPreview())]),
    WidgetbookComponent(name: 'Text', useCases: [WidgetbookUseCase(name: 'Variants', builder: (_) => _TextShowcase())]),
    WidgetbookComponent(name: 'Badge', useCases: [WidgetbookUseCase(name: 'Statuses', builder: (_) => _BadgePreview())]),
    WidgetbookComponent(name: 'Tag', useCases: [WidgetbookUseCase(name: 'States', builder: (_) => _TagShowcase())]),
    WidgetbookComponent(name: 'Divider', useCases: [WidgetbookUseCase(name: 'Types', builder: (_) => _DividerPreview())]),
    WidgetbookComponent(name: 'Avatar', useCases: [WidgetbookUseCase(name: 'Variants', builder: (_) => _AvatarPreview())]),
    WidgetbookComponent(name: 'Tooltip', useCases: [WidgetbookUseCase(name: 'Variants', builder: (_) => _TooltipPreview())]),
    WidgetbookComponent(name: 'Checkbox', useCases: [WidgetbookUseCase(name: 'States', builder: (_) => _CheckboxShowcase())]),
    WidgetbookComponent(name: 'Toggle', useCases: [WidgetbookUseCase(name: 'States', builder: (_) => _TogglePreview())]),
    WidgetbookComponent(name: 'SegmentedControl', useCases: [WidgetbookUseCase(name: 'Basic', builder: (_) => _SegmentedPreview())]),
    WidgetbookComponent(name: 'TextField', useCases: [WidgetbookUseCase(name: 'Inputs', builder: (_) => _TextFieldPreview())]),
    WidgetbookComponent(name: 'TextArea', useCases: [WidgetbookUseCase(name: 'Inputs', builder: (_) => _TextAreaPreview())]),
    WidgetbookComponent(name: 'SearchField', useCases: [WidgetbookUseCase(name: 'Default', builder: (_) => _SearchFieldPreview())]),
    WidgetbookComponent(name: 'Scrollbar', useCases: [WidgetbookUseCase(name: 'Variants', builder: (_) => _ScrollbarPreview())]),
  ],
);

final _moleculesCategory = WidgetbookCategory(
  name: 'Molecules',
  children: [
    WidgetbookComponent(name: 'ListItem', useCases: [WidgetbookUseCase(name: 'Variants', builder: (_) => _ListItemPreview())]),
    WidgetbookComponent(name: 'MenuItem', useCases: [WidgetbookUseCase(name: 'Variants', builder: (_) => _MenuItemPreview())]),
    WidgetbookComponent(name: 'Toolbar', useCases: [WidgetbookUseCase(name: 'Actions', builder: (_) => _ToolbarPreview())]),
    WidgetbookComponent(name: 'Tabs', useCases: [WidgetbookUseCase(name: 'Tabs', builder: (_) => _TabsPreview())]),
    WidgetbookComponent(name: 'PillTabs', useCases: [WidgetbookUseCase(name: 'Pills', builder: (_) => _PillTabsPreview())]),
    WidgetbookComponent(name: 'Breadcrumbs', useCases: [WidgetbookUseCase(name: 'Trail', builder: (_) => _BreadcrumbsPreview())]),
    WidgetbookComponent(name: 'Toast', useCases: [WidgetbookUseCase(name: 'Inline', builder: (_) => _ToastPreview())]),
    WidgetbookComponent(name: 'Snackbar', useCases: [WidgetbookUseCase(name: 'Inline', builder: (_) => _SnackbarPreview())]),
    WidgetbookComponent(name: 'Dropdown', useCases: [WidgetbookUseCase(name: 'Basic', builder: (_) => _DropdownPreview())]),
    WidgetbookComponent(name: 'Select', useCases: [WidgetbookUseCase(name: 'Fields', builder: (_) => _SelectPreview())]),
    WidgetbookComponent(name: 'OptionList', useCases: [WidgetbookUseCase(name: 'Options', builder: (_) => _OptionListPreview())]),
    WidgetbookComponent(name: 'InputGroup', useCases: [WidgetbookUseCase(name: 'Form', builder: (_) => _InputGroupPreview())]),
    WidgetbookComponent(name: 'CodeBlock', useCases: [WidgetbookUseCase(name: 'Code', builder: (_) => _CodeBlockPreview())]),
    WidgetbookComponent(name: 'MarkdownView', useCases: [WidgetbookUseCase(name: 'Markdown', builder: (_) => _MarkdownPreview())]),
    WidgetbookComponent(name: 'EmptyState', useCases: [WidgetbookUseCase(name: 'States', builder: (_) => _EmptyStatePreview())]),
    WidgetbookComponent(name: 'SectionHeader', useCases: [WidgetbookUseCase(name: 'Headers', builder: (_) => _SectionHeaderPreview())]),
  ],
);

final _organismsCategory = WidgetbookCategory(
  name: 'Organisms',
  children: [
    WidgetbookFolder(
      name: 'Session',
      children: [
        WidgetbookComponent(name: 'MessageBubble', useCases: [WidgetbookUseCase(name: 'Variants', builder: (_) => _MessageBubblePreview())]),
        WidgetbookComponent(name: 'MessageTimeline', useCases: [WidgetbookUseCase(name: 'Timeline', builder: (_) => _MessageTimelinePreview())]),
        WidgetbookComponent(name: 'PromptComposer', useCases: [WidgetbookUseCase(name: 'Composer', builder: (_) => _PromptComposerPreview())]),
        WidgetbookComponent(name: 'SessionTabs', useCases: [WidgetbookUseCase(name: 'Tabs', builder: (_) => _SessionTabsPreview())]),
        WidgetbookComponent(name: 'FileList', useCases: [WidgetbookUseCase(name: 'Tree', builder: (_) => _FileListPreview())]),
        WidgetbookComponent(name: 'ReviewList', useCases: [WidgetbookUseCase(name: 'Cards', builder: (_) => _ReviewListPreview())]),
        WidgetbookComponent(name: 'TerminalPanelShell', useCases: [WidgetbookUseCase(name: 'Shell', builder: (_) => _TerminalShellPreview())]),
        WidgetbookComponent(name: 'SessionHeader', useCases: [WidgetbookUseCase(name: 'Header', builder: (_) => _SessionHeaderPreview())]),
      ],
    ),
    WidgetbookFolder(
      name: 'Shell',
      children: [
        WidgetbookComponent(name: 'TitleBar', useCases: [WidgetbookUseCase(name: 'Title', builder: (_) => _TitleBarPreview())]),
        WidgetbookComponent(name: 'ProjectRail', useCases: [WidgetbookUseCase(name: 'Rail', builder: (_) => _ProjectRailPreview())]),
        WidgetbookComponent(name: 'Sidebar', useCases: [WidgetbookUseCase(name: 'Sidebar', builder: (_) => _SidebarPreview())]),
        WidgetbookComponent(name: 'ContextPanel', useCases: [WidgetbookUseCase(name: 'Context', builder: (_) => _ContextPanelPreview())]),
        WidgetbookComponent(name: 'DesktopShell', useCases: [WidgetbookUseCase(name: 'Shell', builder: (_) => _DesktopShellPreview())]),
      ],
    ),
  ],
);

final _layoutCategory = WidgetbookCategory(
  name: 'Layout',
  children: [
    WidgetbookComponent(name: 'Stack', useCases: [WidgetbookUseCase(name: 'Layers', builder: (_) => _StackPreview())]),
    WidgetbookComponent(name: 'OverlayHost', useCases: [WidgetbookUseCase(name: 'Overlays', builder: (_) => _OverlayHostPreview())]),
    WidgetbookComponent(name: 'SplitView', useCases: [WidgetbookUseCase(name: 'Resizable', builder: (_) => _SplitViewPreview())]),
    WidgetbookComponent(name: 'Grid', useCases: [WidgetbookUseCase(name: 'Responsive', builder: (_) => _GridPreview())]),
  ],
);

final _iconsCategory = WidgetbookCategory(
  name: 'Icons',
  children: [
    WidgetbookComponent(name: 'AppIcons', useCases: [WidgetbookUseCase(name: 'Catalog', builder: (_) => _IconsShowcase())]),
  ],
);

// ==========================================================================
// Shared preview scaffolding
// ==========================================================================

class _PreviewScaffold extends StatelessWidget {
  const _PreviewScaffold({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final brightness = MediaQuery.of(context).platformBrightness;
    final fluentTheme = brightness == Brightness.light
        ? AppTheme.fluentLight
        : AppTheme.fluentDark;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      localizationsDelegates: const [
        fluent.FluentLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en', 'US')],
      home: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1000),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.xxl),
              child: fluent.FluentTheme(
                data: fluentTheme,
                child: SingleChildScrollView(
                  primary: false,
                  padding: const EdgeInsets.only(bottom: AppSpacing.xxl),
                  child: child,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// (content continues with previews)

// Helpers
class _DemoBox extends StatelessWidget {
  const _DemoBox({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppRadius.mdAll,
        border: Border.all(color: Colors.black12),
      ),
      child: Text(label),
    );
  }
}

class _ColoredBox extends StatelessWidget {
  const _ColoredBox({required this.color, required this.size});
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, borderRadius: AppRadius.mdAll),
    );
  }
}

void _noop() {}
void _noopBool([bool _ = false]) {}
void _noopNullable([dynamic _]) {}
void _noopSet([Set<dynamic>? _]) {}
void _noopString([String _ = '']) {}
void _noopContextTab([ContextPanelTab _ = ContextPanelTab.details]) {}

// ==========================================================================
// Theme previews
// ==========================================================================

class _TokensPreview extends StatelessWidget {
  const _TokensPreview._();

  factory _TokensPreview.colors() => const _TokensPreview._();
  factory _TokensPreview.typography() => const _TokensPreview._();
  factory _TokensPreview.spacing() => const _TokensPreview._();

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.light;
    return _PreviewScaffold(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText.title('Colors'),
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: AppSpacing.md,
            runSpacing: AppSpacing.md,
            children: [
              _ColoredBox(color: colors.backgroundBase, size: 64),
              _ColoredBox(color: colors.surfaceBase, size: 64),
              _ColoredBox(color: colors.accentPrimary, size: 64),
              _ColoredBox(color: colors.successBase, size: 64),
              _ColoredBox(color: colors.warningBase, size: 64),
              _ColoredBox(color: colors.errorBase, size: 64),
              _ColoredBox(color: colors.infoBase, size: 64),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          AppText.title('Typography'),
          const SizedBox(height: AppSpacing.sm),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              AppText.display('Display'),
              AppText.headline('Headline'),
              AppText.title('Title'),
              AppText.subtitle('Subtitle'),
              AppText.label('Label'),
              AppText.body('Body'),
              AppText.small('Small'),
              AppText.caption('Caption'),
              AppText.code('Code'),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          AppText.title('Spacing'),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.md,
            children: const [
              _DemoBox(label: 'xs'),
              _DemoBox(label: 'sm'),
              _DemoBox(label: 'md'),
              _DemoBox(label: 'lg'),
              _DemoBox(label: 'xl'),
              _DemoBox(label: 'xxl'),
            ],
          ),
        ],
      ),
    );
  }
}

// ==========================================================================
// Foundations previews
// ==========================================================================

class _SurfacePreview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _PreviewScaffold(
      child: Column(
        children: const [
          Surface(
            elevation: AppElevation.low,
            padding: EdgeInsets.all(AppSpacing.md),
            child: AppText('Default surface'),
          ),
          SizedBox(height: AppSpacing.md),
          ElevatedSurface(
            elevation: AppElevation.medium,
            padding: EdgeInsets.all(AppSpacing.md),
            child: AppText('Elevated surface'),
          ),
          SizedBox(height: AppSpacing.md),
          OutlinedSurface(
            padding: EdgeInsets.all(AppSpacing.md),
            child: AppText('Outlined surface'),
          ),
        ],
      ),
    );
  }
}

class _FocusRingPreview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _PreviewScaffold(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          FocusRing(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: AppText('Focus me'),
            ),
          ),
          const FocusBorder(
            focused: true,
            child: Padding(
              padding: EdgeInsets.all(AppSpacing.md),
              child: AppText('Focused state'),
            ),
          ),
        ],
      ),
    );
  }
}

class _IconPreview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _PreviewScaffold(
      child: Wrap(
        spacing: AppSpacing.md,
        runSpacing: AppSpacing.md,
        children: const [
          AppIcon(AppIcons.add),
          AppIcon.sm(AppIcons.delete),
          AppIcon.lg(AppIcons.search),
          AppIcon.xl(AppIcons.terminal),
        ],
      ),
    );
  }
}

class _SkeletonPreview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _PreviewScaffold(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Skeleton.text(width: 160),
          const SizedBox(height: AppSpacing.sm),
          const Skeleton.rect(height: 80),
          const SizedBox(height: AppSpacing.sm),
          Skeleton.circle(size: 32),
        ],
      ),
    );
  }
}

class _LoadersPreview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _PreviewScaffold(
      child: Wrap(
        spacing: AppSpacing.xl,
        children: const [
          AppProgressRing(),
          AppProgressRing(value: 0.6),
          AppProgressBar(value: 0.4, height: 6),
          LoadingIndicator(message: 'Loading...'),
        ],
      ),
    );
  }
}

// ==========================================================================
// Atoms previews
// ==========================================================================

class _ButtonShowcase extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _PreviewScaffold(
      child: Wrap(
        spacing: AppSpacing.sm,
        runSpacing: AppSpacing.sm,
        children: const [
          AppButton(label: 'Primary', onPressed: _noop),
          AppButton.secondary(label: 'Secondary', onPressed: _noop),
          AppButton.tertiary(label: 'Tertiary', onPressed: _noop),
          AppButton.destructive(label: 'Destructive', onPressed: _noop),
          AppButton(label: 'Loading', onPressed: _noop, isLoading: true),
          AppButton(label: 'Disabled', onPressed: null),
        ],
      ),
    );
  }
}

class _IconButtonPreview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _PreviewScaffold(
      child: Wrap(
        spacing: AppSpacing.sm,
        children: [
          const AppIconButton(icon: AppIcons.add, onPressed: _noop),
          const AppIconButton(icon: AppIcons.delete, onPressed: _noop, isDisabled: true),
          AppToggleIconButton(
            icon: AppIcons.success,
            selectedIcon: AppIcons.success,
            isSelected: true,
            onChanged: _noopBool,
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
          AppText.display('Display'),
          AppText.headline('Headline'),
          AppText.title('Title'),
          AppText.subtitle('Subtitle'),
          AppText.label('Label'),
          AppText.body('Body'),
          AppText.small('Small'),
          AppText.caption('Caption'),
        ],
      ),
    );
  }
}

class _BadgePreview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _PreviewScaffold(
      child: Wrap(
        spacing: AppSpacing.sm,
        children: const [
          Badge(label: 'Neutral'),
          Badge.primary('Primary'),
          Badge.success('Success'),
          Badge.warning('Warning'),
          Badge.error('Error'),
          Badge.info('Info'),
          CountBadge(count: 42),
          DotBadge(),
        ],
      ),
    );
  }
}

class _TagShowcase extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _PreviewScaffold(
      child: Wrap(
        spacing: AppSpacing.sm,
        runSpacing: AppSpacing.sm,
        children: const [
          Tag(label: 'Default'),
          Tag(label: 'Selected', isSelected: true),
          Tag(label: 'With Icon', icon: Icons.star),
          Tag(label: 'Removable', onRemove: _noop),
          TagGroup(tags: ['One', 'Two', 'Three'], selectedIndex: 1),
        ],
      ),
    );
  }
}

class _DividerPreview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _PreviewScaffold(
      child: Column(
        children: const [
          AppText('Above'),
          Divider(),
          AppText('Below'),
        ],
      ),
    );
  }
}

class _AvatarPreview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _PreviewScaffold(
      child: Wrap(
        spacing: AppSpacing.md,
        children: const [
          Avatar(initials: 'AB'),
          Avatar(size: AvatarSize.lg, initials: 'CD'),
          AvatarStack(avatars: [
            AvatarData(initials: 'AB'),
            AvatarData(initials: 'CD'),
            AvatarData(initials: 'EF'),
            AvatarData(initials: 'GH'),
          ]),
        ],
      ),
    );
  }
}

class _TooltipPreview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _PreviewScaffold(
      child: const Tooltip(
        message: 'Tooltip message',
        child: AppText('Hover me'),
      ),
    );
  }
}

class _CheckboxShowcase extends StatefulWidget {
  const _CheckboxShowcase();
  @override
  State<_CheckboxShowcase> createState() => _CheckboxShowcaseState();
}

class _CheckboxShowcaseState extends State<_CheckboxShowcase> {
  bool _value = true;
  @override
  Widget build(BuildContext context) {
    return _PreviewScaffold(
      child: CheckboxListTile(
        value: _value,
        onChanged: (v) => setState(() => _value = v ?? false),
        title: const AppText('Checkbox state'),
      ),
    );
  }
}

class _TogglePreview extends StatefulWidget {
  const _TogglePreview();
  @override
  State<_TogglePreview> createState() => _TogglePreviewState();
}

class _TogglePreviewState extends State<_TogglePreview> {
  bool _value = true;
  @override
  Widget build(BuildContext context) {
    return _PreviewScaffold(
      child: SwitchListTile(
        value: _value,
        onChanged: (v) => setState(() => _value = v),
        title: const AppText('Toggle'),
      ),
    );
  }
}

class _SegmentedPreview extends StatefulWidget {
  const _SegmentedPreview();
  @override
  State<_SegmentedPreview> createState() => _SegmentedPreviewState();
}

class _SegmentedPreviewState extends State<_SegmentedPreview> {
  int _index = 0;
  @override
  Widget build(BuildContext context) {
    return _PreviewScaffold(
      child: SegmentedControl<int>(
        segments: const {0: 'First', 1: 'Second', 2: 'Third'},
        selected: _index,
        onChanged: (i) => setState(() => _index = i),
      ),
    );
  }
}

class _TextFieldPreview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _PreviewScaffold(
      child: Column(
        children: const [
          AppTextField(label: 'Label', placeholder: 'Placeholder'),
          SizedBox(height: AppSpacing.md),
          AppTextField(label: 'Error', error: 'Required'),
        ],
      ),
    );
  }
}

class _TextAreaPreview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _PreviewScaffold(
      child: const AppTextArea(
        label: 'Multiline',
        placeholder: 'Type here...',
        minLines: 3,
      ),
    );
  }
}

class _SearchFieldPreview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _PreviewScaffold(
      child: const SearchField(placeholder: 'Search...'),
    );
  }
}

class _ScrollbarPreview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _PreviewScaffold(
      child: SizedBox(
        height: 200,
        child: AppScrollbar(
          child: ListView.builder(
            itemCount: 20,
            itemBuilder: (_, i) => Padding(
              padding: const EdgeInsets.all(AppSpacing.sm),
              child: AppText('Item $i'),
            ),
          ),
        ),
      ),
    );
  }
}

// ==========================================================================
// Molecules previews
// ==========================================================================

class _ListItemPreview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _PreviewScaffold(
      child: Column(
        children: const [
          ListItem(title: 'Item title', subtitle: 'Subtitle'),
          ListItem(title: 'Selected', isSelected: true),
          CheckableListItem(title: 'Checkable', isChecked: true, onChanged: _noopBool),
        ],
      ),
    );
  }
}

class _MenuItemPreview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _PreviewScaffold(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          MenuItem(label: 'Default', icon: AppIcons.add, onTap: _noop),
          MenuItem(label: 'Disabled', icon: AppIcons.delete, onTap: null),
        ],
      ),
    );
  }
}

class _ToolbarPreview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _PreviewScaffold(
      child: Toolbar(
        items: const [
          ToolbarButton(icon: AppIcons.add, onPressed: _noop),
          ToolbarButton(icon: AppIcons.delete, onPressed: _noop),
          ToolbarDivider(),
          ToolbarButton(icon: AppIcons.refresh, onPressed: _noop),
          ToolbarSpacer(),
          ToolbarButton(icon: AppIcons.settings, onPressed: _noop),
        ],
      ),
    );
  }
}

class _TabsPreview extends StatefulWidget {
  const _TabsPreview();
  @override
  State<_TabsPreview> createState() => _TabsPreviewState();
}

class _TabsPreviewState extends State<_TabsPreview> {
  int _index = 0;
  @override
  Widget build(BuildContext context) {
    return _PreviewScaffold(
      child: AppTabs<int>(
        tabs: const {0: 'Overview', 1: 'Details', 2: 'Activity'},
        selected: _index,
        onChanged: (i) => setState(() => _index = i),
      ),
    );
  }
}

class _PillTabsPreview extends StatefulWidget {
  const _PillTabsPreview();
  @override
  State<_PillTabsPreview> createState() => _PillTabsPreviewState();
}

class _PillTabsPreviewState extends State<_PillTabsPreview> {
  int _index = 1;
  @override
  Widget build(BuildContext context) {
    return _PreviewScaffold(
      child: PillTabs<int>(
        tabs: const {0: 'Chat', 1: 'Files', 2: 'Review'},
        selected: _index,
        onChanged: (i) => setState(() => _index = i),
      ),
    );
  }
}

class _BreadcrumbsPreview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _PreviewScaffold(
      child: Breadcrumbs(items: const [
        BreadcrumbItem(label: 'Home'),
        BreadcrumbItem(label: 'Projects'),
        BreadcrumbItem(label: 'CodeLab'),
      ]),
    );
  }
}

class _ToastPreview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _PreviewScaffold(
      child: const Toast(message: 'Saved successfully'),
    );
  }
}

class _SnackbarPreview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _PreviewScaffold(
      child: const AppSnackbar(message: 'Connection lost', actionLabel: 'Retry'),
    );
  }
}

class _DropdownPreview extends StatefulWidget {
  const _DropdownPreview();
  @override
  State<_DropdownPreview> createState() => _DropdownPreviewState();
}

class _DropdownPreviewState extends State<_DropdownPreview> {
  String _value = 'One';
  @override
  Widget build(BuildContext context) {
    return _PreviewScaffold(
      child: AppDropdown<String>(
        value: _value,
        items: const [
          DropdownItem(value: 'One', label: 'One'),
          DropdownItem(value: 'Two', label: 'Two'),
          DropdownItem(value: 'Three', label: 'Three'),
        ],
        onChanged: (v) => setState(() => _value = v ?? 'One'),
      ),
    );
  }
}

class _SelectPreview extends StatefulWidget {
  const _SelectPreview();
  @override
  State<_SelectPreview> createState() => _SelectPreviewState();
}

class _SelectPreviewState extends State<_SelectPreview> {
  String _value = 'Option A';
  @override
  Widget build(BuildContext context) {
    return _PreviewScaffold(
      child: SelectField<String>(
        value: _value,
        items: const [
          DropdownItem(value: 'Option A', label: 'Option A'),
          DropdownItem(value: 'Option B', label: 'Option B'),
        ],
        onChanged: (v) => setState(() => _value = v ?? 'Option A'),
      ),
    );
  }
}

class _OptionListPreview extends StatefulWidget {
  const _OptionListPreview();
  @override
  State<_OptionListPreview> createState() => _OptionListPreviewState();
}

class _OptionListPreviewState extends State<_OptionListPreview> {
  final _selected = <String>{'A'};
  @override
  Widget build(BuildContext context) {
    return _PreviewScaffold(
      child: OptionList<String>(
        options: const [
          OptionItem(value: 'A', label: 'Alpha'),
          OptionItem(value: 'B', label: 'Beta'),
          OptionItem(value: 'C', label: 'Gamma', isDisabled: true),
        ],
        selected: _selected,
        multiSelect: true,
        onSelect: (v) => setState(() {
          if (_selected.contains(v)) {
            _selected.remove(v);
          } else {
            _selected.add(v);
          }
        }),
      ),
    );
  }
}

class _InputGroupPreview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _PreviewScaffold(
      child: InputGroup(
        children: const [
          AppTextField(placeholder: 'Search'),
          AppButton(label: 'Go', onPressed: _noop),
        ],
      ),
    );
  }
}

class _CodeBlockPreview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _PreviewScaffold(
      child: const CodeBlock(
        language: 'dart',
        code: """void main() {\n  print('Hello');\n}""",
      ),
    );
  }
}

class _MarkdownPreview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _PreviewScaffold(
      child: const MarkdownView(
        data: '# Heading\n\n* Bullet 1\n* Bullet 2',
      ),
    );
  }
}

class _EmptyStatePreview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _PreviewScaffold(
      child: const EmptyState(
        title: 'No data',
        message: 'Try adding something first.',
      ),
    );
  }
}

class _SectionHeaderPreview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _PreviewScaffold(
      child: const SectionHeader(title: 'Section title', subtitle: 'Action'),
    );
  }
}

// ==========================================================================
// Organisms: Session
// ==========================================================================

class _MessageBubblePreview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _PreviewScaffold(
      child: Column(
        children: [
          MessageBubble(
            message: Message(id: '1', role: MessageRole.user, content: 'Hello'),
          ),
          const SizedBox(height: AppSpacing.sm),
          MessageBubble(
            message: Message(id: '2', role: MessageRole.assistant, content: 'Hi there!'),
          ),
          const SizedBox(height: AppSpacing.sm),
          MessageBubble(
            message: Message(id: '3', role: MessageRole.system, content: 'System message'),
          ),
        ],
      ),
    );
  }
}

class _MessageTimelinePreview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _PreviewScaffold(
      child: SizedBox(
        height: 320,
        child: MessageTimeline(
          messages: [
            Message(id: '1', role: MessageRole.user, content: 'Hello!'),
            Message(id: '2', role: MessageRole.assistant, content: 'How can I help?'),
            Message(id: '3', role: MessageRole.user, content: 'Show me a list.'),
          ],
          onCopyCode: _noopString,
        ),
      ),
    );
  }
}

class _PromptComposerPreview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _PreviewScaffold(
      child: PromptComposer(onSend: _noopString),
    );
  }
}

class _SessionTabsPreview extends StatefulWidget {
  const _SessionTabsPreview();
  @override
  State<_SessionTabsPreview> createState() => _SessionTabsPreviewState();
}

class _SessionTabsPreviewState extends State<_SessionTabsPreview> {
  SessionRegionTab _tab = SessionRegionTab.files;
  @override
  Widget build(BuildContext context) {
    return _PreviewScaffold(
      child: SessionTabs(
        activeTab: _tab,
        onTabChanged: (t) => setState(() => _tab = t),
      ),
    );
  }
}

class _FileListPreview extends StatefulWidget {
  const _FileListPreview();
  @override
  State<_FileListPreview> createState() => _FileListPreviewState();
}

class _FileListPreviewState extends State<_FileListPreview> {
  final _expanded = <String>{'root', 'lib'};
  List<FileNode> get _nodes => const [
        FileNode(
          id: 'root',
          label: 'workspace',
          isFolder: true,
          children: [
            FileNode(id: 'lib', label: 'lib', isFolder: true, children: [
              FileNode(id: 'file1', label: 'main.dart', isFolder: false),
              FileNode(id: 'file2', label: 'app.dart', isFolder: false),
            ]),
            FileNode(id: 'readme', label: 'README.md', isFolder: false, badge: 'new'),
          ],
        ),
      ];
  @override
  Widget build(BuildContext context) {
    return _PreviewScaffold(
      child: FileList(
        nodes: _nodes,
        expandedNodes: _expanded,
        onNodeToggle: (id) => setState(() {
          if (_expanded.contains(id)) {
            _expanded.remove(id);
          } else {
            _expanded.add(id);
          }
        }),
      ),
    );
  }
}

class _ReviewListPreview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _PreviewScaffold(
      child: SizedBox(
        height: 260,
        child: ReviewList(
          items: const [
            ReviewItem(id: '1', title: 'Sidebar density', summary: 'Tighten hover affordance.', severity: 'P2'),
            ReviewItem(id: '2', title: 'Dialog coverage', summary: 'Ensure shared presentation logic.', severity: 'P3'),
          ],
        ),
      ),
    );
  }
}

class _TerminalShellPreview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _PreviewScaffold(
      child: TerminalPanelShell(
         title: 'Terminal', child: const SizedBox.shrink(),
      ),
    );
  }
}

class _SessionHeaderPreview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _PreviewScaffold(
      child: SessionHeader(
        title: 'Greeting in Russian',
        branchName: 'main',
      ),
    );
  }
}

// ==========================================================================
// Organisms: Shell
// ==========================================================================

class _TitleBarPreview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _PreviewScaffold(
      child: TitleBar(
      ),
    );
  }
}

class _ProjectRailPreview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _PreviewScaffold(
      child: ProjectRail(
        projects:  [
          ProjectRailItem(id: '1', name: 'codelab_desktop', initials: 'CD', color: const Color(0xFF4F8CFF)),
          ProjectRailItem(id: '2', name: 'idea_archive', initials: 'IA', color: const Color(0xFF58C27D)),
        ],
        selectedProjectId: '1', onProjectSelected: (String value) {  },
      ),
    );
  }
}

class _SidebarPreview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _PreviewScaffold(
      child: Sidebar(
      projectName: '', projectPath: '',
      ),
    );
  }
}

class _ContextPanelPreview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _PreviewScaffold(
      child: SizedBox(
        height: 400,
        child: ContextPanel(
          activeTab: ContextPanelTab.details,
          onTabChanged: _noopContextTab,
        ),
      ),
    );
  }
}

class _DesktopShellPreview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _PreviewScaffold(
      child: SizedBox(
        height: 500,
        child: DesktopShell(
          titleBar: TitleBar(),
          projectRail: ProjectRail(
            projects:  [ProjectRailItem(id: '1', name: 'app', initials: 'A', color: const Color(0xFF4F8CFF))],
            selectedProjectId: '1', onProjectSelected: (String value) {  },
          ),
          sidebar: Sidebar(
           projectName: '', projectPath: '',
          ),
          contextPanel: ContextPanel(
            activeTab: ContextPanelTab.details,
            onTabChanged: _noopContextTab,
          ),
          bottomPanel: TerminalPanelShell(child: const SizedBox.shrink(),
   
          ),
          showBottomPanel: true,
          content: const Center(child: AppText('Main content area')),
        ),
      ),
    );
  }
}

// ==========================================================================
// Layout previews
// ==========================================================================

class _StackPreview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _PreviewScaffold(
      child: SizedBox(
        height: 200,
        child: AppStack(
          children: [
            Container(color: Colors.blue.withOpacity(0.2)),
            Align(alignment: Alignment.center, child: ElevatedSurface(child: Padding(padding: const EdgeInsets.all(AppSpacing.md), child: AppText('Center')))),
          ],
        ),
      ),
    );
  }
}

class _OverlayHostPreview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _PreviewScaffold(
      child: SizedBox(
        height: 240,
        child: OverlayHost(
          child: Center(
            child: ElevatedSurface(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: const AppText('Base content'),
            ),
          ),
        ),
      ),
    );
  }
}

class _SplitViewPreview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _PreviewScaffold(
      child: SizedBox(
        height: 260,
        child: SplitView(
          initialRatio: 0.3,
          first: Container(color: Colors.blue.withOpacity(0.1), child: const Center(child: AppText('Left'))),
          second: Container(color: Colors.green.withOpacity(0.1), child: const Center(child: AppText('Right'))), 
        ),
      ),
    );
  }
}

class _GridPreview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _PreviewScaffold(
      child: AppGrid(
        spacing: AppSpacing.md,
        columns: 3,
        children: List.generate(
          6,
          (i) => ElevatedSurface(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: AppText('Item ${i + 1}'),
          ),
        ),
      ),
    );
  }
}

// ==========================================================================
// Icons catalog
// ==========================================================================

class _IconsShowcase extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final icons = <IconData>[
      AppIcons.add,
      AppIcons.remove,
      AppIcons.edit,
      AppIcons.delete,
      AppIcons.copy,
      AppIcons.paste,
      AppIcons.save,
      AppIcons.search,
      AppIcons.send,
      AppIcons.folder,
      AppIcons.file,
      AppIcons.branch,
      AppIcons.warning,
      AppIcons.error,
      AppIcons.info,
      AppIcons.settings,
      AppIcons.terminal,
    ];

    return _PreviewScaffold(
      child: Wrap(
        spacing: AppSpacing.md,
        runSpacing: AppSpacing.md,
        children: icons
            .map(
              (icon) => Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppIcon(icon),
                  const SizedBox(height: AppSpacing.xs),
                  AppText.caption(icon.codePoint.toRadixString(16)),
                ],
              ),
            )
            .toList(),
      ),
    );
  }
}
