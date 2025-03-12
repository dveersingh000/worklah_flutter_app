import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import 'package:work_lah/screens/login_screen.dart';
import 'package:work_lah/screens/bottombar/bottom_bar_screen.dart';
import 'package:work_lah/data/send_request.dart';
import 'package:work_lah/utility/shared_prefs.dart';
import 'package:work_lah/utility/image_path.dart';
import 'package:work_lah/utility/colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthentication();
  }

  /// ✅ **Check Authentication & Token Expiration**
  Future<void> _checkAuthentication() async {
    await Future.delayed(Duration(seconds: 2)); // Simulating splash duration

    final token = await getLoginToken();
    final tokenExpiry = await getTokenExpiration();

    if (token != null && token.isNotEmpty && tokenExpiry != null) {
      DateTime expiryTime = DateTime.parse(tokenExpiry);
      DateTime now = DateTime.now();

      if (now.isBefore(expiryTime)) {
        // ✅ Token is valid (locally checked), navigate to HomeScreen
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => BottomBarScreen(index: 0)),
        );

        // 🔹 Silent API validation in the background
        _validateTokenWithAPI(token);
      } else {
        // ❌ Token expired, validate with API before forcing logout
        await _validateTokenWithAPI(token);
      }
    } else {
      // ❌ No token found, navigate to LoginScreen
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => LoginScreen()),
      );
    }
  }

  /// 🔹 **Background API call to validate token**
  Future<void> _validateTokenWithAPI(String token) async {
    try {
      var response = await ApiProvider().getRequest(apiUrl: '/api/auth/validate');

      if (response != null) {
        // ✅ Token is valid, update expiration timestamp
        int expiresIn = response['expiresIn'] ?? 7200; // Default: 2 hours
        await saveTokenExpiration(expiresIn);
      } else {
        throw Exception("Invalid token");
      }
    } catch (e) {
      print("🔴 Token expired or invalid: $e");

      // ❌ Token is invalid or expired → Remove token and navigate to login
      await removeLoginToken();
      await removeUserData();
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: Center(
        child: Image.asset(
          ImagePath.appLogo,
        ),
      ),
    );
  }
}
