// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:work_lah/screens/login_screen.dart';
import 'package:work_lah/screens/register_screen.dart';
import 'package:work_lah/utility/colors.dart';
import 'package:work_lah/utility/custom_button.dart';
import 'package:work_lah/utility/display_function.dart';
import 'package:work_lah/utility/image_path.dart';
import 'package:work_lah/utility/style_inter.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: commonHeight(context) * 0.05),

            // App Logo
            SizedBox(
              height: 80.h,
              child: Center(
                child: Image.asset(ImagePath.appLogo),
              ),
            ),

            // Welcome Image
            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: commonHeight(context) * 0.4,
              ),
              child: Image.asset(
                ImagePath.welcomeIMG,
                fit: BoxFit.cover,
              ),
            ),

            SizedBox(height: 20.h),

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
                  CustomButton(
                    onTap: () {
                      moveToNext(context, LoginScreen());
                    },
                    text: 'Sign In',
                    backgroundColor: AppColors.themeColor,
                  ),

                  SizedBox(height: 30.h),

                  Text(
                    "Don't have an account?",
                    style: CustomTextInter.regular14(AppColors.blackColor),
                  ),

                  SizedBox(height: 10.h),

                  CustomButton(
                    onTap: () {
                      moveToNext(context, RegisterScreen());
                    },
                    text: 'Create Account',
                    backgroundColor: AppColors.whiteColor,
                    textStyle: CustomTextInter.regular14(AppColors.themeColor),
                    borderColor: AppColors.themeColor,
                  ),
                ],
              ),
            ),

            SizedBox(height: 40.h),
          ],
        ),
      ),
    );
  }
}
