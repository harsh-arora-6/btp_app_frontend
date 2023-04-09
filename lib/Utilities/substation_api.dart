import 'dart:convert';
import 'package:btp_app_mac/constants.dart';
import 'package:http/http.dart' as http;
import '../Models/substation_model.dart';

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

// Future<SubstationModel> createSubstation(SubstationModel substation) async {
//   print("creating substation");
//   var body = substation.toJson();
//   print(jsonEncode(body));
//
//   http.Response response = await http.post(
//       Uri.parse('$baseUrl/substations/createsubstation'),
//       body: jsonEncode(body),
//       headers: {'Content-Type': 'application/json'});
//   print(response.body);
//   var data = jsonDecode(response.body)['data'];
//   SubstationModel substationModel = SubstationModel.fromJson(data);
//   return substationModel;
//
//   //catch(e){
//   //throw Exception(e);
// //  }
// }
