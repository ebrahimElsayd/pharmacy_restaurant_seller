
import '../constants/constants.dart';

class Validators {
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your email address';
    }

    final emailRegex = RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$');

    if (!emailRegex.hasMatch(value.trim())) {
      return 'Email address is invalid';
    }

    return null;
  }


  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'كلمة المرور مطلوبة';
    }

    if (value.length < Constants.minPasswordLength) {
      return 'كلمة المرور يجب أن تحتوي على ${Constants.minPasswordLength} أحرف على الأقل';
    }

    if (value.length > Constants.maxPasswordLength) {
      return 'كلمة المرور طويلة جداً';
    }

    if (!Constants.passwordRegex.hasMatch(value)) {
      return 'كلمة المرور يجب أن تحتوي على:\n• حرف كبير\n• حرف صغير\n• رقم\n• رمز خاص';
    }

    return null;
  }

  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'الاسم مطلوب';
    }

    if (value.length < 2) {
      return 'الاسم يجب أن يحتوي على حرفين على الأقل';
    }

    if (value.length > Constants.maxNameLength) {
      return 'الاسم طويل جداً';
    }

    if (!Constants.nameRegex.hasMatch(value)) {
      return 'الاسم يجب أن يحتوي على حروف فقط';
    }

    return null;
  }

  static String? validateConfirmPassword(String? value, String? password) {
    if (value == null || value.isEmpty) {
      return 'تأكيد كلمة المرور مطلوب';
    }

    if (value != password) {
      return 'كلمتا المرور غير متطابقتين';
    }

    return null;
  }

  static String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'رقم الهاتف مطلوب';
    }

    final phoneRegex = RegExp(r'^[+]?[0-9]{10,15}$');
    if (!phoneRegex.hasMatch(value)) {
      return 'رقم الهاتف غير صحيح';
    }

    return null;
  }

  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName مطلوب';
    }

    return null;
  }

  static bool isValidEmail(String email) {
    return Constants.emailRegex.hasMatch(email);
  }

  static bool isValidPassword(String password) {
    return password.length >= Constants.minPasswordLength &&
        password.length <= Constants.maxPasswordLength &&
        Constants.passwordRegex.hasMatch(password);
  }

  static bool isValidName(String name) {
    return name.length >= 2 &&
        name.length <= Constants.maxNameLength &&
        Constants.nameRegex.hasMatch(name);
  }

  static String getPasswordStrength(String password) {
    if (password.length < 4) return 'ضعيفة جداً';
    if (password.length < 8) return 'ضعيفة';

    int strength = 0;

    // Check for lowercase
    if (password.contains(RegExp(r'[a-z]'))) strength++;

    // Check for uppercase
    if (password.contains(RegExp(r'[A-Z]'))) strength++;

    // Check for numbers
    if (password.contains(RegExp(r'[0-9]'))) strength++;

    // Check for special characters
    if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) strength++;

    switch (strength) {
      case 0:
      case 1:
        return 'ضعيفة';
      case 2:
        return 'متوسطة';
      case 3:
        return 'قوية';
      case 4:
        return 'قوية جداً';
      default:
        return 'ضعيفة';
    }
  }
}