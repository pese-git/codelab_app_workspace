import 'package:freezed_annotation/freezed_annotation.dart';

part 'session_setup.freezed.dart';
part 'session_setup.g.dart';

@freezed
abstract class SessionMode with _$SessionMode {
  const factory SessionMode({
    required String id,
    required String name,
    String? description,
  }) = _SessionMode;

  factory SessionMode.fromJson(Map<String, dynamic> json) =>
      _$SessionModeFromJson(json);
}

@freezed
abstract class SessionModeState with _$SessionModeState {
  const factory SessionModeState({
    required List<SessionMode> availableModes,
    required String currentModeId,
  }) = _SessionModeState;

  factory SessionModeState.fromJson(Map<String, dynamic> json) =>
      _$SessionModeStateFromJson(json);
}

@freezed
abstract class SessionConfigValueOption with _$SessionConfigValueOption {
  const factory SessionConfigValueOption({
    required String value,
    required String name,
    String? description,
  }) = _SessionConfigValueOption;

  factory SessionConfigValueOption.fromJson(Map<String, dynamic> json) =>
      _$SessionConfigValueOptionFromJson(json);
}

@freezed
abstract class SessionConfigOption with _$SessionConfigOption {
  const factory SessionConfigOption({
    required String id,
    required String name,
    required String category,
    required String type,
    required String currentValue,
    required List<SessionConfigValueOption> options,
  }) = _SessionConfigOption;

  factory SessionConfigOption.fromJson(Map<String, dynamic> json) =>
      _$SessionConfigOptionFromJson(json);
}

@freezed
abstract class SessionSetupResult with _$SessionSetupResult {
  const factory SessionSetupResult({
    String? sessionId,
    @Default([]) List<SessionConfigOption> configOptions,
    SessionModeState? modes,
  }) = _SessionSetupResult;

  factory SessionSetupResult.fromJson(Map<String, dynamic> json) =>
      _$SessionSetupResultFromJson(json);
}
