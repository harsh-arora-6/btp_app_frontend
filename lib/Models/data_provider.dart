import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../Utilities/location.dart';
import '../widgets/cable_form.dart';
import 'LineModel.dart';

class DataProvider extends ChangeNotifier {
  GoogleMapController? controller;
  final CustomInfoWindowController customInfoWindowMarkerController =
      CustomInfoWindowController();
  final CustomInfoWindowController customInfoWindowLineController =
      CustomInfoWindowController();

  Map<PolylineId, Polyline> _polylines = <PolylineId, Polyline>{};
  bool isPolyLineContinue = false;
  Map<PolylineId, Polyline> get polylines => _polylines;
  PolylineId currentPolylineId = PolylineId("id");
  CableModel currentCable =
      CableModel("", <String, dynamic>{}, <LocationPoint>[]);
  LatLng currentClickedLocation = LatLng(0, 0);

  void updateClickLocation(LatLng position) {
    currentClickedLocation = position;
    customInfoWindowMarkerController.hideInfoWindow!();
    customInfoWindowLineController.hideInfoWindow!();
    notifyListeners();
  }

  void cameraMove() {
    customInfoWindowMarkerController.onCameraMove!();
    customInfoWindowLineController.onCameraMove!();
    notifyListeners();
  }

  void setController(GoogleMapController cont) {
    controller = cont;
    customInfoWindowMarkerController.googleMapController = cont;
    customInfoWindowLineController.googleMapController = cont;
    notifyListeners();
  }

  void addPolyLinePoint() async {
    try {
      Position currentLocation = await Location().getCurrentLocation();
      if (_polylines.isEmpty || !isPolyLineContinue) {
        // add as we will remove in next step
        currentPolylineId = PolylineId("id: ${currentLocation.latitude} " +
            "${currentLocation.longitude}");
        if (kDebugMode) {
          print(currentPolylineId.value);
        }
        _polylines[currentPolylineId] = (Polyline(
          polylineId: currentPolylineId,
          consumeTapEvents: true,
          width: 3,
          color: Colors.red,
          points: [],
        ));
        isPolyLineContinue = true;
      }

      Polyline polyline = _polylines[currentPolylineId] as Polyline;
      // remove previous entry
      _polylines.remove(polyline);
      // add current point
      polyline.points.add(
        LatLng(currentLocation.latitude, currentLocation.longitude),
      );
      currentCable.locationPoints = polyline.points
          .map((e) => LocationPoint(e.latitude, e.longitude))
          .toList();
      // add this updated entry
      _polylines[currentPolylineId] = polyline;
      if (kDebugMode) {
        print(_polylines[currentPolylineId]!.points);
      }
      Location().animateToCurrent(
          LatLng(currentLocation.latitude, currentLocation.longitude),
          controller);

      notifyListeners();
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
    }
  }

  void addPolyLine(PolylineId id, CableModel cable) async {
    print("adding new polyline: ${id.value}");
    _polylines[id] = Polyline(
        polylineId: id,
        consumeTapEvents: true,
        width: 3,
        color: Colors.red,
        points: cable.locationPoints
            .map((e) => LatLng(e.latitutde, e.longitude))
            .toList(),
        onTap: () {
          handlePolylineClick(id, cable);
        });
    print("polyline created");
    isPolyLineContinue = false;
    for (Polyline p in _polylines.values) {
      print(p.polylineId.value);
    }
    notifyListeners();
  }

  void handlePolylineClick(PolylineId polylineId, CableModel cable) async {
    try {
      Polyline newPolyLine =
          _polylines[polylineId]!.copyWith(colorParam: Colors.blue);
      _polylines[polylineId] = newPolyLine;

      customInfoWindowLineController.addInfoWindow!(
          CableForm(cable),
          LatLng(_polylines[polylineId]!.points[0].latitude,
              _polylines[polylineId]!.points[0].longitude));
      print("animating");
      Location().animateToCurrent(
          LatLng(_polylines[polylineId]!.points[0].latitude,
              _polylines[polylineId]!.points[0].longitude),
          controller);

      notifyListeners();
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
    }
  }
}
