import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:codelab_desktop/app/app.dart';

void main() {
  testWidgets('renders home shell and navigates to a session', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const CodeLabAppBootstrap());
    await tester.pumpAndSettle();

    expect(find.text('Создавайте что угодно'), findsOneWidget);
    expect(find.textContaining('Последнее изменение'), findsOneWidget);

    await tester.tap(find.text('Подключить провайдера'));
    await tester.pumpAndSettle();
    expect(find.text('Провайдеры'), findsOneWidget);
    await tester.tap(find.text('OpenAI'));
    await tester.pumpAndSettle();

    await tester.tap(
      find.text('Greeting in Russian conversation context').first,
    );
    await tester.pumpAndSettle();

    expect(find.text('Greeting in Russian conversation context'), findsWidgets);
    expect(find.text('Git changes'), findsOneWidget);
    expect(find.text('Терминал 1'), findsOneWidget);

    await tester.tap(find.byIcon(FluentIcons.server_processes));
    await tester.pumpAndSettle();
    expect(find.text('Серверы'), findsOneWidget);
  });
}
