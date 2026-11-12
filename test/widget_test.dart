import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:readify/core/app_theme.dart';
import 'package:readify/providers/catalog_provider.dart';
import 'package:readify/providers/reading_provider.dart';
import 'package:readify/screens/home_screen.dart';
import 'package:readify/screens/main_shell.dart';

Widget buildTestApp({required Widget home}) {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => CatalogProvider()),
      ChangeNotifierProvider(create: (context) => ReadingProvider()),
    ],
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: home,
    ),
  );
}

void main() {
  group('Readify Responsive Layout', () {
    testWidgets('Compact layout menampilkan rekomendasi horizontal', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(440, 956);
      tester.view.devicePixelRatio = 1;

      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(buildTestApp(home: const HomeScreen()));

      expect(
        find.byKey(const ValueKey('compact-recommendations')),
        findsOneWidget,
      );

      expect(find.byKey(const ValueKey('wide-recommendations')), findsNothing);

      expect(tester.takeException(), isNull);
    });

    testWidgets('Wide layout menampilkan rekomendasi grid', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1100, 900);
      tester.view.devicePixelRatio = 1;

      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(buildTestApp(home: const HomeScreen()));

      expect(
        find.byKey(const ValueKey('wide-recommendations')),
        findsOneWidget,
      );

      expect(
        find.byKey(const ValueKey('compact-recommendations')),
        findsNothing,
      );

      expect(tester.takeException(), isNull);
    });
  });

  group('Readify Navigation', () {
    testWidgets('Compact navigation dapat berpindah halaman', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(440, 956);
      tester.view.devicePixelRatio = 1;

      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(buildTestApp(home: const MainShell()));

      await tester.pumpAndSettle();

      expect(find.text('Halo, pembaca!'), findsOneWidget);

      await tester.tap(find.text('Jelajah').last);

      await tester.pumpAndSettle();

      expect(find.text('Temukan Buku Favoritmu'), findsOneWidget);

      await tester.tap(find.text('Rak Saya').last);

      await tester.pumpAndSettle();

      expect(find.text('Rak Bacaanmu'), findsOneWidget);

      await tester.tap(find.text('Profil').last);

      await tester.pumpAndSettle();

      expect(find.text('Profil Saya'), findsOneWidget);

      expect(find.text('Kadek Martini Aristianti'), findsNWidgets(2));

      expect(find.text('2415051004'), findsOneWidget);

      expect(find.text('PTI 5 C'), findsNWidgets(2));

      expect(find.text('Pendidikan Teknik Informatika'), findsOneWidget);

      expect(tester.takeException(), isNull);
    });

    testWidgets('Wide navigation menggunakan NavigationRail', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1100, 900);
      tester.view.devicePixelRatio = 1;

      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(buildTestApp(home: const MainShell()));

      await tester.pumpAndSettle();

      expect(find.byType(NavigationRail), findsOneWidget);

      await tester.tap(find.text('Profil').last);

      await tester.pumpAndSettle();

      expect(find.text('Profil Saya'), findsOneWidget);

      expect(find.text('Kadek Martini Aristianti'), findsNWidgets(2));

      expect(find.text('2415051004'), findsOneWidget);

      expect(tester.takeException(), isNull);
    });
  });
}
