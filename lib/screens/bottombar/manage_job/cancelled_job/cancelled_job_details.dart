// ignore_for_file: prefer_const_constructors

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

class CancelledJobDetails extends StatefulWidget {
  final String jobID;
  const CancelledJobDetails({super.key, required this.jobID});

  @override
  State<CancelledJobDetails> createState() => _CancelledJobDetailsState();
}

class _CancelledJobDetailsState extends State<CancelledJobDetails> {
  bool jobDetailsLoading = false;
  Map<String, dynamic> jobDetailsData = {};

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
      var response = await ApiProvider()
          .getRequest(apiUrl: '/api/jobs/details/${widget.jobID}');
      setState(() {
        jobDetailsData = response['job'];
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
                              jobScropDesc: jobDetailsData['jobScope'],
                            ),
                            availabeShiftText(),
                            SizedBox(height: 15.h),
                          ],
                        ),
                      ),
                      AvailableTabView(
                        data: jobDetailsData,
                        whereFrom: 'CancelledJobDetails',
                      ),
                    ],
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
          'Cancelled Shifts',
          style: CustomTextInter.medium16(AppColors.blackColor),
        ),
      ],
    );
  }
}
