// ignore_for_file: prefer_const_constructors

import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:work_lah/data/send_request.dart';
import 'package:work_lah/screens/bottombar/home/home_screen_widget.dart';
import 'package:work_lah/screens/model/user_model.dart';
import 'package:work_lah/utility/colors.dart';
import 'package:work_lah/utility/display_function.dart';
import 'package:work_lah/utility/shared_prefs.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool homeDataLoading = false;
  var homeJobData = [];
  List<dynamic> filteredJobs = [];
  UserModel? userModel;
  String selectedEmployer = "";
  String selectedDate = "";
  @override
  void initState() {
    super.initState();
    getUserLocalData();
    getHomeData();
  }

  Future<void> getUserLocalData() async {
    UserModel? fetchedUser = await getUserData();
    if (fetchedUser != null) {
    try {
      // ✅ Fetch latest profile data from API
      var response = await ApiProvider().getRequest(apiUrl: '/api/profile/stats');

      if (response != null && response['profilePicture'] != null) {
        // ✅ Update user model with latest profile picture
        fetchedUser = fetchedUser.copyWith(profilePicture: response['profilePicture']);

        // ✅ Save updated user data in local storage
        await saveUserData(fetchedUser.toJson());

        // ✅ Debugging: Check new profile picture
        log("Updated profile picture: ${fetchedUser.profilePicture}");
      }
    } catch (e) {
      log("Error fetching latest user profile: $e");
    }
  }
    // ✅ Ensure userModel is not null
  if (fetchedUser != null) {
    setState(() {
      userModel = fetchedUser;
    });
  }
  }

  void getHomeData({String? date}) async {
    setState(() {
      homeDataLoading = true;
    });
    try {
      String apiUrl = '/api/jobs';
      if (date != null && date.isNotEmpty) {
        apiUrl = '/api/jobs/search?selectedDate=$date'; // ✅ Append date filter
      }

      var response = await ApiProvider().getRequest(apiUrl: apiUrl);
      setState(() {
        homeJobData = response['jobs'];
        homeDataLoading = false;
        filteredJobs = response['jobs'];
      });
    } catch (e) {
      log('Error during Res: $e');
      final errorMessage = e is Map ? e['message'] : 'An error occurred';
      toast(errorMessage);
      setState(() {
        homeDataLoading = false;
      });
    }
  }

  // Function to update jobs based on search results
  void updateSearchResults(List<dynamic> results) {
    setState(() {
      filteredJobs = results.isNotEmpty ? results : homeJobData;
    });
  }
  // ✅ Function to Update Jobs Based on Selected Date
  void filterJobsByDate(String date) {
    setState(() {
      selectedDate = date;
    });
    getHomeData(date: date); // ✅ Call API with selected date
  }

   // ✅ Function to Reset Job Filter
  void resetFilter() {
    setState(() {
      selectedDate = ""; // Clear the selected date
    });
    getHomeData(); // Reload all jobs
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: Column(
        children: [
          SizedBox(height: commonHeight(context) * 0.05),
          homeDataLoading || userModel == null
              ? SizedBox()
              : TopBarWidget(
                  userName: userModel!.fullName,
                  imgPath: userModel!.profilePicture,
                ),
          SizedBox(height: 15.h),

          // ✅ Search Bar & Date Filter (Always Visible)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            child: SearchWidget(onSearchResults: updateSearchResults),
          ),
          SizedBox(height: 15.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            child: DateSelectionWidget(
              onDateSelected: (selectedDate) {
                filterJobsByDate(selectedDate);
              },
            ),
          ),
          SizedBox(height: 15.h),

          // ✅ Show "No Jobs Found" Message with Reset Button
          homeDataLoading
              ? Expanded(
                  child: Center(
                    child: CircularProgressIndicator(color: AppColors.themeColor),
                  ),
                )
              : filteredJobs.isEmpty
                  ? Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("No Jobs Found", style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500)),
                          SizedBox(height: 15.h),
                          ElevatedButton(
                            onPressed: resetFilter,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.themeColor,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
                              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                            ),
                            child: Text("Reset Filter", style: TextStyle(color: AppColors.whiteColor, fontSize: 14.sp)),
                          ),
                        ],
                      ),
                    )
                  : Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            // ✅ Job List Container
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 20.h),
                              decoration: BoxDecoration(
                                color: Color(0xFFD6E9FF),
                                borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
                              ),
                              child: ListView.separated(
                                padding: EdgeInsets.zero,
                                separatorBuilder: (context, index) => SizedBox(height: 20.h),
                                itemCount: filteredJobs.length,
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return JobWidget(jobData: filteredJobs[index]);
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
        ],
      ),
    );
  }
}
