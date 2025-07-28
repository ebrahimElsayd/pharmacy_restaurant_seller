import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../features/auth/presentation/screens/forgot_password_screen.dart';
import '../../../features/auth/presentation/screens/login_screen.dart';
import '../../../features/auth/presentation/screens/signup_screen.dart';
import '../../../features/auth/presentation/screens/reset_password_screen.dart';
import '../../../features/auth/presentation/screens/email_verification_screen.dart';
import '../../../features/dashboard/presentation/screens/dashboard_screen.dart';
import '../../../features/orders/presentation/screens/orders_list_screen.dart';
import '../../../features/auth/presentation/riverpods/auth_providers.dart';
import '../../../features/auth/presentation/riverpods/auth_state.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final authNotifier = ref.watch(authNotifierProvider.notifier);
  final authState = ref.watch(authNotifierProvider);

  return GoRouter(
    initialLocation: '/splash',
    redirect: (context, state) => _handleRedirect(authState, state),
    routes: [
      // Splash Route - للتحقق من حالة المصادقة
      GoRoute(
        path: '/splash',
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),

      // Root Route
      GoRoute(
        path: '/',
        redirect: (context, state) => '/splash',
      ),

      // Orders Route (للاختبار)
      GoRoute(
        path: '/orders',
        name: 'orders',
        builder: (context, state) => const OrdersListScreen(),
      ),

      // Auth Routes
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

      // Protected Routes
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

String? _handleRedirect(AuthStateData authState, GoRouterState state) {
  final currentLocation = state.matchedLocation;
  final isLoading = authState.state == AuthState.loading;
  final isAuthenticated = authState.state == AuthState.authenticated;
  final isRegistered = authState.state == AuthState.registrationSuccess;
  final needsEmailVerification = authState.state == AuthState.emailVerificationRequired;
  final isUnauthenticated = authState.state == AuthState.unauthenticated;
  final hasError = authState.state == AuthState.error;

  final publicRoutes = ['/login', '/signup', '/forgot-password', '/splash'];
  final isOnPublicRoute = publicRoutes.contains(currentLocation) ||
      currentLocation.startsWith('/reset-password');

  final protectedRoutes = ['/dashboard', '/orders'];
  final isOnProtectedRoute = protectedRoutes.any((route) => currentLocation.startsWith(route));

  // إذا كان في حالة تحميل وليس في صفحة splash
  if (isLoading) {
    if (currentLocation == '/splash') return null;
    return '/splash';
  }

  // إذا كان هناك خطأ، لا تقم بأي redirect - دع الصفحة الحالية تتعامل مع الخطأ
  if (hasError) {
    return null;
  }

  // إذا تم التسجيل بنجاح ولكن لم يتم تسجيل الدخول التلقائي
  if (isRegistered) {
    if (currentLocation != '/login') {
      return '/login';
    }
    return null;
  }

  // إذا كان مصادق وفي صفحة عامة، انتقل للداشبورد
  if (isAuthenticated) {
    if (isOnPublicRoute) {
      return '/dashboard';
    }
    return null; // دع المستخدم يبقى في الصفحة المحمية الحالية
  }

  // إذا كان يحتاج تحقق من البريد الإلكتروني
  if (needsEmailVerification) {
    if (currentLocation != '/email-verification') {
      return '/email-verification';
    }
    return null;
  }

  // إذا كان غير مصادق وفي صفحة محمية أو splash
  if (isUnauthenticated) {
    if (isOnProtectedRoute || currentLocation == '/splash') {
      return '/login';
    }
    return null; // دع المستخدم يبقى في الصفحة العامة الحالية
  }

  return null;
}

// Splash Screen للتحقق من حالة المصادقة
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // التحقق من حالة المصادقة عند بدء التطبيق
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(authNotifierProvider.notifier).initializeAuth();
    });
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // شعار التطبيق
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Icon(
                Icons.restaurant_menu,
                size: 60,
                color: Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(height: 32),

            // اسم التطبيق
            Text(
              'Restaurant Seller',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(height: 16),

            // مؤشر التحميل
            if (authState.state == AuthState.loading) ...[
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              Text(
                'Checking authentication...',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
            ],

            // رسالة خطأ إذا وجدت
            if (authState.state == AuthState.error && authState.errorMessage != null) ...[
              const Icon(Icons.error_outline, color: Colors.red, size: 48),
              const SizedBox(height: 16),
              Text(
                authState.errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => context.go('/login'),
                child: const Text('Go to Login'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}