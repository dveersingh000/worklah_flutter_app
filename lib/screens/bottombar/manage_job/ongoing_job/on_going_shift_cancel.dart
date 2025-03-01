// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:work_lah/data/send_request.dart';
import 'package:work_lah/screens/bottombar/bottom_bar_screen.dart';
import 'package:work_lah/screens/bottombar/home/job_detail/job_details_widget.dart';
import 'package:work_lah/utility/colors.dart';
import 'package:work_lah/utility/custom_appbar.dart';
import 'package:work_lah/utility/display_function.dart';
import 'package:work_lah/utility/style_inter.dart';

class OnGoingShiftCancel extends StatefulWidget {
  final Map<String, dynamic> data;
  const OnGoingShiftCancel({super.key, required this.data});

  @override
  State<OnGoingShiftCancel> createState() => _OnGoingShiftCancelState();
}

class _OnGoingShiftCancelState extends State<OnGoingShiftCancel> {
  TextEditingController reasonController = TextEditingController();
  bool isLoading = false;
  String? selectedReason;
  File? medicalCertificate;
  bool showMedicalUpload = false;

  final List<String> cancellationReasons = [
    "Medical",
    "Emergency",
    "Personal Reason",
    "Transport Issues",
    "Other"
  ];

  void cancelJob() async {
    setState(() {
      isLoading = true;
    });

    try {
      var response = await ApiProvider().postRequest(
        apiUrl: '/api/jobs/${widget.data['applicationId']}/cancel',
        data: {
          "applicationId": widget.data['applicationId'].toString(),
          "reason": selectedReason ?? "Other",
          "description": reasonController.text,
        },
      );
      toast(response['message']);
      setState(() {
        isLoading = false;
      });
      moveReplacePage(context, BottomBarScreen(index: 0));
    } catch (e) {
      log('Error during Res: $e');
      toast('An error occurred');
      setState(() {
        isLoading = false;
      });
    }
  }

  /// Function to select medical certificate image
  Future<void> pickMedicalCertificate() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        medicalCertificate = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: commonHeight(context) * 0.05),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: CustomAppbar(title: 'Cancel Shift'),
            ),
            Column(
              children: [
                SizedBox(height: commonHeight(context) * 0.03),
                JobNameWidget(
                  jobTitle: widget.data['jobName'].toString(),
                  jobSubTitle: widget.data['outlet']?['name'] ?? "N/A",
                ),
                JobIMGWidget(
                  posterIMG: widget.data['jobIcon'].toString(),
                ),

                Padding(
                  padding: EdgeInsets.all(20.w),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.warning, color: AppColors.redColor),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Text(
                          'You are going to cancel this shift, make sure you read all the guidelines of the penalties.',
                          style: CustomTextInter.regular14(AppColors.redColor),
                        ),
                      ),
                    ],
                  ),
                ),

                Divider(),

                shiftDetailsWidget(),

                reasonForCancellationWidget(),

                // 📤 Upload Medical Certificate (Only if "Medical" is selected)
                if (showMedicalUpload) uploadMedicalCertificateWidget(),

                describeReasonWidget(),

                penaltyInformationWidget(),

                cancelButtons(),

                SizedBox(height: 50.h),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// 📅 Shift Details Widget
  Widget shiftDetailsWidget() {
    return Container(
      padding: EdgeInsets.all(15.w),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 5,
            spreadRadius: 1,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.history_toggle_off_outlined,
                    color: AppColors.blackColor,
                    size: 20.sp,
                  ),
                  SizedBox(width: 5.w),
                  Text(
                    'Cancellation Shift',
                    style: CustomTextInter.medium16(AppColors.blackColor),
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.person,
                        color: Colors.grey,
                        size: 15.sp,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        'Available Vacancy',
                        style: CustomTextInter.medium12(AppColors.blackColor),
                      ),
                      SizedBox(width: 3.w),
                      Icon(
                        Icons.info_outline,
                        color: Colors.black54,
                        size: 14.sp,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.person,
                        color: AppColors.orangeColor,
                        size: 15.sp,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        'Standby Vacancy',
                        style: CustomTextInter.medium12(AppColors.blackColor),
                      ),
                      SizedBox(width: 3.w),
                      Icon(
                        Icons.info_outline,
                        color: Colors.black54,
                        size: 14.sp,
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 10.h),
            ],
          ),

          SizedBox(height: 15.h),

          /// **Date & Time Section**
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.r),
              color: AppColors.themeColor.withOpacity(0.1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _dateBox(widget.data['jobDates'] ?? ""),
                    SizedBox(width: 30.w),
                    Row(
                      children: [
                        _timeBox(widget.data['shift']['startTime'] ?? "--:--",
                            AppColors.themeColor),
                        SizedBox(width: 5.w),
                        Text("to",
                            style:
                                CustomTextInter.medium14(AppColors.blackColor)),
                        SizedBox(width: 5.w),
                        _timeBox(widget.data['shift']['endTime'] ?? "--:--",
                            Colors.black),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 15.h),

                /// **Shift Duration & Wage**
                Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.r),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 5,
                        spreadRadius: 1,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(Icons.access_time,
                              color: AppColors.themeColor, size: 18.sp),
                          SizedBox(width: 5.w),
                          Text(
                              "${widget.data['shift']['duration'] ?? '0'} hrs duration",
                              style: CustomTextInter.medium14(
                                  AppColors.blackColor)),
                          Spacer(),
                          Icon(Icons.coffee,
                              color: AppColors.themeColor, size: 18.sp),
                          SizedBox(width: 5.w),
                          Text(
                            "${widget.data['shift']['breakDuration'] ?? '0'} break (${widget.data['shift']['breakPaid']})",
                            style:
                                CustomTextInter.medium14(AppColors.blackColor),
                          ),
                        ],
                      ),
                      SizedBox(height: 10.h),
                      Row(
                        children: [
                          Icon(Icons.currency_exchange,
                              color: AppColors.themeColor, size: 18.sp),
                          SizedBox(width: 5.w),
                          Text(
                            "${widget.data['shift']['totalWage'] ?? '0'} (${widget.data['shift']['payRate'] ?? '0'}/hr)",
                            style:
                                CustomTextInter.medium14(AppColors.blackColor),
                          ),
                        ],
                      ),
                      Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.check_circle,
                              color: Colors.green, size: 18.sp),
                          SizedBox(width: 5.w),
                          Text("Confirmed",
                              style: CustomTextInter.bold16(Colors.green)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// **Time Box UI**
  Widget _timeBox(String time, Color bgColor) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        color: bgColor,
      ),
      child: Text(
        time,
        style: CustomTextInter.bold14(Colors.white),
      ),
    );
  }

  /// **Date Box UI**
  Widget _dateBox(String? date) {
    if (date == null || date.isEmpty) {
      return Text("Invalid Date",
          style: CustomTextInter.medium12(AppColors.redColor));
    }

    try {
      DateTime parsedDate;

      if (date.contains(',')) {
        // Format: "02 Mar, 2025"
        parsedDate = DateFormat("dd MMM, yyyy").parse(date);
      } else if (date.contains('/')) {
        // Format: "06/11/2024"
        parsedDate = DateFormat("dd/MM/yyyy").parse(date);
      } else if (date.contains('-')) {
        // Format: "2024-11-06"
        parsedDate = DateTime.parse(date);
      } else {
        return Text("Invalid Date",
            style: CustomTextInter.medium12(AppColors.redColor));
      }

      String day = DateFormat('d').format(parsedDate);
      String weekday = DateFormat('EEE').format(parsedDate);
      String month = DateFormat('MMM').format(parsedDate);

      return Container(
        width: 80.w,
        padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.r),
          color: Colors.grey[200],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(width: 5.w),
            Text(
              day,
              style: CustomTextInter.bold33(AppColors.blackColor),
            ),
            SizedBox(width: 5.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(weekday,
                    style: CustomTextInter.medium12(AppColors.blackColor)),
                Text(month,
                    style: CustomTextInter.medium12(AppColors.blackColor)),
              ],
            ),
          ],
        ),
      );
    } catch (e) {
      return Text("Invalid Date",
          style: CustomTextInter.medium12(AppColors.redColor));
    }
  }

  /// **Vacancy Info**
  Widget _vacancyInfo(IconData icon, String text, Color color) {
    return Row(
      children: [
        Icon(icon, color: color, size: 14.sp),
        SizedBox(width: 4.w),
        Text(text, style: CustomTextInter.medium12(color)),
      ],
    );
  }

  /// 🛑 Reason for Cancellation Widget
  Widget reasonForCancellationWidget() {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 25.h, 20.w, 10.h), // Added top spacing
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Reason for Cancellation",
                  style: CustomTextInter.medium14(AppColors.blackColor)),
              Text("Salary",
                  style: CustomTextInter.medium14(AppColors.blackColor)),
            ],
          ),
          SizedBox(height: 8.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 200.w,
                child: DropdownButtonFormField<String>(
                  value: selectedReason,
                  hint: Text(
                    "Select Reason",
                    style: CustomTextInter.medium14(AppColors.blackColor),
                  ),
                  items: cancellationReasons.map((String reason) {
                    return DropdownMenuItem(value: reason, child: Text(reason));
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedReason = value;
                      showMedicalUpload = value == "Medical";
                    });
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.r),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 12.h,
                      horizontal: 14.w,
                    ),
                  ),
                  icon: Icon(Icons.keyboard_arrow_down,
                      size: 22.sp, color: Colors.black54),
                  dropdownColor: Colors.white,
                ),
              ),

              SizedBox(width: 15.w),

              /// **Salary Display**
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    widget.data['shift']['totalWage'] ?? "\$0",
                    style: CustomTextInter.bold18(AppColors.greenColor),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    "${widget.data['shift']['payRate'] ?? "\$0"}/hr - ${widget.data['shift']['duration'] ?? '0'} hrs",
                    style: CustomTextInter.medium12(
                        AppColors.blackColor.withOpacity(0.7)),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 📤 Upload Medical Certificate Widget
  Widget uploadMedicalCertificateWidget() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Upload Medical Certificate",
            style: CustomTextInter.medium16(AppColors.blackColor),
          ),
          SizedBox(height: 10.h),
          GestureDetector(
            onTap: pickMedicalCertificate,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(15.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: AppColors.themeColor, width: 1.5),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 5,
                    spreadRadius: 1,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.cloud_upload_outlined,
                      size: 40.sp, color: AppColors.themeColor),
                  SizedBox(height: 8.h),
                  Text(
                    "Click to upload or drop from gallery",
                    textAlign: TextAlign.center,
                    style: CustomTextInter.medium14(AppColors.themeColor),
                  ),
                  SizedBox(height: 5.h),
                  Text(
                    "Supports only JPG, PNG, JPEG",
                    textAlign: TextAlign.center,
                    style: CustomTextInter.regular12(
                        AppColors.blackColor.withOpacity(0.6)),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 10.h),
        ],
      ),
    );
  }

  /// ✏️ Describe Reason Widget
  Widget describeReasonWidget() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Described Reason",
                style: CustomTextInter.medium16(AppColors.blackColor),
              ),
              Text(
                "${reasonController.text.length}/100",
                style: CustomTextInter.medium12(
                    AppColors.blackColor.withOpacity(0.5)),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: Colors.grey.shade300, width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  spreadRadius: 1,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              controller: reasonController,
              maxLines: 4,
              maxLength: 100,
              style: CustomTextInter.medium14(AppColors.blackColor),
              decoration: InputDecoration(
                hintText: "Describe your reason here",
                hintStyle: CustomTextInter.medium14(
                    AppColors.blackColor.withOpacity(0.5)),
                border: InputBorder.none,
                counterText: "",
              ),
              onChanged: (text) {
                setState(() {});
              },
            ),
          ),
        ],
      ),
    );
  }

  /// ❗ Penalty Information Widget
  Widget penaltyInformationWidget() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
            decoration: BoxDecoration(
              color: Colors.red.shade100,
              borderRadius: BorderRadius.circular(15.r),
            ),
            child: Text(
              "NOTE:",
              style: CustomTextInter.bold14(AppColors.redColor),
            ),
          ),
          SizedBox(height: 10.h),
          RichText(
            text: TextSpan(
              style: CustomTextInter.medium14(AppColors.blackColor),
              children: [
                const TextSpan(text: "1. If you accumulate "),
                TextSpan(
                  text: "5 or more points",
                  style: CustomTextInter.bold14(AppColors.redColor),
                ),
                const TextSpan(text: ": "),
                TextSpan(
                  text: "Businesses have the right to cancel your shift",
                  style: CustomTextInter.bold14(AppColors.redColor),
                ),
                const TextSpan(text: ".\n\n"),
                const TextSpan(text: "2. If you accumulate more than "),
                TextSpan(
                  text: "8 points",
                  style: CustomTextInter.bold14(AppColors.redColor),
                ),
                const TextSpan(text: ": "),
                TextSpan(
                  text: "Your account will be suspended for 4 weeks",
                  style: CustomTextInter.bold14(AppColors.redColor),
                ),
                const TextSpan(text: ".\n\n"),
                TextSpan(
                  text:
                      "Your account will be suspended or banned if you fail to show up without valid notice and reason.",
                  style: CustomTextInter.bold14(AppColors.redColor),
                ),
              ],
            ),
          ),
          SizedBox(height: 10.h),
          GestureDetector(
            onTap: () {
              // Open shift cancellation policy page
            },
            child: Text(
              "more about shift cancellation",
              style: CustomTextInter.medium14(AppColors.blueColor)
                  .copyWith(decoration: TextDecoration.underline),
            ),
          ),
        ],
      ),
    );
  }

  /// 🚀 Confirm & Cancel Buttons
  Widget cancelButtons() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: 50.h,
            child: ElevatedButton(
              onPressed: cancelJob,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.redColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
                padding: EdgeInsets.symmetric(vertical: 14.h),
              ),
              child: Text(
                "Confirm and Cancel",
                style: CustomTextInter.bold16(AppColors.whiteColor),
              ),
            ),
          ),
          SizedBox(height: 12.h),
          SizedBox(
            width: double.infinity,
            height: 50.h,
            child: OutlinedButton(
              onPressed: () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
                side: BorderSide(color: AppColors.blueColor),
                padding: EdgeInsets.symmetric(vertical: 14.h),
              ),
              child: Text(
                "Cancel",
                style: CustomTextInter.bold16(AppColors.blueColor),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
