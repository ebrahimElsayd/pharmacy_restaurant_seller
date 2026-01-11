import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pharmacy_restaurant_seller/core/theme/app_pallete.dart';
import 'package:pharmacy_restaurant_seller/core/theme/font_weight_helper.dart';
import 'package:pharmacy_restaurant_seller/core/theme/values_manager.dart';
import 'package:pharmacy_restaurant_seller/features/auth/presentation/widgets/custom_button.dart';
import 'package:pharmacy_restaurant_seller/features/auth/presentation/widgets/custom_text_field.dart';
import '../riverpods/auth_providers.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _emailSent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(isForgotPasswordLoadingProvider);

    return Scaffold(
      backgroundColor: AppPallete.whiteColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(AppPadding.p24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back button
              IconButton(
                onPressed: () => context.pop(),
                icon: const Icon(Icons.arrow_back_ios),
                padding: EdgeInsets.zero,
              ),
              SizedBox(height: AppSize.s20),

              // Title
              Text(
                _emailSent ? 'Check Your Email' : 'Forgot Password',
                style: TextStyle(
                  fontSize: FontSize.s28,
                  fontWeight: FontWeight.bold,
                  color: AppPallete.blackForText,
                ),
              ),
              SizedBox(height: AppSize.s8),

              Text(
                _emailSent
                    ? 'We sent a password reset link to ${_emailController.text}'
                    : 'Enter your email to reset your password',
                style: TextStyle(
                  fontSize: FontSize.s14,
                  color: AppPallete.lightGreyForText,
                ),
              ),
              SizedBox(height: AppSize.s32),

              // Illustration
              Center(
                child: Container(
                  height: 200,
                  width: 200,
                  decoration: BoxDecoration(
                    gradient: _emailSent
                        ? null
                        : const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppPallete.lightBlueForText,
                        AppPallete.blueColor,
                      ],
                    ),
                    color: _emailSent
                        ? AppPallete.greenColor.withValues(alpha: 0.1)
                        : null,
                    borderRadius: BorderRadius.circular(AppSize.s20),
                  ),
                  child: Icon(
                    _emailSent ? Icons.mark_email_read : Icons.lock_reset,
                    size: 80,
                    color: _emailSent
                        ? AppPallete.greenColor
                        : AppPallete.whiteColor,
                  ),
                ),
              ),
              SizedBox(height: AppSize.s32),

              // Form / Result
              if (!_emailSent)
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      CustomTextField(
                        controller: _emailController,
                        hintText: 'Enter your email',
                        keyboardType: TextInputType.emailAddress,
                        icon: Icons.email_outlined,
                        validator: (value) => ref.read(authNotifierProvider.notifier).validateEmail(value),
                      ),
                      SizedBox(height: AppSize.s24),

                      CustomButton(
                        text: 'Send Reset Link',
                        onPressed: isLoading ? null : _sendResetEmail,
                        isLoading: isLoading,
                        textColor: AppPallete.whiteColor,
                      ),
                    ],
                  ),
                )
              else
                Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(AppPadding.p16),
                      decoration: BoxDecoration(
                        color: AppPallete.greenColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(AppSize.s12),
                        border: Border.all(
                          color: AppPallete.greenColor.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Column(
                        children: [
                          const Icon(
                            Icons.check_circle,
                            color: AppPallete.greenColor,
                            size: 48,
                          ),
                          SizedBox(height: AppSize.s16),
                          Text(
                            'Email Sent Successfully!',
                            style: TextStyle(
                              fontSize: FontSize.s18,
                              fontWeight: FontWeight.w600,
                              color: AppPallete.greenColor,
                            ),
                          ),
                          SizedBox(height: AppSize.s8),
                          Text(
                            'We\'ve sent a password reset link to your email address. Please check your inbox and click the link to reset your password.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppPallete.lightGreyForText,
                              fontSize: FontSize.s14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: AppSize.s24),

                    // Back to Login Button
                    CustomButton(
                      text: 'Back to Login',
                      onPressed: () => context.go('/login'),
                      textColor: AppPallete.whiteColor,
                    ),

                    SizedBox(height: AppSize.s16),

                    // Resend Email Button
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _emailSent = false;
                        });
                      },
                      child: Text(
                        'Didn\'t receive the email? Try again',
                        style: TextStyle(
                          color: AppPallete.lightBlueForText,
                          fontWeight: FontWeightHelper.medium,
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _sendResetEmail() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        await ref.read(authNotifierProvider.notifier).forgotPassword(
          _emailController.text.trim(),
        );
        // Check if the operation was successful
        if (ref.read(errorMessageProvider) == null) {
          setState(() {
            _emailSent = true;
          });
        }
      } catch (e) {
        // Error will be handled by AuthController
      }
    }
  }
}
