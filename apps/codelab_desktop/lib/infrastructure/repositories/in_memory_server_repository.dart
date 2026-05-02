import 'dart:async';

import '../../domain/entities/server.dart';
import '../../domain/repositories/server_repository.dart';

class InMemoryServerRepository implements ServerRepository {
  final Map<String, Server> _servers = {};
  String? _selectedId;
  final StreamController<Server?> _selectedController =
      StreamController.broadcast();

  InMemoryServerRepository() {
    _seedDefaultServers();
  }

  @override
  Future<List<Server>> getAll() async => _servers.values.toList();

  @override
  Future<Server?> getById(String id) async => _servers[id];

  @override
  Future<Server> create(Server server) async {
    _servers[server.id] = server;
    return server;
  }

  @override
  Future<Server> update(Server server) async {
    if (!_servers.containsKey(server.id)) {
      throw StateError('Server with id ${server.id} not found');
    }
    _servers[server.id] = server;
    if (_selectedId == server.id) {
      _selectedController.add(server);
    }
    return server;
  }

  @override
  Future<void> delete(String id) async {
    _servers.remove(id);
    if (_selectedId == id) {
      _selectedId = _servers.keys.isNotEmpty ? _servers.keys.first : null;
    }
    _selectedController.add(getSelected());
  }

  @override
  Server? getSelected() => _selectedId != null ? _servers[_selectedId] : null;

  @override
  Future<void> select(String id) async {
    if (!_servers.containsKey(id)) {
      throw StateError('Server with id $id not found');
    }
    _selectedId = id;
    _selectedController.add(getSelected());
  }

  @override
  Stream<Server?> watchSelected() {
    _selectedController.add(getSelected());
    return _selectedController.stream;
  }

  void _seedDefaultServers() {
    final local = Server.create(
      name: 'Local Agent',
      host: 'localhost',
      port: 8765,
    );
    _servers[local.id] = local;
    _selectedId = local.id;
  }

  Future<void> dispose() async {
    await _selectedController.close();
  }
}
