import 'package:flutter/material.dart';

class TermsOfServiceScreen extends StatelessWidget {
  const TermsOfServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(title: const Text('شروط الاستخدام'), backgroundColor: Colors.transparent),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'شروط الاستخدام لتطبيق زاد',
              style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 24),
            Text(
              'باستخدامك لتطبيق زاد، أنت توافق على الشروط التالية:',
              style: TextStyle(color: Colors.white70, fontSize: 16, height: 1.6),
            ),
            SizedBox(height: 20),
            Text(
              '1. النصائح المالية',
              style: TextStyle(color: Colors.indigoAccent, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              'النصائح المقدمة من كوتش زاد هي نصائح استشارية بناءً على خوارزميات الذكاء الاصطناعي ولا تعتبر نصيحة قانونية أو استثمارية رسمية.',
              style: TextStyle(color: Colors.white70, fontSize: 16, height: 1.6),
            ),
            SizedBox(height: 20),
            Text(
              '2. مسؤولية المستخدم',
              style: TextStyle(color: Colors.indigoAccent, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              'المستخدم مسؤول عن دقة البيانات التي يدخلها في التطبيق.',
              style: TextStyle(color: Colors.white70, fontSize: 16, height: 1.6),
            ),
          ],
        ),
      ),
    );
  }
}
