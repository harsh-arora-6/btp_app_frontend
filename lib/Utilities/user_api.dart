import 'package:flutter/material.dart';

import '../Models/user_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../constants.dart';

Future<UserModel> Login(String email, String password) async {
  try {
    // print("creating substation child :- $childType");
    // print('hello');
    Map<String, dynamic> body = {"email": email, "password": password};
    // print(jsonEncode(body));
    // print('hello');
    http.Response response = await http.post(Uri.parse('$baseUrl/user/login'),
        body: jsonEncode(body), headers: {'Content-Type': 'application/json'});
    // print(response.body);
    var resp = jsonDecode(response.body);
    // print(response.statusCode);
    if (resp['message'] == 'user logged in') {
      var data = resp['data'];
      UserModel user = UserModel.fromJson(data);
      print('login user');
      return user;
    } else if (resp['message'] == 'user not found') {
      return UserModel('', '', '', '', '', '', '');
    } else {
      throw Exception(resp['message']);
    }
  } catch (error) {
    throw Exception(error);
  }
}
