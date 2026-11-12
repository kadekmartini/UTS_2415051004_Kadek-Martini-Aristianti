
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/reading_item.dart';

class ReadingRepository {
  final SupabaseClient? _providedClient;

  ReadingRepository({SupabaseClient? client})
      : _providedClient = client;

  SupabaseClient get _client =>
      _providedClient ?? Supabase.instance.client;

  Future<List<ReadingItem>> getItems() async {
    final user = _client.auth.currentUser;

    if (user == null) {
      throw StateError('Pengguna belum login. Silakan masuk kembali.');
    }

    final response = await _client
        .from('reading_items')
        .select()
        .eq('user_id', user.id)
        .order('created_at', ascending: false);

    return response
        .map((item) => ReadingItem.fromMap(Map<String, dynamic>.from(item)))
        .toList();
  }

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
    final user = _client.auth.currentUser;

    if (user == null) {
      throw StateError('Pengguna belum login. Silakan masuk kembali.');
    }

    final response = await _client
        .from('reading_items')
        .insert({
          'user_id': user.id,
          'open_library_key': openLibraryKey,
          'title': title,
          'author': author,
          'cover_url': coverUrl,
          'publish_year': publishYear,
          'status': status,
          'rating': rating,
          'notes': notes,
        })
        .select()
        .single();

    return ReadingItem.fromMap(Map<String, dynamic>.from(response));
  }

  Future<ReadingItem> updateItem(ReadingItem item) async {
    final user = _client.auth.currentUser;

    if (user == null) {
      throw StateError('Pengguna belum login. Silakan masuk kembali.');
    }

    final response = await _client
        .from('reading_items')
        .update({
          'open_library_key': item.openLibraryKey,
          'title': item.title,
          'author': item.author,
          'cover_url': item.coverUrl,
          'publish_year': item.publishYear,
          'status': item.status,
          'rating': item.rating,
          'notes': item.notes,
        })
        .eq('id', item.id)
        .eq('user_id', user.id)
        .select()
        .single();

    return ReadingItem.fromMap(Map<String, dynamic>.from(response));
  }

  Future<void> deleteItem(String id) async {
    final user = _client.auth.currentUser;

    if (user == null) {
      throw StateError('Pengguna belum login. Silakan masuk kembali.');
    }

    await _client
        .from('reading_items')
        .delete()
        .eq('id', id)
        .eq('user_id', user.id);
  }
}
