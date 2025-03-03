import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: ShiftSelectionScreen(),
    );
  }
}

class ShiftSelectionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Container(
          padding: EdgeInsets.all(8),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.arrow_back, color: Colors.white),
          ),
        ),
        title: Text(
          'Select Shift',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_outlined, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Choose Your Job Shift To Clock In',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8),
              Text(
                'Remember: Checking in/out too early or late may delay payment. Stick to your assigned times for timely processing.',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16),
              Text(
                '08 Nov, 25',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 8),
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
              SizedBox(height: 16),
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
              SizedBox(height: 16),
              Text(
                '28 Dec, 25',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 100), // Space for bottom navigation
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: 2,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt),
            label: 'My Jobs',
          ),
          BottomNavigationBarItem(
            icon: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.blue[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.grid_view, color: Colors.blue),
            ),
            label: 'Clock in/Out',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet),
            label: 'E-wallet',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class ShiftCard extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    jobTitle == 'Tray Collector' ? Icons.restaurant : Icons.point_of_sale,
                    color: Colors.black,
                  ),
                ),
                SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      jobTitle,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.location_on, color: Colors.blue, size: 16),
                        SizedBox(width: 4),
                        Text(
                          location,
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.business, color: Colors.grey, size: 16),
                SizedBox(width: 8),
                Text(
                  company,
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.store, color: Colors.blue, size: 20),
                    SizedBox(width: 8),
                    Text(restaurant),
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.access_time, color: Colors.blue, size: 20),
                    SizedBox(width: 8),
                    Text(duration),
                  ],
                ),
              ],
            ),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.attach_money, color: Colors.blue, size: 20),
                    SizedBox(width: 8),
                    Text(rate),
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.free_breakfast, color: Colors.blue, size: 20),
                    SizedBox(width: 8),
                    Text(breakTime),
                  ],
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          startTime,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          'to',
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          endTime,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: isActive ? () {} : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isActive ? Colors.green : Colors.grey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Row(
                    children: [
                      Text(
                        'Clock In',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 4),
                      Icon(Icons.qr_code_scanner, color: Colors.white, size: 20),
                      Icon(Icons.chevron_right, color: Colors.white, size: 20),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}