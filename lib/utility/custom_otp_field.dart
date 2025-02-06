import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pinput/pinput.dart';
import 'package:work_lah/utility/colors.dart';
import 'package:work_lah/utility/style_inter.dart';

class CustomOtpField extends StatelessWidget {
  final TextEditingController controller;
  final String? Function(String?)? onValidate;
  const CustomOtpField({
    required this.controller,
    required this.onValidate,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 47.w,
      height: 50.h,
      textStyle: CustomTextInter.medium20(AppColors.blackColor),
      decoration: BoxDecoration(
        color: AppColors.fillColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.fillColor),
      ),
    );
    final focusPinTheme = PinTheme(
      width: 47.w,
      height: 50.h,
      textStyle: CustomTextInter.medium20(AppColors.blackColor),
      decoration: BoxDecoration(
        color: AppColors.fillColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.themeColor),
      ),
    );
    return Pinput(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      length: 6,
      controller: controller,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
      defaultPinTheme: defaultPinTheme,
      focusedPinTheme: focusPinTheme,
      validator: onValidate,
      cursor: Center(
        child: Container(
          width: 1.5.w,
          height: 25.h,
          color: AppColors.themeColor,
        ),
      ),
      errorPinTheme: defaultPinTheme.copyBorderWith(
        border: Border.all(color: AppColors.redColor),
      ),
    );
  }
}
