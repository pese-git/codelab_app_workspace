import 'package:uuid/uuid.dart';

import '../../../app/models/workspace_models.dart';

class ProjectEntity {
  ProjectEntity({
    required this.id,
    required this.name,
    required this.path,
  });

  factory ProjectEntity.fromPath(String path) {
    final name = path.split('/').lastWhere((p) => p.isNotEmpty);
    return ProjectEntity(
      id: const Uuid().v4(),
      name: name,
      path: path,
    );
  }

  final String id;
  final String name;
  final String path;

  ProjectModel toProjectModel({
    List<SessionModel> sessions = const [],
    List<WorkspaceNode> workspaceRoots = const [],
  }) {
    final colorValue = _generateColor(name);
    return ProjectModel(
      id: id,
      name: name,
      path: path,
      initials: _generateInitials(name),
      color: colorValue,
      sessions: sessions,
      workspaceRoots: workspaceRoots,
    );
  }

  String _generateInitials(String name) {
    final parts = name.replaceAll(RegExp(r'[_\-]'), ' ').split(' ');
    if (parts.length >= 2) {
      return (parts[0][0] + parts[1][0]).toUpperCase();
    }
    return name.substring(0, 1).toUpperCase();
  }

  int _generateColor(String name) {
    int hash = 0;
    for (var i = 0; i < name.length; i++) {
      hash = name.codeUnitAt(i) + ((hash << 5) - hash);
    }
    final h = hash.abs() % 360;
    final r = _hslToRgb(h / 360, 0.6, 0.55);
    return 0xFF000000 | ((r[0] << 16) | (r[1] << 8) | r[2]);
  }

  List<int> _hslToRgb(double h, double s, double l) {
    double r, g, b;
    if (s == 0) {
      r = g = b = l;
    } else {
      final q = l < 0.5 ? l * (1 + s) : l + s - l * s;
      final p = 2 * l - q;
      r = _hueToRgb(p, q, h + 1 / 3);
      g = _hueToRgb(p, q, h);
      b = _hueToRgb(p, q, h - 1 / 3);
    }
    return [(r * 255).round(), (g * 255).round(), (b * 255).round()];
  }

  double _hueToRgb(double p, double q, double t) {
    if (t < 0) t += 1;
    if (t > 1) t -= 1;
    if (t < 1 / 6) return p + (q - p) * 6 * t;
    if (t < 1 / 2) return q;
    if (t < 2 / 3) return p + (q - p) * (2 / 3 - t) * 6;
    return p;
  }
}
