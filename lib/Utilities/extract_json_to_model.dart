import 'package:btp_app_mac/Models/substation_model.dart';

import '../Models/line_model.dart';
import '../Models/substation_child_model.dart';

dynamic extractData(dynamic data, String type) {
  dynamic extractedData;
  if (type == 'substation') {
    extractedData = SubstationModel.fromJson(data);
  } else if (type == 'cable') {
    extractedData = CableModel.fromJson(data);
  } else {
    extractedData = SubstationChildModel.fromJson(data);
  }
  // print('extracted data');
  // print(extractedData);
  return extractedData;
}
