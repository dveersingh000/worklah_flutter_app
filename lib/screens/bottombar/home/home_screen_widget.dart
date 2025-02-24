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
import 'package:work_lah/utility/image_path.dart';
// import 'package:work_lah/screens/bottombar/home/qr_scanner/scan_qr_screen.dart';

class TopBarWidget extends StatefulWidget {
  final String userName;
  final String imgPath;

  const TopBarWidget({super.key, required this.userName, required this.imgPath});

  @override
  _TopBarWidgetState createState() => _TopBarWidgetState();
}

class _TopBarWidgetState extends State<TopBarWidget> {
  final GlobalKey _menuKey = GlobalKey();
  OverlayEntry? _overlayEntry;

  void _toggleMenu() {
    if (_overlayEntry == null) {
      _overlayEntry = _createOverlayEntry();
      Overlay.of(context).insert(_overlayEntry!);
    } else {
      _overlayEntry!.remove();
      _overlayEntry = null;
    }
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = _menuKey.currentContext!.findRenderObject() as RenderBox;
    var offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
      builder: (context) => Stack(
        children: [
          // **Tap outside to close menu**
          Positioned.fill(
            child: GestureDetector(
              onTap: () => _toggleMenu(),
              behavior: HitTestBehavior.translucent,
            ),
          ),

          // **Dropdown Menu**
          Positioned(
            top: offset.dy + renderBox.size.height,
            right: 10.w,
            child: Material(
              elevation: 4,
              borderRadius: BorderRadius.circular(10.r),
              color: Colors.white,
              child: Container(
                width: 150.w,
                padding: EdgeInsets.symmetric(vertical: 5.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      leading: Icon(Icons.logout, color: AppColors.blackColor),
                      title: Text(
                        'Logout',
                        style: CustomTextInter.medium14(AppColors.blackColor),
                      ),
                      onTap: () {
                        // ✅ Handle Logout
                        _toggleMenu();
                        log('User logged out');
                      },
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

  @override
  Widget build(BuildContext context) {
    final greeting = getGreeting();
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: Row(
        children: [
          // **Profile Image with Border**
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
                  widget.imgPath,
                  fit: BoxFit.fill,
                ),
              ),
            ],
          ),
          SizedBox(width: 10.w),

          // **Greeting & User Name**
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  greeting,
                  style: CustomTextInter.medium12(AppColors.fieldHintColor),
                ),
                Text(
                  widget.userName,
                  style: CustomTextInter.bold20(AppColors.blackColor),
                ),
              ],
            ),
          ),

          // **Notifications Icon**
          GestureDetector(
            onTap: () {
              moveToNext(context, NotificationScreen());
            },
            child: Icon(
              Icons.notifications_outlined,
              color: AppColors.themeColor,
            ),
          ),
          SizedBox(width: 10.w),

          // **Menu Icon**
          GestureDetector(
            key: _menuKey,
            onTap: _toggleMenu,
            child: Icon(Icons.menu_outlined),
          ),
        ],
      ),
    );
  }
}

class SearchWidget extends StatefulWidget {
  final Function(List<dynamic>)
      onSearchResults; // Callback to pass data to parent
  const SearchWidget({super.key, required this.onSearchResults});

  @override
  _SearchWidgetState createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  TextEditingController searchController = TextEditingController();
  Timer? debounce;
  bool isSearching = false;  // ✅ Indicates when the search is loading
  bool showNoJobsMessage = false; // ✅ Controls "No Jobs Found" message

  // Function to call the search API
  void searchJobs(String query) {
    if (query.isEmpty) {
    setState(() {
      widget.onSearchResults([]); // ✅ Reset to full list
      showNoJobsMessage = false; // ✅ Hide "No Jobs Found" message
    });
    return;
  }
    setState(() {
    isSearching = true; // ✅ Show loading indicator
    showNoJobsMessage = false; // ✅ Hide "No Jobs Found" while searching
  });

    // Debounce API calls to reduce excessive requests
    debounce?.cancel();
    debounce = Timer(Duration(milliseconds: 500), () async {
      try {
        var response = await ApiProvider().getRequest(
          apiUrl: '/api/jobs/search?jobName=$query',
        );
        setState(() {
        isSearching = false; // ✅ Hide loading indicator
      });

        if (response != null && response['success'] == true) {
        List<dynamic> searchResults = response['jobs'];
        widget.onSearchResults(searchResults);

        setState(() {
          showNoJobsMessage = searchResults.isEmpty; // ✅ Show/Hide message
        });
      } else {
        setState(() {
          widget.onSearchResults([]);
          showNoJobsMessage = true; // ✅ Show "No Jobs Found"
        });
      }
      } catch (e) {
      log('Error searching jobs: $e');
      setState(() {
        isSearching = false;
        widget.onSearchResults([]);
        showNoJobsMessage = true;
      });
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
        SizedBox(width: 10.w),

        // 🔍 Search Button
        GestureDetector(
          onTap: () {
            searchJobs(searchController.text);
          },
          child: Container(
            height: 50.h,
            width: 50.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: AppColors.themeColor,
            ),
            child: Icon(Icons.search, color: AppColors.whiteColor),
          ),
        ),
        SizedBox(width: 10.w),

        // ⚙️ Filter Button
        GestureDetector(
          onTap: () {
            // TODO: Implement filter logic (show modal or navigate to filter screen)
          },
          child: Container(
            height: 50.h,
            width: 50.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: AppColors.blackColor,
            ),
            child: Icon(Icons.tune, color: AppColors.whiteColor),
          ),
        ),
      ],
    );
  }
}


class DateSelectionWidget extends StatefulWidget {
  final Function(String) onDateSelected;
  const DateSelectionWidget({super.key, required this.onDateSelected});

  @override
  _DateSelectionWidgetState createState() => _DateSelectionWidgetState();
}

class _DateSelectionWidgetState extends State<DateSelectionWidget> {
  DateTime selectedDate = DateTime.now();

  List<DateTime> getNextSevenDays() {
    return List.generate(
        7, (index) => DateTime.now().add(Duration(days: index)));
  }

  @override
  Widget build(BuildContext context) {
    List<DateTime> dates = getNextSevenDays();

    return Row(
      children: [
        // 📅 "Go to Date" Button (Properly Centered)
        GestureDetector(
          onTap: () async {
            DateTime? picked = await showDatePicker(
              context: context,
              initialDate: selectedDate,
              firstDate: DateTime.now().subtract(Duration(days: 30)),
              lastDate: DateTime.now().add(Duration(days: 90)),
            );
            if (picked != null) {
              setState(() {
                selectedDate = picked;
              });
              widget.onDateSelected(picked.toString());
            }
          },
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 14.w),
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(color: AppColors.fieldHintColor),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.calendar_today,
                    size: 18.sp, color: AppColors.blackColor),
                SizedBox(height: 3.h),
                Text("Go to",
                    style: CustomTextInter.medium10(AppColors.blackColor)),
                Text("Date",
                    style: CustomTextInter.medium10(AppColors.blackColor)),
              ],
            ),
          ),
        ),

        // 🔹 Vertical Divider (Properly Aligned)
        Container(
          width: 1.5.w,
          height: 50.h,
          color: AppColors.fieldHintColor,
          margin: EdgeInsets.symmetric(horizontal: 8.w),
        ),

        // 📆 Scrollable Date List (Pill Shapes)
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: dates.map((date) {
                bool isSelected = selectedDate.day == date.day;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedDate = date;
                    });
                    widget.onDateSelected(date.toString());
                  },
                  child: Container(
                    width: 55.w, // More pill-like
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    margin: EdgeInsets.symmetric(horizontal: 5.w),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.themeColor
                          : Color(0xFFE6F0FF), // Light blue for unselected
                      borderRadius: BorderRadius.circular(30.r), // More rounded
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          [
                            "Sun",
                            "Mon",
                            "Tue",
                            "Wed",
                            "Thu",
                            "Fri",
                            "Sat"
                          ][date.weekday % 7],
                          style: CustomTextInter.medium12(
                            isSelected
                                ? AppColors.whiteColor
                                : AppColors.blackColor,
                          ),
                        ),
                        SizedBox(height: 3.h), // Space between text
                        Text(
                          date.day.toString(),
                          style: CustomTextInter.bold18(
                            isSelected
                                ? AppColors.whiteColor
                                : AppColors.blackColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}

class JobWidget extends StatelessWidget {
  final dynamic jobData;
  JobWidget({super.key, required this.jobData});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.h, horizontal: 15.w),
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.r),
        border: Border.all(color: Colors.grey.withOpacity(0.3)),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            blurRadius: 5,
            spreadRadius: 1,
            offset: Offset(0, 2),
            color: Colors.black.withOpacity(0.1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// **Outlet Image & Badge**
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15.r),
                  topRight: Radius.circular(15.r),
                ),
                child: Image.network(
                  jobData['outletImage'] ?? "",
                  height: 130.h,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    // Use local image if network fails
                    return Image.asset(
                      ImagePath.outletImage, // Use the constant from ImagePath
                      height: 130.h,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    );
                  },
                ),
              ),
              Positioned(
                top: 10.h,
                left: 10.w,
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.r),
                    color: Colors.white,
                  ),
                  child: Text(
                    jobData['outlet']['outletName'] ?? 'Unknown',
                    style: CustomTextInter.medium12(AppColors.blackColor),
                  ),
                ),
              ),
              Positioned(
                top: 10.h,
                right: 10.w,
                child: Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors
                        .white, // ✅ White background for better visibility
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 5,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.bookmark_border,
                    color: Colors.black, // ✅ Black icon for contrast
                    size: 22.sp,
                  ),
                ),
              ),
            ],
          ),

          /// **Job Details**
          Padding(
            padding: EdgeInsets.all(12.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// **Job Title & Wage**
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        jobData['jobName'] ?? 'Job Title',
                        style: CustomTextInter.bold16(AppColors.blackColor),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Est. Wage:',
                          style: CustomTextInter.medium12(Colors.grey),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10.w, vertical: 5.h),
                          decoration: BoxDecoration(
                            color: Colors.yellow[700],
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: '\$${jobData['estimatedWage'] ?? '0'}',
                                  style: CustomTextInter.bold14(
                                      AppColors.blackColor),
                                ),
                                TextSpan(
                                  text: ' (${jobData['payRatePerHour']})',
                                  style: CustomTextInter.medium12(
                                      AppColors.blackColor),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 8.h),

                /// **Location**
                Row(
                  children: [
                    Icon(Icons.location_on, color: Colors.blue, size: 18.sp),
                    SizedBox(width: 5.w),
                    Text(
                      jobData['shortAddress'] ??
                          jobData['location'] ??
                          'Location',
                      style: CustomTextInter.medium12(AppColors.blackColor),
                    ),
                  ],
                ),
                SizedBox(height: 5.h),

                /// **Outlet Timing**
                Text(
                  'Outlet timing: ${jobData['outletTiming']}',
                  style: CustomTextInter.medium12(AppColors.blackColor),
                ),
                SizedBox(height: 5.h),

                /// **Slot Label (Trending, Limited Slots, etc.)**
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: Colors.orange[400],
                    borderRadius: BorderRadius.circular(5.r),
                  ),
                  child: Text(
                    jobData['slotLabel'] ?? 'New',
                    style: CustomTextInter.bold12(AppColors.whiteColor),
                  ),
                ),
                SizedBox(height: 12.h),

                /// **Apply Button**
                SizedBox(
  width: double.infinity,
  child: ElevatedButton(
    onPressed: () {
      /// ✅ Navigate to JobDetailsScreen and pass jobID
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => JobDetailsScreen(
            jobID: jobData['_id'], // ✅ Ensure jobData['_id'] exists
          ),
        ),
      );
    },
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.themeColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.r),
      ),
      padding: EdgeInsets.symmetric(vertical: 15.h),
    ),
    child: Text(
      'Apply',
      style: CustomTextInter.bold16(AppColors.whiteColor),
    ),
  ),
),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
