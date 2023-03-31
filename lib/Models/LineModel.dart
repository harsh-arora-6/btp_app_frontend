import 'package:flutter/material.dart';

class cableModel {
  String id = "";
  String name = "";
  double rating = 0;
  List<locationPoint> points = [];
  String startingLocation = "";
  String endingLocation = "";
  String nextMant = "";
  int yearOfManufacture = 0;

  cableModel(
      this.id,
      this.name,
      this.rating,
      this.points,
      this.startingLocation,
      this.endingLocation,
      this.nextMant,
      this.yearOfManufacture);
  factory cableModel.fromJson(Map<String, dynamic> json) {
    List<locationPoint> listPoints = List<locationPoint>.from(
        json['point_locations'].map((p) => locationPoint.fromJson(p)).toList());
    return cableModel(
        json['_id'],
        json['name'],
        json['rating'].toDouble(),
        listPoints,
        json['starting_location'],
        json['ending_location'],
        json['next_maintenance'],
        json['year_of_manufacture']);
  }
  Map toJson() => {
        "name": name,
        "rating": rating,
        "point_locations": points.map((e) => e.toJson()).toList(),
        "starting_location": startingLocation,
        "ending_location": endingLocation,
        "next_maintenance": nextMant,
        "year_of_manufacture": yearOfManufacture
      };
}

class locationPoint {
  double latitutde = 0;
  double longitude = 0;
  locationPoint(this.latitutde, this.longitude);

  factory locationPoint.fromJson(List<dynamic> json) {
    return locationPoint(json[0].toDouble(), json[1].toDouble());
  }

  List<dynamic> toJson() {
    return [latitutde, longitude];
  }
}
