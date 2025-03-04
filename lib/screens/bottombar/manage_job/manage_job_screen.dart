// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:work_lah/screens/bottombar/manage_job/cancelled_job/cancelled_tab_view.dart';
import 'package:work_lah/screens/bottombar/manage_job/completed_job/completed_tab_view.dart';
import 'package:work_lah/screens/bottombar/manage_job/ongoing_job/on_going_tab_view.dart';
import 'package:work_lah/screens/notification_screen.dart';
import 'package:work_lah/utility/colors.dart';
import 'package:work_lah/utility/display_function.dart';
import 'package:work_lah/utility/style_inter.dart';
import 'package:work_lah/utility/syle_poppins.dart';
import 'package:work_lah/utility/top_app_bar.dart';

class ManageJobScreen extends StatefulWidget {
  const ManageJobScreen({super.key});

  @override
  State<ManageJobScreen> createState() => _ManageJobScreenState();
}

class _ManageJobScreenState extends State<ManageJobScreen>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    tabController = TabController(length: 3, vsync: this);
    tabController.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.whiteColor,
    body: Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w), // Horizontal padding
      child: Column(
        children: [
          SizedBox(height: commonHeight(context) * 0.05), // Padding above TopAppBar

          // ✅ Use the reusable TopAppBar
          TopAppBar(title: 'Manage Jobs'),

          SizedBox(height: commonHeight(context) * 0.02), // Padding below TopAppBar

          // ✅ TabBar for job categories
          TabBar(
            dividerColor: AppColors.dividerColor,
            indicatorColor: AppColors.themeColor,
            controller: tabController,
            labelStyle: CustomTextPopins.medium14(AppColors.themeColor),
            unselectedLabelStyle: CustomTextPopins.medium14(
              AppColors.fieldHintColor,
            ),
            tabs: [
              Tab(text: 'Upcoming'),
              Tab(text: 'Completed'),
              Tab(text: 'Cancelled'),
            ],
          ),

          Expanded(
            child: TabBarView(
              controller: tabController,
              children: [
                OnGoingTabView(),
                CompletedTabView(),
                CancelledTabView(),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

}


// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:work_lah/screens/bottombar/manage_job/cancelled_job/cancelled_tab_view.dart';
// import 'package:work_lah/screens/bottombar/manage_job/completed_job/completed_tab_view.dart';
// import 'package:work_lah/screens/bottombar/manage_job/ongoing_job/on_going_tab_view.dart';
// import 'package:work_lah/utility/colors.dart';
// import 'package:work_lah/utility/style_inter.dart';
// import 'package:work_lah/utility/syle_poppins.dart';
// import 'package:work_lah/utility/top_app_bar.dart'; // Import the reusable TopAppBar

// class ManageJobScreen extends StatefulWidget {
//   const ManageJobScreen({super.key});

//   @override
//   State<ManageJobScreen> createState() => _ManageJobScreenState();
// }

// class _ManageJobScreenState extends State<ManageJobScreen>
//     with SingleTickerProviderStateMixin {
//   late TabController tabController;

//   @override
//   void initState() {
//     tabController = TabController(length: 3, vsync: this);
//     tabController.addListener(() {
//       setState(() {});
//     });
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.whiteColor,

//       // ✅ Use the reusable TopAppBar
//       appBar: PreferredSize(
//         preferredSize: Size.fromHeight(110.h), // Adjust height to include tabs
//         child: Column(
//           children: [
//             TopAppBar(title: 'Manage Jobs'),
//             TabBar(
//               controller: tabController,
//               indicatorColor: AppColors.themeColor,
//               labelStyle: CustomTextPopins.medium14(AppColors.themeColor),
//               unselectedLabelStyle:
//                   CustomTextPopins.medium14(AppColors.fieldHintColor),
//               tabs: [
//                 Tab(text: 'Ongoing'),
//                 Tab(text: 'Completed'),
//                 Tab(text: 'Cancelled'),
//               ],
//             ),
//           ],
//         ),
//       ),

//       // ✅ Tab View for each job status
//       body: TabBarView(
//         controller: tabController,
//         children: [
//           OnGoingTabView(),
//           CompletedTabView(),
//           CancelledTabView(),
//         ],
//       ),
//     );
//   }
// }
