import 'package:bloc/bloc.dart';
import 'package:structured_log/structured_log.dart';

import '../../../../../domain/entities/server.dart';
import '../../../../../domain/repositories/server_repository.dart';
import 'server_event.dart';
import 'server_state.dart';

class ServerBloc extends Bloc<ServerEvent, ServerState> {
  ServerBloc({required ServerRepository serverRepository})
      : _serverRepository = serverRepository,
        super(const ServerState.initial()) {
    on<ServerLoadRequested>(_onLoad);
    on<ServerAddRequested>(_onAdd);
    on<ServerUpdateRequested>(_onUpdate);
    on<ServerDeleteRequested>(_onDelete);
    on<ServerSelectRequested>(_onSelect);
  }

  final _log = getLogger('ServerBloc');
  final ServerRepository _serverRepository;

  Future<void> _onLoad(
    ServerLoadRequested event,
    Emitter<ServerState> emit,
  ) async {
    emit(const ServerState.loading());
    try {
      final servers = await _serverRepository.getAll();
      final selected = _serverRepository.getSelected();
      emit(ServerState.loaded(
        servers: servers,
        selectedServerId: selected?.id,
      ));
    } catch (e) {
      _log.error('Failed to load servers: $e');
      emit(ServerState.error(message: 'Failed to load servers: $e'));
    }
  }

  Future<void> _onAdd(
    ServerAddRequested event,
    Emitter<ServerState> emit,
  ) async {
    final previous = state is ServerLoaded ? state as ServerLoaded : null;
    if (previous == null) return;

    try {
      final server = Server.create(
        name: event.name,
        host: event.host,
        port: event.port,
        type: event.type,
        path: event.path,
        connectTimeout: event.connectTimeout,
      );
      await _serverRepository.create(server);

      final servers = await _serverRepository.getAll();
      emit(ServerState.loaded(
        servers: servers,
        selectedServerId: previous.selectedServerId,
      ));
    } catch (e) {
      _log.error('Failed to add server: $e');
      emit(ServerState.error(
        message: 'Failed to add server: $e',
        previousState: previous,
      ));
    }
  }

  Future<void> _onUpdate(
    ServerUpdateRequested event,
    Emitter<ServerState> emit,
  ) async {
    final previous = state is ServerLoaded ? state as ServerLoaded : null;
    if (previous == null) return;

    try {
      final existing = await _serverRepository.getById(event.id);
      if (existing == null) {
        emit(const ServerState.error(message: 'Server not found'));
        return;
      }

      final updated = existing.copyWith(
        name: event.name,
        host: event.host,
        port: event.port,
        type: event.type ?? existing.type,
        path: event.path ?? existing.path,
        connectTimeout: event.connectTimeout ?? existing.connectTimeout,
      );
      await _serverRepository.update(updated);

      final servers = await _serverRepository.getAll();
      emit(ServerState.loaded(
        servers: servers,
        selectedServerId: previous.selectedServerId,
      ));
    } catch (e) {
      _log.error('Failed to update server: $e');
      emit(ServerState.error(
        message: 'Failed to update server: $e',
        previousState: previous,
      ));
    }
  }

  Future<void> _onDelete(
    ServerDeleteRequested event,
    Emitter<ServerState> emit,
  ) async {
    final previous = state is ServerLoaded ? state as ServerLoaded : null;
    if (previous == null) return;

    try {
      await _serverRepository.delete(event.id);

      final servers = await _serverRepository.getAll();
      final selected = _serverRepository.getSelected();
      emit(ServerState.loaded(
        servers: servers,
        selectedServerId: selected?.id,
      ));
    } catch (e) {
      _log.error('Failed to delete server: $e');
      emit(ServerState.error(
        message: 'Failed to delete server: $e',
        previousState: previous,
      ));
    }
  }

  Future<void> _onSelect(
    ServerSelectRequested event,
    Emitter<ServerState> emit,
  ) async {
    final previous = state is ServerLoaded ? state as ServerLoaded : null;
    if (previous == null) return;

    try {
      await _serverRepository.select(event.id);
      emit(ServerState.loaded(
        servers: previous.servers,
        selectedServerId: event.id,
      ));
    } catch (e) {
      _log.error('Failed to select server: $e');
      emit(ServerState.error(
        message: 'Failed to select server: $e',
        previousState: previous,
      ));
    }
  }
}
