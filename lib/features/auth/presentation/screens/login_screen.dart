import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pharmacy_restaurant_seller/core/theme/app_pallete.dart';
import 'package:pharmacy_restaurant_seller/core/theme/font_weight_helper.dart';
import 'package:pharmacy_restaurant_seller/core/theme/values_manager.dart';
import 'package:pharmacy_restaurant_seller/features/auth/presentation/screens/forgot_password_screen.dart';
import 'package:pharmacy_restaurant_seller/features/auth/presentation/screens/signup_screen.dart';
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

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final authState = ref.watch(authControllerProvider);

    // ref.listen(authControllerProvider, (previous, next) {
    //   if (previous?.isLoading == true && next.isLoading == false) {
    //     if (next.error == null && next.user != null) {
    //       Navigator.of(context).pushReplacementNamed('/home');
    //     } else if (next.error != null) {
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
      backgroundColor: AppPallete.whiteColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(AppPadding.p24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Logo
                SvgPicture.asset(
                  'assets/svgs/logo.svg',
                  height: AppSize.s35,
                  width: AppSize.s40,
                ),
                SizedBox(height: AppSize.s40),

                // Title
                Center(
                  child: Text(
                    'Welcome Back',
                    style: TextStyle(
                      fontSize: FontSize.s32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: AppSize.s8),
                Center(
                  child: Text(
                    'Sign in to your account',
                    style: TextStyle(
                      fontSize: FontSize.s16,
                      color: AppPallete.greyColor,
                    ),
                  ),
                ),

                // Avatar
                Center(
                  child: Image.asset('assets/images/login_signup_avatar.png'),
                ),

                // Fields
                CustomTextField(
                  controller: _emailController,
                  hintText: 'Your email',
                  icon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
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
                SizedBox(height: AppSize.s16),

                CustomPasswordField(
                  controller: _passwordController,
                  hintText: 'Password',
                  icon: Icons.lock_outline,
                  obscureText: _obscurePassword,
                  onToggleVisibility:
                      () =>
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
                          onChanged:
                              (value) =>
                                  setState(() => _rememberMe = value ?? false),
                          activeColor: AppPallete.primaryColor,
                        ),
                        const Text('Remember me'),
                      ],
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ForgotPasswordScreen(),
                          ),
                        );
                      },
                      child: Text(
                        'Forgot password?',
                        style: TextStyle(color: AppPallete.primaryColor),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppSize.s24),

                // Button
                CustomButton(
                  text: 'Login',
                  // isLoading: authState.isLoading,
                  onPressed: () {},
                  //  onPressed: authState.isLoading ? null : _handleLogin,
                ),
                SizedBox(height: AppSize.s24),

                // Sign up Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Don\'t have an account?',
                      style: TextStyle(color: AppPallete.greyColor),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignUpScreen(),
                          ),
                        );
                      },
                      child: Text(
                        'Sign up',
                        style: TextStyle(color: AppPallete.primaryColor),
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

  // void _handleLogin() {
  //   if (_formKey.currentState!.validate()) {
  //     ref.read(authControllerProvider.notifier).signIn(
  //       _emailController.text.trim(),
  //       _passwordController.text.trim(),
  //     );
  //   }
  // }
}
