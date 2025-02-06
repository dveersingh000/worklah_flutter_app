// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:work_lah/screens/login_screen.dart';
import 'package:work_lah/screens/notification_screen.dart';
import 'package:work_lah/utility/colors.dart';
import 'package:work_lah/utility/display_function.dart';
import 'package:work_lah/utility/shared_prefs.dart';
import 'package:work_lah/utility/style_inter.dart';

class CustomAppbar extends StatelessWidget {
  final String title;
  final bool isAction;
  final bool isLeading;
  final Color? leadingBack, leadingIcon, titleColor;
  const CustomAppbar(
      {super.key,
      required this.title,
      this.isAction = false,
      this.isLeading = true,
      this.leadingBack,
      this.leadingIcon,
      this.titleColor});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        isLeading
            ? GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  height: 40.h,
                  width: 40.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: leadingBack ?? AppColors.themeColor,
                  ),
                  child: Center(
                    child: Icon(
                      Icons.arrow_back,
                      color: leadingIcon ?? AppColors.whiteColor,
                    ),
                  ),
                ),
              )
            : SizedBox(),
        SizedBox(width: 10.w),
        Expanded(
          child: Text(
            title,
            style: CustomTextInter.medium16(titleColor ?? AppColors.blackColor),
          ),
        ),
        if (isAction) ...[
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
          GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    backgroundColor: AppColors.whiteColor,
                    surfaceTintColor: AppColors.whiteColor,
                    title: Text('Logout?'),
                    content: Text('Are you sure want to logout?'),
                    actions: [
                      TextButton(
                        onPressed: () async {
                          await removeLogin().then(
                            (value) async {
                              await removeLoginToken().then(
                                (value) async {
                                  await removeUserData().then(
                                    (value) {
                                      moveReplacePage(context, LoginScreen());
                                    },
                                  );
                                },
                              );
                            },
                          );
                        },
                        child: Text(
                          'Yes',
                          style: TextStyle(color: AppColors.themeColor),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          'No',
                          style: TextStyle(color: AppColors.themeColor),
                        ),
                      ),
                    ],
                  ),
                );
              },
              child: Icon(Icons.logout)),
          SizedBox(width: 10.w),
        ]
      ],
    );
  }
}
