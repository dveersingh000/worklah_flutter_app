import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:work_lah/screens/bottombar/bottom_bar_screen.dart';
import 'package:work_lah/utility/colors.dart';
import 'package:work_lah/utility/custom_appbar.dart';
import 'package:work_lah/utility/display_function.dart';

class CashOutConfirmationScreen extends StatelessWidget {
  final double amount;
  final String bankName;
  final String accountNumber;

  const CashOutConfirmationScreen({
    super.key,
    required this.amount,
    required this.bankName,
    required this.accountNumber,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Back Button & AppBar
              // SizedBox(height: commonHeight(context) * 0.05),
            const CustomAppbar(title: 'Cash Out'),
            SizedBox(height: commonHeight(context) * 0.02),
              const SizedBox(height: 20),

              // Checkmark Badge
              Center(
                child: Column(
                  children: [
                    Image.asset(
                      'assets/images/check_badge.png', // Replace with the correct checkmark badge image
                      height: 80.h,
                    ),
                    SizedBox(height: 20.h),

                    // Amount Text
                    Text(
                      "\$${amount.toStringAsFixed(1)}",
                      style: TextStyle(
                        fontSize: 32.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(height: 5),

                    // Confirmation Text
                    const Text(
                      "Cash Out Confirmed",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),

                    const SizedBox(height: 5),

                    // Date & Time
                    Text(
                      "02:00 PM, 02 Nov, 2024", // Dynamically replace with actual date/time if needed
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),

                    const SizedBox(height: 15),

                    // Fee Information
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade100.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        "A cashout fee of \$0.60 has been applied to your withdrawal.",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),
              const Spacer(),

              // Transferred To Bank Details
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Transferred to:",
                  style: TextStyle(fontSize: 14, color: Colors.black54),
                ),
              ),
              const SizedBox(height: 10),

              // Bank Information Card
              Container(
                padding: EdgeInsets.all(15.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey.shade300),
                  color: Colors.white,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Linked bank:",
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            "**** ${accountNumber.substring(accountNumber.length - 4)}",
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    Image.asset(
                      'assets/images/bank_logo.png', // Replace dynamically with the correct bank logo
                      height: 30,
                    ),
                  ],
                ),
              ),

              
const SizedBox(height: 10),
              // Bottom Navigation
              Column(
                children: [
                  // Back to Home Button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      minimumSize: Size(double.infinity, 50.h),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => const BottomBarScreen(index: 2)),
                        (route) => false,
                      );
                    },
                    child: const Text(
                      "Back to Home",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  // const SizedBox(height: 20),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
