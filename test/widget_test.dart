import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:readify/core/app_theme.dart';
import 'package:readify/screens/home_screen.dart';

void main() {
  group('Readify Responsive Layout', () {
    testWidgets('Compact layout menampilkan rekomendasi horizontal', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(440, 956);
      tester.view.devicePixelRatio = 1;

      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          home: const HomeScreen(),
        ),
      );

      expect(
        find.byKey(const ValueKey('compact-recommendations')),
        findsOneWidget,
      );

      expect(find.byKey(const ValueKey('wide-recommendations')), findsNothing);
    });

    testWidgets('Wide layout menampilkan rekomendasi berbentuk grid', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1100, 900);
      tester.view.devicePixelRatio = 1;

      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          home: const HomeScreen(),
        ),
      );

      expect(
        find.byKey(const ValueKey('wide-recommendations')),
        findsOneWidget,
      );

      expect(
        find.byKey(const ValueKey('compact-recommendations')),
        findsNothing,
      );
    });
  });
}
