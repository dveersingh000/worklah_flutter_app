// ignore_for_file: prefer_const_constructors

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:work_lah/data/send_request.dart';
import 'package:work_lah/screens/bottombar/manage_job/common_widget.dart';
import 'package:work_lah/utility/colors.dart';
import 'package:work_lah/utility/display_function.dart';

class OnGoingTabView extends StatefulWidget {
  const OnGoingTabView({super.key});

  @override
  State<OnGoingTabView> createState() => _OnGoingTabViewState();
}

class _OnGoingTabViewState extends State<OnGoingTabView> {
  bool isOnGoingJobLoading = false;
  List<dynamic> onGoingJobData = [];

  @override
  void initState() {
    super.initState();
    getOnGoingJob();
  }

  void getOnGoingJob() async {
    setState(() {
      isOnGoingJobLoading = true;
    });
    try {
      var response =
          await ApiProvider().getRequest(apiUrl: '/api/jobs/ongoing');
      setState(() {
        onGoingJobData = response['jobs'];
        isOnGoingJobLoading = false;
      });
    } catch (e) {
      log('Error during Res: $e');
      final errorMessage = e is Map ? e['message'] : 'An error occurred';
      toast(errorMessage);
      setState(() {
        isOnGoingJobLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return isOnGoingJobLoading
        ? Center(
            child: CircularProgressIndicator(color: AppColors.themeColor),
          )
        : onGoingJobData.isEmpty
            ? Center(
                child: Text('No Upcoming Job Found!'),
              )
            : ListView.separated(
                separatorBuilder: (context, index) => SizedBox(height: 20.h),
                itemCount: onGoingJobData.length,
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  return CommonJobWidget(
                    jobData: onGoingJobData[index],
                    tabType: "upcoming", // Pass tabType to differentiate tabs
                  );
                },
              );
  }
}
