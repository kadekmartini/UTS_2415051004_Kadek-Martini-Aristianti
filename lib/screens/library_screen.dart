
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/app_theme.dart';
import '../models/reading_item.dart';
import '../providers/reading_provider.dart';
import '../widgets/feedback_state.dart';
import '../widgets/reading_item_card.dart';
import 'saved_book_detail_screen.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<ReadingProvider>().loadItems();
      }
    });
  }

  Future<void> _refreshBooks() async {
    await context.read<ReadingProvider>().loadItems();
  }

  void _openBookDetail(ReadingItem book) {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (context) => SavedBookDetailScreen(book: book),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        title: const Text(
          'Rak Bacaan Saya',
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
                'Rak Bacaanmu',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 8),
              const Text(
                'Semua buku yang kamu simpan akan ditampilkan di sini.',
                style: TextStyle(
                  color: AppColors.muted,
                  fontSize: 13,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: Consumer<ReadingProvider>(
                  builder: (context, provider, child) {
                    if (provider.isLoading && provider.items.isEmpty) {
                      return const FeedbackState(
                        isLoading: true,
                        title: 'Memuat Rak Buku',
                        message: 'Sedang mengambil koleksi bukumu.',
                      );
                    }

                    if (provider.error != null &&
                        provider.items.isEmpty) {
                      return FeedbackState(
                        icon: Icons.wifi_off_rounded,
                        title: 'Gagal Memuat Rak Buku',
                        message: provider.error!,
                        buttonText: 'Coba Lagi',
                        onPressed: _refreshBooks,
                      );
                    }

                    if (provider.items.isEmpty) {
                      return const FeedbackState(
                        icon: Icons.menu_book_rounded,
                        title: 'Rak Bukumu Masih Kosong',
                        message:
                            'Buku yang kamu simpan nantinya akan muncul di sini.',
                      );
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: AppColors.line),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.library_books_rounded,
                                color: AppColors.forest,
                                size: 30,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Total Koleksi',
                                      style: TextStyle(
                                        color: AppColors.muted,
                                        fontSize: 12,
                                      ),
                                    ),
                                    Text(
                                      '${provider.totalBooks} Buku',
                                      style: const TextStyle(
                                        color: AppColors.ink,
                                        fontWeight: FontWeight.w800,
                                        fontSize: 19,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                onPressed: _refreshBooks,
                                tooltip: 'Muat ulang',
                                icon: const Icon(
                                  Icons.refresh_rounded,
                                  color: AppColors.forest,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 18),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              _buildFilter(provider, 'all', 'Semua'),
                              _buildFilter(
                                provider,
                                'want_to_read',
                                'Ingin Dibaca',
                              ),
                              _buildFilter(
                                provider,
                                'reading',
                                'Sedang Dibaca',
                              ),
                              _buildFilter(
                                provider,
                                'finished',
                                'Selesai Dibaca',
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 14),
                        if (provider.isLoading)
                          const LinearProgressIndicator(
                            color: AppColors.forest,
                            backgroundColor: AppColors.mint,
                          ),
                        if (provider.error != null)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Text(
                              'Pembaruan data gagal: ${provider.error}',
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        Expanded(
                          child: _buildBookCollection(
                            provider.filteredItems,
                          ),
                        ),
                      ],
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

  Widget _buildFilter(
    ReadingProvider provider,
    String value,
    String label,
  ) {
    final selected = provider.statusFilter == value;

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) {
          provider.setStatusFilter(value);
        },
        selectedColor: AppColors.mint,
        backgroundColor: AppColors.white,
        labelStyle: TextStyle(
          color: selected ? AppColors.forest : AppColors.muted,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
        side: BorderSide(
          color: selected ? AppColors.leaf : AppColors.line,
        ),
      ),
    );
  }

  Widget _buildBookCollection(List<ReadingItem> books) {
    if (books.isEmpty) {
      return const FeedbackState(
        icon: Icons.filter_list_off_rounded,
        title: 'Tidak Ada Buku',
        message: 'Belum ada buku dengan status membaca ini.',
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 700;

        if (isWide) {
          return GridView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: books.length,
            gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 2.5,
            ),
            itemBuilder: (context, index) {
              final book = books[index];

              return ReadingItemCard(
                book: book,
                onTap: () => _openBookDetail(book),
              );
            },
          );
        }

        return ListView.separated(
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: books.length,
          separatorBuilder: (context, index) =>
              const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final book = books[index];

            return ReadingItemCard(
              book: book,
              onTap: () => _openBookDetail(book),
            );
          },
        );
      },
    );
  }
}
