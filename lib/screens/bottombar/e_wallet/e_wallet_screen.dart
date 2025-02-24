// ignore_for_file: prefer_const_constructors, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:work_lah/data/send_request.dart';
import 'package:work_lah/screens/bottombar/e_wallet/e_wallet_widget.dart';
import 'package:work_lah/utility/colors.dart';
import 'package:work_lah/utility/display_function.dart';
import 'package:work_lah/utility/top_app_bar.dart';// Import the reusable TopAppBar

class EWalletScreen extends StatefulWidget {
  const EWalletScreen({super.key});

  @override
  State<EWalletScreen> createState() => _EWalletScreenState();
}

class _EWalletScreenState extends State<EWalletScreen> {
  bool isLoading = false;
  String walletBalance = '0.00';

  @override
  void initState() {
    super.initState();
    fetchWalletBalance();
  }

  Future<void> fetchWalletBalance() async {
    setState(() {
      isLoading = true;
    });

    try {
      var response =
          await ApiProvider().getRequest(apiUrl: '/api/profile/stats');
      
      setState(() {
        walletBalance = response['wallet']['balance'].toString();
        isLoading = false;
      });
    } catch (error) {
      print("Error fetching wallet balance: $error");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        child: Column(
          children: [
            SizedBox(height: commonHeight(context) * 0.05),

            // ✅ Use the reusable TopAppBar
            TopAppBar(title: 'E - Wallet'),

            SizedBox(height: commonHeight(context) * 0.02),

            isLoading
                ? Center(
                    child: CircularProgressIndicator(
                      color: AppColors.themeColor,
                    ),
                  )
                : WalletCardWidget(balance: walletBalance), // Passing fetched balance

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
