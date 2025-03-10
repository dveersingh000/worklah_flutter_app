// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:work_lah/screens/splash_screen.dart';

// ✅ Global Navigator Key for context access anywhere
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
void main() {
  runApp(
    ScreenUtilInit(
      designSize: Size(375, 812),
      useInheritedMediaQuery: true,
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return OverlaySupport(
          child: MaterialApp(
            navigatorKey: navigatorKey, // ✅ Assign Global Navigator Key
            debugShowCheckedModeBanner: false,
            title: 'Work Lah',
            home: SplashScreen(),
          ),
        );
      },
    ),
  );
}
// ✅ Global context variable
BuildContext get globalContext {
  if (navigatorKey.currentState?.mounted ?? false) {
    return navigatorKey.currentContext!;
  }
  throw Exception("Global context is not available");
}
//Current Flutter Version :- 3.24.3
//Build AppBundle [release] :- flutter build appbunle --release
//Build Apk [release] :- flutter build apk --release
