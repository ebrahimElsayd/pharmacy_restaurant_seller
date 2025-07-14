import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharmacy_restaurant_seller/core/theme/app_pallete.dart';
import 'package:pharmacy_restaurant_seller/core/theme/values_manager.dart';
import '../../../../core/theme/font_weight_helper.dart';
import '../controllers/auth_controller.dart';
import '../riverpods/auth_providers.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';

class ResetPasswordScreen extends ConsumerStatefulWidget {
  final String? token;

  const ResetPasswordScreen({super.key, this.token});

  @override
  ConsumerState<ResetPasswordScreen> createState() =>
      _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends ConsumerState<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  late AuthController _authController;
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _authController = AuthController(ref, context);
    final isLoading = ref.watch(isLoadingProvider);

    return Scaffold(
      backgroundColor: AppPallete.whiteColor,
      appBar: AppBar(
        backgroundColor: AppPallete.whiteColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppPallete.blackForText),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(AppMargin.m20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: AppSize.s40),

                // Lock Icon
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppPallete.lightBlueForText,
                        AppPallete.blueColor,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(60),
                  ),
                  child: const Icon(
                    Icons.lock_outline,
                    size: 60,
                    color: AppPallete.whiteColor,
                  ),
                ),

                SizedBox(height: AppMargin.m24),

                // Title
                Text(
                  'New Password',
                  style: TextStyle(
                    fontSize: FontSize.s24,
                    fontWeight: FontWeightHelper.bold,
                    color: AppPallete.blackForText,
                  ),
                ),

                SizedBox(height: AppSize.s16),

                // Subtitle
                Text(
                  'Please enter your new password',
                  style: TextStyle(
                    fontSize: FontSize.s14,
                    color: AppPallete.lightGreyForText,
                  ),
                ),

                SizedBox(height: AppSize.s40),

                // Password Field
                CustomTextField(
                  controller: _passwordController,
                  // labelText: 'Password',
                  hintText: 'Enter your new password',
                  // obscureText: !_isPasswordVisible,
                  validator: _authController.validatePassword,
                  // suffixIcon: IconButton(
                  //   icon: Icon(
                  //     _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                  //     color: AppPallete.lightGreyForText,
                  //   ),
                  //   onPressed: () {
                  //     setState(() {
                  //       _isPasswordVisible = !_isPasswordVisible;
                  //     });
                  //   },
                  // ),
                  icon: Icons.lock_outline,
                  // color: AppPallete.lightGreyForText,
                ),

                SizedBox(height: AppSize.s20),

                // Confirm Password Field
                CustomTextField(
                  controller: _confirmPasswordController,
                  // labelText: 'Confirm Password',
                  hintText: 'Confirm your new password',
                  // obscureText: !_isConfirmPasswordVisible,
                  validator:
                      (value) => _authController.validateConfirmPassword(
                        value,
                        _passwordController.text,
                      ),
                  // suffixIcon: IconButton(
                  //   icon: Icon(
                  //     _isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
                  //     color: AppPallete.lightGreyForText,
                  //   ),
                  //   onPressed: () {
                  //     setState(() {
                  //       _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                  //     });
                  //   },
                  // ),
                  icon: Icons.lock_outline,

                  // color: AppPallete.lightGreyForText,
                ),

                SizedBox(height: AppSize.s20),

                // Password Requirements
                Container(
                  padding: EdgeInsets.all(AppMargin.m16),
                  decoration: BoxDecoration(
                    color: AppPallete.borderColor.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(AppMargin.m8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Password Requirements:',
                        style: TextStyle(
                          fontSize: FontSize.s14,
                          fontWeight: FontWeightHelper.medium,
                          color: AppPallete.blackForText,
                        ),
                      ),
                      SizedBox(height: AppSize.s8),
                      _buildRequirement(
                        'At least 6 characters',
                        _passwordController.text.length >= 6,
                      ),
                      _buildRequirement(
                        'Contains uppercase letter',
                        _passwordController.text.contains(RegExp(r'[A-Z]')),
                      ),
                      _buildRequirement(
                        'Contains lowercase letter',
                        _passwordController.text.contains(RegExp(r'[a-z]')),
                      ),
                      _buildRequirement(
                        'Contains number',
                        _passwordController.text.contains(RegExp(r'[0-9]')),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: AppSize.s30),

                // Reset Password Button
                CustomButton(
                  text: 'Reset Password',
                  onPressed: isLoading ? null : _resetPassword,
                  isLoading: isLoading,
                  // backgroundColor: AppPallete.primaryColor,
                  textColor: AppPallete.whiteColor,
                ),

                const Spacer(),

                // Security Note
                Container(
                  padding: EdgeInsets.all(AppMargin.m16),
                  decoration: BoxDecoration(
                    color: AppPallete.greenColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppMargin.m8),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.security_outlined,
                        color: AppPallete.greenColor,
                        size: 20,
                      ),
                      SizedBox(width: AppSize.s8),
                      Expanded(
                        child: Text(
                          'Your password is encrypted and secure. Choose a strong password to protect your account.',
                          style: TextStyle(
                            fontSize: FontSize.s12,
                            color: AppPallete.greenColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRequirement(String text, bool isValid) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppSize.s4),
      child: Row(
        children: [
          Icon(
            isValid ? Icons.check_circle : Icons.circle_outlined,
            size: 16,
            color:
                isValid ? AppPallete.greenColor : AppPallete.lightGreyForText,
          ),
          SizedBox(width: AppSize.s8),
          Text(
            text,
            style: TextStyle(
              fontSize: FontSize.s12,
              color:
                  isValid ? AppPallete.greenColor : AppPallete.lightGreyForText,
            ),
          ),
        ],
      ),
    );
  }

  void _resetPassword() {
    if (_formKey.currentState?.validate() ?? false) {
      final token = widget.token ?? '';
      _authController.updatePassword(
        newPassword: _passwordController.text.trim(),
        token: token,
      );
    }
  }
}
