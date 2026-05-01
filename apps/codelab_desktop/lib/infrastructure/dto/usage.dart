import 'package:freezed_annotation/freezed_annotation.dart';

part 'usage.freezed.dart';
part 'usage.g.dart';

@freezed
abstract class UsageInfo with _$UsageInfo {
  const factory UsageInfo({
    @Default(0) int inputTokens,
    @Default(0) int outputTokens,
    @Default(0) int totalTokens,
    @Default(0.0) double cost,
    String? costCurrency,
  }) = _UsageInfo;

  factory UsageInfo.fromJson(Map<String, dynamic> json) =>
      _$UsageInfoFromJson(json);
}

@freezed
abstract class UsageUpdate with _$UsageUpdate {
  const factory UsageUpdate({
    @Default('usage_update') String sessionUpdate,
    required UsageInfo usage,
  }) = _UsageUpdate;

  factory UsageUpdate.fromJson(Map<String, dynamic> json) =>
      _$UsageUpdateFromJson(json);
}
