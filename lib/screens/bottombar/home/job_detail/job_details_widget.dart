// ignore_for_file: prefer_const_constructors, prefer_interpolation_to_compose_strings

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:work_lah/data/send_request.dart';
import 'package:work_lah/utility/colors.dart';
import 'package:work_lah/utility/image_path.dart';
import 'package:work_lah/utility/style_inter.dart';
import 'package:work_lah/utility/syle_poppins.dart';
import 'package:share_plus/share_plus.dart';

class AvailableShiftsWidget extends StatefulWidget {
  final List<dynamic> availableShiftsData;
  const AvailableShiftsWidget({super.key, required this.availableShiftsData});

  @override
  _AvailableShiftsWidgetState createState() => _AvailableShiftsWidgetState();
}

class _AvailableShiftsWidgetState extends State<AvailableShiftsWidget> {
  List<dynamic> shiftData = [];

  @override
  void initState() {
    super.initState();
    shiftData = List.from(widget.availableShiftsData); // ✅ Copy initial data
  }

  /// ✅ Toggle Shift Selection
  void toggleShiftSelection(int sectionIndex, int shiftIndex) {
    setState(() {
      shiftData[sectionIndex]['shifts'][shiftIndex]['isSelected'] =
          !(shiftData[sectionIndex]['shifts'][shiftIndex]['isSelected'] ??
              false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 5.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ✅ Scrollable Shift Sections (Always Visible)
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: shiftData.length,
            itemBuilder: (context, index) {
              var shiftGroup = shiftData[index];

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 📅 Shift Date Header (Always Visible)
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 5.h),
                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
                    decoration: BoxDecoration(
                      color: AppColors.themeColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // 📅 Date
                        Row(
                          children: [
                            Icon(Icons.calendar_today, size: 18.sp, color: AppColors.blackColor),
                            SizedBox(width: 8.w),
                            Text(
                              shiftGroup["date"],
                              style: CustomTextInter.medium16(AppColors.blackColor),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              "${shiftGroup['appliedShifts']} Applied | ",
                              style: CustomTextInter.medium12(AppColors.blackColor),
                            ),
                            Text(
                              "${shiftGroup['availableShifts']} Available",
                              style: CustomTextInter.medium12(Colors.blue),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // 🔹 Shift Cards (Always Visible)
                  ListView.separated(
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    itemCount: shiftGroup['shifts'].length,
                    separatorBuilder: (context, _) => SizedBox(height: 10.h),
                    itemBuilder: (context, shiftIndex) {
                      var shift = shiftGroup['shifts'][shiftIndex];

                      return Container(
                        margin: EdgeInsets.symmetric(horizontal: 10.w),
                        padding: EdgeInsets.all(12.w),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.r),
                          color: AppColors.themeColor.withOpacity(0.3),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 🕒 Shift Timing
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    _timeBox(shift['startTime']),
                                    SizedBox(width: 5.w),
                                    Text("to"),
                                    SizedBox(width: 5.w),
                                    _timeBox(shift['endTime']),
                                  ],
                                ),
                                _availabilityBox(shift['vacancy'].toString(), shift['standbyVacancy'].toString()),
                              ],
                            ),
                            Divider(),
                            SizedBox(height: 10.h),
                            // ⏳ Duration & Break
                            Row(
                              children: [
                                Icon(Icons.access_time, color: AppColors.themeColor, size: 18.sp),
                                SizedBox(width: 5.w),
                                Text("${shift['duration']} hrs duration", style: CustomTextInter.medium12(AppColors.blackColor)),
                                Spacer(),
                                Icon(Icons.coffee, color: AppColors.themeColor, size: 18.sp),
                                SizedBox(width: 5.w),
                                Text(
                                  "${shift['breakDuration']} hr break (${shift['breakPaid']})",
                                  style: CustomTextInter.medium12(AppColors.blackColor),
                                ),
                              ],
                            ),
                            SizedBox(height: 10.h),

                            // 💲 Wage
                            Row(
                              children: [
                                Icon(Icons.currency_exchange, color: AppColors.themeColor, size: 18.sp),
                                SizedBox(width: 5.w),
                                Text("${shift['totalWage']} (${shift['payRate']}/hr)", style: CustomTextInter.medium12(AppColors.blackColor)),
                              ],
                            ),
                            Divider(),

                            // ✅ Apply / Selected Button
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  toggleShiftSelection(index, shiftIndex);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: shift['isSelected']
                                      ? Colors.green
                                      : AppColors.themeColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.r),
                                  ),
                                  padding: EdgeInsets.symmetric(vertical: 12.h),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    if (shift['isSelected']) // ✅ Show tick only if selected
                                      Icon(Icons.check_circle, color: AppColors.whiteColor, size: 18.sp),
                                    if (shift['isSelected'])
                                      SizedBox(width: 6.w), // ✅ Add spacing
                                    Text(
                                      shift['isSelected'] ? "Selected" : "Select",
                                      style: CustomTextInter.bold16(AppColors.whiteColor),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

Widget _timeBox(String time) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(20.r),
      color: AppColors.themeColor.withOpacity(0.9),
    ),
    child: Text(
      time,
      style: CustomTextInter.regular12(AppColors.whiteColor),
    ),
  );
}

Widget _availabilityBox(String applied, String standby) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      _pillWithIcon(applied, applied != "0" ? Colors.green : AppColors.fieldHintColor, Icons.person, applied != "0" ? Colors.green : Colors.grey),
      SizedBox(width: 3.w), 
      _pillWithIcon(standby, standby != "0" ? AppColors.orangeColor : AppColors.fieldHintColor, Icons.person, standby != "0" ? AppColors.orangeColor : Colors.grey),
    ],
  );
}

Widget _pillWithIcon(String text, Color bgColor, IconData icon, Color iconColor) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
    decoration: BoxDecoration(
      color: bgColor.withOpacity(0.2),
      borderRadius: BorderRadius.circular(15.r),
    ),
    child: Row(
      children: [
        Icon(icon, color: iconColor, size: 12.sp),
        SizedBox(width: 2.w),
        Text(text, style: CustomTextInter.regular10(AppColors.blackColor)),
      ],
    ),
  );
}


Widget _pill(String text, Color color) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
    decoration: BoxDecoration(
      color: color.withOpacity(0.2),
      borderRadius: BorderRadius.circular(8.r),
    ),
    child: Text(
      text,
      style: CustomTextInter.regular14(AppColors.blackColor),
    ),
  );
}

class JobNameWidget extends StatelessWidget {
  final String? jobTitle;
  final String? jobSubTitle;
  const JobNameWidget({
    super.key,
    this.jobTitle,
    this.jobSubTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 10.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.asset(ImagePath.dishIMG),
              SizedBox(width: 10.w),
              Text(
                jobTitle ?? 'Unknown Job',
                style: CustomTextInter.semiBold24(AppColors.blackColor),
              ),
            ],
          ),
          Text(
            jobSubTitle ??
                'Unknown Outlet', // ✅ Using Outlet Name Instead of Subtitle
            style: CustomTextPopins.medium14(AppColors.subTitColor),
          )
        ],
      ),
    );
  }
}

class JobIMGWidget extends StatelessWidget {
  final String? posterIMG;
  // final String? smallIMG;
  final String? outletImage;
  final bool showShareButton;
  final String jobTitle;
  final String jobLocation;
  final String jobUrl;
  const JobIMGWidget(
      {super.key,
      this.posterIMG,
      this.outletImage,
      this.showShareButton = false,
      required this.jobTitle,
      required this.jobLocation,
      required this.jobUrl});

  /// ✅ Function to Share Job Details
  void shareJobDetails() {
    String shareText =
        "🔥 Check out this job: $jobTitle\n📍 Location: $jobLocation\n🔗 Apply Now: $jobUrl";

    Share.share(shareText);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        /// ✅ Background Image (Outlet Image)
        Padding(
          padding: const EdgeInsets.only(top: 20),
          child: posterIMG != null && posterIMG!.isNotEmpty
              ? Image.network(
                  '${ApiProvider().baseUrl}$posterIMG',
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 180.h,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset(
                      ImagePath.trayCollector,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 180.h,
                    );
                  },
                )
              : Image.asset(
                  ImagePath.trayCollector,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 180.h,
                ),
        ),

        /// ✅ Conditionally Show Share Icon
        if (showShareButton)
          Positioned(
            bottom: 10.h,
            right: 20.w,
            child: GestureDetector(
              onTap: shareJobDetails, // ✅ Call share function on tap
              child: Container(
                height: 45.h,
                width: 45.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.whiteColor,
                ),
                child: Icon(
                  Icons.share,
                  color: AppColors.blackColor,
                  size: 21.sp,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class JobScopsWidget extends StatelessWidget {
  final List<dynamic> jobScropDesc;
  const JobScopsWidget({super.key, required this.jobScropDesc});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Icon(
              Icons.my_location_outlined,
              color: AppColors.blackColor,
            ),
            SizedBox(width: 5.w),
            Text(
              'Job Scope',
              style: CustomTextInter.medium16(AppColors.blackColor),
            ),
          ],
        ),
        SizedBox(height: 10.h),
        ListView.builder(
          itemCount: jobScropDesc.length,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          itemBuilder: (context, index) {
            return commonBulletPoint(jobScropDesc[index].toString());
          },
        ),
        SizedBox(height: 20.h),
      ],
    );
  }

  Widget commonBulletPoint(String text) {
    return Padding(
      padding: EdgeInsets.only(right: 10.w, left: 10.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start, // ✅ Aligns text properly
        children: [
          Icon(
            Icons.circle,
            color: AppColors.blackColor,
            size: 6.sp,
          ),
          SizedBox(width: 8.w),
          Expanded(
            // ✅ Prevents overflow by wrapping text
            child: Text(
              text,
              style: CustomTextInter.light14(AppColors.blackColor),
              softWrap: true, // ✅ Ensures text wraps
              overflow: TextOverflow.visible, // ✅ Avoids truncation
            ),
          ),
        ],
      ),
    );
  }
}

class JobRequirementWidget extends StatelessWidget {
  final List<dynamic> jobRequirements;
  const JobRequirementWidget({super.key, required this.jobRequirements});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Icon(
              Icons.check_circle_outline,
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
          itemCount: jobRequirements.length,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          itemBuilder: (context, index) {
            return commonBulletPoint(jobRequirements[index].toString());
          },
        ),
        SizedBox(height: 20.h),
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
            ),
          ),
        ],
      ),
    );
  }
}
