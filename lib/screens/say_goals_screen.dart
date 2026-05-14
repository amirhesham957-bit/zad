import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../repositories/goal_repository.dart';
import '../models/goal_models.dart';
import '../components/round_up_simulator.dart';

class SayGoalsScreen extends ConsumerWidget {
  const SayGoalsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goalsAsync = ref.watch(goalsProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text('Say Goals', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          _buildSummaryCard(),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: RoundUpSimulator(),
          ),
          Expanded(
            child: goalsAsync.when(
              data: (goals) => ListView.builder(
                padding: const EdgeInsets.all(20),
                itemCount: goals.length,
                itemBuilder: (context, index) => _buildGoalCard(goals[index]),
              ),
              loading: () => Skeletonizer(
                enabled: true,
                child: ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: 3,
                  itemBuilder: (context, index) => _buildPlaceholderCard(),
                ),
              ),
              error: (e, s) => Center(child: Text('Error: $e')),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        label: const Text('هدف جديد'),
        icon: const Icon(Icons.star_rounded),
        backgroundColor: Colors.amber.shade700,
      ).animate().scale(delay: 600.ms).shake(delay: 1.seconds),
    );
  }

  Widget _buildSummaryCard() {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1E293B), Color(0xFF0F172A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        children: [
          const Text(
            'إجمالي مدخراتك للأهداف',
            style: TextStyle(color: Colors.white60, fontSize: 14),
          ),
          const SizedBox(height: 8),
          const Text(
            '218,000 ج.م',
            style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
          ).animate().shimmer(duration: 2.seconds),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem('قيد التنفيذ', '3'),
              _buildStatItem('تم الإنجاز', '12'),
              _buildStatItem('معدل الادخار', '15%'),
            ],
          ),
        ],
      ),
    ).animate().fadeIn().slideY(begin: 0.2);
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(color: Colors.white38, fontSize: 12)),
      ],
    );
  }

  Widget _buildGoalCard(FinancialGoal goal) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(goal.iconEmoji ?? '🎯', style: const TextStyle(fontSize: 24)),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      goal.title,
                      style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'متبقي ${goal.daysLeft} يوم',
                      style: const TextStyle(color: Colors.white38, fontSize: 12),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${(goal.progress * 100).toStringAsFixed(0)}%',
                    style: const TextStyle(color: Colors.amberAccent, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: goal.progress,
              minHeight: 8,
              backgroundColor: Colors.white10,
              valueColor: AlwaysStoppedAnimation<Color>(
                goal.progress > 0.8 ? Colors.greenAccent : Colors.amberAccent,
              ),
            ),
          ).animate().custom(
            duration: 1.seconds,
            builder: (context, value, child) => child,
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${goal.currentAmount.toStringAsFixed(0)} ج.م',
                style: const TextStyle(color: Colors.white70, fontSize: 14),
              ),
              Text(
                'من ${goal.targetAmount.toStringAsFixed(0)} ج.م',
                style: const TextStyle(color: Colors.white38, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(delay: 200.ms).slideX(begin: 0.1);
  }

  Widget _buildPlaceholderCard() {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      height: 150,
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}
