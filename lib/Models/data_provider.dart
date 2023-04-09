import 'package:btp_app_mac/Models/substation_model.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../Substation.dart';
import '../Utilities/icon_from_image.dart';
import '../Utilities/location.dart';
import '../widgets/cable_form.dart';
import 'line_model.dart';
import 'substation_model.dart';
import 'substation_child_model.dart';

class DataProvider extends ChangeNotifier {
  BuildContext context;
  DataProvider(this.context);
  GoogleMapController? controller;
  final CustomInfoWindowController customInfoWindowMarkerController =
      CustomInfoWindowController();
  final CustomInfoWindowController customInfoWindowLineController =
      CustomInfoWindowController();
  Map<MarkerId, Marker> _markers = <MarkerId, Marker>{};
  Map<PolylineId, Polyline> _polylines = <PolylineId, Polyline>{};
  bool isPolyLineContinue = false;
  // getters
  Map<PolylineId, Polyline> get polylines => _polylines;
  Map<MarkerId, Marker> get markers => _markers;

  PolylineId currentPolylineId = PolylineId("id");
  CableModel currentCable =
      CableModel("", <String, dynamic>{}, <LocationPoint>[]);
  SubstationModel substation = SubstationModel(
      "id",
      <String, dynamic>{},
      SubstationChildModel('rmu_id', <String, dynamic>{}, 'parentSubstationId'),
      [],
      SubstationChildModel(
          'ltpanel_id', <String, dynamic>{}, 'parentSubstationId'),
      LocationPoint(0.0, 0.0));
  // List<CableModel> cables = [];
  // List<SubstationModel> substations = [];
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

  Future<Marker> markerProperties(LatLng currentLocation, String id) async {
    final Uint8List customIcon = await getBytesFromAsset(
        path: 'assets/images/substation.png', width: 120);
    return Marker(
        markerId: MarkerId(id),
        position: LatLng(currentLocation.latitude, currentLocation.longitude),
        draggable: true,
        icon: BitmapDescriptor.fromBytes(customIcon),
        onDragStart: (coordinates) {
          if (kDebugMode) {
            print("Drag start");
          }
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text("Do you want to remove this substation?"),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          if (kDebugMode) {
                            print(_markers[MarkerId(id)]);
                          }
                          _markers.remove(MarkerId(id));
                          if (kDebugMode) {
                            print(_markers[MarkerId(id)]);
                          }
                          if (kDebugMode) {
                            print(_markers.values.length);
                          }
                          notifyListeners();
                        },
                        child: const Text(
                          "Delete",
                          style: TextStyle(color: Colors.red),
                        )),
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text("Cancel")),
                  ],
                );
              });
        },
        onTap: () {
          customInfoWindowMarkerController.addInfoWindow!(
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SubstationWidget(),
              ],
            ),
            LatLng(currentLocation.latitude, currentLocation.longitude),
          );
        });
  }

  // void _addPoleMarker() async {
  //   Position currentLocation = await Location().getCurrentLocation();
  //   substation.location =
  //       LocationPoint(currentLocation.latitude, currentLocation.longitude);
  //
  //   Marker marker = await markerProperties(
  //       LatLng(currentLocation.latitude, currentLocation.longitude),
  //       "${currentLocation.latitude} " + "${currentLocation.longitude}");
  //
  //   _markers[MarkerId(
  //           "${currentLocation.latitude} " + "${currentLocation.longitude}")] =
  //       marker;
  //
  //   createSubstation(substation).then((substation) async {
  //     substations.add(substation);
  //     _markers.remove(marker);
  //     Marker marker2 = await markerProperties(
  //         LatLng(currentLocation.latitude, currentLocation.longitude),
  //         substation.id);
  //     _markers[MarkerId(substation.id)] = marker2;
  //   });
  //   Location().animateToCurrent(
  //       LatLng(currentLocation.latitude, currentLocation.longitude));
  // }

  void addApiMarkers(SubstationModel substation) async {
    Marker marker = await markerProperties(
        LatLng(substation.location.latitutde, substation.location.longitude),
        substation.id);
    _markers[MarkerId(substation.id)] = marker;
    Location().animateToCurrent(
        LatLng(substation.location.latitutde, substation.location.longitude),
        controller);

    notifyListeners();
  }
}
