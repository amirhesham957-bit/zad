enum SplitType { equal, custom, percentage }

class Transaction {
  final String id;
  final String description;
  final double amount;
  final DateTime date;
  final String category;
  final String merchant;

  Transaction({
    required this.id,
    required this.description,
    required this.amount,
    required this.date,
    required this.category,
    required this.merchant,
  });
}

class FinancialGoal {
  final String id;
  final String name;
  final String emoji;
  final double targetAmount;
  final double currentAmount;
  final DateTime deadline;
  final String status; // active, completed, etc.

  FinancialGoal({
    required this.id,
    required this.name,
    required this.emoji,
    required this.targetAmount,
    required this.currentAmount,
    required this.deadline,
    this.status = 'active',
  });

  double get progress => currentAmount / targetAmount;
}

class SplitMember {
  final String id;
  final String name;
  final double balance;

  SplitMember({required this.id, required this.name, this.balance = 0.0});
}

class CoachInsight {
  final String title;
  final String description;
  final int score;
  final String action;

  CoachInsight({
    required this.title,
    required this.description,
    required this.score,
    required this.action,
  });
}
