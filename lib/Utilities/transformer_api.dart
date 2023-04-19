import 'package:btp_app_mac/Models/substation_model.dart';
import 'package:btp_app_mac/Utilities/cache.dart';
import '../Models/substation_child_model.dart';
import 'api_calls.dart';

Future<SubstationChildModel> createTransformer(
    SubstationChildModel substationChild) async {
  try {
    SubstationChildModel newSubstationChild =
        await createComponent(substationChild, 'transformer');
    //get substation data from backend
    // SubstationModel substation =
    //     await getComponent(substationChild.parentSubstationId, 'substation');

    //get substation data from cache if its available in cache , else from backend
    SubstationModel substation = (await CacheService.getFromCache(
        'substation', substationChild.parentSubstationId)) as SubstationModel;

    // add transformer to parent substation.
    substation.trList.add(newSubstationChild);

    //update substation at backend
    // await updateComponent(substation, 'substation');

    //set up new transformer in cache.
    await CacheService.putMap(
        'transformer', newSubstationChild.id, newSubstationChild.toJson());
    //update substation cache
    await CacheService.putMap('substation', substation.id, substation.toJson());
    return newSubstationChild;
  } catch (error) {
    throw Exception(error);
  }
}
