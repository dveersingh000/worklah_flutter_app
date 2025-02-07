// ignore_for_file: avoid_print, depend_on_referenced_packages

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:work_lah/utility/shared_prefs.dart';

class ApiProvider {
  String baseUrl = 'https://worklah.onrender.com';
  // String baseUrl = 'http://localhost:3000';

  Future<dynamic> getRequest(
      {required apiUrl, data = const <String, String>{}}) async {
    String? loginToken = await getLoginToken();

    var res2 = await http.get(Uri.parse('$baseUrl$apiUrl'), headers: {
      'Accept': 'application/json',
      "accept": "application/json",
      "Authorization": "Bearear $loginToken"
    });
    print("URL ::: ${"$baseUrl$apiUrl"}");
    print('TOKEN :: $loginToken');
    print("RESPONCE :::  ${res2.body}");
    print("RESPONCE :::  ${res2.statusCode}");
    var res = jsonDecode(res2.body);
    if (res2.statusCode == 200) {
      return res;
    } else if (res2.statusCode == 401) {
      return Future.error(res);
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
      "Authorization": "Bearear $loginToken"
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
    } else if (res2.statusCode == 404) {
      return Future.error(res);
    } else if (res2.statusCode == 500) {
      return Future.error(res);
    } else {
      return Future.error('Network Problem');
    }
  }

  Future<dynamic> putRequest(
      {required apiUrl,
      Map<String, dynamic> data = const <String, String>{},
      int? id}) async {
    var res2 = await http
        .put(Uri.parse('$baseUrl$apiUrl'), body: jsonEncode(data), headers: {
      "content-type": "application/json",
      "accept": "application/json",
    });
    print("URL ::: ${"$baseUrl$apiUrl"}");
    print("REQUEST ::: ${"$data"}");
    print("RESPONCE :::  ${res2.body}");
    print("CODE :::  ${res2.statusCode}");
    var res = jsonDecode(res2.body) as Map<String, dynamic>;
    if (res2.statusCode == 200) {
      return res;
    } else if (res2.statusCode == 401) {
      return Future.error(res);
    } else if (res2.statusCode == 404) {
      return Future.error(res);
    } else if (res2.statusCode == 500) {
      return Future.error(res);
    } else {
      return Future.error('Network Problem');
    }
  }

  Future<dynamic> deleteRequest(
      {required apiUrl,
      Map<String, dynamic> data = const <String, String>{},
      int? id}) async {
    var res2 = await http
        .delete(Uri.parse('$baseUrl$apiUrl'), body: jsonEncode(data), headers: {
      "content-type": "application/json",
      "accept": "application/json",
    });
    print("URL ::: ${"$baseUrl$apiUrl"}");
    print("REQUEST ::: ${"$data"}");
    print("RESPONCE :::  ${res2.body}");
    print("CODE :::  ${res2.statusCode}");
    var res = jsonDecode(res2.body) as Map<String, dynamic>;
    if (res2.statusCode == 200) {
      return res;
    } else if (res2.statusCode == 401) {
      return Future.error(res);
    } else if (res2.statusCode == 404) {
      return Future.error(res);
    } else if (res2.statusCode == 500) {
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
    var res2 = await http.post(
      Uri.parse('$baseUrl$apiUrl'),
      body: jsonEncode(data),
      headers: {
        "content-type": "application/json",
        "accept": "application/json",
      },
    );

    print("URL ::: ${"$baseUrl$apiUrl"}");
    print("REQUEST ::: ${"$data"}");
    print("RESPONSE :::  ${res2.body}");
    print("CODE :::  ${res2.statusCode}");

    int statusCode = res2.statusCode;

    return statusCode;
  }
}
