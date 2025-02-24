import 'package:flutter/material.dart';
import 'package:work_lah/screens/bottombar/home/qr_scanner/select_shift_screen.dart';

class SelectJobScreen extends StatefulWidget {
  const SelectJobScreen({super.key, required jobData});

  @override
  // ignore: library_private_types_in_public_api
  _SelectJobScreenState createState() => _SelectJobScreenState();
}

class _SelectJobScreenState extends State<SelectJobScreen> {
  String? selectedJob;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),

            // Work Lah Logo
            Center(
              child: Image.asset(
                'assets/images/worklah_logo.png', // Ensure the correct logo path
                height: 50,
              ),
            ),

            const SizedBox(height: 20),

            // Title: Choose Your Job
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      "Choose your Job",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),

                  // Date & Employer Info
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: "Date: ",
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.blue),
                        ),
                        TextSpan(
                          text: "27 Sept, 24",
                          style: TextStyle(fontSize: 14, color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 5),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: "Employer: ",
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.blue),
                        ),
                        TextSpan(
                          text: "RIGHT SERVICE PTE. LTD.",
                          style: TextStyle(fontSize: 14, color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Job Selection Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  jobSelectionButton("Tray Collector"),
                  jobSelectionButton("Cashier"),
                  jobSelectionButton("Cleaner"),
                ],
              ),
            ),

            const Spacer(),

            // Continue Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: selectedJob == null ? Colors.grey[300] : Colors.blue,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: selectedJob == null
                    ? null
                    : () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SelectShiftScreen(job: selectedJob!)),
                        );
                      },
                child: Text(
                  "Continue",
                  style: TextStyle(
                    fontSize: 16,
                    color: selectedJob == null ? Colors.black54 : Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Job Selection Button UI
  Widget jobSelectionButton(String jobName) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedJob = jobName;
        });
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 15),
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: selectedJob == jobName ? Colors.blue : Colors.grey[300],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            jobName,
            style: TextStyle(
              fontSize: 16,
              color: selectedJob == jobName ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
