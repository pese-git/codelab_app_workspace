import 'package:freezed_annotation/freezed_annotation.dart';

part 'capabilities.freezed.dart';

@freezed
abstract class ClientCapabilities with _$ClientCapabilities {
  const factory ClientCapabilities({
    @Default(FileSystemCapabilities()) FileSystemCapabilities fs,
    @Default(true) bool terminal,
  }) = _ClientCapabilities;
}

@freezed
abstract class FileSystemCapabilities with _$FileSystemCapabilities {
  const factory FileSystemCapabilities({
    @Default(true) bool readTextFile,
    @Default(true) bool writeTextFile,
  }) = _FileSystemCapabilities;
}

@freezed
abstract class AgentCapabilities with _$AgentCapabilities {
  const factory AgentCapabilities({
    @Default(false) bool loadSession,
    @Default({}) Map<String, dynamic> promptCapabilities,
    @Default({}) Map<String, dynamic> mcpCapabilities,
    @Default({}) Map<String, dynamic> sessionCapabilities,
  }) = _AgentCapabilities;
}
