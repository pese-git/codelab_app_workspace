/// Политика переподключения с экспоненциальным backoff
///
/// Задержки: 1s → 2s → 4s → 8s → 16s → 30s (max)
class ReconnectionPolicy {
  ReconnectionPolicy({
    this.initialDelay = const Duration(seconds: 1),
    this.maxDelay = const Duration(seconds: 30),
    this.maxRetries = 10,
    this.backoffFactor = 2.0,
  });

  final Duration initialDelay;
  final Duration maxDelay;
  final int maxRetries;
  final double backoffFactor;

  int _attempt = 0;

  /// Возвращает задержку для текущей попытки и увеличивает счётчик
  Duration getNextDelay() {
    if (_attempt >= maxRetries) {
      return maxDelay;
    }

    final delayMs = initialDelay.inMilliseconds *
        _pow(backoffFactor, _attempt);
    _attempt++;

    return Duration(
      milliseconds: delayMs.clamp(0, maxDelay.inMilliseconds).toInt(),
    );
  }

  /// Сбрасывает счётчик попыток (успешное соединение)
  void reset() {
    _attempt = 0;
  }

  /// Проверяет, достигнут ли лимит попыток
  bool hasReachedMaxRetries() => _attempt >= maxRetries;

  int get attempt => _attempt;

  int _pow(double base, int exp) {
    var result = 1.0;
    for (var i = 0; i < exp; i++) {
      result *= base;
    }
    return result.toInt();
  }
}
