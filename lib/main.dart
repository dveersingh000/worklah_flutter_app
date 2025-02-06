// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:work_lah/screens/splash_screen.dart';

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
            debugShowCheckedModeBanner: false,
            title: 'Work Lah',
            home: SplashScreen(),
          ),
        );
      },
    ),
  );
}

//Current Flutter Version :- 3.24.3
//Build AppBundle [release] :- flutter build appbunle --release
//Build Apk [release] :- flutter build apk --release
