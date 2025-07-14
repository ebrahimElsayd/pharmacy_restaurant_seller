import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharmacy_restaurant_seller/core/theme/app_pallete.dart';
import 'package:pharmacy_restaurant_seller/core/theme/font_weight_helper.dart';
import 'package:pharmacy_restaurant_seller/core/theme/values_manager.dart';
import 'package:pharmacy_restaurant_seller/features/auth/presentation/widgets/custom_button.dart';
import 'package:pharmacy_restaurant_seller/features/auth/presentation/widgets/custom_text_field.dart';

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
    // final authState = ref.watch(authControllerProvider);

    // ref.listen(authControllerProvider, (previous, next) {
    //   if (previous?.isLoading == true && next.isLoading == false) {
    //     if (next.error == null) {
    //       setState(() => _emailSent = true);
    //     } else {
    //       ScaffoldMessenger.of(context).showSnackBar(
    //         SnackBar(
    //           content: Text(next.error!),
    //           backgroundColor: Colors.red,
    //         ),
    //       );
    //     }
    //   }
    // });

    return Scaffold(
      backgroundColor: AppPallete.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(AppPadding.p24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back button
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.arrow_back_ios),
                padding: EdgeInsets.zero,
              ),
              SizedBox(height: AppSize.s20),

              // Title
              Text(
                _emailSent ? 'Check your email' : 'Forgot Password',
                style: TextStyle(
                  fontSize: FontSize.s28,
                  fontWeight: FontWeight.bold,
                  color: AppPallete.darkGreyForText,
                ),
              ),
              SizedBox(height: AppSize.s8),

              Text(
                _emailSent
                    ? 'We sent a password reset link to ${_emailController.text}'
                    : 'Enter your email to reset your password',
                style: TextStyle(
                  fontSize: FontSize.s14,
                  color: AppPallete.greyColor,
                ),
              ),
              SizedBox(height: AppSize.s32),

              // Illustration
              Center(
                child: Container(
                  height: 200,
                  width: 200,
                  decoration: BoxDecoration(
                    color:
                        _emailSent ? AppPallete.greenColor : AppPallete.white,
                    borderRadius: BorderRadius.circular(AppSize.s20),
                  ),
                  child: Icon(
                    _emailSent ? Icons.mark_email_read : Icons.lock_reset,
                    size: 80,
                    color:
                        _emailSent ? AppPallete.greenColor : AppPallete.white,
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
                        hintText: 'Your email',
                        // keyboardType: TextInputType.emailAddress,
                        icon: (Icons.email_outlined),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: AppSize.s24),

                      CustomButton(
                        text: 'Continue',
                        // isLoading: authState.isLoading,
                        onPressed: () {
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder:
                          //         (context) => EmailVerificationScreen(
                          //           email: _emailController.text,
                          //         ),
                          //   ),
                          // );
                          //   if (!authState.isLoading) _handleResetPassword();
                        },
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
                        color: AppPallete.greenColor,
                        borderRadius: BorderRadius.circular(AppSize.s12),
                        border: Border.all(color: AppPallete.greenColor),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: AppPallete.greenColor,
                            size: 48,
                          ),
                          SizedBox(height: AppSize.s16),
                          Text(
                            'Check your email',
                            style: TextStyle(
                              fontSize: FontSize.s18,
                              fontWeight: FontWeight.w600,
                              color: AppPallete.greenColor,
                            ),
                          ),
                          SizedBox(height: AppSize.s8),
                          Text(
                            'We\'ve sent a password reset link to your email address',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: AppPallete.darkGreyForText),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: AppSize.s24),
                    CustomButton.outlined(
                      text: 'Back to Login',
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  // void _handleResetPassword() {
  // if (_formKey.currentState!.validate()) {
  //   ref.read(authControllerProvider.notifier).resetPassword(
  //     _emailController.text.trim(),
  //   );
  // }
  // }
}
