import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:work_lah/utility/colors.dart';
import 'package:work_lah/utility/style_inter.dart';
import 'package:work_lah/utility/top_app_bar.dart';
import 'package:work_lah/utility/display_function.dart';
import 'package:work_lah/screens/bottombar/home/qr_scanner/scan_qr_screen.dart';
import 'package:work_lah/data/send_request.dart';

class ShiftSelectionScreen extends StatefulWidget {
  const ShiftSelectionScreen({super.key});

  @override
  _ShiftSelectionScreenState createState() => _ShiftSelectionScreenState();
}

class _ShiftSelectionScreenState extends State<ShiftSelectionScreen> {
  List<dynamic> shifts = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUpcomingShifts();
  }

  Future<void> fetchUpcomingShifts() async {
    try {
      var response = await ApiProvider().getRequest(apiUrl: '/api/qr/upcoming');
      setState(() {
        shifts = response['shifts'] ?? [];
        isLoading = false;
      });
    } catch (e) {
      toast('Error fetching shifts');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        child: Column(
          children: [
            SizedBox(height: 20.h),
            TopAppBar(title: 'Select Shift'),
            SizedBox(height: 16.h),

            // Header Text
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

            // Display shifts
            Expanded(
              child: isLoading
                  ? Center(child: CircularProgressIndicator())
                  : shifts.isEmpty
                      ? Center(child: Text("No upcoming shifts found"))
                      : ListView.builder(
                          itemCount: shifts.length,
                          itemBuilder: (context, index) {
                            final shift = shifts[index];

                            // Extract data

                            final jobTitle =
                                shift['jobId']['jobName'] ?? 'Unknown Job';
                            final location = shift['jobId']['location'] ??
                                'Unknown Location';
                            final companyName = shift['jobId']['company']
                                    ['companyLegalName'] ??
                                'Unknown Company';
                            final outletName = shift['jobId']['outlet']
                                    ['outletName'] ??
                                'Unknown Outlet';
                            final startTime =
                                "${shift['shiftId']['startTime']} ${shift['shiftId']['startMeridian']}";
                            final endTime =
                                "${shift['shiftId']['endTime']} ${shift['shiftId']['endMeridian']}";
                            final duration =
                                "${shift['shiftId']['duration']} hrs duration";
                            final payRate = "\$${shift['shiftId']['payRate']} ";
                            final breakHours =
                                "${shift['shiftId']['breakHours']} hrs break (${shift['shiftId']['breakType']})";
                            final date = DateFormat('dd MMM, yy')
                                .format(DateTime.parse(shift['date']));

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (index == 0 ||
                                    date !=
                                        DateFormat('dd MMM, yy').format(
                                            DateTime.parse(
                                                shifts[index - 1]['date'])))
                                  Padding(
                                    padding:
                                        EdgeInsets.only(top: 10.h, left: 8.w),
                                    child: Text(
                                      date,
                                      style: CustomTextInter.semiBold16(
                                          AppColors.blackColor),
                                    ),
                                  ),
                                SizedBox(height: 8.h),
                                ShiftCard(
                                  applicationId: shift['_id'],
                                  jobTitle: jobTitle,
                                  jobIcon: shift['jobId']['jobIcon'] ?? '',
                                  location: location,
                                  company: companyName,
                                  companyLogo: shift['jobId']['company']
                                          ['companyLogo'] ??
                                      '',
                                  restaurant: outletName,
                                  duration: duration,
                                  rate: payRate,
                                  breakTime: breakHours,
                                  startTime: startTime,
                                  endTime: endTime,
                                  isActive:
                                      true, // Logic can be updated based on clock-in status
                                ),
                              ],
                            );
                          },
                        ),
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }
}

class ShiftCard extends StatefulWidget {
  final String applicationId;
  final String jobTitle;
  final String jobIcon;
  final String location;
  final String company;
  final String companyLogo;
  final String restaurant;
  final String duration;
  final String rate;
  final String breakTime;
  final String startTime;
  final String endTime;
  final bool isActive;

  const ShiftCard({
    required this.applicationId,
    required this.jobTitle,
    required this.jobIcon,
    required this.location,
    required this.company,
    required this.companyLogo,
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
  bool isClockedIn = false; // ✅ Toggling Clock In/Out state

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // onTap: () {
      //   // ✅ Navigate to ScanQRScreen with Application ID
      //   Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //       builder: (context) => ScanQRScreen(
      //         // applicationId: widget.applicationId
      //         ),
      //     ),
      //   );
      // },
      child: MouseRegion(
        onEnter: (_) => setState(() => isHovered = true),
        onExit: (_) => setState(() => isHovered = false),
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 8.h),
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isHovered
                  ? AppColors.themeColor
                  : Colors.blueAccent.withOpacity(0.4),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.blueAccent.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 5,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ✅ Job Title & Location
              Row(
                children: [
                  // ✅ Job Icon
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6), // Slightly rounded corners
                    child: Image.network(
                      '${ApiProvider().baseUrl}${widget.jobIcon}',
                      height: 24.h,
                      width: 24.w,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(Icons.work, color: AppColors.themeColor, size: 24);
                      },
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      widget.jobTitle,
                      style: CustomTextInter.bold16(AppColors.blackColor),
                    ),
                  ),
                  _locationChip(widget.location), // ✅ Location Box
                ],
              ),
              SizedBox(height: 8.h),

              // ✅ Company Name with Logo
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
                    style: CustomTextInter.regular14(Colors.grey),
                  ),
                ],
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
              Divider(),
              SizedBox(height: 12.h),
              // ✅ Shift Timing & Clock In Button
              // ✅ Shift Timing & Clock In Button
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50, // Light Blue Box
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _timeChip(widget.startTime, AppColors.themeColor),
                    Text('to', style: CustomTextInter.regular14(Colors.grey)),
                    _timeChip(widget.endTime, Colors.black),
                    _clockInOutButton(context),
                  ],
                ),
              ),
            ],
          ),
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
          Text(location, style: CustomTextInter.bold12(Colors.blueAccent)),
        ],
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
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        time,
        style: CustomTextInter.bold12(Colors.white),
      ),
    );
  }

  Widget _clockInOutButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          isClockedIn = !isClockedIn; // ✅ Toggle Clock In/Out state
        });

        // ✅ Navigate to ScanQRScreen with Application ID
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ScanQRScreen(
              applicationId: widget.applicationId, // ✅ Pass Application ID
              jobTitle: widget.jobTitle, // ✅ Pass Job Title
              location: widget.location, // ✅ Pass Location
              company: widget.company, // ✅ Pass Company Name
              startTime: widget.startTime, // ✅ Pass Start Time
              endTime: widget.endTime, // ✅ Pass End Time
              jobIcon: widget.jobIcon, // ✅ Pass Job Icon
              companyLogo: widget.companyLogo, // ✅ Pass Company Logo
            ),
          ),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: isClockedIn ? Colors.red : Colors.green,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            isClockedIn ? 'Clock Out' : 'Clock In',
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
