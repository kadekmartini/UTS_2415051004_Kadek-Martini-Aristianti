
import 'package:flutter/foundation.dart';
import '../models/reading_item.dart';

class ReadingProvider extends ChangeNotifier {
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

  void setItems(List<ReadingItem> items) {
    _items = List<ReadingItem>.from(items);
    _isLoading = false;
    _error = null;
    notifyListeners();
  }

  void addItem(ReadingItem item) {
    _items.insert(0, item);
    notifyListeners();
  }

  bool updateItem(ReadingItem updatedItem) {
    final index = _items.indexWhere(
      (item) => item.id == updatedItem.id,
    );

    if (index == -1) {
      return false;
    }

    _items[index] = updatedItem;
    notifyListeners();
    return true;
  }

  bool deleteItem(ReadingItem targetItem) {
    final initialLength = _items.length;

    _items.removeWhere(
      (item) => item.id == targetItem.id,
    );

    if (_items.length == initialLength) {
      return false;
    }

    notifyListeners();
    return true;
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
