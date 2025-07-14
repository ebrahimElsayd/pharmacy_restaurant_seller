import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../riverpods/auth_providers.dart';
import '../riverpods/auth_state.dart';

class AuthController {
  final WidgetRef ref;
  final BuildContext context;

  AuthController(this.ref, this.context);

  // Login Controller
  Future<void> login({required String email, required String password}) async {
    try {
      await ref.read(authNotifierProvider.notifier).login(email, password);

      // Listen for auth state changes
      ref.listen<AuthState>(authStateProvider, (previous, next) {
        if (next == AuthState.authenticated) {
          // Navigator.pushReplacementNamed(context, '/home');
        } else if (next == AuthState.error) {
          _showErrorSnackBar(ref.read(errorMessageProvider));
        }
      });
    } catch (e) {
      _showErrorSnackBar(e.toString());
    }
  }

  // Register Controller
  Future<void> register({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      await ref
          .read(authNotifierProvider.notifier)
          .register(email, password, name);

      ref.listen<AuthState>(authStateProvider, (previous, next) {
        if (next == AuthState.unauthenticated &&
            ref.read(errorMessageProvider) == null) {
          // Registration successful, navigate to verification
          // Navigator.pushNamed(context, '/verification', arguments: email);
          _showSuccessSnackBar(
            'Registration successful! Please check your email for verification.',
          );
        } else if (next == AuthState.error) {
          _showErrorSnackBar(ref.read(errorMessageProvider));
        }
      });
    } catch (e) {
      _showErrorSnackBar(e.toString());
    }
  }

  // Forgot Password Controller
  Future<void> forgotPassword({required String email}) async {
    try {
      await ref.read(authNotifierProvider.notifier).forgotPassword(email);

      // Check if operation was successful
      if (ref.read(errorMessageProvider) == null) {
        // Navigator.pushNamed(context, '/verification', arguments: email);
        _showSuccessSnackBar(
          'Password reset email sent! Please check your inbox.',
        );
      } else {
        _showErrorSnackBar(ref.read(errorMessageProvider));
      }
    } catch (e) {
      _showErrorSnackBar(e.toString());
    }
  }

  // Email Verification Controller
  Future<void> verifyEmail({
    required String email,
    required String code,
  }) async {
    try {
      await ref.read(authNotifierProvider.notifier).verifyEmail(email, code);

      ref.listen<AuthState>(authStateProvider, (previous, next) {
        if (next == AuthState.authenticated) {
          Navigator.pushReplacementNamed(context, '/home');
          _showSuccessSnackBar('Email verified successfully!');
        } else if (next == AuthState.error) {
          _showErrorSnackBar(ref.read(errorMessageProvider));
        }
      });
    } catch (e) {
      _showErrorSnackBar(e.toString());
    }
  }

  // Update Password Controller
  Future<void> updatePassword({
    required String newPassword,
    required String token,
  }) async {
    try {
      await ref
          .read(authNotifierProvider.notifier)
          .updatePassword(newPassword, token);

      // Check if operation was successful
      if (ref.read(errorMessageProvider) == null) {
        Navigator.pushReplacementNamed(context, '/login');
        _showSuccessSnackBar(
          'Password updated successfully! Please login with your new password.',
        );
      } else {
        _showErrorSnackBar(ref.read(errorMessageProvider));
      }
    } catch (e) {
      _showErrorSnackBar(e.toString());
    }
  }

  // Logout Controller
  Future<void> logout() async {
    try {
      await ref.read(authNotifierProvider.notifier).logout();
      Navigator.pushReplacementNamed(context, '/login');
      _showSuccessSnackBar('Logged out successfully!');
    } catch (e) {
      _showErrorSnackBar(e.toString());
    }
  }

  // Resend Verification Code
  Future<void> resendVerificationCode({required String email}) async {
    try {
      // await ref.read(authNotifierProvider.notifier).verifyEmail(email);

      if (ref.read(errorMessageProvider) == null) {
        _showSuccessSnackBar(
          'Verification code resent! Please check your email.',
        );
      } else {
        _showErrorSnackBar(ref.read(errorMessageProvider));
      }
    } catch (e) {
      _showErrorSnackBar(e.toString());
    }
  }

  // Get current user
  // void getCurrentUser() {
  //   ref.read(authNotifierProvider.notifier).getCurrentUser();
  // }

  // Check if user is authenticated
  bool get isAuthenticated => ref.read(isAuthenticatedProvider);

  // Check if loading
  bool get isLoading => ref.read(isLoadingProvider);

  // Get current user
  get currentUser => ref.read(currentUserProvider);

  // Get auth state
  AuthState get authState => ref.read(authStateProvider);

  // Get error message
  String? get errorMessage => ref.read(errorMessageProvider);

  // Private helper methods
  void _showErrorSnackBar(String? message) {
    if (message != null && message.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  // Clear error message
  void clearError() {
    ref.read(authNotifierProvider.notifier).clearError();
  }

  // Form validation helpers
  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name is required';
    }
    if (value.length < 2) {
      return 'Name must be at least 2 characters';
    }
    return null;
  }

  String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != password) {
      return 'Passwords do not match';
    }
    return null;
  }

  String? validateOTP(String? value) {
    if (value == null || value.isEmpty) {
      return 'Verification code is required';
    }
    if (value.length != 6) {
      return 'Verification code must be 6 digits';
    }
    if (!RegExp(r'^\d{6}$').hasMatch(value)) {
      return 'Verification code must contain only numbers';
    }
    return null;
  }
}
