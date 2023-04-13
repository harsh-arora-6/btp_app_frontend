import 'dart:convert';
import 'package:btp_app_mac/constants.dart';
import 'package:http/http.dart' as http;
import '../Models/substation_child_model.dart';

// for getting transformers from substation id
Future<List<SubstationChildModel>> getAllSubstationChild(
    String substationId, String childType) async {
  try {
    http.Response response =
        await http.get(Uri.parse('$baseUrl/${childType}s/$substationId'));
    Map resp = jsonDecode(response.body);
    print('getAllSubstationChild');
    // print(resp);
    if (resp['message'] == 'Task Successful') {
      var data = jsonDecode(response.body)['data'];
      List<SubstationChildModel> substationChildren =
          List<SubstationChildModel>.from(data
              .map((dataValue) => SubstationChildModel.fromJson(dataValue))
              .toList());
      return substationChildren;
    } else {
      throw Exception(resp['message']);
    }
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
    Map resp = jsonDecode(response.body);
    print('getSubstationChildBasedOnSubstationId');
    // print(resp);
    if (resp['message'] == 'Task Successful') {
      var data = resp['data'];
      SubstationChildModel substationChild =
          SubstationChildModel.fromJson(data);

      return substationChild;
    } else {
      throw Exception(resp['message']);
    }
  } catch (error) {
    throw Exception(error);
  }
}
