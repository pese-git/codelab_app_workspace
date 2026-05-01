import 'dart:async';

import 'package:structured_log/structured_log.dart';

import '../../core/error/failures.dart';
import '../../domain/entities/connection_state.dart';
import '../../domain/services/transport_service.dart';
import '../dto/acp_message.dart';
import '../transport/websocket_transport.dart';
import '../transport/message_router.dart';
import '../transport/routing_queues.dart';
import '../transport/background_receive_loop.dart';
import 'permission_handler.dart';

/// Реализация TransportService для ACP протокола
///
/// Оркестрирует WebSocket транспорт, маршрутизацию сообщений
/// и обработку всех server→client RPC вызовов.
/// Аналог Python: infrastructure/services/acp_transport_service.py
/// Регистрируется в AppModule как singleton TransportService.
class AcpTransportService implements TransportService {
  AcpTransportService({
    required AcpServerConfig config,
    required PermissionHandler permissionHandler,
  })  : _config = config,
        _permissionHandler = permissionHandler;

  final _log = getLogger('AcpTransportService');
  final AcpServerConfig _config;
  final PermissionHandler _permissionHandler;

  WebSocketTransport? _wsTransport;
  RoutingQueues? _queues;
  MessageRouter? _router;
  BackgroundReceiveLoop? _bgLoop;
  Map<String, dynamic>? _serverCapabilities;

  @override
  Future<void> connect() async {
    if (isConnected()) {
      _log.debug('Already connected');
      return;
    }

    try {
      _queues = RoutingQueues();
      _wsTransport = WebSocketTransport(config: _config);
      _router = MessageRouter(_queues!);
      _bgLoop = BackgroundReceiveLoop(
        transport: _wsTransport!,
        router: _router!,
      );

      await _wsTransport!.connect();
      _bgLoop!.start();

      _log.info('AcpTransportService connected to ${_config.uri}');
    } catch (e) {
      await _cleanup();
      throw TransportFailure(
        message: 'Failed to connect to ${_config.uri}: $e',
      );
    }
  }

  @override
  Future<void> disconnect() async {
    if (!isConnected()) return;

    try {
      await _bgLoop?.stop();
      await _queues?.dispose();
      await _wsTransport?.disconnect();
      _log.info('AcpTransportService disconnected');
    } catch (e) {
      _log.warning('Error during disconnect: $e');
    } finally {
      await _cleanup();
    }
  }

  @override
  bool isConnected() => _wsTransport?.isConnected ?? false;

  @override
  bool isInitialized() => _serverCapabilities != null;

  ConnectionState get connectionState =>
      _wsTransport?.connectionState ?? ConnectionState.disconnected;

  Stream<ConnectionState> get connectionStateStream =>
      _wsTransport?.connectionStateStream ??
      const Stream<ConnectionState>.empty();

  Future<void> reconnect() async {
    if (_wsTransport == null) {
      await connect();
      return;
    }

    try {
      await _bgLoop?.stop();
      await _wsTransport!.reconnect();
      _bgLoop = BackgroundReceiveLoop(
        transport: _wsTransport!,
        router: _router!,
      );
      _bgLoop!.start();
      _log.info('AcpTransportService reconnected');
    } catch (e) {
      await _cleanup();
      throw TransportFailure(
        message: 'Failed to reconnect: $e',
      );
    }
  }

  @override
  Future<void> send(Map<String, dynamic> message) async {
    _assertConnected();
    try {
      await _wsTransport!.sendMessage(message);
    } catch (e) {
      throw TransportFailure(message: 'Failed to send message: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> receive({required String requestId}) async {
    _assertConnected();
    final responseStream = _queues!.getOrCreateResponseStream(requestId);
    try {
      return await responseStream.first.timeout(
        const Duration(seconds: 300),
        onTimeout: () => throw const TimeoutFailure(),
      );
    } finally {
      _queues?.cleanupResponseQueue(requestId);
    }
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
    _assertConnected();

    final request = AcpMessage.requestWithAutoId(method, params: params);
    final requestId = switch (request) {
      AcpRequest(:final id) => id.toString(),
      _ => throw StateError('Expected request message'),
    };

    _log.debug('requestWithCallbacks: $method, id=$requestId');

    final responseStream = _queues!.getOrCreateResponseStream(requestId);

    try {
      await send(request.toJson());

      final completer = Completer<Map<String, dynamic>>();

      final notificationSub = _queues!.notifications.listen(
        (notification) async {
          if (completer.isCompleted) return;
          await _handleNotification(
            notification: notification,
            method: method,
            onUpdate: onUpdate,
            onFsRead: onFsRead,
            onFsWrite: onFsWrite,
            onTerminalCreate: onTerminalCreate,
            onTerminalOutput: onTerminalOutput,
            onTerminalWait: onTerminalWait,
            onTerminalRelease: onTerminalRelease,
            onTerminalKill: onTerminalKill,
          );
        },
      );

      final permissionSub = _queues!.permissionRequests.listen(
        (permMsg) async {
          if (completer.isCompleted) return;
          await _permissionHandler.handleRaw(permMsg, _wsTransport!);
        },
      );

      final responseTimeout = responseStream.first.timeout(
        const Duration(seconds: 300),
        onTimeout: () => throw const TimeoutFailure(),
      );

      unawaited(
        responseTimeout.then((response) {
          if (!completer.isCompleted) {
            completer.complete(response);
          }
        }).catchError((Object e) {
          if (!completer.isCompleted) {
            completer.completeError(e);
          }
        }),
      );

      try {
        return await completer.future;
      } finally {
        await notificationSub.cancel();
        await permissionSub.cancel();
      }
    } finally {
      _queues?.cleanupResponseQueue(requestId);
    }
  }

  @override
  void setServerCapabilities(Map<String, dynamic> capabilities) {
    _serverCapabilities = capabilities;
    _log.debug('Server capabilities saved');
  }

  @override
  Map<String, dynamic> getServerCapabilities() {
    if (_serverCapabilities == null) {
      throw const SessionFailure(
        message: 'Server not initialized. Call InitializeUseCase first.',
      );
    }
    return _serverCapabilities!;
  }

  Future<void> _handleNotification({
    required Map<String, dynamic> notification,
    required String method,
    OnUpdateCallback? onUpdate,
    FsReadCallback? onFsRead,
    FsWriteCallback? onFsWrite,
    TerminalCreateCallback? onTerminalCreate,
    TerminalOutputCallback? onTerminalOutput,
    TerminalWaitCallback? onTerminalWait,
    TerminalReleaseCallback? onTerminalRelease,
    TerminalKillCallback? onTerminalKill,
  }) async {
    final rpcMethod = notification['method'] as String?;
    final rpcId = notification['id'];

    if (rpcMethod == 'session/update') {
      onUpdate?.call(notification);
      return;
    }

    if (rpcMethod == null || rpcId == null) return;

    final params = notification['params'] as Map<String, dynamic>? ?? {};

    try {
      switch (rpcMethod) {
        case 'fs/read_text_file':
          await _handleFsRead(rpcId, params, onFsRead);

        case 'fs/write_text_file':
          await _handleFsWrite(rpcId, params, onFsWrite);

        case 'terminal/create':
          await _handleTerminalCreate(rpcId, params, onTerminalCreate);

        case 'terminal/output':
          await _handleTerminalOutput(rpcId, params, onTerminalOutput);

        case 'terminal/wait_for_exit':
          await _handleTerminalWait(rpcId, params, onTerminalWait);

        case 'terminal/release':
          await _handleTerminalRelease(rpcId, params, onTerminalRelease);

        case 'terminal/kill':
          await _handleTerminalKill(rpcId, params, onTerminalKill);

        default:
          _log.warning('Unknown server→client RPC: $rpcMethod');
          await send(
            AcpMessage.response(id: rpcId, result: {}).toJson(),
          );
      }
    } catch (e) {
      _log.error('Error handling $rpcMethod: $e');
      await send(
        AcpMessage.errorResponse(
          id: rpcId,
          code: -32603,
          message: 'Internal error: $e',
        ).toJson(),
      );
    }
  }

  Future<void> _handleFsRead(
    Object rpcId,
    Map<String, dynamic> params,
    FsReadCallback? callback,
  ) async {
    final path = params['path'] as String?;
    if (path == null || callback == null) {
      await send(
        AcpMessage.response(id: rpcId, result: {'content': ''}).toJson(),
      );
      return;
    }
    final content = await callback(path);
    await send(
      AcpMessage.response(id: rpcId, result: {'content': content}).toJson(),
    );
  }

  Future<void> _handleFsWrite(
    Object rpcId,
    Map<String, dynamic> params,
    FsWriteCallback? callback,
  ) async {
    final path = params['path'] as String?;
    final content = params['content'] as String?;
    if (path != null && content != null && callback != null) {
      await callback(path, content);
    }
    await send(
      AcpMessage.response(id: rpcId, result: {}).toJson(),
    );
  }

  Future<void> _handleTerminalCreate(
    Object rpcId,
    Map<String, dynamic> params,
    TerminalCreateCallback? callback,
  ) async {
    final command = params['command'] as String?;
    if (command == null || callback == null) {
      await send(
        AcpMessage.errorResponse(
          id: rpcId,
          code: -32000,
          message: 'terminal/create not configured',
        ).toJson(),
      );
      return;
    }
    final terminalId = await callback(command);
    await send(
      AcpMessage.response(
        id: rpcId,
        result: {'terminalId': terminalId},
      ).toJson(),
    );
  }

  Future<void> _handleTerminalOutput(
    Object rpcId,
    Map<String, dynamic> params,
    TerminalOutputCallback? callback,
  ) async {
    final terminalId = params['terminalId'] as String?;
    if (terminalId == null || callback == null) {
      await send(
        AcpMessage.errorResponse(
          id: rpcId,
          code: -32000,
          message: 'terminal/output not configured',
        ).toJson(),
      );
      return;
    }
    final output = await callback(terminalId);
    await send(
      AcpMessage.response(id: rpcId, result: output).toJson(),
    );
  }

  Future<void> _handleTerminalWait(
    Object rpcId,
    Map<String, dynamic> params,
    TerminalWaitCallback? callback,
  ) async {
    final terminalId = params['terminalId'] as String?;
    if (terminalId == null || callback == null) {
      await send(
        AcpMessage.response(id: rpcId, result: {}).toJson(),
      );
      return;
    }
    final result = await callback(terminalId);
    await send(
      AcpMessage.response(id: rpcId, result: result).toJson(),
    );
  }

  Future<void> _handleTerminalRelease(
    Object rpcId,
    Map<String, dynamic> params,
    TerminalReleaseCallback? callback,
  ) async {
    final terminalId = params['terminalId'] as String?;
    if (terminalId != null && callback != null) {
      await callback(terminalId);
    }
    await send(
      AcpMessage.response(id: rpcId, result: {}).toJson(),
    );
  }

  Future<void> _handleTerminalKill(
    Object rpcId,
    Map<String, dynamic> params,
    TerminalKillCallback? callback,
  ) async {
    final terminalId = params['terminalId'] as String?;
    final killed = (terminalId != null && callback != null)
        ? await callback(terminalId)
        : false;
    await send(
      AcpMessage.response(
        id: rpcId,
        result: {'killed': killed},
      ).toJson(),
    );
  }

  void _assertConnected() {
    if (!isConnected()) {
      throw const TransportFailure(message: 'Not connected to server');
    }
  }

  Future<void> _cleanup() async {
    _wsTransport = null;
    _queues = null;
    _router = null;
    _bgLoop = null;
  }

  Future<void> dispose() async {
    await disconnect();
  }
}
