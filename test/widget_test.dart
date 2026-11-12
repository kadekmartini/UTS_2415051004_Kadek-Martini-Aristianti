import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:readify/core/app_theme.dart';
import 'package:readify/screens/home_screen.dart';

void main() {
  testWidgets('Readify home screen displays correctly', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        home: const HomeScreen(),
      ),
    );

    expect(find.text('readify'), findsOneWidget);

    expect(find.text('Halo, pembaca!'), findsOneWidget);

    expect(find.text('Ringkasan bacaan'), findsOneWidget);

    expect(find.text('Rekomendasi buku'), findsOneWidget);

    expect(find.text('Target membaca'), findsOneWidget);
  });
}
