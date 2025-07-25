import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pharmacy_restaurant_seller/core/theme/app_pallete.dart';
import 'package:pharmacy_restaurant_seller/core/theme/values_manager.dart';
import '../../../../core/utils/validators.dart';
import '../riverpods/auth_providers.dart';
import '../riverpods/auth_state.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_password_field.dart';
import '../widgets/custom_text_field.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _hasSetUpListener = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignUp() async {
    // مسح الأخطاء السابقة
    ref.read(authNotifierProvider.notifier).clearError();

    // التحقق من صحة النموذج أولاً
    if (!_formKey.currentState!.validate()) {
      return; // لا تتابع إذا كان النموذج غير صحيح
    }

    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    // التحقق الإضافي من أن الحقول ليست فارغة
    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      _showMessage('الرجاء ملء جميع الحقول المطلوبة', AppPallete.redColor);
      return;
    }

    // تسجيل المستخدم
    await ref.read(authNotifierProvider.notifier).register(email, password, name);
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
          duration: const Duration(seconds: 4),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: const EdgeInsets.all(16),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    final isRegisterLoading = authState.isRegisterLoading;

    if (!_hasSetUpListener) {
      ref.listen<AuthStateData>(authNotifierProvider, (previous, next) {
        if (!mounted) return;

        // معالجة الأخطاء
        if (next.state == AuthState.error && next.errorMessage != null) {
          _showMessage(next.errorMessage!, AppPallete.redColor);
          return;
        }

        // معالجة انتهاء عملية التسجيل بنجاح فقط
        final wasLoading = previous?.isRegisterLoading == true;
        final isNotLoadingAnymore = !next.isRegisterLoading;
        final registrationJustFinished = wasLoading && isNotLoadingAnymore;

        // تأكد من أن التسجيل انتهى بنجاح وليس بخطأ
        if (registrationJustFinished && next.state != AuthState.error) {
          switch (next.state) {
            case AuthState.registrationSuccess:
              _showMessage(
                'تم إنشاء الحساب بنجاح! الرجاء تسجيل الدخول للمتابعة.',
                AppPallete.greenColor,
              );
              // انتظار لإظهار الرسالة ثم الانتقال
              Future.delayed(const Duration(seconds: 2), () {
                if (mounted) {
                  context.go('/login');
                }
              });
              break;

            case AuthState.authenticated:
              _showMessage('تم إنشاء الحساب وتسجيل الدخول بنجاح!', AppPallete.greenColor);
              Future.delayed(const Duration(seconds: 1), () {
                if (mounted) {
                  context.go('/dashboard');
                }
              });
              break;

            case AuthState.emailVerificationRequired:
              _showMessage(
                'تم إنشاء الحساب! الرجاء التحقق من بريدك الإلكتروني.',
                AppPallete.primaryColor,
              );
              Future.delayed(const Duration(seconds: 2), () {
                if (mounted) {
                  context.go('/email-verification');
                }
              });
              break;

            default:
            // في حالة عدم وضوح الحالة، اذهب للتسجيل
              Future.delayed(const Duration(seconds: 1), () {
                if (mounted) {
                  context.go('/login');
                }
              });
          }
        }
      });

      _hasSetUpListener = true;
    }

    return Scaffold(
      backgroundColor: AppPallete.whiteColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(AppPadding.p24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: isRegisterLoading ? null : () => context.pop(),
                  icon: const Icon(Icons.arrow_back_ios),
                  padding: EdgeInsets.zero,
                ),
                SizedBox(height: AppSize.s20),

                Center(
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: AppPallete.primaryColor.withAlpha(25),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      Icons.person_add_rounded,
                      size: 40,
                      color: AppPallete.primaryColor,
                    ),
                  ),
                ),
                SizedBox(height: AppSize.s24),

                const Center(
                  child: Text(
                    'Create Account',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppPallete.blackForText,
                    ),
                  ),
                ),
                SizedBox(height: AppSize.s8),

                const Center(
                  child: Text(
                    'Sign up to get started',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppPallete.greyColor,
                    ),
                  ),
                ),
                SizedBox(height: AppSize.s32),

                // Full Name
                CustomTextField(
                  controller: _nameController,
                  hintText: 'Full Name',
                  icon: Icons.person_outline,
                  enabled: !isRegisterLoading,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return 'Please enter your full name';
                    }
                    if (v.trim().length < 2) {
                      return 'Name must be at least 2 characters';
                    }
                    return null;
                  },
                ),
                SizedBox(height: AppSize.s16),

                // Email
                CustomTextField(
                  controller: _emailController,
                  hintText: 'Email Address',
                  icon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  enabled: !isRegisterLoading,
                  validator: (value) {
                    return Validators.validateEmail(value);
                  },
                ),
                SizedBox(height: AppSize.s16),

                // Password
                CustomPasswordField(
                  controller: _passwordController,
                  hintText: 'Password',
                  icon: Icons.lock_outline,
                  obscureText: _obscurePassword,
                  enabled: !isRegisterLoading,
                  onToggleVisibility: () => setState(() => _obscurePassword = !_obscurePassword),
                  validator: (v) {
                    if (v == null || v.isEmpty) {
                      return 'Please enter a password';
                    }
                    if (v.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                SizedBox(height: AppSize.s16),

                // Confirm Password
                CustomPasswordField(
                  controller: _confirmPasswordController,
                  hintText: 'Confirm Password',
                  icon: Icons.lock_outline,
                  obscureText: _obscureConfirmPassword,
                  enabled: !isRegisterLoading,
                  onToggleVisibility: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                  validator: (v) {
                    if (v == null || v.isEmpty) {
                      return 'Please confirm your password';
                    }
                    if (v != _passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
                SizedBox(height: AppSize.s24),

                // Sign Up Button
                CustomButton(
                  text: 'Create Account',
                  isLoading: isRegisterLoading,
                  onPressed: isRegisterLoading ? null : _handleSignUp,
                ),
                SizedBox(height: AppSize.s24),

                // Login link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Already have an account? ',
                      style: TextStyle(color: AppPallete.greyColor),
                    ),
                    TextButton(
                      onPressed: isRegisterLoading ? null : () => context.pop(),
                      child: Text(
                        'Sign In',
                        style: TextStyle(
                          color: isRegisterLoading
                              ? AppPallete.greyColor
                              : AppPallete.primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}