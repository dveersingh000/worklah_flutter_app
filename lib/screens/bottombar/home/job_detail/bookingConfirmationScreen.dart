import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:work_lah/utility/colors.dart';
import 'package:work_lah/utility/style_inter.dart';
import 'package:work_lah/utility/image_path.dart';
import 'package:work_lah/utility/custom_appbar.dart';
import 'package:work_lah/screens/bottombar/bottom_bar_screen.dart';

class BookingConfirmationScreen extends StatelessWidget {
  final Map<String, dynamic> jobDetails;

  const BookingConfirmationScreen({super.key, required this.jobDetails});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE5F3FF), 
      body: Column(
        children: [
          SizedBox(height: 40.h),

          Padding(
            padding: EdgeInsets.only(left: 10.w, right: 10.w),
            child: CustomAppbar(title: ''),
          ),
          SizedBox(height: 20.h),
          // 📌 Shift Details Card
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
                  // 📸 Job Image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.r),
                    child: Image.network(
                      jobDetails['jobIcon'] ?? '', // Ensure valid image URL
                      width: 50.w,
                      height: 50.h,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          Icon(Icons.image, size: 50.sp, color: Colors.grey),
                    ),
                  ),
                  SizedBox(width: 15.w),

                  // 🏢 Job & Date Details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          jobDetails['company'] ?? "Unknown Company",
                          style: CustomTextInter.medium14(AppColors.blackColor),
                        ),
                        Text(
                          jobDetails['jobTitle'] ?? "Unknown Job",
                          style: CustomTextInter.bold16(AppColors.blackColor),
                        ),
                        SizedBox(height: 5.h),
                        Row(
                          children: [
                            Icon(Icons.date_range,
                                size: 16.sp, color: Colors.grey),
                            SizedBox(width: 5.w),
                            Text(
                              "${jobDetails['startDate']} - ${jobDetails['endDate']}",
                              style: CustomTextInter.medium12(
                                  AppColors.blackColor),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 30.h),
          Image.asset(
            ImagePath.success_illustration,
            height: 200.h,
          ),
          SizedBox(height: 20.h),
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

          // 📌 Action Buttons (View Shift Details & Home)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // 🔍 View Shift Details
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      // Navigate to Shift Details Screen (if exists)
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

                // 🏠 Home Button
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // ✅ Navigate to Home Screen & Clear Backstack
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => BottomBarScreen(index: 0)),
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
          SizedBox(height: 10.h),
        ],
      ),
    );
  }
}
