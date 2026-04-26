import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:codelab_desktop/app/app.dart';

void main() {
  testWidgets('renders home screen', (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(1200, 800));
    await tester.pumpWidget(const CodeLabAppBootstrap());
    await tester.pumpAndSettle();

    expect(find.text('Создавайте что угодно'), findsOneWidget);
    expect(find.textContaining('Последнее изменение'), findsOneWidget);

    await tester.binding.setSurfaceSize(null);
  });
}
