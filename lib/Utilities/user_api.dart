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

Future<String> signup(
    String name, String email, String password, String confirmPassword) async {
  try {
    Map<String, dynamic> body = {
      "name": name,
      "email": email,
      "password": password,
      "confirmPassword": confirmPassword
    };
    http.Response response = await http.post(Uri.parse('$baseUrl/user/signup'),
        body: jsonEncode(body), headers: {'Content-Type': 'application/json'});

    var resp = jsonDecode(response.body);

    if (resp['message'] == 'User Signed up' ||
        resp['message'] == 'User Already Exists' ||
        resp['message'] == 'Invalid Credentials') {
      return resp['message'];
    } else {
      throw Exception(resp['message']);
    }
  } catch (error) {
    throw Exception(error);
  }
}

Future<String> forgetPassword(String email) async {
  try {
    Map<String, dynamic> body = {"email": email};
    http.Response response = await http.post(
        Uri.parse('$baseUrl/user/forgetpassword'),
        body: jsonEncode(body),
        headers: {'Content-Type': 'application/json'});

    var resp = jsonDecode(response.body);

    if (resp['message'] == 'OTP sent to the specified mail' ||
        resp['message'] == 'please sign up') {
      return resp['message'];
    } else {
      throw Exception(resp['message']);
    }
  } catch (error) {
    throw Exception(error);
  }
}

Future<String> resetPassword(
    String otp, String password, String confirmPassword) async {
  try {
    Map<String, dynamic> body = {
      "token": otp,
      "password": password,
      "confirmPassword": confirmPassword
    };
    http.Response response = await http.post(
        Uri.parse('$baseUrl/user/resetpassword'),
        body: jsonEncode(body),
        headers: {'Content-Type': 'application/json'});

    var resp = jsonDecode(response.body);

    if (resp['message'] == 'Password Changed Successfully' ||
        resp['message'] == 'OTP Incorrect') {
      return resp['message'];
    } else {
      throw Exception(resp['message']);
    }
  } catch (error) {
    throw Exception(error);
  }
}
