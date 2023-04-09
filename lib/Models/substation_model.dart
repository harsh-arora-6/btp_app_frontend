import 'substation_child_model.dart';
import 'package:btp_app_mac/Models/TransformerModel.dart';
import 'package:btp_app_mac/Models/line_model.dart';

class SubstationModel {
  String id = "";

  Map<String, dynamic> properties;

  SubstationChildModel rmu = SubstationChildModel(
      "rmu_id", <String, dynamic>{}, "parent substation id");

  List<SubstationChildModel> trList = [];

  SubstationChildModel ltpanel = SubstationChildModel(
      "ltpanel_id", <String, dynamic>{}, "parent substation id");

  LocationPoint location = LocationPoint(0, 0);

  SubstationModel(this.id, this.properties, this.rmu, this.trList, this.ltpanel,
      this.location);

  factory SubstationModel.fromJson(Map<String, dynamic> json) {
    List<SubstationChildModel> transformers = List<SubstationChildModel>.from(
        json['transformers']
            .map((p) => SubstationChildModel.fromJson(p))
            .toList());
    return SubstationModel(
        json['_id'],
        json['properties'],
        (json['rmu'] != null)
            ? SubstationChildModel.fromJson(json['rmu'])
            : SubstationChildModel(
                "rmu_id", <String, dynamic>{}, "parent substation id"),
        transformers,
        (json['lt_panel'] != null)
            ? SubstationChildModel.fromJson(json['lt_panel'])
            : SubstationChildModel(
                "ltpanel_id", <String, dynamic>{}, "parent substation id"),
        LocationPoint.fromJson(json['location']));
  }
  // Map toJson() => {
  //       "name": name,
  //       "location": location.toJson(),
  //     };
}
