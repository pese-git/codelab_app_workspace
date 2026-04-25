import 'package:flutter_test/flutter_test.dart';

import 'package:codelab_desktop/app/app.dart';

void main() {
  testWidgets('renders home shell and navigates to a session', (WidgetTester tester) async {
    await tester.pumpWidget(const CodeLabAppBootstrap());
    await tester.pumpAndSettle();

    expect(find.text('OpenCode desktop replica'), findsOneWidget);
    expect(find.text('Recent projects'), findsOneWidget);

    await tester.tap(find.text('CodeLab Desktop').first);
    await tester.pumpAndSettle();

    expect(find.text('Desktop shell parity'), findsOneWidget);
    expect(find.text('Files'), findsOneWidget);
    expect(find.text('Context Panel'), findsOneWidget);
  });
}
