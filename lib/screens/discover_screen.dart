
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/app_theme.dart';
import '../models/book.dart';
import '../providers/catalog_provider.dart';
import '../widgets/book_card.dart';
import 'book_detail_screen.dart';

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  final TextEditingController _searchController = TextEditingController();

  Future<void> _searchBooks() async {
    FocusScope.of(context).unfocus();

    await context.read<CatalogProvider>().searchBooks(
      query: _searchController.text,
    );
  }

  void _openBookDetail(Book book) {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (context) => BookDetailScreen(book: book),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        title: const Text(
          'Jelajah Buku',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Temukan Buku Favoritmu',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 8),
              Text(
                'Cari berbagai buku dari katalog Open Library.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _searchController,
                textInputAction: TextInputAction.search,
                onSubmitted: (_) => _searchBooks(),
                decoration: InputDecoration(
                  hintText: 'Masukkan judul atau penulis buku',
                  prefixIcon: const Icon(
                    Icons.search,
                    color: AppColors.forest,
                  ),
                  suffixIcon: IconButton(
                    onPressed: _searchBooks,
                    icon: const Icon(
                      Icons.arrow_forward,
                      color: AppColors.forest,
                    ),
                  ),
                  filled: true,
                  fillColor: AppColors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Hasil Pencarian',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              Expanded(
                child: Consumer<CatalogProvider>(
                  builder: (context, provider, child) {
                    if (provider.isLoading) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.forest,
                        ),
                      );
                    }

                    if (provider.error != null) {
                      return Center(
                        child: _FeedbackMessage(
                          icon: Icons.wifi_off,
                          title: 'Gagal Memuat Buku',
                          message: provider.error!,
                          buttonText: 'Coba Lagi',
                          onPressed: _searchBooks,
                        ),
                      );
                    }

                    if (provider.books.isEmpty) {
                      return Center(
                        child: _FeedbackMessage(
                          icon: Icons.menu_book_outlined,
                          title: provider.searchQuery.isEmpty
                              ? 'Mulai Jelajahi Buku'
                              : 'Buku Tidak Ditemukan',
                          message: provider.searchQuery.isEmpty
                              ? 'Masukkan judul atau nama penulis pada kolom pencarian.'
                              : 'Coba gunakan kata kunci pencarian yang berbeda.',
                        ),
                      );
                    }

                    return LayoutBuilder(
                      builder: (context, constraints) {
                        final isWide = constraints.maxWidth >= 700;

                        if (isWide) {
                          return GridView.builder(
                            itemCount: provider.books.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 12,
                                  mainAxisSpacing: 12,
                                  mainAxisExtent: 132,
                                ),
                            itemBuilder: (context, index) {
                              final book = provider.books[index];

                              return BookCard(
                                book: book,
                                onTap: () => _openBookDetail(book),
                              );
                            },
                          );
                        }

                        return ListView.separated(
                          itemCount: provider.books.length,
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final book = provider.books[index];

                            return BookCard(
                              book: book,
                              onTap: () => _openBookDetail(book),
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FeedbackMessage extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final String? buttonText;
  final VoidCallback? onPressed;

  const _FeedbackMessage({
    required this.icon,
    required this.title,
    required this.message,
    this.buttonText,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: AppColors.leaf, size: 52),
            const SizedBox(height: 14),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.ink,
                fontSize: 17,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.muted,
                fontSize: 13,
                height: 1.5,
              ),
            ),
            if (buttonText != null && onPressed != null) ...[
              const SizedBox(height: 16),
              FilledButton(
                onPressed: onPressed,
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.forest,
                  foregroundColor: AppColors.white,
                ),
                child: Text(buttonText!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
