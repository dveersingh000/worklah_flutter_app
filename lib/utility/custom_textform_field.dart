// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:work_lah/utility/colors.dart';
import 'package:work_lah/utility/syle_poppins.dart';

OutlineInputBorder allBorder = OutlineInputBorder(
  borderSide: BorderSide(color: AppColors.fieldBorderColor),
  borderRadius: const BorderRadius.all(Radius.circular(10)),
);

class CustomTextFormField extends StatelessWidget {
  final String hintText;
  final String? Function(String?)? onValidate;
  final Function(String)? onChange;
  final TextEditingController controller;
  final TextInputType? textInputType;
  final bool? obscureText;
  final bool isPrefixDisplay;
  final String? prefixIcon;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLength;
  final bool isDateField;
  final bool isDropdown;
  final bool readOnly;
  final List<String>? dropdownItems;
  const CustomTextFormField({
    required this.hintText,
    this.onValidate,
    this.onChange,
    required this.controller,
    this.textInputType,
    this.obscureText,
    this.prefixIcon,
    this.inputFormatters,
    this.maxLength,
    this.isPrefixDisplay = true,
    this.isDateField = false,
    this.isDropdown = false,
    this.readOnly = false,
    this.dropdownItems,
    super.key,
  });

  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      controller.text =
          "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
      if (onChange != null) {
        onChange!(controller.text);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isDropdown && dropdownItems != null && dropdownItems!.isNotEmpty) {
      return DropdownButtonFormField<String>(
        validator: onValidate,
        dropdownColor: AppColors.whiteColor,
        value: controller.text.isEmpty ? null : controller.text,
        style: CustomTextPopins.regular14(AppColors.blackColor),
        hint: Text(
          hintText,
          style: CustomTextPopins.regular14(AppColors.fieldHintColor),
        ),
        items: dropdownItems!.map((String item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(item),
          );
        }).toList(),
        onChanged: (String? newValue) {
          controller.text = newValue ?? '';
          if (onChange != null) {
            onChange!(newValue!);
          }
        },
        decoration: InputDecoration(
          border: allBorder,
          enabledBorder: allBorder,
          focusedBorder: allBorder,
          disabledBorder: allBorder,
        ),
      );
    }
    return TextFormField(
      cursorColor: AppColors.blackColor,
      inputFormatters: inputFormatters,
      controller: controller,
      validator: onValidate,
      maxLength: maxLength ?? 30,
      keyboardType: isDateField
          ? TextInputType.none
          : textInputType ?? TextInputType.text,
      obscureText: obscureText ?? false,
      onTap: isDateField
          ? () {
              _selectDate(context);
            }
          : null,
      onChanged: onChange,
      readOnly: readOnly,
      style: CustomTextPopins.regular14(AppColors.blackColor),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: CustomTextPopins.regular14(AppColors.fieldHintColor),
        counterText: '',
        prefixIconConstraints: BoxConstraints.loose(Size(45, 45)),
        border: allBorder,
        enabledBorder: allBorder,
        focusedBorder: allBorder,
        disabledBorder: allBorder,
      ),
    );
  }
}
