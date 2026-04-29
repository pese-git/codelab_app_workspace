import 'package:freezed_annotation/freezed_annotation.dart';

part 'session_setup.freezed.dart';

@freezed
abstract class SessionMode with _$SessionMode {
  const factory SessionMode({
    required String id,
    required String name,
    String? description,
  }) = _SessionMode;
}

@freezed
abstract class SessionModeState with _$SessionModeState {
  const factory SessionModeState({
    required List<SessionMode> availableModes,
    required String currentModeId,
  }) = _SessionModeState;
}

@freezed
abstract class SessionConfigValueOption with _$SessionConfigValueOption {
  const factory SessionConfigValueOption({
    required String value,
    required String name,
    String? description,
  }) = _SessionConfigValueOption;
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
}

@freezed
abstract class SessionSetupResult with _$SessionSetupResult {
  const factory SessionSetupResult({
    String? sessionId,
    @Default([]) List<SessionConfigOption> configOptions,
    SessionModeState? modes,
  }) = _SessionSetupResult;
}
