import 'dart:async';
import 'dart:typed_data';
import 'package:btp_app_mac/Models/LTModel.dart';
import 'package:btp_app_mac/Models/LineModel.dart';
import 'package:btp_app_mac/Models/RMUModel.dart';
import 'package:btp_app_mac/Models/SubstationModel.dart';
import 'package:btp_app_mac/Substation.dart';
import 'package:btp_app_mac/Utilities/api_calls.dart';
import 'package:btp_app_mac/Utilities/icon_from_image.dart';
import 'package:btp_app_mac/widgets/cable_form.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:ui' as ui;
import 'dart:typed_data';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // A Google Maps controller is an object that is used to control the behavior of a GoogleMap widget in Flutter.
  // The controller provides access to various methods and properties that allow you to interact with the map and customize its behavior.
  GoogleMapController? controller;
  final CustomInfoWindowController _customInfoWindowMarkerController =
      CustomInfoWindowController();
  final CustomInfoWindowController _customInfoWindowLineController =
      CustomInfoWindowController();
  final Map<MarkerId, Marker> _markers = <MarkerId, Marker>{};
  final Map<PolylineId, Polyline> _polylines = <PolylineId, Polyline>{};
  LatLng currentClickedLocation = LatLng(0, 0);
  bool isPolyLineContinue = false;
  PolylineId currentPolylineId = PolylineId("id");
  cableModel currentCable = cableModel(
      "id", "name", 0, [], "start", "end", "${DateTime.now()}", 2023);
  List<cableModel> cables = [];
  List<SubstationModel> substations = [];
  SubstationModel substation = SubstationModel("id", "name",
      LTModel(2, 8, 40, 20), [], RMUModel(200, 4), locationPoint(0.0, 0.0));

  static const CameraPosition _kBhawan = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(29.869858078101394, 77.89556176735142),
      zoom: 15.151926040649414);

  // to get current location
  Future<Position> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
  }

  void animateToCurrent(LatLng currentLocation) async {
    controller!.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
            target: LatLng(currentLocation.latitude, currentLocation.longitude),
            zoom: 20),
      ),
    );
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
          print("Drag start");
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text("Do you want to remove this substation?"),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          setState(() {
                            print(_markers[MarkerId(id)]);
                            _markers.remove(MarkerId(id));
                            print(_markers[MarkerId(id)]);
                            print(_markers.values.length);
                          });
                        },
                        child: Text(
                          "Delete",
                          style: TextStyle(color: Colors.red),
                        )),
                    TextButton(onPressed: () {}, child: Text("Cancel")),
                  ],
                );
              });
        },
        onTap: () {
          _customInfoWindowMarkerController.addInfoWindow!(
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SubstationWidget(),
                ],
              ),
              LatLng(currentLocation.latitude, currentLocation.longitude));
        });
  }

  void _addPoleMarker() async {
    Position currentLocation = await getCurrentLocation();
    substation.location =
        locationPoint(currentLocation.latitude, currentLocation.longitude);

    Marker marker = await markerProperties(
        LatLng(currentLocation.latitude, currentLocation.longitude),
        "${currentLocation.latitude} " + "${currentLocation.longitude}");
    setState(() {
      _markers[MarkerId("${currentLocation.latitude} " +
          "${currentLocation.longitude}")] = marker;

      createSubstation(substation).then((substation) async {
        substations.add(substation);
        _markers.remove(marker);
        Marker marker2 = await markerProperties(
            LatLng(currentLocation.latitude, currentLocation.longitude),
            substation.id);
        _markers[MarkerId(substation.id)] = marker2;
      });
    });
    animateToCurrent(
        LatLng(currentLocation.latitude, currentLocation.longitude));
  }

  void _addApiMarkers(SubstationModel substation) async {
    //final Uint8List customIcon =  await getBytesFromAsset(path: 'assets/images/substation.png', width: 120);
    Marker marker = await markerProperties(
        LatLng(substation.location.latitutde, substation.location.longitude),
        substation.id);
    setState(() {
      _markers[MarkerId(substation.id)] = marker;
    });
    animateToCurrent(
        LatLng(substation.location.latitutde, substation.location.longitude));
  }

  void _addPolyLinePoint() async {
    Position currentLocation = await getCurrentLocation();
    if (_polylines.isEmpty || !isPolyLineContinue) {
      currentPolylineId = PolylineId(
          "id: ${currentLocation.latitude} " + "${currentLocation.longitude}");
      print(currentPolylineId.value);
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
    // remove the polyline
    _polylines.remove(polyline);
    // add the current coordinates to the polyline points
    polyline.points
        .add(LatLng(currentLocation.latitude, currentLocation.longitude));
    // update the currentCable points list to this polylines points
    currentCable.points = polyline.points
        .map((e) => locationPoint(e.latitude, e.longitude))
        .toList();
    setState(() {
      // insert this polyline back
      _polylines[currentPolylineId] = polyline;
      if (kDebugMode) {
        print(_polylines[currentPolylineId]!.points);
      }
    });
    animateToCurrent(
        LatLng(currentLocation.latitude, currentLocation.longitude));
  }

  void _addPolyLine(PolylineId id, cableModel cable) async {
    if (kDebugMode) {
      print("adding new polyline: ${id.value}");
    }
    setState(() {
      _polylines[id] = Polyline(
          polylineId: id,
          consumeTapEvents: true,
          width: 3,
          color: Colors.red,
          points: cable.points
              .map((e) => LatLng(e.latitutde, e.longitude))
              .toList(),
          onTap: () {
            handlePolylineClick(id, cable);
          });
      if (kDebugMode) {
        print("polyline created");
      }
      isPolyLineContinue = false;
      // for (Polyline p in _polylines.values) {
      //   if (kDebugMode) {
      //     print(p.polylineId.value);
      //   }
      // }
    });
  }

  void handlePolylineClick(PolylineId polylineId, cableModel cable) async {
    Polyline newPolyLine =
        _polylines[polylineId]!.copyWith(colorParam: Colors.blue);
    setState(() {
      _polylines[polylineId] = newPolyLine;
    });

    _customInfoWindowLineController.addInfoWindow!(
        CableForm(cable),
        LatLng(_polylines[polylineId]!.points[0].latitude,
            _polylines[polylineId]!.points[0].longitude));
    print("animating");
    animateToCurrent(LatLng(_polylines[polylineId]!.points[0].latitude,
        _polylines[polylineId]!.points[0].longitude));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // retrieve data from database
    getCableData().then((cableList) {
      setState(() {
        cables = cableList;
        for (var cable in cables) {
          _addPolyLine(PolylineId(cable.id), cable);
        }
      });
    });

    getSubstationData().then((substationList) {
      setState(() {
        substations = substationList;
        for (var substation in substations) {
          _addApiMarkers(substation);
        }
      });
    });

    cableModel cable = cableModel("id", "sample", 0, [], "", "", "", 2023);
    PolylineId newPolylineId = PolylineId("id1");
    _polylines[newPolylineId] = (Polyline(
      polylineId: newPolylineId,
      consumeTapEvents: true,
      width: 3,
      color: Colors.red,
      points: [
        LatLng(29.869858078101394, 77.89556176735142),
        LatLng(29.863895988693088, 77.89736900562289),
      ],
      onTap: () {
        print("clicked on line");
        handlePolylineClick(newPolylineId, cable);
      },
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                GoogleMap(
                  mapType: MapType.hybrid,
                  initialCameraPosition: _kBhawan,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                  onTap: (position) {
                    print("clicked position");
                    currentClickedLocation = position;
                    _customInfoWindowMarkerController.hideInfoWindow!();
                    _customInfoWindowLineController.hideInfoWindow!();
                  },
                  onCameraMove: (position) {
                    _customInfoWindowMarkerController.onCameraMove!();
                    _customInfoWindowLineController.onCameraMove!();
                  },
                  // returns a controller to interact with map
                  onMapCreated: (GoogleMapController cont) async {
                    controller = cont;
                    _customInfoWindowMarkerController.googleMapController =
                        controller;
                    _customInfoWindowLineController.googleMapController =
                        controller;
                  },
                  markers: Set<Marker>.of(_markers.values),
                  polylines: Set<Polyline>.of(_polylines.values),
                ),
                CustomInfoWindow(
                  controller: _customInfoWindowLineController,
                  height: 400,
                  width: 320,
                  offset: 50,
                ),
                CustomInfoWindow(
                  controller: _customInfoWindowMarkerController,
                  height: 290,
                  width: 320,
                  offset: 50,
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Button for adding new line or adding point
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: FilledButton(
                    onPressed: () {
                      _addPolyLinePoint();
                    },
                    child: Text(
                        "${(isPolyLineContinue) ? "Add point" : "New line"}")),
              ),
              // Button for adding substation
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: FilledButton(
                    onPressed: () {
                      // createSubstation(substation);
                      _addPoleMarker();
                    },
                    child: Text("Add substation")),
              ),
              // Button appearing to confirm line creation
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: (isPolyLineContinue)
                    ? FilledButton(
                        onPressed: () {
                          _addPolyLine(currentPolylineId, currentCable);
                          createCable(currentCable);
                        },
                        child: Text("Create"))
                    : null,
              ),
            ],
          )
        ],
      ),
    );
  }
}
