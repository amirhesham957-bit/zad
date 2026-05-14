import 'package:flutter/material.dart';

class FeatureErrorBoundary extends StatelessWidget {
  final Widget child;
  final VoidCallback onRetry;

  const FeatureErrorBoundary({
    super.key,
    required this.child,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return child; // Simplified for now, real boundary uses ErrorWidget.builder
  }
}

class FeatureErrorUI extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const FeatureErrorUI({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 48),
            const SizedBox(height: 16),
            Text(
              'حدث خطأ / An error occurred',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Color(0xFF94A3B8)),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('إعادة المحاولة / Retry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4F46E5),
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
