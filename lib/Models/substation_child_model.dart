class SubstationChildModel {
  // double cktBkrRating = 0.0;
  // int way = 0;
  late String id;
  late Map<String, dynamic> properties;
  late String parentSubstationId;

  SubstationChildModel(this.id, this.properties, this.parentSubstationId);
  factory SubstationChildModel.fromJson(Map<String, dynamic> json) {
    // print('substation child fromJson');
    // print(json);
    String newId = json['_id'] ?? json['id'];
    return SubstationChildModel(
        newId,
        json['properties'] ?? <String, dynamic>{},
        json['substation'] as String);
  }

  Map<String, dynamic> toJson() =>
      {"id": id, "properties": properties, "substation": parentSubstationId};
}
