import 'package:flutter_test/flutter_test.dart';

import 'package:soulnotes/main.dart';

void main() {
  testWidgets('App shows welcome flow', (WidgetTester tester) async {
    await tester.pumpWidget(const SoulNotesApp());

    expect(find.text('Welcome to SoulNotes'), findsOneWidget);
  });
}
