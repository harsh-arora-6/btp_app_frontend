import 'dart:convert';
import 'package:btp_app_mac/Models/substation_child_model.dart';
import 'package:btp_app_mac/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../Models/substation_model.dart';
import 'package:btp_app_mac/Utilities/substation_child_api.dart';

Future<List<SubstationModel>> getAllSubstationsData() async {
  http.Response response = await http.get(Uri.parse('$baseUrl/substations'));
  if (response.statusCode == 200) {
    var data = jsonDecode(response.body);
    List<SubstationModel> substations = [];
    for (var d in data['data']) {
      // print("d= $d");
      SubstationModel newSubstation = SubstationModel.fromJson(d);
      substations.add(newSubstation);
      // print(newSubstation.name);
    }
    // print(substations);
    return substations;
  }

  throw Exception("failed to load substation");
}

Future<SubstationModel> getSubstation(String substationId) async {
  try {
    http.Response response = await http
        .get(Uri.parse('$baseUrl/substations/substation/$substationId'));
    Map resp = jsonDecode(response.body);
    print('getSubstation');
    print(resp);
    if (resp['message'] == 'Task Successful') {
      var data = jsonDecode(response.body)['data'];
      SubstationModel substation = SubstationModel.fromJson(data);
      // print(substation);
      return substation;
    } else {
      throw Exception(resp['message']);
    }
  } catch (error) {
    throw Exception(error);
  }
  //catch(e){
  //throw Exception(e);
//  }
}

Future<SubstationModel> createSubstation(SubstationModel substation) async {
  try {
    // print("creating substation");
    Map body = substation.toJson();
    // print(jsonEncode(body));
    // print('json converted successfully');
    // print(body);
    http.Response response = await http.post(
        Uri.parse('$baseUrl/substations/createsubstation'),
        body: jsonEncode(body),
        headers: {'Content-Type': 'application/json'});
    // print(response.body);
    Map<String, dynamic> resp = jsonDecode(response.body);
    if (resp['message'] == "Task Successful") {
      var data = resp['data'];
      // print(data);
      SubstationModel newSubstation = SubstationModel.fromJson(data);
      //create rmu
      SubstationChildModel rmu = await createSubstationChild(
          SubstationChildModel('id', <String, dynamic>{}, newSubstation.id),
          'rmu');
      //create ltpanel
      SubstationChildModel ltpanel = await createSubstationChild(
          SubstationChildModel('id', <String, dynamic>{}, newSubstation.id),
          'ltpanel');
      newSubstation.rmu = rmu;
      newSubstation.ltpanel = ltpanel;
      newSubstation.trList = [];
      SubstationModel updatedNewSubstation =
          await updateSubstation(newSubstation);
      return updatedNewSubstation;
    } else {
      throw Exception(resp['message']);
    }
  } catch (error) {
    throw Exception(error);
  }
}

Future<SubstationModel> updateSubstation(SubstationModel substation) async {
  try {
    // print("updating substation");
    var body = substation.toJson();
    // print(jsonEncode(body));

    http.Response response = await http.patch(
        Uri.parse('$baseUrl/substations/substation/${substation.id}'),
        body: jsonEncode(body),
        headers: {'Content-Type': 'application/json'});
    // print(response.body);
    // print('updateSubstation');
    Map<String, dynamic> resp = jsonDecode(response.body);
    if (resp['message'] == "Task Successful") {
      var data = resp['data'];
      // print(data.runtimeType);
      // print(response.body);
      SubstationModel updatedSubstation = SubstationModel.fromJson(data);
      print('updateSubstation');
      // print(updatedSubstation);
      return updatedSubstation;
    } else {
      throw Exception(resp['message']);
    }
  } catch (error) {
    throw Exception(error);
  }
  //catch(e){
  //throw Exception(e);
//  }
}

Future<void> deleteSubstation(String substationId) async {
  try {
    http.Response response = await http
        .delete(Uri.parse('$baseUrl/substations/substation/$substationId'));
    Map resp = jsonDecode(response.body);
    print('deleteSubstation');
    print(resp);
    if (resp['message'] == 'Task Successful') {
    } else {
      if (kDebugMode) {
        print(resp['message']);
      }
    }
  } catch (error) {
    throw Exception(error);
  }
  //catch(e){
  //throw Exception(e);
//  }
}
