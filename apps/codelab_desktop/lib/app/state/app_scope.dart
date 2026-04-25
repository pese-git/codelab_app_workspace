import 'package:flutter/widgets.dart';

import 'app_controller.dart';

class CodeLabAppScope extends InheritedNotifier<CodeLabAppController> {
  const CodeLabAppScope({
    required CodeLabAppController controller,
    required super.child,
    super.key,
  }) : super(notifier: controller);

  static CodeLabAppController of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<CodeLabAppScope>();
    assert(scope != null, 'CodeLabAppScope is missing in the widget tree.');
    return scope!.notifier!;
  }

  /// Returns the [SessionTabsController] for managing file tabs.
  static SessionTabsController sessionTabsOf(BuildContext context) {
    return of(context).sessionTabsController;
  }

  /// Returns the [TerminalController] for managing terminal sessions.
  static TerminalController terminalOf(BuildContext context) {
    return of(context).terminalController;
  }
}

/// Convenience extension on [BuildContext] for accessing app state.
extension CodeLabAppScopeX on BuildContext {
  /// Returns the [CodeLabAppController] from the nearest [CodeLabAppScope].
  CodeLabAppController get appController => CodeLabAppScope.of(this);

  /// Returns the [SessionTabsController] for managing file tabs.
  SessionTabsController get sessionTabs => CodeLabAppScope.sessionTabsOf(this);

  /// Returns the [TerminalController] for managing terminal sessions.
  TerminalController get terminal => CodeLabAppScope.terminalOf(this);
}
