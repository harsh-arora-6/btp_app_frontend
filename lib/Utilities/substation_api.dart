import 'package:btp_app_mac/Models/substation_child_model.dart';
import '../Models/substation_model.dart';

import 'api_calls.dart';

Future<dynamic> createSubstation(dynamic substation) async {
  try {
    SubstationModel newSubstation =
        await createComponent(substation, 'substation');
    //create rmu
    SubstationChildModel rmu = await createComponent(
        SubstationChildModel(
            'id', <String, dynamic>{}, newSubstation.id as String),
        'rmu');
    //create ltpanel
    SubstationChildModel ltpanel = await createComponent(
        SubstationChildModel(
            'id', <String, dynamic>{}, newSubstation.id as String),
        'ltpanel');

    newSubstation.rmu = rmu;
    newSubstation.ltpanel = ltpanel;
    newSubstation.trList = [];
    dynamic updatedNewSubstation =
        await updateComponent(newSubstation, 'substation');
    return updatedNewSubstation;
  } catch (error) {
    throw Exception(error);
  }
}
