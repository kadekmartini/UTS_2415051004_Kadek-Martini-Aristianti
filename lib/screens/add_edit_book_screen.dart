
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../core/app_theme.dart';
import '../models/book.dart';
import '../models/reading_item.dart';
import '../providers/reading_provider.dart';
import '../widgets/book_cover.dart';

class AddEditBookScreen extends StatefulWidget {
  final Book? book;
  final ReadingItem? readingItem;

  const AddEditBookScreen({super.key, this.book, this.readingItem})
      : assert((book == null) != (readingItem == null));

  @override
  State<AddEditBookScreen> createState() => _AddEditBookScreenState();
}

class _AddEditBookScreenState extends State<AddEditBookScreen> {
  final _formKey = GlobalKey<FormState>();
  final _notesController = TextEditingController();

  late String _status;
  double? _rating;
  bool _isSaving = false;

  bool get _isEditing => widget.readingItem != null;

  String get _title => widget.book?.title ?? widget.readingItem!.title;

  String get _author => widget.book?.authorLabel ?? widget.readingItem!.author;

  String? get _coverUrl =>
      widget.book?.coverUrl ?? widget.readingItem!.coverUrl;

  int? get _publishYear =>
      widget.book?.firstPublishYear ?? widget.readingItem!.publishYear;

  @override
  void initState() {
    super.initState();

    final item = widget.readingItem;

    _status = item?.status ?? 'want_to_read';
    _rating = item?.rating;
    _notesController.text = item?.notes ?? '';
  }

  Future<void> _saveBook() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      final provider = context.read<ReadingProvider>();

      if (_isEditing) {
        final existingItem = widget.readingItem!;

        final updatedItem = ReadingItem(
          id: existingItem.id,
          userId: existingItem.userId,
          openLibraryKey: existingItem.openLibraryKey,
          title: existingItem.title,
          author: existingItem.author,
          coverUrl: existingItem.coverUrl,
          publishYear: existingItem.publishYear,
          status: _status,
          rating: _rating,
          notes: _notesController.text.trim(),
          createdAt: existingItem.createdAt,
          updatedAt: existingItem.updatedAt,
        );

        await provider.updateItem(updatedItem);
      } else {
        final selectedBook = widget.book!;

        await provider.createItem(
          openLibraryKey: selectedBook.workKey,
          title: selectedBook.title,
          author: selectedBook.authorLabel,
          coverUrl: selectedBook.coverUrl,
          publishYear: selectedBook.firstPublishYear,
          status: _status,
          rating: _rating,
          notes: _notesController.text.trim(),
        );
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isEditing
                ? 'Buku berhasil diperbarui!'
                : 'Buku berhasil ditambahkan ke Rak Saya!',
          ),
          backgroundColor: AppColors.forest,
        ),
      );

      Navigator.pop(context, true);
    } on PostgrestException catch (e) {
      if (!mounted) return;

      final message = e.code == '23505'
          ? 'Buku ini sudah ada di Rak Saya.'
          : 'Gagal menyimpan buku: ${e.message}';

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: AppColors.orange,
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isEditing
                ? 'Gagal memperbarui buku: $e'
                : 'Gagal menyimpan buku: $e',
          ),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        title: Text(
          _isEditing ? 'Edit Buku' : 'Tambah ke Rak Saya',
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 650),
            child: Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  // Book information
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: AppColors.line),
                    ),
                    child: Row(
                      children: [
                        BookCover(
                          coverUrl: _coverUrl,
                          width: 85,
                          height: 115,
                          iconSize: 35,
                          borderRadius: 12,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _title,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: AppColors.ink,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                _author,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: AppColors.muted,
                                  fontSize: 12,
                                ),
                              ),
                              if (_publishYear != null) ...[
                                const SizedBox(height: 6),
                                Text(
                                  'Terbit $_publishYear',
                                  style: const TextStyle(
                                    color: AppColors.muted,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 26),

                  Text(
                    _isEditing
                        ? 'Perbarui Informasi Buku'
                        : 'Atur Koleksi Buku',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),

                  const SizedBox(height: 18),

                  // Reading status
                  const Text(
                    'Status Membaca',
                    style: TextStyle(
                      color: AppColors.ink,
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),

                  const SizedBox(height: 8),

                  DropdownButtonFormField<String>(
                    initialValue: _status,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: AppColors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'want_to_read',
                        child: Text('Ingin Dibaca'),
                      ),
                      DropdownMenuItem(
                        value: 'reading',
                        child: Text('Sedang Dibaca'),
                      ),
                      DropdownMenuItem(
                        value: 'finished',
                        child: Text('Selesai Dibaca'),
                      ),
                    ],
                    onChanged: _isSaving
                        ? null
                        : (value) {
                            if (value != null) {
                              setState(() {
                                _status = value;
                              });
                            }
                          },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Pilih status membaca.';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 20),

                  // Rating
                  const Text(
                    'Rating Buku (Opsional)',
                    style: TextStyle(
                      color: AppColors.ink,
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),

                  const SizedBox(height: 8),

                  DropdownButtonFormField<double?>(
                    initialValue: _rating,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: AppColors.white,
                      hintText: 'Pilih rating buku',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    items: const [
                      DropdownMenuItem<double?>(
                        value: null,
                        child: Text('Belum diberi rating'),
                      ),
                      DropdownMenuItem<double?>(
                        value: 1.0,
                        child: Text('★ 1 - Kurang'),
                      ),
                      DropdownMenuItem<double?>(
                        value: 2.0,
                        child: Text('★★ 2 - Cukup'),
                      ),
                      DropdownMenuItem<double?>(
                        value: 3.0,
                        child: Text('★★★ 3 - Baik'),
                      ),
                      DropdownMenuItem<double?>(
                        value: 4.0,
                        child: Text('★★★★ 4 - Sangat Baik'),
                      ),
                      DropdownMenuItem<double?>(
                        value: 5.0,
                        child: Text('★★★★★ 5 - Favorit'),
                      ),
                    ],
                    onChanged: _isSaving
                        ? null
                        : (value) {
                            setState(() {
                              _rating = value;
                            });
                          },
                  ),

                  const SizedBox(height: 20),

                  // Personal notes
                  const Text(
                    'Catatan Pribadi (Opsional)',
                    style: TextStyle(
                      color: AppColors.ink,
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),

                  const SizedBox(height: 8),

                  TextFormField(
                    controller: _notesController,
                    enabled: !_isSaving,
                    maxLines: 4,
                    maxLength: 500,
                    decoration: InputDecoration(
                      hintText: 'Tambahkan catatan tentang buku ini...',
                      filled: true,
                      fillColor: AppColors.white,
                      alignLabelWithHint: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    validator: (value) {
                      if (value != null && value.length > 500) {
                        return 'Catatan maksimal 500 karakter.';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 24),

                  // Save button
                  SizedBox(
                    height: 52,
                    child: FilledButton.icon(
                      onPressed: _isSaving ? null : _saveBook,
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.forest,
                        foregroundColor: AppColors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      icon: _isSaving
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColors.white,
                              ),
                            )
                          : Icon(
                              _isEditing
                                  ? Icons.save_rounded
                                  : Icons.bookmark_add_rounded,
                            ),
                      label: Text(
                        _isSaving
                            ? 'Menyimpan...'
                            : _isEditing
                                ? 'Simpan Perubahan'
                                : 'Simpan ke Rak Saya',
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  Text(
                    _isEditing
                        ? 'Perubahan akan diperbarui pada koleksi pribadi Readify.'
                        : 'Buku akan disimpan ke koleksi pribadi Readify.',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: AppColors.muted,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
