import 'package:cherrypick/cherrypick.dart';
import 'package:structured_log/structured_log.dart';

import '../../domain/services/transport_service.dart';

class AcpTransportService implements TransportService, Disposable {
  final _log = getLogger('AcpTransportService');
  Map<String, dynamic> _serverCapabilities = {};
  bool _connected = false;
  bool _initialized = false;

  @override
  bool isConnected() => _connected;

  @override
  bool isInitialized() => _initialized;

  @override
  Future<void> connect() async {
    _log.info('Connecting to ACP server...');
    _connected = true;
  }

  @override
  Future<void> disconnect() async {
    _log.info('Disconnecting from ACP server');
    _connected = false;
    _initialized = false;
  }

  @override
  Future<void> send(Map<String, dynamic> message) async {
    _log.info('Sending message', context: {'method': message['method']});
  }

  @override
  Future<Map<String, dynamic>> receive({required String requestId}) async {
    _log.info('Receiving response', context: {'requestId': requestId});
    return {};
  }

  @override
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
  }) async {
    _log.info('Request with callbacks', context: {'method': method});
    return {'result': 'stub'};
  }

  @override
  void setServerCapabilities(Map<String, dynamic> capabilities) {
    _serverCapabilities = capabilities;
    _initialized = true;
  }

  @override
  Map<String, dynamic> getServerCapabilities() => _serverCapabilities;

  @override
  Future<void> dispose() async {
    await disconnect();
  }
}
