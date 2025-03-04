// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:work_lah/utility/colors.dart';
import 'package:work_lah/utility/image_path.dart';
import 'package:work_lah/utility/style_inter.dart';
import 'package:intl/intl.dart';
import 'package:work_lah/utility/syle_poppins.dart';
import 'package:work_lah/screens/bottombar/bottom_bar_screen.dart';
import 'package:work_lah/screens/bottombar/profile/cashout/CashOutHomeScreen.dart';

class WalletCardWidget extends StatelessWidget {
  final String balance;
  const WalletCardWidget({super.key, required this.balance});

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
                'Your E-Wallet amount',
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
                  '\$$balance',
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
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BottomBarScreen(
                              index:
                                  0, // ✅ Set the correct tab index (e.g., Home or Wallet)
                              child:
                                  CashOutHomeScreen(), // ✅ Keep CashOutHomeScreen as child
                            ),
                          ),
                        );
                      },
                      child: Row(
                        children: [
                          Text(
                            'Cash Out',
                            style:
                                CustomTextInter.medium12(AppColors.whiteColor),
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
                  )),
            ],
          ),
        ),
      ],
    );
  }
}

class CommonRowWithDateFilter extends StatefulWidget {
  const CommonRowWithDateFilter({super.key});

  @override
  _CommonRowWithDateFilterState createState() =>
      _CommonRowWithDateFilterState();
}

class _CommonRowWithDateFilterState extends State<CommonRowWithDateFilter> {
  DateTime? _startDate;
  DateTime? _endDate;

  Future<void> _selectDateRange(BuildContext context) async {
    final DateTime now = DateTime.now();
    final DateTime oneYearAgo = now.subtract(Duration(days: 365));

    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: oneYearAgo,
      lastDate: now,
      initialDateRange: _startDate != null && _endDate != null
          ? DateTimeRange(start: _startDate!, end: _endDate!)
          : DateTimeRange(start: now.subtract(Duration(days: 30)), end: now),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.blueAccent, // Highlight color
              onPrimary: Colors.white, // Text on selected items
              onSurface: Colors.black, // Text color on normal dates
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.blueAccent, // Button color
                textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
            dialogBackgroundColor: Colors.white, // Background color
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String startDateText = _startDate != null
        ? DateFormat("dd MMM, yyyy").format(_startDate!)
        : "-- : --";
    String endDateText = _endDate != null
        ? DateFormat("dd MMM, yyyy").format(_endDate!)
        : "-- : --";
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          Expanded(
            child: Wrap(
              alignment: WrapAlignment.start,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 10,
              children: [
                Icon(Icons.swap_horiz, color: Colors.black),
                Text(
                  'Transactions',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => _selectDateRange(context), // Opens date picker
            child: Container(
              height: 35,
              padding: EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.grey[200], // Background color
                borderRadius: BorderRadius.circular(30),
              ),
              child: Wrap(
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 6,
                children: [
                  _buildDateBox(startDateText),
                  Text(" to ",
                      style: TextStyle(color: Colors.black, fontSize: 12)),
                  _buildDateBox(endDateText),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to build a single date box
  Widget _buildDateBox(String dateText) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black, // Black background for contrast
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.calendar_today, size: 12, color: Colors.white),
          SizedBox(width: 5),
          Text(
            dateText,
            style: TextStyle(
                color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500),
          ),
        ],
      ),
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
                        // Text(
                        //   'Right Service Pvt. Ltd.',
                        //   style: CustomTextPopins.semiBold12(
                        //     AppColors.themeColor,
                        //     isUnderline: true,
                        //   ),
                        // ),
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
