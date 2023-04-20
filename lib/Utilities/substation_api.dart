import 'package:btp_app_mac/Models/substation_child_model.dart';
import 'package:btp_app_mac/Utilities/cache.dart';
import '../Models/substation_model.dart';

import 'api_calls.dart';

Future<dynamic> createSubstation(dynamic substation) async {
  try {
    SubstationModel newSubstation =
        await createComponent(substation, 'substation');
    //create rmu
    SubstationChildModel rmu = await createComponent(
        SubstationChildModel('id', <String, dynamic>{}, newSubstation.id),
        'rmu');
    //create ltpanel
    SubstationChildModel ltpanel = await createComponent(
        SubstationChildModel('id', <String, dynamic>{}, newSubstation.id),
        'ltpanel');

    newSubstation.rmu = rmu;
    newSubstation.ltpanel = ltpanel;
    newSubstation.trList = [];
    // dynamic updatedNewSubstation =
    //     await updateComponent(newSubstation, 'substation');

    //set up in cache
    await CacheService.putMap(
        'substation', newSubstation.id, newSubstation.toJson());
    await CacheService.putMap('rmu', rmu.id, rmu.toJson());
    await CacheService.putMap('ltpanel', ltpanel.id, ltpanel.toJson());
    //return updatedNewSubstation
    return newSubstation;
  } catch (error) {
    throw Exception(error);
  }
}
