// ignore_for_file: prefer_const_constructors

import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:work_lah/data/send_request.dart';
import 'package:work_lah/screens/bottombar/home/job_detail/job_details_widget.dart';
import 'package:work_lah/screens/bottombar/home/job_detail/availableShiftsPreviewWidget.dart';
import 'package:work_lah/utility/colors.dart';
import 'package:work_lah/utility/custom_appbar.dart';
import 'package:work_lah/utility/style_inter.dart';
import 'package:work_lah/utility/display_function.dart';
import 'package:work_lah/screens/bottombar/home/job_detail/common_widgets.dart';
import 'package:intl/intl.dart';
import 'package:work_lah/screens/bottombar/bottom_bar_screen.dart';
import 'package:work_lah/screens/bottombar/manage_job/ongoing_job/on_going_shift_cancel.dart';

class OnGoingJobDetails extends StatefulWidget {
  final String jobID;
  const OnGoingJobDetails({super.key, required this.jobID});

  @override
  State<OnGoingJobDetails> createState() => _OnGoingJobDetailsState();
}

class _OnGoingJobDetailsState extends State<OnGoingJobDetails> {
  bool jobDetailsLoading = false;
  Map<String, dynamic> jobDetailsData = {};
  List<dynamic> selectedShifts = [];
  String formatDate(String? date) {
    if (date == null || date.isEmpty) return "N/A";

    try {
      DateTime parsedDate;

      if (date.contains(',')) {
        // Handle "02 Mar, 2025"
        parsedDate = DateFormat("dd MMM, yyyy").parse(date);
      } else if (date.contains('/')) {
        // Handle "06/11/2024"
        parsedDate = DateFormat("dd/MM/yyyy").parse(date);
      } else if (date.contains('-')) {
        // Handle "2024-11-06"
        parsedDate = DateTime.parse(date);
      } else {
        return "Invalid Date";
      }

      return DateFormat('d EEE MMM').format(parsedDate); // "1 Sat Mar"
    } catch (e) {
      return "Invalid Date";
    }
  }

  @override
  void initState() {
    super.initState();
    getJobDetailWithID();
  }

  /// Fetch job details from API
  void getJobDetailWithID() async {
    setState(() {
      jobDetailsLoading = true;
    });
    try {
      var response = await ApiProvider()
          .getRequest(apiUrl: '/api/jobs/details/${widget.jobID}');
      setState(() {
        jobDetailsData = Map<String, dynamic>.from(
            response['job']); // ✅ Ensure it's a Map<String, dynamic>

        /// Format jobDates correctly
        String formattedDate = formatDate(jobDetailsData['jobDates']);

        /// Ensure `shift` is correctly converted to a Map<String, dynamic>
        if (jobDetailsData['shift'] is Map) {
          selectedShifts = [
            {
              ...Map<String, dynamic>.from(
                  jobDetailsData['shift']), // ✅ Convert shift explicitly
              'date': formattedDate, // ✅ Pass formatted date correctly
            }
          ];
        } else {
          selectedShifts = [];
        }

        jobDetailsLoading = false;
      });
    } catch (e) {
      log('Error fetching job details: $e');
      toast(e is Map ? e['message'] : 'An error occurred');
      setState(() {
        jobDetailsLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: commonHeight(context) * 0.05),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: CustomAppbar(title: 'Shift Summary'),
            ),
            jobDetailsLoading
                ? SizedBox(
                    height: commonHeight(context) * 0.5,
                    child: Center(
                      child: CircularProgressIndicator(
                          color: AppColors.themeColor),
                    ),
                  )
                : Column(
                    children: [
                      SizedBox(height: commonHeight(context) * 0.03),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Job Name & Subtitle
                            JobNameWidget(
                              jobTitle: jobDetailsData['jobName']?.toString() ??
                                  "N/A",
                              jobSubTitle: jobDetailsData['outlet']?['name']
                                      ?.toString() ??
                                  "N/A",
                            ),
                          ],
                        ),
                      ),

                      // Job Image
                      JobIMGWidget(
                        posterIMG: jobDetailsData['outlet']['outletImage']
                                ?.toString() ??
                            "",
                        showShareButton: false, // ✅ Enable sharing
                        jobTitle: jobDetailsData['jobName'] ?? 'Unknown Job',
                        jobLocation:
                            jobDetailsData['location'] ?? 'Unknown Location',
                        jobUrl:
                            "https://yourapp.com/job/${jobDetailsData['_id']}",
                      ),

                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.w, vertical: 10.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Job Scope Section
                            JobScopsWidget(
                              jobScropDesc: jobDetailsData['jobScope'] ?? [],
                            ),

                            // Job Requirements Section
                            JobRequirementWidget(
                              jobRequirements:
                                  jobDetailsData['jobRequirements'] ?? [],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 15.h),
                      shiftDetailsWidget(),

                      SizedBox(height: 20.h),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.w, vertical: 10.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Location Section
                            LocationWidget(
                              locationData:
                                  jobDetailsData['locationCoordinates'],
                            ),

                            SizedBox(height: 30.h),

                            // Employer Section
                            EmployerWidget(
                              employerName:
                                  jobDetailsData['employer']?['name'] ?? "N/A",
                              employerLogo: jobDetailsData['employer']
                                      ?['companyLogo'] ??
                                  "",
                              jobId:
                                  jobDetailsData['jobId']?.toString() ?? "N/A",
                              jobCategory:
                                  jobDetailsData['industry']?.toString() ??
                                      "N/A",
                              jobLocation:
                                  jobDetailsData['location']?.toString() ??
                                      "N/A",
                              jobDates: formatDate(jobDetailsData['jobDates']),
                            ),

                            SizedBox(height: 20.h),

                            // Shift Cancellation Alerts
                            OnGoingJobAlert(),

                            SizedBox(height: 10.h),

                            // Cancel Shift & Cancel Buttons
                            cancelShiftButtons(),
                            SizedBox(height: 20.h),
                          ],
                        ),
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }

  /// "Your Selected Shifts" Header
  Widget shiftDetailsWidget() {
    return Container(
      padding: EdgeInsets.all(15.w),
      decoration: BoxDecoration(
        color: AppColors.borderColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 5,
            spreadRadius: 1,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
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
              SizedBox(height: 8.h),
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
              SizedBox(height: 10.h),
            ],
          ),

          SizedBox(height: 15.h),

          /// **Date & Time Section**
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.r),
              color: AppColors.themeColor.withOpacity(0.5),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _dateBox(jobDetailsData['jobDates'] ?? ""),
                    SizedBox(width: 30.w),
                    Row(
                      children: [
                        _timeBox(
                            jobDetailsData['shift']['startTime'] ?? "--:--",
                            AppColors.themeColor),
                        SizedBox(width: 5.w),
                        Text("to",
                            style:
                                CustomTextInter.medium14(AppColors.blackColor)),
                        SizedBox(width: 5.w),
                        _timeBox(jobDetailsData['shift']['endTime'] ?? "--:--",
                            Colors.black),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 15.h),

                /// **Shift Duration & Wage**
                Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.r),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 5,
                        spreadRadius: 1,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(Icons.access_time,
                              color: AppColors.themeColor, size: 18.sp),
                          SizedBox(width: 5.w),
                          Text(
                              "${jobDetailsData['shift']['duration'] ?? '0'} hrs duration",
                              style: CustomTextInter.medium14(
                                  AppColors.blackColor)),
                          Spacer(),
                          Icon(Icons.coffee,
                              color: AppColors.themeColor, size: 18.sp),
                          SizedBox(width: 5.w),
                          Text(
                            "${jobDetailsData['shift']['breakDuration'] ?? '0'} break (${jobDetailsData['shift']['breakPaid']})",
                            style:
                                CustomTextInter.medium14(AppColors.blackColor),
                          ),
                        ],
                      ),
                      SizedBox(height: 10.h),
                      Row(
                        children: [
                          Icon(Icons.currency_exchange,
                              color: AppColors.themeColor, size: 18.sp),
                          SizedBox(width: 5.w),
                          Text(
                            "${jobDetailsData['shift']['totalWage'] ?? '0'} (${jobDetailsData['shift']['payRate'] ?? '0'}/hr)",
                            style:
                                CustomTextInter.medium14(AppColors.blackColor),
                          ),
                        ],
                      ),
                      Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.check_circle,
                              color: Colors.green, size: 18.sp),
                          SizedBox(width: 5.w),
                          Text("Confirmed",
                              style: CustomTextInter.bold16(Colors.green)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// **Time Box UI**
  Widget _timeBox(String time, Color bgColor) {
    return IntrinsicWidth(
      // ✅ Makes width adaptive to text
      child: Container(
        constraints: BoxConstraints(
            minWidth: 50.w, maxWidth: 80.w), // ✅ Prevents overflow
        padding: EdgeInsets.symmetric(
            horizontal: 8.w, vertical: 5.h), // ✅ Reduced padding
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),
          color: bgColor,
        ),
        child: FittedBox(
          // ✅ Ensures text scales properly
          fit: BoxFit.scaleDown,
          child: Text(
            time,
            style: CustomTextInter.bold14(Colors.white),
            softWrap: false, // ✅ Prevents multiline overflow
            overflow: TextOverflow.ellipsis, // ✅ Avoids excessive expansion
          ),
        ),
      ),
    );
  }

  /// **Date Box UI**
  Widget _dateBox(String? date) {
    if (date == null || date.isEmpty) {
      return Text(
        "Invalid Date",
        style: CustomTextInter.medium12(AppColors.redColor),
      );
    }

    try {
      DateTime parsedDate;

      if (date.contains(',')) {
        // Format: "02 Mar, 2025"
        parsedDate = DateFormat("dd MMM, yyyy").parse(date);
      } else if (date.contains('/')) {
        // Format: "06/11/2024"
        parsedDate = DateFormat("dd/MM/yyyy").parse(date);
      } else if (date.contains('-')) {
        // Format: "2024-11-06"
        parsedDate = DateTime.parse(date);
      } else {
        return Text(
          "Invalid Date",
          style: CustomTextInter.medium12(AppColors.redColor),
        );
      }

      String day = DateFormat('d').format(parsedDate);
      String weekday = DateFormat('EEE').format(parsedDate);
      String month = DateFormat('MMM').format(parsedDate);

      return Container(
        constraints:
            BoxConstraints(minWidth: 70.w, maxWidth: 90.w), // ✅ Dynamic width
        padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.r),
          color: Colors.grey[200],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min, // ✅ Prevents unnecessary space usage
          children: [
            SizedBox(width: 5.w),
            FittedBox(
              // ✅ Prevents text from overflowing
              fit: BoxFit.scaleDown,
              child: Text(
                day,
                style: CustomTextInter.bold33(AppColors.blackColor),
              ),
            ),
            SizedBox(width: 5.w),
            Expanded(
              // ✅ Ensures text inside Column fits properly
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      weekday,
                      style: CustomTextInter.medium12(AppColors.blackColor),
                    ),
                  ),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      month,
                      style: CustomTextInter.medium12(AppColors.blackColor),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    } catch (e) {
      return Text(
        "Invalid Date",
        style: CustomTextInter.medium12(AppColors.redColor),
      );
    }
  }

  /// **Vacancy Info**
  Widget _vacancyInfo(IconData icon, String text, Color color) {
    return Row(
      children: [
        Icon(icon, color: color, size: 14.sp),
        SizedBox(width: 4.w),
        Text(text, style: CustomTextInter.medium12(color)),
      ],
    );
  }

  /// "Cancel Shift" and "Cancel" buttons
  Widget cancelShiftButtons() {
    return Column(
      children: [
        // Cancel Shift Button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BottomBarScreen(
                    index:
                        0, // ✅ Keep Home as default tab OR pass the correct tab index
                    child: OnGoingShiftCancel(
                      data:
                          jobDetailsData, // ✅ Pass job details for cancellation screen
                    ),
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.redColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.r),
              ),
              padding: EdgeInsets.symmetric(vertical: 12.h),
            ),
            child: Text(
              "Cancel Shift",
              style: CustomTextInter.bold16(AppColors.whiteColor),
            ),
          ),
        ),
        SizedBox(height: 10.h),

        // Cancel Button
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: AppColors.themeColor),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.r),
              ),
              padding: EdgeInsets.symmetric(vertical: 12.h),
            ),
            child: Text(
              "Cancel",
              style: CustomTextInter.bold16(AppColors.themeColor),
            ),
          ),
        ),
      ],
    );
  }
}
