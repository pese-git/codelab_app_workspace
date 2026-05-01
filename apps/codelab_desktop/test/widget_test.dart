import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:codelab_desktop/app/bootstrap/app.dart';
import 'package:codelab_desktop/core/di/injection.dart';

void main() {
  testWidgets('renders empty welcome screen', (WidgetTester tester) async {
    configureDependencies();

    await tester.binding.setSurfaceSize(const Size(1200, 800));
    await tester.pumpWidget(const CodeLabAppBootstrap());
    await tester.pumpAndSettle();

    expect(find.text('Добро пожаловать в CodeLab'), findsOneWidget);
    expect(find.text('Откройте проект, чтобы начать работу'), findsOneWidget);
    expect(find.text('Открыть проект'), findsOneWidget);

    await tester.binding.setSurfaceSize(null);
  });
}
