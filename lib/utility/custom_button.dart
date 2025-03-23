// ignore_for_file: sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:work_lah/utility/colors.dart';
import 'package:work_lah/utility/style_inter.dart';

class CustomButton extends StatelessWidget {
  final double? height;
  final double? width;
  final VoidCallback onTap;
  final String text;
  final TextStyle? textStyle;
  final Color? backgroundColor;
  final Color? borderColor;
  final bool isDisable;
  final bool isLoading;
  const CustomButton({
    super.key,
    this.height,
    this.width,
    required this.onTap,
    required this.text,
    this.textStyle,
    this.backgroundColor,
    this.borderColor,
    this.isDisable = false,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isDisable || isLoading
          ? null
          : () {
              onTap();
            },
      child: Container(
        height: height ?? 44.h,
        width: width ?? double.infinity,
        decoration: BoxDecoration(
          color: isDisable
              ? AppColors.themeColor.withOpacity(0.3)
              : backgroundColor ?? AppColors.themeColor,
          border: borderColor != null
              ? Border.all(color: borderColor!) // ✅ Apply border if provided
              : null,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: isLoading
              ? SizedBox(
                  height: 20.h,
                  width: 20.w,
                  child: CircularProgressIndicator(color: AppColors.whiteColor),
                )
              : Text(
                  text,
                  style: textStyle ??
                      CustomTextInter.regular14(AppColors.whiteColor),
                ),
        ),
      ),
    );
  }
}
