class Book {
  const Book({
    required this.key,
    required this.title,
    required this.authors,
    this.firstPublishYear,
    this.coverId,
    this.editionCount,
    this.subjects = const [],
  });

  final String key;

  final String title;

  final List<String> authors;

  final int? firstPublishYear;

  final int? coverId;

  final int? editionCount;

  final List<String> subjects;

  String get authorLabel {
    return authors.isEmpty ? 'Penulis tidak tercantum' : authors.join(', ');
  }

  String get workKey {
    final segments = key.split('/').where((part) => part.isNotEmpty).toList();

    return segments.isEmpty ? key : segments.last;
  }

  //
  String? get coverUrl {
    if (coverId == null) {
      return null;
    }

    return 'https://covers.openlibrary.org/b/id/$coverId-L.jpg';
  }

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      key: (json['key'] ?? '').toString(),

      title: (json['title'] ?? 'Tanpa judul').toString(),

      authors: _toStringList(json['author_name']),

      firstPublishYear: _toInt(json['first_publish_year']),

      coverId: _toInt(json['cover_i']),

      editionCount: _toInt(json['edition_count']),

      subjects: _toStringList(json['subject']).take(5).toList(),
    );
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

  static List<String> _toStringList(dynamic value) {
    if (value is! List) {
      return const [];
    }

    return value
        .where((item) => item != null)
        .map((item) => item.toString())
        .toList();
  }
}
