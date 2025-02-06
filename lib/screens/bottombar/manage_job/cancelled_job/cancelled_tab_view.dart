// ignore_for_file: prefer_const_constructors

import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:work_lah/data/send_request.dart';
import 'package:work_lah/screens/bottombar/manage_job/common_widget.dart';
import 'package:work_lah/utility/colors.dart';
import 'package:work_lah/utility/display_function.dart';

class CancelledTabView extends StatefulWidget {
  const CancelledTabView({super.key});

  @override
  State<CancelledTabView> createState() => _CancelledTabViewState();
}

class _CancelledTabViewState extends State<CancelledTabView> {
  bool isCancelledJobLoading = false;
  var onCancelledJobData = [];

  @override
  void initState() {
    super.initState();
    getCancelledJob();
  }

  void getCancelledJob() async {
    setState(() {
      isCancelledJobLoading = true;
    });
    try {
      var response =
          await ApiProvider().getRequest(apiUrl: '/api/jobs/cancelled');
      setState(() {
        onCancelledJobData = response['jobs'];
        isCancelledJobLoading = false;
      });
    } catch (e) {
      log('Error during Res: $e');
      final errorMessage = e is Map ? e['message'] : 'An error occurred';
      toast(errorMessage);
      setState(() {
        isCancelledJobLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return isCancelledJobLoading
        ? Center(
            child: CircularProgressIndicator(color: AppColors.themeColor),
          )
        : onCancelledJobData.isEmpty
            ? Center(
                child: Text('No Cancelled Job Found!'),
              )
            : ListView.separated(
                separatorBuilder: (context, index) => SizedBox(height: 20.h),
                itemCount: onCancelledJobData.length,
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  return CommonJobWidget(
                    jobData: onCancelledJobData[index],
                    isCancelled: true,
                  );
                },
              );
  }
}
