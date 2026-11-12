
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/app_theme.dart';
import '../models/reading_item.dart';
import '../providers/reading_provider.dart';
import '../widgets/book_cover.dart';
import 'add_edit_book_screen.dart';

class SavedBookDetailScreen extends StatefulWidget {
  final ReadingItem book;

  const SavedBookDetailScreen({
    super.key,
    required this.book,
  });

  @override
  State<SavedBookDetailScreen> createState() =>
      _SavedBookDetailScreenState();
}

class _SavedBookDetailScreenState
    extends State<SavedBookDetailScreen> {
  late ReadingItem _currentBook;
  bool _isDeleting = false;

  @override
  void initState() {
    super.initState();
    _currentBook = widget.book;
  }


  Future<void> _editBook() async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute<bool>(
        builder: (context) =>
            AddEditBookScreen(readingItem: _currentBook),
      ),
    );

    if (!mounted || result != true) return;

    final provider = context.read<ReadingProvider>();

    await provider.loadItems();

    if (!mounted) return;

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
          content: Text(
            'Gagal memperbarui tampilan: ${provider.error}',
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }


  Future<void> _deleteBook() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text(
            'Hapus Buku?',
            style: TextStyle(fontWeight: FontWeight.w800),
          ),
          content: Text(
            'Apakah kamu yakin ingin menghapus '
            '"${_currentBook.title}" dari Rak Saya? '
            'Data buku yang dihapus tidak dapat dikembalikan.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text('Batal'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              style: FilledButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );

    if (!mounted || confirmed != true) return;

    setState(() {
      _isDeleting = true;
    });

    final provider = context.read<ReadingProvider>();
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    try {
      await provider.deleteItem(_currentBook.id);

      if (!mounted) return;

      setState(() {
        _isDeleting = false;
      });

      navigator.pop();

      messenger.showSnackBar(
        const SnackBar(
          content: Text('Buku berhasil dihapus dari Rak Saya.'),
          backgroundColor: AppColors.forest,
        ),
      );
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isDeleting = false;
      });

      messenger.showSnackBar(
        SnackBar(
          content: Text('Gagal menghapus buku: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget _buildInfo({
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 145,
            child: Text(
              label,
              style: const TextStyle(
                color: AppColors.muted,
                fontSize: 13,
              ),
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
                  style: const TextStyle(
                    color: AppColors.muted,
                    fontSize: 14,
                  ),
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
                        value: book.publishYear?.toString() ??
                            'Tidak tersedia',
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
                            BookCover(
                              coverUrl: book.coverUrl,
                              width: 180,
                              height: 260,
                              iconSize: 70,
                              borderRadius: 16,
                            ),
                            const SizedBox(width: 28),
                            Expanded(child: information),
                          ],
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            BookCover(
                              coverUrl: book.coverUrl,
                              width: 180,
                              height: 260,
                              iconSize: 70,
                              borderRadius: 16,
                            ),
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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: double.infinity,
                height: 52,
                child: FilledButton.icon(
                  onPressed: _isDeleting ? null : _editBook,
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
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton.icon(
                  onPressed: _isDeleting ? null : _deleteBook,
                  icon: _isDeleting
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        )
                      : const Icon(Icons.delete_outline_rounded),
                  label: Text(
                    _isDeleting ? 'Menghapus...' : 'Hapus Buku',
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: const BorderSide(color: Colors.red),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
