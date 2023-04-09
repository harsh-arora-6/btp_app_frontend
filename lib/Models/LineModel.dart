class CableModel {
  String id;
  late Map<String, dynamic> properties;
  List<LocationPoint> locationPoints;
  // String id = "";
  // String name = "";
  // double rating = 0;
  // List<LocationPoint> points = [];
  // String startingLocation = "";
  // String endingLocation = "";
  // String nextMant = "";
  // int yearOfManufacture = 0;

  CableModel(this.id, this.properties, this.locationPoints);
  factory CableModel.fromJson(Map<String, dynamic> json) {
    List<LocationPoint> listPoints = List<LocationPoint>.from(
        json['point_locations'].map((p) => LocationPoint.fromJson(p)).toList());
    return CableModel(json['_id'] as String, json['properties'], listPoints);
  }
  // Map toJson() => {
  //       "name": name,
  //       "rating": rating,
  //       "point_locations": points.map((e) => e.toJson()).toList(),
  //       "starting_location": startingLocation,
  //       "ending_location": endingLocation,
  //       "next_maintenance": nextMant,
  //       "year_of_manufacture": yearOfManufacture
  //     };
}

class LocationPoint {
  double latitutde = 0;
  double longitude = 0;
  LocationPoint(this.latitutde, this.longitude);

  factory LocationPoint.fromJson(List<dynamic> json) {
    return LocationPoint(json[0].toDouble(), json[1].toDouble());
  }

  List<dynamic> toJson() {
    return [latitutde, longitude];
  }
}
