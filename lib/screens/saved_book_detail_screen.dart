import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/app_theme.dart';
import '../models/reading_item.dart';
import '../providers/reading_provider.dart';
import 'add_edit_book_screen.dart';

class SavedBookDetailScreen extends StatefulWidget {
  final ReadingItem book;

  const SavedBookDetailScreen({super.key, required this.book});

  @override
  State<SavedBookDetailScreen> createState() => _SavedBookDetailScreenState();
}

class _SavedBookDetailScreenState extends State<SavedBookDetailScreen> {
  late ReadingItem _currentBook;

  @override
  void initState() {
    super.initState();
    _currentBook = widget.book;
  }

  Future<void> _editBook() async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute<bool>(
        builder: (context) => AddEditBookScreen(readingItem: _currentBook),
      ),
    );

    if (!mounted || result != true) return;

    // Ambil kembali data terbaru dari Supabase.
    final provider = context.read<ReadingProvider>();

    await provider.loadItems();

    if (!mounted) return;

    // Cari buku yang sudah diperbarui.
    final updatedBooks = provider.items.where(
      (item) => item.id == _currentBook.id,
    );

    if (updatedBooks.isNotEmpty) {
      setState(() {
        _currentBook = updatedBooks.first;
      });
    } else if (provider.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal memperbarui tampilan: ${provider.error}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget _buildCover() {
    final coverUrl = _currentBook.coverUrl;

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: SizedBox(
        width: 180,
        height: 260,
        child: coverUrl != null && coverUrl.isNotEmpty
            ? Image.network(
                coverUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return _coverPlaceholder();
                },
              )
            : _coverPlaceholder(),
      ),
    );
  }

  Widget _coverPlaceholder() {
    return Container(
      color: AppColors.mint,
      child: const Icon(
        Icons.menu_book_rounded,
        color: AppColors.forest,
        size: 70,
      ),
    );
  }

  Widget _buildInfo({required String label, required String value}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 145,
            child: Text(
              label,
              style: const TextStyle(color: AppColors.muted, fontSize: 13),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: AppColors.ink,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final book = _currentBook;

    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        title: const Text(
          'Detail Buku Tersimpan',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth >= 700;

            final information = Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  book.title,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  book.author,
                  style: const TextStyle(color: AppColors.muted, fontSize: 14),
                ),
                const SizedBox(height: 20),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.line),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Informasi Koleksi',
                        style: TextStyle(
                          color: AppColors.ink,
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildInfo(
                        label: 'Status membaca',
                        value: book.statusLabel,
                      ),
                      const Divider(color: AppColors.line),
                      _buildInfo(
                        label: 'Tahun terbit',
                        value: book.publishYear?.toString() ?? 'Tidak tersedia',
                      ),
                      const Divider(color: AppColors.line),
                      _buildInfo(
                        label: 'Rating',
                        value: book.rating != null
                            ? '${book.rating!.toStringAsFixed(1)} / 5'
                            : 'Belum diberi rating',
                      ),
                      const Divider(color: AppColors.line),
                      _buildInfo(
                        label: 'Catatan pribadi',
                        value: book.notes.isNotEmpty
                            ? book.notes
                            : 'Belum ada catatan',
                      ),
                    ],
                  ),
                ),
              ],
            );

            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1000),
                  child: isWide
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildCover(),
                            const SizedBox(width: 28),
                            Expanded(child: information),
                          ],
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            _buildCover(),
                            const SizedBox(height: 24),
                            information,
                          ],
                        ),
                ),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 16),
          child: SizedBox(
            height: 52,
            child: FilledButton.icon(
              onPressed: _editBook,
              icon: const Icon(Icons.edit_rounded),
              label: const Text(
                'Edit Buku',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.forest,
                foregroundColor: AppColors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
