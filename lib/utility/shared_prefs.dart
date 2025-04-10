import 'dart:convert';
import 'dart:developer';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:work_lah/screens/model/user_model.dart';

Future<void> setLogin(String isFrom) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('isFrom', isFrom);
}

Future<String?> getLogin() async {
  try {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('isFrom');
  } catch (e) {
    return null;
  }
}

Future<void> removeLogin() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove('isFrom');
}

Future<void> setLoginToken(String loginToken) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('loginToken', loginToken);
}

Future<String?> getLoginToken() async {
  try {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('loginToken');
  } catch (e) {
    return null;
  }
}

Future<void> removeLoginToken() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove('loginToken');
}

Future<void> saveUserData(Map<String, dynamic> userJson) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String userData = jsonEncode(userJson);
  await prefs.setString('user', userData);

   // ✅ Ensure profile picture is updated correctly
  if (userJson.containsKey('profilePicture')) {
    await prefs.setString('profilePicture', userJson['profilePicture']);
    log("Profile picture saved in SharedPreferences: ${userJson['profilePicture']}");
  }
  
  // ✅ Store userId separately for quick access
  if (userJson.containsKey('_id')) {
    await prefs.setString('userId', userJson['_id']);
    // print('✅ userId saved separately: ${userJson['_id']}');
  }
}

Future<UserModel?> getUserData() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? userData = prefs.getString('user');
  if (userData != null) {
    Map<String, dynamic> userMap = jsonDecode(userData);
    return UserModel.fromJson(userMap);
  }
  return null;
}

Future<void> removeUserData() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove('user');
}

Future<void> saveTokenExpiration(int expiresIn) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  DateTime expiryTime = DateTime.now().add(Duration(seconds: expiresIn));
  await prefs.setString('tokenExpiry', expiryTime.toIso8601String());
}

Future<String?> getTokenExpiration() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('tokenExpiry');
}

Future<void> removeTokenExpiration() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove('tokenExpiry');
}

