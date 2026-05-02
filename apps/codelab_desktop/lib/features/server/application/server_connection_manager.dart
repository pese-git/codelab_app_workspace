import 'dart:async';

import 'package:structured_log/structured_log.dart';

import '../../../domain/entities/connection_state.dart';
import '../../../domain/entities/server.dart';
import '../../../domain/repositories/server_repository.dart';
import '../../../domain/services/transport_service.dart';
import '../../../features/session/presentation/blocs/session/session_bloc.dart';
import '../../../features/session/presentation/blocs/session/session_event.dart';
import 'server_config_mapper.dart';

/// Координатор подключения к ACP серверу
///
/// Связывает подсистему управления серверами (ServerRepository)
/// с транспортным слоем (TransportService) и сессиями (SessionBloc).
///
/// Логика работы:
/// 1. При старте — берёт выбранный сервер, подключается, инициализирует сессию
/// 2. При смене сервера — переподключается к новому
/// 3. Синхронизирует ServerStatus с ConnectionState транспорта
class ServerConnectionManager {
  ServerConnectionManager({
    required ServerRepository serverRepository,
    required TransportService transport,
    required SessionBloc sessionBloc,
  })  : _serverRepository = serverRepository,
        _transport = transport,
        _sessionBloc = sessionBloc;

  final _log = getLogger('ServerConnectionManager');
  final ServerRepository _serverRepository;
  final TransportService _transport;
  final SessionBloc _sessionBloc;

  StreamSubscription<Server?>? _serverSubscription;
  StreamSubscription<ConnectionState>? _connectionSubscription;
  bool _isInitialized = false;

  bool get isConnected => _transport.isConnected();
  Server? get selectedServer => _serverRepository.getSelected();

  /// Инициализирует менеджер подключений
  ///
  /// Подписывается на изменения выбранного сервера и
  /// автоматически подключается к нему.
  Future<void> initialize() async {
    if (_isInitialized) {
      _log.debug('Already initialized');
      return;
    }

    _isInitialized = true;

    _connectionSubscription = _transport.connectionStateStream.listen(
      _onConnectionStateChanged,
    );

    _serverSubscription = _serverRepository.watchSelected().listen(
      _onServerChanged,
    );

    await _connectToSelected();
  }

  /// Принудительное переподключение к текущему серверу
  Future<void> reconnect() async {
    await _connectToSelected();
  }

  /// Отключение и очистка ресурсов
  Future<void> dispose() async {
    _isInitialized = false;
    await _serverSubscription?.cancel();
    await _connectionSubscription?.cancel();
    await _transport.disconnect();
  }

  Future<void> _onServerChanged(Server? server) async {
    if (!_isInitialized) return;
    if (server == null) {
      _log.warning('No server selected');
      return;
    }

    _log.info('Server changed: ${server.name} (${server.displayUrl})');
    await _connectToSelected();
  }

  void _onConnectionStateChanged(ConnectionState state) {
    _syncServerStatus(state);
  }

  Future<void> _connectToSelected() async {
    final server = _serverRepository.getSelected();
    if (server == null) {
      _log.warning('No server selected, skipping connection');
      return;
    }

    try {
      if (_transport.isConnected()) {
        _log.debug('Disconnecting from current server');
        await _transport.disconnect();
      }

      final config = ServerConfigMapper.toAcpServerConfig(server);
      _transport.updateConfig(config);
      _log.info('Connecting to ${server.name} at ${config.uri}');

      await _transport.connect();

      _sessionBloc.add(
        SessionEvent.initialize(
          serverHost: server.host,
          serverPort: server.port,
        ),
      );
    } catch (e) {
      _log.error('Failed to connect to ${server.name}: $e');
    }
  }

  void _syncServerStatus(ConnectionState state) {
    final server = _serverRepository.getSelected();
    if (server == null) return;

    final status = switch (state) {
      ConnectionState.connected => ServerStatus.connected,
      ConnectionState.connecting => ServerStatus.connecting,
      ConnectionState.reconnecting => ServerStatus.connecting,
      ConnectionState.disconnected => ServerStatus.disconnected,
    };

    if (server.status == status) return;

    _serverRepository.update(server.copyWith(status: status));
    _log.debug('Server ${server.name} status: $status');
  }
}
