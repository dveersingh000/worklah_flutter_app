// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:work_lah/screens/bottombar/e_wallet/e_wallet_widget.dart';
import 'package:work_lah/utility/colors.dart';
import 'package:work_lah/utility/custom_appbar.dart';
import 'package:work_lah/utility/display_function.dart';

class EWalletScreen extends StatefulWidget {
  const EWalletScreen({super.key});

  @override
  State<EWalletScreen> createState() => _EWalletScreenState();
}

class _EWalletScreenState extends State<EWalletScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: Padding(
        padding: EdgeInsets.only(left: 10.w, right: 10.w),
        child: Column(
          children: [
            SizedBox(height: commonHeight(context) * 0.05),
            CustomAppbar(
              title: 'E - Wallet',
              isAction: true,
              isLeading: false,
            ),
            SizedBox(height: commonHeight(context) * 0.02),
            WalletCardWidget(),
            SizedBox(height: commonHeight(context) * 0.02),
            CommonRowWithDateFilter(),
            SizedBox(height: commonHeight(context) * 0.03),
            CommonTransactionWidget(type: 'Cashout'),
            SizedBox(height: 10.h),
            CommonTransactionWidget(type: 'Received'),
          ],
        ),
      ),
    );
  }
}
