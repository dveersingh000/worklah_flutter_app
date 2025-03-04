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
import 'package:work_lah/screens/bottombar/home/complete_profile/complete_profile.dart';
import 'package:work_lah/screens/bottombar/home/job_detail/job_details_preview_screen.dart';
import 'package:work_lah/screens/bottombar/bottom_bar_screen.dart';

class JobDetailsScreen extends StatefulWidget {
  final String jobID;
  const JobDetailsScreen({super.key, required this.jobID});

  @override
  State<JobDetailsScreen> createState() => _JobDetailsScreenState();
}

class _JobDetailsScreenState extends State<JobDetailsScreen> {
  bool jobDetailsLoading = false;
  bool profileLoading = false;
  Map<String, dynamic> jobDetailsData = {};
  List<dynamic> availableShiftsData = [];
  bool profileCompleted = false;
  int selectedIndex = 0;

  // ✅ Capture Selected Shifts from AvailableShiftsWidget
  List<dynamic> getSelectedShifts() {
    List<dynamic> selectedShifts = [];

    for (var shiftGroup in availableShiftsData) {
      String date = shiftGroup['date'] ?? 'Unknown Date';
      for (var shift in shiftGroup['shifts']) {
        // print("📌 Checking Shift: $shift");
        if (shift['isSelected'] == true) {
          selectedShifts.add({
            ...shift,
            'date': date,
          });
        }
      }
    }
    return selectedShifts;
  }

  @override
  void initState() {
    super.initState();
    getJobDetailWithID();
    getProfileStatus();
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
          availableShiftsData = response['job']['availableShiftsData'] ?? [];
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

  void getProfileStatus() async {
    setState(() {
      profileLoading = true;
    });

    try {
      var response =
          await ApiProvider().getRequest(apiUrl: '/api/profile/stats');

      if (response != null && response.containsKey('profileCompleted')) {
        setState(() {
          profileCompleted = response['profileCompleted'];
        });
      } else {
        log('Error: Invalid profile response structure');
        toast('Failed to fetch profile status');
      }
    } catch (e) {
      log('Error fetching profile status: $e');
      toast('An error occurred while fetching profile status');
    }
  }

  @override
  Widget build(BuildContext context) {
    var employerData = jobDetailsData['employer'] ?? {};

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
                            Padding(
                              padding: EdgeInsets.only(
                                  left: 10.w,
                                  right: 10.w), // ✅ Same as CustomAppbar
                              child: JobNameWidget(
                                jobTitle:
                                    jobDetailsData['jobName'] ?? 'Unknown Job',
                                jobSubTitle: jobDetailsData['outlet']
                                        ?['name'] ??
                                    'Unknown Outlet',
                              ),
                            ),
                            JobIMGWidget(
                              posterIMG:
                                  jobDetailsData['outlet']['image'] ?? '',
                              showShareButton: true,
                              jobTitle:
                                  jobDetailsData['jobName'] ?? 'Unknown Job',
                              jobLocation: jobDetailsData['location'] ??
                                  'Unknown Location',
                              jobUrl:
                                  "https://worklah.onrender.com/api/jobs/${jobDetailsData['id']}",
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  right: 20.w, top: 10.h, left: 20.w),
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
                                  AvailableShiftsWidget(
                                    availableShiftsData: availableShiftsData,
                                  ),
                                  SizedBox(height: 20.h),
                                  Container(
                                    padding: EdgeInsets.all(20),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Color(0XFFFFDDBD),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                                style:
                                                    CustomTextInter.regular12(
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
                                                style:
                                                    CustomTextInter.regular12(
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
                                                style:
                                                    CustomTextInter.regular12(
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
                                        jobDetailsData['locationCoordinates'],
                                  ),

                                  SizedBox(height: 20.h),

                                  // 🏢 Employer Details
                                  EmployerWidget(
                                    employerName:
                                        employerData['name']?.toString() ??
                                            'N/A',
                                    employerLogo:
                                        employerData['logo']?.toString() ?? '',
                                    jobId:
                                        jobDetailsData['id']?.toString() ?? '',
                                    jobCategory: jobDetailsData['jobCategory']
                                            ?.toString() ??
                                        'N/A',
                                    jobLocation: jobDetailsData['location']
                                            ?.toString() ??
                                        'N/A',
                                    jobDates: jobDetailsData[
                                                'availableShiftsData'] !=
                                            null
                                        ? jobDetailsData['availableShiftsData']
                                            .map((date) =>
                                                date['date'].toString())
                                            .join(' | ')
                                        : 'N/A',
                                  ),
                                  SizedBox(height: 20.h),

                                  /// ✅ Button Appears Normally at the End
Padding(
  padding: EdgeInsets.symmetric(horizontal: 20.w),
  child: Column(
    children: [
      /// ✅ "Preview" Button (Always Enabled)
      SizedBox(
        width: double.infinity,
        height: 50.h,
        child: ElevatedButton(
          onPressed: () {
            List<dynamic> selectedShifts = getSelectedShifts();
            if (selectedShifts.isEmpty) {
              // **Show toast message if no shift is selected**
              toast("Please select at least one shift before proceeding.");
              return; // Stop further execution
            }
            if (profileCompleted) {
              // ✅ Wrap with BottomBarScreen so it includes the bottom navigation bar
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BottomBarScreen(
                    index: 0, // ✅ Keep Home as default tab OR pass the correct tab index
                    child: JobDetailsPreviewScreen(
                      jobDetailsData: jobDetailsData,
                      selectedShifts: selectedShifts, // ✅ Pass selected shifts with date
                    ),
                  ),
                ),
              );
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.themeColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.r),
            ),
          ),
          child: Text(
            "Preview",
            style: CustomTextInter.bold16(AppColors.whiteColor),
          ),
        ),
      ),

      SizedBox(height: 10.h),

      /// ✅ "Complete Profile" Button (Always Visible but Disabled if Profile is Completed)
      SizedBox(
        width: double.infinity,
        height: 50.h,
        child: ElevatedButton(
          onPressed: profileCompleted
              ? null // Disabled when profile is completed
              : () {
                  // ✅ Navigate to Complete Profile
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CompleteProfile(
                        jobData: {},
                        shiftID: '',
                        jobDATE: '',
                      ),
                    ),
                  );
                },
          style: ElevatedButton.styleFrom(
            backgroundColor: profileCompleted
                ? Colors.grey.shade400 // Disabled state color
                : Colors.orange, // Active color
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.r),
            ),
          ),
          child: Text(
            "Complete Your Profile",
            style: CustomTextInter.bold16(AppColors.whiteColor),
          ),
        ),
      ),

      /// ✅ Show the warning message always
      Padding(
        padding: EdgeInsets.only(top: 10.h), // ✅ Spacing below the button
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.info, color: Colors.orange, size: 16.sp), // ℹ️ Info icon
            SizedBox(width: 5.w),
            Text(
              profileCompleted
                  ? "Your profile is already completed"
                  : "Complete your profile before shift bookings",
              style: CustomTextInter.medium12(Colors.orange),
            ),
          ],
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
              'Available Shifts',
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
