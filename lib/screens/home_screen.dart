import 'package:flutter/material.dart';

import '../core/app_theme.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 18),
            child: CircleAvatar(
              radius: 18,
              backgroundColor: AppColors.mint,
              child: Icon(
                Icons.person_outline_rounded,
                color: AppColors.forest,
                size: 21,
              ),
            ),
          ),
        ],
      ),

      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final bool isWide = constraints.maxWidth >= 800;

            final double horizontalPadding = isWide ? 32 : 20;

            final int gridColumns = constraints.maxWidth >= 1100 ? 4 : 3;

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
                      // INTRODUCTION
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

                      // RESPONSIVE HERO AND STATISTICS
                      if (isWide) ...[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Expanded(flex: 3, child: _HeroBanner()),
                            const SizedBox(width: 20),
                            const Expanded(
                              flex: 2,
                              child: _StatisticsSection(),
                            ),
                          ],
                        ),
                      ] else ...[
                        const _HeroBanner(),
                        const SizedBox(height: 25),
                        const _StatisticsSection(),
                      ],

                      const SizedBox(height: 27),

                      // RECOMMENDATION TITLE
                      // FIX: Expanded mencegah overflow.
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

                          const Text(
                            'Jelajahi',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.forest,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 5),

                      const Text(
                        'Temukan bacaan untuk menemani harimu.',
                        style: TextStyle(color: AppColors.muted, fontSize: 12),
                      ),

                      const SizedBox(height: 15),

                      // COMPACT: HORIZONTAL LIST
                      // WIDE: RESPONSIVE GRID
                      if (isWide)
                        _WideRecommendationGrid(columns: gridColumns)
                      else
                        const _CompactRecommendationList(),

                      const SizedBox(height: 26),

                      const _ReadingTarget(),

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

// ======================================
// HERO BANNER
// ======================================

class _HeroBanner extends StatelessWidget {
  const _HeroBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(23),
        gradient: const LinearGradient(
          colors: [AppColors.forestDark, AppColors.forest, Color(0xFF52785C)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
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
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Text(
                    'WELCOME TO READIFY',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1,
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                const Text(
                  'Satu halaman,\nbanyak dunia.',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    height: 1.15,
                  ),
                ),

                const SizedBox(height: 9),

                Text(
                  'Mulai perjalanan membaca dan kumpulkan buku favoritmu.',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.8),
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
            color: Color(0xAAFFFFFF),
            size: 75,
          ),
        ],
      ),
    );
  }
}

// ======================================
// STATISTICS SECTION
// ======================================

class _StatisticsSection extends StatelessWidget {
  const _StatisticsSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Ringkasan bacaan', style: Theme.of(context).textTheme.titleLarge),

        const SizedBox(height: 5),

        const Text(
          'Contoh data koleksi',
          style: TextStyle(fontSize: 10, color: AppColors.muted),
        ),

        const SizedBox(height: 13),

        const Row(
          children: [
            Expanded(
              child: _StatisticCard(
                icon: Icons.library_books_rounded,
                value: '12',
                label: 'Total buku',
              ),
            ),
            SizedBox(width: 9),
            Expanded(
              child: _StatisticCard(
                icon: Icons.menu_book_rounded,
                value: '03',
                label: 'Dibaca',
              ),
            ),
            SizedBox(width: 9),
            Expanded(
              child: _StatisticCard(
                icon: Icons.check_circle_rounded,
                value: '08',
                label: 'Selesai',
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ======================================
// STATISTIC CARD
// ======================================

class _StatisticCard extends StatelessWidget {
  const _StatisticCard({
    required this.icon,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 8),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: AppColors.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.leaf, size: 19),
          const SizedBox(height: 9),
          Text(
            value,
            style: const TextStyle(
              color: AppColors.ink,
              fontSize: 21,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            label,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: AppColors.muted, fontSize: 10),
          ),
        ],
      ),
    );
  }
}

// ======================================
// COMPACT RECOMMENDATION LIST
// ======================================

class _CompactRecommendationList extends StatelessWidget {
  const _CompactRecommendationList();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 235,
      child: ListView.separated(
        key: const ValueKey('compact-recommendations'),
        scrollDirection: Axis.horizontal,
        itemCount: _sampleBooks.length,

        separatorBuilder: (BuildContext context, int index) {
          return const SizedBox(width: 13);
        },

        itemBuilder: (context, index) {
          return _BookCard(book: _sampleBooks[index], width: 145);
        },
      ),
    );
  }
}

// ======================================
// WIDE RESPONSIVE RECOMMENDATION GRID
// ======================================

class _WideRecommendationGrid extends StatelessWidget {
  const _WideRecommendationGrid({required this.columns});

  final int columns;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      key: const ValueKey('wide-recommendations'),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.82,
      ),
      itemCount: _sampleBooks.length,
      itemBuilder: (context, index) {
        return _BookCard(book: _sampleBooks[index], width: double.infinity);
      },
    );
  }
}

// ======================================
// BOOK DATA
// ======================================

class _BookData {
  const _BookData({
    required this.title,
    required this.author,
    required this.tag,
    required this.colors,
    required this.icon,
  });

  final String title;
  final String author;
  final String tag;
  final List<Color> colors;
  final IconData icon;
}

const List<_BookData> _sampleBooks = [
  _BookData(
    title: 'Atomic Habits',
    author: 'James Clear',
    tag: 'Self Improvement',
    colors: [Color(0xFF325B49), Color(0xFF729278)],
    icon: Icons.spa_rounded,
  ),
  _BookData(
    title: 'Filosofi Teras',
    author: 'Henry Manampiring',
    tag: 'Filosofi',
    colors: [Color(0xFFB56D45), Color(0xFFE8AE77)],
    icon: Icons.wb_sunny_rounded,
  ),
  _BookData(
    title: 'The Psychology of Money',
    author: 'Morgan Housel',
    tag: 'Keuangan',
    colors: [Color(0xFF46516D), Color(0xFF8792B2)],
    icon: Icons.account_balance_wallet_rounded,
  ),
  _BookData(
    title: 'Deep Work',
    author: 'Cal Newport',
    tag: 'Produktivitas',
    colors: [Color(0xFF69513F), Color(0xFFB18C6B)],
    icon: Icons.psychology_rounded,
  ),
];

// ======================================
// BOOK CARD
// ======================================

class _BookCard extends StatelessWidget {
  const _BookCard({required this.book, required this.width});

  final _BookData book;
  final double width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                gradient: LinearGradient(
                  colors: book.colors,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(book.icon, color: Colors.white, size: 40),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      book.title.toUpperCase(),
                      textAlign: TextAlign.center,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 9),
          Text(
            book.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.ink,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            book.author,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 11, color: AppColors.muted),
          ),
          const SizedBox(height: 4),
          Text(
            book.tag,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 9,
              color: AppColors.leaf,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

// ======================================
// READING TARGET
// ======================================

class _ReadingTarget extends StatelessWidget {
  const _ReadingTarget();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF0E4),
        borderRadius: BorderRadius.circular(19),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.flag_rounded, color: AppColors.orange, size: 21),
              SizedBox(width: 9),
              Text(
                'Target membaca',
                style: TextStyle(
                  color: AppColors.ink,
                  fontWeight: FontWeight.w800,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 13),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '8 dari 12 buku',
                style: TextStyle(
                  color: AppColors.ink,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                '67%',
                style: TextStyle(
                  color: AppColors.orange,
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 9),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: const LinearProgressIndicator(
              value: 0.67,
              minHeight: 9,
              backgroundColor: Color(0xFFE8D8C8),
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.orange),
            ),
          ),
          const SizedBox(height: 9),
          const Text(
            'Terus semangat menyelesaikan target bacaanmu!',
            style: TextStyle(color: AppColors.muted, fontSize: 11),
          ),
        ],
      ),
    );
  }
}
