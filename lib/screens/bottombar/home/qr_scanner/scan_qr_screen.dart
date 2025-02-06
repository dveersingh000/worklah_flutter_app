import 'package:flutter/material.dart';
import 'package:work_lah/screens/bottombar/home/qr_scanner/location_permission_screen.dart';
import 'package:work_lah/screens/bottombar/home/qr_scanner/select_job_screen.dart';

class ScanQRScreen extends StatelessWidget {
  const ScanQRScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 50), // Spacing from the top

          // Work Lah Logo at the top
          Center(
            child: Image.asset(
              'assets/images/worklah_logo.png', // Ensure correct path for logo
              height: 60,
            ),
          ),

          const Spacer(),

          // QR Code Icon
          Image.asset(
            'assets/images/qr_icon.png', // Ensure correct path for QR image
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
                  // Navigate to job selection only if permission is granted
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SelectJobScreen()),
                  );
                }
              },
              child: const Text(
                "Scan In/Out",
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
            ),
          ),

          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
