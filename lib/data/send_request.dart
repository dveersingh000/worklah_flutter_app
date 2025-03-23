// ignore_for_file: avoid_print, depend_on_referenced_packages

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:work_lah/utility/shared_prefs.dart';
import 'package:work_lah/screens/login_screen.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:work_lah/main.dart';

class ApiProvider {
  String baseUrl = 'https://worklah.onrender.com';
  // String baseUrl = 'http://localhost:3000';

  Future<dynamic> getRequest(
      {required apiUrl, data = const <String, String>{}}) async {
    String? loginToken = await getLoginToken();

     if (loginToken == null || loginToken.isEmpty) {
    await handleUnauthorized();
    return Future.error('Unauthorized access. Please login.');
  }

    var res2 = await http.get(Uri.parse('$baseUrl$apiUrl'), headers: {
      'Accept': 'application/json',
      "accept": "application/json",
      "Authorization": "Bearer $loginToken"
    });
    print("URL ::: ${"$baseUrl$apiUrl"}");
    print('TOKEN :: $loginToken');
    print("RESPONCE :::  ${res2.body}");
    print("RESPONCE :::  ${res2.statusCode}");
    var res = jsonDecode(res2.body);
    if (res2.statusCode == 200) {
      return res;
    } else if (res2.statusCode == 401) {
      // 🔥 Unauthorized - Redirect to Login
      await handleUnauthorized();
      return Future.error('Session expired. Please login again.');
    } else if (res2.statusCode == 404) {
      return Future.error(res);
    } else if (res2.statusCode == 500) {
      return Future.error(res);
    } else {
      return Future.error('Network Problem');
    }
  }

  Future<dynamic> postRequest(
      {required apiUrl,
      Map<String, dynamic> data = const <String, String>{},
      int? id}) async {
    String? loginToken = await getLoginToken();

    var res2 = await http
        .post(Uri.parse('$baseUrl$apiUrl'), body: jsonEncode(data), headers: {
      "content-type": "application/json",
      "accept": "application/json",
      "Authorization": "Bearer $loginToken"
    });
    print("URL ::: ${"$baseUrl$apiUrl"}");
    print("REQUEST ::: ${"$data"}");
    print("RESPONCE :::  ${res2.body}");
    print("CODE :::  ${res2.statusCode}");
    var res = jsonDecode(res2.body) as Map<String, dynamic>;
    if (res2.statusCode == 200) {
      return res;
    } else if (res2.statusCode == 400) {
      return Future.error(res);
    } else if (res2.statusCode == 401) {
      // 🔥 Unauthorized - Redirect to Login
      await handleUnauthorized();
      return Future.error('Session expired. Please login again.');
    } else if (res2.statusCode == 404) {
      return Future.error(res);
    } else if (res2.statusCode == 500) {
      return Future.error(res);
    } else {
      return Future.error('Network Problem');
    }
  }

Future<dynamic> putRequest({
  required String apiUrl,
  Map<String, dynamic> data = const <String, String>{},
  int? id,
}) async {
  String? loginToken = await getLoginToken();

  if (loginToken == null || loginToken.isEmpty) {
    await handleUnauthorized();
    return Future.error('Unauthorized access. Please login.');
  }

  var res2 = await http.put(
    Uri.parse('$baseUrl$apiUrl'),
    body: jsonEncode(data),
    headers: {
      "content-type": "application/json",
      "accept": "application/json",
      "Authorization": "Bearer $loginToken", // ✅ FIXED: Add token
    },
  );

  print("URL ::: ${"$baseUrl$apiUrl"}");
  print("REQUEST ::: ${"$data"}");
  print("RESPONCE :::  ${res2.body}");
  print("CODE :::  ${res2.statusCode}");

  var res = jsonDecode(res2.body) as Map<String, dynamic>;

  if (res2.statusCode == 200) {
    return res;
  } else if (res2.statusCode == 401) {
    await handleUnauthorized();
    return Future.error('Session expired. Please login again.');
  } else if (res2.statusCode == 400 || res2.statusCode == 404 || res2.statusCode == 500) {
    return Future.error(res);
  } else {
    return Future.error('Network Problem');
  }
}


  Future<dynamic> deleteRequest({
  required apiUrl,
  Map<String, dynamic> data = const <String, String>{},
  int? id,
}) async {
  String? loginToken = await getLoginToken();

  if (loginToken == null || loginToken.isEmpty) {
    await handleUnauthorized();
    return Future.error('Unauthorized access. Please login.');
  }

  var res2 = await http.delete(
    Uri.parse('$baseUrl$apiUrl'),
    body: jsonEncode(data),
    headers: {
      "content-type": "application/json",
      "accept": "application/json",
      "Authorization": "Bearer $loginToken",
    },
  );

  print("URL ::: ${"$baseUrl$apiUrl"}");
  print("REQUEST ::: ${"$data"}");
  print("RESPONCE :::  ${res2.body}");
  print("CODE :::  ${res2.statusCode}");

  var res = jsonDecode(res2.body) as Map<String, dynamic>;

  if (res2.statusCode == 200) {
    return res;
  } else if (res2.statusCode == 401) {
    await handleUnauthorized();
    return Future.error('Session expired. Please login again.');
  } else if (res2.statusCode == 404 || res2.statusCode == 400 || res2.statusCode == 500) {
    return Future.error(res);
  } else {
    return Future.error('Network Problem');
  }
}


Future<int> postRequestWithStatusCode({
  required String apiUrl,
  Map<String, dynamic> data = const <String, String>{},
  int? id,
}) async {
  String? loginToken = await getLoginToken();

  if (loginToken == null || loginToken.isEmpty) {
    await handleUnauthorized();
    return 401;
  }

  var res2 = await http.post(
    Uri.parse('$baseUrl$apiUrl'),
    body: jsonEncode(data),
    headers: {
      "content-type": "application/json",
      "accept": "application/json",
      "Authorization": "Bearer $loginToken",
    },
  );

  print("URL ::: ${"$baseUrl$apiUrl"}");
  print("REQUEST ::: ${"$data"}");
  print("RESPONSE :::  ${res2.body}");
  print("CODE :::  ${res2.statusCode}");

  return res2.statusCode;
}

  Future<Map<String, dynamic>> uploadFile({required String apiUrl, required File file, required String fieldName}) async {
    String? loginToken = await getLoginToken();

    var request = http.MultipartRequest('POST', Uri.parse('$baseUrl$apiUrl'));
    request.headers.addAll({
      "Authorization": "Bearer $loginToken",
      "Accept": "application/json",
    });

    // Attach the file
    request.files.add(await http.MultipartFile.fromPath(fieldName, file.path));

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    print("URL ::: ${"$baseUrl$apiUrl"}");
    print("UPLOAD RESPONSE :::  ${response.body}");
    print("CODE :::  ${response.statusCode}");

    var res = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return res;
    } else {
      return Future.error(res);
    }
  }
  /// ✅ Handles Unauthorized Access (401)
  Future<void> handleUnauthorized() async {
    print("🔴 Unauthorized: Redirecting to Login...");
    
    await removeLoginToken();
    await removeUserData();
    await removeTokenExpiration();

    if (navigatorKey.currentState?.mounted ?? false) {
      navigatorKey.currentState?.pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => LoginScreen()), 
        (route) => false
      );
    }
  }
}
