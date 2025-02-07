// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously

import 'dart:developer';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:work_lah/data/send_request.dart';
import 'package:work_lah/screens/login_screen.dart';
import 'package:work_lah/utility/colors.dart';
import 'package:work_lah/utility/custom_button.dart';
import 'package:work_lah/utility/custom_otp_field.dart';
import 'package:work_lah/utility/custom_textform_field.dart';
import 'package:work_lah/utility/display_function.dart';
import 'package:work_lah/utility/image_path.dart';
import 'package:work_lah/utility/style_inter.dart';
import 'dart:async'; // Import for Timer

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController dropDownController = TextEditingController();
  TextEditingController otpControllers = TextEditingController();
  TextEditingController countryController = TextEditingController(text: '+65');

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

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

    String phoneData = countryController.text + phoneController.text;

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
      log('Error during Res: $e');
      final errorMessage = e is Map ? e['message'] : 'An error occurred';
      toast(errorMessage);
      setState(() {
        isGenerateOTPLoading = false;
        isContinueDisable = true;
      });
    }
  }

  void onVerifyOTP() async {
    setState(() {
      isContinueLoading = true;
    });
    String phoneData = countryController.text + phoneController.text;

    final Map<String, dynamic> registerData = {
      "fullName": nameController.text,
      "phoneNumber": phoneData,
      "email": emailController.text,
      "employmentStatus": dropDownController.text,
      "otp": otpControllers.text,
    };
    try {
      var response = await ApiProvider()
          .postRequest(apiUrl: '/api/auth/register', data: registerData);
      toast(response['message']);
      setState(() {
        isContinueLoading = false;
      });
      moveReplacePage(context, LoginScreen());
    } catch (e) {
      log('Error during Res: $e');
      final errorMessage = e is Map ? e['message'] : 'An error occurred';
      toast(errorMessage);
      setState(() {
        isContinueLoading = false;
        isContinueDisable = true;
        otpControllers.clear();
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
    String phoneData = countryController.text + phoneController.text;

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
      log('Error during Res: $e');
      final errorMessage = e is Map ? e['message'] : 'An error occurred';
      toast(errorMessage);
      setState(() {
        isResendLoading = false;
        isContinueDisable = true;
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
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: commonHeight(context) * 0.03),
                        Center(
                          child: Text(
                            'Create an Account',
                            style:
                                CustomTextInter.medium24(AppColors.blackColor),
                          ),
                        ),
                        SizedBox(height: commonHeight(context) * 0.03),
                        commonTitle('Full Name (As per NRIC)'),
                        SizedBox(height: 10.h),
                        CustomTextFormField(
                          controller: nameController,
                          hintText: 'Steve Ryan',
                          onValidate: (v) {
                            if (v!.isEmpty) {
                              return 'Please Enter Full Name';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 20.h),
                        commonTitle('Phone Number'),
                        SizedBox(height: 10.h),
                        Row(
                          children: [
                            Expanded(
                              child: CustomTextFormField(
                                controller: countryController,
                                isDropdown: true,
                                dropdownItems: [
                                  '+65',
                                  '+91',
                                  '+70',
                                ],
                                hintText: 'Country',
                              ),
                            ),
                            SizedBox(width: 10.w),
                            Expanded(
                              flex: 2,
                              child: CustomTextFormField(
                                controller: phoneController,
                                textInputType: TextInputType.phone,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                hintText: '+65 1234567892',
                                onValidate: (v) {
                                  if (v!.isEmpty) {
                                    return 'Please Enter Phone Number';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20.h),
                        commonTitle('Email'),
                        SizedBox(height: 10.h),
                        CustomTextFormField(
                          controller: emailController,
                          hintText: 'axrt@gmail.com',
                          onValidate: (v) {
                            if (v!.isEmpty) {
                              return 'Please Enter Email';
                            } else if (!emailController.text.contains("@")) {
                              return 'Please enter valid email';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 20.h),
                        commonTitle('Employment Status'),
                        SizedBox(height: 10.h),
                        CustomTextFormField(
                          controller: dropDownController,
                          isDropdown: true,
                          dropdownItems: ['PR', 'LTVP', 'Student'],
                          hintText: 'Select Employment Status',
                          onValidate: (value) {
                            if (dropDownController.text.isEmpty) {
                              return 'Please Select Employment Status';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 50.h),
                        CustomButton(
                          isDisable: !isContinueDisable,
                          isLoading: isGenerateOTPLoading,
                          backgroundColor: AppColors.blackColor,
                          onTap: () {
                            if (formKey.currentState!.validate()) {
                              onGenerateOTP();
                            }
                          },
                          text: 'Generate OTP',
                        ),
                        SizedBox(height: 20.h),
                        Text(
                          'OTP',
                          style: CustomTextInter.medium16(AppColors.blackColor),
                        ),
                        SizedBox(height: 5.h),
                        Text(
                          'Please enter your 6 digit SMS OTP',
                          style:
                              CustomTextInter.light12(AppColors.subTitleColor),
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
                                          ? AppColors.textGreyColor // Disable color
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
                            style: CustomTextInter.medium12(AppColors.blackColor),
                          ),
                          ],
                        ),
                        SizedBox(height: 50.h),
                        CustomButton(
                          isDisable: isContinueDisable,
                          isLoading: isContinueLoading,
                          onTap: () {
                            if (otpControllers.text.length < 6) {
                              toast('Please Enter OTP');
                            } else {
                              onVerifyOTP();
                            }
                          },
                          text: 'Continue',
                        ),
                        SizedBox(height: 10.h),
                        Center(
                          child: RichText(
                            text: TextSpan(
                              children: <TextSpan>[
                                TextSpan(
                                  text: 'Already have an account? ',
                                  style: CustomTextInter.regular12(
                                      AppColors.blackColor),
                                ),
                                TextSpan(
                                  text: 'Log In',
                                  style: CustomTextInter.semiBold12(
                                    AppColors.themeColor,
                                    isUnderline: true,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () async {
                                      moveReplacePage(context, LoginScreen());
                                    },
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 20.h),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget commonTitle(String title) {
    return RichText(
      text: TextSpan(
        children: <TextSpan>[
          TextSpan(
            text: title,
            style: CustomTextInter.medium12(AppColors.fieldTitleColor),
          ),
          TextSpan(
            text: '*',
            style: CustomTextInter.medium12(AppColors.redColor),
          ),
        ],
      ),
    );
  }
}
