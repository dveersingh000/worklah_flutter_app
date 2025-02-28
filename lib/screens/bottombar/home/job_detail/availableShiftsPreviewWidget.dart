import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:work_lah/utility/colors.dart';
import 'package:work_lah/utility/style_inter.dart';

class AvailableShiftsPreviewWidget extends StatelessWidget {
  final List<dynamic> selectedShifts;

  const AvailableShiftsPreviewWidget({super.key, required this.selectedShifts});

  @override
  Widget build(BuildContext context) {
    Map<String, List<dynamic>> groupedShifts = {}; 
    for (var shift in selectedShifts) {
      String date = shift['date'] ?? 'Unknown Date';
      if (!groupedShifts.containsKey(date)) {
        groupedShifts[date] = [];
      }
      groupedShifts[date]?.add(shift);
    }

    return Column(
      children: groupedShifts.keys.map((date) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// **Date Header**
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 10.w),
              child: Text(
                "📅 $date",
                style: CustomTextInter.bold16(AppColors.blackColor),
              ),
            ),
            
            /// **List of Selected Shifts for This Date**
            Column(
              children: groupedShifts[date]!.map((shift) {
                return _shiftDetailsCard(shift);
              }).toList(),
            ),
          ],
        );
      }).toList(),
    );
  }

  /// **Selected Shift Details Card**
  Widget _shiftDetailsCard(Map<String, dynamic> shift) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5.h, horizontal: 10.w),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  _timeBox(shift['startTime'] ?? '--:--'),
                  SizedBox(width: 5.w),
                  Text("to"),
                  SizedBox(width: 5.w),
                  _timeBox(shift['endTime'] ?? '--:--'),
                ],
              ),
              _availabilityBox(shift['vacancy']?.toString() ?? '0', shift['standbyVacancy']?.toString() ?? '0'),
            ],
          ),
          Divider(),
          SizedBox(height: 10.h),

          /// **Shift Duration & Break**
          Row(
            children: [
              Icon(Icons.access_time, color: AppColors.themeColor, size: 18.sp),
              SizedBox(width: 5.w),
              Text("${shift['duration'] ?? '0'} hrs duration", style: CustomTextInter.medium12(AppColors.blackColor)),
              Spacer(),
              Icon(Icons.coffee, color: AppColors.themeColor, size: 18.sp),
              SizedBox(width: 5.w),
              Text(
                "${shift['breakDuration'] ?? '0'} hr break (${shift['breakPaid']})",
                style: CustomTextInter.medium12(AppColors.blackColor),
              ),
            ],
          ),

          SizedBox(height: 10.h),

          /// **Shift Wage**
          Row(
            children: [
              Icon(Icons.currency_exchange, color: AppColors.themeColor, size: 18.sp),
              SizedBox(width: 5.w),
              Text(
                "${shift['totalWage'] ?? '0'} (${shift['payRate'] ?? '0'}/hr)",
                style: CustomTextInter.medium12(AppColors.blackColor),
              ),
            ],
          ),

          Divider(),

          /// **Selected Button**
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: null, // Button is disabled in preview mode
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
                padding: EdgeInsets.symmetric(vertical: 12.h),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check_circle, color: AppColors.whiteColor, size: 18.sp),
                  SizedBox(width: 6.w),
                  Text("Selected", style: CustomTextInter.bold16(AppColors.whiteColor)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// **Time Box UI**
  Widget _timeBox(String time) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        color: AppColors.themeColor.withOpacity(0.9),
      ),
      child: Text(time, style: CustomTextInter.regular12(AppColors.whiteColor)),
    );
  }

  /// **Availability Box (Vacancy & Standby)**
  Widget _availabilityBox(String vacancy, String standby) {
    return Row(
      children: [
        _pillWithIcon(vacancy, AppColors.fieldHintColor, Icons.person, Colors.grey),
        SizedBox(width: 3.w),
        _pillWithIcon(standby, AppColors.orangeColor, Icons.person, AppColors.orangeColor),
      ],
    );
  }

  /// **Pill with Icon UI**
  Widget _pillWithIcon(String text, Color bgColor, IconData icon, Color iconColor) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: bgColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(15.r),
      ),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 12.sp),
          SizedBox(width: 2.w),
          Text(text, style: CustomTextInter.regular10(AppColors.blackColor)),
        ],
      ),
    );
  }
}
