import 'package:freezed_annotation/freezed_annotation.dart';

part 'prompt_result.freezed.dart';
part 'prompt_result.g.dart';

typedef StopReason = String;

@freezed
abstract class PromptResult with _$PromptResult {
  const factory PromptResult({
    required String stopReason,
  }) = _PromptResult;

  factory PromptResult.fromJson(Map<String, dynamic> json) =>
      _$PromptResultFromJson(json);

  const PromptResult._();

  bool get isEndTurn => stopReason == 'end_turn';
  bool get isCancelled => stopReason == 'cancelled';
}
