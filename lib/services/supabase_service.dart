import 'package:supabase_flutter/supabase_flutter.dart';


class SupabaseService {
  final SupabaseClient _client = Supabase.instance.client;

  // --- Transactions (Say Coach) ---
  Future<void> addTransaction(double amount, String category, String desc) async {
    await _client.from('transactions').insert({
      'amount': amount,
      'category': category,
      'description': desc,
      'user_id': _client.auth.currentUser?.id,
    });
  }

  Stream<List<Map<String, dynamic>>> getTransactionStream() {
    return _client
        .from('transactions')
        .stream(primaryKey: ['id'])
        .order('created_at');
  }

  // --- Goals (Say Goals) ---
  Future<void> updateGoalProgress(String goalId, double newAmount) async {
    await _client
        .from('goals')
        .update({'current_amount': newAmount})
        .eq('id', goalId);
  }

  // --- Auth ---
  Future<void> signOut() async => await _client.auth.signOut();
}
