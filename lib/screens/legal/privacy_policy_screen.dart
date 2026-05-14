import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(title: const Text('سياسة الخصوصية'), backgroundColor: Colors.transparent),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'سياسة الخصوصية لتطبيق زاد',
              style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 24),
            Text(
              'نحن في زاد (Zad) نولي أهمية قصوى لخصوصية بياناتك المالية. هذا التطبيق مصمم ليعمل كأداة تحليلية ذكية، وجميع البيانات التي يتم إدخالها تُعالج لتقديم رؤى مخصصة لك.',
              style: TextStyle(color: Colors.white70, fontSize: 16, height: 1.6),
            ),
            SizedBox(height: 20),
            Text(
              '1. البيانات التي نجمعها',
              style: TextStyle(color: Colors.indigoAccent, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              '- معاملاتك المالية المدخلة يدوياً.\n- النصوص التي تشاركها مع كوتش زاد.\n- تفاصيل المجموعات في ميزة تقسيم المصاريف.',
              style: TextStyle(color: Colors.white70, fontSize: 16, height: 1.6),
            ),
            SizedBox(height: 20),
            Text(
              '2. كيف نستخدم بياناتك',
              style: TextStyle(color: Colors.indigoAccent, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              'نستخدم البيانات فقط لتحسين تجربتك وتقديم نصائح مالية دقيقة من خلال الذكاء الاصطناعي.',
              style: TextStyle(color: Colors.white70, fontSize: 16, height: 1.6),
            ),
          ],
        ),
      ),
    );
  }
}
