import 'package:freezed_annotation/freezed_annotation.dart';

import 'tool_call.dart';

part 'permission.freezed.dart';
part 'permission.g.dart';

@freezed
abstract class PermissionOption with _$PermissionOption {
  const factory PermissionOption({
    required String optionId,
    required String name,
    required PermissionKind kind,
  }) = _PermissionOption;

  factory PermissionOption.fromJson(Map<String, dynamic> json) =>
      _$PermissionOptionFromJson(json);
}

enum PermissionKind {
  @JsonValue('allow_once') allowOnce,
  @JsonValue('allow_always') allowAlways,
  @JsonValue('reject_once') rejectOnce,
  @JsonValue('reject_always') rejectAlways,
}

@freezed
abstract class PermissionToolCall with _$PermissionToolCall {
  const factory PermissionToolCall({
    required String toolCallId,
    String? title,
    ToolKind? kind,
    ToolCallStatus? status,
  }) = _PermissionToolCall;

  factory PermissionToolCall.fromJson(Map<String, dynamic> json) =>
      _$PermissionToolCallFromJson(json);
}

@freezed
abstract class RequestPermissionPayload with _$RequestPermissionPayload {
  const factory RequestPermissionPayload({
    required String sessionId,
    required PermissionToolCall toolCall,
    required List<PermissionOption> options,
  }) = _RequestPermissionPayload;

  factory RequestPermissionPayload.fromJson(Map<String, dynamic> json) =>
      _$RequestPermissionPayloadFromJson(json);
}

class RequestPermissionRequest {
  final Object id;
  final RequestPermissionPayload params;

  const RequestPermissionRequest({
    required this.id,
    required this.params,
  });

  factory RequestPermissionRequest.fromJson(Map<String, dynamic> json) {
    return RequestPermissionRequest(
      id: json['id'] as Object,
      params: RequestPermissionPayload.fromJson(
        json['params'] as Map<String, dynamic>,
      ),
    );
  }
}

sealed class PermissionOutcome {
  const PermissionOutcome();
}

class SelectedPermissionOutcome extends PermissionOutcome {
  final String optionId;

  const SelectedPermissionOutcome({required this.optionId});

  Map<String, dynamic> toJson() => {
    'outcome': 'selected',
    'optionId': optionId,
  };
}

class CancelledPermissionOutcome extends PermissionOutcome {
  const CancelledPermissionOutcome();

  Map<String, dynamic> toJson() => {'outcome': 'cancelled'};
}
