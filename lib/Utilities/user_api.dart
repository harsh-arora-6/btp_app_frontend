import 'package:flutter/foundation.dart';
import 'package:tuple/tuple.dart';
import '../Models/user_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../constants.dart';

Future<Tuple2<UserModel, String>> login(String email, String password) async {
  try {
    Map<String, dynamic> body = {"email": email, "password": password};
    http.Response response = await http.post(Uri.parse('$baseUrl/user/login'),
        body: jsonEncode(body), headers: {'Content-Type': 'application/json'});

    var resp = jsonDecode(response.body);

    if (resp['message'] == 'user logged in') {
      var data = resp['data'];
      UserModel user = UserModel.fromJson(data);
      if (kDebugMode) {
        print('login user');
      }
      return Tuple2(user, resp['message']);
    } else if (resp['message'] == 'please sign up' ||
        resp['message'] == 'wrong credentials') {
      return Tuple2(UserModel('', '', '', '', '', '', ''), resp['message']);
    } else {
      throw Exception(resp['message']);
    }
  } catch (error) {
    throw Exception(error);
  }
}

Future<void> logout() async {
  try {
    http.Response response = await http.get(Uri.parse('$baseUrl/user/logout'));
    var resp = jsonDecode(response.body);
    if (resp['message'] == 'user logged out successfully') {
    } else {
      throw Exception(resp['message']);
    }
  } catch (error) {
    throw Exception(error);
  }
}
