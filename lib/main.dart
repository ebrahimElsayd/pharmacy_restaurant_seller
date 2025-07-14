import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'features/auth/presentation/screens/signup_screen.dart';

void main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  // await Supabase.initialize(
  //   url: 'YOUR_SUPABASE_URL',
  //   anonKey: 'YOUR_SUPABASE_ANON_KEY',
  // );

  runApp(
    // const ProviderScope(
    // child:
    MyApp(),
    // ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690), // الحجم اللي صممت عليه
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'ScreenUtil Demo',
          theme: ThemeData(primarySwatch: Colors.blue),
          home: const SignUpScreen(),
        );
      },
    );
  }
}

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
          width: 200.w,
          // العرض يتناسب مع الشاشة
          height: 100.h,
          // الطول يتناسب مع الشاشة
          color: Colors.amber,
          alignment: Alignment.center,
          child: Text('Hello!', style: TextStyle(fontSize: 24.sp)),
        ),
      ),
    );
  }
}
