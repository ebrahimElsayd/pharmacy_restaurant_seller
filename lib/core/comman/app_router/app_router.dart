import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../features/auth/presentation/screens/forgot_password_screen.dart';
import '../../../features/auth/presentation/screens/login_screen.dart';
import '../../../features/auth/presentation/screens/signup_screen.dart';
import '../../../features/auth/presentation/screens/reset_password_screen.dart';
import '../../../features/auth/presentation/screens/email_verification_screen.dart';
import '../../../features/dashboard/presentation/screens/dashboard_screen.dart';
import '../../../features/auth/presentation/riverpods/auth_providers.dart';
import '../../../features/auth/presentation/riverpods/auth_state.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authNotifierProvider);

  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      final isLoggedIn = authState.state == AuthState.authenticated;
      final isEmailVerified = authState.user?.isEmailVerified ?? false;
      final needsEmailVerification = authState.state == AuthState.emailVerificationRequired;

      final isOnAuthPage = state.matchedLocation == '/login' ||
          state.matchedLocation == '/signup' ||
          state.matchedLocation == '/forgot-password' ||
          state.matchedLocation.startsWith('/reset-password');

      final isOnEmailVerificationPage = state.matchedLocation == '/email-verification';
      final isOnDashboard = state.matchedLocation == '/dashboard';

      // If user is authenticated and email is verified, redirect to dashboard
      if (isLoggedIn && isEmailVerified && isOnAuthPage) {
        return '/dashboard';
      }

      // If user needs email verification, redirect to verification page
      if (needsEmailVerification && !isOnEmailVerificationPage) {
        return '/email-verification';
      }

      // If user is not authenticated and trying to access protected routes
      if (!isLoggedIn && isOnDashboard) {
        return '/login';
      }

      // If user is not authenticated and not on auth pages, redirect to login
      if (!isLoggedIn && !isOnAuthPage && !isOnEmailVerificationPage) {
        return '/login';
      }

      return null; // No redirect needed
    },
    routes: [
      GoRoute(
        path: '/',
        redirect: (context, state) => '/login',
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/signup',
        name: 'signup',
        builder: (context, state) => const SignUpScreen(),
      ),
      GoRoute(
        path: '/forgot-password',
        name: 'forgot-password',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: '/reset-password',
        name: 'reset-password',
        builder: (context, state) {
          final accessToken = state.uri.queryParameters['access_token'];
          return ResetPasswordScreen(token: accessToken);
        },
      ),
      GoRoute(
        path: '/email-verification',
        name: 'email-verification',
        builder: (context, state) => const EmailVerificationScreen(),
      ),
      GoRoute(
        path: '/dashboard',
        name: 'dashboard',
        builder: (context, state) => const DashboardScreen(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Page not found: ${state.matchedLocation}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go('/login'),
              child: const Text('Go to Login'),
            ),
          ],
        ),
      ),
    ),
  );
});
