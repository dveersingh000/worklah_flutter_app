import 'package:flutter/material.dart';
import 'package:work_lah/screens/bottombar/profile/cashout/CashOutSuccessScreen.dart';
import 'package:work_lah/screens/bottombar/bottom_bar_screen.dart';

class SelectBankScreen extends StatefulWidget {
  const SelectBankScreen({super.key});

  @override
  _SelectBankScreenState createState() => _SelectBankScreenState();
}

class _SelectBankScreenState extends State<SelectBankScreen> {
  String selectedMethod = "PayNow via Mobile";
  String selectedBank = "DBS";
  bool saveForFuture = false;
  double cashOutAmount = 100.00;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.5),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
            width: MediaQuery.of(context).size.width * 0.9,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Choose Transfer Method (Heading)
                const Text(
                  "Choose transfer method",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 15),

                // 1st Payment Method Box (PayNow via Mobile)
                _buildPaymentMethodCard(
                  "PayNow via Mobile",
                  "Linked",
                  "assets/images/paynow_logo.png",
                ),
                const SizedBox(height: 10),

                // 2nd Payment Method Box (PayNow via NRIC)
                _buildPaymentMethodCard(
                  "PayNow via NRIC",
                  "Link",
                  "assets/images/paynow_logo.png",
                  showExtraText: true,
                ),
                const SizedBox(height: 15),

                // 3rd Bank Details Box (Add Another Bank)
                _buildBankDetailsSection(),

                const SizedBox(height: 15),

                // Warning Text with "i" Icon
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.info_outline, color: Colors.orange, size: 20),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        "Worklah! is not liable for inaccurate info for payment details that being input and transferred.",
                        style: TextStyle(color: Colors.orange, fontSize: 12),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 15),

                // Proceed Button
                // Proceed Button
ElevatedButton(
  style: ElevatedButton.styleFrom(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    padding: EdgeInsets.zero, // Required for Ink gradient effect
  ),
  onPressed: selectedBank.isEmpty
      ? null // Disable button if no bank is selected
      : () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BottomBarScreen(
                index: 0,
                child: CashOutConfirmationScreen(
                  amount: cashOutAmount,
                  bankName: selectedBank,
                  accountNumber: "XXXX XXXX 3456",
                ),
              ),
            ),
          );
        },
  child: Ink(
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [Colors.blue.shade600, Colors.blue.shade400], // Gradient effect
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(10),
    ),
    child: Container(
      alignment: Alignment.center,
      height: 50,
      width: double.infinity,
      child: Text(
        "Proceed",
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  ),
),

              ],
            ),
          ),
        ),
      ),
    );
  }

  // PayNow Payment Method UI
  Widget _buildPaymentMethodCard(String title, String status, String logoPath,
      {bool showExtraText = false}) {
    bool isSelected = selectedMethod == title;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedMethod = title;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.green.withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? Colors.green : Colors.grey[300]!,
            width: 2,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // PayNow Logo
            Image.asset(logoPath, height: 18),

            const SizedBox(height: 8),

            // PayNow Title, Radio Button, and Linked Status
            Row(
              children: [
                Radio(
                  value: title,
                  groupValue: selectedMethod,
                  onChanged: (value) {
                    setState(() {
                      selectedMethod = value.toString();
                    });
                  },
                ),
                Expanded(
                  child: Text(title, style: const TextStyle(fontSize: 14)),
                ),
                Text(
                  status,
                  style: TextStyle(
                      color: status == "Linked" ? Colors.green : Colors.blue,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),

            // Extra Text (Only for NRIC)
            if (showExtraText && selectedMethod == "PayNow via NRIC")
              const Padding(
                padding: EdgeInsets.only(left: 35, top: 5),
                child: Text(
                  "Ensure your NRIC is registered with your bank for PayNow to receive payments successfully",
                  style: TextStyle(fontSize: 10, color: Colors.grey),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // Bank selection + Account Number Section
  Widget _buildBankDetailsSection() {
    bool isSelected = selectedMethod == "Bank Transfer";

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedMethod = "Bank Transfer";
        });
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.green.withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: isSelected ? Colors.green : Colors.grey[300]!, width: 2),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Radio Button + Bank Logo + "Add another bank" Text
            Row(
              children: [
                Radio(
                  value: "Bank Transfer",
                  groupValue: selectedMethod,
                  onChanged: (value) {
                    setState(() {
                      selectedMethod = value.toString();
                    });
                  },
                ),
                const Icon(Icons.account_balance, color: Colors.blue),
                const SizedBox(width: 5),
                const Text("Add another bank",
                    style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        fontSize: 14)),
              ],
            ),

            const SizedBox(height: 10),

            // Bank Name Dropdown
            const Text("Select Bank Name *",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            _buildBankDropdown(),

            const SizedBox(height: 10),

            // Bank Account Number Field
            const Text("Bank Account Number *",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                hintText: "XXXX XXXX 3456",
              ),
            ),

            const SizedBox(height: 10),

            // Save Details Checkbox
            Row(
              children: [
                Checkbox(
                  value: saveForFuture,
                  onChanged: (value) {
                    setState(() {
                      saveForFuture = value!;
                    });
                  },
                ),
                const Expanded(
                  child: Text("Save these details for future cashouts",
                      style: TextStyle(fontSize: 12)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Bank selection dropdown
  Widget _buildBankDropdown() {
  return DropdownButtonFormField<String>(
    value: selectedBank,
    decoration: const InputDecoration(
      border: OutlineInputBorder(),
      contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
    ),
    items: [
      _buildBankDropdownItem("DBS", "assets/images/bank_logo.png"),
      _buildBankDropdownItem("UOB", "assets/images/bank_logo.png"),
      _buildBankDropdownItem("OCBC", "assets/images/bank_logo.png"),
      _buildBankDropdownItem("HSBC", "assets/images/bank_logo.png"),
      _buildBankDropdownItem("Maybank", "assets/images/bank_logo.png"),
    ],
    onChanged: (value) {
      setState(() {
        selectedBank = value!;
      });
    },
  );
}

// Helper function to build bank dropdown items
DropdownMenuItem<String> _buildBankDropdownItem(String bankName, String logoPath) {
  return DropdownMenuItem(
    value: bankName,
    child: Row(
      children: [
        Image.asset(logoPath, height: 20), // Display bank logo
        const SizedBox(width: 8),
        Text(bankName),
      ],
    ),
  );
}

}
