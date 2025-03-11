import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:work_lah/data/send_request.dart';
import 'package:work_lah/screens/bottombar/profile/cashout/SelectBankScreen.dart';
import 'package:work_lah/utility/colors.dart';
import 'package:work_lah/utility/custom_appbar.dart';
import 'package:work_lah/utility/dashed_divider.dart';
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
  TextEditingController noteController = TextEditingController();
  bool isNoteFieldVisible = false; // Track if note input is visible


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
                    // _buildBankSelectionBox(),
                  ],
                ),
              ),
            ),
            // Available Balance Moved to Bottom Section
          isLoading
              ? CircularProgressIndicator(color: AppColors.themeColor)
              : Padding(
                  padding: EdgeInsets.only(bottom: 10.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.account_balance_wallet_outlined,
                          color: AppColors.blackColor, size: 22.sp),
                      SizedBox(width: 5.w),
                      Text("Available balance: ",
                          style:
                              CustomTextPopins.regular14(AppColors.blackColor)),
                      Text("\$${availableBalance.toStringAsFixed(2)}",
                          style: CustomTextPopins.bold14(AppColors.blackColor)),
                    ],
                  ),
                ),
           // Bottom Section with Bank Selection & Continue Button
          Column(
            children: [
              _buildBankSelectionBox(),
              SizedBox(height: 12.h), // Reduced spacing for proper alignment
              _buildContinueButton(),
            ],
          ),
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
      // Amount Input Field with "$" Symbol
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center, // Ensure proper alignment
        children: [
          Text(
            "\$",
            style: CustomTextPopins.bold33(AppColors.blackColor), // Bold "$" symbol
          ),
          SizedBox(width: 3.w), // Adjusted space between "$" and input
          SizedBox(
            width: 120.w, // Adjusted width for input
            child: TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              style: CustomTextPopins.bold33(AppColors.blackColor), // Large bold number
              onChanged: (value) {},
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "0", // Default input hint
                hintStyle: CustomTextPopins.bold33(Colors.grey.shade400), // Lighter hint color
              ),
            ),
          ),
        ],
      ),

      SizedBox(height: 5.h),

      // Note with Bold Text
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: CustomTextPopins.regular14(Colors.grey.shade600),
            children: [
              TextSpan(
                text: "Note: ",
                style: CustomTextPopins.bold14(AppColors.blackColor), // "Note" in bold
              ),
              TextSpan(text: "A cashout fee of "),
              TextSpan(
                text: "\$0.60",
                style: CustomTextPopins.bold14(AppColors.blackColor), // Bold cashout fee
              ),
              TextSpan(text: " will be applied to each withdrawal."),
            ],
          ),
        ),
      ),

      SizedBox(height: 10.h),

      // Add Note Button with Hover Effect
      InkWell(
        onTap: () {
          setState(() {
            isNoteFieldVisible = !isNoteFieldVisible; // Toggle input visibility
          });
        },
        borderRadius: BorderRadius.circular(20), // Added hover effect
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(20),
          ),
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
          child: Text(
            "Add note",
            style: CustomTextPopins.regular14(AppColors.blackColor),
          ),
        ),
      ),

      // Note Input Field (Shown when "Add Note" is clicked)
      if (isNoteFieldVisible)
        Padding(
          padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
          child: TextField(
            controller: noteController,
            maxLines: 2,
            style: CustomTextPopins.regular14(AppColors.blackColor),
            decoration: InputDecoration(
              hintText: "Enter your note...",
              hintStyle: CustomTextPopins.regular14(Colors.grey.shade400),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.grey.shade400),
              ),
            ),
          ),
        ),
    ],
  );
}




  /// Bank Selection Box
 
Widget _buildBankSelectionBox() {
  return Container(
    padding: EdgeInsets.all(15.w),
    decoration: BoxDecoration(
      color: Colors.grey[100], 
      borderRadius: BorderRadius.circular(10),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Selected Bank Label
        Padding(
          padding: EdgeInsets.only(left: 10.w, right: 10.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Selected bank",
                style: CustomTextPopins.regular14(Colors.grey.shade700),
              ),
              Text(
                "Linked",
                style: CustomTextPopins.bold14(AppColors.greenColor),
              ),
            ],
          ),
        ),

        SizedBox(height: 8.h),

        // Bank Selection Row
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.w), // Adjusted alignment
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Radio(
                    value: "PayNow via Mobile",
                    groupValue: selectedMethod,
                    activeColor: AppColors.themeColor,
                    onChanged: (value) {
                      setState(() {
                        selectedMethod = value.toString();
                      });
                    },
                  ),
                  SizedBox(width: 5.w),
                  Text(
                    "PayNow via Mobile",
                    style: CustomTextPopins.regular14(AppColors.blackColor),
                  ),
                ],
              ),
              Image.asset(
                'assets/images/paynow_logo.png',
                height: 22.h,
              ),
            ],
          ),
        ),

        // Dashed Divider
        // Padding(
        //   padding: EdgeInsets.symmetric(vertical: 8.h),
        //   child: DottedLine(
        //     dashColor: Colors.grey.shade400,
        //     lineThickness: 1,
        //     dashGapLength: 3,
        //   ),
        // ),
        SizedBox(height: 8.h),
        DashedDivider(),
        SizedBox(height: 8.h),

        // Choose Another Method Dropdown (Centered Text + Right Icon)
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SelectBankScreen()),
            );
          },
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 8.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center, // Center text
              children: [
                Text(
                  "Choose another method",
                  style: CustomTextPopins.regular14(AppColors.blackColor),
                ),
                SizedBox(width: 5.w), // Space between text and icon
                Icon(
                  Icons.keyboard_arrow_down,
                  color: AppColors.blackColor,
                  size: 18.sp,
                ),
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
