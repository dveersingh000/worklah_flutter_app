// ignore_for_file: prefer_const_constructors, prefer_interpolation_to_compose_strings

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:work_lah/data/send_request.dart';
import 'package:work_lah/utility/colors.dart';
import 'package:work_lah/utility/image_path.dart';
import 'package:work_lah/utility/style_inter.dart';
import 'package:work_lah/utility/syle_poppins.dart';

class AvailableShiftsWidget extends StatefulWidget {
  final List<dynamic> availableShiftsData;
  const AvailableShiftsWidget({super.key, required this.availableShiftsData});

  @override
  _AvailableShiftsWidgetState createState() => _AvailableShiftsWidgetState();
}

class _AvailableShiftsWidgetState extends State<AvailableShiftsWidget> {
  Map<String, bool> expandedSections = {}; // Track expanded states
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
          !(shiftData[sectionIndex]['shifts'][shiftIndex]['isSelected'] ?? false);
    });
  }
  void toggleSectionExpansion(String date) {
    setState(() {
      expandedSections[date] = !(expandedSections[date] ?? false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
      color: AppColors.themeColor.withOpacity(0.5), // ✅ Blue Background
      borderRadius: BorderRadius.circular(20.r),
    ),
      padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 5.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // SizedBox(height: 10.h),

          // ✅ Scrollable Shift Sections
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: widget.availableShiftsData.length,
            itemBuilder: (context, index) {
              var shiftGroup = widget.availableShiftsData[index];
              bool isExpanded = expandedSections[shiftGroup["date"]] ?? false;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 📅 Shift Date Header with Dropdown
                  GestureDetector(
                    onTap: () => toggleSectionExpansion(shiftGroup["date"]),
                    child: Container(
                      margin:
                          EdgeInsets.symmetric(vertical: 5.h),
                      padding: EdgeInsets.symmetric(
                          horizontal: 5.w, vertical: 5.h),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 5,
                            spreadRadius: 1,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // 📅 Date
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10.w, vertical: 8.h),
                                decoration: BoxDecoration(
                                  color: AppColors.lightGreyColor,
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      shiftGroup["date"].split(" ")[0],
                                      style: CustomTextInter.bold16(
                                          AppColors.blackColor),
                                    ),
                                    Text(
                                      shiftGroup["date"].split(" ")[1] +
                                          " " +
                                          shiftGroup["date"].split(" ")[2],
                                      style: CustomTextInter.medium12(
                                          AppColors.blackColor),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 20.w),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Column(
                                    children: [
                                      Text(
                                        "${shiftGroup['appliedShifts']} ",
                                        style: CustomTextInter.bold14(
                                            Colors.green),
                                      ),
                                      Text(
                                        "Applied Shifts",
                                        style: CustomTextInter.medium12(
                                            AppColors.blackColor),
                                      ),
                                    ],
                                  ),
                                  SizedBox(width: 20.w),
                                  Column(
                                    children: [
                                      Text(
                                        "${shiftGroup['availableShifts']} ",
                                        style:
                                            CustomTextInter.bold14(Colors.blue),
                                      ),
                                      Text(
                                        "Available Shifts",
                                        style: CustomTextInter.medium12(
                                            AppColors.blackColor),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Icon(
                            isExpanded
                                ? Icons.keyboard_arrow_up
                                : Icons.keyboard_arrow_down,
                            color: AppColors.blackColor,
                          ),
                        ],
                      ),
                    ),
                  ),

                  // 🔹 Shift Cards (Only Show if Expanded)
                  if (isExpanded)
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
                              // 🕒 Shift Timing
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                  Icon(Icons.access_time,
                                      color: AppColors.themeColor, size: 18.sp),
                                  SizedBox(width: 5.w),
                                  Text("${shift['duration']} hrs duration",
                                      style: CustomTextInter.medium12(
                                          AppColors.blackColor)),
                                  Spacer(),
                                  Icon(Icons.coffee,
                                      color: AppColors.themeColor,
                                      size: 18.sp),
                                  SizedBox(width: 5.w),
                                  Text(
                                    "${shift['breakDuration']} hr break (${shift['breakPaid']})",
                                    style: CustomTextInter.medium12(
                                        AppColors.blackColor),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10.h),

                              // 💲 Wage
                              Row(
                                children: [
                                  Icon(Icons.currency_exchange,
                                      color: AppColors.themeColor, size: 18.sp),
                                  SizedBox(width: 5.w),
                                  Text(
                                      "${shift['totalWage']} (${shift['payRate']}/hr)",
                                      style: CustomTextInter.medium12(
                                          AppColors.blackColor)),
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
                                    padding:
                                        EdgeInsets.symmetric(vertical: 12.h),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      if (shift[
                                          'isSelected']) // ✅ Show tick only if selected
                                        Icon(Icons.check_circle,
                                            color: AppColors.whiteColor,
                                            size: 18.sp),
                                      if (shift['isSelected'])
                                        SizedBox(width: 6.w), // ✅ Add spacing
                                      Text(
                                        shift['isSelected']
                                            ? "Selected"
                                            : "Select",
                                        style: CustomTextInter.bold16(
                                            AppColors.whiteColor),
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

Widget _timeBox(String time, {bool isSelected = false, bool isBlack = false}) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(20.r),
      color: isBlack ? Colors.black : AppColors.themeColor.withOpacity(0.9),
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
      _pillWithIcon(
          applied, AppColors.fieldHintColor, Icons.person, Colors.grey),
      SizedBox(width: 3.w), // Reduced spacing
      _pillWithIcon(
          standby, AppColors.orangeColor, Icons.person, AppColors.orangeColor),
    ],
  );
}

Widget _pillWithIcon(
    String text, Color bgColor, IconData icon, Color iconColor) {
  return Container(
    padding:
        EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h), // Reduced padding
    decoration: BoxDecoration(
      color: bgColor.withOpacity(0.2),
      borderRadius: BorderRadius.circular(15.r),
    ),
    child: Row(
      children: [
        Icon(icon, color: iconColor, size: 12.sp), // Smaller icon
        SizedBox(width: 2.w),
        Text(text,
            style: CustomTextInter.regular10(
                AppColors.blackColor)), // Smaller font
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
  const JobIMGWidget({super.key, this.posterIMG, this.outletImage});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        /// ✅ Background Image (Outlet Image)
        Padding(
          padding: const EdgeInsets.only(top: 20),
          child: outletImage != null && outletImage!.isNotEmpty
              ? Image.network(
                  '${ApiProvider().baseUrl}$outletImage',
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 180.h, // ✅ Adjust height based on UI
                )
              : Image.asset(
                  ImagePath.trayCollector, // ✅ Default image
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 180.h,
                ),
        ),

        /// ✅ Share Icon (Floating at Bottom Right)
        Positioned(
          bottom: 10.h,
          right: 20.w,
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
        children: [
          Icon(
            Icons.circle,
            color: AppColors.blackColor,
            size: 6.sp,
          ),
          SizedBox(width: 8.w),
          Text(
            text,
            style: CustomTextInter.light14(AppColors.blackColor),
          )
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
