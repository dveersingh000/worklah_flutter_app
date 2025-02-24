// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:work_lah/utility/colors.dart';
import 'package:work_lah/utility/display_function.dart';
import 'package:work_lah/utility/image_path.dart';
import 'package:work_lah/utility/style_inter.dart';
import 'package:work_lah/utility/syle_poppins.dart';
import 'package:work_lah/screens/bottombar/profile/cashout/CashOutHomeScreen.dart';

class AccountStatusAndId extends StatelessWidget {
  final String acStatus;
  final VoidCallback onEditProfile;

  const AccountStatusAndId({
    super.key,
    required this.acStatus,
    required this.onEditProfile,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: Row(
        children: [
          // **Account Status**
          Expanded(
            child: RichText(
              text: TextSpan(
                children: <TextSpan>[
                  TextSpan(
                    text: 'Account status: ',
                    style: CustomTextInter.medium12(AppColors.blackColor),
                  ),
                  TextSpan(
                    text: ' $acStatus',
                    style: CustomTextInter.semiBold12(AppColors.greenColor),
                  ),
                ],
              ),
            ),
          ),

          // **Edit Profile Button**
          GestureDetector(
          onTap: onEditProfile, // ✅ Calls the function passed from ProfileScreen
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Row(
              children: [
                Icon(Icons.edit, size: 16.sp, color: AppColors.blackColor),
                SizedBox(width: 5.w),
                Text(
                  'Edit Profile',
                  style: CustomTextInter.medium14(AppColors.blackColor),
                ),
              ],
            ),
          ),
        ),
      ],
      ),
    );
  }
}

class ProfileDetails extends StatelessWidget {
  final bool profileCompleted;
  final String profileIMG;
  final String userName;
  final String mobileNo;
  final String joinDate;
  const ProfileDetails({
    super.key,
    required this.profileCompleted,
    required this.profileIMG,
    required this.userName,
    required this.mobileNo,
    required this.joinDate,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          SizedBox(
            height: 110.h,
            width: 125.w,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned(
                  right: 0,
                  top: 0,
                  child: Image.asset(ImagePath.editIMG),
                ),
                DottedBorder(
                  borderType: BorderType.RRect,
                  radius: Radius.circular(50),
                  dashPattern: [4, 4],
                  borderPadding: EdgeInsets.all(-1),
                  color: AppColors.blackColor,
                  strokeWidth: 1,
                  child: profileCompleted
                      ? Image.network(
                          profileIMG,
                          fit: BoxFit.fill,
                          height: 95.h,
                          width: 95.w,
                        )
                      : Image.asset(
                          profileCompleted
                              ? ImagePath.profilePic1
                              : ImagePath.personIMG,
                          fit: BoxFit.contain,
                        ),
                ),
              ],
            ),
          ),
          if (profileCompleted) ...[
            Text(
              userName,
              style: CustomTextPopins.medium24(AppColors.blackColor),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.phone,
                  size: 20.sp,
                ),
                SizedBox(width: 5.w),
                Text(
                  mobileNo,
                  style: CustomTextPopins.regular12(AppColors.blackColor),
                ),
              ],
            ),
            Text(
              'Joined $joinDate',
              style: CustomTextPopins.regular12(AppColors.fieldHintColor),
            ),
          ]
        ],
      ),
    );
  }
}

class MyWalletWidget extends StatelessWidget {
  final bool profileCompleted;
  final String balance;
  const MyWalletWidget(
      {super.key, required this.profileCompleted, required this.balance});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: AppColors.blackColor,
      ),
      padding: EdgeInsets.only(
        left: 20.w,
        right: 20.w,
        top: 10.h,
        bottom: 10.h,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                Icons.account_balance_wallet_outlined,
                color: AppColors.fieldBorderColor,
              ),
              SizedBox(width: 5.w),
              Text(
                'Your e-Wallet amount',
                style: CustomTextInter.medium12(AppColors.fieldBorderColor),
              ),
            ],
          ),
          SizedBox(height: 5.h),
          Row(
            children: [
              Expanded(
                child: Text(
                  profileCompleted ? '\$$balance' : '\$0',
                  style: CustomTextInter.medium24(AppColors.whiteColor),
                ),
              ),
              // Container(
              //   height: 35.h,
              //   padding: EdgeInsets.only(left: 10.w, right: 10.w),
              //   decoration: BoxDecoration(
              //     borderRadius: BorderRadius.circular(50),
              //     color: profileCompleted
              //         ? AppColors.themeColor
              //         : AppColors.textGreyColor,
              //   ),
              //   child: Center(
              //     child: InkWell(
              //       onTap: profileCompleted
              //           ? () {
              //               Navigator.push(
              //                 context,
              //                 MaterialPageRoute(
              //                     builder: (context) => CashOutHomeScreen()),
              //               );
              //             }
              //           : null,
              //       child: Row(
              //         children: [
              //           Text(
              //             'Cash Out',
              //             style: CustomTextInter.medium12(AppColors.whiteColor),
              //           ),
              //           SizedBox(width: 5.w),
              //           Icon(
              //             Icons.arrow_outward,
              //             color: AppColors.whiteColor,
              //             size: 20.sp,
              //           ),
              //         ],
              //       ),
              //     ),
              //   ),
              // )
            ],
          ),
        ],
      ),
    );
  }
}

class TotalCompleteJobStatus extends StatelessWidget {
  const TotalCompleteJobStatus({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              flex: 4,
              child: commonColorWidget(AppColors.completedColor),
            ),
            SizedBox(width: 10.w),
            Expanded(
              flex: 2,
              child: commonColorWidget(AppColors.canceledColor),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: commonColorWidget(AppColors.noShowColor),
            ),
          ],
        ),
        SizedBox(height: commonHeight(context) * 0.01),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            commonStatusRow(AppColors.completedColor, '0', 'Completed Jobs'),
            commonStatusRow(AppColors.canceledColor, '0', 'Cancelled Jobs'),
            commonStatusRow(AppColors.noShowColor, '0', 'No Show'),
          ],
        ),
      ],
    );
  }

  Widget commonColorWidget(Color color) {
    return Container(
      height: 21.h,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: color,
      ),
    );
  }

  Widget commonStatusRow(Color color, String percent, String text) {
    return Padding(
      padding: EdgeInsets.only(left: 5.w, right: 5.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 5.h),
            child: Container(
              height: 11.h,
              width: 11.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color,
              ),
            ),
          ),
          SizedBox(width: 5.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                percent,
                style: CustomTextInter.semiBold12(AppColors.blackColor),
              ),
              Text(
                text,
                style: CustomTextInter.regular12(AppColors.blackColor),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class DemeritPoints extends StatelessWidget {
  final String demeritAmount;
  const DemeritPoints({super.key, required this.demeritAmount});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 15.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
            color: AppColors.demoriteColor, // Light pink background
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Demerit Amount:',
                style:
                    CustomTextInter.medium14(AppColors.redColor), // Red title
              ),
              Text(
                '- \$${demeritAmount}', // Bold and red amount
                style: CustomTextInter.bold16(AppColors.redColor),
              ),
            ],
          ),
        ),
        SizedBox(height: 5.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: Text(
            'Demerit amount auto-deducts on Dec 1, 2025.',
            style: CustomTextInter.regular12(AppColors.subTitColor),
          ),
        ),
      ],
    );
  }
}

class ViewMyJobsButton extends StatelessWidget {
  const ViewMyJobsButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {
            // ✅ Navigate to "My Jobs" Screen
            // Navigator.pushNamed(context, '/my-jobs');
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.lightBorderColor, // Light background
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.r),
            ),
            padding: EdgeInsets.symmetric(vertical: 20.h),
            elevation: 0, // No shadow
          ),
          child: Text(
            'View My Jobs',
            style: CustomTextInter.medium16(AppColors.blackColor),
          ),
        ),
      ),
    );
  }
}



// class RecentPastJobWiget extends StatelessWidget {
//   final List recentJobList;
//   const RecentPastJobWiget({super.key, required this.recentJobList});

//   @override
//   Widget build(BuildContext context) {
//     return ListView.builder(
//       padding: EdgeInsets.zero,
//       shrinkWrap: true,
//       itemCount: recentJobList.length,
//       itemBuilder: (context, index) {
//         final item = recentJobList[index];
//         return Container(
//           padding:
//               EdgeInsets.only(left: 10.h, right: 10.w, top: 20.h, bottom: 20.h),
//           decoration: BoxDecoration(
//             color: AppColors.whiteColor,
//             borderRadius: BorderRadius.circular(10),
//             border: Border.all(color: AppColors.lightBorderColor),
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 children: [
//                   Image.asset(ImagePath.jobLogoIMG),
//                   SizedBox(width: 10.w),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(
//                           children: [
//                             Image.asset(ImagePath.dishIMG),
//                             SizedBox(width: 5.w),
//                             Text(
//                               item['jobName'].toString(),
//                               style: CustomTextInter.semiBold16(
//                                   AppColors.blackColor),
//                             ),
//                           ],
//                         ),
//                         Text(
//                           item['subtitle'].toString(),
//                           style:
//                               CustomTextInter.regular12(AppColors.subTitColor),
//                         ),
//                       ],
//                     ),
//                   ),
//                   Icon(Icons.share),
//                 ],
//               ),
//               SizedBox(height: 10.h),
//               RichText(
//                 text: TextSpan(
//                   children: <TextSpan>[
//                     TextSpan(
//                       text: '${item['duration']} - ',
//                       style: CustomTextInter.light14(
//                         AppColors.greenColor,
//                       ),
//                     ),
//                     TextSpan(
//                       text: item['status'].toString(),
//                       style: CustomTextInter.regular14(
//                         AppColors.greenColor,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               SizedBox(height: 5.h),
//               Row(
//                 children: [
//                   Expanded(
//                     child: Text(
//                       DateFormat('MMMM yyyy')
//                           .format(DateTime.parse(item['date'].toString())),
//                       style: CustomTextInter.light14(
//                         AppColors.blackColor,
//                       ),
//                     ),
//                   ),
//                   Text(
//                     item['companyName'].toString(),
//                     style: CustomTextInter.light14(
//                       AppColors.themeColor,
//                       isUnderline: true,
//                     ),
//                   ),
//                 ],
//               )
//             ],
//           ),
//         );
//       },
//     );
//   }
// }


