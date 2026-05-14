import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text('الإعدادات', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildProfileHeader(),
          const SizedBox(height: 32),
          _buildSectionTitle('الحساب'),
          _buildSettingsTile(Icons.person_outline, 'الملف الشخصي', () {}),
          _buildSettingsTile(Icons.notifications_none, 'التنبيهات', () {}),
          _buildSettingsTile(Icons.security, 'الأمان', () {}),
          const SizedBox(height: 32),
          _buildSectionTitle('قانوني'),
          _buildSettingsTile(Icons.privacy_tip_outlined, 'سياسة الخصوصية', () => context.push('/settings/privacy')),
          _buildSettingsTile(Icons.description_outlined, 'شروط الاستخدام', () => context.push('/settings/terms')),
          const SizedBox(height: 40),
          _buildLogoutButton(),
        ],
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundColor: Colors.indigoAccent.withValues(alpha: 0.2),
          child: const Text('AH', style: TextStyle(fontSize: 32, color: Colors.indigoAccent, fontWeight: FontWeight.bold)),
        ).animate().scale(delay: 200.ms),
        const SizedBox(height: 16),
        const Text(
          'أحمد هشام',
          style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const Text(
          'ahmed@example.com',
          style: TextStyle(color: Colors.white38, fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, left: 4),
      child: Text(
        title,
        style: const TextStyle(color: Colors.indigoAccent, fontWeight: FontWeight.bold, fontSize: 14),
      ),
    );
  }

  Widget _buildSettingsTile(IconData icon, String title, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.white70),
        title: Text(title, style: const TextStyle(color: Colors.white)),
        trailing: const Icon(Icons.chevron_right, color: Colors.white24),
        onTap: onTap,
      ),
    ).animate().fadeIn(delay: 300.ms).slideX(begin: 0.1);
  }

  Widget _buildLogoutButton() {
    return TextButton(
      onPressed: () {},
      child: const Text('تسجيل الخروج', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
    );
  }
}
