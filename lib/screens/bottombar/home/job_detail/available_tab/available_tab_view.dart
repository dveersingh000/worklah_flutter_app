// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:work_lah/screens/bottombar/home/job_detail/common_widgets.dart';
import 'package:work_lah/screens/bottombar/manage_job/ongoing_job/on_going_shift_cancel.dart';
import 'package:work_lah/screens/model/user_model.dart';
import 'package:work_lah/utility/colors.dart';
import 'package:work_lah/utility/dashed_divider.dart';
import 'package:work_lah/utility/display_function.dart';
import 'package:work_lah/utility/image_path.dart';
import 'package:work_lah/utility/shared_prefs.dart';
import 'package:work_lah/utility/style_inter.dart';
import 'package:work_lah/utility/syle_poppins.dart';

class AvailableTabView extends StatefulWidget {
  final String whereFrom;
  final Map<String, dynamic> data;
  const AvailableTabView(
      {super.key, required this.data, required this.whereFrom});

  @override
  State<AvailableTabView> createState() => _AvailableTabViewState();
}

class _AvailableTabViewState extends State<AvailableTabView> {
  List<int?> selectedTim = [];
  String selectedShiftDate = '';
  String selectedShiftId = '';

  var employerDetails = [
    {
      'icon': Icons.tag,
      'title': 'Job ID',
      'subTitle': 'ID180432',
    },
    {
      'icon': Icons.access_time_outlined,
      'title': 'Job Duration',
      'subTitle': '1 Hrs',
    },
    {
      'icon': Icons.calendar_month_outlined,
      'title': 'Job Dates',
      'subTitle': '2, Sat | 6, Mon',
    },
    {
      'icon': Icons.local_cafe_outlined,
      'title': 'Break Duration',
      'subTitle': '1 Hrs (Unpaid Break)',
    },
    {
      'icon': Icons.business_outlined,
      'title': 'Job Category',
      'subTitle': 'Cleaning',
    },
    {
      'icon': Icons.location_on_outlined,
      'title': 'Location',
      'subTitle': '101 Thomson Rd, Singapore 307591',
    },
  ];

  final ScrollController scrollController = ScrollController();

  bool isTermCheck = false;
  bool isMedicalTermCheck = false;
  bool isBookingTermCheck = false;

  UserModel? userModel;

  @override
  void initState() {
    super.initState();
    selectedTim = List.filled(2, null);
    getUserLocalData();
    debugPrint("AvailableTabView Data: ${widget.data}");
  }
  void printData() {
    print("AvailableTabView Data: ${widget.data}");
  }

  Future<void> getUserLocalData() async {
    UserModel? fetchedUser = await getUserData();
    setState(() {
      userModel = fetchedUser!;
    });
  }

  @override
  Widget build(BuildContext context) {
    var employerData = widget.data['employer'];
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(right: 20.w, left: 20.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                commonLeftWidget('Available Vacancy', AppColors.blackColor),
                commonLeftWidget('Standby Vacancy', AppColors.orangeColor),
              ],
            ),
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
                      // itemCount: widget.data['shiftsAvailable'].length,
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
          SizedBox(height: 10.h),
          Padding(
            padding: EdgeInsets.only(right: 20.w, left: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                widget.whereFrom == 'OnGoingJobDetails' ||
                        widget.whereFrom == 'CancelledJobDetails'
                    ? SizedBox()
                    : Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Color(0XFFFFDDBD),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
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
                                        'Failing to show up after being\n\t\t\tactivated from standby will result in a \$20 penalty.',
                                    style: CustomTextInter.regular12(
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
                                        'A \$10 fee will be charged upon shift\n\t\t\tcompletion for standby booking.',
                                    style: CustomTextInter.regular12(
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
                                        'If you book another shift that\n\t\t\toverlaps with this standby slot, your standby\n\t\t\treservation will be forfeited.',
                                    style: CustomTextInter.regular12(
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
                // SizedBox(height: 20.h),
                // JobRequirements(
                //   jobRequire: widget.whereFrom == 'OnGoingJobDetails' ||
                //           widget.whereFrom == 'CancelledJobDetails'
                //       ? widget.data['jobRequirements']
                //       : widget.data['requirements']['jobRequirements'],
                // ),
                SizedBox(height: 30.h),
                LocationWidget(
                  locationData: widget.data['locationCoordinates'],
                ),
                SizedBox(height: 20.h),
                EmployerWidget(
            employerName: employerData['name'].toString(),
            employerLogo: employerData['logo'].toString(),
            jobId: widget.data['id'].toString(),
            jobCategory: widget.data['jobCategory'].toString(),
            jobLocation: widget.data['location'].toString(),
            jobDates: widget.data['jobDates']
                .map((date) => DateFormat('d MMM').format(DateTime.parse(date['date'])))
                .join(' | '), // Convert job dates to readable format
          ),
                SizedBox(height: 20.h),
                if (widget.whereFrom == 'OnGoingJobDetails') ...[
                  OnGoingJobAlert(),
                  commonCheckBoxes(),
                ],
                if (widget.whereFrom == 'CancelledJobDetails') ...[
                  CancelledJobAlert(
                    paneltyAmount: widget.data['penalty'].toString(),
                    reasonText: widget.data['reason'].toString(),
                  ),
                ],
                if (widget.whereFrom == 'JobDetails') ...[
                  CompleteYourProfile(
                    profileComplete: widget.data['profileCompleted'],
                    jobData: widget.data,
                    userId: userModel?.id ?? '',
                    jobDate: selectedShiftDate,
                    shiftId: selectedShiftId,
                  ),
                ],
              ],
            ),
          ),
          SizedBox(height: commonHeight(context) * 0.05),
        ],
      ),
    );
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
                    '${shiftData['shifts'][selectedTim[parentIndex] ?? 0]['totalWage']}',
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
      onTap: widget.whereFrom == 'OnGoingJobDetails' ||
              widget.whereFrom == 'CancelledJobDetails'
          ? () {}
          : () {
              setState(() {
                selectedTim[parentIndex] = index;
                selectedShiftDate =
                    widget.data['shiftsAvailable'][parentIndex]['date'];
                selectedShiftId = dataa['_id'];
              });
            },
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

  Widget commonCheckBoxes() {
    return Column(
      children: [
        Row(
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  isTermCheck = !isTermCheck;
                });
              },
              child: Container(
                height: 21.h,
                width: 21.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Color(0XFFD9D9D9),
                ),
                child: isTermCheck
                    ? Center(
                        child: Icon(
                          Icons.check,
                          color: AppColors.blackColor,
                          size: 16.sp,
                        ),
                      )
                    : null,
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: RichText(
                text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                      text: 'I agree to the ',
                      style: CustomTextInter.medium12(AppColors.blackColor),
                    ),
                    TextSpan(
                      text: 'Terms and Conditions ',
                      style: CustomTextInter.regular12(
                        AppColors.themeColor,
                        isUnderline: true,
                      ),
                    ),
                    TextSpan(
                      text: 'written in the policy',
                      style: CustomTextInter.medium12(AppColors.blackColor),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 20.h),
        Row(
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  isMedicalTermCheck = !isMedicalTermCheck;
                });
              },
              child: Container(
                height: 21.h,
                width: 21.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Color(0XFFD9D9D9),
                ),
                child: isMedicalTermCheck
                    ? Center(
                        child: Icon(
                          Icons.check,
                          color: AppColors.blackColor,
                          size: 16.sp,
                        ),
                      )
                    : null,
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: RichText(
                text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                      text: 'I understand the ',
                      style: CustomTextInter.medium12(AppColors.blackColor),
                    ),
                    TextSpan(
                      text: 'medical waivers submission terms and conditions ',
                      style: CustomTextInter.regular12(
                        AppColors.themeColor,
                        isUnderline: true,
                      ),
                    ),
                    TextSpan(
                      text:
                          'and also confirm my availability on the day of shift.',
                      style: CustomTextInter.medium12(AppColors.blackColor),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 20.h),
        Row(
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  isBookingTermCheck = !isBookingTermCheck;
                });
              },
              child: Container(
                height: 21.h,
                width: 21.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Color(0XFFD9D9D9),
                ),
                child: isBookingTermCheck
                    ? Center(
                        child: Icon(
                          Icons.check,
                          color: AppColors.blackColor,
                          size: 16.sp,
                        ),
                      )
                    : null,
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: RichText(
                text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                      text:
                          'By booking a standby shift, you agree to be available and ready to work if a vacancy arises.',
                      style: CustomTextInter.medium12(AppColors.blackColor),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 30.h),
        GestureDetector(
          onTap: () {
            if (isTermCheck && isBookingTermCheck && isMedicalTermCheck) {
              moveToNext(context, OnGoingShiftCancel(data: widget.data));
            } else {
              toast('Please check the checkboxes');
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
              child: Text(
                'Cancel Shift',
                style: CustomTextPopins.medium16(AppColors.whiteColor),
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
              border: Border.all(color: AppColors.themeColor),
            ),
            child: Center(
              child: Text(
                'Cancel',
                style: CustomTextPopins.medium16(AppColors.themeColor),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
