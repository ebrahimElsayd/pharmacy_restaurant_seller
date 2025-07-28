import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../riverpods/auth_providers.dart';

final authControllerProvider = Provider.family<AuthController, BuildContext>((ref, context) {
  return AuthController(ref as WidgetRef, context);
});

class AuthController {
  final WidgetRef ref;
  final BuildContext context;

  AuthController(this.ref, this.context);

  Future<void> login({
    required String email,
    required String password,
  }) async {
    await ref.read(authNotifierProvider.notifier).login(email, password);
  }

  Future<void> register({
    required String email,
    required String password,
    required String fullName,
    String? phoneNumber,
  }) async {
    await ref.read(authNotifierProvider.notifier).register(
      email,
      password,
      fullName,
      phoneNumber: phoneNumber,
    );
  }

  Future<void> forgotPassword({required String email}) async {
    await ref.read(authNotifierProvider.notifier).forgotPassword(email);
  }

  Future<void> updatePassword({
    required String newPassword,
    String token = '',
  }) async {
    await ref.read(authNotifierProvider.notifier).updatePassword(newPassword);
  }

  Future<void> signOut() async {
    await ref.read(authNotifierProvider.notifier).signOut();
  }

  String? validateEmail(String? email) {
    if (email == null || email.trim().isEmpty) {
      return 'Please enter your email';
    }
    if (!RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email.trim())) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return 'Please enter a password';
    }
    if (password.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  String? validateName(String? name) {
    if (name == null || name.trim().isEmpty) {
      return 'Please enter your name';
    }
    if (name.trim().length < 2) {
      return 'Name must be at least 2 characters';
    }
    return null;
  }
}
