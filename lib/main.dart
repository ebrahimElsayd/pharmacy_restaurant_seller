
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pharmacy_restaurant_seller/core/constants/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/comman/app_router/app_router.dart';
import 'core/theme/app_pallete.dart';
import 'core/theme/font_weight_helper.dart';
import 'core/theme/values_manager.dart';
import 'features/auth/presentation/riverpods/auth_providers.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // إعداد Supabase
  await Supabase.initialize(
    url: Constants.supabaseUrl,
    anonKey: Constants.supabaseKey,
  );
  final sharedPreferences = await SharedPreferences.getInstance();

  runApp(ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(sharedPreferences),
      ],      child: const MyApp()
  )
  );
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  void initState() {
    super.initState();
    _handleAuthStateChanges();
  }

  void _handleAuthStateChanges() {
    // الاستماع لتغييرات المصادقة للتعامل مع Deep Links
    Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      final event = data.event;
      final router = ref.read(appRouterProvider);

      if (event == AuthChangeEvent.passwordRecovery) {
        // التوجيه لشاشة إعادة تعيين كلمة المرور عند الضغط على الرابط
        router.go('/reset-password');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(appRouterProvider);

    return ScreenUtilInit(
      designSize: const Size(375, 812), // ✅ تحديث حسب تصميمك
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp.router(
          title: 'تطبيق البائع',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: AppPallete.primaryColor, // ✅ استخدام لونك الأساسي
              brightness: Brightness.light,
            ),
            appBarTheme: AppBarTheme(
              backgroundColor: AppPallete.white, // ✅ استخدام ألوانك
              elevation: 0,
              centerTitle: true,
              iconTheme: IconThemeData(color: AppPallete.blackForText),
              titleTextStyle: TextStyle(
                color: AppPallete.blackForText,
                fontSize: FontSize.s20, // ✅ استخدام حجم الخط الخاص بك
                fontWeight: FontWeight.bold,
              ),
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppPallete.primaryColor, // ✅ زر أساسي بلونك
                foregroundColor: AppPallete.white,
                padding: EdgeInsets.symmetric(
                  horizontal: ValuesManager.paddingLarge,
                  vertical: ValuesManager.paddingMedium,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(ValuesManager.borderRadius),
                ),
              ),
            ),
            inputDecorationTheme: InputDecorationTheme(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(ValuesManager.borderRadius),
                borderSide: BorderSide(color: AppPallete.borderColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(ValuesManager.borderRadius),
                borderSide: BorderSide(color: AppPallete.primaryColor),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(ValuesManager.borderRadius),
                borderSide: BorderSide(color: AppPallete.borderColor),
              ),
            ),
          ),
          routerConfig: router,
        );
      },
    );
  }
}

// مثال على شاشة رئيسية للتأكد من أن كل شيء يعمل
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'الشاشة الرئيسية',
          style: TextStyle(fontSize: FontSize.s20),
        ),
      ),
      body: Center(
        child: Container(
          width: 200.w,
          height: 100.h,
          padding: EdgeInsets.all(ValuesManager.paddingMedium),
          decoration: BoxDecoration(
            color: AppPallete.primaryColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(ValuesManager.borderRadiusLarge),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'مرحباً بك!',
                style: TextStyle(
                  fontSize: FontSize.s24,
                  fontWeight: FontWeight.bold,
                  color: AppPallete.primaryColor,
                ),
              ),
              SizedBox(height: ValuesManager.marginMedium),
              Text(
                'هذا تطبيق البائع',
                style: TextStyle(
                  fontSize: FontSize.s16,
                  color: AppPallete.lightGreyForText,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}