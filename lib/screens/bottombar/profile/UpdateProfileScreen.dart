// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print

import 'dart:io';
import 'dart:developer';
// import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:intl/intl.dart';
import 'package:work_lah/data/send_request.dart';
// import 'package:work_lah/screens/bottombar/bottom_bar_screen.dart';
import 'package:work_lah/screens/model/user_model.dart';
import 'package:work_lah/utility/colors.dart';
import 'package:work_lah/utility/custom_appbar.dart';
import 'package:work_lah/utility/custom_textform_field.dart';
import 'package:work_lah/utility/display_function.dart';
import 'package:work_lah/utility/shared_prefs.dart';
import 'package:work_lah/utility/style_inter.dart';
import 'package:work_lah/utility/syle_poppins.dart';
import 'package:work_lah/screens/bottombar/home/complete_profile/complete_profile_widget.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key});

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController empStatusController = TextEditingController();
  TextEditingController nricController = TextEditingController();
  TextEditingController finController = TextEditingController();
  TextEditingController postalCodeController = TextEditingController();
  TextEditingController studentIDController = TextEditingController();
  TextEditingController schoolNameController = TextEditingController();

  int selectedGender = 0;
  UserModel? userModel;
  File? selectedProfileImage;

  String? dobDate;
  String? dobMonth;
  String? dobYear;
  
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getUserProfileData();
  }

  /// ✅ Fetch the user data from local storage
  Future<void> getUserProfileData() async {
    UserModel? fetchedUser = await getUserData();
    setState(() {
      userModel = fetchedUser;
      nameController.text = userModel?.fullName ?? '';
      phoneController.text = userModel?.phoneNumber ?? '';
      emailController.text = userModel?.email ?? '';
      empStatusController.text = userModel?.employmentStatus ?? '';
      selectedGender = userModel?.gender == "Male" ? 0 : 1;
    });
  }

  /// ✅ Handle Image Selection from Gallery
  Future<void> selectImage(Function(File?) updateImage) async {
    final File? image = await getImageFromGallery();
    if (image != null) {
      setState(() {
        updateImage(image);
      });
    }
  }

  /// ✅ Update Profile API Call
  Future<void> updateProfile() async {
    setState(() {
      isLoading = true;
    });

    String dateOfBirth = '$dobYear-$dobMonth-$dobDate';

    try {
      var response = await ApiProvider().postRequest(
        apiUrl: '/api/profile/update',
        data: {
          "userId": userModel!.id.toString(),
          "fullName": nameController.text,
          "phoneNumber": phoneController.text,
          "email": emailController.text,
          "dob": dateOfBirth,
          "gender": selectedGender == 0 ? 'Male' : 'Female',
          "postalCode": postalCodeController.text,
          "nricNumber": nricController.text,
        },
      );

      toast(response['message'] ?? 'Profile Updated Successfully');

      // ✅ Update local storage with new user data
      UserModel updatedUser = userModel!.copyWith(
        fullName: nameController.text,
        phoneNumber: phoneController.text,
        email: emailController.text,
        gender: selectedGender == 0 ? 'Male' : 'Female',
      );
      await saveUserData(updatedUser.toJson());

      setState(() {
        isLoading = false;
      });

      // ✅ Navigate back after updating profile
      Navigator.pop(context);
    } catch (e) {
      log('Error updating profile: $e');
      toast('An error occurred while updating profile');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.themeColor,
      body: Stack(
        children: [
          Column(
            children: [
              SizedBox(height: commonHeight(context) * 0.05),
              Padding(
                padding: EdgeInsets.only(left: 10.w),
                child: CustomAppbar(
                  title: 'Update Profile',
                  leadingBack: AppColors.whiteColor,
                  leadingIcon: AppColors.themeColor,
                  titleColor: AppColors.whiteColor,
                ),
              ),
              SizedBox(height: commonHeight(context) * 0.03),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                    color: AppColors.whiteColor,
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(20.w),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Text(
                              userModel?.fullName ?? '',
                              style: CustomTextPopins.medium24(AppColors.blackColor),
                            ),
                          ),
                          SizedBox(height: 20.h),
                          _buildInputField('Full Name', nameController, true),
                          _buildInputField('Phone Number', phoneController, false),
                          _buildInputField('Email', emailController, false),
                          _buildInputField('Employment Status', empStatusController, true),
                          _buildDateDropdown('Date of Birth'),
                          _buildGenderSelection(),
                          _buildInputField('Postal Code', postalCodeController, false),

                          SizedBox(height: 30.h),
                          GestureDetector(
                            onTap: updateProfile,
                            child: Container(
                              height: 50.h,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: AppColors.themeColor,
                              ),
                              child: Center(
                                child: isLoading
                                    ? CircularProgressIndicator(color: AppColors.whiteColor)
                                    : Text(
                                        'Save Changes',
                                        style: CustomTextPopins.medium16(AppColors.whiteColor),
                                      ),
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
            ],
          ),
        ],
      ),
    );
  }

  /// ✅ Helper Function: Build Text Input Fields
  Widget _buildInputField(String title, TextEditingController controller, bool readOnly) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: CustomTextInter.medium12(AppColors.fieldTitleColor)),
        SizedBox(height: 10.h),
        CustomTextFormField(controller: controller, hintText: 'Enter $title', readOnly: readOnly),
        SizedBox(height: 20.h),
      ],
    );
  }

  /// ✅ Helper Function: Build Date Dropdown
  Widget _buildDateDropdown(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: CustomTextInter.medium12(AppColors.fieldTitleColor)),
        SizedBox(height: 10.h),
        DateDropDownWidget(
          selectedDate: (value) => dobDate = value,
          selectedMonth: (value) => dobMonth = value,
          selectedYear: (value) => dobYear = value,
        ),
        SizedBox(height: 20.h),
      ],
    );
  }

  /// ✅ Helper Function: Gender Selection
  Widget _buildGenderSelection() {
    return Row(
      children: [
        Flexible(child: _genderButton(0, 'Male')),
        Flexible(child: _genderButton(1, 'Female')),
      ],
    );
  }
  

  Widget _genderButton(int index, String text) {
    return GestureDetector(
      onTap: () => setState(() => selectedGender = index),
      child: Row(children: [
        Icon(Icons.circle, color: selectedGender == index ? AppColors.themeColor : Colors.grey, size: 14.sp),
        SizedBox(width: 5.w),
        Text(text, style: CustomTextInter.medium12(AppColors.blackColor)),
      ]),
    );
  }
}
