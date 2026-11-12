
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/app_theme.dart';
import '../models/book.dart';
import '../providers/catalog_provider.dart';
import '../providers/reading_provider.dart';
import '../widgets/book_card.dart';
import '../widgets/feedback_state.dart';
import 'book_detail_screen.dart';
import 'library_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback? onOpenProfile;
  final ValueChanged<String>? onOpenLibrary;

  const HomeScreen({
    super.key,
    this.onOpenProfile,
    this.onOpenLibrary,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<CatalogProvider>().loadRecommendations();
    });
  }

  void _openProfile() {
    if (widget.onOpenProfile != null) {
      widget.onOpenProfile!();
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (context) => const ProfileScreen(),
      ),
    );
  }

  void _openLibrary(String status) {
    if (widget.onOpenLibrary != null) {
      widget.onOpenLibrary!(status);
      return;
    }

    context.read<ReadingProvider>().setStatusFilter(status);

    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (context) => const LibraryScreen(),
      ),
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              height: 38,
              width: 38,
              decoration: BoxDecoration(
                color: AppColors.forest,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.auto_stories_rounded,
                color: Colors.white,
                size: 22,
              ),
            ),
            const SizedBox(width: 10),
            const Text(
              'readify',
              style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.w900,
                letterSpacing: -0.8,
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 18),
            child: Material(
              color: AppColors.mint,
              shape: const CircleBorder(),
              child: IconButton(
                tooltip: 'Profil Saya',
                onPressed: _openProfile,
                icon: const Icon(
                  Icons.person_outline_rounded,
                  color: AppColors.forest,
                  size: 22,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth >= 800;
            final horizontalPadding = isWide ? 32.0 : 20.0;
            final gridColumns =
                constraints.maxWidth >= 1100 ? 4 : 3;

            return SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                horizontalPadding,
                12,
                horizontalPadding,
                28,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1180),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'PERSONAL READING SPACE',
                        style: TextStyle(
                          color: AppColors.leaf,
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Halo, pembaca!',
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'Temukan cerita dan pengetahuan baru hari ini.',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 22),
                      if (isWide)
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Expanded(
                              flex: 3,
                              child: _HeroBanner(),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              flex: 2,
                              child: _StatisticsSection(
                                onOpenLibrary: _openLibrary,
                              ),
                            ),
                          ],
                        )
                      else ...[
                        const _HeroBanner(),
                        const SizedBox(height: 25),
                        _StatisticsSection(
                          onOpenLibrary: _openLibrary,
                        ),
                      ],
                      const SizedBox(height: 27),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Rekomendasi buku',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                          ),
                          const SizedBox(width: 8),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute<void>(
                                  builder: (context) =>
                                      const LibraryScreen(),
                                ),
                              );
                            },
                            style: TextButton.styleFrom(
                              foregroundColor: AppColors.forest,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                              ),
                            ),
                            child: const Text(
                              'Rak Saya',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      const Text(
                        'Temukan bacaan untuk menemani harimu.',
                        style: TextStyle(
                          color: AppColors.muted,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 15),
                      _RecommendationsSection(
                        isWide: isWide,
                        columns: gridColumns,
                        onBookTap: _openBookDetail,
                      ),
                      const SizedBox(height: 26),
                      const _ReadingProgress(),
                      const SizedBox(height: 22),
                      const Center(
                        child: Text(
                          'READ MORE. GROW MORE.',
                          style: TextStyle(
                            color: AppColors.leaf,
                            fontWeight: FontWeight.w800,
                            fontSize: 10,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _HeroBanner extends StatelessWidget {
  const _HeroBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(23),
        gradient: const LinearGradient(
          colors: [
            AppColors.forestDark,
            AppColors.forest,
            Color(0xFF66866A),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -15,
            top: -25,
            child: Container(
              width: 125,
              height: 125,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.07),
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE5B17C),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const Text(
                        'YOUR READING SPACE',
                        style: TextStyle(
                          color: Color(0xFF443221),
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ),
                    const SizedBox(height: 17),
                    const Text(
                      'Satu halaman,\nbanyak dunia.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.w900,
                        height: 1.15,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Luangkan waktu, temukan cerita baru, dan nikmati perjalanan membaca.',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.85),
                        fontSize: 11,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const Icon(
                Icons.auto_stories_rounded,
                color: Color(0xBFFFFFFF),
                size: 72,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatisticsSection extends StatelessWidget {
  final ValueChanged<String> onOpenLibrary;

  const _StatisticsSection({
    required this.onOpenLibrary,
  });

  String _formatValue(ReadingProvider provider, int value) {
    if (provider.items.isEmpty && provider.isLoading) {
      return '...';
    }

    if (provider.items.isEmpty && provider.error != null) {
      return '—';
    }

    return value.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ReadingProvider>(
      builder: (context, provider, child) {
        String description;

        if (provider.items.isEmpty && provider.isLoading) {
          description = 'Sedang memuat koleksi bacaan.';
        } else if (provider.items.isEmpty && provider.error != null) {
          description = 'Statistik belum dapat dimuat.';
        } else {
          description = 'Ketuk ringkasan untuk melihat koleksimu.';
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ringkasan bacaan',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 5),
            Text(
              description,
              style: const TextStyle(
                fontSize: 10,
                color: AppColors.muted,
              ),
            ),
            const SizedBox(height: 13),
            Row(
              children: [
                Expanded(
                  child: _StatisticCard(
                    icon: Icons.library_books_rounded,
                    value: _formatValue(provider, provider.totalBooks),
                    label: 'Total buku',
                    backgroundColor: const Color(0xFFE3EEE3),
                    iconColor: AppColors.forest,
                    onTap: () => onOpenLibrary('all'),
                  ),
                ),
                const SizedBox(width: 9),
                Expanded(
                  child: _StatisticCard(
                    icon: Icons.menu_book_rounded,
                    value: _formatValue(provider, provider.readingCount),
                    label: 'Dibaca',
                    backgroundColor: const Color(0xFFFFE9D8),
                    iconColor: const Color(0xFFAC682F),
                    onTap: () => onOpenLibrary('reading'),
                  ),
                ),
                const SizedBox(width: 9),
                Expanded(
                  child: _StatisticCard(
                    icon: Icons.check_circle_rounded,
                    value: _formatValue(provider, provider.finishedCount),
                    label: 'Selesai',
                    backgroundColor: const Color(0xFFEAE7F3),
                    iconColor: const Color(0xFF6C5B91),
                    onTap: () => onOpenLibrary('finished'),
                  ),
                ),
              ],
            ),
            if (provider.error != null && provider.items.isEmpty) ...[
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton.icon(
                  onPressed: provider.loadItems,
                  icon: const Icon(Icons.refresh_rounded, size: 16),
                  label: const Text('Coba muat ulang'),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.forest,
                  ),
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}

class _StatisticCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color backgroundColor;
  final Color iconColor;
  final VoidCallback onTap;

  const _StatisticCard({
    required this.icon,
    required this.value,
    required this.label,
    required this.backgroundColor,
    required this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(17),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(17),
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: 13,
            horizontal: 9,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(17),
            border: Border.all(
              color: iconColor.withValues(alpha: 0.13),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: iconColor, size: 21),
              const SizedBox(height: 10),
              Text(
                value,
                style: TextStyle(
                  color: iconColor,
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: AppColors.ink,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 7),
              Row(
                children: [
                  Text(
                    'Lihat',
                    style: TextStyle(
                      color: iconColor,
                      fontSize: 9,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(width: 3),
                  Icon(
                    Icons.arrow_forward_rounded,
                    color: iconColor,
                    size: 11,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RecommendationsSection extends StatelessWidget {
  final bool isWide;
  final int columns;
  final ValueChanged<Book> onBookTap;

  const _RecommendationsSection({
    required this.isWide,
    required this.columns,
    required this.onBookTap,
  });

  Widget _buildFeedback(CatalogProvider provider) {
    if (provider.isLoadingRecommendations) {
      return const FeedbackState(
        isLoading: true,
        title: 'Memuat Rekomendasi',
        message: 'Sedang mengambil buku dari Open Library.',
      );
    }

    if (provider.recommendationError != null) {
      return FeedbackState(
        icon: Icons.wifi_off_rounded,
        title: 'Rekomendasi Gagal Dimuat',
        message: provider.recommendationError!,
        buttonText: 'Coba Lagi',
        onPressed: () {
          provider.loadRecommendations(forceRefresh: true);
        },
      );
    }

    return const FeedbackState(
      icon: Icons.menu_book_outlined,
      title: 'Rekomendasi Belum Tersedia',
      message: 'Belum ada buku dengan sampul yang dapat ditampilkan.',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CatalogProvider>(
      builder: (context, provider, child) {
        final books = provider.recommendations.take(12).toList();
        final hasBooks = books.isNotEmpty;

        if (isWide) {
          return GridView.builder(
            key: const ValueKey('wide-recommendations'),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: columns,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              mainAxisExtent: hasBooks ? 132 : 210,
            ),
            itemCount: hasBooks ? books.length : 1,
            itemBuilder: (context, index) {
              if (!hasBooks) {
                return _buildFeedback(provider);
              }

              final book = books[index];

              return BookCard(
                book: book,
                onTap: () => onBookTap(book),
              );
            },
          );
        }

        return SizedBox(
          height: 235,
          child: ListView.separated(
            key: const ValueKey('compact-recommendations'),
            scrollDirection: Axis.horizontal,
            itemCount: hasBooks ? books.length : 1,
            separatorBuilder: (context, index) =>
                const SizedBox(width: 12),
            itemBuilder: (context, index) {
              if (!hasBooks) {
                return SizedBox(
                  width: 300,
                  child: _buildFeedback(provider),
                );
              }

              final book = books[index];

              return SizedBox(
                width: 260,
                child: BookCard(
                  book: book,
                  onTap: () => onBookTap(book),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class _ReadingProgress extends StatelessWidget {
  const _ReadingProgress();

  @override
  Widget build(BuildContext context) {
    return Consumer<ReadingProvider>(
      builder: (context, provider, child) {
        final totalBooks = provider.totalBooks;
        final finishedBooks = provider.finishedCount;
        final hasError = provider.error != null && totalBooks == 0;
        final isLoading = provider.isLoading && totalBooks == 0;

        final progress = totalBooks == 0
            ? 0.0
            : finishedBooks / totalBooks;

        final percentage = hasError
            ? '—'
            : '${(progress * 100).round()}%';

        final description = isLoading
            ? 'Sedang memuat progres membaca.'
            : hasError
                ? 'Progres belum dapat dimuat. Periksa koneksi.'
                : totalBooks == 0
                    ? 'Tambahkan buku ke Rak Saya untuk melihat progres membaca.'
                    : '$finishedBooks dari $totalBooks buku sudah selesai dibaca.';

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: const Color(0xFFFFEBD9),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: const Color(0xFFF2D3B5),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(
                    Icons.auto_graph_rounded,
                    color: Color(0xFFAD682F),
                    size: 22,
                  ),
                  SizedBox(width: 9),
                  Text(
                    'Progres membaca',
                    style: TextStyle(
                      color: AppColors.ink,
                      fontWeight: FontWeight.w800,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 13),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      description,
                      style: const TextStyle(
                        color: AppColors.ink,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    percentage,
                    style: const TextStyle(
                      color: Color(0xFFAD682F),
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 10,
                  backgroundColor: const Color(0xFFE8D4BF),
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    Color(0xFFD58A4F),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Persentase buku selesai dibaca dari seluruh koleksi.',
                style: TextStyle(
                  color: AppColors.muted,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
