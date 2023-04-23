import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../Models/data_provider.dart';
import '../Models/line_model.dart';
import '../Utilities/api_calls.dart';
import '../Utilities/user_api.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isLoggingOut = false;
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
    fetchData();
  }

  void fetchData() async {
    List<dynamic> cableList = await getAllComponent('cable');
    List<dynamic> substationList = await getAllComponent('substation');

    for (dynamic cableModel in cableList) {
      // print(cableModel.properties);
      Provider.of<DataProvider>(context, listen: false).addPolyLine(
        cableModel,
      );
    }
    for (dynamic substationModel in substationList) {
      // print(cableModel.properties);
      Provider.of<DataProvider>(context, listen: false)
          .addMarker(substationModel);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DataProvider>(
      builder: (context, data, child) {
        data.context = context;
        return Scaffold(
          appBar: AppBar(
            //user name
            title: Text(data.user.name),
            actions: [
              //logout button
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: FilledButton(
                  onPressed: () async {
                    data.makeDefaultScreen();
                    setState(() {
                      isLoggingOut = true;
                    });
                    Navigator.pop(context);
                    await logout();
                  },
                  style: const ButtonStyle(
                      backgroundColor:
                          MaterialStatePropertyAll(Colors.blueGrey)),
                  child: const Text("Logout"),
                ),
              )
            ],
          ),
          body: isLoggingOut
              ? const AlertDialog(
                  icon: CircularProgressIndicator(),
                  title: Text('Logging out...'),
                )
              : Column(
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
                                // print("clicked position");
                              }
                              data.makeAllLineRed();
                              data.updateClickLocation(position);
                              data.hideMarkerInfoWindow();
                              data.hideLineInfoWindow();
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
                    data.user.role == 'admin'
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Button for adding new line or adding point
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: FilledButton(
                                  onPressed: () {
                                    data.addPolyLinePoint();
                                  },
                                  child: Text(data.isPolyLineContinue
                                      ? "Add point"
                                      : "New line"),
                                ),
                              ),
                              // Button for adding substation
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: FilledButton(
                                    onPressed: () {
                                      // create a new substation and add marker to it.
                                      data.addNewMarker();
                                    },
                                    child: const Text("Add substation")),
                              ),
                              // Button appearing to confirm line creation
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: (data.isPolyLineContinue)
                                    ? FilledButton(
                                        onPressed: () async {
                                          // print(data.currentCable);
                                          CableModel cable =
                                              await createComponent(
                                                  data.currentCable, 'cable');
                                          data.addPolyLine(cable);
                                        },
                                        child: const Text("Create"))
                                    : null,
                              ),
                            ],
                          )
                        : Container()
                  ],
                ),
        );
      },
    );
  }
}
