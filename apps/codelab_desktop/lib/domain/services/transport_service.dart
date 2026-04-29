typedef OnUpdateCallback = void Function(Map<String, dynamic> update);
typedef FsReadCallback = Future<String> Function(String path);
typedef FsWriteCallback = Future<void> Function(String path, String content);
typedef TerminalCreateCallback = Future<String> Function(String command);
typedef TerminalOutputCallback = Future<Map<String, dynamic>> Function(String terminalId);
typedef TerminalWaitCallback = Future<Map<String, dynamic>> Function(String terminalId);
typedef TerminalReleaseCallback = Future<void> Function(String terminalId);
typedef TerminalKillCallback = Future<bool> Function(String terminalId);

abstract interface class TransportService {
  Future<void> connect();
  Future<void> disconnect();
  bool isConnected();
  bool isInitialized();
  Future<void> send(Map<String, dynamic> message);
  Future<Map<String, dynamic>> receive({required String requestId});
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
  void setServerCapabilities(Map<String, dynamic> capabilities);
  Map<String, dynamic> getServerCapabilities();
}
