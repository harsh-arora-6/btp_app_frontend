import 'package:btp_app_mac/Models/substation_model.dart';
import 'package:btp_app_mac/Models/user_model.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../Substation.dart';
import '../Utilities/api_calls.dart';
import '../Utilities/icon_from_image.dart';
import '../Utilities/location.dart';
import '../Utilities/substation_api.dart';
import '../widgets/component_form.dart';
import 'line_model.dart';
import 'substation_child_model.dart';

class DataProvider extends ChangeNotifier {
  BuildContext context;
  DataProvider(this.context);
  GoogleMapController? controller;
  final CustomInfoWindowController customInfoWindowMarkerController =
      CustomInfoWindowController();
  final CustomInfoWindowController customInfoWindowLineController =
      CustomInfoWindowController();
  UserModel user = UserModel('', '', '', '', '', '', '');
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
  LatLng currentClickedLocation = LatLng(0, 0);

  void hideLineInfoWindow() {
    customInfoWindowLineController.hideInfoWindow!();
    notifyListeners();
  }

  void hideMarkerInfoWindow() {
    customInfoWindowMarkerController.hideInfoWindow!();
    notifyListeners();
  }

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
        currentPolylineId = PolylineId(
            "${currentLocation.latitude} " + "${currentLocation.longitude}");
        // if (kDebugMode) {
        //   print(currentPolylineId.value);
        // }
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
      _polylines.remove(currentPolylineId);
      // add current point
      polyline.points.add(
        LatLng(currentLocation.latitude, currentLocation.longitude),
      );
      currentCable.locationPoints = polyline.points
          .map((e) => LocationPoint(e.latitude, e.longitude))
          .toList();
      // add this updated entry
      _polylines[currentPolylineId] = polyline;
      // if (kDebugMode) {
      //   print(_polylines[currentPolylineId]!.points);
      // }
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

  void addPolyLine(dynamic cable) async {
    _polylines.remove(currentPolylineId);
    _polylines[PolylineId(cable.id as String)] = Polyline(
        polylineId: PolylineId(cable.id),
        consumeTapEvents: true,
        width: 3,
        color: Colors.red,
        points: List<LatLng>.from(
          cable.locationPoints
              .map((e) => LatLng(e.latitutde as double, e.longitude as double))
              .toList(),
        ),
        onTap: () {
          hideMarkerInfoWindow();
          handlePolylineClick(cable);
        });

    isPolyLineContinue = false;
    notifyListeners();
  }

  void removeLine(String id) async {
    // remove from backend
    await deleteComponent(id, 'cable');
    //remove from frontend
    _polylines.remove(PolylineId(id));
    hideLineInfoWindow();
    notifyListeners();
  }

  void updatePolylineColor(String id, {String color = 'red'}) {
    PolylineId polylineId = PolylineId(id);
    Polyline newPolyLine = _polylines[polylineId]!
        .copyWith(colorParam: color == 'red' ? Colors.red : Colors.blue);
    _polylines[polylineId] = newPolyLine;
  }

  void makeAllLineRed() {
    for (PolylineId polylineId in _polylines.keys) {
      Polyline newPolyLine =
          _polylines[polylineId]!.copyWith(colorParam: Colors.red);
      _polylines[polylineId] = newPolyLine;
    }
  }

  void handlePolylineClick(dynamic cable) async {
    try {
      updatePolylineColor(cable.id as String, color: 'blue');

      PolylineId polylineId = PolylineId(cable.id as String);

      customInfoWindowLineController.addInfoWindow!(
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ComponentForm('cable', cable),
              user.role == 'admin'
                  ? TextButton(
                      onPressed: () {
                        //todo:remove Line from front end and backend
                        // Navigator.pop(context);
                        removeLine(cable.id as String);
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.red),
                        foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.white),
                      ),
                      child: const Text('Delete Line'),
                    )
                  : Container()
            ],
          ),
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

  // puts marker to current location with the given id
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
                          hideMarkerInfoWindow();
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
        onDragEnd: (coordinates) async {
          //  todo:update location in backend

          if (!id.contains(' ')) {
            //not a dummy marker
            SubstationModel sub = await getComponent(id, 'substation');
            sub.location =
                LocationPoint(coordinates.latitude, coordinates.longitude);
            sub = await updateComponent(sub, 'substation');
            _markers.remove(MarkerId(id));
            addMarker(sub);
          }
        },
        onTap: () {
          hideLineInfoWindow();
          makeAllLineRed();
          customInfoWindowMarkerController.addInfoWindow!(
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SubstationWidget(id),
                user.role == 'admin'
                    ? TextButton(
                        onPressed: () {
                          removeMarker(id);
                        },
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.red),
                          foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.white),
                        ),
                        child: const Text('Delete Substation'),
                      )
                    : Container()
              ],
            ),
            LatLng(currentLocation.latitude, currentLocation.longitude),
          );
        });
  }

  void removeMarker(String id) async {
    // remove from backend
    await deleteComponent(id, 'substation');
    //remove from frontend
    _markers.remove(MarkerId(id));
    hideMarkerInfoWindow();
    notifyListeners();
  }

  // puts marker to newly created substation
  void addNewMarker() async {
    Position currentLocation = await Location().getCurrentLocation();
    substation.location =
        LocationPoint(currentLocation.latitude, currentLocation.longitude);
    final Uint8List customIcon = await getBytesFromAsset(
        path: 'assets/images/substation.png', width: 120);
    // just putting icon on front end
    Marker marker = Marker(
      markerId: MarkerId(
          "${currentLocation.latitude} " + "${currentLocation.longitude}"),
      position: LatLng(currentLocation.latitude, currentLocation.longitude),
      icon: BitmapDescriptor.fromBytes(customIcon),
    );

    _markers[MarkerId(
            "${currentLocation.latitude} " + "${currentLocation.longitude}")] =
        marker;
    // create new substation
    dynamic newSubstation = await createSubstation(substation);
    // removing dummy marker
    _markers.remove(MarkerId(
        "${currentLocation.latitude} " + "${currentLocation.longitude}"));
    // add actual marker
    Marker marker2 = await markerProperties(
        LatLng(currentLocation.latitude, currentLocation.longitude),
        newSubstation.id as String);
    _markers[MarkerId(newSubstation.id as String)] = marker2;

    Location().animateToCurrent(
        LatLng(currentLocation.latitude, currentLocation.longitude),
        controller);

    notifyListeners();
  }

  // puts marker to given substation
  void addMarker(dynamic substation) async {
    //put marker at substation location
    Marker marker = await markerProperties(
        LatLng(substation.location.latitutde, substation.location.longitude),
        substation.id as String);
    _markers[MarkerId(substation.id as String)] = marker;

    Location().animateToCurrent(
        LatLng(substation.location.latitutde as double,
            substation.location.longitude as double),
        controller);

    notifyListeners();
  }

  void updateUser(UserModel usr) {
    user = usr;
    notifyListeners();
  }
}
