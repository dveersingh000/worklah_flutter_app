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
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w),
        child: Column(
          children: [
            SizedBox(height: commonHeight(context) * 0.05),
            const CustomAppbar(title: 'Cash Out'),
            SizedBox(height: commonHeight(context) * 0.02),

            // Confirmation Icon
            const Center(
              child: Icon(
                Icons.check_circle,
                color: Colors.blue,
                size: 100,
              ),
            ),

            const SizedBox(height: 20),

            // Amount
            Text(
              "\$${amount.toStringAsFixed(2)}",
              style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.blue),
            ),

            const SizedBox(height: 10),

            // Confirmation Text
            const Text(
              "Cash Out Confirmed",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
            ),

            const SizedBox(height: 5),

            // Date & Time
            const Text(
              "02:00 PM, 02 Nov, 2024",
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),

            const SizedBox(height: 50),

            // Bank Information
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Transferred to:", style: TextStyle(fontSize: 14, color: Colors.black54)),
                      const SizedBox(height: 5),
                      const Text(
                        "Linked bank:",
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "**** ${accountNumber.substring(accountNumber.length - 4)}",
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Image.asset(
                    'assets/images/bank_logo.png', // Update with correct bank image path
                    height: 30,
                  ),
                ],
              ),
            ),

            const Spacer(),

            // Back to Home Button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const BottomBarScreen(index: 2)),
                  (route) => false,
                );
              },
              child: const Text("Back to Home", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}