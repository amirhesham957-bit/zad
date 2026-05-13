class Budget {
  final String id;
  final double totalBudget;
  final double spent;

  Budget({
    required this.id,
    required this.totalBudget,
    this.spent = 0.0,
  });

  double get remaining => totalBudget - spent;
  
  double get spentPercentage => totalBudget > 0 ? (spent / totalBudget).clamp(0.0, 1.0) : 0.0;
}
