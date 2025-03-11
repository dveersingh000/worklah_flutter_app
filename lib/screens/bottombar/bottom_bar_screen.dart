// ignore_for_file: prefer_const_constructors, library_private_types_in_public_api, prefer_final_fields, prefer_const_literals_to_create_immutables, depend_on_referenced_packages, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:work_lah/screens/bottombar/e_wallet/e_wallet_screen.dart';
import 'package:work_lah/screens/bottombar/home/home_screen.dart';
import 'package:work_lah/screens/bottombar/manage_job/manage_job_screen.dart';
import 'package:work_lah/screens/bottombar/profile/profile_screen.dart';
import 'package:work_lah/screens/model/user_model.dart';
import 'package:work_lah/utility/colors.dart';
import 'package:work_lah/utility/shared_prefs.dart';
import 'package:work_lah/utility/style_inter.dart';
// import 'package:work_lah/screens/bottombar/home/qr_scanner/scan_qr_screen.dart';
import 'package:work_lah/screens/bottombar/home/qr_scanner/qr_screen.dart';

class BottomBarScreen extends StatefulWidget {
  final int index;
  final Widget? child; // ✅ Allows embedding a custom page inside

  const BottomBarScreen({super.key, required this.index, this.child});

  @override
  _BottomBarScreenState createState() => _BottomBarScreenState();
}

class _BottomBarScreenState extends State<BottomBarScreen> {
  int _page = 0;
  UserModel? userModel;

  @override
  void initState() {
    super.initState();
    getUserLocalData();
    setState(() {
      _page = widget.index;
    });
  }

  Future<void> getUserLocalData() async {
    UserModel? fetchedUser = await getUserData();
    setState(() {
      userModel = fetchedUser;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_page != 0) {
          setState(() {
            _page = 0; // ✅ Resets to Home Tab if not already on it
          });
          return false; // ✅ Prevents accidental exit
        }
        
        final shouldPop = await showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              backgroundColor: AppColors.whiteColor,
              surfaceTintColor: AppColors.whiteColor,
              title: Text(
                "Do you want to exit?",
                style: CustomTextInter.medium20(AppColors.blackColor),
              ),
              actionsAlignment: MainAxisAlignment.spaceBetween,
              actions: [
                TextButton(
                  style: ButtonStyle(
                    overlayColor: MaterialStatePropertyAll(
                      AppColors.themeColor.withOpacity(0.1),
                    ),
                  ),
                  child: Text(
                    "Yes",
                    style: CustomTextInter.medium17(AppColors.themeColor),
                  ),
                  onPressed: () {
                    SystemNavigator.pop(); // ✅ Exits the app
                  },
                ),
                TextButton(
                  style: ButtonStyle(
                    overlayColor: MaterialStatePropertyAll(
                      AppColors.themeColor.withOpacity(0.1),
                    ),
                  ),
                  child: Text(
                    "No",
                    style: CustomTextInter.medium17(AppColors.themeColor),
                  ),
                  onPressed: () {
                    Navigator.pop(context, false); // ✅ Dismisses dialog
                  },
                ),
              ],
            );
          },
        );

        return shouldPop ?? false; // ✅ Prevents app from closing accidentally
      },

      child: Scaffold(
        bottomNavigationBar: _buildBottomNavBar(),
        body: widget.child ?? _getBody(), // ✅ If child is provided, display it; otherwise, show default pages
      ),
    );
  }

  /// ✅ Handles bottom navigation pages
  Widget _getBody() {
    if (userModel == null) {
    return Center(child: CircularProgressIndicator(color: AppColors.themeColor)); 
  }

    switch (_page) {
      case 0:
        return HomeScreen();
      case 1:
        return ManageJobScreen();
      case 2:
        return ShiftSelectionScreen();
      case 3:
        return EWalletScreen();
      case 4:
        return ProfileScreen(profileCompleted: userModel?.profileCompleted ?? false);
      default:
        return Container();
    }
  }

  /// ✅ Builds Bottom Navigation Bar and Handles Page Switching
  Widget _buildBottomNavBar() {
  return Container(
    height: 65, // ✅ Increase the height to prevent text cutoff
    decoration: BoxDecoration(
      border: Border(top: BorderSide(color: Colors.grey.shade300, width: 1)), // Optional: Add a subtle top border
    ),
    child: BottomNavigationBar(
      iconSize: 25,
      backgroundColor: AppColors.whiteColor,
      selectedItemColor: AppColors.themeColor,
      unselectedItemColor: AppColors.blackColor,
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,

      selectedLabelStyle: TextStyle(fontSize: 12), // ✅ Reduce font size
      unselectedLabelStyle: TextStyle(fontSize: 11), // ✅ Reduce font size for unselected items

      currentIndex: (_page >= 0 && _page < 5) ? _page : 0,
      onTap: (value) {
        if (widget.child != null) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => BottomBarScreen(index: value)),
          );
        } else {
          setState(() {
            _page = value;
          });
        }
      },
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.menu_outlined), label: 'My Jobs'),
        BottomNavigationBarItem(
          icon: Icon(Icons.qr_code_scanner, color: AppColors.themeColor), 
          label: 'Clock In/Out', // ✅ Ensure label fits properly
        ),
        BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet_outlined), label: 'E-Wallet'),
        BottomNavigationBarItem(icon: Icon(Icons.account_circle_outlined), label: 'Profile'),
      ],
    ),
  );
}

}
