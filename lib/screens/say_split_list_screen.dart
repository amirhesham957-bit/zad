import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../repositories/split_repository.dart';
import '../models/split_models.dart';

class SaySplitListScreen extends ConsumerWidget {
  const SaySplitListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groupsAsync = ref.watch(splitGroupsProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text('Say Split', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          Expanded(
            child: groupsAsync.when(
              data: (groups) => ListView.builder(
                padding: const EdgeInsets.all(20),
                itemCount: groups.length,
                itemBuilder: (context, index) => _buildGroupCard(context, groups[index]),
              ),
              loading: () => Skeletonizer(
                enabled: true,
                child: ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: 3,
                  itemBuilder: (context, index) => _buildGroupCardPlaceholder(),
                ),
              ),
              error: (e, s) => Center(child: Text('Error: $e')),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        label: const Text('مجموعة جديدة'),
        icon: const Icon(Icons.group_add),
        backgroundColor: Colors.indigoAccent,
      ).animate().scale(delay: 500.ms),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.indigo.shade900, Colors.indigo.shade700],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.indigo.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.account_balance_wallet, color: Colors.white, size: 32),
          ),
          const SizedBox(width: 16),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'صافي التزاماتك',
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
              Text(
                '350.00 ج.م',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn().slideY(begin: 0.1);
  }

  Widget _buildGroupCard(BuildContext context, SplitGroup group) {
    return GestureDetector(
      onTap: () => context.push('/split/group/${group.id}'),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF1E293B),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white10),
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.indigo.withValues(alpha: 0.2),
              child: Text(group.name[0], style: const TextStyle(color: Colors.indigoAccent)),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    group.name,
                    style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '${group.members.length} أعضاء • ${group.expenses.length} مصروفات',
                    style: const TextStyle(color: Colors.white60, fontSize: 12),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.white24),
          ],
        ),
      ),
    ).animate().fadeIn(delay: 100.ms).slideX(begin: 0.05);
  }

  Widget _buildGroupCardPlaceholder() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      height: 80,
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}
