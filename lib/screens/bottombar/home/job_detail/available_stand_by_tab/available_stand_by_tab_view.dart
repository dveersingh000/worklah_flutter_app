// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:work_lah/screens/bottombar/home/job_detail/common_widgets.dart';
import 'package:work_lah/utility/colors.dart';
import 'package:work_lah/utility/dashed_divider.dart';
import 'package:work_lah/utility/display_function.dart';
import 'package:work_lah/utility/image_path.dart';
import 'package:work_lah/utility/style_inter.dart';
import 'package:work_lah/utility/syle_poppins.dart';

class AvailableStandByTabView extends StatefulWidget {
  const AvailableStandByTabView({super.key});

  @override
  State<AvailableStandByTabView> createState() =>
      _AvailableStandByTabViewState();
}

class _AvailableStandByTabViewState extends State<AvailableStandByTabView> {
  var employerDetails = [
    {
      'icon': Icons.tag,
      'title': 'Job ID',
      'subTitle': 'ID180432',
    },
    {
      'icon': Icons.access_time_outlined,
      'title': 'Job Duration',
      'subTitle': '4 Hrs',
    },
    {
      'icon': Icons.calendar_month_outlined,
      'title': 'Job Dates',
      'subTitle': '4, Sat | 6, Mon',
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
  int selectedTim = 0;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: commonHeight(context) * 0.02),
          Padding(
            padding: EdgeInsets.only(right: 20.w, left: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Interested applicants may join shift\'s standby list.',
                  style: CustomTextInter.regular12(AppColors.blackColor),
                ),
                SizedBox(height: 10.h),
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
                      style: CustomTextInter.semiBold10(AppColors.standbyColor),
                    ),
                  ],
                ),
                SizedBox(height: 10.h),
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color(0XFFFFFAF0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                      itemCount: 3,
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return availableVaccancyWidget(index);
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 30.h),
          Padding(
            padding: EdgeInsets.only(right: 20.w, left: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                JobRequirements(
                  jobRequire: ['Black T-shirt'],
                ),
                SizedBox(height: 30.h),
                LocationWidget(locationData: {}),
                SizedBox(height: 20.h),
                EmployerWidget(
                  employerDetails: employerDetails,
                  companyName: '',
                  img: '',
                ),
                SizedBox(height: 20.h),
                CompleteYourProfile(
                  jobData: {},
                  profileComplete: true,
                  userId: '',
                  jobDate: '',
                  shiftId: '',
                ),
              ],
            ),
          ),
          SizedBox(height: commonHeight(context) * 0.05),
        ],
      ),
    );
  }

  Widget availableVaccancyWidget(int index) {
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
                      '4',
                      style: CustomTextPopins.light32(AppColors.blackColor),
                    ),
                    Text(
                      'Sat',
                      style: CustomTextPopins.regular12(AppColors.blackColor),
                    ),
                    Text(
                      'Nov',
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
                GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedTim = index;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.only(
                      top: 5.h,
                      bottom: 5.h,
                      left: 8.w,
                      right: 8.w,
                    ),
                    decoration: BoxDecoration(
                      color: selectedTim == index
                          ? AppColors.orangeColor
                          : Colors.transparent,
                      border: Border.all(color: AppColors.orangeColor),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '05:00 PM',
                          style: CustomTextInter.regular12(selectedTim == index
                              ? AppColors.whiteColor
                              : AppColors.blackColor),
                        ),
                        SizedBox(width: 10.w),
                        Container(
                          padding: EdgeInsets.only(
                              top: 2.h, bottom: 2.h, left: 4.w, right: 4.w),
                          decoration: BoxDecoration(
                            color: selectedTim == index
                                ? AppColors.lightOrangeColor
                                : AppColors.orangeColor.withOpacity(0.2),
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
                                '0/2',
                                style: CustomTextInter.regular12(
                                    AppColors.blackColor),
                              ),
                            ],
                          ),
                        ),
                      ],
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
                    color: AppColors.orangeColor.withOpacity(0.1),
                  ),
                  child: Text(
                    '2 seats left',
                    style: CustomTextInter.medium12(AppColors.orangeColor),
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
                    '\$58',
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
}
