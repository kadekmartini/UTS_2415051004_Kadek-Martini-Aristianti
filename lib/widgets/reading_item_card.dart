
import 'package:flutter/material.dart';

import '../core/app_theme.dart';
import '../models/reading_item.dart';
import 'book_cover.dart';

class ReadingItemCard extends StatelessWidget {
  final ReadingItem book;
  final VoidCallback onTap;

  const ReadingItemCard({
    super.key,
    required this.book,
    required this.onTap,
  });

  Color _statusColor() {
    if (book.status == 'reading') {
      return AppColors.orange;
    }

    if (book.status == 'finished') {
      return AppColors.leaf;
    }

    return AppColors.forest;
  }

  @override
  Widget build(BuildContext context) {
    final rating = book.rating;

    return Card(
      margin: EdgeInsets.zero,
      color: AppColors.white,
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.line),
      ),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              BookCover(
                coverUrl: book.coverUrl,
                width: 68,
                height: 96,
                iconSize: 30,
                borderRadius: 10,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      book.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.ink,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      book.author.isNotEmpty
                          ? book.author
                          : 'Penulis tidak diketahui',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.muted,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 7),
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        _StatusLabel(
                          label: book.statusLabel,
                          color: _statusColor(),
                        ),
                        if (book.publishYear != null)
                          Text(
                            book.publishYear.toString(),
                            style: const TextStyle(
                              color: AppColors.muted,
                              fontSize: 11,
                            ),
                          ),
                      ],
                    ),
                    if (rating != null && rating > 0) ...[
                      const SizedBox(height: 5),
                      Text(
                        '★ ${rating.toStringAsFixed(1)} / 5',
                        style: const TextStyle(
                          color: AppColors.orange,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                    if (book.notes.isNotEmpty) ...[
                      const SizedBox(height: 5),
                      Text(
                        book.notes,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppColors.muted,
                          fontSize: 11,
                        ),
                      ),
                    ],
                    const SizedBox(height: 5),
                    const Text(
                      'Lihat detail →',
                      style: TextStyle(
                        color: AppColors.forest,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusLabel extends StatelessWidget {
  final String label;
  final Color color;

  const _StatusLabel({
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 9,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
