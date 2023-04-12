import 'substation_child_model.dart';
import 'package:btp_app_mac/Models/line_model.dart';

class SubstationModel {
  String id = "";

  Map<String, dynamic> properties = {};

  SubstationChildModel rmu = SubstationChildModel(
      "rmu_id", <String, dynamic>{}, "parent substation id");

  List<SubstationChildModel> trList = [];

  SubstationChildModel ltpanel = SubstationChildModel(
      "ltpanel_id", <String, dynamic>{}, "parent substation id");

  LocationPoint location = LocationPoint(0, 0);

  SubstationModel(this.id, this.properties, this.rmu, this.trList, this.ltpanel,
      this.location);

  factory SubstationModel.fromJson(Map<String, dynamic> json) {
    try {
      // print('substation.fromJson');
      // print(json['transformers'].runtimeType);
      List<SubstationChildModel> transformers = List<SubstationChildModel>.from(
          json['transformers']
              .map((p) => SubstationChildModel.fromJson(p))
              .toList());
      return SubstationModel(
          json['_id'] as String,
          json['properties'] ?? <String, dynamic>{},
          (json['rmu'] != null)
              ? SubstationChildModel.fromJson(
                  json['rmu'] as Map<String, dynamic>)
              : SubstationChildModel(
                  "rmu_id", <String, dynamic>{}, "parent substation id"),
          transformers,
          (json['lt_panel'] != null)
              ? SubstationChildModel.fromJson(
                  json['lt_panel'] as Map<String, dynamic>)
              : SubstationChildModel(
                  "ltpanel_id", <String, dynamic>{}, "parent substation id"),
          LocationPoint.fromJson(json['location']));
    } catch (error) {
      throw Exception(error);
    }
  }
  // at backend for rmu and ltpanel keys we only need rmu id and lt panel id
  Map toJson() => {
        "properties": properties,
        "rmu": rmu.id == 'rmu_id' ? null : rmu.id,
        "transformers": trList.map((tr) => tr.id).toList(),
        "ltpanel": ltpanel.id == 'ltpanel_id' ? null : ltpanel.id,
        "location": location.toJson()
      };
}
