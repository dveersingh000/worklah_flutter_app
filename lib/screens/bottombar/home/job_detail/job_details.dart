// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:work_lah/data/send_request.dart';
import 'package:work_lah/screens/bottombar/home/job_detail/available_tab/available_tab_view.dart';
import 'package:work_lah/screens/bottombar/home/job_detail/common_widgets.dart';
import 'package:work_lah/screens/bottombar/home/job_detail/job_details_widget.dart';
import 'package:work_lah/utility/colors.dart';
import 'package:work_lah/utility/custom_appbar.dart';
import 'package:work_lah/utility/display_function.dart';
import 'package:work_lah/utility/style_inter.dart';
import 'package:work_lah/utility/syle_poppins.dart';
import 'package:work_lah/utility/top_app_bar.dart';

class JobDetailsScreen extends StatefulWidget {
  final String jobID;
  const JobDetailsScreen({super.key, required this.jobID});

  @override
  State<JobDetailsScreen> createState() => _JobDetailsScreenState();
}

class _JobDetailsScreenState extends State<JobDetailsScreen> {
  bool jobDetailsLoading = false;
  Map<String, dynamic> jobDetailsData = {};
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    getJobDetailWithID();
  }

  void getJobDetailWithID() async {
    setState(() {
      jobDetailsLoading = true;
    });

    try {
      var response =
          await ApiProvider().getRequest(apiUrl: '/api/jobs/${widget.jobID}');

      if (response != null && response.containsKey('job')) {
        setState(() {
          jobDetailsData = response['job']; // ✅ Assign 'job' object
          jobDetailsLoading = false;
        });
      } else {
        log('Error: Invalid response structure');
        toast('Failed to fetch job details');
        setState(() {
          jobDetailsLoading = false;
        });
      }
    } catch (e) {
      log('Error fetching job details: $e');
      toast('An error occurred while fetching job details');
      setState(() {
        jobDetailsLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var employerData = jobDetailsData['employer'] ?? {};

    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: Stack(
        children: [
          // 🔹 Scrollable Job Details
          SingleChildScrollView(
            child: Column(
              children: [
                TopAppBar(title: ''),
                SizedBox(height: commonHeight(context) * 0.01),
                Padding(
                  padding: EdgeInsets.only(left: 10.w, right: 10.w),
                  child: CustomAppbar(title: ''),
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
                          JobNameWidget(
                            jobTitle: jobDetailsData['jobName'] ?? 'Unknown Job',
                            jobSubTitle: jobDetailsData['outlet']?['name'] ??
                                'Unknown Outlet',
                          ),
                          JobIMGWidget(
                            posterIMG: jobDetailsData['jobIcon'] ?? '',
                          ),
                          Padding(
                            padding:
                                EdgeInsets.only(right: 20.w, top: 10.h, left: 20.w),
                            child: Column(
                              children: [
                                JobScopsWidget(
                                  jobScropDesc:
                                      jobDetailsData['jobScope'] ?? [],
                                ),
                                JobRequirementWidget(
                                  jobRequirements:
                                      jobDetailsData['jobRequirements'] ?? [],
                                ),
                                availabeShiftText(),
                                SizedBox(height: 15.h),
                                AvailableShiftsWidget(),
                                LocationWidget(
                                  locationData:
                                      jobDetailsData['locationCoordinates'],
                                ),
                                SizedBox(height: 20.h),
                                EmployerWidget(
                                  employerName:
                                      employerData['name']?.toString() ?? 'N/A',
                                  employerLogo:
                                      employerData['logo']?.toString() ?? '',
                                  jobId: jobDetailsData['id']?.toString() ?? '',
                                  jobCategory:
                                      jobDetailsData['jobCategory']?.toString() ??
                                          'N/A',
                                  jobLocation:
                                      jobDetailsData['location']?.toString() ??
                                          'N/A',
                                  jobDates: jobDetailsData['jobDates'] != null
                                      ? jobDetailsData['jobDates']
                                          .map((date) => date['date'].toString())
                                          .join(' | ')
                                      : 'N/A',
                                ),
                                SizedBox(height: 150.h),
                              ],
                            ),
                          ),
                        ],
                      ),
              ],
            ),
          ),

          // 🔽 **Bottom UI - Confirm Booking & Cancel Buttons**
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.all(15.w),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    spreadRadius: 2,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // ✅ Confirm Booking Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        toast('Booking Confirmed!');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.themeColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 15.h),
                      ),
                      child: Text(
                        'Confirm Booking',
                        style: CustomTextInter.bold16(AppColors.whiteColor),
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
                        side: BorderSide(color: AppColors.themeColor),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 15.h),
                      ),
                      child: Text(
                        'Cancel',
                        style: CustomTextInter.bold16(AppColors.themeColor),
                      ),
                    ),
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
    return Row(
      children: [
        Icon(
          Icons.history_toggle_off_outlined,
          color: AppColors.blackColor,
        ),
        SizedBox(width: 5.w),
        Text(
          'Available Shifts',
          style: CustomTextInter.medium16(AppColors.blackColor),
        ),
      ],
    );
  }
}

//   @override
//   Widget build(BuildContext context) {
//     var employerData = jobDetailsData['employer'] ?? {};
//     return Scaffold(
//       backgroundColor: AppColors.whiteColor,
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             TopAppBar(title: ''),
//             SizedBox(height: commonHeight(context) * 0.01),
//             Padding(
//               padding: EdgeInsets.only(left: 10.w, right: 10.w),
//               child: CustomAppbar(title: ''),
//             ),
//             jobDetailsLoading
//                 ? SizedBox(
//                     height: commonHeight(context) * 0.5,
//                     child: Center(
//                       child: CircularProgressIndicator(
//                           color: AppColors.themeColor),
//                     ),
//                   )
//                 : Column(
//                     children: [
//                       SizedBox(height: commonHeight(context) * 0.03),
//                       JobNameWidget(
//                         jobTitle: jobDetailsData['jobName'] ?? 'Unknown Job',
//                         jobSubTitle: jobDetailsData['outlet']?['name'] ??
//                             'Unknown Outlet',
//                       ),
//                       JobIMGWidget(
//                         posterIMG: jobDetailsData['jobIcon'] ?? '',
//                       ),
//                       Padding(
//                         padding:
//                             EdgeInsets.only(right: 20.w, top: 10.h, left: 20.w),
//                         child: Column(
//                           children: [
//                             // JobSalary(
//                             //   salary: jobDetailsData['salary'].toString(),
//                             // ),
//                             JobScopsWidget(
//                               jobScropDesc:
//                                   jobDetailsData['jobScope'] ?? [], // ✅ Updated
//                             ),
//                             JobRequirementWidget(
//                               jobRequirements:
//                                   jobDetailsData['jobRequirements'] ??
//                                       [], // 🔥 Job Requirements Added
//                             ),
//                             availabeShiftText(),
//                             SizedBox(height: 15.h),
//                             AvailableShiftsWidget(),
//                             // 📍 Location Widget
//                             LocationWidget(
//                               locationData:
//                                   jobDetailsData['locationCoordinates'],
//                             ),

//                             SizedBox(height: 20.h),

//                             // 🏢 Employer Details
//                             EmployerWidget(
//                               employerName: employerData['name']?.toString() ?? 'N/A',
//                               employerLogo: employerData['logo']?.toString() ?? '',
//                               jobId: jobDetailsData['id']?.toString() ?? '',
//                               jobCategory: jobDetailsData['jobCategory']?.toString() ?? 'N/A',
//                               jobLocation: jobDetailsData['location']?.toString() ?? 'N/A',
//                               jobDates: jobDetailsData['jobDates'] != null
//                                   ? jobDetailsData['jobDates']
//                                       .map((date) => date['date'].toString())
//                                       .join(' | ')
//                                   : 'N/A',
//                             ),
//                             SizedBox(height: 150.h),
//                           ],
//                         ),
//                       ),
//                       // AvailableTabView(
//                       //   data: jobDetailsData,
//                       //   whereFrom: 'JobDetails',
//                       // ),
//                     ],
//                   ),
//           ],
//         ),
//       ),
      
//     );
//   }
// }
// //   Widget commonTabWidget(bool isAvailableTab, int index) {
// //     return GestureDetector(
// //       onTap: () {
// //         setState(() {
// //           selectedIndex = index;
// //         });
// //       },
// //       child: Container(
// //         height: 43.h,
// //         width: double.infinity,
// //         decoration: BoxDecoration(
// //           borderRadius: BorderRadius.circular(10),
// //           color: AppColors.whiteColor,
// //           border: Border.all(
// //             color: selectedIndex == index
// //                 ? AppColors.blackColor
// //                 : AppColors.lightBorderColor,
// //           ),
// //           boxShadow: selectedIndex == index
// //               ? [
// //                   BoxShadow(
// //                     blurRadius: 4,
// //                     color: AppColors.blackColor.withOpacity(0.2),
// //                     offset: Offset(0, 4),
// //                   ),
// //                 ]
// //               : [],
// //         ),
// //         child: Row(
// //           mainAxisAlignment: isAvailableTab
// //               ? MainAxisAlignment.center
// //               : MainAxisAlignment.spaceEvenly,
// //           children: [
// //             isAvailableTab
// //                 ? Container(
// //                     height: 10.h,
// //                     width: 10.w,
// //                     decoration: BoxDecoration(
// //                       shape: BoxShape.circle,
// //                       border: Border.all(color: AppColors.themeColor),
// //                       color: AppColors.themeColor.withOpacity(0.1),
// //                     ),
// //                   )
// //                 : Container(
// //                     height: 20.h,
// //                     width: 20.w,
// //                     decoration: BoxDecoration(
// //                       shape: BoxShape.circle,
// //                       border: Border.all(
// //                         color: AppColors.lightOrangeColor,
// //                       ),
// //                       color: AppColors.lightOrangeColor,
// //                     ),
// //                     child: Center(
// //                       child: Icon(
// //                         Icons.person,
// //                         color: AppColors.blackColor,
// //                         size: 10.sp,
// //                       ),
// //                     ),
// //                   ),
// //             isAvailableTab ? SizedBox(width: 5.w) : SizedBox(),
// //             Text(
// //               isAvailableTab ? 'Available' : 'Available Standby',
// //               style: CustomTextPopins.light12(AppColors.blackColor),
// //             ),
// //             isAvailableTab
// //                 ? SizedBox()
// //                 : Icon(
// //                     Icons.info_outline,
// //                     color: AppColors.blackColor,
// //                     size: 20.sp,
// //                   ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }

//   Widget availabeShiftText() {
//     return Row(
//       children: [
//         Icon(
//           Icons.history_toggle_off_outlined,
//           color: AppColors.blackColor,
//         ),
//         SizedBox(width: 5.w),
//         Text(
//           'Available Shifts',
//           style: CustomTextInter.medium16(AppColors.blackColor),
//         ),
//       ],
//     );
//   }
