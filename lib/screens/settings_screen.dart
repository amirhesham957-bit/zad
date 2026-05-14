import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الإعدادات'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildProfileHeader(context),
          const SizedBox(height: 32),
          _buildSectionTitle(context, 'الحساب'),
          _buildSettingsTile(context, Icons.person_outline, 'الملف الشخصي', () {}),
          _buildSettingsTile(context, Icons.notifications_none, 'التنبيهات', () {}),
          _buildSettingsTile(context, Icons.security, 'الأمان', () {}),
          const SizedBox(height: 32),
          _buildSectionTitle(context, 'قانوني'),
          _buildSettingsTile(context, Icons.privacy_tip_outlined, 'سياسة الخصوصية', () => context.push('/settings/privacy')),
          _buildSettingsTile(context, Icons.description_outlined, 'شروط الاستخدام', () => context.push('/settings/terms')),
          const SizedBox(height: 40),
          _buildLogoutButton(),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
          child: Text(
            'AH',
            style: TextStyle(
              fontSize: 32,
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ).animate().scale(delay: 200.ms),
        const SizedBox(height: 16),
        Text(
          'أحمد هشام',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        Text(
          'ahmed@example.com',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white38),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, left: 4),
      child: Text(
        title,
        style: TextStyle(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildSettingsTile(BuildContext context, IconData icon, String title, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
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
