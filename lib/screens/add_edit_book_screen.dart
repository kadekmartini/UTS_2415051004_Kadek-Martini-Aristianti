import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../core/app_theme.dart';
import '../models/book.dart';
import '../providers/reading_provider.dart';

class AddEditBookScreen extends StatefulWidget {
  final Book book;

  const AddEditBookScreen({super.key, required this.book});

  @override
  State<AddEditBookScreen> createState() => _AddEditBookScreenState();
}

class _AddEditBookScreenState extends State<AddEditBookScreen> {
  final _formKey = GlobalKey<FormState>();
  final _notesController = TextEditingController();

  String _status = 'want_to_read';
  double? _rating;
  bool _isSaving = false;

  Future<void> _saveBook() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      await context.read<ReadingProvider>().createItem(
        openLibraryKey: widget.book.workKey,
        title: widget.book.title,
        author: widget.book.authorLabel,
        coverUrl: widget.book.coverUrl,
        publishYear: widget.book.firstPublishYear,
        status: _status,
        rating: _rating,
        notes: _notesController.text.trim(),
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Buku berhasil ditambahkan ke Rak Saya!'),
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
          backgroundColor: e.code == '23505' ? AppColors.orange : Colors.red,
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal menyimpan buku: $e'),
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

  Widget _buildBookCover() {
    final coverUrl = widget.book.coverUrl;

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        width: 85,
        height: 115,
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
        size: 35,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        title: const Text(
          'Tambah ke Rak Saya',
          style: TextStyle(fontWeight: FontWeight.w800),
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
                  // Selected book information
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: AppColors.line),
                    ),
                    child: Row(
                      children: [
                        _buildBookCover(),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.book.title,
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
                                widget.book.authorLabel,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: AppColors.muted,
                                  fontSize: 12,
                                ),
                              ),
                              if (widget.book.firstPublishYear != null) ...[
                                const SizedBox(height: 6),
                                Text(
                                  'Terbit ${widget.book.firstPublishYear}',
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
                    'Atur Koleksi Buku',
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

                  // Book rating
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
                          : const Icon(Icons.bookmark_add_rounded),
                      label: Text(
                        _isSaving ? 'Menyimpan Buku...' : 'Simpan ke Rak Saya',
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  const Text(
                    'Buku akan disimpan ke koleksi pribadi Readify.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppColors.muted, fontSize: 11),
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
