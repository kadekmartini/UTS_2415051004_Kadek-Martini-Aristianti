import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/app_theme.dart';
import 'providers/catalog_provider.dart';
import 'providers/reading_provider.dart';
import 'screens/main_shell.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ReadifyApp());
}

class ReadifyApp extends StatelessWidget {
  const ReadifyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CatalogProvider()),
        ChangeNotifierProvider(create: (context) => ReadingProvider()),
      ],
      child: MaterialApp(
        title: 'Readify',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        home: const MainShell(),
      ),
    );
  }
}
