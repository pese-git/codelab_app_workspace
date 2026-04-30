import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../infrastructure/services/permission_handler.dart';

part 'permission_state.freezed.dart';

@freezed
sealed class PermissionState with _$PermissionState {
  const factory PermissionState.idle() = PermissionIdle;

  const factory PermissionState.awaitingDecision({
    required PendingPermissionRequest request,
  }) = PermissionAwaitingDecision;

  const factory PermissionState.resolved({
    required String requestId,
    required String outcome,
  }) = PermissionResolved;
}
