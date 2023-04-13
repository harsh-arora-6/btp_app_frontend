import 'package:btp_app_mac/Models/substation_model.dart';
import '../Models/substation_child_model.dart';
import 'api_calls.dart';

Future<SubstationChildModel> createTransformer(
    SubstationChildModel substationChild) async {
  try {
    SubstationChildModel newSubstationChild =
        await createComponent(substationChild, 'transformer');
    SubstationModel substation =
        await getComponent(substationChild.parentSubstationId, 'substation');
    // add transformer to parent substation.
    substation.trList.add(newSubstationChild);

    await updateComponent(substation, 'substation');
    return newSubstationChild;
  } catch (error) {
    throw Exception(error);
  }
}
