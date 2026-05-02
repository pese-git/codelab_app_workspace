import '../../infrastructure/transport/websocket_transport.dart'
    show AcpServerConfig;
import '../entities/connection_state.dart';

/// Callback типы для обработки server→client RPC вызовов
typedef OnUpdateCallback = void Function(Map<String, dynamic> update);
typedef FsReadCallback = Future<String> Function(String path);
typedef FsWriteCallback = Future<void> Function(String path, String content);
typedef TerminalCreateCallback = Future<String> Function(String command);
typedef TerminalOutputCallback = Future<Map<String, dynamic>> Function(String terminalId);
typedef TerminalWaitCallback = Future<Map<String, dynamic>> Function(String terminalId);
typedef TerminalReleaseCallback = Future<void> Function(String terminalId);
typedef TerminalKillCallback = Future<bool> Function(String terminalId);

/// Интерфейс транспортного сервиса для ACP коммуникации
///
/// Абстрагирует WebSocket соединение и предоставляет методы
/// для отправки/получения ACP сообщений.
///
/// Аналог Python: `domain/services.py::TransportService`
abstract interface class TransportService {
  /// Устанавливает соединение с ACP сервером
  Future<void> connect();

  /// Разрывает соединение
  Future<void> disconnect();

  /// Проверяет активность соединения
  bool isConnected();

  /// Проверяет, выполнена ли инициализация (получены server capabilities)
  bool isInitialized();

  /// Отправляет JSON-RPC сообщение
  Future<void> send(Map<String, dynamic> message);

  /// Получает ответ на конкретный request по ID
  /// Timeout: 300 секунд
  Future<Map<String, dynamic>> receive({required String requestId});

  /// Выполняет request с обработкой промежуточных callbacks
  ///
  /// Основной метод для операций session/prompt, session/load и т.д.
  /// Обрабатывает:
  /// - session/update notifications → [onUpdate]
  /// - fs/read_text_file → [onFsRead]
  /// - fs/write_text_file → [onFsWrite]
  /// - terminal/* → соответствующие callbacks
  /// - session/request_permission → обрабатывается через PermissionHandler
  Future<Map<String, dynamic>> requestWithCallbacks({
    required String method,
    Map<String, dynamic>? params,
    OnUpdateCallback? onUpdate,
    FsReadCallback? onFsRead,
    FsWriteCallback? onFsWrite,
    TerminalCreateCallback? onTerminalCreate,
    TerminalOutputCallback? onTerminalOutput,
    TerminalWaitCallback? onTerminalWait,
    TerminalReleaseCallback? onTerminalRelease,
    TerminalKillCallback? onTerminalKill,
  });

  /// Сохраняет capabilities сервера после initialize
  void setServerCapabilities(Map<String, dynamic> capabilities);

  /// Возвращает capabilities сервера
  Map<String, dynamic> getServerCapabilities();

  /// Текущее состояние соединения
  ConnectionState get connectionState;

  /// Поток изменений состояния соединения
  Stream<ConnectionState> get connectionStateStream;

  /// Обновляет конфигурацию сервера (для переключения между серверами)
  void updateConfig(AcpServerConfig config);
}
