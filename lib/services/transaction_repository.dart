import '../../models/feature_models.dart';

class TransactionRepository {
  List<Transaction> getRecentTransactions() {
    return [
      Transaction(id: '1', description: 'Uber Trip', amount: 150.0, date: DateTime.now().subtract(const Duration(days: 1)), category: 'Transport', merchant: 'Uber'),
      Transaction(id: '2', description: 'Starbucks Coffee', amount: 85.0, date: DateTime.now().subtract(const Duration(days: 1)), category: 'Food & Drink', merchant: 'Starbucks'),
      Transaction(id: '3', description: 'Netflix Subscription', amount: 250.0, date: DateTime.now().subtract(const Duration(days: 3)), category: 'Subscriptions', merchant: 'Netflix'),
      Transaction(id: '4', description: 'Grocery Shopping', amount: 1200.0, date: DateTime.now().subtract(const Duration(days: 4)), category: 'Groceries', merchant: 'HyperOne'),
      Transaction(id: '5', description: 'Restaurant Dinner', amount: 600.0, date: DateTime.now().subtract(const Duration(days: 5)), category: 'Food & Drink', merchant: 'Buffalo Burger'),
      Transaction(id: '6', description: 'Gas Station', amount: 400.0, date: DateTime.now().subtract(const Duration(days: 6)), category: 'Transport', merchant: 'ChillOut'),
      Transaction(id: '7', description: 'Zara Apparels', amount: 2500.0, date: DateTime.now().subtract(const Duration(days: 7)), category: 'Shopping', merchant: 'Zara'),
    ];
  }

  Map<String, double> getCategorySummary() {
    final transactions = getRecentTransactions();
    final summary = <String, double>{};
    for (var tx in transactions) {
      summary[tx.category] = (summary[tx.category] ?? 0) + tx.amount;
    }
    return summary;
  }

  List<double> getDailySpending() {
    // Last 7 days
    return [400, 600, 0, 250, 0, 235, 1200];
  }
}
