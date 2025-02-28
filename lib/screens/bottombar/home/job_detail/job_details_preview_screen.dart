import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:work_lah/data/send_request.dart';
import 'package:work_lah/screens/bottombar/bottom_bar_screen.dart';
import 'package:work_lah/screens/bottombar/home/job_detail/available_tab/available_tab_view.dart';
import 'package:work_lah/screens/bottombar/home/job_detail/common_widgets.dart';
import 'package:work_lah/screens/bottombar/home/job_detail/job_details_widget.dart';
import 'package:work_lah/utility/colors.dart';
import 'package:work_lah/utility/custom_appbar.dart';
import 'package:work_lah/utility/display_function.dart';
import 'package:work_lah/utility/style_inter.dart';
import 'package:work_lah/utility/syle_poppins.dart';
import 'package:work_lah/screens/bottombar/home/complete_profile/complete_profile.dart';
import 'package:work_lah/screens/bottombar/home/job_detail/availableShiftsPreviewWidget.dart';
import 'package:work_lah/screens/bottombar/home/job_detail/bookingConfirmationScreen.dart';

class JobDetailsPreviewScreen extends StatefulWidget {
  final Map<String, dynamic> jobDetailsData;
  final List<dynamic> selectedShifts;

  const JobDetailsPreviewScreen({
    super.key,
    required this.jobDetailsData,
    required this.selectedShifts,
  });
  @override
  _JobDetailsPreviewScreenState createState() =>
      _JobDetailsPreviewScreenState();
}

class _JobDetailsPreviewScreenState extends State<JobDetailsPreviewScreen> {
  bool termsAccepted = false;
  bool medicalWaiverAccepted = false;
  get availableShiftsData => null;

  @override
  Widget build(BuildContext context) {
    var employerData = widget.jobDetailsData['employer'] ?? {};

    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: Column(
        children: [
          Expanded(
            // Makes body scrollable while buttons remain fixed
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: commonHeight(context) * 0.01),
                  Padding(
                    padding: EdgeInsets.only(left: 10.w, right: 10.w),
                    child: CustomAppbar(title: 'Shift Confirmation'),
                  ),
                  Column(
                    children: [
                      SizedBox(height: commonHeight(context) * 0.03),
                      Padding(
                        padding: EdgeInsets.only(
                            left: 10.w, right: 10.w),
                        child: JobNameWidget(
                          jobTitle:
                              widget.jobDetailsData['jobName'] ?? 'Unknown Job',
                          jobSubTitle: widget.jobDetailsData['outlet']
                                  ?['name'] ??
                              'Unknown Outlet',
                        ),
                      ),
                      JobIMGWidget(
                        posterIMG: widget.jobDetailsData['jobIcon'] ?? '',
                      ),
                      Padding(
                        padding:
                            EdgeInsets.only(right: 20.w, top: 10.h, left: 20.w),
                        child: Column(
                          children: [
                            JobScopsWidget(
                              jobScropDesc:
                                  widget.jobDetailsData['jobScope'] ?? [],
                            ),
                            JobRequirementWidget(
                              jobRequirements:
                                  widget.jobDetailsData['jobRequirements'] ??
                                      [],
                            ),
                            availabeShiftText(),
                            SizedBox(height: 15.h),
                            AvailableShiftsPreviewWidget(
                              selectedShifts: widget.selectedShifts
                                  .map((shift) =>
                                      Map<String, dynamic>.from(shift))
                                  .toList(),
                            ),

                            SizedBox(height: 20.h),
                            Container(
                              padding: EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Color(0XFFFFDDBD),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.person,
                                        size: 16.sp,
                                        color: AppColors.standbyColor,
                                      ),
                                      SizedBox(width: 5.w),
                                      Text(
                                        'Standby Booking Warning Notices',
                                        style: CustomTextInter.semiBold10(
                                            AppColors.standbyColor),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 20.h),
                                  RichText(
                                    text: TextSpan(
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: '1. No-show Penalty: ',
                                          style: CustomTextInter.medium12(
                                              AppColors.standbyColor),
                                        ),
                                        TextSpan(
                                          text:
                                              'Failing to show up after being activated from standby will result in a \$20 penalty.',
                                          style: CustomTextInter.regular12(
                                            AppColors.fieldTitleColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 10.h),
                                  RichText(
                                    text: TextSpan(
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: '2. Booking Fee: ',
                                          style: CustomTextInter.medium12(
                                              AppColors.standbyColor),
                                        ),
                                        TextSpan(
                                          text:
                                              'A \$10 fee will be charged upon shift completion for standby booking.',
                                          style: CustomTextInter.regular12(
                                            AppColors.fieldTitleColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 10.h),
                                  RichText(
                                    text: TextSpan(
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: '3. Standby Conditions: ',
                                          style: CustomTextInter.medium12(
                                              AppColors.standbyColor),
                                        ),
                                        TextSpan(
                                          text:
                                              'If you book another shift that overlaps with this standby slot, your standby reservation will be forfeited.',
                                          style: CustomTextInter.regular12(
                                            AppColors.fieldTitleColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 20.h),
                                  Text(
                                    'Thank you for your interest!',
                                    style: CustomTextInter.medium12(
                                      AppColors.fieldTitleColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 20.h),
                            // 📍 Location Widget
                            LocationWidget(
                              locationData:
                                  widget.jobDetailsData['locationCoordinates'],
                            ),

                            SizedBox(height: 20.h),

                            // 🏢 Employer Details
                            EmployerWidget(
                              employerName:
                                  employerData['name']?.toString() ?? 'N/A',
                              employerLogo:
                                  employerData['logo']?.toString() ?? '',
                              jobId:
                                  widget.jobDetailsData['id']?.toString() ?? '',
                              jobCategory: widget.jobDetailsData['jobCategory']
                                      ?.toString() ??
                                  'N/A',
                              jobLocation: widget.jobDetailsData['location']
                                      ?.toString() ??
                                  'N/A',
                              jobDates: widget.jobDetailsData[
                                          'availableShiftsData'] !=
                                      null
                                  ? widget.jobDetailsData['availableShiftsData']
                                      .map((date) => date['date'].toString())
                                      .join(' | ')
                                  : 'N/A',
                            ),
                            SizedBox(height: 20.h),

                            // 📌 Terms and Conditions Checkboxes
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20.w),
                              child: Column(
                                children: [
                                  CheckboxListTile(
                                    activeColor: AppColors.themeColor,
                                    title: RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: "I agree to the ",
                                            style: CustomTextInter.medium12(
                                                AppColors.blackColor),
                                          ),
                                          TextSpan(
                                            text: "Terms and Conditions",
                                            style: CustomTextInter.medium12(
                                                AppColors.themeColor),
                                          ),
                                          TextSpan(
                                            text: " written in the policy",
                                            style: CustomTextInter.medium12(
                                                AppColors.blackColor),
                                          ),
                                        ],
                                      ),
                                    ),
                                    value: termsAccepted,
                                    onChanged: (value) {
                                      setState(() {
                                        termsAccepted = value!;
                                      });
                                    },
                                    controlAffinity:
                                        ListTileControlAffinity.leading,
                                  ),
                                  CheckboxListTile(
                                    activeColor: AppColors.themeColor,
                                    title: RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: "I understand the ",
                                            style: CustomTextInter.medium12(
                                                AppColors.blackColor),
                                          ),
                                          TextSpan(
                                            text:
                                                "medical waivers submission terms",
                                            style: CustomTextInter.medium12(
                                                AppColors.themeColor),
                                          ),
                                          TextSpan(
                                            text:
                                                " and conditions and also confirm my availability on the day of shift.",
                                            style: CustomTextInter.medium12(
                                                AppColors.blackColor),
                                          ),
                                        ],
                                      ),
                                    ),
                                    value: medicalWaiverAccepted,
                                    onChanged: (value) {
                                      setState(() {
                                        medicalWaiverAccepted = value!;
                                      });
                                    },
                                    controlAffinity:
                                        ListTileControlAffinity.leading,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 20.h),
// 📌 Buttons (Confirm Booking & Cancel)
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20.w),
                              child: Column(
                                children: [
                                  // ✅ Confirm Booking Button
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      onPressed: (termsAccepted &&
                                              medicalWaiverAccepted)
                                          ? () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      BottomBarScreen(
                                                        index: 0,
                                                        child: BookingConfirmationScreen(
                                                    jobDetails:
                                                        widget.jobDetailsData,
                                                  ),
                                                  )  
                                                ),
                                              );
                                            }
                                          : null, // Disabled if terms not accepted
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.themeColor,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.r),
                                        ),
                                        padding: EdgeInsets.symmetric(
                                            vertical: 12.h),
                                      ),
                                      child: Text(
                                        "Confirm Booking",
                                        style: CustomTextInter.bold16(
                                            AppColors.whiteColor),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 10.h),

                                  // ❌ Cancel Button
                                  SizedBox(
                                    width: double.infinity,
                                    child: OutlinedButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      style: OutlinedButton.styleFrom(
                                        side: BorderSide(
                                            color: AppColors.themeColor),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.r),
                                        ),
                                        padding: EdgeInsets.symmetric(
                                            vertical: 12.h),
                                      ),
                                      child: Text(
                                        "Cancel",
                                        style: CustomTextInter.bold16(
                                            AppColors.themeColor),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 20.h),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget availabeShiftText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.history_toggle_off_outlined,
              color: AppColors.blackColor,
              size: 20.sp,
            ),
            SizedBox(width: 5.w),
            Text(
              'Your Selected Shifts',
              style: CustomTextInter.medium16(AppColors.blackColor),
            ),
          ],
        ),
        SizedBox(height: 8.h), // Proper spacing
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Row(
              children: [
                Icon(
                  Icons.person,
                  color: Colors.grey,
                  size: 15.sp,
                ),
                SizedBox(width: 4.w),
                Text(
                  'Available Vacancy',
                  style: CustomTextInter.medium12(AppColors.blackColor),
                ),
                SizedBox(width: 3.w),
                Icon(
                  Icons.info_outline,
                  color: Colors.black54,
                  size: 14.sp,
                ),
              ],
            ),
            Row(
              children: [
                Icon(
                  Icons.person,
                  color: AppColors.orangeColor,
                  size: 15.sp,
                ),
                SizedBox(width: 4.w),
                Text(
                  'Standby Vacancy',
                  style: CustomTextInter.medium12(AppColors.blackColor),
                ),
                SizedBox(width: 3.w),
                Icon(
                  Icons.info_outline,
                  color: Colors.black54,
                  size: 14.sp,
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: 10.h), // Add space before shifts listing
      ],
    );
  }
}

Widget commonLeftWidget(String text, Color color) {
  return Row(
    children: [
      Icon(
        Icons.person,
        color: color,
        size: 15.sp,
      ),
      SizedBox(width: 5.w),
      Text(
        text,
        style: CustomTextInter.medium10(AppColors.blackColor),
      ),
    ],
  );
}
