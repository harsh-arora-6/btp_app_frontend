import 'dart:async';
import 'dart:typed_data';
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

import 'Utilities/substation_api.dart';

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
          create: (context) => DataProvider(context),
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
  static const CameraPosition _kBhawan = CameraPosition(
    bearing: 192.8334901395799,
    target: LatLng(29.869858078101394, 77.89556176735142),
    zoom: 15.151926040649414,
  );

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
    }).catchError((error) {
      if (kDebugMode) {
        print(error);
      }
    });

    getSubstationData().then((substationList) {
      for (var substation in substationList) {
        Provider.of<DataProvider>(context, listen: false)
            .addApiMarkers(substation);
      }
    }).catchError((error) {
      if (kDebugMode) {
        print(error);
      }
    });
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
                      markers: Set<Marker>.of(data.markers.values),
                      polylines: Set<Polyline>.of(data.polylines.values),
                    ),
                    CustomInfoWindow(
                      controller: data.customInfoWindowLineController,
                      height: 400,
                      width: 320,
                      offset: 50,
                    ),
                    CustomInfoWindow(
                      controller: data.customInfoWindowMarkerController,
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
