import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:work_lah/screens/bottombar/home/qr_scanner/MobileScannerScreen.dart';
import 'package:work_lah/screens/bottombar/home/qr_scanner/location_permission_screen.dart';
import 'package:work_lah/utility/display_function.dart';
import 'package:work_lah/utility/custom_appbar.dart';

class ScanQRScreen extends StatefulWidget {
  const ScanQRScreen({super.key});

  @override
  _ScanQRScreenState createState() => _ScanQRScreenState();
}

class _ScanQRScreenState extends State<ScanQRScreen> {
  bool isScanned = false;

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
          const SizedBox(height: 50), // Spacing from the top

          // Work Lah Logo
          // Center(
          //   child: Image.asset(
          //     'assets/images/worklah_logo.png',
          //     height: 60,
          //   ),
          // ),
          // Job Info Card
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
                      Icon(Icons.work, color: Colors.blueAccent, size: 20),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Text(
                          'Tray Collector',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Icon(Icons.location_on, color: Colors.grey, size: 16),
                      Text(
                        'Jurong street',
                        style: TextStyle(fontSize: 14.sp, color: Colors.grey),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'RIGHT SERVICE PTE. LTD.',
                    style: TextStyle(fontSize: 14.sp, color: Colors.grey),
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
                        _timeChip('11:00 AM', Colors.blueAccent),
                        SizedBox(width: 8.w),
                        Text('to', style: TextStyle(color: Colors.black)),
                        SizedBox(width: 8.w),
                        _timeChip('02:00 PM', Colors.black),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 40.h),

          const Spacer(),

          // QR Icon Image (This is shown initially)
          Image.asset(
            'assets/images/qr_icon.png',
            height: 150,
            width: 150,
            color: Colors.white,
          ),

          const Spacer(),

          // Scan In/Out Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const MobileScannerScreen()),
                  );
                }
              },
              child: const Text(
                "Clock In/Out",
                style: TextStyle(color: Colors.black, fontSize: 16),
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
}
