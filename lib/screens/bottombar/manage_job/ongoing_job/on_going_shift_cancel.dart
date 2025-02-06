// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:work_lah/data/send_request.dart';
import 'package:work_lah/screens/bottombar/bottom_bar_screen.dart';
import 'package:work_lah/screens/bottombar/home/job_detail/job_details_widget.dart';
import 'package:work_lah/utility/colors.dart';
import 'package:work_lah/utility/custom_appbar.dart';
import 'package:work_lah/utility/dashed_divider.dart';
import 'package:work_lah/utility/display_function.dart';
import 'package:work_lah/utility/image_path.dart';
import 'package:work_lah/utility/style_inter.dart';
import 'package:work_lah/utility/syle_poppins.dart';

class OnGoingShiftCancel extends StatefulWidget {
  final Map<String, dynamic> data;
  const OnGoingShiftCancel({super.key, required this.data});

  @override
  State<OnGoingShiftCancel> createState() => _OnGoingShiftCancelState();
}

class _OnGoingShiftCancelState extends State<OnGoingShiftCancel> {
  final ScrollController scrollController = ScrollController();
  List<int?> selectedTim = [];
  TextEditingController reasonController = TextEditingController();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    selectedTim = List.filled(widget.data['shiftsAvailable'].length, 0);
  }

  void cancelJob() async {
    setState(() {
      isLoading = true;
    });
    try {
      var response = await ApiProvider().postRequest(
        apiUrl: '/api/jobs/${widget.data['applicationId']}/cancel',
        data: {
          "applicationId": widget.data['applicationId'].toString(),
          "reason": reasonController.text,
        },
      );
      toast(response['message']);
      setState(() {
        isLoading = false;
      });
      moveReplacePage(context, BottomBarScreen(index: 0));
    } catch (e) {
      log('Error during Res: $e');
      final errorMessage = e is Map ? e['message'] : 'An error occurred';
      toast(errorMessage);
      setState(() {
        isLoading = false;
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
              child: CustomAppbar(title: 'Shift Cancellation'),
            ),
            Column(
              children: [
                SizedBox(height: commonHeight(context) * 0.03),
                JobNameWidget(
                  jobTitle: widget.data['jobName'].toString(),
                  jobSubTitle: widget.data['subtitle'].toString(),
                ),
                JobIMGWidget(
                  posterIMG: widget.data['jobIcon'].toString(),
                  smallIMG: widget.data['subtitleIcon'].toString(),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10.h),
                  child: Column(
                    children: [
                      SizedBox(height: 20.h),
                      Padding(
                        padding: EdgeInsets.only(right: 20.w, left: 20.w),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.info,
                              color: AppColors.redColor,
                            ),
                            SizedBox(width: 5.w),
                            Expanded(
                              child: Text(
                                'You are going to cancel this shift, makesure you read all the guidelines of the penalties.',
                                style: CustomTextPopins.regular14(
                                    AppColors.redColor),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20.h),
                      Divider(),
                      SizedBox(height: 20.h),
                      Padding(
                        padding: EdgeInsets.only(right: 20.w, left: 20.w),
                        child: availabeShiftText(),
                      ),
                      SizedBox(height: 20.h),
                      Stack(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            child: Image.asset(
                              ImagePath.backViewIMG,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned.fill(
                            child: Align(
                              alignment: Alignment.center,
                              child: RawScrollbar(
                                controller: scrollController,
                                padding: EdgeInsets.only(
                                  top: 10.h,
                                  bottom: 10.h,
                                  right: 3.w,
                                ),
                                thumbColor: Color(0XFF011D5C),
                                trackColor: AppColors.whiteColor,
                                trackVisibility: true,
                                thumbVisibility: true,
                                trackRadius: Radius.circular(10),
                                thickness: 6,
                                radius: Radius.circular(10),
                                child: ListView.builder(
                                  controller: scrollController,
                                  padding: EdgeInsets.zero,
                                  itemCount:
                                      widget.data['shiftsAvailable'].length,
                                  physics: BouncingScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    return availableVaccancyWidget(
                                      index,
                                      widget.data['shiftsAvailable'][index],
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20.h),
                      Padding(
                        padding: EdgeInsets.only(right: 20.w, left: 20.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            JobSalary(
                              salary: widget.data['salary'].toString(),
                            ),
                            SizedBox(height: 20.h),
                            Text(
                              'Described Reason',
                              style: CustomTextInter.medium16(
                                AppColors.blackColor,
                              ),
                            ),
                            SizedBox(height: 10.h),
                            TextFormField(
                              controller: reasonController,
                              maxLines: 5,
                              decoration: InputDecoration(
                                hintText: 'Describe your reason here',
                                hintStyle: CustomTextInter.regular12(
                                  AppColors.fieldHintColor,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide:
                                      BorderSide(color: Color(0XFFB6B6B6)),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide:
                                      BorderSide(color: Color(0XFFB6B6B6)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide:
                                      BorderSide(color: Color(0XFFB6B6B6)),
                                ),
                              ),
                            ),
                            SizedBox(height: 20.h),
                            commonChip('NOTE:'),
                            SizedBox(height: 20.h),
                            commonRichNote(
                              '1.',
                              'If you accumulate 5 or more points: ',
                              'Businesses have the right to cancel your shift',
                            ),
                            SizedBox(height: 10.h),
                            commonRichNote(
                              '2.',
                              'If you accumulate more than 8 points: ',
                              'Your account will be suspended for 4 weeks',
                            ),
                            SizedBox(height: 50.h),
                            GestureDetector(
                              onTap: () {
                                if (reasonController.text.isNotEmpty) {
                                  cancelJob();
                                } else {
                                  toast('Please Describe Reason');
                                }
                              },
                              child: Container(
                                height: 50.h,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: AppColors.redColor,
                                ),
                                child: Center(
                                  child: isLoading
                                      ? SizedBox(
                                          height: 20.h,
                                          width: 20.w,
                                          child: CircularProgressIndicator(
                                            color: AppColors.whiteColor,
                                          ),
                                        )
                                      : Text(
                                          'Confirm & Cancel',
                                          style: CustomTextPopins.medium16(
                                              AppColors.whiteColor),
                                        ),
                                ),
                              ),
                            ),
                            SizedBox(height: 20.h),
                            GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: Container(
                                height: 50.h,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border:
                                      Border.all(color: AppColors.themeColor),
                                ),
                                child: Center(
                                  child: Text(
                                    'Cancel',
                                    style: CustomTextPopins.medium16(
                                        AppColors.themeColor),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 50.h),
                          ],
                        ),
                      ),
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

  Widget commonChip(String txt) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: AppColors.dangorColor.withOpacity(0.1),
      ),
      child: Text(
        txt,
        style: CustomTextInter.medium12(AppColors.dangorColor),
      ),
    );
  }

  Widget commonRichNote(String count, String t1, String t2) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          count,
          style: CustomTextInter.medium12(AppColors.blackColor),
        ),
        SizedBox(width: 5.w),
        Expanded(
          child: RichText(
            text: TextSpan(
              children: <TextSpan>[
                TextSpan(
                  text: t1,
                  style: CustomTextInter.medium12(
                    AppColors.blackColor,
                  ),
                ),
                TextSpan(
                  text: t2,
                  style: CustomTextInter.medium12(
                    AppColors.dangorColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
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
          'Shifts for Cancellation',
          style: CustomTextInter.medium16(AppColors.blackColor),
        ),
      ],
    );
  }

  Widget availableVaccancyWidget(int parentIndex, var shiftData) {
    DateTime date = DateTime.parse(shiftData['date']);
    String day = DateFormat('d').format(date);
    String weekDay = DateFormat('EEE').format(date);
    String month = DateFormat('MMM').format(date);

    return Padding(
      padding: EdgeInsets.only(
        top: 10.h,
        left: 15.w,
        right: 15.w,
      ),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.only(
          left: 10.w,
          right: 10.w,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.themeColor),
          color: AppColors.whiteColor,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Column(
                  children: [
                    Text(
                      day,
                      style: CustomTextPopins.light32(AppColors.blackColor),
                    ),
                    Text(
                      weekDay,
                      style: CustomTextPopins.regular12(AppColors.blackColor),
                    ),
                    Text(
                      month,
                      style: CustomTextPopins.medium10(AppColors.blackColor),
                    ),
                  ],
                ),
                SizedBox(width: 15.w),
                SizedBox(
                  height: 115.h,
                  width: 2,
                  child: Column(
                    children: List.generate(
                      150 ~/ 2,
                      (index) => Container(
                        color: index % 2 == 0
                            ? Colors.transparent
                            : AppColors.lightBorderColor,
                        height: 1.5,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 5.w),
                Expanded(
                  child: Wrap(
                    spacing: 5,
                    runSpacing: 10,
                    children: List.generate(
                      shiftData['shifts'].length,
                      (index) {
                        return selectedTime(
                          parentIndex,
                          index,
                          shiftData['shifts'][index],
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
            DashedDivider(),
            SizedBox(height: 10.h),
            Row(
              children: [
                Text(
                  'Total vacancy left:',
                  style: CustomTextInter.medium12(AppColors.blackColor),
                ),
                SizedBox(width: 10.w),
                Container(
                  padding: EdgeInsets.only(
                    left: 10.w,
                    right: 10.w,
                    top: 5.h,
                    bottom: 5.h,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(60),
                    color: AppColors.greenColor.withOpacity(0.1),
                  ),
                  child: Text(
                    '${shiftData['shifts'][selectedTim[parentIndex] ?? 0]['vacancy']} seats left',
                    style: CustomTextInter.medium12(AppColors.greenColor),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.h),
            Text(
              'Potential total wages / shift:',
              style: CustomTextInter.medium12(AppColors.blackColor),
            ),
            SizedBox(height: 10.h),
            Row(
              children: [
                Expanded(
                  child: Text(
                    '\$${shiftData['shifts'][selectedTim[parentIndex] ?? 0]['totalWage']}',
                    style: CustomTextInter.medium20(AppColors.greenColor),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '\$12/hr (4hrs) --',
                      style: CustomTextInter.regular10(AppColors.blackColor),
                    ),
                    Text(
                      '1 Hrs (Unpaid Break) / per shift',
                      style: CustomTextInter.regular10(AppColors.blackColor),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 15.h),
          ],
        ),
      ),
    );
  }

  Widget selectedTime(
    int parentIndex,
    int index,
    var dataa,
  ) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: 130.w,
        padding: EdgeInsets.only(
          top: 5.h,
          bottom: 5.h,
          left: 8.w,
          right: 8.w,
        ),
        decoration: BoxDecoration(
          color: selectedTim[parentIndex] == index
              ? AppColors.themeColor
              : Colors.transparent,
          border: Border.all(color: AppColors.themeColor),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              dataa['startTime'].toString(),
              style: CustomTextInter.regular12(selectedTim[parentIndex] == index
                  ? AppColors.whiteColor
                  : AppColors.blackColor),
            ),
            SizedBox(width: 10.w),
            Container(
              padding:
                  EdgeInsets.only(top: 2.h, bottom: 2.h, left: 4.w, right: 4.w),
              decoration: BoxDecoration(
                color: AppColors.chipGreyColor,
                borderRadius: BorderRadius.circular(80),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.person,
                    color: AppColors.orangeColor,
                    size: 10.sp,
                  ),
                  SizedBox(width: 5.w),
                  Text(
                    '${dataa['filledVacancies'].toString()}/${dataa['vacancy'].toString()}',
                    style: CustomTextInter.regular12(AppColors.blackColor),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
