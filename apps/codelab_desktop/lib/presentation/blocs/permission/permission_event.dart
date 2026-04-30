import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../infrastructure/services/permission_handler.dart';

part 'permission_event.freezed.dart';

@freezed
sealed class PermissionEvent with _$PermissionEvent {
  const factory PermissionEvent.requestReceived({
    required PendingPermissionRequest request,
  }) = PermissionRequestReceived;

  const factory PermissionEvent.optionSelected({
    required String requestId,
    required String optionId,
  }) = PermissionOptionSelected;

  const factory PermissionEvent.cancelled({
    required String requestId,
  }) = PermissionCancelled;
}
