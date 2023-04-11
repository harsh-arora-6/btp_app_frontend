import 'dart:convert';
import 'package:btp_app_mac/constants.dart';
import 'package:http/http.dart' as http;
import '../Models/substation_child_model.dart';

Future<List<SubstationChildModel>> getAllSubstationChildData(
    String child) async {
  http.Response response = await http.get(Uri.parse('$baseUrl/$child'));
  if (response.statusCode == 200) {
    var data = jsonDecode(response.body);
    List<SubstationChildModel> children = [];
    for (var d in data['data']) {
      print("d= $d");
      SubstationChildModel newSubstationChild =
          SubstationChildModel.fromJson(d);
      children.add(newSubstationChild);
      // print(newSubstation.name);
    }
    // print(substations);
    return children;
  }

  throw Exception("failed to load substation");
}

// Future<SubstationChildModel> createSubstation(SubstationChildModel substation) async {
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
//   SubstationChildModel SubstationChildModel = SubstationChildModel.fromJson(data);
//   return SubstationChildModel;
//
//   //catch(e){
//   //throw Exception(e);
// //  }
// }
