import '../entities/server.dart';

abstract interface class ServerRepository {
  Future<List<Server>> getAll();
  Future<Server?> getById(String id);
  Future<Server> create(Server server);
  Future<Server> update(Server server);
  Future<void> delete(String id);
  Server? getSelected();
  Future<void> select(String id);
  Stream<Server?> watchSelected();
}
