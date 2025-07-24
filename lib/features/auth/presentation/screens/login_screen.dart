import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_pallete.dart';
import '../../../../core/theme/values_manager.dart';
import '../riverpods/auth_providers.dart';
import '../riverpods/auth_state.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_password_field.dart';
import '../widgets/custom_text_field.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _rememberMe = false;
  bool _isListening = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    ref.read(authNotifierProvider.notifier).clearError();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    await ref.read(authNotifierProvider.notifier).login(email, password);
  }

  void _showMessage(String message, Color backgroundColor) {
    if (mounted) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: backgroundColor,
          duration: const Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.all(16),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    final isLoginLoading = authState.isLoginLoading;

    // Listen to auth state changes once
    if (!_isListening) {
      ref.listen<AuthStateData>(authNotifierProvider, (previous, next) {
        if (!mounted) return;

        if (next.state == AuthState.authenticated &&
            previous?.isLoginLoading == true &&
            !next.isLoginLoading &&
            next.user?.isEmailVerified == true) {
          _showMessage('Login successful!', AppPallete.greenColor);
          context.go('/dashboard');
        }

        if (next.state == AuthState.emailVerificationRequired) {
          _showMessage('Please verify your email address', AppPallete.primaryColor);
          context.go('/email-verification');
        }

        if (next.state == AuthState.error && next.errorMessage != null) {
          _showMessage(next.errorMessage!, AppPallete.redColor);
        }
      });
      _isListening = true;
    }

    return Scaffold(
      backgroundColor: AppPallete.whiteColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(AppSize.s24),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(height: AppSize.s40),

                // Logo
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppPallete.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.storefront_rounded,
                    size: 40,
                    color: AppPallete.primaryColor,
                  ),
                ),
                SizedBox(height: AppSize.s24),

                // Title
                const Text(
                  'Welcome Back',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppPallete.blackForText,
                  ),
                ),
                SizedBox(height: AppSize.s8),
                const Text(
                  'Sign in to continue',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppPallete.greyColor,
                  ),
                ),
                SizedBox(height: AppSize.s48),

                // Email Field
                CustomTextField(
                  controller: _emailController,
                  hintText: 'Enter your email',
                  icon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  enabled: !isLoginLoading,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$')
                        .hasMatch(value.trim())) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                SizedBox(height: AppSize.s20),

                // Password Field
                CustomPasswordField(
                  controller: _passwordController,
                  hintText: 'Enter your password',
                  icon: Icons.lock_outline,
                  obscureText: _obscurePassword,
                  enabled: !isLoginLoading,
                  onToggleVisibility: () =>
                      setState(() => _obscurePassword = !_obscurePassword),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                SizedBox(height: AppSize.s16),

                // Remember me + Forgot Password
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Checkbox(
                          value: _rememberMe,
                          onChanged: isLoginLoading
                              ? null
                              : (value) =>
                              setState(() => _rememberMe = value ?? false),
                          activeColor: AppPallete.primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        Text(
                          'Remember me',
                          style: TextStyle(
                            color: isLoginLoading
                                ? AppPallete.greyColor
                                : AppPallete.blackForText,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    TextButton(
                      onPressed: isLoginLoading
                          ? null
                          : () => context.push('/forgot-password'),
                      child: Text(
                        'Forgot Password?',
                        style: TextStyle(
                          color: isLoginLoading
                              ? AppPallete.greyColor
                              : AppPallete.primaryColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppSize.s32),

                // Login Button
                CustomButton(
                  text: 'Sign In',
                  isLoading: isLoginLoading,
                  onPressed: isLoginLoading ? null : _handleLogin,
                ),
                SizedBox(height: AppSize.s32),

                // Divider
                const Row(
                  children: [
                    Expanded(child: Divider(color: AppPallete.greyColor)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'or',
                        style: TextStyle(
                          color: AppPallete.greyColor,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Expanded(child: Divider(color: AppPallete.greyColor)),
                  ],
                ),
                SizedBox(height: AppSize.s24),

                // Sign up Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Don\'t have an account? ',
                      style: TextStyle(color: AppPallete.greyColor),
                    ),
                    TextButton(
                      onPressed: isLoginLoading
                          ? null
                          : () => context.push('/signup'),
                      child: Text(
                        'Create Account',
                        style: TextStyle(
                          color: isLoginLoading
                              ? AppPallete.greyColor
                              : AppPallete.primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppSize.s32),

                // App Version
                Text(
                  'Version 1.0.0',
                  style: TextStyle(
                    color: AppPallete.greyColor.withValues(alpha: 0.7),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
