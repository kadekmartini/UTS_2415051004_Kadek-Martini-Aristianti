import '../models/book.dart';
import '../services/open_library_service.dart';

class BookRepository {
  final OpenLibraryService _service;

  BookRepository({OpenLibraryService? service})
    : _service = service ?? OpenLibraryService();

  Future<List<Book>> searchBooks({
    required String query,
    int limit = 20,
    int page = 1,
  }) {
    return _service.searchBooks(query: query, limit: limit, page: page);
  }
}
