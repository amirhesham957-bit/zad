import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../../providers/ai_provider.dart';
import '../../services/transaction_repository.dart';

final transactionRepoProvider = Provider((ref) => TransactionRepository());

class SayCoachScreen extends ConsumerStatefulWidget {
  const SayCoachScreen({super.key});

  @override
  ConsumerState<SayCoachScreen> createState() => _SayCoachScreenState();
}

class _SayCoachScreenState extends ConsumerState<SayCoachScreen> {
  @override
  void initState() {
    super.initState();
    // Trigger initial AI insight generation
    Future.microtask(() => _generateInsight());
  }

  void _generateInsight() {
    final repo = ref.read(transactionRepoProvider);
    final summary = repo.getCategorySummary();
    final context = "Transactions: $summary. Total Spent: ${summary.values.fold(0.0, (a, b) => a + b)}";
    ref.read(coachChatProvider.notifier).sendMessage("Analyze this data and give me a weekly insight: $context");
  }

  @override
  Widget build(BuildContext context) {
    final chatState = ref.watch(coachChatProvider);
    final repo = ref.read(transactionRepoProvider);
    final bool isFirstLoad = chatState.isLoading && chatState.messages.isEmpty;

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('زاد كوتش / Zad Coach', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Skeletonizer(
        enabled: isFirstLoad,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildPersonalityScore(85), // Mock score
              const SizedBox(height: 24),
              _buildInsightCard(chatState),
              const SizedBox(height: 24),
              const Text('النمط الأسبوعي / Weekly Pattern', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              _buildSpendingChart(repo.getDailySpending()),
              const SizedBox(height: 24),
              _buildCategoryBreakdown(repo.getCategorySummary()),
              const SizedBox(height: 24),
              _buildChallengeCard(),
              const SizedBox(height: 100), // Space for chat
            ],
          ),
        ),
      ),
      bottomSheet: _buildChatInterface(chatState),
    );
  }

  Widget _buildPersonalityScore(int score) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 60,
                height: 60,
                child: CircularProgressIndicator(
                  value: score / 100,
                  backgroundColor: Colors.white10,
                  color: const Color(0xFF4F46E5),
                  strokeWidth: 8,
                ),
              ),
              Text('$score%', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(width: 20),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('نقاط الوعي المالي / Financial Score', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                Text('أداء ممتاز هذا الأسبوع!', style: TextStyle(color: Colors.white54, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInsightCard(ChatState state) {
    final lastMessage = state.messages.isNotEmpty 
        ? state.messages.last.role == 'model' && state.messages.last.parts.first is TextPart
          ? (state.messages.last.parts.first as TextPart).text
          : "..."
        : "جاري تحليل نمط إنفاقك...";

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4F46E5).withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.auto_awesome, color: Colors.white, size: 24),
              SizedBox(width: 10),
              Text('رؤية ذكية / AI Insight', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            lastMessage,
            style: const TextStyle(color: Colors.white, fontSize: 15, height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget _buildSpendingChart(List<double> data) {
    return Container(
      height: 200,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(24),
      ),
      child: LineChart(
        LineChartData(
          gridData: const FlGridData(show: false),
          titlesData: const FlTitlesData(show: false),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: data.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value)).toList(),
              isCurved: true,
              color: const Color(0xFF4F46E5),
              barWidth: 4,
              isStrokeCapRound: true,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                color: const Color(0xFF4F46E5).withValues(alpha: 0.1),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryBreakdown(Map<String, double> summary) {
    return Column(
      children: summary.entries.map((e) => _buildCategoryRow(e.key, e.value)).toList(),
    );
  }

  Widget _buildCategoryRow(String category, double amount) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.category, color: Colors.white54, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(category, style: const TextStyle(color: Colors.white)),
          ),
          Text('${amount.toStringAsFixed(0)} ج.م', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildChallengeCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.greenAccent.withValues(alpha: 0.2)),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.emoji_events_outlined, color: Colors.greenAccent),
              SizedBox(width: 8),
              Text('تحدي الأسبوع / Weekly Challenge', style: TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold)),
            ],
          ),
          SizedBox(height: 8),
          Text(
            'وفر 200 جنيه من مصاريف "الترفيه" بنهاية الأسبوع!',
            style: TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget _buildChatInterface(ChatState state) {
    final controller = TextEditingController();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: const BoxDecoration(
        color: Color(0xFF1E293B),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.mic_none_rounded, color: Color(0xFF94A3B8)),
            onPressed: () {
              // TODO: Voice Tracking
            },
          ),
          Expanded(
            child: TextField(
              controller: controller,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: 'تحدث مع الكوتش...',
                hintStyle: TextStyle(color: Color(0xFF94A3B8)),
                border: InputBorder.none,
              ),
              onSubmitted: (val) {
                if (val.isNotEmpty) {
                  ref.read(coachChatProvider.notifier).sendMessage(val);
                  controller.clear();
                }
              },
            ),
          ),
          IconButton(
            icon: Icon(state.isLoading ? Icons.hourglass_empty : Icons.send, color: const Color(0xFF4F46E5)),
            onPressed: () {
              if (controller.text.isNotEmpty) {
                ref.read(coachChatProvider.notifier).sendMessage(controller.text);
                controller.clear();
              }
            },
          ),
        ],
      ),
    );
  }
}
