import 'package:codelab_desktop/infrastructure/transport/reconnection_policy.dart';
import 'package:test/test.dart';

void main() {
  group('ReconnectionPolicy', () {
    test('starts with initial delay', () {
      final policy = ReconnectionPolicy(
        initialDelay: const Duration(seconds: 1),
        maxDelay: const Duration(seconds: 30),
        maxRetries: 5,
      );

      expect(policy.attempt, 0);
      expect(policy.hasReachedMaxRetries(), isFalse);
    });

    test('increases delay exponentially', () {
      final policy = ReconnectionPolicy(
        initialDelay: const Duration(seconds: 1),
        maxDelay: const Duration(seconds: 30),
        maxRetries: 10,
        backoffFactor: 2.0,
      );

      final delay1 = policy.getNextDelay();
      final delay2 = policy.getNextDelay();
      final delay3 = policy.getNextDelay();

      expect(delay1, const Duration(seconds: 1));
      expect(delay2, const Duration(seconds: 2));
      expect(delay3, const Duration(seconds: 4));
    });

    test('caps delay at maxDelay', () {
      final policy = ReconnectionPolicy(
        initialDelay: const Duration(seconds: 1),
        maxDelay: const Duration(seconds: 8),
        maxRetries: 10,
        backoffFactor: 2.0,
      );

      policy.getNextDelay(); // 1s
      policy.getNextDelay(); // 2s
      policy.getNextDelay(); // 4s
      final delay4 = policy.getNextDelay(); // 8s (capped)
      final delay5 = policy.getNextDelay(); // 8s (capped)

      expect(delay4, const Duration(seconds: 8));
      expect(delay5, const Duration(seconds: 8));
    });

    test('resets attempt counter', () {
      final policy = ReconnectionPolicy(
        initialDelay: const Duration(seconds: 1),
        maxDelay: const Duration(seconds: 30),
        maxRetries: 5,
      );

      policy.getNextDelay();
      policy.getNextDelay();
      expect(policy.attempt, 2);

      policy.reset();
      expect(policy.attempt, 0);

      final delayAfterReset = policy.getNextDelay();
      expect(delayAfterReset, const Duration(seconds: 1));
    });

    test('reports max retries reached', () {
      final policy = ReconnectionPolicy(
        initialDelay: const Duration(seconds: 1),
        maxDelay: const Duration(seconds: 30),
        maxRetries: 3,
      );

      expect(policy.hasReachedMaxRetries(), isFalse);

      policy.getNextDelay();
      policy.getNextDelay();
      policy.getNextDelay();

      expect(policy.hasReachedMaxRetries(), isTrue);
    });
  });
}
