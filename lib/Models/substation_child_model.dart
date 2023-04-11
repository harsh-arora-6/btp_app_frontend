class SubstationChildModel {
  // double cktBkrRating = 0.0;
  // int way = 0;
  late String id;
  late Map<String, dynamic> properties;
  late String parentSubstationId;

  SubstationChildModel(this.id, this.properties, this.parentSubstationId);
  factory SubstationChildModel.fromJson(Map<String, dynamic> json) {
    return SubstationChildModel(json['_id'] as String, json['properties'],
        json['substation'] as String);
  }

  Map toJson() => {"properties": properties, "substation": parentSubstationId};
}
