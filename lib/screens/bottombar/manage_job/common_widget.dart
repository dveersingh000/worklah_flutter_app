// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:work_lah/utility/colors.dart';
import 'package:work_lah/utility/style_inter.dart';
import 'package:work_lah/data/send_request.dart';
import 'package:work_lah/utility/display_function.dart';
import 'package:work_lah/screens/bottombar/manage_job/cancelled_job/cancelled_job_details.dart';
import 'package:work_lah/screens/bottombar/manage_job/ongoing_job/on_going_job_details.dart';
import 'package:work_lah/screens/bottombar/bottom_bar_screen.dart';
// import 'package:work_lah/screens/bottombar/manage_job/no_show_job/no_show_job_details.dart';

class CommonJobWidget extends StatelessWidget {
  final Map jobData;
  final String tabType; // "upcoming", "completed", "cancelled", "no-show"

  const CommonJobWidget({
    super.key,
    required this.jobData,
    required this.tabType,
  });

  @override
  Widget build(BuildContext context) {
    // Format Job Date
    String jobDate =
        DateFormat('dd MMM, yy').format(DateTime.parse(jobData['jobDate']));

    // Format Shift Start & End Time
    String shiftStartTime = jobData['shiftStartTime'];
    String shiftEndTime = jobData['shiftEndTime'];

    // Determine status label & color
    String statusText = "";
    Color statusColor = Colors.transparent;
    Color statusTextColor = Colors.white;
    Widget? penaltyWidget;

    if (tabType == "completed") {
      statusText = "Completed";
      statusColor = Colors.greenAccent;
      statusTextColor = Colors.green;
    } else if (tabType == "cancelled") {
      statusText = "Cancelled";
      statusColor = Colors.redAccent;
      statusTextColor = Colors.red;
      penaltyWidget = _buildPenaltyWidget(jobData['penaltyAmount']);
    } else if (tabType == "no-show") {
      statusText = "No-Show";
      statusColor = Colors.redAccent;
      statusTextColor = Colors.red;
      penaltyWidget = _buildPenaltyWidget(jobData['penaltyAmount']);
    }

    return GestureDetector(
      onTap: () {
        if (tabType == "completed") {
          // moveToNext(
          //   context,
          //   CompletedJobDetails(jobID: jobData['applicationId']),
          // );
        } else if (tabType == "cancelled") {
          moveToNext(
            context,
            CancelledJobDetails(jobID: jobData['applicationId']),
          );
        } else if (tabType == "no-show") {
          // moveToNext(
          //   context,
          //   NoShowJobDetails(jobID: jobData['applicationId']),
          // );
        } else {
          Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BottomBarScreen(
            index: 0, // ✅ Set the default tab index (Home or correct index)
            child: OnGoingJobDetails(
              jobID: jobData['applicationId'],
            ),
          ),
        ),
      );
        }
      },
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Job Date Header
        Padding(
          padding: EdgeInsets.only(left: 15.w, top: 10.h, bottom: 5.h),
          child: Text(
            jobDate,
            style: CustomTextInter.medium14(AppColors.blackColor),
          ),
        ),

        // Job Card UI
        Stack(
          children: [
            // Background Image
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                '${ApiProvider().baseUrl}${jobData['outletImage']}',
                width: double.infinity,
                height: commonHeight(context) * 0.22,
                fit: BoxFit.cover,
              ),
            ),

            // Dark Overlay
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withOpacity(0.6),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),

            // Job Name & Outlet
            Positioned(
              top: 15.h,
              left: 20.w,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Job Name
                  Row(
                    children: [
                      Icon(Icons.work, color: Colors.white, size: 18.sp),
                      SizedBox(width: 5.w),
                      Text(
                        jobData['jobName'],
                        style: CustomTextInter.bold16(AppColors.whiteColor),
                      ),
                    ],
                  ),
                  SizedBox(height: 5.h),

                  // Outlet Name
                  Text(
                    jobData['outletName'],
                    style: CustomTextInter.medium12(AppColors.whiteColor),
                  ),
                ],
              ),
            ),

            // **Share & Options Button inside white circular container**
            Positioned(
              top: 15.h,
              right: 20.w,
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(6.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.share, color: Colors.black, size: 22.sp),
                  ),
                  SizedBox(width: 10.w),
                  PopupMenuButton<String>(
                    icon: Icon(Icons.more_vert, color: Colors.white, size: 22.sp),
                    onSelected: (String result) {
                      // Handle menu selection
                    },
                    itemBuilder: (BuildContext context) => [
                      PopupMenuItem<String>(value: 'view', child: Text('View')),
                      PopupMenuItem<String>(value: 'delete', child: Text('Delete')),
                    ],
                  ),
                ],
              ),
            ),

            // **Status Badge for Completed, Cancelled, or No-Show**
            if (tabType != "upcoming")
              Positioned(
                top: 15.h,
                right: 70.w,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.h),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(60),
                    color: statusColor.withOpacity(0.2),
                  ),
                  child: Text(
                    statusText,
                    style: CustomTextInter.medium14(statusTextColor),
                  ),
                ),
              ),

            // Shift Section - Stacked Label & Timing
            Positioned(
              bottom: 20.h,
              left: 20.w,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Shift Label
                  Row(
                    children: [
                      Icon(Icons.access_time, color: Colors.white, size: 16.sp),
                      SizedBox(width: 5.w),
                      Text(
                        'Shift',
                        style: CustomTextInter.medium12(AppColors.whiteColor),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),

                  // Shift Start & End Time
                  Row(
                    children: [
                      _buildTimeContainer(shiftStartTime, Colors.blueAccent),
                      SizedBox(width: 8.w),
                      Text('to', style: CustomTextInter.medium12(AppColors.whiteColor)),
                      SizedBox(width: 8.w),
                      _buildTimeContainer(shiftEndTime, Colors.black54),
                    ],
                  ),
                ],
              ),
            ),

            // Wage & Pay Rate for Ongoing & Completed Jobs
            if (tabType == "upcoming" || tabType == "completed")
              Positioned(
                bottom: 10.h,
                right: 20.w,
                child: _buildWageWidget(jobData['totalWage'], jobData['ratePerHour']),
              ),

            // Penalty for Cancelled & No-Show Jobs
            if (penaltyWidget != null)
              Positioned(
                bottom: 10.h,
                right: 20.w,
                child: penaltyWidget,
              ),
          ],
        ),
      ],
    ),
    );
  }

  // **Helper Function: Build Time Container**
  Widget _buildTimeContainer(String time, Color bgColor) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: bgColor,
      ),
      child: Text(
        time,
        style: CustomTextInter.medium12(AppColors.whiteColor),
      ),
    );
  }

  // **Helper Function: Build Wage Widget**
  Widget _buildWageWidget(String totalWage, String ratePerHour) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.yellowAccent,
      ),
      child: Column(
        children: [
          Text(
            totalWage,
            style: CustomTextInter.bold14(Colors.black),
          ),
          Text(
            ratePerHour,
            style: CustomTextInter.medium12(Colors.black),
          ),
        ],
      ),
    );
  }

  // **Helper Function: Build Penalty Widget**
  Widget _buildPenaltyWidget(String penaltyAmount) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.redAccent.withOpacity(0.2),
      ),
      child: Text(
        "- $penaltyAmount",
        style: CustomTextInter.medium12(Colors.red),
      ),
    );
  }
}
