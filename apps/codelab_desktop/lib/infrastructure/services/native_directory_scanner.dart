import 'dart:io';

import 'package:structured_log/structured_log.dart';
import 'package:uuid/uuid.dart';

import '../../app/models/workspace_models.dart';
import '../../domain/services/directory_scanner_service.dart';

class NativeDirectoryScanner implements DirectoryScannerService {
  NativeDirectoryScanner();

  final _log = getLogger('NativeDirectoryScanner');
  static const _ignoredDirs = {
    '.git',
    '.svn',
    '.hg',
    'node_modules',
    '.dart_tool',
    'build',
    '__pycache__',
    '.venv',
    'venv',
    '.idea',
    '.vscode',
  };
  static const _ignoredFiles = {
    '.DS_Store',
    'Thumbs.db',
    '.flutter-plugins-dependencies',
    '.flutter-plugins',
  };
  static const _maxChildren = 100;

  @override
  Future<List<WorkspaceNode>> scanDirectory(
    String path, {
    int maxDepth = 3,
  }) async {
    final directory = Directory(path);
    if (!await directory.exists()) {
      _log.warning('Directory does not exist: $path');
      return [];
    }

    return _scanDirectorySync(directory, depth: 0, maxDepth: maxDepth);
  }

  List<WorkspaceNode> _scanDirectorySync(
    Directory dir, {
    required int depth,
    required int maxDepth,
  }) {
    if (depth >= maxDepth) return [];

    final nodes = <WorkspaceNode>[];
    var childCount = 0;

    try {
      final entities = dir.listSync(followLinks: false);
      final sorted = [...entities]..sort((a, b) {
        final aIsDir = a is Directory;
        final bIsDir = b is Directory;
        if (aIsDir && !bIsDir) return -1;
        if (!aIsDir && bIsDir) return 1;
        return a.path.compareTo(b.path);
      });

      for (final entity in sorted) {
        if (childCount >= _maxChildren) break;

        final name = _entityName(entity);
        if (_shouldIgnore(name, entity)) continue;

        if (entity is Directory) {
          final children = _scanDirectorySync(
            entity,
            depth: depth + 1,
            maxDepth: maxDepth,
          );
          nodes.add(WorkspaceNode(
            id: const Uuid().v4(),
            label: name,
            kind: 'folder',
            children: children,
          ));
          childCount++;
        } else if (entity is File) {
          nodes.add(WorkspaceNode(
            id: const Uuid().v4(),
            label: name,
            kind: 'file',
          ));
          childCount++;
        }
      }
    } catch (e) {
      _log.warning('Failed to scan directory: ${dir.path}. Error: $e');
    }

    return nodes;
  }

  String _entityName(FileSystemEntity entity) {
    return entity.path.split('/').lastWhere((p) => p.isNotEmpty);
  }

  bool _shouldIgnore(String name, FileSystemEntity entity) {
    if (_ignoredDirs.contains(name) && entity is Directory) return true;
    if (_ignoredFiles.contains(name) && entity is File) return true;
    if (name.startsWith('.') && entity is Directory) return true;
    return false;
  }
}
