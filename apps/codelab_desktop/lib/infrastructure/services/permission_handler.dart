import 'dart:async';

import 'package:structured_log/structured_log.dart';

import '../../domain/entities/acp_message.dart';
import '../../domain/entities/permission.dart';
import '../transport/websocket_transport.dart';

class PendingPermissionRequest {
  PendingPermissionRequest({
    required this.requestId,
    required this.sessionId,
    required this.toolCall,
    required this.options,
    Duration timeout = const Duration(seconds: 300),
  })  : createdAt = DateTime.now().toUtc(),
        _completer = Completer<PermissionOutcome>() {
    _timeoutTimer = Timer(timeout, () {
      if (!_completer.isCompleted) {
        _completer.complete(const CancelledPermissionOutcome());
      }
    });
  }

  final Object requestId;
  final String sessionId;
  final PermissionToolCall toolCall;
  final List<PermissionOption> options;
  final DateTime createdAt;
  final Completer<PermissionOutcome> _completer;
  Timer? _timeoutTimer;

  Future<PermissionOutcome> get outcome => _completer.future;

  void resolve(PermissionOutcome outcome) {
    _timeoutTimer?.cancel();
    if (!_completer.isCompleted) {
      _completer.complete(outcome);
    }
  }

  void cancel() {
    _timeoutTimer?.cancel();
    if (!_completer.isCompleted) {
      _completer.complete(const CancelledPermissionOutcome());
    }
  }
}

typedef PermissionRequestCallback = void Function(
  PendingPermissionRequest request,
);

class PermissionHandler {
  PermissionHandler();

  final _log = getLogger('PermissionHandler');
  final Map<String, PendingPermissionRequest> _pending = {};

  PermissionRequestCallback? _uiCallback;

  void setUiCallback(PermissionRequestCallback callback) {
    _uiCallback = callback;
  }

  Future<void> handleRaw(
    Map<String, dynamic> message,
    WebSocketTransport transport,
  ) async {
    final requestId = message['id'];
    if (requestId == null) return;

    try {
      final params = RequestPermissionPayload.fromJson(
        message['params'] as Map<String, dynamic>,
      );

      _log.info(
        'PermissionHandler: request $requestId for '
        '${params.toolCall.toolCallId}',
      );

      final pending = PendingPermissionRequest(
        requestId: requestId,
        sessionId: params.sessionId,
        toolCall: params.toolCall,
        options: params.options,
      );

      _pending[requestId.toString()] = pending;

      if (_uiCallback != null) {
        _uiCallback!(pending);
      } else {
        _log.warning('No UI callback, auto-cancelling permission $requestId');
        pending.cancel();
      }

      final outcome = await pending.outcome;

      _log.info(
        'Permission $requestId outcome: ${outcome.runtimeType}',
      );

      final responsePayload = switch (outcome) {
        SelectedPermissionOutcome(:final optionId) => {
            'outcome': 'selected',
            'optionId': optionId,
          },
        CancelledPermissionOutcome() => {'outcome': 'cancelled'},
      };

      final response = AcpMessage.response(
        id: requestId,
        result: responsePayload,
      );
      await transport.sendMessage(response.toJson());

      _log.info('Permission response sent for $requestId');
    } catch (e) {
      _log.error('Error handling permission request: $e');
      final errorResponse = AcpMessage.errorResponse(
        id: requestId,
        code: -32603,
        message: 'Internal error: $e',
      );
      await transport.sendMessage(errorResponse.toJson());
    } finally {
      _pending.remove(requestId.toString());
    }
  }

  void resolve(String requestId, String optionId) {
    final pending = _pending[requestId];
    if (pending == null) {
      _log.warning('Permission request not found: $requestId');
      return;
    }
    pending.resolve(SelectedPermissionOutcome(optionId: optionId));
  }

  void cancel(String requestId) {
    final pending = _pending[requestId];
    pending?.cancel();
    _pending.remove(requestId);
  }

  List<PendingPermissionRequest> get pendingRequests =>
      List.unmodifiable(_pending.values);
}
