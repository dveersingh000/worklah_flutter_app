// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, deprecated_member_use

import 'dart:developer';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:work_lah/data/send_request.dart';
import 'package:work_lah/screens/bottombar/bottom_bar_screen.dart';
import 'package:work_lah/screens/register_screen.dart';
import 'package:work_lah/utility/colors.dart';
import 'package:work_lah/utility/custom_button.dart';
import 'package:work_lah/utility/custom_otp_field.dart';
import 'package:work_lah/utility/display_function.dart';
import 'package:work_lah/utility/image_path.dart';
import 'package:work_lah/utility/shared_prefs.dart';
import 'package:work_lah/utility/style_inter.dart';

import 'dart:async'; // Import for Timer

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isHovered = false; // State to track hover
  bool isOtpHovered = false;
  List<Map<String, String>> countryCodes = [
    {'code': '+65', 'flag': ImagePath.singaporeFlag}, // Singapore
    {
      'code': '+60',
      'flag': ImagePath.singaporeFlag
    }, // Malaysia (Assuming you add this in ImagePath)
    {'code': '+91', 'flag': ImagePath.indiaFlag}, // India
  ];
  String selectedCode = '+65';

  TextEditingController otpControllers = TextEditingController();
  TextEditingController mobileControllers = TextEditingController();

  bool isContinueDisable = true;
  bool isGenerateOTPLoading = false;
  bool isContinueLoading = false;
  bool isResendLoading = false;

  int otpTimerSeconds = 60; // Timer duration
  Timer? otpTimer; // Timer instance
  bool isTimerRunning = false; // Flag to check timer status

  void startOTPTimer() {
    if (otpTimer != null) {
      otpTimer!.cancel(); // Cancel any existing timer
    }

    setState(() {
      otpTimerSeconds = 60; // Reset timer to 60 sec
      isTimerRunning = true;
    });

    otpTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (otpTimerSeconds > 0) {
        setState(() {
          otpTimerSeconds--;
        });
      } else {
        timer.cancel(); // Stop the timer when it reaches 0
        setState(() {
          isTimerRunning = false;
        });
      }
    });
  }

  void onGenerateOTP() async {
    setState(() {
      isGenerateOTPLoading = true;
    });

    String phoneData = selectedCode + mobileControllers.text;

    try {
      var response = await ApiProvider()
          .postRequest(apiUrl: '/api/auth/generate-otp', data: {
        "phoneNumber": phoneData,
      });
      toast(response['message']);
      setState(() {
        isGenerateOTPLoading = false;
        isContinueDisable = false;
      });
      startOTPTimer(); // Start timer after OTP request
    } catch (e) {
      log('Error during login: $e');
      final errorMessage = e is Map ? e['message'] : 'An error occurred';
      toast(errorMessage);
      setState(() {
        isGenerateOTPLoading = false;
        isContinueDisable = true;
      });
    }
  }

  void onResendOTP() async {
    if (isTimerRunning) return; // Prevent resending before timer ends
    setState(() {
      otpControllers.clear();
      isResendLoading = true;
      isContinueDisable = false;
    });
    String phoneData = selectedCode + mobileControllers.text;

    try {
      var response = await ApiProvider()
          .postRequest(apiUrl: '/api/auth/resend-otp', data: {
        "phoneNumber": phoneData,
      });
      toast(response['message']);
      setState(() {
        isResendLoading = false;
        isContinueDisable = false;
      });
      startOTPTimer(); // Restart timer when OTP is resent
    } catch (e) {
      log('Error during login: $e');
      final errorMessage = e is Map ? e['message'] : 'An error occurred';
      toast(errorMessage);
      setState(() {
        isResendLoading = false;
        isContinueDisable = true;
      });
    }
  }

  void onVerifyOTP() async {
    setState(() {
      isContinueLoading = true;
    });
    String phoneData = selectedCode + mobileControllers.text;
    // String phoneData = mobileControllers.text;

    final Map<String, dynamic> registerData = {
      "phoneNumber": phoneData,
      "otp": otpControllers.text,
    };
    try {
      var response = await ApiProvider()
          .postRequest(apiUrl: '/api/auth/login', data: registerData);
      toast(response['message']);
      setState(() {
        isContinueLoading = false;
      });
      await setLogin(phoneData);
      await setLoginToken(response['token']);
      await saveUserData(response['user']);
      moveReplacePage(context, BottomBarScreen(index: 0));
    } catch (e) {
      log('Error during login: $e');
      final errorMessage = e is Map ? e['message'] : 'An error occurred';
      toast(errorMessage);
      setState(() {
        isContinueDisable = true;
        isContinueLoading = false;
        otpControllers.clear();
      });
    }
  }

  @override
  void dispose() {
    otpTimer?.cancel(); // Cancel timer when widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.themeColor,
      body: Column(
        children: [
          SizedBox(height: commonHeight(context) * 0.05),
          Center(child: Image.asset(ImagePath.appLogo)),
          SizedBox(height: commonHeight(context) * 0.02),
          Expanded(
            child: Container(
              height: double.infinity,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                color: AppColors.whiteColor,
              ),
              child: Padding(
                padding: EdgeInsets.only(left: 20.w, right: 20.w),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: commonHeight(context) * 0.03),
                      Center(
                        child: Text(
                          'Sign In',
                          style: CustomTextInter.medium24(AppColors.blackColor),
                        ),
                      ),
                      SizedBox(height: commonHeight(context) * 0.03),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Sign in using your mobile number',
                            style:
                                CustomTextInter.medium16(AppColors.blackColor),
                          ),
                          SizedBox(width: 5.w), // Space between text and icon
                          Tooltip(
                            message:
                                'Please confirm your country code and enter your mobile number',
                            child: Icon(Icons.info_outline,
                                color: AppColors.subTitleColor, size: 18),
                          ),
                        ],
                      ),
                      SizedBox(height: 20.h),
                      Text(
                        'Country code',
                        style:
                            CustomTextInter.regular14(AppColors.textGreyColor),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment
                            .end, // Aligns the underline properly
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  dropdownColor: AppColors.whiteColor,
                                  value: selectedCode,
                                  onChanged: (newValue) {
                                    setState(() {
                                      selectedCode = newValue!;
                                    });
                                  },
                                  items: countryCodes.map((item) {
                                    return DropdownMenuItem(
                                      value: item['code'],
                                      child: Row(
                                        children: [
                                          Image.asset(
                                            item['flag']!,
                                            width: 24,
                                            height: 16,
                                            fit: BoxFit.contain,
                                          ),
                                          SizedBox(width: 5),
                                          Text(item['code']!), // Country code
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                              Container(
                                height: 1,
                                width:
                                    70, // Adjust width to match dropdown width
                                color: Color(0XFFC9C9C9),
                              ),
                            ],
                          ),
                          SizedBox(width: 20.w),
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextFormField(
                                  controller: mobileControllers,
                                  cursorColor: AppColors.subTitleColor,
                                  style: CustomTextInter.regular14(
                                      AppColors.blackColor),
                                  keyboardType: TextInputType.number,
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Please Enter Mobile No';
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    hintText: 'Mobile number',
                                    hintStyle: CustomTextInter.light14(
                                        AppColors.subTitleColor),
                                    border: InputBorder
                                        .none, // Remove default underline
                                  ),
                                ),
                                Container(
                                  height: 1,
                                  width: double.infinity,
                                  color: Color(0XFFC9C9C9),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 20.h),
                      MouseRegion(
                        onEnter: (_) => setState(() => isOtpHovered = true),
                        onExit: (_) => setState(() => isOtpHovered = false),
                        child: CustomButton(
                          isDisable: false, // Allow clicking
                          isLoading: isGenerateOTPLoading,
                          backgroundColor: isGenerateOTPLoading
                              ? AppColors.blackColor
                                  .withOpacity(0.5) // Dimmed when loading
                              : isOtpHovered
                                  ? AppColors.blackColor
                                      .withOpacity(0.8) // Darken on hover
                                  : AppColors.blackColor, // Normal color
                          onTap: () {
                            if (mobileControllers.text.isEmpty) {
                              toast('Please Enter Mobile No');
                            } else {
                              onGenerateOTP();
                            }
                          },
                          text: 'Generate OTP',
                        ),
                      ),
                      SizedBox(height: 20.h),
                      Text(
                        'OTP',
                        style: CustomTextInter.medium16(AppColors.blackColor),
                      ),
                      SizedBox(height: 5.h),
                      Text(
                        'Please enter your 6 digit SMS OTP',
                        style: CustomTextInter.light12(AppColors.subTitleColor),
                      ),
                      SizedBox(height: 20.h),
                      CustomOtpField(
                        controller: otpControllers,
                        onValidate: (val) {
                          if (val.toString().isEmpty) {
                            return 'Please Enter Pin';
                          } else if (val.toString().length < 5) {
                            return 'Please Enter Valid Pin';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 10.h),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: isTimerRunning
                                ? null // Disable if timer is running
                                : () {
                                    onResendOTP();
                                  },
                            child: isResendLoading
                                ? Padding(
                                    padding: EdgeInsets.only(left: 10.w),
                                    child: SizedBox(
                                      height: 20.h,
                                      width: 20.w,
                                      child: CircularProgressIndicator(
                                        color: AppColors.themeColor,
                                      ),
                                    ),
                                  )
                                : Text(
                                    'Resend the code',
                                    style: CustomTextInter.light12(
                                      isTimerRunning
                                          ? AppColors
                                              .textGreyColor // Disable color
                                          : AppColors.themeColor,
                                      isUnderline: true,
                                    ),
                                  ),
                          ),
                          Spacer(),
                          Text(
                            isTimerRunning
                                ? '00:${otpTimerSeconds.toString().padLeft(2, '0')}'
                                : '', // Show countdown timer
                            style:
                                CustomTextInter.medium12(AppColors.blackColor),
                          ),
                        ],
                      ),
                      SizedBox(
                          height: 30.h), // Increased spacing between buttons
                      MouseRegion(
                        onEnter: (_) {
                          if (!isContinueDisable) {
                            setState(() => isHovered = true);
                          }
                        },
                        onExit: (_) {
                          if (!isContinueDisable) {
                            setState(() => isHovered = false);
                          }
                        },
                        child: Tooltip(
                          message:
                              isContinueDisable ? 'Generate OTP first' : '',
                          child: CustomButton(
                            isDisable: isContinueDisable,
                            isLoading: isContinueLoading,
                            backgroundColor: isContinueDisable
                                ? AppColors.themeColor
                                    .withOpacity(0.4) // Dimmed when disabled
                                : isHovered
                                    ? AppColors.themeColor
                                        .withOpacity(0.8) // Darken on hover
                                    : AppColors.themeColor,
                            onTap: () {
                              if (otpControllers.text.length < 6) {
                                toast('Please Enter OTP');
                              } else {
                                onVerifyOTP();
                              }
                            },
                            text: 'Sign In',
                          ),
                        ),
                      ),
                      SizedBox(height: 20.h), // Increased spacing for better UI
                      Center(
                        child: Column(
                          children: [
                            Text(
                              "Don't have an account?",
                              style: CustomTextInter.regular14(
                                  AppColors.blackColor),
                            ),
                            SizedBox(
                                height: 12.h), // Space between text and button
                            SizedBox(
                              width: double
                                  .infinity, // Match the Continue button width
                              child: OutlinedButton(
                                onPressed: () {
                                  moveToNext(context, RegisterScreen());
                                },
                                style: OutlinedButton.styleFrom(
                                  side: BorderSide(
                                      color:
                                          AppColors.themeColor), // Blue border
                                  padding: EdgeInsets.symmetric(
                                      vertical: 18.h), // Match button height
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                ),
                                child: Text(
                                  'Create Account',
                                  style: CustomTextInter.regular14(
                                      AppColors.themeColor),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                          height: 30
                              .h), // Additional spacing before the bottom of the page
                      // Additional spacing before bottom of the page

                      SizedBox(height: 20.h),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
