import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../domain/entities/connection_state.dart';
import '../../domain/services/transport_service.dart';

/// Менеджер состояния соединения для UI
///
/// Подписывается на TransportService и предоставляет
/// реактивное состояние соединения для виджетов.
class ConnectionStateManager extends ChangeNotifier {
  ConnectionStateManager({
    required TransportService transport,
  }) : _transport = transport;

  final TransportService _transport;
  ConnectionState _state = ConnectionState.disconnected;
  StreamSubscription<ConnectionState>? _subscription;

  ConnectionState get state => _state;
  bool get isConnected => _state == ConnectionState.connected;
  bool get isReconnecting => _state == ConnectionState.reconnecting;
  bool get isDisconnected => _state == ConnectionState.disconnected;

  String get statusLabel {
    return switch (_state) {
      ConnectionState.connected => 'Подключено',
      ConnectionState.connecting => 'Подключение...',
      ConnectionState.reconnecting => 'Переподключение...',
      ConnectionState.disconnected => 'Отключено',
    };
  }

  void initialize() {
    _state = _transport.connectionState;
    _subscription = _transport.connectionStateStream.listen(_onStateChanged);
  }

  void _onStateChanged(ConnectionState newState) {
    _state = newState;
    notifyListeners();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
