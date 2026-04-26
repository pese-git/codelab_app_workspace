import 'package:fluent_ui/fluent_ui.dart' as fluent;

import '../../theme/tokens.dart';

/// Project model for the rail.
class ProjectRailItem {
  const ProjectRailItem({
    required this.id,
    required this.name,
    required this.color,
    this.initials,
  });

  final String id;
  final String name;
  final fluent.Color color;
  final String? initials;

  String get displayInitials => initials ?? name.substring(0, 1).toUpperCase();
}

/// Project rail component (left sidebar with project icons).
class ProjectRail extends fluent.StatelessWidget {
  const ProjectRail({
    required this.projects,
    required this.selectedProjectId,
    required this.onProjectSelected,
    this.onAddProject,
    this.onSettings,
    this.onHelp,
    super.key,
  });

  final List<ProjectRailItem> projects;
  final String? selectedProjectId;
  final fluent.ValueChanged<String> onProjectSelected;
  final fluent.VoidCallback? onAddProject;
  final fluent.VoidCallback? onSettings;
  final fluent.VoidCallback? onHelp;

  @override
  fluent.Widget build(fluent.BuildContext context) {
    final brightness = fluent.FluentTheme.of(context).brightness;
    final colors = brightness == fluent.Brightness.light
        ? AppColors.light
        : AppColors.dark;

    return fluent.Container(
      width: AppDimensions.projectRailWidth,
      decoration: fluent.BoxDecoration(
        color: colors.backgroundSubtle,
        border: fluent.Border(
          right: fluent.BorderSide(color: colors.borderBase),
        ),
      ),
      child: fluent.Column(
        children: [
          const fluent.SizedBox(height: 16),
          for (final project in projects)
            fluent.Padding(
              padding: const fluent.EdgeInsets.only(bottom: 14),
              child: fluent.Tooltip(
                message: project.name,
                child: _RailProjectButton(
                  project: project,
                  isSelected: project.id == selectedProjectId,
                  onTap: () => onProjectSelected(project.id),
                ),
              ),
            ),
          if (onAddProject != null)
            fluent.GestureDetector(
              onTap: onAddProject,
              child: fluent.Container(
                width: 32,
                height: 32,
                alignment: fluent.Alignment.center,
                child: fluent.Icon(
                  fluent.FluentIcons.add,
                  size: 17,
                  color: colors.iconWeak,
                ),
              ),
            ),
          const fluent.Spacer(),
          if (onSettings != null)
            fluent.IconButton(
              icon: fluent.Icon(
                fluent.FluentIcons.settings,
                color: colors.iconWeak,
              ),
              onPressed: onSettings,
            ),
          const fluent.SizedBox(height: 8),
          if (onHelp != null)
            fluent.IconButton(
              icon: fluent.Icon(
                fluent.FluentIcons.help,
                color: colors.iconWeak,
              ),
              onPressed: onHelp,
            ),
          const fluent.SizedBox(height: 12),
        ],
      ),
    );
  }
}

class _RailProjectButton extends fluent.StatelessWidget {
  const _RailProjectButton({
    required this.project,
    required this.isSelected,
    required this.onTap,
  });

  final ProjectRailItem project;
  final bool isSelected;
  final fluent.VoidCallback onTap;

  @override
  fluent.Widget build(fluent.BuildContext context) {
    final brightness = fluent.FluentTheme.of(context).brightness;
    final colors = brightness == fluent.Brightness.light
        ? AppColors.light
        : AppColors.dark;

    return fluent.GestureDetector(
      onTap: onTap,
      child: fluent.Container(
        width: 54,
        height: 54,
        padding: const fluent.EdgeInsets.all(4),
        decoration: fluent.BoxDecoration(
          borderRadius: fluent.BorderRadius.circular(14),
          border: fluent.Border.all(
            color: isSelected ? colors.accentPrimary : colors.borderBase,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: fluent.Container(
          alignment: fluent.Alignment.center,
          decoration: fluent.BoxDecoration(
            color: project.color.withValues(alpha: 0.2),
            borderRadius: fluent.BorderRadius.circular(10),
          ),
          child: fluent.Text(
            project.displayInitials,
            style: fluent.TextStyle(
              fontSize: 18,
              fontWeight: fluent.FontWeight.w600,
              color: project.color,
            ),
          ),
        ),
      ),
    );
  }
}
