import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/app_theme.dart';
import 'providers/catalog_provider.dart';
import 'providers/reading_provider.dart';
import 'screens/main_shell.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://rfkglblbdmcvrqotoyik.supabase.co',
    publishableKey: 'sb_publishable_Kofee-IRYHEKbPhuqAIYpQ_ZfqAgQUg',
  );

  // Membuat sesi pengguna anonim jika belum ada.
  try {
    final supabase = Supabase.instance.client;

    if (supabase.auth.currentSession == null) {
      await supabase.auth.signInAnonymously();
      debugPrint('Readify: Anonymous sign-in berhasil.');
    } else {
      debugPrint('Readify: Sesi pengguna sudah tersedia.');
    }
  } catch (error, stackTrace) {
    debugPrint('Readify: Anonymous sign-in gagal: $error');
    debugPrintStack(stackTrace: stackTrace);
  }

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
