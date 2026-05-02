import 'dart:async';
import 'dart:convert';

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

  static const _payloadPreviewLimit = 200;

  final _log = getLogger('AcpTransportService');
  AcpServerConfig _config;
  final PermissionHandler _permissionHandler;

  WebSocketTransport? _wsTransport;
  RoutingQueues? _queues;
  MessageRouter? _router;
  BackgroundReceiveLoop? _bgLoop;
  Map<String, dynamic>? _serverCapabilities;

  /// Обновляет конфигурацию сервера (для переключения между серверами)
  void updateConfig(AcpServerConfig newConfig) {
    _config = newConfig;
    _log.debug('Server config updated to ${newConfig.uri}');
  }

  @override
  Future<void> connect() async {
    if (isConnected()) {
      _log.debug('acp_already_connected', context: {
        'uri': _config.uri.toString(),
      });
      return;
    }

    _log.info('acp_connect_start', context: {
      'uri': _config.uri.toString(),
    });

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

      _log.info('acp_connected', context: {
        'uri': _config.uri.toString(),
      });
    } catch (e, st) {
      _log.error('acp_connect_failed', context: {
        'uri': _config.uri.toString(),
        'error': e.toString(),
        'stack_trace': st.toString(),
      });
      await _cleanup();
      throw TransportFailure(
        message: 'Failed to connect to ${_config.uri}: $e',
      );
    }
  }

  @override
  Future<void> disconnect() async {
    if (!isConnected()) {
      _log.debug('acp_disconnect_not_connected');
      return;
    }

    _log.info('acp_disconnect_start', context: {
      'uri': _config.uri.toString(),
    });

    try {
      await _bgLoop?.stop();
      await _queues?.dispose();
      await _wsTransport?.disconnect();
      _log.info('acp_disconnected', context: {
        'uri': _config.uri.toString(),
      });
    } catch (e, st) {
      _log.warning('acp_disconnect_error', context: {
        'error': e.toString(),
        'stack_trace': st.toString(),
      });
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
    _log.info('acp_reconnect_start', context: {
      'uri': _config.uri.toString(),
    });

    if (_wsTransport == null) {
      await connect();
      return;
    }

    try {
      await _bgLoop?.stop();
      await _queues?.dispose();
      await _wsTransport?.disconnect();

      _queues = RoutingQueues();
      _wsTransport = WebSocketTransport(config: _config);
      _router = MessageRouter(_queues!);
      _bgLoop = BackgroundReceiveLoop(
        transport: _wsTransport!,
        router: _router!,
      );

      await _wsTransport!.connect();
      _bgLoop!.start();
      _log.info('acp_reconnected', context: {
        'uri': _config.uri.toString(),
      });
    } catch (e, st) {
      _log.error('acp_reconnect_failed', context: {
        'uri': _config.uri.toString(),
        'error': e.toString(),
        'stack_trace': st.toString(),
      });
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
      final json = jsonEncode(message);
      _log.debug('acp_send', context: {
        'direction': 'send',
        'method': message['method'],
        'id': message['id'],
        'has_params': message.containsKey('params'),
        'has_result': message.containsKey('result'),
        'has_error': message.containsKey('error'),
        'payload_size_bytes': json.length,
        'payload_preview': _truncatePayload(json),
      });
      await _wsTransport!.sendMessage(message);
    } catch (e, st) {
      _log.error('acp_send_failed', context: {
        'direction': 'send',
        'method': message['method'],
        'id': message['id'],
        'error': e.toString(),
        'stack_trace': st.toString(),
      });
      throw TransportFailure(message: 'Failed to send message: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> receive({required String requestId}) async {
    _assertConnected();
    _log.debug('acp_receive_waiting', context: {
      'direction': 'recv',
      'request_id': requestId,
    });
    final responseStream = _queues!.getOrCreateResponseStream(requestId);
    try {
      final response = await responseStream.first.timeout(
        const Duration(seconds: 300),
        onTimeout: () {
          _log.warning('acp_receive_timeout', context: {
            'direction': 'recv',
            'request_id': requestId,
          });
          throw const TimeoutFailure();
        },
      );
      final responseJson = jsonEncode(response);
      _log.debug('acp_receive_complete', context: {
        'direction': 'recv',
        'request_id': requestId,
        'has_result': response.containsKey('result'),
        'has_error': response.containsKey('error'),
        'payload_size_bytes': responseJson.length,
        'payload_preview': _truncatePayload(responseJson),
      });
      return response;
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

    _log.debug('acp_request_with_callbacks_start', context: {
      'direction': 'send',
      'method': method,
      'request_id': requestId,
      'has_params': params != null,
      'has_on_update': onUpdate != null,
      'has_on_fs_read': onFsRead != null,
      'has_on_fs_write': onFsWrite != null,
      'has_on_terminal_create': onTerminalCreate != null,
      'has_on_terminal_output': onTerminalOutput != null,
      'has_on_terminal_wait': onTerminalWait != null,
      'has_on_terminal_release': onTerminalRelease != null,
      'has_on_terminal_kill': onTerminalKill != null,
    });

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
        onTimeout: () {
          _log.warning('acp_request_with_callbacks_timeout', context: {
            'direction': 'recv',
            'method': method,
            'request_id': requestId,
          });
          throw const TimeoutFailure();
        },
      );

      unawaited(
        responseTimeout.then((response) {
          if (!completer.isCompleted) {
            final responseJson = jsonEncode(response);
            _log.debug('acp_request_with_callbacks_response', context: {
              'direction': 'recv',
              'method': method,
              'request_id': requestId,
              'has_result': response.containsKey('result'),
              'has_error': response.containsKey('error'),
              'payload_size_bytes': responseJson.length,
              'payload_preview': _truncatePayload(responseJson),
            });
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
      _log.debug('acp_notification_session_update', context: {
        'direction': 'recv',
        'rpc_method': rpcMethod,
        'parent_method': method,
      });
      onUpdate?.call(notification);
      return;
    }

    if (rpcMethod == null || rpcId == null) return;

    final params = notification['params'] as Map<String, dynamic>? ?? {};

    _log.debug('acp_notification_rpc', context: {
      'direction': 'recv',
      'rpc_method': rpcMethod,
      'rpc_id': rpcId,
      'parent_method': method,
    });

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
          _log.warning('acp_unknown_server_rpc', context: {
            'direction': 'recv',
            'rpc_method': rpcMethod,
            'rpc_id': rpcId,
          });
          await send(
            AcpMessage.response(id: rpcId, result: {}).toJson(),
          );
      }
    } catch (e, st) {
      _log.error('acp_notification_handler_error', context: {
        'direction': 'recv',
        'rpc_method': rpcMethod,
        'rpc_id': rpcId,
        'error': e.toString(),
        'stack_trace': st.toString(),
      });
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
      _log.debug('acp_fs_read_send_response', context: {
        'direction': 'send',
        'rpc_method': 'fs/read_text_file',
        'rpc_id': rpcId,
        'path': path,
        'has_callback': callback != null,
      });
      await send(
        AcpMessage.response(id: rpcId, result: {'content': ''}).toJson(),
      );
      return;
    }
    final content = await callback(path);
    _log.debug('acp_fs_read_send_response', context: {
      'direction': 'send',
      'rpc_method': 'fs/read_text_file',
      'rpc_id': rpcId,
      'path': path,
      'content_length': content.length,
    });
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
    _log.debug('acp_fs_write_send_response', context: {
      'direction': 'send',
      'rpc_method': 'fs/write_text_file',
      'rpc_id': rpcId,
      'path': path,
      'content_length': content?.length,
    });
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
      _log.warning('acp_terminal_create_error', context: {
        'direction': 'send',
        'rpc_method': 'terminal/create',
        'rpc_id': rpcId,
        'has_command': command != null,
        'has_callback': callback != null,
      });
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
    _log.debug('acp_terminal_create_send_response', context: {
      'direction': 'send',
      'rpc_method': 'terminal/create',
      'rpc_id': rpcId,
      'command': command,
      'terminal_id': terminalId,
    });
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
      _log.warning('acp_terminal_output_error', context: {
        'direction': 'send',
        'rpc_method': 'terminal/output',
        'rpc_id': rpcId,
        'has_terminal_id': terminalId != null,
        'has_callback': callback != null,
      });
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
    _log.debug('acp_terminal_output_send_response', context: {
      'direction': 'send',
      'rpc_method': 'terminal/output',
      'rpc_id': rpcId,
      'terminal_id': terminalId,
      'output_length': output.length,
    });
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
      _log.debug('acp_terminal_wait_send_response', context: {
        'direction': 'send',
        'rpc_method': 'terminal/wait_for_exit',
        'rpc_id': rpcId,
        'has_terminal_id': terminalId != null,
        'has_callback': callback != null,
      });
      await send(
        AcpMessage.response(id: rpcId, result: {}).toJson(),
      );
      return;
    }
    final result = await callback(terminalId);
    _log.debug('acp_terminal_wait_send_response', context: {
      'direction': 'send',
      'rpc_method': 'terminal/wait_for_exit',
      'rpc_id': rpcId,
      'terminal_id': terminalId,
    });
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
    _log.debug('acp_terminal_release_send_response', context: {
      'direction': 'send',
      'rpc_method': 'terminal/release',
      'rpc_id': rpcId,
      'terminal_id': terminalId,
    });
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
    _log.debug('acp_terminal_kill_send_response', context: {
      'direction': 'send',
      'rpc_method': 'terminal/kill',
      'rpc_id': rpcId,
      'terminal_id': terminalId,
      'killed': killed,
    });
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

  static String _truncatePayload(String payload) {
    if (payload.length <= _payloadPreviewLimit) return payload;
    return '${payload.substring(0, _payloadPreviewLimit)}...';
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
