class SplitGroup {
  final String id;
  final String name;
  final List<SplitMember> members;
  final List<SplitExpense> expenses;
  final DateTime createdAt;

  SplitGroup({
    required this.id,
    required this.name,
    required this.members,
    required this.expenses,
    required this.createdAt,
  });
}

class SplitMember {
  final String id;
  final String name;
  final String? phone;
  final double netBalance;

  SplitMember({
    required this.id,
    required this.name,
    this.phone,
    this.netBalance = 0.0,
  });
}

class SplitExpense {
  final String id;
  final String description;
  final double amount;
  final String paidBy; // Member ID
  final Map<String, double> splits; // Member ID -> Amount
  final DateTime date;

  SplitExpense({
    required this.id,
    required this.description,
    required this.amount,
    required this.paidBy,
    required this.splits,
    required this.date,
  });
}
