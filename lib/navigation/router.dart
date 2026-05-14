
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../screens/dashboard_screen.dart';
import '../screens/splash_screen.dart';
import '../screens/say_coach/say_coach_screen.dart';
import '../screens/say_split_list_screen.dart';
import '../screens/say_split_group_screen.dart';
import '../screens/say_split_add_expense_screen.dart';
import '../screens/say_goals_screen.dart';
import '../screens/settings_screen.dart';
import '../screens/legal/privacy_policy_screen.dart';
import '../screens/legal/terms_of_service_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/splash',
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/',
        builder: (context, state) => const DashboardScreen(),
      ),
      GoRoute(
        path: '/coach',
        builder: (context, state) => const SayCoachScreen(),
      ),
      GoRoute(
        path: '/split',
        builder: (context, state) => const SaySplitListScreen(),
      ),
      GoRoute(
        path: '/split/group/:id',
        builder: (context, state) => SaySplitGroupScreen(groupId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/split/group/:id/add',
        builder: (context, state) => SaySplitAddExpenseScreen(groupId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/goals',
        builder: (context, state) => const SayGoalsScreen(),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: '/privacy',
        builder: (context, state) => const PrivacyPolicyScreen(),
      ),
      GoRoute(
        path: '/terms',
        builder: (context, state) => const TermsOfServiceScreen(),
      ),
    ],
  );
});
