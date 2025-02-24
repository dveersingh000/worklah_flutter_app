// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:work_lah/data/send_request.dart';
import 'package:work_lah/utility/colors.dart';
import 'package:work_lah/utility/image_path.dart';
import 'package:work_lah/utility/style_inter.dart';
import 'package:work_lah/utility/syle_poppins.dart';

class AvailableShiftsWidget extends StatefulWidget {
  const AvailableShiftsWidget({super.key});

  @override
  _AvailableShiftsWidgetState createState() => _AvailableShiftsWidgetState();
}

class _AvailableShiftsWidgetState extends State<AvailableShiftsWidget> {
  Map<String, bool> expandedSections = {}; // Track expanded states
  List<Map<String, dynamic>> dummyShifts = [
    {
      "date": "8 Wed Nov",
      "appliedShifts": 2,
      "availableShifts": 3,
      "shifts": [
        {
          "startTime": "11:00 AM",
          "endTime": "02:00 PM",
          "duration": 3,
          "breakDuration": 1,
          "breakPaid": false,
          "totalWage": 60,
          "hourlyRate": "\$30/hr",
          "vacancy": "0/10",
          "standbyVacancy": "-/-",
          "isSelected": false,
        },
        {
          "startTime": "01:00 PM",
          "endTime": "05:00 PM",
          "duration": 4,
          "breakDuration": 1,
          "breakPaid": true,
          "totalWage": 80,
          "hourlyRate": "\$20/hr",
          "vacancy": "6/10",
          "standbyVacancy": "-/-",
          "isSelected": false,
        },
        {
          "startTime": "06:00 PM",
          "endTime": "09:00 PM",
          "duration": 3,
          "breakDuration": 1,
          "breakPaid": false,
          "totalWage": 100,
          "hourlyRate": "\$50/hr",
          "vacancy": "10/10",
          "standbyVacancy": "0/2",
          "isSelected": false,
        },
      ],
    },
  ];

  void toggleShiftSelection(int sectionIndex, int shiftIndex) {
    setState(() {
      dummyShifts[sectionIndex]['shifts'][shiftIndex]['isSelected'] =
          !dummyShifts[sectionIndex]['shifts'][shiftIndex]['isSelected'];
    });
  }

  void toggleSectionExpansion(String date) {
    setState(() {
      expandedSections[date] = !(expandedSections[date] ?? false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: dummyShifts.length,
      itemBuilder: (context, index) {
        var shiftGroup = dummyShifts[index];
        bool isExpanded = expandedSections[shiftGroup["date"]] ?? false;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 📅 Shift Date Header with Dropdown
            GestureDetector(
              onTap: () => toggleSectionExpansion(shiftGroup["date"]),
              child: Container(
                margin: EdgeInsets.only(bottom: 10.h),
                padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 12.h),
                decoration: BoxDecoration(
                  color: AppColors.whiteColor,
                  borderRadius: BorderRadius.circular(10.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 5,
                      spreadRadius: 1,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      shiftGroup["date"],
                      style: CustomTextInter.bold16(AppColors.blackColor),
                    ),
                    Row(
                      children: [
                        Text(
                          "${shiftGroup['appliedShifts']} Applied Shifts",
                          style: CustomTextInter.medium12(AppColors.themeColor),
                        ),
                        SizedBox(width: 10.w),
                        Text(
                          "${shiftGroup['availableShifts']} Available Shifts",
                          style: CustomTextInter.medium12(AppColors.fieldHintColor),
                        ),
                        SizedBox(width: 5.w),
                        Icon(
                          isExpanded
                              ? Icons.keyboard_arrow_up
                              : Icons.keyboard_arrow_down,
                          color: AppColors.blackColor,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // 🔹 Shift Cards (Only Show if Expanded)
            if (isExpanded)
              ListView.separated(
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                itemCount: shiftGroup['shifts'].length,
                separatorBuilder: (context, _) => SizedBox(height: 10.h),
                itemBuilder: (context, shiftIndex) {
                  var shift = shiftGroup['shifts'][shiftIndex];

                  return Container(
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.r),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 5,
                          spreadRadius: 1,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 🕒 Shift Timing
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                _timeBox(shift['startTime']),
                                SizedBox(width: 5.w),
                                Text("to"),
                                SizedBox(width: 5.w),
                                _timeBox(shift['endTime']),
                              ],
                            ),
                            _availabilityBox(shift['vacancy'], shift['standbyVacancy']),
                          ],
                        ),
                        SizedBox(height: 10.h),

                        // ⏳ Duration & Break
                        Row(
                          children: [
                            Icon(Icons.access_time, color: AppColors.themeColor, size: 18.sp),
                            SizedBox(width: 5.w),
                            Text("${shift['duration']} hrs duration",
                                style: CustomTextInter.medium12(AppColors.blackColor)),
                            Spacer(),
                            Icon(Icons.coffee, color: AppColors.fieldHintColor, size: 18.sp),
                            SizedBox(width: 5.w),
                            Text(
                              "${shift['breakDuration']} hr break (${shift['breakPaid'] ? 'Paid' : 'Unpaid'})",
                              style: CustomTextInter.medium12(AppColors.blackColor),
                            ),
                          ],
                        ),
                        SizedBox(height: 10.h),

                        // 💲 Wage
                        Row(
                          children: [
                            Icon(Icons.attach_money, color: Colors.green, size: 18.sp),
                            SizedBox(width: 5.w),
                            Text("\$${shift['totalWage']} (${shift['hourlyRate']})",
                                style: CustomTextInter.bold14(AppColors.blackColor)),
                          ],
                        ),
                        SizedBox(height: 15.h),

                        // ✅ Apply / Selected Button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              toggleShiftSelection(index, shiftIndex);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: shift['isSelected']
                                  ? Colors.green
                                  : AppColors.themeColor,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
                              padding: EdgeInsets.symmetric(vertical: 12.h),
                            ),
                            child: Text(
                              shift['isSelected'] ? "Selected" : "Select",
                              style: CustomTextInter.bold16(AppColors.whiteColor),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            SizedBox(height: 20.h),
          ],
        );
      },
    );
  }

  Widget _timeBox(String time) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
        color: AppColors.themeColor.withOpacity(0.1),
      ),
      child: Text(
        time,
        style: CustomTextInter.bold14(AppColors.blackColor),
      ),
    );
  }
}

  Widget _availabilityBox(String applied, String standby) {
    return Row(
      children: [
        _pill("$applied", AppColors.fieldHintColor),
        SizedBox(width: 5.w),
        _pill("Standby $standby", AppColors.lightOrangeColor),
      ],
    );
  }

  Widget _pill(String text, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Text(
        text,
        style: CustomTextInter.bold12(AppColors.blackColor),
      ),
    );
  }


class JobNameWidget extends StatelessWidget {
  final String? jobTitle;
  final String? jobSubTitle;
  const JobNameWidget({
    super.key,
    this.jobTitle,
    this.jobSubTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 10.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.asset(ImagePath.dishIMG),
              SizedBox(width: 10.w),
              Text(
                jobTitle ?? 'Unknown Job',
                style: CustomTextInter.semiBold24(AppColors.blackColor),
              ),
            ],
          ),
          Text(
            jobSubTitle ?? 'Unknown Outlet', // ✅ Using Outlet Name Instead of Subtitle
            style: CustomTextPopins.medium14(AppColors.subTitColor),
          )
        ],
      ),
    );
  }
}

class JobIMGWidget extends StatelessWidget {
  final String? posterIMG;
  // final String? smallIMG;
  final String? outletImage;
  const JobIMGWidget({super.key, this.posterIMG, this.outletImage});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        /// ✅ Background Image (Outlet Image)
        Padding(
          padding: const EdgeInsets.only(top: 20),
          child: outletImage != null && outletImage!.isNotEmpty
              ? Image.network(
                  '${ApiProvider().baseUrl}$outletImage',
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 180.h, // ✅ Adjust height based on UI
                )
              : Image.asset(
                  ImagePath.trayCollector, // ✅ Default image
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 180.h,
                ),
        ),
        /// ✅ Share Icon (Floating at Bottom Right)
        Positioned(
          bottom: 10.h,
          right: 20.w,
          child: Container(
            height: 45.h,
            width: 45.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.whiteColor,
            ),
            child: Icon(
              Icons.share,
              color: AppColors.blackColor,
              size: 21.sp,
            ),
          ),
        ),
      ],
    );
  }
}


class JobScopsWidget extends StatelessWidget {
  final List<dynamic> jobScropDesc;
  const JobScopsWidget({super.key, required this.jobScropDesc});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Icon(
              Icons.my_location_outlined,
              color: AppColors.blackColor,
            ),
            SizedBox(width: 5.w),
            Text(
              'Job Scope',
              style: CustomTextInter.medium16(AppColors.blackColor),
            ),
          ],
        ),
        SizedBox(height: 10.h),
        ListView.builder(
          itemCount: jobScropDesc.length,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          itemBuilder: (context, index) {
            return commonBulletPoint(jobScropDesc[index].toString());
          },
        ),
        SizedBox(height: 20.h),
      ],
    );
  }

  Widget commonBulletPoint(String text) {
    return Padding(
      padding: EdgeInsets.only(right: 10.w, left: 10.w),
      child: Row(
        children: [
          Icon(
            Icons.circle,
            color: AppColors.blackColor,
            size: 6.sp,
          ),
          SizedBox(width: 8.w),
          Text(
            text,
            style: CustomTextInter.light14(AppColors.blackColor),
          )
        ],
      ),
    );
  }
}
class JobRequirementWidget extends StatelessWidget {
  final List<dynamic> jobRequirements;
  const JobRequirementWidget({super.key, required this.jobRequirements});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Icon(
              Icons.check_circle_outline,
              color: AppColors.blackColor,
            ),
            SizedBox(width: 5.w),
            Text(
              'Job Requirements',
              style: CustomTextInter.medium16(AppColors.blackColor),
            ),
          ],
        ),
        SizedBox(height: 10.h),
        ListView.builder(
          itemCount: jobRequirements.length,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          itemBuilder: (context, index) {
            return commonBulletPoint(jobRequirements[index].toString());
          },
        ),
        SizedBox(height: 20.h),
      ],
    );
  }

  Widget commonBulletPoint(String text) {
    return Padding(
      padding: EdgeInsets.only(right: 10.w, left: 10.w),
      child: Row(
        children: [
          Icon(
            Icons.circle,
            color: AppColors.blackColor,
            size: 6.sp,
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              text,
              style: CustomTextInter.light14(AppColors.blackColor),
            ),
          ),
        ],
      ),
    );
  }
}


