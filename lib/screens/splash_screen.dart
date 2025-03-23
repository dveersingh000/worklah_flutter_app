import 'package:flutter/material.dart';
import 'package:work_lah/screens/login_screen.dart';
import 'package:work_lah/screens/bottombar/bottom_bar_screen.dart';
import 'package:work_lah/data/send_request.dart';
import 'package:work_lah/utility/shared_prefs.dart';
import 'package:work_lah/utility/image_path.dart';
import 'package:work_lah/utility/colors.dart';
import 'package:work_lah/screens/welcome_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initialize();
  }

  /// ✅ **Initialize Splash Logic**
  Future<void> _initialize() async {
    await Future.delayed(
        Duration(milliseconds: 1500)); // Faster splash duration
    _checkAuthentication();
  }

  /// ✅ **Check Authentication & Token Expiration**
  Future<void> _checkAuthentication() async {
    final token = await getLoginToken();
    final tokenExpiry = await getTokenExpiration();

    if (token != null && token.isNotEmpty && tokenExpiry != null) {
      DateTime expiryTime = DateTime.parse(tokenExpiry);
      DateTime now = DateTime.now();

      if (now.isBefore(expiryTime)) {
        // ✅ Token is valid (local check), navigate to HomeScreen
        _navigateTo(BottomBarScreen(index: 0));

        // 🔹 Validate token in the background
        _validateTokenWithAPI(token);
      } else {
        // ❌ Token expired, validate with API before logout
        await _validateTokenWithAPI(token);
      }
    } else {
      // ❌ No token found, navigate to WelcomeScreen
      _navigateTo(WelcomeScreen());
    }
  }

  /// 🔹 **Background API call to validate token**
  Future<void> _validateTokenWithAPI(String token) async {
    try {
      var response =
          await ApiProvider().getRequest(apiUrl: '/api/auth/validate');

      if (response != null) {
        // ✅ Token is valid, update expiration timestamp
        int expiresIn = response['expiresIn'] ?? 7200; // Default: 2 hours
        await saveTokenExpiration(expiresIn);
      } else {
        throw Exception("Invalid token");
      }
    } catch (e) {
      print("🔴 Token expired or invalid: $e");

      // ❌ Token is invalid → Remove token and navigate to login
      await removeLoginToken();
      await removeUserData();
      _navigateTo(WelcomeScreen());
    }
  }

  /// ✅ **Helper function to navigate**
  void _navigateTo(Widget page) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => page),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: Center(
        child: Image.asset(
          ImagePath.appLogo,
          height: 120, // Adjusted size for consistency
        ),
      ),
    );
  }
}
