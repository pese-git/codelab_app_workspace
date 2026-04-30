/// Интерфейс сервиса терминала
///
/// Реализуется в Infrastructure Layer.
/// Используется при обработке server→client RPC вызовов terminal/*.
abstract interface class TerminalService {
  /// Создаёт новый терминальный процесс
  /// Возвращает ID терминала
  Future<String> create({
    required String command,
    List<String>? args,
    Map<String, String>? env,
    String? cwd,
    int? outputByteLimit,
  });

  /// Получает текущий вывод терминала
  Future<Map<String, dynamic>> getOutput(String terminalId);

  /// Ожидает завершения терминального процесса
  Future<Map<String, dynamic>> waitForExit(String terminalId);

  /// Освобождает ресурсы терминала
  Future<void> release(String terminalId);

  /// Принудительно завершает терминальный процесс
  Future<bool> kill(String terminalId);
}
