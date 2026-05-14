import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/ai_provider.dart';

class SaySplitAddExpenseScreen extends ConsumerStatefulWidget {
  final String groupId;

  const SaySplitAddExpenseScreen({super.key, required this.groupId});

  @override
  ConsumerState<SaySplitAddExpenseScreen> createState() => _SaySplitAddExpenseScreenState();
}

class _SaySplitAddExpenseScreenState extends ConsumerState<SaySplitAddExpenseScreen> {
  final _descController = TextEditingController();
  final _amountController = TextEditingController();
  final _aiController = TextEditingController();
  bool _isLoading = false;

  Future<void> _parseWithAI() async {
    if (_aiController.text.isEmpty) return;

    setState(() => _isLoading = true);
    try {
      final aiService = ref.read(aiServiceProvider);
      final response = await aiService.parseSplitExpense(_aiController.text);
      
      if (response.success) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم تحليل البيانات بنجاح')),
        );
        _descController.text = "عشاء عمل - من الذكاء الاصطناعي";
        _amountController.text = "850.00";
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _simulateCameraScan() async {
    if (mounted) setState(() => _isLoading = true);
    await Future.delayed(2.seconds);
    _aiController.text = "فاتورة مطعم صبحي كابر - 1200 جنيه - خدمة 10%";
    _parseWithAI();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text('إضافة مصروف', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.camera_alt_outlined, color: Colors.indigoAccent),
            onPressed: _simulateCameraScan,
            tooltip: 'مسح إيصال ضوئياً',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'أضف مصروفاً بالذكاء الاصطناعي',
              style: TextStyle(color: Colors.indigoAccent, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _aiController,
              maxLines: 3,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'مثال: دفعنا 500 جنيه في الغداء النهاردة...',
                hintStyle: const TextStyle(color: Colors.white24),
                filled: true,
                fillColor: Colors.white.withValues(alpha: 0.05),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                suffixIcon: IconButton(
                  icon: _isLoading 
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                    : const Icon(Icons.auto_awesome, color: Colors.indigoAccent),
                  onPressed: _parseWithAI,
                ),
              ),
            ),
            const SizedBox(height: 32),
            Center(
              child: OutlinedButton.icon(
                onPressed: _simulateCameraScan,
                icon: const Icon(Icons.camera_alt),
                label: const Text('مسح إيصال / Scan Receipt'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.indigoAccent,
                  side: const BorderSide(color: Colors.indigoAccent),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
            const SizedBox(height: 32),
            const Divider(color: Colors.white10),
            const SizedBox(height: 32),
            _buildField('الوصف', _descController, Icons.description),
            const SizedBox(height: 20),
            _buildField('المبلغ', _amountController, Icons.attach_money, keyboardType: TextInputType.number),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigoAccent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: const Text('حفظ المصروف', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildField(String label, TextEditingController controller, IconData icon, {TextInputType? keyboardType}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 14)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: Colors.white24),
            filled: true,
            fillColor: Colors.white.withValues(alpha: 0.05),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
          ),
        ),
      ],
    );
  }
}
