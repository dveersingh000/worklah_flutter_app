// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:work_lah/data/send_request.dart';
import 'package:work_lah/screens/bottombar/home/job_detail/available_tab/available_tab_view.dart';
import 'package:work_lah/screens/bottombar/home/job_detail/job_details_widget.dart';
import 'package:work_lah/utility/colors.dart';
import 'package:work_lah/utility/custom_appbar.dart';
import 'package:work_lah/utility/display_function.dart';
import 'package:work_lah/utility/style_inter.dart';
import 'package:work_lah/utility/syle_poppins.dart';

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
      setState(() {
        jobDetailsData = response;
        jobDetailsLoading = false;
      });
    } catch (e) {
      log('Error during response: $e');
      final errorMessage = e is Map ? e['message'] : 'An error occurred';
      toast(errorMessage);
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
                        jobTitle: jobDetailsData['jobName'].toString(),
                        jobSubTitle: jobDetailsData['subtitle'].toString(),
                      ),
                      JobIMGWidget(
                        posterIMG: jobDetailsData['jobIcon'].toString(),
                        smallIMG: jobDetailsData['subtitleIcon'].toString(),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.only(right: 20.w, top: 10.h, left: 20.w),
                        child: Column(
                          children: [
                            JobSalary(
                              salary: jobDetailsData['salary'].toString(),
                            ),
                            JobScopsWidget(
                              jobScropDesc: jobDetailsData['requirements']
                                  ['jobScopeDescription'],
                            ),
                            availabeShiftText(),
                            SizedBox(height: 15.h),
                          ],
                        ),
                      ),
                      AvailableTabView(
                        data: jobDetailsData,
                        whereFrom: 'JobDetails',
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }

  Widget commonTabWidget(bool isAvailableTab, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIndex = index;
        });
      },
      child: Container(
        height: 43.h,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: AppColors.whiteColor,
          border: Border.all(
            color: selectedIndex == index
                ? AppColors.blackColor
                : AppColors.lightBorderColor,
          ),
          boxShadow: selectedIndex == index
              ? [
                  BoxShadow(
                    blurRadius: 4,
                    color: AppColors.blackColor.withOpacity(0.2),
                    offset: Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: Row(
          mainAxisAlignment: isAvailableTab
              ? MainAxisAlignment.center
              : MainAxisAlignment.spaceEvenly,
          children: [
            isAvailableTab
                ? Container(
                    height: 10.h,
                    width: 10.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.themeColor),
                      color: AppColors.themeColor.withOpacity(0.1),
                    ),
                  )
                : Container(
                    height: 20.h,
                    width: 20.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.lightOrangeColor,
                      ),
                      color: AppColors.lightOrangeColor,
                    ),
                    child: Center(
                      child: Icon(
                        Icons.person,
                        color: AppColors.blackColor,
                        size: 10.sp,
                      ),
                    ),
                  ),
            isAvailableTab ? SizedBox(width: 5.w) : SizedBox(),
            Text(
              isAvailableTab ? 'Available' : 'Available Standby',
              style: CustomTextPopins.light12(AppColors.blackColor),
            ),
            isAvailableTab
                ? SizedBox()
                : Icon(
                    Icons.info_outline,
                    color: AppColors.blackColor,
                    size: 20.sp,
                  ),
          ],
        ),
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
