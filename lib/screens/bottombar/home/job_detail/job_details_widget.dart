// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:work_lah/data/send_request.dart';
import 'package:work_lah/utility/colors.dart';
import 'package:work_lah/utility/image_path.dart';
import 'package:work_lah/utility/style_inter.dart';
import 'package:work_lah/utility/syle_poppins.dart';

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
                jobTitle ?? 'Tray Collector',
                style: CustomTextInter.semiBold24(AppColors.blackColor),
              ),
            ],
          ),
          Text(
            jobSubTitle ?? 'Food Dynasty (United Square)',
            style: CustomTextPopins.medium14(AppColors.subTitColor),
          )
        ],
      ),
    );
  }
}

class JobIMGWidget extends StatelessWidget {
  final String? posterIMG;
  final String? smallIMG;
  const JobIMGWidget({super.key, this.posterIMG, this.smallIMG});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Image.asset(ImagePath.trayCollector),
        ),
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
        Positioned(
          top: 0.h,
          right: 20.w,
          child: Container(
            height: 45.h,
            width: 45.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.whiteColor,
            ),
            child: posterIMG!.isEmpty
                ? Image.asset(
                    ImagePath.jobLogoIMG,
                    fit: BoxFit.fill,
                  )
                : Image.network(
                    '${ApiProvider().baseUrl}$posterIMG',
                    fit: BoxFit.fill,
                  ),
          ),
        ),
      ],
    );
  }
}

class JobSalary extends StatelessWidget {
  final String? salary;
  const JobSalary({super.key, this.salary});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Spacer(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              'Salary',
              style: CustomTextPopins.medium14(AppColors.blackColor),
            ),
            Text(
              '$salary',
              style: CustomTextPopins.medium20(AppColors.greenColor),
            ),
            Text(
              '\$12/hr - 4hrs',
              style: CustomTextPopins.regular12(
                AppColors.fieldHintColor,
              ),
            ),
          ],
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
