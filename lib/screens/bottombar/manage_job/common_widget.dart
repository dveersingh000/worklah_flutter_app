// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:work_lah/data/send_request.dart';
import 'package:work_lah/screens/bottombar/manage_job/cancelled_job/cancelled_job_details.dart';
import 'package:work_lah/screens/bottombar/manage_job/ongoing_job/on_going_job_details.dart';
import 'package:work_lah/utility/colors.dart';
import 'package:work_lah/utility/display_function.dart';
import 'package:work_lah/utility/image_path.dart';
import 'package:work_lah/utility/style_inter.dart';
import 'package:work_lah/utility/syle_poppins.dart';

class CommonJobWidget extends StatelessWidget {
  final bool icCompleted, isCancelled;
  final Map jobData;
  const CommonJobWidget({
    super.key,
    this.icCompleted = false,
    this.isCancelled = false,
    required this.jobData,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (icCompleted) {
        } else if (isCancelled) {
          moveToNext(
            context,
            CancelledJobDetails(jobID: jobData['applicationId']),
          );
        } else {
          moveToNext(
            context,
            OnGoingJobDetails(jobID: jobData['applicationId']),
          );
        }
      },
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Image.asset(ImagePath.dishIMG),
                        SizedBox(width: 10.w),
                        Text(
                          jobData['jobName'],
                          style:
                              CustomTextInter.semiBold24(AppColors.blackColor),
                        ),
                      ],
                    ),
                    Text(
                      jobData['subtitle'],
                      style: CustomTextPopins.medium14(AppColors.subTitColor),
                    )
                  ],
                ),
                Spacer(),
                Icon(
                  Icons.more_vert,
                  color: AppColors.blackColor,
                  size: 35.sp,
                ),
              ],
            ),
          ),
          Stack(
            children: [
              Image.network(
                '${ApiProvider().baseUrl}${jobData['outletImage']}',
              ),
              icCompleted || isCancelled
                  ? Container(
                      height: commonHeight(context) * 0.25,
                      color: AppColors.textGreyColor.withOpacity(0.15),
                    )
                  : SizedBox(),
              Positioned(
                top: 20.h,
                right: 20.w,
                child: Icon(
                  Icons.share,
                  color: AppColors.whiteColor,
                ),
              ),
              icCompleted || isCancelled
                  ? Positioned(
                      top: 20.h,
                      right: commonWidth(context) * 0.2,
                      child: Container(
                        height: 35.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(60),
                          color: isCancelled
                              ? AppColors.lightRedColor
                              : AppColors.lightGreenColor,
                        ),
                        padding: EdgeInsets.only(left: 10.w, right: 10.w),
                        child: Center(
                          child: Text(
                            isCancelled ? 'Cancelled' : 'Completed',
                            style: CustomTextInter.medium14(isCancelled
                                ? AppColors.redColor
                                : AppColors.greenColor),
                          ),
                        ),
                      ),
                    )
                  : SizedBox(),
              Positioned(
                bottom: 10.h,
                right: 20.w,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Salary',
                      style: CustomTextPopins.medium14(AppColors.whiteColor),
                    ),
                    Text(
                      '\$${jobData['salary']}',
                      style: CustomTextPopins.medium20(AppColors.greenColor),
                    ),
                    Text(
                      jobData['ratePerHour'],
                      style: CustomTextPopins.regular12(
                          AppColors.fieldBorderColor),
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 10.h,
                left: 20.w,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          color: AppColors.whiteColor,
                          size: 18.sp,
                        ),
                        SizedBox(width: 5.w),
                        Text(
                          'Job Duration',
                          style:
                              CustomTextPopins.medium14(AppColors.whiteColor),
                        ),
                      ],
                    ),
                    SizedBox(height: 5.h),
                    Text(
                      jobData['duration'],
                      style: CustomTextPopins.regular12(
                          AppColors.fieldBorderColor),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
