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
  @override
  void initState() {
    super.initState();
    getUserLocalData();
    getHomeData();
  }

  Future<void> getUserLocalData() async {
    UserModel? fetchedUser = await getUserData();
    setState(() {
      userModel = fetchedUser!;
    });
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
      backgroundColor: AppColors.whiteColor,
      body: Column(
        children: [
          SizedBox(height: commonHeight(context) * 0.05),
          homeDataLoading
              ? SizedBox()
              : TopBarWidget(
                  userName: userModel!.fullName,
                  imgPath: userModel!.profilePicture,
                ),
          homeDataLoading
              ? Expanded(
                  child: Center(
                    child:
                        CircularProgressIndicator(color: AppColors.themeColor),
                  ),
                )
              : homeJobData.isEmpty
                  ? Expanded(
                      child: Center(
                        child: Text('No Jobs Found'),
                      ),
                    )
                  : Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(left: 10.w, right: 10.w),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              SizedBox(height: commonHeight(context) * 0.03),
                              SearchWidget(onSearchResults: updateSearchResults),
                              SizedBox(height: commonHeight(context) * 0.03),
                              ListView.separated(
                                padding: EdgeInsets.zero,
                                separatorBuilder: (context, index) =>
                                    SizedBox(height: 20.h),
                                itemCount: homeJobData.length,
                                shrinkWrap: true,
                                physics: BouncingScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return JobWidget(
                                    jobsData: homeJobData[index],
                                  );
                                },
                              )
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
