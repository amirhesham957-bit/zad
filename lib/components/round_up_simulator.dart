import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class RoundUpSimulator extends StatefulWidget {
  const RoundUpSimulator({super.key});

  @override
  State<RoundUpSimulator> createState() => _RoundUpSimulatorState();
}

class _RoundUpSimulatorState extends State<RoundUpSimulator> {
  final double _transactionAmount = 45.20;
  bool _isAnimating = false;

  void _simulate() async {
    if (!mounted) return;
    setState(() => _isAnimating = true);
    await Future.delayed(2.seconds);
    if (!mounted) return;
    setState(() => _isAnimating = false);
  }

  @override
  Widget build(BuildContext context) {
    double rounded = _transactionAmount.ceilToDouble();
    double spareChange = rounded - _transactionAmount;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.indigo.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.indigoAccent.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          const Row(
            children: [
              Icon(Icons.auto_awesome, color: Colors.indigoAccent),
              SizedBox(width: 8),
              Text(
                'محاكي الادخار التلقائي (Round-Up)',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildValueColumn('المعاملة', _transactionAmount.toStringAsFixed(2)),
              const Icon(Icons.arrow_forward_rounded, color: Colors.white24),
              _buildValueColumn('التقريب', rounded.toStringAsFixed(0)),
            ],
          ),
          const SizedBox(height: 20),
          if (_isAnimating)
            const Text(
              'جاري تحويل الفكة إلى هدفك...',
              style: TextStyle(color: Colors.indigoAccent, fontSize: 12),
            ).animate().fadeIn().shimmer()
          else
            Text(
              '+${spareChange.toStringAsFixed(2)} ج.م تمت إضافتها لهدفك',
              style: const TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold),
            ).animate().scale().fadeIn(),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _isAnimating ? null : _simulate,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.indigoAccent,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('محاكاة عملية شراء', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildValueColumn(String label, String value) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: Colors.white38, fontSize: 12)),
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
