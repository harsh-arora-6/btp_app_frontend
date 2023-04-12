import 'dart:convert';
import 'package:btp_app_mac/constants.dart';
import 'package:http/http.dart' as http;
import '../Models/substation_child_model.dart';

Future<SubstationChildModel> createSubstationChild(
    SubstationChildModel substationChild, String childType) async {
  try {
    // print("creating substation child :- $childType");
    var body = substationChild.toJson();
    // print(jsonEncode(body));
    // print('hello');
    http.Response response = await http.post(
        Uri.parse('$baseUrl/${childType}s/create$childType'),
        body: jsonEncode(body),
        headers: {'Content-Type': 'application/json'});
    // print(response.body);
    var resp = jsonDecode(response.body);
    if (resp['message'] == 'Task Successful') {
      var data = resp['data'];
      SubstationChildModel newSubstationChild =
          SubstationChildModel.fromJson(data);
      print('created $childType');
      return newSubstationChild;
    } else {
      throw Exception(resp['message']);
    }
  } catch (error) {
    throw Exception(error);
  }
}

Future<SubstationChildModel> updateSubstationChild(
    SubstationChildModel substationChild, String childType) async {
  try {
    // print("creating substation child :- $childType");
    var body = substationChild.toJson();
    // print(jsonEncode(body));

    http.Response response = await http.patch(
        Uri.parse('$baseUrl/${childType}s/$childType/${substationChild.id}'),
        body: jsonEncode(body),
        headers: {'Content-Type': 'application/json'});
    // print(response.body);
    var data = jsonDecode(response.body)['data'];
    SubstationChildModel updatedSubstationChild =
        SubstationChildModel.fromJson(data);
    return updatedSubstationChild;
  } catch (error) {
    throw Exception(error);
  }
}

// Future<SubstationChildModel> getSubstationChild(
//     SubstationChildModel substationChild, String childType) async {
//   try {
//     http.Response response = await http
//         .get(Uri.parse('$baseUrl/${childType}s/$childType/${substationChild.id}'));
//     // print(response.body);
//     var data = jsonDecode(response.body)['data'];
//     SubstationChildModel substationChild = SubstationChildModel.fromJson(data);
//     return substationChild;
//   } catch (error) {
//     throw Exception(error);
//   }
// }

// for getting transformers from substation id
Future<List<SubstationChildModel>> getAllSubstationChild(
    String substationId, String childType) async {
  try {
    http.Response response =
        await http.get(Uri.parse('$baseUrl/${childType}s/$substationId'));
    // print(response.body);
    var data = jsonDecode(response.body)['data'];
    List<SubstationChildModel> substationChildren =
        data.map((dataValue) => SubstationChildModel.fromJson(dataValue));

    return substationChildren;
  } catch (error) {
    throw Exception(error);
  }
}

// for getting rmu and ltpanel from substation id
Future<SubstationChildModel> getSubstationChildBasedOnSubstationId(
    String substationId, String childType) async {
  try {
    http.Response response =
        await http.get(Uri.parse('$baseUrl/${childType}s/$substationId'));
    // print(response.body);
    var data = jsonDecode(response.body)['data'];
    SubstationChildModel substationChildren =
        SubstationChildModel.fromJson(data);

    return substationChildren;
  } catch (error) {
    throw Exception(error);
  }
}
