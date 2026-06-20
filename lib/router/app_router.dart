import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/auth_provider.dart';
import '../providers/user_provider.dart';
import '../screens/splash/splash_screen.dart';
import '../screens/onboarding/onboarding_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/streak/streak_detail_screen.dart';
import '../screens/trackers/trackers_list_screen.dart';
import '../screens/trackers/tracker_detail_screen.dart';
import '../screens/trackers/tracker_form_builder_screen.dart';
import '../screens/trackers/tracker_entry_screen.dart';
import '../screens/tasks/tasks_screen.dart';
import '../screens/challenges/challenges_screen.dart';
import '../screens/challenges/challenge_detail_screen.dart';
import '../screens/journal/journal_screen.dart';
import '../screens/journal/journal_entry_screen.dart';
import '../screens/analytics/analytics_screen.dart';
import '../screens/routine/routine_builder_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../widgets/apex_scaffold.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: '/splash',
    redirect: (context, state) {
      final isLoggedIn = authState.value != null;
      final loc = state.matchedLocation;
      final isPublicRoute = loc.startsWith('/splash') ||
          loc.startsWith('/login') ||
          loc.startsWith('/register') ||
          loc.startsWith('/onboarding');

      if (!isLoggedIn && !isPublicRoute) return '/login';
      if (isLoggedIn && (loc == '/login' || loc == '/register')) return '/home';
      return null;
    },
    routes: [
      GoRoute(
        path: '/splash',
        builder: (_, __) => const SplashScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (_, __) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (_, __) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (_, __) => const RegisterScreen(),
      ),

      // Shell with bottom navigation
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            ApexScaffold(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(routes: [
            GoRoute(path: '/home', builder: (_, __) => const HomeScreen()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/trackers',
              builder: (_, __) => const TrackersListScreen(),
              routes: [
                GoRoute(
                  path: 'new',
                  builder: (_, __) => const TrackerFormBuilderScreen(),
                ),
                GoRoute(
                  path: ':id',
                  builder: (_, s) =>
                      TrackerDetailScreen(trackerId: s.pathParameters['id']!),
                  routes: [
                    GoRoute(
                      path: 'entry',
                      builder: (_, s) => TrackerEntryScreen(
                          trackerId: s.pathParameters['id']!),
                    ),
                    GoRoute(
                      path: 'edit',
                      builder: (_, s) => TrackerFormBuilderScreen(
                          trackerId: s.pathParameters['id']),
                    ),
                  ],
                ),
              ],
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: '/tasks', builder: (_, __) => const TasksScreen()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/journal',
              builder: (_, __) => const JournalScreen(),
              routes: [
                GoRoute(
                  path: 'new',
                  builder: (_, __) => const JournalEntryScreen(),
                ),
                GoRoute(
                  path: ':id',
                  builder: (_, s) =>
                      JournalEntryScreen(entryId: s.pathParameters['id']),
                ),
              ],
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
                path: '/profile', builder: (_, __) => const ProfileScreen()),
          ]),
        ],
      ),

      // Full-screen routes (outside shell — no bottom nav)
      GoRoute(
        path: '/streak',
        builder: (_, __) => const StreakDetailScreen(),
      ),
      GoRoute(
        path: '/analytics',
        builder: (_, __) => const AnalyticsScreen(),
      ),
      GoRoute(
        path: '/challenges',
        builder: (_, __) => const ChallengesScreen(),
        routes: [
          GoRoute(
            path: ':id',
            builder: (_, s) =>
                ChallengeDetailScreen(challengeId: s.pathParameters['id']!),
          ),
        ],
      ),
      GoRoute(
        path: '/routine',
        builder: (_, __) => const RoutineBuilderScreen(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(child: Text('Page not found: ${state.uri}')),
    ),
  );
});
