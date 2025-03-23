import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:work_lah/utility/colors.dart';
import 'package:work_lah/utility/style_inter.dart';
import 'package:work_lah/utility/image_path.dart';
import 'package:work_lah/utility/custom_appbar.dart';
import 'package:work_lah/screens/bottombar/bottom_bar_screen.dart';
import 'package:work_lah/data/send_request.dart';
import 'package:work_lah/screens/bottombar/manage_job/ongoing_job/on_going_job_details.dart';

class BookingConfirmationScreen extends StatelessWidget {
  final Map<String, dynamic> jobDetails;
  final List<dynamic> selectedShifts;
  final String applicationId;

  const BookingConfirmationScreen({
    super.key,
    required this.jobDetails,
    required this.selectedShifts,
    required this.applicationId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE5F3FF),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20.h),

              // 🏷️ **App Bar**
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: CustomAppbar(title: 'Booking Confirmation'),
              ),
              SizedBox(height: 20.h),

              // 📌 **Shift Details Card**
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Container(
                  padding: EdgeInsets.all(15.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
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
                    children: [
                      // 📸 **Job Image** (Fixed)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8.r),
                        child: Image.network(
                          '${ApiProvider().baseUrl}${jobDetails['outlet']?['image'] ?? ''}',
                          width: 60.w,
                          height: 60.h,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Icon(
                              Icons.image,
                              size: 50.sp,
                              color: Colors.grey),
                        ),
                      ),
                      SizedBox(width: 15.w),

                      // 🏢 **Job & Date Details**
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              jobDetails['outlet']?['name'] ?? "Unknown Outlet",
                              style: CustomTextInter.medium14(
                                  AppColors.blackColor),
                            ),
                            Text(
                              jobDetails['jobName'] ?? "Unknown Job",
                              style:
                                  CustomTextInter.bold16(AppColors.blackColor),
                            ),
                            SizedBox(height: 5.h),

                            // 📆 **Shift Dates & Vacancy** (Fixed)
                            Row(
                              children: selectedShifts.map((shift) {
                                // Extract vacancy and standby data from the shift object
                                int totalVacancy = int.tryParse(
                                        shift['vacancy']?.split("/")?[1] ??
                                            '0') ??
                                    0;
                                int filledVacancy = int.tryParse(
                                        shift['vacancy']?.split("/")?[0] ??
                                            '0') ??
                                    0;
                                int totalStandby = int.tryParse(
                                        shift['standbyVacancy']
                                                ?.split("/")?[1] ??
                                            '0') ??
                                    0;

                                // If normal vacancy is available, show "1" in normal vacancy, else show "1" in standby
                                String displayVacancy =
                                    (filledVacancy < totalVacancy) ? "1" : "0";
                                String displayStandby =
                                    (filledVacancy >= totalVacancy &&
                                            totalStandby > 0)
                                        ? "1"
                                        : "0";

                                return Padding(
                                  padding: EdgeInsets.only(right: 8.w),
                                  child: _dateVacancyWidget(
                                    shift['date'] ?? '',
                                    displayVacancy,
                                    displayStandby,
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 30.h),

              // 🎉 **Success Illustration**
              Image.asset(
                ImagePath.success_illustration,
                height: 200.h,
              ),
              SizedBox(height: 20.h),

              // 🎊 **Congratulations Message**
              Text(
                "Congratulations!",
                style: CustomTextInter.bold24(AppColors.themeColor),
              ),
              SizedBox(height: 10.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Text(
                  "Your shift has been successfully booked. Get ready to show up and do your best!",
                  textAlign: TextAlign.center,
                  style: CustomTextInter.medium14(AppColors.blackColor),
                ),
              ),
              SizedBox(height: 10.h),
              Text(
                "See you soon! 🚀",
                style: CustomTextInter.bold16(AppColors.blackColor),
              ),
              SizedBox(height: 30.h),

              // 📌 **Action Buttons (View Shift Details & Home)**
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // 🔍 **View Shift Details**
                    // 🔍 **View Shift Details**
Expanded(
  child: OutlinedButton(
    onPressed: () {
      // ✅ Navigate to Shift Summary (OnGoingJobDetails)
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BottomBarScreen(
            index: 0, // ✅ Home Tab
            child: OnGoingJobDetails(
              jobID: applicationId, // ✅ Pass Job ID
            ),
          ),
        ),
      );
    },
    style: OutlinedButton.styleFrom(
      side: BorderSide(color: AppColors.themeColor),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.r),
      ),
      padding: EdgeInsets.symmetric(vertical: 12.h),
    ),
    child: Text(
      "View Shift Details",
      style: CustomTextInter.bold14(AppColors.themeColor),
    ),
  ),
),

                    SizedBox(width: 10.w),

                    // 🏠 **Home Button**
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // ✅ Navigate to Home Screen & Clear Backstack
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    BottomBarScreen(index: 0)),
                            (route) =>
                                false, // Removes all previous routes from the stack
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.themeColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                        ),
                        child: Text(
                          "Home",
                          style: CustomTextInter.bold14(AppColors.whiteColor),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }

  /// 🗓 **Shift Date & Vacancy UI**
  Widget _dateVacancyWidget(String date, String vacancy, String standby) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10.r),
      color: AppColors.lightGreyColor.withOpacity(0.2),
    ),
    child: Wrap( // ✅ Wrap allows text to go to the next line if necessary
      alignment: WrapAlignment.center,
      spacing: 6.w,
      children: [
        // 📅 Date
        Row(
          mainAxisSize: MainAxisSize.min, // ✅ Ensures it only takes required space
          children: [
            Icon(Icons.date_range, size: 14.sp, color: Colors.grey),
            SizedBox(width: 4.w),
            Flexible( // ✅ Prevents text overflow
              child: Text(
                date,
                style: CustomTextInter.medium12(AppColors.blackColor),
                overflow: TextOverflow.ellipsis, // ✅ Avoids overflow issue
                maxLines: 1,
              ),
            ),
          ],
        ),

        // ✅ Vacancy
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.person, size: 14.sp, color: AppColors.blackColor),
            SizedBox(width: 2.w),
            Flexible(
              child: Text(
                vacancy,
                style: CustomTextInter.medium12(AppColors.blackColor),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ],
        ),

        // 🟠 Standby Vacancy
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.person, size: 14.sp, color: AppColors.orangeColor),
            SizedBox(width: 2.w),
            Flexible(
              child: Text(
                standby,
                style: CustomTextInter.medium12(AppColors.orangeColor),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

}
