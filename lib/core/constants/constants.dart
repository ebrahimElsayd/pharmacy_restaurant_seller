class Constants {
  static const List<String> topics = [
    'Technology',
    'Business',
    'Programming',
    'Entertainment',
  ];

  static const noConnectionErrorMessage = 'Not connected to a network!';

  static const String supabaseUrl = 'https://gwzvpnetxlpqpjsemttw.supabase.co';
  static const String supabaseKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imd3enZwbmV0eGxwcXBqc2VtdHR3Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzE1NDMyNDMsImV4cCI6MjA0NzExOTI0M30.M_gXPVEvhH0z69l1VxMt7VwuybOZqQ2gAAnHC1ZMBn0';


  // Auth Settings
  static const int sessionTimeoutMinutes = 30;
  static const int maxLoginAttempts = 3;
  static const int lockoutDurationMinutes = 15;

  // Validation
  static const int minPasswordLength = 8;
  static const int maxPasswordLength = 128;
  static const int maxNameLength = 50;

  // Error Messages
  static const String networkError = 'خطأ في الاتصال بالإنترنت';
  static const String unknownError = 'حدث خطأ غير متوقع';
  static const String authError = 'خطأ في المصادقة';
  static const String validationError = 'خطأ في التحقق من البيانات';

  // Success Messages
  static const String signUpSuccess = 'تم إنشاء الحساب بنجاح';
  static const String signInSuccess = 'تم تسجيل الدخول بنجاح';
  static const String signOutSuccess = 'تم تسجيل الخروج بنجاح';
  static const String passwordResetSuccess = 'تم إرسال رابط استعادة كلمة المرور';

  // Routes
  static const String signInRoute = '/sign-in';
  static const String signUpRoute = '/sign-up';
  static const String forgotPasswordRoute = '/forgot-password';
  static const String emailVerificationRoute = '/email-verification';
  static const String homeRoute = '/home';
  static const String profileRoute = '/profile';

  // Regex Patterns
  static final RegExp emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  static final RegExp passwordRegex = RegExp(
    r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$',
  );

  static final RegExp nameRegex = RegExp(
    r'^[a-zA-Z\u0600-\u06FF\s]{2,50}$',
  );
}

