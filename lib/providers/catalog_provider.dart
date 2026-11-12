
import 'package:flutter/foundation.dart';
import '../models/book.dart';

class CatalogProvider extends ChangeNotifier {
  List<Book> _books = [];
  bool _isLoading = false;
  String? _error;
  String _searchQuery = '';

  List<Book> get books => List.unmodifiable(_books);

  bool get isLoading => _isLoading;

  String? get error => _error;

  String get searchQuery => _searchQuery;

  List<Book> get filteredBooks {
    final query = _searchQuery.trim().toLowerCase();

    if (query.isEmpty) {
      return List.unmodifiable(_books);
    }

    return _books.where((book) {
      return book.title.toLowerCase().contains(query) ||
          book.authorLabel.toLowerCase().contains(query);
    }).toList(growable: false);
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
    notifyListeners();
  }
}
