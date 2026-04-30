import 'dart:io';

import 'package:structured_log/structured_log.dart';

import '../../domain/services/file_system_service.dart';
import '../../core/error/failures.dart';

/// Реализация FileSystemService через dart:io
///
/// Обрабатывает fs/read_text_file и fs/write_text_file запросы от агента.
/// Аналог Python: infrastructure/services/file_system_executor.py
/// Регистрируется в SessionModule как singleton FileSystemService.
class FileSystemHandler implements FileSystemService {
  FileSystemHandler();

  final _log = getLogger('FileSystemHandler');

  @override
  Future<String> readTextFile(
    String path, {
    int? line,
    int? limit,
  }) async {
    _log.debug('fs/read: $path (line=$line, limit=$limit)');

    final file = File(path);
    if (!await file.exists()) {
      throw FileSystemFailure(
        message: 'File not found: $path',
        path: path,
      );
    }

    try {
      if (line == null && limit == null) {
        return await file.readAsString();
      }

      final lines = await file.readAsLines();
      final startIndex = (line != null) ? (line - 1).clamp(0, lines.length) : 0;
      final endIndex = (limit != null)
          ? (startIndex + limit).clamp(0, lines.length)
          : lines.length;

      return lines.sublist(startIndex, endIndex).join('\n');
    } catch (e) {
      if (e is FileSystemFailure) rethrow;
      throw FileSystemFailure(
        message: 'Failed to read file: $path. Error: $e',
        path: path,
      );
    }
  }

  @override
  Future<void> writeTextFile(String path, String content) async {
    _log.debug('fs/write: $path (${content.length} chars)');

    try {
      final file = File(path);
      await file.parent.create(recursive: true);
      await file.writeAsString(content);
    } catch (e) {
      throw FileSystemFailure(
        message: 'Failed to write file: $path. Error: $e',
        path: path,
      );
    }
  }

  @override
  Future<bool> exists(String path) async {
    return File(path).exists();
  }
}
