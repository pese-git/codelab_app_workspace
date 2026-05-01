import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../domain/entities/server.dart';

part 'server_event.freezed.dart';

@freezed
sealed class ServerEvent with _$ServerEvent {
  const factory ServerEvent.load() = ServerLoadRequested;

  const factory ServerEvent.add({
    required String name,
    required String host,
    required int port,
    @Default(ServerType.websocket) ServerType type,
    String? path,
    Duration? connectTimeout,
  }) = ServerAddRequested;

  const factory ServerEvent.update({
    required String id,
    required String name,
    required String host,
    required int port,
    ServerType? type,
    String? path,
    Duration? connectTimeout,
  }) = ServerUpdateRequested;

  const factory ServerEvent.delete(String id) = ServerDeleteRequested;

  const factory ServerEvent.select(String id) = ServerSelectRequested;
}
