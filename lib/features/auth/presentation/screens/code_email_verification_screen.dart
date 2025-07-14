import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';

import '../../../../core/theme/app_pallete.dart';
import '../../../../core/theme/font_weight_helper.dart';
import '../../../../core/theme/values_manager.dart';
import '../controllers/auth_controller.dart';
import '../riverpods/auth_providers.dart';
import '../widgets/custom_button.dart';
import '../widgets/otp_input.dart';

class CodeEmailVerificationScreen extends ConsumerStatefulWidget {
  final String email;

  const CodeEmailVerificationScreen({Key? key, required this.email})
    : super(key: key);

  @override
  ConsumerState<CodeEmailVerificationScreen> createState() =>
      _CodeEmailVerificationScreenState();
}

class _CodeEmailVerificationScreenState
    extends ConsumerState<CodeEmailVerificationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _otpController = TextEditingController();
  late AuthController _authController;
  Timer? _timer;
  int _countdown = 60;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _otpController.dispose();
    super.dispose();
  }

  void _startCountdown() {
    _canResend = false;
    _countdown = 60;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_countdown > 0) {
          _countdown--;
        } else {
          _canResend = true;
          timer.cancel();
        }
      });
    });
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

                // Cloud and Lock Icon
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [AppPallete.lightOrange, AppPallete.primaryColor],
                    ),
                    borderRadius: BorderRadius.circular(60),
                  ),
                  child: const Icon(
                    Icons.cloud_outlined,
                    size: 60,
                    color: AppPallete.whiteColor,
                  ),
                ),

                SizedBox(height: AppSize.s30),

                // Title
                Text(
                  'Verification Code',
                  style: TextStyle(
                    fontSize: FontSize.s24,
                    fontWeight: FontWeightHelper.bold,
                    color: AppPallete.blackForText,
                  ),
                ),

                SizedBox(height: AppSize.s16),

                // Subtitle
                Text(
                  'We have sent the verification code to',
                  style: TextStyle(
                    fontSize: FontSize.s14,
                    color: AppPallete.lightGreyForText,
                  ),
                ),

                SizedBox(height: AppSize.s8),

                // Email
                Text(
                  widget.email,
                  style: TextStyle(
                    fontSize: FontSize.s16,
                    fontWeight: FontWeightHelper.medium,
                    color: AppPallete.blackForText,
                  ),
                ),

                SizedBox(height: AppSize.s40),

                // OTP Input
                OTPInput(
                  // controller: _otpController,
                  onChanged: (value) {
                    if (value.length == 6) {
                      // Auto-submit when 6 digits are entered
                      _verifyCode();
                    }
                  },
                  onCompleted: (String) {},
                  // validator: _authController.validateOTP,
                ),

                SizedBox(height: AppSize.s24),

                // Countdown Timer
                if (!_canResend)
                  Text(
                    'Resend code in ${_countdown.toString().padLeft(2, '0')}s',
                    style: TextStyle(
                      fontSize: FontSize.s14,
                      color: AppPallete.lightGreyForText,
                    ),
                  ),

                SizedBox(height: AppSize.s24),

                // Confirm Button
                CustomButton(
                  text: 'Confirm Code',
                  onPressed: isLoading ? null : _verifyCode,
                  isLoading: isLoading,
                  // backgroundColor: AppPallete.primaryColor,
                  textColor: AppPallete.whiteColor,
                ),

                SizedBox(height: AppSize.s20),

                // Resend Code Button
                TextButton(
                  onPressed: _canResend && !isLoading ? _resendCode : null,
                  child: Text(
                    'Didn\'t get OTP? Resend OTP',
                    style: TextStyle(
                      fontSize: FontSize.s14,
                      color:
                          _canResend
                              ? AppPallete.lightBlueForText
                              : AppPallete.lightGreyForText,
                      fontWeight: FontWeightHelper.medium,
                    ),
                  ),
                ),

                const Spacer(),

                // Help Text
                Container(
                  padding: EdgeInsets.all(AppMargin.m16),
                  decoration: BoxDecoration(
                    color: AppPallete.borderColor.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(AppSize.s20),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.info_outline,
                        color: AppPallete.lightBlueForText,
                        size: 20,
                      ),
                      SizedBox(width: AppSize.s8),
                      Expanded(
                        child: Text(
                          'Please check your email and enter the 6-digit verification code.',
                          style: TextStyle(
                            fontSize: FontSize.s12,
                            color: AppPallete.lightGreyForText,
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

  void _verifyCode() {
    if (_formKey.currentState?.validate() ?? false) {
      _authController.verifyEmail(
        email: widget.email,
        code: _otpController.text.trim(),
      );
    }
  }

  void _resendCode() {
    _authController.resendVerificationCode(email: widget.email);
    _startCountdown();
  }
}
