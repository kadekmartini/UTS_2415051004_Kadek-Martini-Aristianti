
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/app_theme.dart';
import '../providers/reading_provider.dart';
import 'library_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      final provider = context.read<ReadingProvider>();

      if (!provider.isLoading &&
          provider.items.isEmpty &&
          provider.error == null) {
        provider.loadItems();
      }
    });
  }

  void _openLibrary(String status) {
    context.read<ReadingProvider>().setStatusFilter(status);

    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (context) => const LibraryScreen(),
      ),
    );
  }

  String _statisticValue(ReadingProvider provider, int value) {
    if (provider.isLoading && provider.items.isEmpty) {
      return '...';
    }

    if (provider.error != null && provider.items.isEmpty) {
      return '—';
    }

    return value.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        title: const Text(
          'Profil Saya',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth >= 700;

            return SingleChildScrollView(
              padding: EdgeInsets.all(isWide ? 32 : 20),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 900),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const _ProfileHeader(),
                      const SizedBox(height: 28),
                      Row(
                        children: [
                          Container(
                            width: 5,
                            height: 25,
                            decoration: BoxDecoration(
                              color: AppColors.forest,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            'Identitas Mahasiswa',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ],
                      ),
                      const SizedBox(height: 13),
                      const _IdentityCard(),
                      const SizedBox(height: 28),
                      Row(
                        children: [
                          Container(
                            width: 5,
                            height: 25,
                            decoration: BoxDecoration(
                              color: const Color(0xFFD58A4F),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Statistik Koleksi',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                          ),
                          const Icon(
                            Icons.insights_rounded,
                            color: AppColors.leaf,
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      const Text(
                        'Ringkasan buku dari koleksi pribadi Readify.',
                        style: TextStyle(
                          color: AppColors.muted,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Consumer<ReadingProvider>(
                        builder: (context, provider, child) {
                          return Column(
                            children: [
                              if (provider.isLoading)
                                const LinearProgressIndicator(
                                  color: AppColors.forest,
                                  backgroundColor: AppColors.mint,
                                ),
                              if (provider.error != null &&
                                  provider.items.isEmpty)
                                _LoadError(
                                  message: provider.error!,
                                  onRetry: provider.loadItems,
                                ),
                              Row(
                                children: [
                                  Expanded(
                                    child: _StatisticCard(
                                      icon: Icons.library_books_rounded,
                                      value: _statisticValue(
                                        provider,
                                        provider.totalBooks,
                                      ),
                                      label: 'Total Buku',
                                      backgroundColor: const Color(
                                        0xFFE3EEE3,
                                      ),
                                      iconColor: AppColors.forest,
                                      onTap: () => _openLibrary('all'),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: _StatisticCard(
                                      icon: Icons.menu_book_rounded,
                                      value: _statisticValue(
                                        provider,
                                        provider.readingCount,
                                      ),
                                      label: 'Sedang Dibaca',
                                      backgroundColor: const Color(
                                        0xFFFFEBD9,
                                      ),
                                      iconColor: const Color(0xFFAD682F),
                                      onTap: () => _openLibrary('reading'),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: _StatisticCard(
                                      icon: Icons.check_circle_rounded,
                                      value: _statisticValue(
                                        provider,
                                        provider.finishedCount,
                                      ),
                                      label: 'Selesai',
                                      backgroundColor: const Color(
                                        0xFFEAE7F3,
                                      ),
                                      iconColor: const Color(0xFF6C5B91),
                                      onTap: () => _openLibrary('finished'),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Ketuk statistik untuk melihat koleksi sesuai status.',
                                style: TextStyle(
                                  color: AppColors.muted,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: 28),
                      Row(
                        children: [
                          Container(
                            width: 5,
                            height: 25,
                            decoration: BoxDecoration(
                              color: const Color(0xFF748A9E),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            'Tentang Readify',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ],
                      ),
                      const SizedBox(height: 13),
                      const _ApplicationInfoCard(),
                      const SizedBox(height: 27),
                      const Center(
                        child: Column(
                          children: [
                            Icon(
                              Icons.auto_stories_rounded,
                              color: AppColors.leaf,
                              size: 25,
                            ),
                            SizedBox(height: 8),
                            Text(
                              'READ MORE. GROW MORE.',
                              style: TextStyle(
                                color: AppColors.leaf,
                                fontWeight: FontWeight.w800,
                                fontSize: 10,
                                letterSpacing: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
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

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(23),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          colors: [
            AppColors.forestDark,
            AppColors.forest,
            Color(0xFF789078),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.forest.withValues(alpha: 0.17),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -25,
            top: -35,
            child: Container(
              width: 130,
              height: 130,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.07),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 11,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE7B985),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Text(
                      'READIFY READER',
                      style: TextStyle(
                        color: Color(0xFF493524),
                        fontWeight: FontWeight.w900,
                        fontSize: 9,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.auto_stories_rounded,
                    color: Color(0xBFFFFFFF),
                    size: 29,
                  ),
                ],
              ),
              const SizedBox(height: 25),
              Row(
                children: [
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFFF5E9D7),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.7),
                        width: 3,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      'KM',
                      style: TextStyle(
                        color: AppColors.forest,
                        fontSize: 25,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Kadek Martini Aristianti',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.w900,
                            height: 1.3,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          'Mahasiswa Pendidikan Teknik Informatika',
                          style: TextStyle(
                            color: Color(0xFFE0E9DF),
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  const Icon(
                    Icons.school_rounded,
                    color: Color(0xFFE7B985),
                    size: 17,
                  ),
                  const SizedBox(width: 7),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.16),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Text(
                      'PTI 5 C',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 10,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _IdentityCard extends StatelessWidget {
  const _IdentityCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.line),
        boxShadow: [
          BoxShadow(
            color: AppColors.forest.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: const Column(
        children: [
          _IdentityRow(
            icon: Icons.person_rounded,
            iconColor: AppColors.forest,
            iconBackground: Color(0xFFE3EEE3),
            label: 'Nama Mahasiswa',
            value: 'Kadek Martini Aristianti',
          ),
          Divider(height: 25, color: AppColors.line),
          _IdentityRow(
            icon: Icons.badge_rounded,
            iconColor: Color(0xFFAD682F),
            iconBackground: Color(0xFFFFEBD9),
            label: 'Nomor Induk Mahasiswa',
            value: '2415051004',
          ),
          Divider(height: 25, color: AppColors.line),
          _IdentityRow(
            icon: Icons.groups_rounded,
            iconColor: Color(0xFF6C5B91),
            iconBackground: Color(0xFFEAE7F3),
            label: 'Kelas',
            value: 'PTI 5 C',
          ),
          Divider(height: 25, color: AppColors.line),
          _IdentityRow(
            icon: Icons.school_rounded,
            iconColor: Color(0xFF527B91),
            iconBackground: Color(0xFFE3EDF2),
            label: 'Program Studi',
            value: 'Pendidikan Teknik Informatika',
          ),
        ],
      ),
    );
  }
}

class _IdentityRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBackground;
  final String label;
  final String value;

  const _IdentityRow({
    required this.icon,
    required this.iconColor,
    required this.iconBackground,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 39,
          height: 39,
          decoration: BoxDecoration(
            color: iconBackground,
            borderRadius: BorderRadius.circular(13),
          ),
          child: Icon(
            icon,
            color: iconColor,
            size: 20,
          ),
        ),
        const SizedBox(width: 13),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: AppColors.muted,
                  fontSize: 11,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                value,
                style: const TextStyle(
                  color: AppColors.ink,
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ],
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
            horizontal: 7,
            vertical: 15,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(17),
            border: Border.all(
              color: iconColor.withValues(alpha: 0.12),
            ),
          ),
          child: Column(
            children: [
              Icon(icon, color: iconColor, size: 22),
              const SizedBox(height: 9),
              Text(
                value,
                style: TextStyle(
                  color: iconColor,
                  fontSize: 23,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                label,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: AppColors.ink,
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Icon(
                Icons.arrow_forward_rounded,
                size: 15,
                color: iconColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LoadError extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _LoadError({
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFE9DF),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xFFECC5B2),
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.wifi_off_rounded,
            color: Color(0xFFAC5338),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: Color(0xFF87432E),
                fontSize: 11,
              ),
            ),
          ),
          IconButton(
            onPressed: onRetry,
            icon: const Icon(
              Icons.refresh_rounded,
              color: Color(0xFFAC5338),
            ),
            tooltip: 'Coba lagi',
          ),
        ],
      ),
    );
  }
}

class _ApplicationInfoCard extends StatelessWidget {
  const _ApplicationInfoCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.line),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Temani perjalanan membacamu.',
            style: TextStyle(
              color: AppColors.forest,
              fontSize: 16,
              fontWeight: FontWeight.w900,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Readify membantu pengguna menemukan dan mengatur koleksi buku. '
            'Simpan bacaan yang ingin dijelajahi, catat buku yang sedang '
            'dibaca, dan tandai buku yang telah diselesaikan.',
            style: TextStyle(
              color: AppColors.muted,
              fontSize: 12,
              height: 1.65,
            ),
          ),
          SizedBox(height: 17),
          Divider(height: 1, color: AppColors.line),
          SizedBox(height: 17),
          _ApplicationInfoRow(
            icon: Icons.auto_stories_rounded,
            iconColor: AppColors.forest,
            label: 'Nama Aplikasi',
            value: 'Readify',
          ),
          SizedBox(height: 16),
          _ApplicationInfoRow(
            icon: Icons.menu_book_rounded,
            iconColor: Color(0xFFAD682F),
            label: 'Jenis Aplikasi',
            value: 'Personal Book Library & Reading Tracker',
          ),
          SizedBox(height: 16),
          _ApplicationInfoRow(
            icon: Icons.bookmark_rounded,
            iconColor: Color(0xFF6C5B91),
            label: 'Fungsi Aplikasi',
            value: 'Mencari dan mengelola koleksi bacaan',
          ),
        ],
      ),
    );
  }
}

class _ApplicationInfoRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;

  const _ApplicationInfoRow({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: iconColor, size: 21),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: AppColors.muted,
                  fontSize: 11,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  color: AppColors.ink,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
