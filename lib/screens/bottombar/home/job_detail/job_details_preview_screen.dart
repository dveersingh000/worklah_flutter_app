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
import 'package:url_launcher/url_launcher.dart';
import 'package:work_lah/screens/model/user_model.dart';
import 'package:work_lah/utility/shared_prefs.dart';
import 'package:intl/intl.dart';

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
  bool isBooking = false;

  /// **Fetch the logged-in user ID from SharedPreferences**
  Future<String?> getUserId() async {
    UserModel? user = await getUserData();
    return user?.id; // Ensure 'id' exists in UserModel
  }

  /// **Book Selected Shifts API**
  Future<void> bookSelectedShifts() async {
  if (widget.selectedShifts.isEmpty) {
    toast("No shifts selected. Please select at least one shift.");
    return;
  }

  setState(() {
    isBooking = true;
  });

  String? userId = await getUserId();
  if (userId == null) {
    toast("User not found. Please log in again.");
    setState(() {
      isBooking = false;
    });
    return;
  }

  for (var shift in widget.selectedShifts) {
    try {
      // Format the date properly - convert from "2 Sun Mar" to a proper date format
      String formattedDate = "";
      
      try {
        // Parse the date string into proper format
        // Create a more standard date string
        String rawDate = shift['date'];
        
        // If the date is in "2 Sun Mar" format, convert it to proper format
        if (rawDate.contains(" ")) {
          List<String> dateParts = rawDate.split(" ");
          if (dateParts.length >= 3) {
            // Assuming format is "day weekday month"
            int day = int.tryParse(dateParts[0]) ?? 1;
            String month = dateParts[2]; // Mar
            
            // Get current year
            int year = DateTime.now().year;
            
            // Convert month name to month number
            Map<String, int> monthMap = {
              "Jan": 1, "Feb": 2, "Mar": 3, "Apr": 4, "May": 5, "Jun": 6,
              "Jul": 7, "Aug": 8, "Sep": 9, "Oct": 10, "Nov": 11, "Dec": 12
            };
            
            int monthNum = monthMap[month] ?? 1;
            
            // Create DateTime object
            DateTime dateObj = DateTime(year, monthNum, day);
            
            // Format the date in ISO format (YYYY-MM-DD)
            formattedDate = DateFormat('yyyy-MM-dd').format(dateObj);
          } else {
            formattedDate = rawDate; // Use as is if we can't parse
          }
        } else {
          formattedDate = rawDate; // Use as is if it's not in the expected format
        }
      } catch (e) {
        log("Error formatting date: $e");
        formattedDate = shift['date']; // Fallback to original date
      }

      // Now use the formatted date in the API call
      var response = await ApiProvider().postRequest(
        apiUrl: "/api/jobs/${widget.jobDetailsData['id']}/apply",
        data: {
          "userId": userId,
          "jobId": widget.jobDetailsData['id'],
          "shiftId": shift['id'],
          "date": formattedDate,
          "isStandby": shift['isStandby'] ?? false,
        },
      );

      if (response != null && response['message'] == "Shift booking successful") {
        toast("Shift booked successfully!");

        // ✅ Navigate to Booking Confirmation Screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => BottomBarScreen(
              index: 0,
              child: BookingConfirmationScreen(
                jobDetails: widget.jobDetailsData,
              ),
            ),
          ),
        );

        return; // ✅ Stop further execution after successful booking
      } else {
        toast(response['error'] ?? "Failed to book shift.");
      }
    } catch (e) {
      log("Error while booking shift: $e");
      toast("An error occurred. Please try again.");
    }
  }

  setState(() {
    isBooking = false;
  });
}

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
                        padding: EdgeInsets.only(left: 10.w, right: 10.w),
                        child: JobNameWidget(
                          jobTitle:
                              widget.jobDetailsData['jobName'] ?? 'Unknown Job',
                          jobSubTitle: widget.jobDetailsData['outlet']
                                  ?['name'] ??
                              'Unknown Outlet',
                        ),
                      ),
                      JobIMGWidget(
                        posterIMG:
                            widget.jobDetailsData['outlet']['image'] ?? '',
                        showShareButton: true, // ✅ Enable sharing
                        jobTitle:
                            widget.jobDetailsData['jobName'] ?? 'Unknown Job',
                        jobLocation: widget.jobDetailsData['location'] ??
                            'Unknown Location',
                        jobUrl:
                            "https://worklah.onrender.com/api/jobs/${widget.jobDetailsData['id']}",
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
                                          WidgetSpan(
                                            child: MouseRegion(
                                              cursor: SystemMouseCursors.click,
                                              child: GestureDetector(
                                                onTap: () async {
                                                  const url =
                                                      'https://www.worksome.com/legal-center/default-booking-contract';
                                                  if (await canLaunch(url)) {
                                                    await launch(url);
                                                  } else {
                                                    throw 'Could not launch $url';
                                                  }
                                                },
                                                child: Text(
                                                  "Terms and Conditions",
                                                  style: CustomTextInter
                                                          .medium12(AppColors
                                                              .themeColor)
                                                      .copyWith(
                                                          decoration:
                                                              TextDecoration
                                                                  .underline),
                                                ),
                                              ),
                                            ),
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
                                          WidgetSpan(
                                            child: MouseRegion(
                                              cursor: SystemMouseCursors.click,
                                              child: GestureDetector(
                                                onTap: () async {
                                                  const url =
                                                      'https://www.shrm.org/topics-tools/tools/forms/health-insurance-participant-waiver';
                                                  if (await canLaunch(url)) {
                                                    await launch(url);
                                                  } else {
                                                    throw 'Could not launch $url';
                                                  }
                                                },
                                                child: Text(
                                                  "medical waivers submission terms and conditions",
                                                  style: CustomTextInter
                                                          .medium12(AppColors
                                                              .themeColor)
                                                      .copyWith(
                                                          decoration:
                                                              TextDecoration
                                                                  .underline),
                                                ),
                                              ),
                                            ),
                                          ),
                                          TextSpan(
                                            text:
                                                " and also confirm my availability on the day of shift.",
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
                                      onPressed: isBooking ? null : bookSelectedShifts,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.symmetric(vertical: 12),
              ),
              child: isBooking
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text(
                      "Confirm Booking",
                      style: TextStyle(color: Colors.white, fontSize: 16),
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
