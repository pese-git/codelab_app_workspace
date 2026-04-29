import 'package:cherrypick/cherrypick.dart';
import 'package:flutter/widgets.dart';

/// Provides a cherrypick [Scope] to the widget tree.
class DiScope extends InheritedWidget {
  const DiScope({
    required this.scope,
    required super.child,
    super.key,
  });

  final Scope scope;

  @override
  bool updateShouldNotify(DiScope oldWidget) => false;

  static Scope of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<DiScope>();
    assert(scope != null, 'DiScope is missing in the widget tree.');
    return scope!.scope;
  }
}

/// Convenience extension on [BuildContext] for accessing DI scope.
extension DiScopeX on BuildContext {
  /// Returns the [Scope] from the nearest [DiScope].
  Scope get scope => DiScope.of(this);

  /// Resolves a dependency of type [T] from the current scope.
  T resolve<T extends Object>() => DiScope.of(this).resolve<T>();
}
