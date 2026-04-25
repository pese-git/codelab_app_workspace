import 'package:flutter_test/flutter_test.dart';

import 'package:codelab_desktop/main.dart';

void main() {
  testWidgets('renders fluent workspace screen', (WidgetTester tester) async {
    await tester.pumpWidget(const CodeLabApp());

    expect(find.text('CodeLab Workspace'), findsOneWidget);
    expect(find.text('Build ideas faster'), findsOneWidget);
    expect(find.text('Next steps'), findsOneWidget);
    expect(find.text('Create idea'), findsOneWidget);
  });
}
