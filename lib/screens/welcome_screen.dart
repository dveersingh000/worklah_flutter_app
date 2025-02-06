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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: Column(
        children: [
          SizedBox(height: commonHeight(context) * 0.05),
          Center(child: Image.asset(ImagePath.appLogo)),
          Center(
            child: SizedBox(
              height: commonHeight(context) * 0.5.h,
              width: double.infinity,
              child: Image.asset(
                ImagePath.welcomeIMG,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Spacer(),
          Text(
            'Login to your account',
            style: CustomTextInter.medium16(AppColors.blackColor),
          ),
          SizedBox(height: 20.h),
          Padding(
            padding: EdgeInsets.only(left: 20.w, right: 20.w),
            child: CustomButton(
              onTap: () {
                moveToNext(context, LoginScreen());
              },
              text: 'Log In',
            ),
          ),
          SizedBox(height: 10.h),
          RichText(
            text: TextSpan(
              children: <TextSpan>[
                TextSpan(
                  text: 'Don\'t have an account? ',
                  style: CustomTextInter.regular12(AppColors.blackColor),
                ),
                TextSpan(
                  text: 'Create an Account',
                  style: CustomTextInter.semiBold12(
                    AppColors.themeColor,
                    isUnderline: true,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () async {
                      moveToNext(context, RegisterScreen());
                    },
                ),
              ],
            ),
          ),
          SizedBox(height: commonHeight(context) * 0.08),
        ],
      ),
    );
  }
}
