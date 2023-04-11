import 'dart:convert';
import 'package:btp_app_mac/Models/substation_child_model.dart';
import 'package:btp_app_mac/constants.dart';
import 'package:http/http.dart' as http;
import '../Models/substation_model.dart';
import 'package:btp_app_mac/Utilities/substation_child_api.dart';

Future<List<SubstationModel>> getSubstationData() async {
  http.Response response = await http.get(Uri.parse('$baseUrl/substations'));
  if (response.statusCode == 200) {
    var data = jsonDecode(response.body);
    List<SubstationModel> substations = [];
    for (var d in data['data']) {
      print("d= $d");
      SubstationModel newSubstation = SubstationModel.fromJson(d);
      substations.add(newSubstation);
      // print(newSubstation.name);
    }
    // print(substations);
    return substations;
  }

  throw Exception("failed to load substation");
}

Future<SubstationModel> createSubstation(SubstationModel substation) async {
  try {
    print("creating substation");
    var body = substation.toJson();
    // print(jsonEncode(body));

    http.Response response = await http.post(
        Uri.parse('$baseUrl/substations/createsubstation'),
        body: jsonEncode(body),
        headers: {'Content-Type': 'application/json'});
    // print(response.body);
    var data = jsonDecode(response.body)['data'];
    SubstationModel newSubstation = SubstationModel.fromJson(data);
    //create rmu
    SubstationChildModel rmu = await createSubstationChild(
        SubstationChildModel('id', <String, dynamic>{}, newSubstation.id),
        'rmu');
    SubstationChildModel ltpanel = await createSubstationChild(
        SubstationChildModel('id', <String, dynamic>{}, newSubstation.id),
        'ltpanel');
    SubstationModel updatedNewSubstation =
        await updateSubstation(newSubstation);
    return updatedNewSubstation;
  } catch (error) {
    throw Exception(error);
  }
}

Future<SubstationModel> updateSubstation(SubstationModel substation) async {
  try {
    print("updating substation");
    var body = substation.toJson();
    // print(jsonEncode(body));

    http.Response response = await http.patch(
        Uri.parse('$baseUrl/substations/substation/${substation.id}'),
        body: jsonEncode(body),
        headers: {'Content-Type': 'application/json'});
    // print(response.body);
    var data = jsonDecode(response.body)['data'];
    SubstationModel updatedSubstation = SubstationModel.fromJson(data);
    return updatedSubstation;
  } catch (error) {
    throw Exception(error);
  }
  //catch(e){
  //throw Exception(e);
//  }
}
