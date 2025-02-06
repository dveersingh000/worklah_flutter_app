import 'package:flutter/material.dart';
import 'package:work_lah/screens/bottombar/bottom_bar_screen.dart';

class SelectShiftScreen extends StatefulWidget {
  final String job;
  const SelectShiftScreen({super.key, required this.job});

  @override
  _SelectShiftScreenState createState() => _SelectShiftScreenState();
}

class _SelectShiftScreenState extends State<SelectShiftScreen> {
  String? selectedShift;

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
                'assets/images/worklah_logo.png', // Ensure correct path
                height: 50,
              ),
            ),

            const SizedBox(height: 20),

            // Title
            const Center(
              child: Text(
                "Choose your shift",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),

            const SizedBox(height: 15),

            // Date, Employer, and Job Info
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _infoRow("Date:", "27 Sept, 24", Colors.blue),
                  _infoRow("Employer:", "RIGHT SERVICE PTE. LTD.", Colors.blue),
                  _infoRow("Job selected:", widget.job, Colors.blue),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Shift Selection
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  shiftSelectionButton("11:00 AM", "03:00 PM", isDisabled: true),
                  shiftSelectionButton("04:00 PM", "08:00 PM"),
                  shiftSelectionButton("07:00 PM", "11:00 PM"),
                ],
              ),
            ),

            const Spacer(),

            // Clock In & Clock Out Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: selectedShift == null
                        ? null
                        : () {
                            _navigateToHomeScreen();
                          },
                    child: const Text(
                      "Clock In",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: selectedShift == null
                        ? null
                        : () {
                            _navigateToHomeScreen();
                          },
                    child: const Text(
                      "Clock Out",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Shift Selection Button UI
  Widget shiftSelectionButton(String startTime, String endTime, {bool isDisabled = false}) {
    bool isSelected = selectedShift == "$startTime - $endTime";

    return GestureDetector(
      onTap: isDisabled
          ? null
          : () {
              setState(() {
                selectedShift = "$startTime - $endTime";
              });
            },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 15),
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: isDisabled ? Colors.grey[300] : (isSelected ? Colors.blue : Colors.white),
          border: Border.all(color: isSelected ? Colors.blue : Colors.grey),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            "$startTime  —  $endTime",
            style: TextStyle(
              fontSize: 16,
              color: isDisabled ? Colors.black38 : (isSelected ? Colors.white : Colors.black),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  // Info Row Widget
  Widget _infoRow(String label, String value, Color labelColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: "$label ",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: labelColor),
            ),
            TextSpan(
              text: value,
              style: const TextStyle(fontSize: 14, color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }

  // Navigate to Home Screen (BottomBarScreen)
  void _navigateToHomeScreen() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => BottomBarScreen(index: 0)),
      (route) => false, // Removes all previous screens from the stack
    );
  }
}
