import 'package:structured_log/structured_log.dart';

/// Creates a logger instance for the given class/category name.
///
/// Usage:
/// ```dart
/// final _log = createLogger('MyClass');
/// _log.info('Something happened', context: {'key': 'value'});
/// ```
BoundLogger createLogger(String name) {
  return getLogger(name);
}
