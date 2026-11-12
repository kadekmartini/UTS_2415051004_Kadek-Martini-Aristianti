import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/reading_item.dart';

class ReadingRepository {
  final SupabaseClient? _providedClient;

  ReadingRepository({SupabaseClient? client}) : _providedClient = client;

  SupabaseClient get _client => _providedClient ?? Supabase.instance.client;

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
}
