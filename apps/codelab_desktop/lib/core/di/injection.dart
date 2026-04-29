import 'package:cherrypick/cherrypick.dart';
import 'package:structured_log/structured_log.dart';

import 'app_module.dart';

late final Scope rootScope;

void configureDependencies() {
  StructlogConfiguration.configure(
    output: coloredConsoleOutput,
    initialContext: {'app': 'codelab_desktop'},
  );

  rootScope = CherryPick.openRootScope()
    ..installModules([AppModule()]);
}

T resolve<T extends Object>() => rootScope.resolve<T>();
