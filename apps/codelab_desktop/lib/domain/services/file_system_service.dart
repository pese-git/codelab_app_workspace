/// Интерфейс сервиса файловой системы
///
/// Реализуется в Infrastructure Layer.
/// Используется при обработке server→client RPC вызовов fs/*.
abstract interface class FileSystemService {
  /// Читает текстовый файл
  /// [line] — начальная строка (1-based, опционально)
  /// [limit] — количество строк (опционально)
  Future<String> readTextFile(String path, {int? line, int? limit});

  /// Записывает текстовый файл
  Future<void> writeTextFile(String path, String content);

  /// Проверяет существование файла
  Future<bool> exists(String path);
}
