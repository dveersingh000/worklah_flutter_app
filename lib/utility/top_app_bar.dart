import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:work_lah/screens/login_screen.dart';
import 'package:work_lah/screens/notification_screen.dart';
import 'package:work_lah/utility/colors.dart';
import 'package:work_lah/utility/shared_prefs.dart';
import 'package:work_lah/utility/style_inter.dart';

class TopAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final bool isLeading;
  const TopAppBar({super.key, required this.title, this.isLeading = false});

  @override
  _TopAppBarState createState() => _TopAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(60.h);
}

class _TopAppBarState extends State<TopAppBar> {
  final GlobalKey _menuKey = GlobalKey();
  OverlayEntry? _overlayEntry;

  void _toggleMenu() {
    if (_overlayEntry == null) {
      _overlayEntry = _createOverlayEntry();
      Overlay.of(context).insert(_overlayEntry!);
    } else {
      _overlayEntry!.remove();
      _overlayEntry = null;
    }
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = _menuKey.currentContext!.findRenderObject() as RenderBox;
    var offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
      builder: (context) => Stack(
        children: [
          // Tap outside to close menu
          Positioned.fill(
            child: GestureDetector(
              onTap: _toggleMenu,
              behavior: HitTestBehavior.translucent,
            ),
          ),

          // Dropdown Menu
          Positioned(
            top: offset.dy + renderBox.size.height,
            right: 10.w,
            child: Material(
              elevation: 4,
              borderRadius: BorderRadius.circular(10.r),
              color: Colors.white,
              child: Container(
                width: 150.w,
                padding: EdgeInsets.symmetric(vertical: 5.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(Icons.logout, color: AppColors.blackColor),
                      title: Text(
                        'Logout',
                        style: CustomTextInter.medium14(AppColors.blackColor),
                      ),
                      onTap: () {
                        _toggleMenu();
                        _handleLogout();
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

  Future<void> _handleLogout() async {
    await removeLogin().then((value) async {
      await removeLoginToken().then((value) async {
        await removeUserData().then((value) {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.whiteColor,
      surfaceTintColor: AppColors.whiteColor,
      automaticallyImplyLeading: false,
      elevation: 0,
      title: Text(
        widget.title,
        style: CustomTextInter.medium20(AppColors.blackColor),
      ),
      leading: widget.isLeading
          ? IconButton(
              icon: Icon(Icons.arrow_back, color: AppColors.blackColor),
              onPressed: () => Navigator.pop(context),
            )
          : null,
      actions: [
        GestureDetector(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => NotificationScreen()));
          },
          child: Icon(Icons.notifications_outlined, color: AppColors.themeColor),
        ),
        SizedBox(width: 10.w),
        GestureDetector(
          key: _menuKey,
          onTap: _toggleMenu,
          child: Icon(Icons.menu_outlined, color: AppColors.blackColor),
        ),
        SizedBox(width: 10.w),
      ],
    );
  }
}
