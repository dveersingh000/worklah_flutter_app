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
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        surfaceTintColor: AppColors.whiteColor,
        automaticallyImplyLeading: false,
        title: Text(
          'Manage Jobs',
          style: CustomTextInter.medium20(AppColors.blackColor),
        ),
        actions: [
          // Icon(Icons.qr_code_scanner_outlined),
          SizedBox(width: 10.w),
          GestureDetector(
              onTap: () => moveToNext(context, NotificationScreen()),
              child: Icon(
                Icons.notifications_outlined,
                color: AppColors.themeColor,
              )),
          SizedBox(width: 10.w),
          Icon(Icons.menu_outlined),
          SizedBox(width: 10.w),
        ],
        bottom: TabBar(
            dividerColor: AppColors.dividerColor,
            indicatorColor: AppColors.themeColor,
            controller: tabController,
            labelStyle: CustomTextPopins.medium14(AppColors.themeColor),
            unselectedLabelStyle: CustomTextPopins.medium14(
              AppColors.fieldHintColor,
            ),
            tabs: [
              Tab(
                text: 'Ongoing',
              ),
              Tab(
                text: 'Completed',
              ),
              Tab(
                text: 'Cancelled',
              ),
            ]),
      ),
      body: TabBarView(
        controller: tabController,
        children: [
          OnGoingTabView(),
          CompletedTabView(),
          CancelledTabView(),
        ],
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
