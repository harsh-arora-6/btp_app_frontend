import 'dart:async';
import 'dart:typed_data';
import 'package:btp_app_mac/Models/LTModel.dart';
import 'package:btp_app_mac/Models/LineModel.dart';
import 'package:btp_app_mac/Models/RMUModel.dart';
import 'package:btp_app_mac/Models/SubstationModel.dart';
import 'package:btp_app_mac/Substation.dart';
import 'package:btp_app_mac/Utilities/api_calls.dart';
import 'package:btp_app_mac/Utilities/cable_api.dart';
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
import 'Models/data_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<DataProvider>(
          create: (_) => DataProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const MyHomePage(title: 'Flutter Demo Home Page'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final Map<MarkerId, Marker> _markers = <MarkerId, Marker>{};

  List<CableModel> cables = [];
  // List<SubstationModel> substations = [];
  // SubstationModel substation = SubstationModel("id", "name",
  //     LTModel(2, 8, 40, 20), [], RMUModel(200, 4), LocationPoint(0.0, 0.0));

  static const CameraPosition _kBhawan = CameraPosition(
    bearing: 192.8334901395799,
    target: LatLng(29.869858078101394, 77.89556176735142),
    zoom: 15.151926040649414,
  );

  // Future<Marker> markerProperties(LatLng currentLocation, String id) async {
  //   final Uint8List customIcon = await getBytesFromAsset(
  //       path: 'assets/images/substation.png', width: 120);
  //   return Marker(
  //       markerId: MarkerId(id),
  //       position: LatLng(currentLocation.latitude, currentLocation.longitude),
  //       draggable: true,
  //       icon: BitmapDescriptor.fromBytes(customIcon),
  //       onDragStart: (coordinates) {
  //         print("Drag start");
  //         showDialog(
  //             context: context,
  //             builder: (context) {
  //               return AlertDialog(
  //                 title: const Text("Do you want to remove this substation?"),
  //                 actions: [
  //                   TextButton(
  //                       onPressed: () {
  //                         Navigator.pop(context);
  //                         setState(() {
  //                           print(_markers[MarkerId(id)]);
  //                           _markers.remove(MarkerId(id));
  //                           print(_markers[MarkerId(id)]);
  //                           print(_markers.values.length);
  //                         });
  //                       },
  //                       child: const Text(
  //                         "Delete",
  //                         style: TextStyle(color: Colors.red),
  //                       )),
  //                   TextButton(onPressed: () {}, child: const Text("Cancel")),
  //                 ],
  //               );
  //             });
  //       },
  //       onTap: () {
  //         _customInfoWindowMarkerController.addInfoWindow!(
  //             Column(
  //               mainAxisAlignment: MainAxisAlignment.center,
  //               children: [
  //                 SubstationWidget(),
  //               ],
  //             ),
  //             LatLng(currentLocation.latitude, currentLocation.longitude));
  //       });
  // }

  // void _addPoleMarker() async {
  //   Position currentLocation = await getCurrentLocation();
  //   substation.location =
  //       LocationPoint(currentLocation.latitude, currentLocation.longitude);
  //
  //   Marker marker = await markerProperties(
  //       LatLng(currentLocation.latitude, currentLocation.longitude),
  //       "${currentLocation.latitude} " + "${currentLocation.longitude}");
  //   setState(() {
  //     _markers[MarkerId("${currentLocation.latitude} " +
  //         "${currentLocation.longitude}")] = marker;
  //
  //     createSubstation(substation).then((substation) async {
  //       substations.add(substation);
  //       _markers.remove(marker);
  //       Marker marker2 = await markerProperties(
  //           LatLng(currentLocation.latitude, currentLocation.longitude),
  //           substation.id);
  //       _markers[MarkerId(substation.id)] = marker2;
  //     });
  //   });
  //   animateToCurrent(
  //       LatLng(currentLocation.latitude, currentLocation.longitude));
  // }
  //
  // void _addApiMarkers(SubstationModel substation) async {
  //   //final Uint8List customIcon =  await getBytesFromAsset(path: 'assets/images/substation.png', width: 120);
  //   Marker marker = await markerProperties(
  //       LatLng(substation.location.latitutde, substation.location.longitude),
  //       substation.id);
  //   setState(() {
  //     _markers[MarkerId(substation.id)] = marker;
  //   });
  //   animateToCurrent(
  //       LatLng(substation.location.latitutde, substation.location.longitude));
  // }
  //
  // void _addPolyLinePoint() async {
  //   Position currentLocation = await getCurrentLocation();
  //   if (_polylines.isEmpty || !isPolyLineContinue) {
  //     currentPolylineId = PolylineId(
  //         "id: ${currentLocation.latitude} " + "${currentLocation.longitude}");
  //     print(currentPolylineId.value);
  //     _polylines[currentPolylineId] = (Polyline(
  //       polylineId: currentPolylineId,
  //       consumeTapEvents: true,
  //       width: 3,
  //       color: Colors.red,
  //       points: [],
  //     ));
  //     isPolyLineContinue = true;
  //   }
  //
  //   Polyline polyline = _polylines[currentPolylineId] as Polyline;
  //   // remove the polyline
  //   _polylines.remove(polyline);
  //   // add the current coordinates to the polyline points
  //   polyline.points
  //       .add(LatLng(currentLocation.latitude, currentLocation.longitude));
  //   // update the currentCable points list to this polylines points
  //   currentCable.points = polyline.points
  //       .map((e) => LocationPoint(e.latitude, e.longitude))
  //       .toList();
  //   setState(() {
  //     // insert this polyline back
  //     _polylines[currentPolylineId] = polyline;
  //     if (kDebugMode) {
  //       print(_polylines[currentPolylineId]!.points);
  //     }
  //   });
  //   animateToCurrent(
  //       LatLng(currentLocation.latitude, currentLocation.longitude));
  // }
  //
  // Add a line.
  // void _addPoleMarker() async {
  //   Position currentLocation = await getCurrentLocation();
  //   substation.location =
  //       locationPoint(currentLocation.latitude, currentLocation.longitude);
  //
  //   Marker marker = await markerProperties(
  //       LatLng(currentLocation.latitude, currentLocation.longitude),
  //       "${currentLocation.latitude} " + "${currentLocation.longitude}");
  //   setState(() {
  //     _markers[MarkerId("${currentLocation.latitude} " +
  //         "${currentLocation.longitude}")] = marker;
  //
  //     createSubstation(substation).then((substation) async {
  //       substations.add(substation);
  //       _markers.remove(marker);
  //       Marker marker2 = await markerProperties(
  //           LatLng(currentLocation.latitude, currentLocation.longitude),
  //           substation.id);
  //       _markers[MarkerId(substation.id)] = marker2;
  //     });
  //   });
  //   animateToCurrent(
  //       LatLng(currentLocation.latitude, currentLocation.longitude));
  // }
  //
  // void _addApiMarkers(SubstationModel substation) async {
  //   //final Uint8List customIcon =  await getBytesFromAsset(path: 'assets/images/substation.png', width: 120);
  //   Marker marker = await markerProperties(
  //       LatLng(substation.location.latitutde, substation.location.longitude),
  //       substation.id);
  //   setState(() {
  //     _markers[MarkerId(substation.id)] = marker;
  //   });
  //   animateToCurrent(
  //       LatLng(substation.location.latitutde, substation.location.longitude));
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // retrieve data from database
    getAllCables().then((cableList) {
      for (var cableModel in cableList) {
        Provider.of<DataProvider>(context, listen: false).addPolyLine(
          PolylineId(cableModel.id),
          cableModel,
        );
      }
    }).catchError((error) => print(error));
    // getSubstationData().then((substationList) {
    //   setState(() {
    //     substations = substationList;
    //     for (var substation in substations) {
    //       _addApiMarkers(substation);
    //     }
    //   });
    // });
    //
    // CableModel cable = CableModel("id", "sample", 0, [], "", "", "", 2023);
    // PolylineId newPolylineId = PolylineId("id1");
    // _polylines[newPolylineId] = (Polyline(
    //   polylineId: newPolylineId,
    //   consumeTapEvents: true,
    //   width: 3,
    //   color: Colors.red,
    //   points: [
    //     LatLng(29.869858078101394, 77.89556176735142),
    //     LatLng(29.863895988693088, 77.89736900562289),
    //   ],
    //   onTap: () {
    //     print("clicked on line");
    //     handlePolylineClick(newPolylineId, cable);
    //   },
    // ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<DataProvider>(
        builder: (context, data, child) {
          return Column(
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
                        if (kDebugMode) {
                          print("clicked position");
                        }
                        data.updateClickLocation(position);
                      },
                      onCameraMove: (position) {
                        data.cameraMove();
                      },
                      // returns a controller to interact with map
                      onMapCreated: (GoogleMapController cont) async {
                        data.setController(cont);
                      },
                      markers: Set<Marker>.of(_markers.values),
                      polylines: Set<Polyline>.of(data.polylines.values),
                    ),
                    CustomInfoWindow(
                      controller: data.customInfoWindowLineController,
                      height: 400,
                      width: 320,
                      offset: 50,
                    ),
                    // CustomInfoWindow(
                    //   controller: _customInfoWindowMarkerController,
                    //   height: 290,
                    //   width: 320,
                    //   offset: 50,
                    // ),
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
                        data.addPolyLinePoint();
                      },
                      child: Text(
                          data.isPolyLineContinue ? "Add point" : "New line"),
                    ),
                  ),
                  // Button for adding substation
                  // Padding(
                  //   padding: const EdgeInsets.all(8.0),
                  //   child: FilledButton(
                  //       onPressed: () {
                  //         // createSubstation(substation);
                  //         _addPoleMarker();
                  //       },
                  //       child: Text("Add substation")),
                  // ),
                  // Button appearing to confirm line creation
                  // Padding(
                  //   padding: const EdgeInsets.all(8.0),
                  //   child: (isPolyLineContinue)
                  //       ? FilledButton(
                  //           onPressed: () {
                  //             _addPolyLine(currentPolylineId, currentCable);
                  //             createCable(currentCable);
                  //           },
                  //           child: Text("Create"))
                  //       : null,
                  // ),
                ],
              )
            ],
          );
        },
      ),
    );
  }
}
