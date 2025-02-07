// ignore_for_file: prefer_const_constructors, must_be_immutable, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:developer';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:work_lah/data/send_request.dart';
import 'package:work_lah/screens/bottombar/home/job_detail/job_details.dart';
import 'package:work_lah/screens/notification_screen.dart';
import 'package:work_lah/utility/colors.dart';
import 'package:work_lah/utility/display_function.dart';
import 'package:work_lah/utility/style_inter.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:work_lah/screens/bottombar/home/qr_scanner/scan_qr_screen.dart';

class TopBarWidget extends StatelessWidget {
  final String userName;
  final String imgPath;
  const TopBarWidget(
      {super.key, required this.userName, required this.imgPath});

  @override
  Widget build(BuildContext context) {
    final greeting = getGreeting();
    return Padding(
      padding: EdgeInsets.only(left: 10.w, right: 10.w),
      child: Row(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                height: 53.h,
                width: 53.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.themeColor),
                ),
              ),
              SizedBox(
                height: 45.h,
                width: 45.w,
                child: Image.network(
                  imgPath,
                  fit: BoxFit.fill,
                ),
              ),
            ],
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  greeting,
                  style: CustomTextInter.medium12(AppColors.fieldHintColor),
                ),
                Text(
                  userName,
                  style: CustomTextInter.bold20(AppColors.blackColor),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.mobile_scanner),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ScanQRScreen()),
              );
            },
          ),
          GestureDetector(
              onTap: () {
                moveToNext(context, NotificationScreen());
              },
              child: Icon(
                Icons.notifications_outlined,
                color: AppColors.themeColor,
              )),
          SizedBox(width: 10.w),
          Icon(Icons.menu_outlined),
        ],
      ),
    );
  }
}

class SearchWidget extends StatefulWidget {
  final Function(List<dynamic>) onSearchResults; // Callback to pass data to parent
  const SearchWidget({super.key, required this.onSearchResults});

  @override
  // ignore: library_private_types_in_public_api
  _SearchWidgetState createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  TextEditingController searchController = TextEditingController();
  Timer? debounce;

  // Function to call the search API
  void searchJobs(String query) {
    if (query.isEmpty) {
      widget.onSearchResults([]); // Reset results if input is cleared
      return;
    }

    // Debounce API calls to reduce excessive requests
    debounce?.cancel();
    debounce = Timer(Duration(milliseconds: 500), () async {
      try {
        var response = await ApiProvider().getRequest(
          apiUrl: '/api/jobs/search?jobName=$query',
        );

        if (response != null && response['success'] == true) {
          widget.onSearchResults(response['jobs']); // Pass results to parent
        }
      } catch (e) {
        log('Error searching jobs: $e');
      }
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 50.h,
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  blurRadius: 10,
                  spreadRadius: 0,
                  offset: Offset(0, 3),
                  color: AppColors.blackColor.withOpacity(0.1),
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.only(left: 10.w, right: 10.w),
              child: TextFormField(
                controller: searchController,
                cursorColor: AppColors.fieldHintColor,
                style: CustomTextInter.medium12(AppColors.blackColor),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Search Jobs..',
                  hintStyle: CustomTextInter.medium12(AppColors.fieldHintColor),
                ),
                onChanged: (value) {
                  searchJobs(value);
                },
              ),
            ),
          ),
        ),
        SizedBox(width: 20.w),
        Container(
          height: 50.h,
          width: 50.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: AppColors.themeColor,
          ),
          child: Icon(
            Icons.search,
            color: AppColors.whiteColor,
          ),
        ),
      ],
    );
  }
}

class JobWidget extends StatelessWidget {
  dynamic jobsData;
  JobWidget({super.key, this.jobsData});

  String formatDate(String date) {
    DateTime parsedDate = DateTime.parse(date);
    return '${parsedDate.day} ${getMonthAbbreviation(parsedDate.month)}';
  }

  String getMonthAbbreviation(int month) {
    List<String> months = [
      '',
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return months[month];
  }

  @override
  Widget build(BuildContext context) {
    DateTime postDate = DateTime.parse(jobsData['postedDate']);
    String timeAgo = timeago.format(postDate);
    return Container(
      height: commonHeight(context) * 0.55,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(17),
        color: AppColors.fieldBorderColor,
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(17),
              topRight: Radius.circular(17),
            ),
            child: Image.network(
              "${ApiProvider().baseUrl}${jobsData['outlet']['outletImage']}",
              fit: BoxFit.cover,
              width: double.infinity,
              height: commonHeight(context) * 0.3,
            ),
          ),
          Positioned(
            top: 10,
            left: 20,
            child: Container(
              height: 35,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(70),
                color: AppColors.chipColor,
              ),
              padding: EdgeInsets.only(left: 10.w, right: 10.w),
              child: Center(
                child: Text(
                  timeAgo,
                  style: CustomTextInter.regular12(
                    AppColors.blackColor,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 18,
            right: 20,
            child: Container(
              height: 25,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: AppColors.whiteColor,
              ),
              padding: EdgeInsets.only(left: 10.w, right: 10.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.favorite,
                    color: AppColors.redColor,
                    size: 15.sp,
                  ),
                  SizedBox(width: 5.w),
                  Text(
                    '${jobsData['popularity']}',
                    style: CustomTextInter.light10(
                      AppColors.blackColor,
                    ),
                  )
                ],
              ),
            ),
          ),
          Positioned(
            top: commonHeight(context) * 0.15,
            left: 20,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: AppColors.whiteColor,
              ),
              padding: EdgeInsets.only(
                left: 15.w,
                right: 15.w,
                top: 9.h,
                bottom: 9.h,
              ),
              child: Center(
                child: Text(
                  'Kaanha',
                  style: CustomTextInter.light16(
                    AppColors.blackColor,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(17),
                color: AppColors.whiteColor,
                boxShadow: [
                  BoxShadow(
                    blurRadius: 4,
                    offset: Offset(0, 3),
                    spreadRadius: 0,
                    color: AppColors.blackColor.withOpacity(0.1),
                  ),
                ],
                border: Border.all(
                  color: AppColors.borderColor,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            jobsData['jobName'].toString(),
                            style: CustomTextInter.semiBold16(
                              AppColors.blackColor,
                            ),
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Icon(
                          Icons.location_pin,
                          size: 15.sp,
                        ),
                        SizedBox(width: 5.w),
                        Expanded(
                          child: Text(
                            jobsData['location'].toString(),
                            style:
                                CustomTextInter.regular12(AppColors.blackColor),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.h),
                    Row(
                      children: [
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              children: <TextSpan>[
                                TextSpan(
                                  text: 'Potential total wages: ',
                                  style: CustomTextInter.semiBold12(
                                    AppColors.primaryGreyColor,
                                  ),
                                ),
                                TextSpan(
                                  text:
                                      '\$${jobsData['totalPotentialWages'].toString()}',
                                  style: CustomTextInter.semiBold16(
                                    AppColors.greenColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Icon(
                          Icons.calendar_month,
                          size: 15.sp,
                        ),
                        SizedBox(width: 5.w),
                        Text(
                          jobsData['showDates']
                              .map((date) => formatDate(date)) // Format dates
                              .take(3) // Show only the first 3 dates
                              .join(', '), // Join with commas
                          style: CustomTextInter.regular12(
                            AppColors.blackColor,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.h),
                    Row(
                      children: [
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              children: <TextSpan>[
                                // Fetch and display pay rate from API
                                TextSpan(
                                  text:
                                      '${jobsData['payRate']} ', // Example: "$20/Hr"
                                  style: CustomTextInter.semiBold10(
                                      AppColors.blackColor),
                                ),
                                // Fetch and display work duration and break hours
                                TextSpan(
                                  text:
                                      '- (${jobsData['breakHours']} Hrs ${jobsData['breakType'].toLowerCase()} break)',
                                  style: CustomTextInter.regular10(
                                      AppColors.blackColor),
                                ),
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            moveToNext(
                              context,
                              JobDetailsScreen(jobID: jobsData['_id']),
                            );
                          },
                          child: Text(
                            'show dates',
                            style: CustomTextInter.regular12(
                              AppColors.blackColor,
                              isUnderline: true,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.h),
                    Text(
                      'Shifts available:',
                      style: CustomTextInter.semiBold12(
                        AppColors.primaryGreyColor,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: List<Widget>.from(
                              jobsData['shiftsAvailable']
                                  .take(3) // Show only the first 3 shifts
                                  .map((shiftTime) {
                                // Convert "HH:mm" to "hh:mm a" format
                                List<String> timeParts = shiftTime.split(':');
                                int hour = int.parse(timeParts[0]);
                                int minute = int.parse(timeParts[1]);

                                String formattedTime =
                                    '${hour > 12 ? hour - 12 : hour}:${minute.toString().padLeft(2, '0')} ${hour >= 12 ? 'PM' : 'AM'}';

                                return Padding(
                                  padding: EdgeInsets.only(right: 5.w),
                                  child: Container(
                                    height: 28.h,
                                    width: 70.w, // Increased width for AM/PM
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(25),
                                      border: Border.all(
                                          color: AppColors.themeColor),
                                    ),
                                    child: Center(
                                      child: Text(
                                        formattedTime, // Display formatted time
                                        style: CustomTextInter.regular14(
                                            AppColors.themeColor),
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(), // ✅ Explicitly convert to List<Widget>
                            ),
                          ),
                        ),
                        Container(
                          height: 28.h,
                          padding: EdgeInsets.only(left: 10.w, right: 10.w),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: jobsData['jobStatus'].toString() == 'Active'
                                ? AppColors.greenColor.withOpacity(0.1)
                                : AppColors.redColor.withOpacity(0.1),
                          ),
                          child: Center(
                            child: Text(
                              jobsData['jobStatus'].toString(),
                              style: CustomTextInter.regular10(
                                jobsData['jobStatus'].toString() == 'Active'
                                    ? AppColors.greenColor
                                    : AppColors.redColor,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.h),
                    GestureDetector(
                      onTap: () {
                        moveToNext(
                          context,
                          JobDetailsScreen(jobID: jobsData['_id']),
                        );
                      },
                      child: Container(
                        height: 44.h,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppColors.themeColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: AppColors.themeColor,
                            width: 1.5,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'Apply',
                            style:
                                CustomTextInter.regular16(AppColors.themeColor),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
