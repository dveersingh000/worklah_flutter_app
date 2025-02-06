// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print

import 'dart:io';

import 'package:datepicker_dropdown/datepicker_dropdown.dart';
import 'package:datepicker_dropdown/order_format.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:work_lah/utility/colors.dart';
import 'package:work_lah/utility/display_function.dart';
import 'package:work_lah/utility/style_inter.dart';
import 'package:work_lah/utility/syle_poppins.dart';

class WalletAmountCard extends StatelessWidget {
  const WalletAmountCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 10.w, right: 10.w),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: AppColors.whiteColor,
        ),
        padding: EdgeInsets.only(
          left: 20.w,
          right: 20.w,
          top: 10.h,
          bottom: 10.h,
        ),
        child: Column(
          children: [
            Row(
              children: [
                Icon(
                  Icons.account_balance_wallet_outlined,
                  color: AppColors.fieldTitleColor,
                ),
                SizedBox(width: 5.w),
                Text(
                  'Your e-Wallet amount',
                  style: CustomTextInter.medium12(AppColors.fieldTitleColor),
                ),
              ],
            ),
            SizedBox(height: 5.h),
            Row(
              children: [
                Expanded(
                  child: Text(
                    '\$0',
                    style: CustomTextInter.medium24(AppColors.blackColor),
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
          ],
        ),
      ),
    );
  }
}

class DateDropDownWidget extends StatelessWidget {
  final Function(String?) selectedDate;
  final Function(String?) selectedMonth;
  final Function(String?) selectedYear;

  const DateDropDownWidget({
    super.key,
    required this.selectedDate,
    required this.selectedMonth,
    required this.selectedYear,
  });

  @override
  Widget build(BuildContext context) {
    OutlineInputBorder allBorder = OutlineInputBorder(
      borderSide: BorderSide(color: AppColors.fieldBorderColor),
      borderRadius: const BorderRadius.all(Radius.circular(10)),
    );
    return DropdownDatePicker(
      dateformatorder: OrderFormat.DMY,
      textStyle: CustomTextPopins.regular14(
        AppColors.blackColor,
      ),
      inputDecoration: InputDecoration(
        fillColor: AppColors.whiteColor,
        border: allBorder,
        enabledBorder: allBorder,
        focusedBorder: allBorder,
      ),
      isDropdownHideUnderline: true,
      isFormValidator: true,
      startYear: 1900,
      endYear: 2020,
      width: 10,
      dayFlex: 2,
      hintDay: 'DD',
      hintMonth: 'MM',
      hintYear: 'YYYY',
      onChangedDay: (value) {
        selectedDate(value);
        print('onChangedDay: $value');
      },
      onChangedMonth: (value) {
        selectedMonth(value);
        print('onChangedMonth: $value');
      },
      onChangedYear: (value) {
        selectedYear(value);
        print('onChangedYear: $value');
      },
    );
  }
}

class CaptureImageWidget extends StatelessWidget {
  final String title;
  final String title2;
  final VoidCallback onSelectImage;
  final File? selectedIMG;
  const CaptureImageWidget({
    super.key,
    required this.title,
    required this.title2,
    required this.onSelectImage,
    required this.selectedIMG,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onSelectImage();
      },
      child: DottedBorder(
        borderType: BorderType.RRect,
        radius: Radius.circular(10),
        dashPattern: [4, 4],
        borderPadding: EdgeInsets.all(1),
        color: AppColors.themeColor,
        strokeWidth: 1,
        child: Container(
          padding: EdgeInsets.all(5),
          width: double.infinity,
          child: selectedIMG != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.file(
                    selectedIMG!,
                    fit: BoxFit.cover,
                    height: 200.h,
                  ),
                )
              : Column(
                  children: [
                    Text(
                      title,
                      style: CustomTextPopins.medium10(
                        AppColors.blackColor,
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Padding(
                      padding: EdgeInsets.only(
                        left: commonWidth(context) * 0.33,
                        right: commonWidth(context) * 0.33,
                      ),
                      child: DottedBorder(
                        borderType: BorderType.RRect,
                        radius: Radius.circular(30),
                        dashPattern: [4, 4],
                        borderPadding: EdgeInsets.all(1),
                        color: AppColors.themeColor,
                        strokeWidth: 1,
                        padding: EdgeInsets.only(top: 40.h, bottom: 40.h),
                        child: Center(
                          child: Icon(Icons.collections,
                              color: AppColors.themeColor),
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Text(
                      title2,
                      style: CustomTextPopins.medium14(
                        AppColors.fieldHintColor,
                      ),
                    ),
                    Text(
                      'Supports only JPG, PNG, JPEG',
                      style: CustomTextPopins.regular10(
                        AppColors.fieldHintColor,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
