import 'package:btp_app_mac/Models/LTModel.dart';
import 'package:btp_app_mac/Models/TransformerModel.dart';
import 'package:btp_app_mac/Models/RMUModel.dart';
import 'package:btp_app_mac/Models/LineModel.dart';

class SubstationModel {
  String id = "";
  String name = "";
  LTModel lt = LTModel(0, 0, 0, 0);
  List<transformerModel> trList = [];
  RMUModel rmu = RMUModel(0, 0);
  LocationPoint location = LocationPoint(0, 0);
  SubstationModel(
      this.id, this.name, this.lt, this.trList, this.rmu, this.location);
  factory SubstationModel.fromJson(Map<String, dynamic> json) {
    List<transformerModel> transformers = List<transformerModel>.from(
        json['transformers'].map((p) => transformerModel.fromJson(p)).toList());
    return SubstationModel(
        json['_id'],
        json['name'],
        (json['lt_panel'] != null)
            ? LTModel.fromJson(json['lt_panel'])
            : LTModel(0, 0, 0, 0),
        transformers,
        (json['rmu'] != null) ? RMUModel.fromJson(json['rmu']) : RMUModel(0, 0),
        LocationPoint.fromJson(json['location']));
  }
  Map toJson() => {
        "name": name,
        "location": location.toJson(),
      };
}
