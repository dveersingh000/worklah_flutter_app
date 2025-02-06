// ignore_for_file: prefer_const_constructors

import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:work_lah/data/send_request.dart';
import 'package:work_lah/screens/bottombar/manage_job/common_widget.dart';
import 'package:work_lah/utility/colors.dart';
import 'package:work_lah/utility/display_function.dart';

class CompletedTabView extends StatefulWidget {
  const CompletedTabView({super.key});

  @override
  State<CompletedTabView> createState() => _CompletedTabViewState();
}

class _CompletedTabViewState extends State<CompletedTabView> {
  bool isCompletedJobLoading = false;
  var completedJobData = [];

  @override
  void initState() {
    super.initState();
    getCompletedJob();
  }

  void getCompletedJob() async {
    setState(() {
      isCompletedJobLoading = true;
    });
    try {
      var response =
          await ApiProvider().getRequest(apiUrl: '/api/jobs/completed');
      setState(() {
        completedJobData = response['jobs'];
        isCompletedJobLoading = false;
      });
    } catch (e) {
      log('Error during Res: $e');
      final errorMessage = e is Map ? e['message'] : 'An error occurred';
      toast(errorMessage);
      setState(() {
        isCompletedJobLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return isCompletedJobLoading
        ? Center(
            child: CircularProgressIndicator(color: AppColors.themeColor),
          )
        : completedJobData.isEmpty
            ? Center(
                child: Text('No Completed Job Found!'),
              )
            : ListView.separated(
                separatorBuilder: (context, index) => SizedBox(height: 20.h),
                itemCount: completedJobData.length,
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  return CommonJobWidget(
                    jobData: completedJobData[index],
                    icCompleted: true,
                  );
                },
              );
  }
}
