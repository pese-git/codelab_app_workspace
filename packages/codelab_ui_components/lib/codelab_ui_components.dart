/// CodeLab Desktop UI Components Library
///
/// A comprehensive collection of reusable UI components built on top of
/// Flutter and Fluent UI, following atomic design principles.
///
/// ## Structure
///
/// - **Theme**: Design tokens, themes, and markdown styles
/// - **Foundations**: Base components (surface, focus, icons, loaders, skeletons)
/// - **Atoms**: Basic UI elements (buttons, text, badges, inputs, etc.)
/// - **Molecules**: Composite components (lists, menus, tabs, dropdowns, etc.)
/// - **Organisms**: Complex components (session, shell)
/// - **Layout**: Layout utilities (stack, grid, split view, overlays)
/// - **Icons**: Icon exports
///
/// ## Usage
///
/// ```dart
/// import 'package:codelab_ui_components/codelab_ui_components.dart';
/// ```
library;

// =============================================================================
// THEME
// =============================================================================

export 'components/theme/tokens.dart';
export 'components/theme/themes.dart';
export 'components/theme/markdown_styles.dart';

// =============================================================================
// FOUNDATIONS
// =============================================================================

export 'components/foundations/surface.dart';
export 'components/foundations/focus_ring.dart';
export 'components/foundations/icon.dart';
export 'components/foundations/skeleton.dart';
export 'components/foundations/loaders.dart';

// =============================================================================
// ATOMS
// =============================================================================

export 'components/atoms/button.dart';
export 'components/atoms/icon_button.dart';
export 'components/atoms/text.dart';
export 'components/atoms/badge.dart';
export 'components/atoms/tag.dart';
export 'components/atoms/divider.dart';
export 'components/atoms/avatar.dart';
export 'components/atoms/tooltip.dart';
export 'components/atoms/checkbox.dart';
export 'components/atoms/toggle.dart';
export 'components/atoms/segmented_control.dart';
export 'components/atoms/text_field.dart';
export 'components/atoms/text_area.dart';
export 'components/atoms/search_field.dart';
export 'components/atoms/scrollbar.dart';

// =============================================================================
// MOLECULES
// =============================================================================

export 'components/molecules/list_item.dart';
export 'components/molecules/menu_item.dart';
export 'components/molecules/toolbar.dart';
export 'components/molecules/tabs.dart';
export 'components/molecules/pill_tabs.dart';
export 'components/molecules/breadcrumbs.dart';
export 'components/molecules/toast.dart';
export 'components/molecules/snackbar.dart';
export 'components/molecules/dropdown.dart';
export 'components/molecules/select.dart';
export 'components/molecules/option_list.dart';
export 'components/molecules/input_group.dart';
export 'components/molecules/code_block.dart';
export 'components/molecules/markdown_view.dart';
export 'components/molecules/empty_state.dart';
export 'components/molecules/section_header.dart';

// =============================================================================
// ORGANISMS - SESSION
// =============================================================================

export 'components/organisms/session/message_bubble.dart';
export 'components/organisms/session/message_timeline.dart';
export 'components/organisms/session/prompt_composer.dart';
export 'components/organisms/session/session_tabs.dart';
export 'components/organisms/session/file_list.dart';
export 'components/organisms/session/review_list.dart';
export 'components/organisms/session/terminal_panel_shell.dart';
export 'components/organisms/session/terminal_session_tabs.dart';
export 'components/organisms/session/session_header.dart';

// =============================================================================
// ORGANISMS - SHELL
// =============================================================================

export 'components/organisms/shell/title_bar.dart';
export 'components/organisms/shell/project_rail.dart';
export 'components/organisms/shell/sidebar.dart';
export 'components/organisms/shell/context_panel.dart';
export 'components/organisms/shell/desktop_shell.dart';

// =============================================================================
// LAYOUT
// =============================================================================

export 'components/layout/stack.dart';
export 'components/layout/overlay_host.dart';
export 'components/layout/split_view.dart';
export 'components/layout/grid.dart';

// =============================================================================
// ICONS
// =============================================================================

export 'components/icons/icons.dart';
