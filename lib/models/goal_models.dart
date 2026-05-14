enum GoalCategory { travel, electronics, savings, emergency, other }

class FinancialGoal {
  final String id;
  final String title;
  final double targetAmount;
  final double currentAmount;
  final GoalCategory category;
  final DateTime deadline;
  final String? iconEmoji;

  FinancialGoal({
    required this.id,
    required this.title,
    required this.targetAmount,
    required this.currentAmount,
    required this.category,
    required this.deadline,
    this.iconEmoji,
  });

  double get progress => currentAmount / targetAmount;
  int get daysLeft => deadline.difference(DateTime.now()).inDays;
}
