// ignore_for_file: prefer_const_constructors, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:work_lah/data/send_request.dart';
import 'package:work_lah/utility/colors.dart';
import 'package:work_lah/utility/custom_appbar.dart';
import 'package:work_lah/utility/display_function.dart';
import 'package:work_lah/utility/syle_poppins.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  bool isNotificationLoading = false;
  List<dynamic> notificationData = [];

  @override
  void initState() {
    super.initState();
    fetchNotifications();
  }

  Future<void> fetchNotifications() async {
    setState(() {
      isNotificationLoading = true;
    });

    try {
      var response =
          await ApiProvider().getRequest(apiUrl: "/api/notifications");

      setState(() {
        notificationData = response['notifications'] ?? [];
        isNotificationLoading = false;
      });
    } catch (error) {
      print("Error fetching notifications: $error");
      setState(() {
        isNotificationLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: commonHeight(context) * 0.05),
            CustomAppbar(title: 'Notifications'),
            SizedBox(height: commonHeight(context) * 0.02),
            isNotificationLoading
                ? Expanded(
                    child: Center(
                      child: CircularProgressIndicator(
                        color: AppColors.themeColor,
                      ),
                    ),
                  )
                : notificationData.isEmpty
                    ? Expanded(
                        child: Center(
                          child: Text(
                            'No Notifications Found',
                            style: CustomTextPopins.regular14(
                                AppColors.blackColor),
                          ),
                        ),
                      )
                    : Expanded(
                        child: ListView.separated(
                          padding: EdgeInsets.zero,
                          separatorBuilder: (context, index) =>
                              SizedBox(height: 10.h),
                          itemCount: notificationData.length,
                          shrinkWrap: true,
                          physics: BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            return commonNotificationWidget(
                                notificationData[index]);
                          },
                        ),
                      )
          ],
        ),
      ),
    );
  }

  Widget commonNotificationWidget(var resData) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: AppColors.whiteColor,
          boxShadow: [
            BoxShadow(
              blurRadius: 13,
              color: AppColors.blackColor.withOpacity(0.1),
              offset: Offset(0, 0),
            ),
          ],
        ),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Stack(
                  children: [
                    Container(
                      height: 50.h,
                      width: 50.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.lightOrangeColor,
                      ),
                      child: resData['icon'] != null
                          ? ClipOval(
                              child: Image.network(
                                '${ApiProvider().baseUrl}${resData['icon']}',
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    Icon(Icons.notifications,
                                        color: AppColors.themeColor),
                              ),
                            )
                          : Icon(Icons.notifications,
                              color: AppColors.themeColor),
                    ),
                    if (!(resData['isRead'] ?? true))
                      Positioned(
                        right: 8,
                        child: Container(
                          height: 11.h,
                          width: 11.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.redColor,
                          ),
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 5.h),
                Text(
                  resData['createdAt'] != null
                      ? DateFormat('dd MMM').format(
                          DateTime.parse(resData['createdAt']),
                        )
                      : '',
                  style: CustomTextPopins.regular12(AppColors.blackColor),
                ),
              ],
            ),
            SizedBox(width: 20.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    resData['type']?.toString() ?? 'Notification',
                    style: CustomTextPopins.regular14(AppColors.blackColor),
                  ),
                  SizedBox(height: 5.h),
                  Text(
                    resData['message']?.toString() ?? '',
                    style: CustomTextPopins.regular14(
                      AppColors.fieldHintColor,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
