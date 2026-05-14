import 'dart:math';

class SettlementTransaction {
  final String from;
  final String to;
  final double amount;

  SettlementTransaction({required this.from, required this.to, required this.amount});
}

class DebtSimplifier {
  static List<SettlementTransaction> simplify(Map<String, double> netBalances) {
    // Separate into creditors and debtors
    List<MapEntry<String, double>> debtors = [];
    List<MapEntry<String, double>> creditors = [];

    netBalances.forEach((id, balance) {
      if (balance < -0.01) {
        debtors.add(MapEntry(id, balance));
      } else if (balance > 0.01) {
        creditors.add(MapEntry(id, balance));
      }
    });

    // Sort to optimize greedy matching (largest first)
    debtors.sort((a, b) => a.value.compareTo(b.value)); // e.g. -100 before -50
    creditors.sort((a, b) => b.value.compareTo(a.value)); // e.g. 100 before 50

    List<SettlementTransaction> transactions = [];

    int dIdx = 0;
    int cIdx = 0;

    while (dIdx < debtors.length && cIdx < creditors.length) {
      var debtor = debtors[dIdx];
      var creditor = creditors[cIdx];

      double amountToPay = min(-debtor.value, creditor.value);

      transactions.add(SettlementTransaction(
        from: debtor.key,
        to: creditor.key,
        amount: amountToPay,
      ));

      // Update balances
      debtors[dIdx] = MapEntry(debtor.key, debtor.value + amountToPay);
      creditors[cIdx] = MapEntry(creditor.key, creditor.value - amountToPay);

      if (debtors[dIdx].value.abs() < 0.01) dIdx++;
      if (creditors[cIdx].value.abs() < 0.01) cIdx++;
    }

    return transactions;
  }
}
