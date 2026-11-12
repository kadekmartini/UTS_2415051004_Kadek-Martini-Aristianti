import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/book.dart';

class OpenLibraryService {
  final http.Client _client;

  OpenLibraryService({http.Client? client}) : _client = client ?? http.Client();

  Future<List<Book>> searchBooks({
    required String query,
    int limit = 20,
    int page = 1,
  }) async {
    final keyword = query.trim();

    if (keyword.isEmpty) {
      return [];
    }

    final uri = Uri.https('openlibrary.org', '/search.json', {
      'q': keyword,
      'fields': 'key,title,author_name,first_publish_year,cover_i,edition_count,subject',
      'limit': limit.toString(),
      'page': page.toString(),
    });

    try {
      final response = await _client
          .get(uri, headers: {'Accept': 'application/json'})
          .timeout(const Duration(seconds: 15));

      if (response.statusCode != 200) {
        throw OpenLibraryException(
          'Gagal mengambil data buku. '
          'Kode server: ${response.statusCode}',
        );
      }

      final decoded = jsonDecode(response.body);

      if (decoded is! Map<String, dynamic>) {
        throw const OpenLibraryException('Format respons API tidak valid.');
      }

      final docs = decoded['docs'];

      if (docs is! List) {
        throw const OpenLibraryException(
          'Data buku tidak ditemukan dalam respons API.',
        );
      }

      return docs
          .whereType<Map<String, dynamic>>()
          .map((json) => Book.fromJson(json))
          .toList(growable: false);
    } on TimeoutException {
      throw const OpenLibraryException(
        'Koneksi terlalu lama. Silakan coba lagi.',
      );
    } on http.ClientException {
      throw const OpenLibraryException(
        'Tidak dapat terhubung ke Open Library.',
      );
    } on FormatException {
      throw const OpenLibraryException('Gagal membaca format data dari API.');
    }
  }
}

class OpenLibraryException implements Exception {
  final String message;

  const OpenLibraryException(this.message);

  @override
  String toString() => message;
}
