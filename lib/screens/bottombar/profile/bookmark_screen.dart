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
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 15.w),
                                child:
                                    SearchWidget(onSearchResults: (results) {}),
                              ),
                              SizedBox(height: 15.h),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 15.w),
                                child: DateSelectionWidget(
                                    onDateSelected: (selectedDate) {}),
                              ),
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
                borderRadius: BorderRadius.circular(10.r),
                child: Image.network(
                  '${ApiProvider().baseUrl}${jobData['outletImage']}',
                  height: 130.h,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  // errorBuilder: (context, error, stackTrace) {
                  //   // Use local image if network fails
                  //   return Image.asset(
                  //     ImagePath.trayCollector, // Fallback image
                  //     height: 130.h,
                  //     width: double.infinity,
                  //     fit: BoxFit.cover,
                  //   );
                  // },
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
                    color: Colors.green,
                  ),
                  child: Text(
                    jobData['slotLabel'] ?? "New",
                    style: TextStyle(color: Colors.white, fontSize: 12.sp),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Text(
            jobData['jobName'],
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 5.h),
          Text(
            "Outlet: ${jobData['outletName']}",
            style: TextStyle(fontSize: 14.sp),
          ),
          Text(
            "Location: ${jobData['location']}",
            style: TextStyle(fontSize: 12.sp, color: Colors.grey),
          ),
          Text(
            "Outlet Timing: ${jobData['outletTiming']}",
            style: TextStyle(fontSize: 12.sp, color: Colors.grey),
          ),
          SizedBox(height: 10.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Est. Wage:",
                      style: TextStyle(fontSize: 12.sp, color: Colors.grey)),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                    decoration: BoxDecoration(
                      color: Colors.yellow[700],
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Text(
                      "\$${jobData['estimatedWage']} (${jobData['payRatePerHour']})",
                      style: TextStyle(
                          fontSize: 14.sp, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Text("Limited Slots Left",
                  //     style: TextStyle(fontSize: 12.sp, color: Colors.red)),
                  if (jobData['slotLabel'] == "Standby Slot Available")
                    Text(
                      jobData['slotLabel'],
                      style: TextStyle(fontSize: 12.sp, color: Colors.orange),
                    ),
                ],
              ),
            ],
          ),
          SizedBox(height: 10.h),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.themeColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
              onPressed: () {
                 Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BottomBarScreen(
                            index: 0,
                            child:
                                JobDetailsScreen(jobID: jobData['jobId']),
                          ),
                        ),
                      );
              },
              child: Text(
                "Apply Now",
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
