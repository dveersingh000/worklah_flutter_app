// ignore_for_file: prefer_const_constructors

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:work_lah/screens/login_screen.dart';
import 'package:work_lah/screens/register_screen.dart';
import 'package:work_lah/utility/colors.dart';
import 'package:work_lah/utility/custom_button.dart';
import 'package:work_lah/utility/display_function.dart';
import 'package:work_lah/utility/image_path.dart';
import 'package:work_lah/utility/style_inter.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  bool isHovered = false; // State to track hover

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SingleChildScrollView(  // ✅ Allows scrolling to prevent overflow
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: commonHeight(context) * 0.05),

            // App Logo
            Center(child: Image.asset(ImagePath.appLogo)),

            // Welcome Image (Now wrapped inside a ConstrainedBox for responsiveness)
            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: commonHeight(context) * 0.4, // ✅ Adjust max height
              ),
              child: Image.asset(
                ImagePath.welcomeIMG,
                fit: BoxFit.cover,
              ),
            ),

            SizedBox(height: 20.h), // ✅ Replaces Spacer()

            // Sign In Text
            Text(
              'Sign in to your account',
              style: CustomTextInter.medium16(AppColors.blackColor),
            ),

            SizedBox(height: 30.h),

            // Sign In and Create Account Buttons
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                children: [
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    onEnter: (_) => setState(() => isHovered = true),
                    onExit: (_) => setState(() => isHovered = false),
                    child: CustomButton(
                      onTap: () {
                        moveToNext(context, LoginScreen());
                      },
                      text: 'Sign In',
                      backgroundColor: isHovered
                          ? AppColors.themeColor.withOpacity(0.7) // Hover effect
                          : AppColors.themeColor,
                    ),
                  ),

                  SizedBox(height: 30.h),

                  Text(
                    "Don't have an account?",
                    style: CustomTextInter.regular14(AppColors.blackColor),
                  ),

                  SizedBox(height: 10.h),

                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {
                        moveToNext(context, RegisterScreen());
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: AppColors.themeColor),
                        padding: EdgeInsets.symmetric(vertical: 18.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                      child: Text(
                        'Create Account',
                        style: CustomTextInter.regular14(AppColors.themeColor),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 40.h), // ✅ Adjusted bottom spacing
          ],
        ),
      ),
    );
  }
}
