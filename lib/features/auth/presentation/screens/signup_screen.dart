import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharmacy_restaurant_seller/core/theme/app_pallete.dart';
import 'package:pharmacy_restaurant_seller/core/theme/font_weight_helper.dart';
import 'package:pharmacy_restaurant_seller/core/theme/values_manager.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_password_field.dart';
import '../widgets/custom_text_field.dart';
import 'login_screen.dart';

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

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
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
          padding:  EdgeInsets.all(AppPadding.p24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SvgPicture.asset(
                  'assets/svgs/logo.svg',
                  height: AppSize.s40,
                  width: AppSize.s40,
                ),
                 SizedBox(height: AppSize.s20),

                Center(
                  child: Text(
                    'Sign Up',
                    style: TextStyle(
                      fontSize: FontSize.s32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                 SizedBox(height: AppSize.s8),
                Center(
                  child: Text(
                    'Create your account',
                    style: TextStyle(
                      fontSize: FontSize.s16,
                      color: AppPallete.greyColor,
                    ),
                  ),
                ),

                Center(
                  child: Image.asset('assets/images/login_signup_avatar.png'),
                ),

                CustomTextField(
                  controller: _nameController,
                  hintText: 'Full Name',
                  icon: Icons.person_outline,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your full name';
                    }
                    return null;
                  },
                ),
                 SizedBox(height: AppSize.s16),

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
                      return 'Please enter a password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                 SizedBox(height: AppSize.s16),

                CustomPasswordField(
                  controller: _confirmPasswordController,
                  hintText: 'Confirm Password',
                  icon: Icons.lock_outline,
                  obscureText: _obscureConfirmPassword,
                  onToggleVisibility:
                      () => setState(
                        () =>
                            _obscureConfirmPassword = !_obscureConfirmPassword,
                      ),
                  validator: (value) {
                    if (value != _passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
                 SizedBox(height: AppSize.s24),

                CustomButton(
                  text: 'Sign up',
                  // isLoading: authState.isLoading,
                  onPressed: () {},
                  // onPressed: authState.isLoading ? null : _handleSignUp,
                ),
                 SizedBox(height: AppSize.s24),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account?',
                      style: TextStyle(color: AppPallete.greyColor),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                        );
                      },
                      child: Text(
                        'Login',
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

  // void _handleSignUp() {
  //   if (_formKey.currentState!.validate()) {
  //     ref.read(authControllerProvider.notifier).signUp(
  //           name: _nameController.text.trim(),
  //           email: _emailController.text.trim(),
  //           password: _passwordController.text.trim(),
  //         );
  //   }
  // }
}
