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
    final cacheService = CacheService();
    await cacheService.init();
    await cacheService.openBox('substation');
    //set up in cache
    await cacheService.putMap(
        'substation', newSubstation.id, newSubstation.toJson());
    await cacheService.closeBox('substation');

    await cacheService.openBox('rmu');
    await cacheService.putMap('rmu', rmu.id, rmu.toJson());
    await cacheService.closeBox('rmu');

    await cacheService.openBox('ltpanel');
    await cacheService.putMap('ltpanel', ltpanel.id, ltpanel.toJson());
    await cacheService.closeBox('ltpanel');
    //return updatedNewSubstation
    return newSubstation;
  } catch (error) {
    throw Exception(error);
  }
}
