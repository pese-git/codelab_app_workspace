import 'package:freezed_annotation/freezed_annotation.dart';

part 'server.freezed.dart';

enum ServerType { websocket, sse }

enum ServerStatus { disconnected, connecting, connected, error }

@freezed
abstract class Server with _$Server {
  const factory Server({
    required String id,
    required String name,
    required String host,
    required int port,
    @Default(ServerType.websocket) ServerType type,
    @Default(ServerStatus.disconnected) ServerStatus status,
    String? path,
    @Default(Duration(seconds: 30)) Duration connectTimeout,
    DateTime? createdAt,
  }) = _Server;

  const Server._();

  factory Server.create({
    required String name,
    required String host,
    required int port,
    ServerType type = ServerType.websocket,
    String? path,
    Duration? connectTimeout,
  }) {
    return Server(
      id: _generateId(),
      name: name,
      host: host,
      port: port,
      type: type,
      path: path,
      connectTimeout: connectTimeout ?? const Duration(seconds: 30),
      createdAt: DateTime.now().toUtc(),
    );
  }

  String get displayUrl {
    final effectivePath = path ?? '/ws';
    return '$host:$port$effectivePath';
  }

  static String _generateId() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return 'srv_$timestamp';
  }
}
