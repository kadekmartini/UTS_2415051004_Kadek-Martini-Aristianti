
import 'package:flutter/material.dart';

import '../core/app_theme.dart';

class BookCover extends StatelessWidget {
  final String? coverUrl;
  final double width;
  final double height;
  final double iconSize;
  final double borderRadius;

  const BookCover({
    super.key,
    required this.coverUrl,
    this.width = 120,
    this.height = 160,
    this.iconSize = 48,
    this.borderRadius = 12,
  });

  Widget _buildPlaceholder() {
    return Container(
      width: width,
      height: height,
      color: AppColors.mint,
      child: Icon(
        Icons.menu_book_rounded,
        color: AppColors.forest,
        size: iconSize,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasCover = coverUrl != null && coverUrl!.trim().isNotEmpty;

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: SizedBox(
        width: width,
        height: height,
        child: hasCover
            ? Image.network(
                coverUrl!,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, progress) {
                  if (progress == null) return child;
                  return _buildPlaceholder();
                },
                errorBuilder: (context, error, stackTrace) {
                  return _buildPlaceholder();
                },
              )
            : _buildPlaceholder(),
      ),
    );
  }
}
