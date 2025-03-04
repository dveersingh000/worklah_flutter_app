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

  Future<void> _deleteJob(BuildContext context, String jobId) async {
  try {
    var response = await ApiProvider().deleteRequest(
      apiUrl: "/api/jobs/$jobId",
    );

    if (response != null && response['message'] == "Job deleted successfully") {
      toast("Job deleted successfully!");
      Navigator.pop(context); // Go back after delete
    } else {
      toast(response['error'] ?? "Failed to delete job.");
    }
  } catch (e) {
    toast("Error deleting job: $e");
  }
}


  /// **Format Date for UI Display**
  String formatDate(String? date) {
    if (date == null || date.isEmpty) return "N/A";
    try {
      return DateFormat('dd MMM, yy').format(
        DateFormat('dd MMM, yy').parse(date),
      );
    } catch (e) {
      return "Invalid Date";
    }
  }

  @override
  Widget build(BuildContext context) {
    // **Extract Data from API Response**
    String jobDate = formatDate(jobData['jobDate'] ?? jobData['cancelledAt']);
    String shiftStartTime = jobData['shiftStartTime'] ?? "--:--";
    String shiftEndTime = jobData['shiftEndTime'] ?? "--:--";
    String totalWage = jobData['totalWage'] ?? "\$0";
    String ratePerHour = jobData['ratePerHour'] ?? "\$0/hr";
    String penalty = jobData['penalty'] ?? "-";
    String penaltyLabel = jobData['penaltyLabel'] ?? "";
    String reason = jobData['reason'] ?? "No Reason Provided";

    // Determine status label & color
    String statusText = "";
    Color statusColor = Colors.transparent;
    Color statusTextColor = Colors.white;
    Widget? extraWidget;

    if (tabType == "completed") {
      statusText = "Completed";
      statusColor = Colors.greenAccent;
      statusTextColor = Colors.green;
    } else if (tabType == "cancelled") {
      statusText = "Cancelled";
      statusColor = Colors.redAccent;
      statusTextColor = Colors.red;
      extraWidget = _buildPenaltyWidget(penalty);
    } else if (tabType == "no-show") {
      statusText = "No-Show";
      statusColor = Colors.redAccent;
      statusTextColor = Colors.red;
      extraWidget = _buildPenaltyWidget(penalty);
    }

    return GestureDetector(
      onTap: () {
        if (tabType == "completed") {
          // moveToNext(
          //   context,
          //   CompletedJobDetails(jobID: jobData['applicationId']),
          // );
        } else if (tabType == "cancelled") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BottomBarScreen(
                index: 0, // ✅ Set the default tab index (Home or correct index)
                child: CancelledJobDetails(
                  jobID: jobData['applicationId'],
                ),
              ),
            ),
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

          // **Job Card UI**
          Container(
            margin: EdgeInsets.symmetric(horizontal: 15.w),
            padding: EdgeInsets.only(bottom: 15.h), // Increased spacing
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.black, // Dark background
            ),
            child: Stack(
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
                          Colors.black.withOpacity(0.9),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),

                // Job Name & Outlet
                Positioned(
                  top: 5.h,
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
                  top: 5.h,
                  right: 20.w,
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(6.w),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child:
                            Icon(Icons.share, color: Colors.black, size: 22.sp),
                      ),
                      SizedBox(width: 10.w),
                      PopupMenuButton<String>(
                        icon: Icon(Icons.more_vert,
                            color: Colors.white, size: 22.sp),
                        onSelected: (String result) async {
                          if (result == 'view') {
                            Widget screen =
                                SizedBox(); // Default to avoid uninitialized error

                            if (tabType == "upcoming" || tabType == "ongoing") {
                              screen = OnGoingJobDetails(
                                  jobID: jobData['applicationId']);
                            } else if (tabType == "completed") {
                              // screen = CompletedJobDetails(
                              //     jobID: jobData['applicationId']);
                            } else if (tabType == "cancelled") {
                              screen = CancelledJobDetails(
                                  jobID: jobData['applicationId']);
                            } else if (tabType == "no-show") {
                              // screen = NoShowJobDetails(
                              //     jobID: jobData['applicationId']);
                            }

                            if (screen is! SizedBox) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BottomBarScreen(
                                    index: 0,
                                    child: screen,
                                  ),
                                ),
                              );
                            }
                          } else if (result == 'delete') {
                            _confirmDelete(context, jobData['applicationId']);
                          }
                        },
                        itemBuilder: (BuildContext context) => [
                          PopupMenuItem<String>(
                              value: 'view', child: Text('View')),
                          PopupMenuItem<String>(
                              value: 'delete', child: Text('Delete')),
                        ],
                      ),
                    ],
                  ),
                ),

                // **Status Badge for Completed, Cancelled, or No-Show**
                if (tabType == "cancelled")
                  Positioned(
                    top: 50.h,
                    right: 20.w,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        // Cancelled Label
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 12.w, vertical: 3.h),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(60),
                            color: Colors.redAccent.withOpacity(0.5),
                          ),
                          child: Text(
                            statusText,
                            style: CustomTextInter.bold14(Colors.white),
                          ),
                        ),
                        SizedBox(height: 5.h),

                        // Penalty Label
                        if (penaltyLabel.isNotEmpty)
                          Text(
                            penaltyLabel,
                            style: CustomTextInter.medium12(Colors.white),
                          ),
                      ],
                    ),
                  ),
                // Shift Section - Stacked Label & Timing
                Positioned(
                  bottom: 1.h,
                  left: 20.w,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Shift Label
                      Row(
                        children: [
                          Icon(Icons.access_time,
                              color: Colors.white, size: 16.sp),
                          SizedBox(width: 5.w),
                          Text(
                            'Shift',
                            style:
                                CustomTextInter.medium12(AppColors.whiteColor),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.h),

                      // Shift Start & End Time
                      Row(
                        children: [
                          _buildTimeContainer(
                              shiftStartTime, Colors.blueAccent),
                          SizedBox(width: 8.w),
                          Text('to',
                              style: CustomTextInter.medium12(
                                  AppColors.whiteColor)),
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
                    bottom: 1.h,
                    right: 20.w,
                    child: _buildWageWidget(
                        jobData['totalWage'], jobData['ratePerHour']),
                  ),

                // Penalty for Cancelled & No-Show Jobs
                if (extraWidget != null)
                  Positioned(
                    bottom: 1.h,
                    right: 20.w,
                    child: extraWidget,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, String jobId) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Confirm Delete"),
        content: Text("Are you sure you want to delete this job? This action cannot be undone."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), // Cancel action
            child: Text("Cancel", style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context); // Close the dialog
              await _deleteJob(context, jobId); // Call delete function
            },
            child: Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      );
    },
  );
}


  // **Helper Function: Build Time Container**
  Widget _buildTimeContainer(String time, Color bgColor) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Penalty Label with $ Icon
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.currency_exchange, color: Colors.red, size: 16.sp),
            SizedBox(width: 5.w),
            Text(
              "Penalty",
              style: CustomTextInter.medium12(Colors.red),
            ),
          ],
        ),
        SizedBox(height: 5.h),

        // Penalty Amount Box
        Container(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.red),
            color: Colors.white,
          ),
          child: Text(
            penaltyAmount,
            style: CustomTextInter.medium12(Colors.red),
          ),
        ),
      ],
    );
  }
}
