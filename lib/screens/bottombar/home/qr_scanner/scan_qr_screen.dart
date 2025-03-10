import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:work_lah/screens/bottombar/home/qr_scanner/MobileScannerScreen.dart';
import 'package:work_lah/screens/bottombar/home/qr_scanner/location_permission_screen.dart';
import 'package:work_lah/utility/display_function.dart';
import 'package:work_lah/utility/custom_appbar.dart';
import 'package:work_lah/utility/colors.dart';
import 'package:work_lah/data/send_request.dart';

class ScanQRScreen extends StatefulWidget {
  final String applicationId;
  final String jobTitle;
  final String location;
  final String company;
  final String startTime;
  final String endTime;
  final String jobIcon;
  final String companyLogo;

  const ScanQRScreen({
    required this.applicationId,
    required this.jobTitle,
    required this.location,
    required this.company,
    required this.startTime,
    required this.endTime,
    required this.jobIcon,
    required this.companyLogo,
    super.key,
  });

  @override
  _ScanQRScreenState createState() => _ScanQRScreenState();
}

class _ScanQRScreenState extends State<ScanQRScreen> {
  bool isClockedIn = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: commonHeight(context) * 0.01),
          Padding(
            padding: EdgeInsets.only(left: 10.w, right: 10.w),
            child: CustomAppbar(title: 'Scan QR'),
          ),
          const SizedBox(height: 50),

          // ✅ Job Info Card
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    blurRadius: 5,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: Image.network(
                          '${ApiProvider().baseUrl}${widget.jobIcon}',
                          height: 24.h,
                          width: 24.w,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(Icons.work, color: Colors.blueAccent, size: 24);
                          },
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Text(
                          widget.jobTitle,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      _locationChip(widget.location),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      // ✅ Company Logo
                      ClipOval(
                        child: Image.network(
                          '${ApiProvider().baseUrl}${widget.companyLogo}',
                          height: 24.h,
                          width: 24.w,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(Icons.business, color: Colors.grey, size: 24);
                          },
                        ),
                      ),
                      SizedBox(width: 8.w),

                      // ✅ Company Name
                      Text(
                        widget.company,
                        style: TextStyle(fontSize: 14.sp, color: Colors.grey),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Container(
                    padding: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                      color: Colors.blueAccent.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _timeChip(widget.startTime, Colors.blueAccent),
                        SizedBox(width: 8.w),
                        Text('to', style: TextStyle(color: Colors.black)),
                        SizedBox(width: 8.w),
                        _timeChip(widget.endTime, Colors.black),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // SizedBox(height: 20.h),
          const Spacer(),

          // ✅ QR Code Placeholder
          Image.asset(
            'assets/images/qr_icon.png',
            height: 150,
            width: 150,
            color: Colors.white,
          ),

          const Spacer(),

          // ✅ Clock In/Out Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: isClockedIn ? Colors.red : Colors.white,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () async {
                bool granted = await showDialog(
                  context: context,
                  builder: (context) => const LocationPermissionScreen(),
                );

                if (granted) {
                  setState(() {
                    isClockedIn = !isClockedIn;
                  });

                  if (isClockedIn) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MobileScannerScreen(),
                      ),
                    );
                  } else {
                    // ✅ Navigate back to Shift Selection after Clock Out
                    Navigator.pop(context);
                  }
                }
              },
              child: Text(
                isClockedIn ? "Clock Out" : "Clock In",
                style: TextStyle(
                  color: isClockedIn ? Colors.white : Colors.black,
                  fontSize: 16,
                ),
              ),
            ),
          ),

          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _timeChip(String time, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        time,
        style: TextStyle(
          color: Colors.white,
          fontSize: 14.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _locationChip(String location) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(Icons.location_on, color: Colors.blueAccent, size: 16),
          SizedBox(width: 4.w),
          Text(location, style: TextStyle(fontSize: 12.sp, color: Colors.blueAccent)),
        ],
      ),
    );
  }
}
