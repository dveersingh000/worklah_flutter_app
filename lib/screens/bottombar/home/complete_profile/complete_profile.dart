// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print, use_build_context_synchronously, unused_local_variable

import 'dart:developer';
import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:work_lah/data/send_request.dart';
import 'package:work_lah/screens/bottombar/bottom_bar_screen.dart';
import 'package:work_lah/screens/bottombar/home/complete_profile/complete_profile_widget.dart';
import 'package:work_lah/screens/model/user_model.dart';
import 'package:work_lah/utility/colors.dart';
import 'package:work_lah/utility/custom_appbar.dart';
import 'package:work_lah/utility/custom_textform_field.dart';
import 'package:work_lah/utility/display_function.dart';
import 'package:work_lah/utility/shared_prefs.dart';
import 'package:work_lah/utility/style_inter.dart';
import 'package:work_lah/utility/syle_poppins.dart';
import 'package:work_lah/utility/image_path.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

class CompleteProfile extends StatefulWidget {
  final Map<String, dynamic> jobData;
  final String shiftID;
  final String jobDATE;
  const CompleteProfile(
      {super.key,
      required this.jobData,
      required this.shiftID,
      required this.jobDATE});

  @override
  State<CompleteProfile> createState() => _CompleteProfileState();
}

class _CompleteProfileState extends State<CompleteProfile> {
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

  File? selectedNRICFront;
  File? selectedNRICBack;

  File? selectedFINFront;
  File? selectedFINBack;

  File? selectedPLOC;

  File? selectedStudentPass;

  String? dobDate;
  String? dobMonth;
  String? dobYear;

  String? plocDate;
  String? plocMonth;
  String? plocYear;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getLocalData();
  }

  Future<void> getLocalData() async {
    UserModel? fetchedUser = await getUserData();
    setState(() {
      userModel = fetchedUser!;
      nameController.text = userModel?.fullName ?? 'Steve Ryan';
      phoneController.text = userModel?.phoneNumber ?? '+65 1234567890';
      emailController.text = userModel?.email ?? 'artx@gmail.com';
      empStatusController.text =
          userModel?.employmentStatus ?? 'Singaporean/Permanent Resident';
    });
  }

  Future<void> galleryImageStore(Function(File?) updateImage) async {
    final File? image = await getImageFromGallery();
    if (image != null) {
      setState(() {
        updateImage(image);
      });
    }
  }

Future<void> completePRProfile() async {
  setState(() {
    isLoading = true;
  });

  try {
    final String dob = '$dobYear-$dobMonth-$dobDate';
    final String? plocExpiryDate =
        (plocDate != null && plocMonth != null && plocYear != null)
            ? '$plocYear-$plocMonth-$plocDate'
            : null;

    final uri = Uri.parse('https://worklah.onrender.com/api/profile/complete-profile');
    final request = http.MultipartRequest('PUT', uri);

    // 🌐 Add required fields
    request.fields['userId'] = userModel!.id;
    request.fields['dob'] = dob;
    request.fields['gender'] = selectedGender == 0 ? 'Male' : 'Female';
    request.fields['postalCode'] = postalCodeController.text;

    final status = empStatusController.text;

    // 📎 Upload files & fields based on employment status
    if (status == 'Singaporean/Permanent Resident') {
      request.fields['nricNumber'] = nricController.text;

      if (selectedNRICFront != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'nricFront',
          selectedNRICFront!.path,
          filename: basename(selectedNRICFront!.path),
        ));
      }

      if (selectedNRICBack != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'nricBack',
          selectedNRICBack!.path,
          filename: basename(selectedNRICBack!.path),
        ));
      }
    }

    if (status == 'Long Term Visit Pass Holder') {
      request.fields['finNumber'] = finController.text;
      if (plocExpiryDate != null) {
        request.fields['plocExpiryDate'] = plocExpiryDate;
      }

      if (selectedFINFront != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'finFront',
          selectedFINFront!.path,
          filename: basename(selectedFINFront!.path),
        ));
      }

      if (selectedFINBack != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'finBack',
          selectedFINBack!.path,
          filename: basename(selectedFINBack!.path),
        ));
      }

      if (selectedPLOC != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'plocImage',
          selectedPLOC!.path,
          filename: basename(selectedPLOC!.path),
        ));
      }
    }

    if (status == 'Student Pass') {
      request.fields['studentIdNumber'] = studentIDController.text;
      request.fields['schoolName'] = schoolNameController.text;

      if (selectedStudentPass != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'studentCard',
          selectedStudentPass!.path,
          filename: basename(selectedStudentPass!.path),
        ));
      }
    }

    // 🖼️ Upload profile picture (selfie)
    if (selectedProfileImage != null) {
      request.files.add(await http.MultipartFile.fromPath(
        'selfie',
        selectedProfileImage!.path,
        filename: basename(selectedProfileImage!.path),
      ));
    }

    // Optional: Auth header (if needed)
    // request.headers['Authorization'] = 'Bearer ${userModel?.token}';

    final response = await request.send();

    if (response.statusCode == 200) {
      final body = await response.stream.bytesToString();
      log('✅ Profile completed: $body');

      final fetchedUser = await getUserData();
      await saveUserData(fetchedUser!.copyWith(profileCompleted: true).toJson());

      setState(() => isLoading = false);
      Navigator.pushReplacement(
        this.context,
        MaterialPageRoute(builder: (_) => BottomBarScreen(index: 4)),
      );
    } else {
      final body = await response.stream.bytesToString();
      log('❌ Upload failed: $body');
      toast('Failed: ${response.statusCode}');
      setState(() => isLoading = false);
    }
  } catch (e) {
    log('❌ Error during profile upload: $e');
    toast('Something went wrong. Try again.');
    setState(() => isLoading = false);
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
                  title: 'Complete your profile',
                  leadingBack: AppColors.whiteColor,
                  leadingIcon: AppColors.themeColor,
                  titleColor: AppColors.themeColor,
                ),
              ),
              SizedBox(height: commonHeight(context) * 0.03),
              WalletAmountCard(),
              SizedBox(height: commonHeight(context) * 0.08),
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
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).padding.top + 40.h,
                      left: 10.w,
                      right: 10.w,
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Text(
                              userModel?.fullName.toString() ?? 'Steve Ryan',
                              style: CustomTextPopins.medium24(
                                  AppColors.blackColor),
                            ),
                          ),
                          SizedBox(height: 20.h),
                          commonTitle('Full Name (As per NRIC)'),
                          SizedBox(height: 10.h),
                          CustomTextFormField(
                            controller: nameController,
                            hintText: 'Steve Ryan',
                            readOnly: true,
                          ),
                          SizedBox(height: 20.h),
                          commonTitle('Phone Number'),
                          SizedBox(height: 10.h),
                          CustomTextFormField(
                            controller: phoneController,
                            hintText: '+65 1234567892',
                            readOnly: true,
                          ),
                          SizedBox(height: 20.h),
                          commonTitle('Email'),
                          SizedBox(height: 10.h),
                          CustomTextFormField(
                            controller: emailController,
                            hintText: 'axrt@gmail.com',
                            readOnly: true,
                          ),
                          SizedBox(height: 20.h),
                          commonTitle('Work Pass Status'),
                          SizedBox(height: 10.h),
                          CustomTextFormField(
                            controller: empStatusController,
                            hintText: 'Singaporean/Permanent Resident',
                            readOnly: true,
                          ),
                          SizedBox(height: 20.h),
                          if (empStatusController.text ==
                              'Singaporean/Permanent Resident') ...[
                            commonTitle('NRIC', isRichText: true),
                            SizedBox(height: 10.h),
                            Text(
                              'Ensure your NRIC is registered with your bank for PayNow to receive payments successfully.',
                              style: CustomTextInter.regular12(
                                AppColors.fieldTitleColor,
                              ),
                            ),
                            SizedBox(height: 10.h),
                            CustomTextFormField(
                              controller: nricController,
                              hintText: 'Enter your NRIC number',
                            ),
                          ],
                          if (empStatusController.text ==
                              'Long Term Visit Pass Holder') ...[
                            commonTitle('FIN No', isRichText: true),
                            SizedBox(height: 10.h),
                            CustomTextFormField(
                              controller: finController,
                              hintText: 'Enter your FIN number',
                            ),
                          ],
                          SizedBox(height: 20.h),
                          commonTitle('Date of Birth', isRichText: true),
                          SizedBox(height: 10.h),
                          DateDropDownWidget(
                            selectedDate: (dateValue) {
                              dobDate = dateValue;
                            },
                            selectedMonth: (monthValue) {
                              dobMonth = monthValue;
                            },
                            selectedYear: (yearValue) {
                              dobYear = yearValue;
                            },
                          ),
                          SizedBox(height: 20.h),
                          commonTitle('Gender', isRichText: true),
                          SizedBox(height: 10.h),
                          Row(
                            children: [
                              Flexible(child: genderSelection(0, 'Male')),
                              Flexible(
                                flex: 2,
                                child: genderSelection(1, 'Female'),
                              ),
                            ],
                          ),
                          SizedBox(height: 20.h),
                          commonTitle('Postal Code', isRichText: true),
                          SizedBox(height: 10.h),
                          CustomTextFormField(
                            controller: postalCodeController,
                            hintText: 'Enter your Postal code',
                          ),
                          SizedBox(height: 20.h),
                          if (empStatusController.text ==
                              'Singaporean/Permanent Resident') ...[
                            commonTitle(
                              'NRIC Image (Front & Back)',
                              isRichText: true,
                            ),
                            SizedBox(height: 10.h),
                            CaptureImageWidget(
                              title: 'NRIC front image',
                              title2: 'Upload NRIC front image',
                              onSelectImage: () {
                                galleryImageStore((image) {
                                  selectedNRICFront = image;
                                });
                              },
                              selectedIMG: selectedNRICFront,
                            ),
                            SizedBox(height: 10.h),
                            CaptureImageWidget(
                              title: 'NRIC back image',
                              title2: 'Upload NRIC back image',
                              onSelectImage: () {
                                galleryImageStore((image) {
                                  selectedNRICBack = image;
                                });
                              },
                              selectedIMG: selectedNRICBack,
                            ),
                          ],
                          if (empStatusController.text ==
                              'Long Term Visit Pass Holder') ...[
                            commonTitle(
                              'FIN Image (Front & Back)',
                              isRichText: true,
                            ),
                            SizedBox(height: 10.h),
                            CaptureImageWidget(
                              title: 'FIN front image',
                              title2: 'Upload FIN front image',
                              onSelectImage: () {
                                galleryImageStore((image) {
                                  selectedFINFront = image;
                                });
                              },
                              selectedIMG: selectedFINFront,
                            ),
                            SizedBox(height: 10.h),
                            CaptureImageWidget(
                              title: 'FIN back image',
                              title2: 'Upload FIN back image',
                              onSelectImage: () {
                                galleryImageStore((image) {
                                  selectedFINBack = image;
                                });
                              },
                              selectedIMG: selectedFINBack,
                            ),
                            SizedBox(height: 20.h),
                            commonTitle(
                              'PLOC Image',
                              isRichText: true,
                            ),
                            SizedBox(height: 10.h),
                            CaptureImageWidget(
                              title: 'PLOC image',
                              title2: 'Upload PLOC image',
                              onSelectImage: () {
                                galleryImageStore((image) {
                                  selectedPLOC = image;
                                });
                              },
                              selectedIMG: selectedPLOC,
                            ),
                            SizedBox(height: 20.h),
                            commonTitle(
                              'PLOC Expiry Date',
                              isRichText: true,
                            ),
                            SizedBox(height: 20.h),
                            DateDropDownWidget(
                              selectedDate: (dateValue) {
                                plocDate = dateValue;
                              },
                              selectedMonth: (monthValue) {
                                plocMonth = monthValue;
                              },
                              selectedYear: (yearValue) {
                                plocYear = yearValue;
                              },
                            ),
                          ],
                          if (empStatusController.text == 'Student Pass') ...[
                            commonTitle(
                              'Student Card',
                              isRichText: true,
                            ),
                            SizedBox(height: 10.h),
                            CaptureImageWidget(
                              title: 'Student Pass image',
                              title2: 'Upload Student Pass image',
                              onSelectImage: () {
                                galleryImageStore((image) {
                                  selectedStudentPass = image;
                                });
                              },
                              selectedIMG: selectedStudentPass,
                            ),
                            SizedBox(height: 20.h),
                            commonTitle('Student ID Number', isRichText: true),
                            SizedBox(height: 10.h),
                            CustomTextFormField(
                              controller: studentIDController,
                              hintText: 'Enter your Student ID',
                            ),
                            SizedBox(height: 20.h),
                            commonTitle('School Name', isRichText: true),
                            SizedBox(height: 10.h),
                            CustomTextFormField(
                              controller: schoolNameController,
                              hintText: 'Enter your school name',
                            ),
                          ],
                          SizedBox(height: 30.h),
                          GestureDetector(
                            onTap: () {
                              completePRProfile();
                            },
                            child: Container(
                              height: 50.h,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: AppColors.themeColor,
                              ),
                              child: Center(
                                child: isLoading
                                    ? SizedBox(
                                        height: 20.h,
                                        width: 20.w,
                                        child: CircularProgressIndicator(
                                          color: AppColors.whiteColor,
                                        ),
                                      )
                                    : Text(
                                        'Save Profile',
                                        style: CustomTextPopins.medium16(
                                            AppColors.whiteColor),
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
          Padding(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 220.h,
              left: MediaQuery.of(context).padding.left + 120.w,
              right: MediaQuery.of(context).padding.right + 120.w,
            ),
            child: SizedBox(
              height: 110.h,
              width: 125.w,
              child: GestureDetector(
                onTap: () async {
                  galleryImageStore((image) {
                    selectedProfileImage = image;
                  });
                },
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    DottedBorder(
                      borderType: BorderType.RRect,
                      radius: Radius.circular(50),
                      dashPattern: [4, 4],
                      borderPadding: EdgeInsets.all(-1),
                      color: AppColors.blackColor,
                      strokeWidth: 1,
                      child: selectedProfileImage != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: Image.file(
                                selectedProfileImage!,
                                fit: BoxFit.fill,
                                height: 75,
                                width: 75,
                              ),
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: Image.network(
                                userModel?.profilePicture ??
                                    '', // Handle null profilePicture
                                fit: BoxFit.fill,
                                height: 75.h,
                                width: 75.w,
                                errorBuilder: (context, error, stackTrace) {
                                  return Image.asset(
                                    ImagePath
                                        .personIMG, // Placeholder image if network image fails
                                    fit: BoxFit.fill,
                                    height: 75.h,
                                    width: 75.w,
                                  );
                                },
                              ),
                            ),
                    ),
                    Positioned(
                      right: 5,
                      top: 5,
                      child: Container(
                        height: 35.h,
                        width: 35.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.whiteColor,
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 4,
                              color: AppColors.blackColor.withOpacity(0.2),
                              offset: Offset(0, 4),
                              spreadRadius: 0,
                            ),
                          ],
                        ),
                        child: Center(
                          child: Icon(
                            Icons.camera_alt_outlined,
                            color: AppColors.blackColor,
                            size: 20.sp,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget commonTitle(String title, {bool isRichText = false}) {
    return isRichText
        ? RichText(
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
          )
        : Text(
            title,
            style: CustomTextInter.medium12(AppColors.fieldTitleColor),
          );
  }

  Widget genderSelection(int index, String text) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedGender = index;
        });
      },
      child: Row(
        children: [
          Container(
            height: 12.h,
            width: 12.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: selectedGender == index
                  ? AppColors.themeColor
                  : AppColors.fieldBorderColor,
            ),
          ),
          SizedBox(width: 10.w),
          Text(
            text,
            style: CustomTextPopins.regular14(AppColors.blackColor),
          ),
        ],
      ),
    );
  }
}
