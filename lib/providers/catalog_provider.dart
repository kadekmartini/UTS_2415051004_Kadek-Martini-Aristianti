import 'package:flutter/foundation.dart';

import '../models/book.dart';
import '../repositories/book_repository.dart';

class CatalogProvider extends ChangeNotifier {
  final BookRepository _repository;

  CatalogProvider({BookRepository? repository})
    : _repository = repository ?? BookRepository();

  // Data pencarian Jelajah
  List<Book> _books = [];
  bool _isLoading = false;
  String? _error;
  String _searchQuery = '';

  // Data rekomendasi Beranda
  List<Book> _recommendations = [];
  bool _isLoadingRecommendations = false;
  String? _recommendationError;
  bool _recommendationsLoaded = false;

  List<Book> get books => List.unmodifiable(_books);

  bool get isLoading => _isLoading;

  String? get error => _error;

  String get searchQuery => _searchQuery;

  List<Book> get recommendations => List.unmodifiable(_recommendations);

  bool get isLoadingRecommendations => _isLoadingRecommendations;

  String? get recommendationError => _recommendationError;

  List<Book> get filteredBooks {
    final query = _searchQuery.trim().toLowerCase();

    if (query.isEmpty) {
      return List.unmodifiable(_books);
    }

    return _books
        .where((book) {
          return book.title.toLowerCase().contains(query) ||
              book.authorLabel.toLowerCase().contains(query);
        })
        .toList(growable: false);
  }

  // Mengambil buku khusus untuk rekomendasi Beranda.
  Future<void> loadRecommendations({bool forceRefresh = false}) async {
    if (_isLoadingRecommendations) return;

    if (_recommendationsLoaded && !forceRefresh) return;

    _isLoadingRecommendations = true;
    _recommendationError = null;
    notifyListeners();

    try {
      final results = await _repository.searchBooks(
        query: 'fiction',
        limit: 40,
      );

      // Hanya tampilkan buku yang memiliki URL sampul.
      _recommendations = results
          .where((book) {
            final cover = book.coverUrl;
            return cover != null && cover.isNotEmpty;
          })
          .toList(growable: false);

      _recommendationsLoaded = true;
    } catch (e) {
      _recommendationError = e.toString();
    } finally {
      _isLoadingRecommendations = false;
      notifyListeners();
    }
  }

  // Pencarian buku melalui Open Library.
  Future<void> searchBooks({
    required String query,
    int limit = 20,
    int page = 1,
  }) async {
    final keyword = query.trim();

    _searchQuery = keyword;

    if (keyword.isEmpty) {
      _books = [];
      _error = null;
      _isLoading = false;
      notifyListeners();
      return;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _books = await _repository.searchBooks(
        query: keyword,
        limit: limit,
        page: page,
      );
    } catch (e) {
      _books = [];
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setBooks(List<Book> books) {
    _books = List<Book>.from(books);
    _isLoading = false;
    _error = null;
    notifyListeners();
  }

  void setLoading(bool value) {
    _isLoading = value;

    if (value) {
      _error = null;
    }

    notifyListeners();
  }

  void setError(String? message) {
    _error = message;
    _isLoading = false;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  void clearBooks() {
    _books = [];
    _error = null;
    _isLoading = false;
    _searchQuery = '';
    notifyListeners();
  }
}
