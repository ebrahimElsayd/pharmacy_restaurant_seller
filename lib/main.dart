import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pharmacy_restaurant_seller/core/constants/constants.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/comman/app_router/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // إعداد Supabase
  await Supabase.initialize(
    url: Constants.supabaseUrl,
    anonKey: Constants.supabaseKey,
  );

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({Key? key}) : super(key: key);

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
      designSize: const Size(360, 690), // الحجم اللي صممت عليه
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp.router(
          title: 'تطبيق إعادة تعيين كلمة المرور',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
            fontFamily: 'Arial', // يمكنك تغيير هذا حسب الخط المطلوب
            appBarTheme: AppBarTheme(
              backgroundColor: Colors.transparent,
              elevation: 0,
              iconTheme: const IconThemeData(color: Colors.black),
              titleTextStyle: TextStyle(
                color: Colors.black,
                fontSize: 20.sp, // استخدام ScreenUtil للحجم
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          routerConfig: router,
        );
      },
    );
  }
}

// مثال على شاشة رئيسية للتأكد من أن ScreenUtil يعمل بشكل صحيح
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Responsive UI',
          style: TextStyle(fontSize: 20.sp), // حجم الخط يتناسب مع الشاشة
        ),
      ),
      body: Center(
        child: Container(
          width: 200.w, // العرض يتناسب مع الشاشة
          height: 100.h, // الطول يتناسب مع الشاشة
          color: Colors.amber,
          alignment: Alignment.center,
          child: Text('Hello!', style: TextStyle(fontSize: 24.sp)),
        ),
      ),
    );
  }
}
