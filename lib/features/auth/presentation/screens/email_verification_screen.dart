import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_pallete.dart';
import '../../../../core/theme/values_manager.dart';
import '../riverpods/auth_providers.dart';
import '../riverpods/auth_state.dart';
import '../widgets/custom_button.dart';

class EmailVerificationScreen extends ConsumerStatefulWidget {
  const EmailVerificationScreen({super.key});

  @override
  ConsumerState<EmailVerificationScreen> createState() => _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends ConsumerState<EmailVerificationScreen> {
  bool _isListening = false;

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    final userEmail = authState.user?.email ?? '';

    // Listen to auth state changes
    if (!_isListening) {
      ref.listen<AuthStateData>(authNotifierProvider, (previous, next) {
        if (!mounted) return;

        if (next.state == AuthState.authenticated &&
            next.user?.isEmailVerified == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Email verified successfully!'),
              backgroundColor: AppPallete.greenColor,
            ),
          );
          context.go('/dashboard');
        }
      });
      _isListening = true;
    }

    return Scaffold(
      backgroundColor: AppPallete.whiteColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(AppPadding.p24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Email icon
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: AppPallete.primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(60),
                ),
                child: const Icon(
                  Icons.mark_email_read_outlined,
                  size: 60,
                  color: AppPallete.primaryColor,
                ),
              ),
              SizedBox(height: AppSize.s32),

              // Title
              const Text(
                'Verify Your Email',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppPallete.blackForText,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: AppSize.s16),

              // Description
              Text(
                'We\'ve sent a verification link to',
                style: TextStyle(
                  fontSize: 16,
                  color: AppPallete.greyColor,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: AppSize.s8),
              Text(
                userEmail,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppPallete.primaryColor,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: AppSize.s16),
              Text(
                'Please check your email and click the verification link to activate your account.',
                style: TextStyle(
                  fontSize: 14,
                  color: AppPallete.greyColor,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: AppSize.s48),

              // Resend button
              CustomButton(
                text: 'Resend Verification Email',
                onPressed: () async {
                  // Implement resend verification email
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Verification email sent!'),
                      backgroundColor: AppPallete.greenColor,
                    ),
                  );
                },
              ),
              SizedBox(height: AppSize.s16),

              // Back to login
              TextButton(
                onPressed: () {
                  ref.read(authNotifierProvider.notifier).signOut();
                  context.go('/login');
                },
                child: const Text(
                  'Back to Login',
                  style: TextStyle(
                    color: AppPallete.primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
