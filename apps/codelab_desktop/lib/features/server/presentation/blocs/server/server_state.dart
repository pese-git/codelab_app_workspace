import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../domain/entities/server.dart';

part 'server_state.freezed.dart';

@freezed
sealed class ServerState with _$ServerState {
  const factory ServerState.initial() = ServerInitial;

  const factory ServerState.loading() = ServerLoading;

  const factory ServerState.loaded({
    required List<Server> servers,
    String? selectedServerId,
  }) = ServerLoaded;

  const factory ServerState.error({
    required String message,
    ServerState? previousState,
  }) = ServerError;
}
