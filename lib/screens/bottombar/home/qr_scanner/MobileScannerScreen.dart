import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:work_lah/screens/bottombar/home/qr_scanner/select_job_screen.dart';
import 'package:work_lah/data/send_request.dart';

class MobileScannerScreen extends StatefulWidget {
  const MobileScannerScreen({super.key});

  @override
  State<MobileScannerScreen> createState() => _MobileScannerScreenState();
}

class _MobileScannerScreenState extends State<MobileScannerScreen> {
  MobileScannerController cameraController = MobileScannerController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 50), // Spacing from the top

          // QR Scanner View
          SizedBox(
            height: 200,
            width: 200,
            child: MobileScanner(
              controller: cameraController,
              onDetect: (capture) async {
                final List<Barcode> barcodes = capture.barcodes;
                for (final barcode in barcodes) {
                  String? scannedData = barcode.rawValue;
                  if (scannedData != null) {
                    var response = await ApiProvider().postRequest(
                      apiUrl: '/api/qr/scan',
                      data: {"qrData": scannedData},
                    );

                    if (response['success']) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SelectJobScreen(
                              jobData: response['jobDetails']),
                        ),
                    );
                  }
                }
                }
              },
            ),
          ),

          const Spacer(),

          // Restart Scanner Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ElevatedButton(
              onPressed: () {
                cameraController.start();
              },
              child: const Text("Scan Again"),
            ),
          ),

          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
