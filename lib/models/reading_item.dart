class ReadingItem {
  const ReadingItem({
    this.id = '',
    this.userId = '',
    this.openLibraryKey,
    required this.title,
    required this.author,
    this.coverUrl,
    this.publishYear,
    this.status = 'want_to_read',
    this.rating,
    this.notes = '',
    this.createdAt,
    this.updatedAt,
  });

  final String id;

  final String userId;

  final String? openLibraryKey;

  final String title;

  final String author;

  final String? coverUrl;

  final int? publishYear;

  final String status;

  final double? rating;

  final String notes;

  final DateTime? createdAt;

  final DateTime? updatedAt;

  static const Map<String, String> statusLabels = {
    'want_to_read': 'Ingin Dibaca',
    'reading': 'Sedang Dibaca',
    'finished': 'Selesai Dibaca',
  };

  String get statusLabel {
    return statusLabels[status] ?? 'Ingin Dibaca';
  }

  factory ReadingItem.fromMap(Map<String, dynamic> map) {
    return ReadingItem(
      id: (map['id'] ?? '').toString(),

      userId: (map['user_id'] ?? '').toString(),

      openLibraryKey: map['open_library_key']?.toString(),

      title: (map['title'] ?? '').toString(),

      author: (map['author'] ?? '').toString(),

      coverUrl: map['cover_url']?.toString(),

      publishYear: _toInt(map['publish_year']),

      status: (map['status'] ?? 'want_to_read').toString(),

      rating: _toDouble(map['rating']),

      notes: (map['notes'] ?? '').toString(),

      createdAt: DateTime.tryParse(map['created_at']?.toString() ?? ''),

      updatedAt: DateTime.tryParse(map['updated_at']?.toString() ?? ''),
    );
  }

  Map<String, dynamic> toInsertMap(String ownerId) {
    return {
      'user_id': ownerId,
      'open_library_key': openLibraryKey,
      'title': title.trim(),
      'author': author.trim(),
      'cover_url': _nullableTrim(coverUrl),
      'publish_year': publishYear,
      'status': status,
      'rating': rating,
      'notes': notes.trim(),
    };
  }

  Map<String, dynamic> toUpdateMap() {
    return {
      'open_library_key': openLibraryKey,
      'title': title.trim(),
      'author': author.trim(),
      'cover_url': _nullableTrim(coverUrl),
      'publish_year': publishYear,
      'status': status,
      'rating': rating,
      'notes': notes.trim(),
      'updated_at': DateTime.now().toUtc().toIso8601String(),
    };
  }

  ReadingItem copyWith({String? status, double? rating, String? notes}) {
    return ReadingItem(
      id: id,
      userId: userId,
      openLibraryKey: openLibraryKey,
      title: title,
      author: author,
      coverUrl: coverUrl,
      publishYear: publishYear,
      status: status ?? this.status,
      rating: rating ?? this.rating,
      notes: notes ?? this.notes,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  static String? _nullableTrim(String? value) {
    final cleaned = value?.trim() ?? '';

    return cleaned.isEmpty ? null : cleaned;
  }

  static int? _toInt(dynamic value) {
    if (value is int) {
      return value;
    }

    if (value is num) {
      return value.toInt();
    }

    return int.tryParse(value?.toString() ?? '');
  }

  static double? _toDouble(dynamic value) {
    if (value is num) {
      return value.toDouble();
    }

    return double.tryParse(value?.toString() ?? '');
  }
}
