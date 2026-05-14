import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../components/glass_container.dart';

import '../services/haptic_service.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'زاد / Zad',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle_outlined, color: Colors.white),
            onPressed: () {
              HapticService.light();
              context.push('/settings');
            },
          )
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              _buildBudgetCard(),
              const SizedBox(height: 32),
              const Text(
                'الخدمات الأساسية',
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              _buildFeatureGrid(),
              const SizedBox(height: 32),
              const Text(
                'تنبيهات المدرب / Coach Alerts',
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              _buildAlertCard('Emotional Spend Detected', 'You spent 150 EGP on Coffee after a late work meeting.', Colors.orange),
              const SizedBox(height: 12),
              _buildAlertCard('Budget Goal Reached', 'You saved 500 EGP more than last month!', Colors.green),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          HapticService.medium();
          context.push('/coach');
        },
        backgroundColor: Colors.indigoAccent,
        icon: const Icon(Icons.auto_awesome, color: Colors.white),
        label: const Text('اسأل زاد', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ).animate().scale(delay: 1.seconds).shimmer(delay: 2.seconds),
    );
  }

  Widget _buildBudgetCard() {
    return GlassContainer(
      opacity: 0.1,
      child: Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Text(
              'الميزانية المتبقية',
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
            const SizedBox(height: 12),
            const Text(
              '1,750.00 ج.م',
              style: TextStyle(
                color: Colors.white,
                fontSize: 36,
                fontWeight: FontWeight.bold,
              ),
            ).animate().shimmer(duration: 2.seconds, color: Colors.indigoAccent),
            const SizedBox(height: 24),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: const LinearProgressIndicator(
                value: 0.65,
                minHeight: 12,
                backgroundColor: Colors.white10,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.indigoAccent),
              ),
            ).animate().fadeIn(delay: 400.ms).scaleX(),
          ],
        ),
      ),
    ).animate().fadeIn().slideY(begin: 0.2);
  }

  Widget _buildFeatureGrid() {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 3,
      crossAxisSpacing: 15,
      mainAxisSpacing: 15,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _buildFeatureItem('Coach', Icons.psychology_outlined, Colors.purpleAccent, () => context.push('/coach')),
        _buildFeatureItem('Split', Icons.groups_outlined, Colors.blueAccent, () => context.push('/split')),
        _buildFeatureItem('Goals', Icons.star_outline, Colors.amberAccent, () => context.push('/goals')),
      ],
    );
  }

  Widget _buildFeatureItem(String title, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: () {
        HapticService.light();
        onTap();
      },
      child: GlassContainer(
        opacity: 0.05,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 28),
            ).animate().scale(delay: 500.ms),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAlertCard(String title, String subtitle, Color color) {
    return GlassContainer(
      opacity: 0.05,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(Icons.info_outline, color: color),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  Text(subtitle, style: const TextStyle(color: Colors.white54, fontSize: 12)),
                ],
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn().slideX(begin: 0.1);
  }
}
