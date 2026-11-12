import 'package:flutter/foundation.dart';

import '../models/reading_item.dart';
import '../repositories/reading_repository.dart';

class ReadingProvider extends ChangeNotifier {
  final ReadingRepository _repository;

  ReadingProvider({ReadingRepository? repository})
    : _repository = repository ?? ReadingRepository();

  List<ReadingItem> _items = [];
  bool _isLoading = false;
  String? _error;
  String _statusFilter = 'all';

  List<ReadingItem> get items => List.unmodifiable(_items);

  bool get isLoading => _isLoading;

  String? get error => _error;

  String get statusFilter => _statusFilter;

  List<ReadingItem> get filteredItems {
    if (_statusFilter == 'all') {
      return List.unmodifiable(_items);
    }

    return _items
        .where((item) => item.status == _statusFilter)
        .toList(growable: false);
  }

  int get totalBooks => _items.length;

  int get wantToReadCount =>
      _items.where((item) => item.status == 'want_to_read').length;

  int get readingCount =>
      _items.where((item) => item.status == 'reading').length;

  int get finishedCount =>
      _items.where((item) => item.status == 'finished').length;

  // READ: mengambil koleksi buku dari Supabase.
  Future<void> loadItems() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _items = await _repository.getItems();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // CREATE: menyimpan buku baru ke Supabase.
  Future<ReadingItem> createItem({
    required String openLibraryKey,
    required String title,
    required String author,
    String? coverUrl,
    int? publishYear,
    String status = 'want_to_read',
    double? rating,
    String notes = '',
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final newItem = await _repository.createItem(
        openLibraryKey: openLibraryKey,
        title: title,
        author: author,
        coverUrl: coverUrl,
        publishYear: publishYear,
        status: status,
        rating: rating,
        notes: notes,
      );

      _items.insert(0, newItem);
      _statusFilter = 'all';

      return newItem;
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // UPDATE: mengubah buku yang sudah tersimpan di Supabase.
  Future<ReadingItem> updateItem(ReadingItem item) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final updatedItem = await _repository.updateItem(item);

      final index = _items.indexWhere(
        (existingItem) => existingItem.id == updatedItem.id,
      );

      if (index != -1) {
        _items[index] = updatedItem;
      } else {
        _items.insert(0, updatedItem);
      }

      return updatedItem;
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setItems(List<ReadingItem> items) {
    _items = List<ReadingItem>.from(items);
    _error = null;
    notifyListeners();
  }

  void setStatusFilter(String status) {
    _statusFilter = status;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  void clearItems() {
    _items = [];
    _error = null;
    _isLoading = false;
    notifyListeners();
  }
}
