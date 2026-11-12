import 'package:flutter/material.dart';

import '../core/app_theme.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Rak Bacaan Saya',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    color: AppColors.mint,
                    borderRadius: BorderRadius.circular(28),
                  ),
                  child: const Icon(
                    Icons.bookmarks_rounded,
                    color: AppColors.forest,
                    size: 48,
                  ),
                ),

                const SizedBox(height: 22),

                Text(
                  'Rak Bacaanmu',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),

                const SizedBox(height: 10),

                const Text(
                  'Semua buku yang kamu simpan akan ditampilkan di halaman ini.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.muted,
                    fontSize: 13,
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 24),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: AppColors.line),
                  ),
                  child: const Column(
                    children: [
                      Icon(
                        Icons.library_books_rounded,
                        color: AppColors.leaf,
                        size: 30,
                      ),

                      SizedBox(height: 10),

                      Text(
                        'Koleksi Buku Pribadi',
                        style: TextStyle(
                          color: AppColors.ink,
                          fontWeight: FontWeight.w800,
                          fontSize: 15,
                        ),
                      ),

                      SizedBox(height: 6),

                      Text(
                        'Koleksi, status membaca, rating, dan catatan akan dikelola melalui database Supabase.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: AppColors.muted, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
