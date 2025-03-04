import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:work_lah/data/send_request.dart';
import 'package:work_lah/screens/bottombar/profile/cashout/SelectBankScreen.dart';
import 'package:work_lah/utility/colors.dart';
import 'package:work_lah/utility/custom_appbar.dart';
import 'package:work_lah/utility/display_function.dart';
import 'package:work_lah/utility/syle_poppins.dart';
import 'package:work_lah/screens/bottombar/bottom_bar_screen.dart';

class CashOutHomeScreen extends StatefulWidget {
  const CashOutHomeScreen({super.key});

  @override
  _CashOutHomeScreenState createState() => _CashOutHomeScreenState();
}

class _CashOutHomeScreenState extends State<CashOutHomeScreen> {
  TextEditingController amountController = TextEditingController();
  double availableBalance = 0.0; // Default balance set to 0
  String selectedMethod = "PayNow via Mobile";
  bool isAmountEntered = false;
  bool isLoading = true; // For balance loading state

  @override
  void initState() {
    super.initState();
    fetchWalletBalance();
  }

  /// Fetch Available Balance from API
  Future<void> fetchWalletBalance() async {
    try {
      var response =
          await ApiProvider().getRequest(apiUrl: '/api/profile/stats');
      setState(() {
        availableBalance =
            double.tryParse(response['wallet']['balance'].toString()) ?? 0.0;
        isLoading = false;
      });
    } catch (e) {
      log('Error fetching wallet balance: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void updateAmount(String value) {
    setState(() {
      isAmountEntered = value.isNotEmpty &&
          double.tryParse(value) != null &&
          double.parse(value) > 0;
    });
  }

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
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Enter amount to cash out",
                        style:
                            CustomTextPopins.regular16(AppColors.blackColor)),
                    SizedBox(height: commonHeight(context) * 0.06),
                    _buildBalanceAndAmountInput(),
                    SizedBox(height: commonHeight(context) * 0.06),
                    _buildBankSelectionBox(),
                  ],
                ),
              ),
            ),
            _buildContinueButton(), // Continue button at the bottom
            SizedBox(height: 20.h), // Bottom padding
          ],
        ),
      ),
    );
  }

  /// Balance & Amount Input in the Center
  Widget _buildBalanceAndAmountInput() {
    return Column(
      children: [
        // Wallet Balance
        isLoading
            ? CircularProgressIndicator(color: AppColors.themeColor)
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.account_balance_wallet_outlined,
                      color: AppColors.blackColor, size: 22.sp),
                  SizedBox(width: 5.w),
                  Text("Available balance: ",
                      style: CustomTextPopins.regular14(AppColors.blackColor)),
                  Text("\$${availableBalance.toStringAsFixed(2)}",
                      style: CustomTextPopins.bold14(AppColors.blackColor)),
                ],
              ),

        SizedBox(height: 20.h),

        // Amount Input
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text("\$", style: CustomTextPopins.bold32(AppColors.blackColor)),
            SizedBox(width: 5.w),
            SizedBox(
              width: 150.w,
              child: TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                style: CustomTextPopins.bold32(AppColors.blackColor),
                onChanged: updateAmount,
                decoration: const InputDecoration(
                    border: InputBorder.none, hintText: "0"),
              ),
            ),
          ],
        ),

        SizedBox(height: 10.h),

        // Add Note Button
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey[300],
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
            minimumSize: Size(140.w, 30.h),
          ),
          child: Text("Add note",
              style: CustomTextPopins.regular14(AppColors.blackColor)),
        ),
      ],
    );
  }

  /// Bank Selection Box
  Widget _buildBankSelectionBox() {
    return Container(
      padding: EdgeInsets.all(15.w),
      decoration: BoxDecoration(
          color: Colors.grey[100], borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Selected bank",
              style: CustomTextPopins.regular14(AppColors.blackColor)),
          SizedBox(height: 5.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(children: [
                Radio(
                    value: "PayNow via Mobile",
                    groupValue: selectedMethod,
                    onChanged: (value) {
                      setState(() {
                        selectedMethod = value.toString();
                      });
                    }),
                Text("PayNow via Mobile",
                    style: CustomTextPopins.regular14(AppColors.blackColor)),
              ]),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Linked",
                      style: CustomTextPopins.bold14(AppColors.greenColor)),
                  SizedBox(width: 5.w),
                  Image.asset('assets/images/paynow_logo.png', height: 20.h),
                ],
              ),
            ],
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SelectBankScreen()));
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 10.h),
              decoration: const BoxDecoration(
                  border: Border(top: BorderSide(color: Colors.grey))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Choose another method",
                      style: CustomTextPopins.regular14(AppColors.blueColor)),
                  Icon(Icons.arrow_drop_down, color: AppColors.blueColor),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Continue Button at the Bottom
  Widget _buildContinueButton() {
    return FractionallySizedBox(
      widthFactor: 1,
      child: ElevatedButton(
        onPressed: isAmountEntered
            ? () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BottomBarScreen(
                      index:
                          0, // ✅ Set the correct tab index (e.g., Home or Wallet)
                      child:
                          SelectBankScreen(), // ✅ Keep SelectBankScreen as child
                    ),
                  ),
                );
              }
            : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: isAmountEntered ? AppColors.blueColor : Colors.grey,
          padding: EdgeInsets.symmetric(vertical: 15.h),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        child: Text("Continue",
            style: CustomTextPopins.bold16(AppColors.whiteColor)),
      ),
    );
  }
}
