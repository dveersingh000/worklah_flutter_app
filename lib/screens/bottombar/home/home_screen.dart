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

  void getHomeData() async {
    setState(() {
      homeDataLoading = true;
    });
    try {
      var response = await ApiProvider().getRequest(apiUrl: '/api/jobs');
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

  @override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.whiteColor, // Keep the main background white
    body: Column(
      children: [
        SizedBox(height: commonHeight(context) * 0.05),
        homeDataLoading || userModel == null
            ? SizedBox()
            : TopBarWidget(
                userName: userModel!.fullName,
                imgPath: userModel!.profilePicture,
              ),
        homeDataLoading
            ? Expanded(
                child: Center(
                  child: CircularProgressIndicator(color: AppColors.themeColor),
                ),
              )
            : homeJobData.isEmpty
                ? Expanded(
                    child: Center(
                      child: Text('No Jobs Found'),
                    ),
                  )
                : Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(height: commonHeight(context) * 0.03),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 15.w), // ✅ Add horizontal padding
                            child: SearchWidget(onSearchResults: updateSearchResults),
                          ),
                          SizedBox(height: 15.h),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 15.w), // ✅ Add horizontal padding
                            child: DateSelectionWidget(
                                onDateSelected: (selectedDate) {
                              // TODO: Handle selected date
                            }),
                          ),
                          SizedBox(height: commonHeight(context) * 0.03),

                          // Blue Background Section for Jobs
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(
                                horizontal: 10.w, vertical: 20.h),
                            decoration: BoxDecoration(
                              color: Color(0xFFD6E9FF), // Light Blue Background
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(30.r),
                              ),
                            ),
                            child: ListView.separated(
                              padding: EdgeInsets.zero,
                              separatorBuilder: (context, index) =>
                                  SizedBox(height: 20.h),
                              itemCount: filteredJobs.length,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return JobWidget(
                                  jobData: filteredJobs[index],
                                );
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
