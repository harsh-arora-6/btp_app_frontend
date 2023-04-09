import 'dart:convert';
import 'package:btp_app_mac/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:btp_app_mac/Models/line_model.dart';

Future<List<CableModel>> getAllCables() async {
  http.Response response = await http.get(Uri.parse('$baseUrl/cables/'));

  if (response.statusCode == 200) {
    var data = jsonDecode(response.body);
    List<CableModel> cables = [];
    for (var cableData in data['data']) {
      cables.add(CableModel.fromJson(cableData));
    }
    return cables;
  }

  throw Exception("failed to load cables");
}
//
// void createCable(CableModel cable) async {
//   print("creating cable");
//   var body = cable.toJson();
//   print(jsonEncode(body));
//
//   try {
//     http.Response response = await http.post(
//         Uri.parse('$baseUrl/cables/createcable'),
//         body: jsonEncode(body),
//         headers: {'Content-Type': 'application/json'});
//     print(response.body);
//   } catch (e) {
//     print(e);
//   }
// }
//
// void updateCable(CableModel cable) async {
//   print("creating cable");
//   var body = cable.toJson();
//   print(jsonEncode(body));
//
//   try {
//     http.Response response = await http.patch(
//         Uri.parse('$baseUrl/cables/cable/${cable.id}/'),
//         body: jsonEncode(body),
//         headers: {'Content-Type': 'application/json'});
//     print(response.body);
//   } catch (e) {
//     print(e);
//   }
// }
