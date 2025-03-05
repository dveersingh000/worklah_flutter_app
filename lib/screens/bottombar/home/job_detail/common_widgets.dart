// ignore_for_file: prefer_const_constructors, must_be_immutable, prefer_typing_uninitialized_variables, use_build_context_synchronously, avoid_print

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:work_lah/data/send_request.dart';
import 'package:work_lah/screens/bottombar/bottom_bar_screen.dart';
import 'package:work_lah/screens/bottombar/home/complete_profile/complete_profile.dart';
import 'package:work_lah/utility/colors.dart';
import 'package:work_lah/utility/display_function.dart';
import 'package:work_lah/utility/image_path.dart';
import 'package:work_lah/utility/style_inter.dart';
import 'package:work_lah/utility/syle_poppins.dart';
import 'package:url_launcher/url_launcher.dart';

class JobRequirements extends StatelessWidget {
  final List<dynamic> jobRequire;
  const JobRequirements({super.key, required this.jobRequire});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.description,
              color: AppColors.blackColor,
            ),
            SizedBox(width: 5.w),
            Text(
              'Job Requirements',
              style: CustomTextInter.medium16(AppColors.blackColor),
            ),
          ],
        ),
        SizedBox(height: 10.h),
        ListView.builder(
          itemCount: jobRequire.length,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          itemBuilder: (context, index) {
            return commonBulletPoint(jobRequire[index].toString());
          },
        ),
        SizedBox(height: 20.h),
        Text(
          'Show more',
          style: CustomTextInter.regular14(
            AppColors.themeColor,
            isUnderline: true,
          ),
        ),
      ],
    );
  }

  Widget commonBulletPoint(String text) {
    return Padding(
      padding: EdgeInsets.only(right: 10.w, left: 10.w),
      child: Row(
        children: [
          Icon(
            Icons.circle,
            color: AppColors.blackColor,
            size: 6.sp,
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              text,
              style: CustomTextInter.light14(AppColors.blackColor),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          )
        ],
      ),
    );
  }
}

class LocationWidget extends StatelessWidget {
  final locationData;
  const LocationWidget({super.key, this.locationData});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Icon(
              Icons.location_on_outlined,
              color: AppColors.blackColor,
            ),
            SizedBox(width: 5.w),
            Expanded(
              child: Text(
                'Location',
                style: CustomTextInter.medium16(AppColors.blackColor),
              ),
            ),
            RichText(
              text: TextSpan(
                children: <TextSpan>[
                  TextSpan(
                    text: 'Map/',
                    style: CustomTextInter.light16(
                      AppColors.blackColor,
                    ),
                  ),
                  TextSpan(
                    text: 'Satellite',
                    style: CustomTextInter.light16(
                      AppColors.textGreyColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 10.h),
        GestureDetector(
          onTap: () async {
            await openMap(
              locationData['latitude'].toString(),
              locationData['longitude'].toString(),
            );
          },
          child: Image.asset(ImagePath.mapIMG),
        ),
      ],
    );
  }
}

class EmployerWidget extends StatelessWidget {
  final String employerName;
  final String employerLogo;
  final String jobId;
  final String jobCategory;
  final String jobLocation;
  final String jobDates;

  const EmployerWidget({
    super.key,
    required this.employerName,
    required this.employerLogo,
    required this.jobId,
    required this.jobCategory,
    required this.jobLocation,
    required this.jobDates,
  });
  // Format Job ID to show only last 6 characters
  String getFormattedJobId(String jobId) {
    return 'ID: ${jobId.substring(jobId.length - 6).toUpperCase()}';
  }

  // Get Employer Logo (Handles missing base URL or fallback)
  String getEmployerLogo(String? logoUrl) {
    if (logoUrl == null || logoUrl.isEmpty) {
      return 'assets/images/companyLogo.png'; // Default logo
    }
    // Ensure a complete URL
    const String baseUrl = "https://worklah.onrender.com"; // Replace with actual base URL
    return logoUrl.startsWith("http") ? logoUrl : "$baseUrl$logoUrl";
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Icon(
              Icons.badge_outlined,
              color: AppColors.blackColor,
            ),
            SizedBox(width: 5.w),
            Text(
              'Employer',
              style: CustomTextInter.medium16(AppColors.blackColor),
            ),
          ],
        ),
        SizedBox(height: 10.h),
        Row(
          children: [
            ClipRRect(
            child: Image.network(
                getEmployerLogo(employerLogo),
                width: 50.w,
                height: 50.h,)
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Text(
                employerName,
                style: CustomTextInter.medium18(AppColors.blackColor),
              ),
            ),
          ],
        ),

        Divider(),
        SizedBox(height: 5.h),
        commonRowWidget(Icons.tag, 'Job ID', getFormattedJobId(jobId), context),
        SizedBox(height: 20.h),
        commonRowWidget(Icons.calendar_month_outlined, 'Job Dates',
            jobDates, context),
        SizedBox(height: 20.h),
        commonRowWidget(
            Icons.business_outlined, 'Job Category', jobCategory, context),
        SizedBox(height: 20.h),
        commonRowWidget(Icons.location_on_outlined, 'Location',
            jobLocation, context),
        SizedBox(height: 5.h),
      ],
    );
  }

  Widget commonRowWidget(
      IconData icon, String title, String subTitle, BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: AppColors.themeColor),
        SizedBox(width: 5.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: CustomTextInter.regular14(AppColors.themeColor),
              ),
              Text(
                subTitle,
                style: CustomTextInter.regular14(AppColors.blackColor),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class CompleteYourProfile extends StatefulWidget {
  final bool profileComplete;
  final String userId;
  final String shiftId;
  final String jobDate;
  final Map<String, dynamic> jobData;
  const CompleteYourProfile({
    super.key,
    required this.profileComplete,
    required this.jobData,
    required this.userId,
    required this.shiftId,
    required this.jobDate,
  });

  @override
  State<CompleteYourProfile> createState() => _CompleteYourProfileState();
}

class _CompleteYourProfileState extends State<CompleteYourProfile> {
  bool isLoading = false;
  bool isTermCheck = false;
  bool isMedicalTermCheck = false;
  bool isBookingTermCheck = false;

  Future<void> confirmJobBooking() async {
    setState(() {
      isLoading = true;
    });
    DateTime date = DateTime.parse(widget.jobDate);
    String formattedDate = DateFormat('yyyy-MM-dd').format(date);
    try {
      var response = await ApiProvider().postRequest(
          apiUrl: '/api/jobs/${widget.jobData['_id']}/apply',
          data: {
            "userId": widget.userId,
            "jobId": widget.jobData['_id'],
            "shiftId": widget.shiftId,
            "date": formattedDate,
            "isStandby": false,
          });
      toast(response['message']);
      setState(() {
        isLoading = false;
      });
      moveReplacePage(context, BottomBarScreen(index: 0));
    } catch (e) {
      log('Error during Res: $e');
      final errorMessage = e is Map ? e['message'] : 'An error occurred';
      toast(errorMessage);
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 10.h),
        Divider(),
        SizedBox(height: 10.h),
        Row(
          children: [
            Icon(
              Icons.payments,
              color: AppColors.blackColor,
            ),
            SizedBox(width: 5.w),
            Text(
              'About Payment',
              style: CustomTextInter.medium16(AppColors.blackColor),
            ),
          ],
        ),
        SizedBox(height: 5.h),
        Text(
          'Checking in or out significantly earlier or later than your scheduled times may result in delays in payment processing. To ensure timely payments. Please stick closely to your assigned check-in and check-out times.',
          style: CustomTextInter.regular12(AppColors.blackColor),
        ),
        SizedBox(height: 10.h),
        Divider(),
        SizedBox(height: 30.h),
        Row(
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  isTermCheck = !isTermCheck;
                });
              },
              child: Container(
                height: 21.h,
                width: 21.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Color(0XFFD9D9D9),
                ),
                child: isTermCheck
                    ? Center(
                        child: Icon(
                          Icons.check,
                          color: AppColors.blackColor,
                          size: 16.sp,
                        ),
                      )
                    : null,
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: RichText(
                text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                      text: 'I agree to the ',
                      style: CustomTextInter.medium12(AppColors.blackColor),
                    ),
                    TextSpan(
                      text: 'Terms and Conditions ',
                      style: CustomTextInter.regular12(
                        AppColors.themeColor,
                        isUnderline: true,
                      ),
                    ),
                    TextSpan(
                      text: 'written in the policy',
                      style: CustomTextInter.medium12(AppColors.blackColor),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 20.h),
        Row(
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  isMedicalTermCheck = !isMedicalTermCheck;
                });
              },
              child: Container(
                height: 21.h,
                width: 21.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Color(0XFFD9D9D9),
                ),
                child: isMedicalTermCheck
                    ? Center(
                        child: Icon(
                          Icons.check,
                          color: AppColors.blackColor,
                          size: 16.sp,
                        ),
                      )
                    : null,
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: RichText(
                text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                      text: 'I understand the ',
                      style: CustomTextInter.medium12(AppColors.blackColor),
                    ),
                    TextSpan(
                      text: 'medical waivers submission terms and conditions ',
                      style: CustomTextInter.regular12(
                        AppColors.themeColor,
                        isUnderline: true,
                      ),
                    ),
                    TextSpan(
                      text:
                          'and also confirm my availability on the day of shift.',
                      style: CustomTextInter.medium12(AppColors.blackColor),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 20.h),
        Row(
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  isBookingTermCheck = !isBookingTermCheck;
                });
              },
              child: Container(
                height: 21.h,
                width: 21.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Color(0XFFD9D9D9),
                ),
                child: isBookingTermCheck
                    ? Center(
                        child: Icon(
                          Icons.check,
                          color: AppColors.blackColor,
                          size: 16.sp,
                        ),
                      )
                    : null,
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: RichText(
                text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                      text:
                          'By booking a standby shift, you agree to be available and ready to work if a vacancy arises.',
                      style: CustomTextInter.medium12(AppColors.blackColor),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 30.h),
        GestureDetector(
          onTap: () {
            if (widget.profileComplete) {
              if (widget.shiftId.isNotEmpty) {
                if (isTermCheck && isBookingTermCheck && isMedicalTermCheck) {
                  confirmJobBooking();
                } else {
                  toast('Please check the checkboxes');
                }
              } else {
                toast('Please Select Shift');
              }
              print('UserID :: ${widget.userId}');
              print('JobID :: ${widget.jobData['_id']}');
              print('ShiftId :: ${widget.shiftId}');
              print('Date :: ${widget.jobDate}');
            } else {
              if (isTermCheck && isBookingTermCheck && isMedicalTermCheck) {
                moveToNext(
                  context,
                  CompleteProfile(
                    jobData: widget.jobData,
                    jobDATE: widget.jobDate,
                    shiftID: widget.shiftId,
                  ),
                );
              } else {
                toast('Please check the checkboxes');
              }
            }
          },
          child: Container(
            height: 50.h,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: widget.profileComplete
                  ? AppColors.themeColor
                  : AppColors.themeColor.withOpacity(0.1),
              border: widget.profileComplete
                  ? null
                  : Border.all(color: AppColors.fieldBorderColor),
            ),
            child: Center(
              child: isLoading
                  ? SizedBox(
                      height: 20.h,
                      width: 20.w,
                      child: CircularProgressIndicator(
                        color: AppColors.whiteColor,
                      ),
                    )
                  : Text(
                      widget.profileComplete
                          ? 'Confirm Booking'
                          : 'Complete Your Profile',
                      style: CustomTextPopins.regular16(widget.profileComplete
                          ? AppColors.whiteColor
                          : AppColors.blackColor),
                    ),
            ),
          ),
        ),
        SizedBox(height: 10.h),
        widget.profileComplete
            ? SizedBox()
            : Row(
                children: [
                  Icon(
                    Icons.info,
                    color: AppColors.primaryOrangeColor,
                  ),
                  SizedBox(width: 5.w),
                  Text(
                    'Complete your profile before shift bookings',
                    style: CustomTextPopins.regular12(
                        AppColors.primaryOrangeColor),
                  ),
                ],
              ),
      ],
    );
  }
}

class OnGoingJobAlert extends StatelessWidget {
  const OnGoingJobAlert({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Divider(),
        SizedBox(height: 20.h),
        Row(
          children: [
            Icon(
              Icons.info_outline,
              color: AppColors.dangorColor,
            ),
            SizedBox(width: 10.w),
            Text(
              'Alert',
              style: CustomTextInter.semiBold16(AppColors.dangorColor),
            ),
          ],
        ),
        SizedBox(height: 20.h),
        commonChip('About Penalty Points'),
        SizedBox(height: 20.h),
        Text(
          'Penalty points are given to users when they exhibit poor work practices such as last minute cancellation and no shows. To safeguard businesses against bad practices by workers, the penalty system will penalize workers and set restrictions in place when workers accumulate a certain amount of penalty points.',
          style: CustomTextPopins.medium12(AppColors.dangorColor),
        ),
        SizedBox(height: 20.h),
        commonChip('Shift Cancellation Panelties'),
        SizedBox(height: 20.h),
        commonPanelties('5 minutes after applying', 'No Penalty'),
        SizedBox(height: 10.h),
        commonPanelties('> 48 Hours', 'No Penalty'),
        SizedBox(height: 10.h),
        commonPanelties(
          '> 24 Hours (1st Time)',
          '\$5 Penalty',
          textColor: AppColors.dangorColor,
        ),
        SizedBox(height: 10.h),
        commonPanelties(
          '> 24 Hours (2nd Time)',
          '\$10 Penalty',
          textColor: AppColors.dangorColor,
        ),
        SizedBox(height: 10.h),
        commonPanelties(
          '> 24 Hours (3rd Time)',
          '\$15 Penalty',
          textColor: AppColors.dangorColor,
        ),
        SizedBox(height: 10.h),
        commonPanelties(
          'No Show - During Shift',
          '\$50 Penalty',
          textColor: AppColors.dangorColor,
        ),
        SizedBox(height: 20.h),
        commonChip('NOTE:'),
        SizedBox(height: 20.h),
        commonRichNote(
          '1.',
          'If you accumulate 5 or more points: ',
          'Businesses have the right to cancel your shift',
        ),
        SizedBox(height: 10.h),
        commonRichNote(
          '2.',
          'If you accumulate more than 8 points: ',
          'Your account will be suspended for 4 weeks',
        ),
        SizedBox(height: 20.h),
        Text(
          'Your account will be suspended or banned if you fail to show up without valid notice and reason.',
          style: CustomTextInter.medium12(AppColors.dangorColor),
        ),
        SizedBox(height: 10.h),
        GestureDetector(
            onTap: () async {
              const url =
                  'https://supportingadvancement.com/shift_cancellation_policy/';
              if (await canLaunch(url)) {
                await launch(url);
              } else {
                throw 'Could not launch $url';
              }
            },
            child: MouseRegion(
              cursor: SystemMouseCursors
                  .click, // ✅ Change cursor to pointer on hover
              child: Text(
                "more about shift cancellation",
                style: CustomTextInter.medium14(AppColors.blueColor)
                    .copyWith(decoration: TextDecoration.underline),
              ),
            ),
          ),
          SizedBox(height: 10.h),
        Divider(),
        SizedBox(height: 20.h),
      ],
    );
  }

  Widget commonChip(String txt) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: AppColors.dangorColor.withOpacity(0.1),
      ),
      child: Text(
        txt,
        style: CustomTextInter.medium12(AppColors.dangorColor),
      ),
    );
  }

  Widget commonPanelties(String title, String panelty, {Color? textColor}) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: CustomTextInter.medium12(AppColors.blackColor),
          ),
        ),
        Text(
          '- - - - - -  $panelty',
          style:
              CustomTextInter.medium12(textColor ?? AppColors.fieldHintColor),
        ),
      ],
    );
  }

  Widget commonRichNote(String count, String t1, String t2) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          count,
          style: CustomTextInter.medium12(AppColors.blackColor),
        ),
        SizedBox(width: 5.w),
        Expanded(
          child: RichText(
            text: TextSpan(
              children: <TextSpan>[
                TextSpan(
                  text: t1,
                  style: CustomTextInter.medium12(
                    AppColors.blackColor,
                  ),
                ),
                TextSpan(
                  text: t2,
                  style: CustomTextInter.medium12(
                    AppColors.dangorColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class CancelledJobAlert extends StatelessWidget {
  final String paneltyAmount;
  final String reasonText;
  const CancelledJobAlert(
      {super.key, required this.paneltyAmount, required this.reasonText});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Divider(),
        SizedBox(height: 20.h),
        Row(
          children: [
            Icon(
              Icons.info_outline,
              color: AppColors.dangorColor,
            ),
            SizedBox(width: 10.w),
            Text(
              'Alert',
              style: CustomTextInter.semiBold16(AppColors.dangorColor),
            ),
          ],
        ),
        SizedBox(height: 20.h),
        commonChip('About Penalty Points'),
        SizedBox(height: 20.h),
        Text(
          'Penalty points are given to users when they exhibit poor work practices such as last minute cancellation and no shows. To safeguard businesses against bad practices by workers, the penalty system will penalize workers and set restrictions in place when workers accumulate a certain amount of penalty points.',
          style: CustomTextPopins.medium12(AppColors.dangorColor),
        ),
        SizedBox(height: 20.h),
        commonChip('Your Panelties'),
        SizedBox(height: 20.h),
        commonPanelties(
          '> 24 Hours (1st Time)',
          '\$$paneltyAmount Penalty',
          textColor: AppColors.dangorColor,
        ),
        SizedBox(height: 20.h),
        Divider(),
        SizedBox(height: 20.h),
        commonChip(
          'Reason',
          backColor: AppColors.chipGreyColor,
          txtColor: AppColors.blackColor,
        ),
        SizedBox(height: 20.h),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: AppColors.chipGreyColor,
            border: Border.all(
              color: AppColors.textGreyColor,
            ),
          ),
          padding: EdgeInsets.all(10),
          child: Text(
            reasonText,
            style: CustomTextInter.regular14(AppColors.blackColor),
          ),
        ),
        SizedBox(height: 30.h),
      ],
    );
  }

  Widget commonChip(String txt, {Color? backColor, Color? txtColor}) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: backColor ?? AppColors.dangorColor.withOpacity(0.1),
      ),
      child: Text(
        txt,
        style: CustomTextInter.medium12(txtColor ?? AppColors.dangorColor),
      ),
    );
  }

  Widget commonPanelties(String title, String panelty, {Color? textColor}) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: CustomTextInter.medium12(AppColors.blackColor),
          ),
        ),
        Text(
          '- - - - - -  $panelty',
          style:
              CustomTextInter.medium12(textColor ?? AppColors.fieldHintColor),
        ),
      ],
    );
  }

  Widget commonRichNote(String count, String t1, String t2) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          count,
          style: CustomTextInter.medium12(AppColors.blackColor),
        ),
        SizedBox(width: 5.w),
        Expanded(
          child: RichText(
            text: TextSpan(
              children: <TextSpan>[
                TextSpan(
                  text: t1,
                  style: CustomTextInter.medium12(
                    AppColors.blackColor,
                  ),
                ),
                TextSpan(
                  text: t2,
                  style: CustomTextInter.medium12(
                    AppColors.dangorColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
