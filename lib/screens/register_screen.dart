// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously, deprecated_member_use

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
import 'package:url_launcher/url_launcher.dart';

class NameCapitalizationFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return newValue.copyWith(
      text: toTitleCase(newValue.text),
      selection: TextSelection.collapsed(offset: newValue.text.length),
    );
  }
}

String toTitleCase(String text) {
  if (text.isEmpty) return text;
  return text
      .split(' ')
      .map((word) => word.isNotEmpty
          ? '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}'
          : '')
      .join(' ');
}

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool isOtpHovered = false;
  List<Map<String, String>> countryCodes = [
    {'code': '+65', 'flag': ImagePath.singaporeFlag}, // Singapore
    {'code': '+60', 'flag': ImagePath.singaporeFlag}, // Malaysia
    {'code': '+91', 'flag': ImagePath.indiaFlag}, // India
  ];

  String selectedCode = '+65';
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

  void showWorkPassErrorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                ImagePath.warningIcon, // Use an appropriate warning icon
                width: 50,
                height: 50,
              ),
              SizedBox(height: 20.h),
              Text(
                "Apologies, but we are unable to proceed as you do not have a valid work pass for Singapore.",
                textAlign: TextAlign.center,
                style: CustomTextInter.medium16(AppColors.blackColor),
              ),
              SizedBox(height: 10.h),
              Text(
                "For more information, kindly visit MOM website:",
                textAlign: TextAlign.center,
                style: CustomTextInter.regular14(AppColors.textGreyColor),
              ),
              SizedBox(height: 5.h),
              GestureDetector(
                onTap: () {
                  launchUrl(
                      Uri.parse("https://www.mom.gov.sg/passes-and-permits"));
                },
                child: Text(
                  "https://www.mom.gov.sg/passes-and-permits",
                  style:
                      CustomTextInter.regular14(AppColors.themeColor).copyWith(
                    decoration: TextDecoration.underline,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 20.h),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.themeColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: Text(
                  "Close",
                  style: CustomTextInter.medium14(AppColors.whiteColor),
                ),
              ),
            ],
          ),
        );
      },
    );
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
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(
                                r"[a-zA-Z\s]")), // Allow only alphabets and spaces
                            NameCapitalizationFormatter(), // Apply title case formatting only here
                          ],
                          onChange: (value) {
                            setState(() {
                              nameController.text = toTitleCase(value);
                              nameController.selection =
                                  TextSelection.fromPosition(
                                TextPosition(
                                    offset: nameController.text.length),
                              );
                            });
                          },
                          onValidate: (v) {
                            if (v!.isEmpty) {
                              return 'Please Enter Full Name';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 10.h),
                        commonTitle('Phone Number'),
                        SizedBox(height: 10.h),
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 10.w),
                              decoration: BoxDecoration(
                                border: Border.all(color: Color(0XFFC9C9C9)),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton(
                                  dropdownColor: AppColors.whiteColor,
                                  value: selectedCode,
                                  onChanged: (newValue) {
                                    setState(() {
                                      selectedCode = newValue!;
                                      countryController.text = selectedCode;
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
                                          SizedBox(width: 5.w),
                                          Text(item['code']!),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                            SizedBox(width: 10.w),
                            Expanded(
                              child: CustomTextFormField(
                                controller: phoneController,
                                textInputType: TextInputType.phone,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                hintText: '96325334',
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
                        commonTitle('Work Pass Status'),
                        SizedBox(height: 10.h),
                        CustomTextFormField(
                          controller: dropDownController,
                          isDropdown: true,
                          dropdownItems: [
                            'Singaporean/Permanent Resident',
                            'Long Term Visit Pass Holder',
                            'Student Pass',
                            'No Valid Work Pass',
                          ],
                          hintText: 'Select Work Pass Status',
                          onValidate: (value) {
                            if (dropDownController.text.isEmpty) {
                              return 'Please Select Employment Status';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 50.h),
                        MouseRegion(
                          onEnter: (_) => setState(() => isOtpHovered = true),
                          onExit: (_) => setState(() => isOtpHovered = false),
                          child: CustomButton(
                            isDisable: !isContinueDisable,
                            isLoading: isGenerateOTPLoading,
                            backgroundColor: isGenerateOTPLoading
                                ? AppColors.blackColor
                                    .withOpacity(0.5) // Dimmed when loading
                                : isOtpHovered
                                    ? AppColors.blackColor
                                        .withOpacity(0.8) // Darken on hover
                                    : AppColors.blackColor, // Normal color
                            onTap: () {
                              if (nameController.text.isEmpty) {
                                toast('Please Enter Full Name');
                              } else if (phoneController.text.isEmpty) {
                                toast('Please Enter Phone Number');
                              } else if (emailController.text.isEmpty) {
                                toast('Please Enter Email');
                              } else if (!emailController.text.contains("@")) {
                                toast('Please enter a valid email');
                              } else if (dropDownController.text.isEmpty) {
                                toast('Please Select Employment Status');
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
                              style: CustomTextInter.medium12(
                                  AppColors.blackColor),
                            ),
                          ],
                        ),
                        SizedBox(height: 50.h),
                        CustomButton(
                          isDisable: isContinueDisable,
                          isLoading: isContinueLoading,
                          onTap: () {
                            if (dropDownController.text ==
                                "No Valid Work Pass") {
                              showWorkPassErrorDialog(context);
                            } else {
                              if (otpControllers.text.isEmpty ||
                                  otpControllers.text.length < 6) {
                                toast('Please Enter OTP');
                              } else {
                                onVerifyOTP();
                              }
                            }
                          },
                          text: 'Submit',
                        ),
                        SizedBox(height: 20.h), // Maintain spacing consistency
                        Center(
                          child: Column(
                            children: [
                              Text(
                                "Already have an account?",
                                style: CustomTextInter.regular14(
                                    AppColors.blackColor),
                              ),
                              SizedBox(
                                  height:
                                      12.h), // Space between text and button
                              SizedBox(
                                width: double
                                    .infinity, // Match Submit button width
                                child: OutlinedButton(
                                  onPressed: () {
                                    moveReplacePage(context, LoginScreen());
                                  },
                                  style: OutlinedButton.styleFrom(
                                    side: BorderSide(
                                        color: AppColors
                                            .themeColor), // Blue border
                                    padding: EdgeInsets.symmetric(
                                        vertical:
                                            18.h), // Match Submit button height
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.r),
                                    ),
                                  ),
                                  child: Text(
                                    'Sign In',
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
                                .h), // Additional spacing before bottom of the page
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
