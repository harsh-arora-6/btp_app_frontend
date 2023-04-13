import 'dart:convert';
import 'package:btp_app_mac/constants.dart';
import 'package:http/http.dart' as http;
import 'extract_json_to_model.dart';

Future<dynamic> createComponent(dynamic component, String type) async {
  try {
    // print("creating substation child :- $childType");
    var body = component.toJson();
    // print(jsonEncode(body));
    // print('hello');
    http.Response response = await http.post(
        Uri.parse('$baseUrl/${type}s/create$type'),
        body: jsonEncode(body),
        headers: {'Content-Type': 'application/json'});
    // print(response.body);
    var resp = jsonDecode(response.body);
    if (resp['message'] == 'Task Successful') {
      dynamic data = resp['data'];
      dynamic componentCreated = extractData(data, type);
      print('created $type');
      return componentCreated;
    } else {
      throw Exception(resp['message']);
    }
  } catch (error) {
    throw Exception(error);
  }
}

Future<dynamic> updateComponent(dynamic component, String type) async {
  try {
    // print("creating substation child :- $childType");
    var body = component.toJson();
    // print(jsonEncode(body));
    // print('hello');
    http.Response response = await http.patch(
        Uri.parse('$baseUrl/${type}s/$type/${component.id}'),
        body: jsonEncode(body),
        headers: {'Content-Type': 'application/json'});
    // print(response.body);
    var resp = jsonDecode(response.body);
    if (resp['message'] == 'Task Successful') {
      var data = resp['data'];
      dynamic updatedComponent = extractData(data, type);
      print('updated $type');
      return updatedComponent;
    } else {
      throw Exception(resp['message']);
    }
  } catch (error) {
    throw Exception(error);
  }
}

Future<dynamic> getComponent(String id, String type) async {
  try {
    http.Response response =
        await http.get(Uri.parse('$baseUrl/${type}s/$type/$id'));
    // print(response.body);
    var resp = jsonDecode(response.body);
    if (resp['message'] == 'Task Successful') {
      var data = resp['data'];
      dynamic component = extractData(data, type);
      print('got $type');
      // print(data);
      return component;
    } else {
      throw Exception(resp['message']);
    }
  } catch (error) {
    throw Exception(error);
  }
}

Future<List<dynamic>> getAllComponent(String type) async {
  try {
    http.Response response = await http.get(Uri.parse('$baseUrl/${type}s/'));
    // print(response.body);
    var resp = jsonDecode(response.body);
    if (resp['message'] == 'Task Successful') {
      var data = resp['data'];
      List<dynamic> components =
          List<dynamic>.from(data.map((d) => extractData(d, type)).toList());
      print('got ${type}s');
      return components;
    } else {
      throw Exception(resp['message']);
    }
  } catch (error) {
    throw Exception(error);
  }
}

Future<void> deleteComponent(String id, String type) async {
  try {
    http.Response response =
        await http.delete(Uri.parse('$baseUrl/${type}s/$type/$id'));
    // print(response.body);
    var resp = jsonDecode(response.body);
    if (resp['message'] == 'Task Successful') {
      print('deleted $type');
    } else {
      throw Exception(resp['message']);
    }
  } catch (error) {
    throw Exception(error);
  }
}
