import 'package:flutter/material.dart';

import 'core/app_theme.dart';
import 'screens/main_shell.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const ReadifyApp());
}

class ReadifyApp extends StatelessWidget {
  const ReadifyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Readify',

      debugShowCheckedModeBanner: false,

      theme: AppTheme.light,

      home: const MainShell(),
    );
  }
}
