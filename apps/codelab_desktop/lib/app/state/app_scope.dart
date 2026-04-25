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
}
