import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:work_lah/utility/colors.dart';
import 'package:work_lah/utility/style_inter.dart';
import 'package:work_lah/utility/top_app_bar.dart';
import 'package:work_lah/utility/display_function.dart';
import 'package:work_lah/screens/bottombar/home/qr_scanner/scan_qr_screen.dart';

class ShiftSelectionScreen extends StatelessWidget {
  const ShiftSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        child: Column(
          children: [
            SizedBox(height: commonHeight(context) * 0.05),

            // ✅ Top AppBar
            TopAppBar(title: 'Select Shift'),

            SizedBox(height: commonHeight(context) * 0.02),

            // ✅ Main Content Scrollable
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        'Choose Your Job Shift To Clock In',
                        style: CustomTextInter.bold18(AppColors.blackColor),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Center(
                      child: Text(
                        'Remember: Checking in/out too early or late may delay payment. Stick to your assigned times for timely processing.',
                        style: CustomTextInter.regular14(AppColors.subTitColor),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: 16.h),

                    // ✅ Job Shift Date
                    Text(
                      '08 Nov, 25',
                      style: CustomTextInter.semiBold16(AppColors.blackColor),
                    ),
                    SizedBox(height: 8.h),

                    // ✅ Shift Cards
                    ShiftCard(
                      jobTitle: 'Tray Collector',
                      location: 'Jurong street',
                      company: 'RIGHT SERVICE PTE. LTD.',
                      restaurant: 'Food Dynasty',
                      duration: '3 hrs duration',
                      rate: '\$100 (\$20/hr)',
                      breakTime: '1 hr break (Unpaid)',
                      startTime: '11:00 AM',
                      endTime: '02:00 PM',
                      isActive: true,
                    ),
                    SizedBox(height: 16.h),

                    ShiftCard(
                      jobTitle: 'Cashier',
                      location: 'Jurong street',
                      company: 'RIGHT SERVICE PTE. LTD.',
                      restaurant: '2-Celios',
                      duration: '3 hrs duration',
                      rate: '\$100 (\$20/hr)',
                      breakTime: '1 hr break (Unpaid)',
                      startTime: '06:00 PM',
                      endTime: '09:00 PM',
                      isActive: false,
                    ),
                    SizedBox(height: 16.h),

                    // ✅ Another Job Shift Date
                    Text(
                      '28 Dec, 25',
                      style: CustomTextInter.semiBold16(AppColors.blackColor),
                    ),
                    SizedBox(height: 8.h),

                    ShiftCard(
                      jobTitle: 'Kitchen Helper',
                      location: 'Orchard Road',
                      company: 'Star Services PTE. LTD.',
                      restaurant: 'Pizza Palace',
                      duration: '4 hrs duration',
                      rate: '\$120 (\$30/hr)',
                      breakTime: '30 min break (Paid)',
                      startTime: '10:00 AM',
                      endTime: '02:00 PM',
                      isActive: true,
                    ),

                    SizedBox(height: 100.h), // Space for bottom navigation
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ShiftCard extends StatefulWidget {
  final String jobTitle;
  final String location;
  final String company;
  final String restaurant;
  final String duration;
  final String rate;
  final String breakTime;
  final String startTime;
  final String endTime;
  final bool isActive;

  const ShiftCard({
    required this.jobTitle,
    required this.location,
    required this.company,
    required this.restaurant,
    required this.duration,
    required this.rate,
    required this.breakTime,
    required this.startTime,
    required this.endTime,
    required this.isActive,
  });

  @override
  _ShiftCardState createState() => _ShiftCardState();
}

class _ShiftCardState extends State<ShiftCard> {
  bool isHovered = false;
  bool isClockedIn = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // ✅ Navigate to ScanQRScreen() when the job card is tapped
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ScanQRScreen()),
        );
      },
      child: MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isHovered ? AppColors.themeColor : Colors.grey.shade300, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(12.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ✅ Job Title & Location
              Row(
                children: [
                  Icon(Icons.work, color: AppColors.themeColor, size: 20),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      widget.jobTitle,
                      style: CustomTextInter.bold16(AppColors.blackColor),
                    ),
                  ),
                  Icon(Icons.location_on, color: Colors.grey, size: 16),
                  SizedBox(width: 4.w),
                  Text(
                    widget.location,
                    style: CustomTextInter.regular14(Colors.grey),
                  ),
                ],
              ),
              SizedBox(height: 8.h),

              Text(
                widget.company,
                style: CustomTextInter.regular14(Colors.grey),
              ),
              Divider(),

              // ✅ Details Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _iconText(Icons.restaurant, widget.restaurant),
                  _iconText(Icons.access_time, widget.duration),
                ],
              ),
              SizedBox(height: 8.h),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _iconText(Icons.attach_money, widget.rate),
                  _iconText(Icons.free_breakfast, widget.breakTime),
                ],
              ),
              SizedBox(height: 12.h),

              // ✅ Shift Timing & Clock In Button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _timeChip(widget.startTime, AppColors.themeColor,),
                  Text('to', style: CustomTextInter.regular14(Colors.grey)),
                  _timeChip(widget.endTime, Colors.black, ),
                  _clockInOutButton(),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
    );
  }

  Widget _iconText(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: AppColors.themeColor, size: 18),
        SizedBox(width: 6.w),
        Text(text, style: CustomTextInter.regular14(Colors.black)),
      ],
    );
  }

 Widget _timeChip(String time, Color bgColor) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h), // Reduced padding
    decoration: BoxDecoration(
      color: bgColor,
      borderRadius: BorderRadius.circular(8),
    ),
    child: Text(
      time,
      style: CustomTextInter.bold12(Colors.white), // Reduced font size
    ),
  );
}

  // ✅ Clock In/Out Button with Toggle Functionality
  Widget _clockInOutButton() {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          isClockedIn = !isClockedIn; // Toggle Clock In/Out state
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: isClockedIn ? Colors.red : Colors.green, // Toggle Color
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            isClockedIn ? 'Clock Out' : 'Clock In', // Toggle Text
            style: CustomTextInter.bold12(Colors.white),
          ),
          SizedBox(width: 4.w),
          Icon(
            Icons.qr_code_scanner,
            color: Colors.white,
            size: 16,
          ),
          Icon(
            Icons.chevron_right,
            color: Colors.white,
            size: 16,
          ),
        ],
      ),
    );
  }
}

