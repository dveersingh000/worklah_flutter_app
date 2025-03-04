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
        children: [
          SizedBox(height: 50), // Spacing from the top
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),
          SizedBox(height: 20),
          
          // QR Scanner View Centered
          Expanded(
            child: Center(
              child: AspectRatio(
                aspectRatio: 1,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
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
                                        jobData: response['jobDetails'])),
                              );
                            }
                          }
                        }
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),

          SizedBox(height: 30),

          // Restart Scanner Button Centered
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Align(
              alignment: Alignment.center,
              child: ElevatedButton(
                onPressed: () {
                  cameraController.start();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                ),
                child: Text(
                  "Scan Again",
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
