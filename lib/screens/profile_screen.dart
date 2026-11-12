import 'package:flutter/material.dart';

import '../core/app_theme.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isWide = width >= 700;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profil Saya',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
      ),

      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: EdgeInsets.all(isWide ? 32 : 20),

            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 760),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    // PROFILE HEADER
                    _ProfileHeader(isWide: isWide),

                    const SizedBox(height: 25),

                    // STUDENT IDENTITY
                    Text(
                      'Identitas Mahasiswa',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),

                    const SizedBox(height: 12),

                    const _IdentityCard(),

                    const SizedBox(height: 25),

                    // BOOK STATISTICS
                    Text(
                      'Statistik Jumlah Buku',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),

                    const SizedBox(height: 5),

                    const Text(
                      'Ringkasan koleksi bacaan Readify.',
                      style: TextStyle(color: AppColors.muted, fontSize: 12),
                    ),

                    const SizedBox(height: 13),

                    const Row(
                      children: [
                        Expanded(
                          child: _StatisticCard(
                            icon: Icons.library_books_rounded,
                            value: '0',
                            label: 'Total Buku',
                          ),
                        ),

                        SizedBox(width: 10),

                        Expanded(
                          child: _StatisticCard(
                            icon: Icons.menu_book_rounded,
                            value: '0',
                            label: 'Sedang Dibaca',
                          ),
                        ),

                        SizedBox(width: 10),

                        Expanded(
                          child: _StatisticCard(
                            icon: Icons.check_circle_rounded,
                            value: '0',
                            label: 'Selesai',
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 25),

                    // APPLICATION INFORMATION
                    Text(
                      'Informasi Aplikasi',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),

                    const SizedBox(height: 12),

                    const _ApplicationInfoCard(),

                    const SizedBox(height: 23),

                    // FOOTER
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

                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// ======================================
// PROFILE HEADER
// ======================================

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({required this.isWide});

  final bool isWide;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(23),

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(23),

        gradient: const LinearGradient(
          colors: [AppColors.forestDark, AppColors.forest, Color(0xFF52785C)],

          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),

      child: Column(
        children: [
          Container(
            height: 86,
            width: 86,

            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.6),
                width: 4,
              ),
            ),

            alignment: Alignment.center,

            child: const Text(
              'KM',
              style: TextStyle(
                color: AppColors.forest,
                fontSize: 30,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),

          const SizedBox(height: 17),

          Text(
            'Kadek Martini Aristianti',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: isWide ? 24 : 20,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.4,
            ),
          ),

          const SizedBox(height: 7),

          const Text(
            'Mahasiswa Pendidikan Teknik Informatika',
            textAlign: TextAlign.center,
            style: TextStyle(color: Color(0xFFDCEADF), fontSize: 12),
          ),

          const SizedBox(height: 13),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 7),

            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(30),
            ),

            child: const Text(
              'PTI 5 C',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 11,
                letterSpacing: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ======================================
// STUDENT IDENTITY CARD
// ======================================

class _IdentityCard extends StatelessWidget {
  const _IdentityCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(19),
        border: Border.all(color: AppColors.line),
      ),

      child: const Column(
        children: [
          _IdentityRow(
            icon: Icons.person_outline_rounded,
            label: 'Nama Mahasiswa',
            value: 'Kadek Martini Aristianti',
          ),

          Divider(height: 24, color: AppColors.line),

          _IdentityRow(
            icon: Icons.badge_outlined,
            label: 'NIM',
            value: '2415051004',
          ),

          Divider(height: 24, color: AppColors.line),

          _IdentityRow(
            icon: Icons.groups_outlined,
            label: 'Kelas',
            value: 'PTI 5 C',
          ),

          Divider(height: 24, color: AppColors.line),

          _IdentityRow(
            icon: Icons.school_outlined,
            label: 'Program Studi',
            value: 'Pendidikan Teknik Informatika',
          ),
        ],
      ),
    );
  }
}

class _IdentityRow extends StatelessWidget {
  const _IdentityRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        Container(
          height: 38,
          width: 38,

          decoration: BoxDecoration(
            color: AppColors.mint,
            borderRadius: BorderRadius.circular(12),
          ),

          child: Icon(icon, color: AppColors.forest, size: 20),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Text(
                label,
                style: const TextStyle(color: AppColors.muted, fontSize: 11),
              ),

              const SizedBox(height: 4),

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

// ======================================
// BOOK STATISTIC CARD
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
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 15),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: AppColors.line),
      ),

      child: Column(
        children: [
          Icon(icon, color: AppColors.leaf, size: 21),

          const SizedBox(height: 8),

          Text(
            value,
            style: const TextStyle(
              color: AppColors.forest,
              fontSize: 23,
              fontWeight: FontWeight.w900,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,

            style: const TextStyle(
              color: AppColors.muted,
              fontSize: 9,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// ======================================
// APPLICATION INFORMATION
// ======================================

class _ApplicationInfoCard extends StatelessWidget {
  const _ApplicationInfoCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(19),
        border: Border.all(color: AppColors.line),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Readify merupakan aplikasi untuk membantu '
            'pengguna mencari dan mengatur koleksi buku. '
            'Pengguna dapat menyimpan buku yang ingin '
            'dibaca, mencatat buku yang sedang dibaca, '
            'serta menandai buku yang sudah selesai dibaca.',
            style: TextStyle(color: AppColors.ink, fontSize: 13, height: 1.6),
          ),

          SizedBox(height: 20),

          Divider(height: 1, color: AppColors.line),

          SizedBox(height: 17),

          _ApplicationInfoRow(
            icon: Icons.auto_stories_rounded,
            label: 'Nama Aplikasi',
            value: 'Readify',
          ),

          SizedBox(height: 17),

          _ApplicationInfoRow(
            icon: Icons.menu_book_rounded,
            label: 'Jenis Aplikasi',
            value: 'Personal Book Library & Reading Tracker',
          ),

          SizedBox(height: 17),

          _ApplicationInfoRow(
            icon: Icons.bookmark_rounded,
            label: 'Fungsi Aplikasi',
            value: 'Mencari dan mengelola koleksi bacaan',
          ),
        ],
      ),
    );
  }
}

class _ApplicationInfoRow extends StatelessWidget {
  const _ApplicationInfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: AppColors.forest, size: 20),

        const SizedBox(width: 12),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(color: AppColors.muted, fontSize: 11),
              ),

              const SizedBox(height: 4),

              Text(
                value,
                style: const TextStyle(
                  color: AppColors.ink,
                  fontSize: 13,
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
