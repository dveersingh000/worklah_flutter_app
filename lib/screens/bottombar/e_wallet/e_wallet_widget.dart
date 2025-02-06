// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:work_lah/utility/colors.dart';
import 'package:work_lah/utility/image_path.dart';
import 'package:work_lah/utility/style_inter.dart';
import 'package:work_lah/utility/syle_poppins.dart';

class WalletCardWidget extends StatelessWidget {
  const WalletCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 115.h,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: AppColors.whiteColor,
          ),
          child: Image.asset(
            ImagePath.walletIMG,
            fit: BoxFit.fill,
          ),
        ),
        Positioned(
          top: 10,
          left: 20,
          child: Row(
            children: [
              Icon(
                Icons.account_balance_wallet_outlined,
                color: AppColors.fieldBorderColor,
              ),
              SizedBox(width: 5.w),
              Text(
                'Your e-Wallet amount',
                style: CustomTextInter.medium12(AppColors.fieldBorderColor),
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 10,
          left: 20,
          right: 20,
          child: Row(
            children: [
              Expanded(
                child: Text(
                  '\$4,553',
                  style: CustomTextInter.medium24(AppColors.whiteColor),
                ),
              ),
              Container(
                height: 35.h,
                padding: EdgeInsets.only(left: 10.w, right: 10.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: AppColors.themeColor,
                ),
                child: Center(
                  child: Row(
                    children: [
                      Text(
                        'Cash Out',
                        style: CustomTextInter.medium12(AppColors.whiteColor),
                      ),
                      SizedBox(width: 5.w),
                      Icon(
                        Icons.arrow_outward,
                        color: AppColors.whiteColor,
                        size: 20.sp,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class CommonRowWithDateFilter extends StatelessWidget {
  const CommonRowWithDateFilter({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Row(
            children: [
              Icon(Icons.swap_horiz),
              SizedBox(width: 5.w),
              Text(
                'Transactions',
                style: CustomTextPopins.medium14(AppColors.blackColor),
              ),
            ],
          ),
        ),
        Container(
          height: 33.h,
          padding: EdgeInsets.only(left: 10.w, right: 10.w),
          decoration: BoxDecoration(
            color: AppColors.dateFilterBoxColor,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Row(
            children: [
              Text(
                '10 Apr 2024 - 20 Sep 2024',
                style: CustomTextPopins.regular10(AppColors.blackColor),
              ),
              SizedBox(width: 5.w),
              Container(
                height: 18.h,
                width: 18.w,
                decoration: BoxDecoration(
                  color: AppColors.blackColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.calendar_month_outlined,
                  color: AppColors.whiteColor,
                  size: 10.sp,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class CommonTransactionWidget extends StatelessWidget {
  final String type;
  const CommonTransactionWidget({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            blurRadius: 4,
            offset: Offset(0, 0),
            color: AppColors.blackColor.withOpacity(0.2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            type,
            style: CustomTextPopins.medium16(
              type == 'Received' ? AppColors.greenColor : AppColors.themeColor,
            ),
          ),
          Text(
            'Transaction ID: SAFAKHSDFU0EONC',
            style: CustomTextPopins.regular12(AppColors.fieldTitleColor),
          ),
          SizedBox(height: 10.h),
          Row(
            children: [
              Expanded(
                child: Text(
                  type == 'Received' ? '+\$49.50' : '-\$49.50',
                  style: CustomTextPopins.medium20(AppColors.blackColor),
                ),
              ),
              type == 'Received'
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Received from:',
                          style:
                              CustomTextPopins.regular12(AppColors.blackColor),
                        ),
                        Text(
                          'Right Service Pvt. Ltd.',
                          style: CustomTextPopins.semiBold12(
                            AppColors.themeColor,
                            isUnderline: true,
                          ),
                        ),
                        Text(
                          '07 Jun, 2024 | 03:10 PM',
                          style:
                              CustomTextPopins.regular12(AppColors.blackColor),
                        ),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Cashout Fee: -\$0.60',
                          style:
                              CustomTextPopins.regular12(AppColors.blackColor),
                        ),
                        Text(
                          '07 Jun, 2024 | 03:10 PM',
                          style:
                              CustomTextPopins.regular12(AppColors.blackColor),
                        ),
                      ],
                    ),
            ],
          ),
        ],
      ),
    );
  }
}
