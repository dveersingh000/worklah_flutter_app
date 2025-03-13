import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:work_lah/data/send_request.dart';
import 'package:work_lah/utility/colors.dart';
import 'package:work_lah/utility/custom_appbar.dart';
import 'package:work_lah/screens/bottombar/home/home_screen_widget.dart';
import 'package:work_lah/utility/display_function.dart';
import 'package:work_lah/utility/shared_prefs.dart';
import 'package:work_lah/screens/model/user_model.dart';
import 'package:work_lah/screens/bottombar/bottom_bar_screen.dart';
import 'package:work_lah/screens/bottombar/home/job_detail/job_details.dart';
import 'dart:async';
import 'package:work_lah/utility/style_inter.dart';
import 'package:work_lah/utility/image_path.dart';


class BookmarkScreen extends StatefulWidget {
  const BookmarkScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _BookmarkScreenState createState() => _BookmarkScreenState();
}

class _BookmarkScreenState extends State<BookmarkScreen> {
  List<dynamic> bookmarkedJobs = [];
  bool isLoading = true;
  String? userId;

  @override
  void initState() {
    super.initState();
    _fetchUserIdAndBookmarkedJobs(); // ✅ Call the correct method
  }

  // ✅ Fetch Logged-in User ID & Then Fetch Bookmarked Jobs
  Future<void> _fetchUserIdAndBookmarkedJobs() async {
    try {
      UserModel? user = await getUserData(); 

      if (user != null && user.id.isNotEmpty) {
        setState(() {
          userId = user.id; 
        });

        // ✅ Fetch bookmarked jobs **after** setting userId
        await _fetchBookmarkedJobs();
      } else {
        setState(() => isLoading = false);
      }
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  // ✅ Fetch Bookmarked Jobs from API for Logged-in User
  Future<void> _fetchBookmarkedJobs() async {
    if (userId == null) return; // ✅ Avoid unnecessary API calls if userId is null

    try {
      var response = await ApiProvider().getRequest(
        apiUrl: '/api/bookmark?userId=$userId',
      );

      if (response != null && response['success'] == true) {
        setState(() {
          bookmarkedJobs = response['bookmarks'];
        });
      } 
    } catch (e) {
        print('Error fetching bookmarked jobs: $e');
    } finally {
      setState(() => isLoading = false); // ✅ Ensure loading state updates
    }
  }

   // ✅ Toggle bookmark status
  Future<void> _toggleBookmark(String jobId) async {
    if (userId == null) return;

    try {
      var response = await ApiProvider().postRequest(
        apiUrl: '/api/bookmark',
        data: {'jobId': jobId, 'userId': userId},
      );

      if (response != null && response['success'] == true) {
        setState(() {
          bookmarkedJobs.removeWhere((job) => job['jobId'] == jobId);
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Bookmark removed successfully!")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to update bookmark.")),
        );
      }
    } catch (e) {
      print('❌ Error toggling bookmark: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error updating bookmark.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.01),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: CustomAppbar(title: "Bookmarked Jobs"),
          ),
          Expanded(
            child: isLoading
                ? Center(
                    child:
                        CircularProgressIndicator(color: AppColors.themeColor))
                : bookmarkedJobs.isEmpty
                    ? Center(
                        child: Text("No Bookmarked Jobs",
                            style:
                                TextStyle(color: Colors.grey, fontSize: 16.sp)))
                    : SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.all(15.w),
                          child: Column(
                            children: [
                              // Padding(
                              //   padding: EdgeInsets.symmetric(horizontal: 15.w),
                              //   child:
                              //       SearchWidget(onSearchResults: (results) {}),
                              // ),
                              // SizedBox(height: 15.h),
                              // Padding(
                              //   padding: EdgeInsets.symmetric(horizontal: 15.w),
                              //   child: DateSelectionWidget(
                              //       onDateSelected: (selectedDate) {}),
                              // ),
                              ListView.builder(
                                itemCount: bookmarkedJobs.length,
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return _buildJobCard(bookmarkedJobs[index]);
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

  Widget _buildJobCard(dynamic jobData) {
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
                '${ApiProvider().baseUrl}${jobData['outletImage']}',
                height: 130.h,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset(
                    ImagePath.trayCollector, // Fallback image
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
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.r),
                  color: Colors.white,
                ),
                child: Text(
                  jobData['outletName'] ?? 'Unknown',
                  style: CustomTextInter.medium12(AppColors.blackColor),
                ),
              ),
            ),
            Positioned(
                top: 10.h,
                right: 10.w,
                child: GestureDetector(
                  onTap: () => _toggleBookmark(jobData['jobId']),
                  child: Container(
                    padding: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 5,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.bookmark,
                      color: Colors.blue,
                      size: 24.sp,
                    ),
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
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                        decoration: BoxDecoration(
                          color: Colors.yellow[700],
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'S${jobData['payRatePerHour'] ?? '0'}',
                              style: CustomTextInter.bold14(AppColors.blackColor),
                            ),
                            Text(
                              '(Est: S\$${jobData['estimatedWage'] ?? '0'})',
                              style: CustomTextInter.medium12(AppColors.blackColor),
                            ),
                          ],
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
                    jobData['shortAddress'] ?? jobData['location'] ?? 'Location',
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
                        builder: (context) => BottomBarScreen(
                          index: -1,
                          child: JobDetailsScreen(jobID: jobData['jobId']),
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
