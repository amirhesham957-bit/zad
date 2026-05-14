import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../models/split_models.dart';
import '../repositories/split_repository.dart';
import '../utils/debt_simplifier.dart';

class SaySplitGroupScreen extends ConsumerWidget {
  final String groupId;

  const SaySplitGroupScreen({super.key, required this.groupId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groupAsync = ref.watch(splitGroupsProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: groupAsync.when(
        data: (groups) {
          final group = groups.firstWhere((g) => g.id == groupId);
          final settlements = _calculateSettlements(group);

          return CustomScrollView(
            slivers: [
              _buildSliverAppBar(group),
              SliverToBoxAdapter(child: _buildSettlementSection(settlements, group)),
              SliverPadding(
                padding: const EdgeInsets.all(20),
                sliver: SliverToBoxAdapter(
                  child: const Text(
                    'المصروفات',
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => _buildExpenseTile(group.expenses[index], group),
                  childCount: group.expenses.length,
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(child: Text('Error: $e')),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/split/group/$groupId/add'),
        label: const Text('إضافة مصروف'),
        icon: const Icon(Icons.add_shopping_cart),
        backgroundColor: Colors.indigoAccent,
      ),
    );
  }

  Widget _buildSliverAppBar(SplitGroup group) {
    return SliverAppBar(
      expandedHeight: 120,
      pinned: true,
      backgroundColor: const Color(0xFF0F172A),
      flexibleSpace: FlexibleSpaceBar(
        title: Text(group.name, style: const TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: false,
      ),
    );
  }

  List<SettlementTransaction> _calculateSettlements(SplitGroup group) {
    Map<String, double> balances = {};
    for (var m in group.members) {
      balances[m.id] = 0.0;
    }

    for (var exp in group.expenses) {
      // Paid by
      balances[exp.paidBy] = (balances[exp.paidBy] ?? 0) + exp.amount;
      // Splits
      exp.splits.forEach((memberId, amount) {
        balances[memberId] = (balances[memberId] ?? 0) - amount;
      });
    }

    return DebtSimplifier.simplify(balances);
  }

  Widget _buildSettlementSection(List<SettlementTransaction> settlements, SplitGroup group) {
    if (settlements.isEmpty) return const SizedBox();

    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.indigo.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.indigo.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.auto_awesome, color: Colors.indigoAccent, size: 20),
              SizedBox(width: 8),
              Text(
                'خطة التسوية الذكية',
                style: TextStyle(color: Colors.indigoAccent, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...settlements.map((s) => _buildSettlementRow(s, group)),
        ],
      ),
    ).animate().fadeIn().slideY(begin: 0.1);
  }

  Widget _buildSettlementRow(SettlementTransaction s, SplitGroup group) {
    final fromName = group.members.firstWhere((m) => m.id == s.from).name;
    final toName = group.members.firstWhere((m) => m.id == s.to).name;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(fromName, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
          const Icon(Icons.arrow_forward, color: Colors.white24, size: 16),
          Text(toName, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
          const Spacer(),
          Text(
            '${s.amount.toStringAsFixed(0)} ج.م',
            style: const TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildExpenseTile(SplitExpense expense, SplitGroup group) {
    final paidByName = group.members.firstWhere((m) => m.id == expense.paidBy).name;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.receipt_long, color: Colors.white60),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(expense.description, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                Text('دفعها $paidByName', style: const TextStyle(color: Colors.white54, fontSize: 12)),
              ],
            ),
          ),
          Text(
            '${expense.amount.toStringAsFixed(0)} ج.م',
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
