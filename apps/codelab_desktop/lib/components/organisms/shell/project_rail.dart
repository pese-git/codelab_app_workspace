import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/material.dart';

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
  final Color color;
  final String? initials;

  String get displayInitials => initials ?? name.substring(0, 1).toUpperCase();
}

/// Project rail component (left sidebar with project icons).
class ProjectRail extends StatelessWidget {
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
  final ValueChanged<String> onProjectSelected;
  final VoidCallback? onAddProject;
  final VoidCallback? onSettings;
  final VoidCallback? onHelp;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final colors = brightness == Brightness.light ? AppColors.light : AppColors.dark;

    return Container(
      width: AppDimensions.projectRailWidth,
      decoration: BoxDecoration(
        color: colors.backgroundSubtle,
        border: Border(right: BorderSide(color: colors.borderBase)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 16),
          for (final project in projects)
            Padding(
              padding: const EdgeInsets.only(bottom: 14),
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
            GestureDetector(
              onTap: onAddProject,
              child: Container(
                width: 32,
                height: 32,
                alignment: Alignment.center,
                child: Icon(
                  fluent.FluentIcons.add,
                  size: 17,
                  color: colors.iconWeak,
                ),
              ),
            ),
          const Spacer(),
          if (onSettings != null)
            fluent.IconButton(
              icon: Icon(fluent.FluentIcons.settings, color: colors.iconWeak),
              onPressed: onSettings,
            ),
          const SizedBox(height: 8),
          if (onHelp != null)
            fluent.IconButton(
              icon: Icon(fluent.FluentIcons.help, color: colors.iconWeak),
              onPressed: onHelp,
            ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}

class _RailProjectButton extends StatelessWidget {
  const _RailProjectButton({
    required this.project,
    required this.isSelected,
    required this.onTap,
  });

  final ProjectRailItem project;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final colors = brightness == Brightness.light ? AppColors.light : AppColors.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 54,
        height: 54,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? colors.accentPrimary : colors.borderBase,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: project.color.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            project.displayInitials,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: project.color,
            ),
          ),
        ),
      ),
    );
  }
}
