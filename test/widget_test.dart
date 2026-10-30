import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:splitmate/app/app.dart';

void main() {
  testWidgets('SplitMate dashboard loads', (WidgetTester tester) async {
    await tester.pumpWidget(const SplitMateApp());

    expect(find.text('Sreenu 👋'), findsOneWidget);

    expect(find.text("Here's your expense overview"), findsOneWidget);

    expect(find.byIcon(Icons.notifications_none_rounded), findsOneWidget);
  });
}
