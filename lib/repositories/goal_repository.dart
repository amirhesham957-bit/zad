import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/goal_models.dart';

class GoalRepository {
  final List<FinancialGoal> _goals = [
    FinancialGoal(
      id: '1',
      title: 'سيارة جديدة',
      targetAmount: 500000,
      currentAmount: 125000,
      category: GoalCategory.travel,
      deadline: DateTime.now().add(const Duration(days: 365)),
      iconEmoji: '🚗',
    ),
    FinancialGoal(
      id: '2',
      title: 'جهاز MacBook Pro',
      targetAmount: 85000,
      currentAmount: 45000,
      category: GoalCategory.electronics,
      deadline: DateTime.now().add(const Duration(days: 60)),
      iconEmoji: '💻',
    ),
    FinancialGoal(
      id: '3',
      title: 'صندوق الطوارئ',
      targetAmount: 50000,
      currentAmount: 48000,
      category: GoalCategory.emergency,
      deadline: DateTime.now().add(const Duration(days: 30)),
      iconEmoji: '🚨',
    ),
  ];

  Future<List<FinancialGoal>> getGoals() async {
    await Future.delayed(const Duration(milliseconds: 600));
    return _goals;
  }
}

final goalRepositoryProvider = Provider((ref) => GoalRepository());

final goalsProvider = FutureProvider((ref) {
  return ref.watch(goalRepositoryProvider).getGoals();
});
