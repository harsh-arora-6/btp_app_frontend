import 'package:btp_app_mac/Models/LineModel.dart';
import 'package:btp_app_mac/Utilities/api_calls.dart';
import 'package:flutter/material.dart';

class CableForm extends StatefulWidget {
  // const CableForm({Key? key}) : super(key: key);
  cableModel cabel;
  CableForm(this.cabel);
  @override
  State<CableForm> createState() => _CableFormState();
}

class _CableFormState extends State<CableForm> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _ratingController = TextEditingController();
  TextEditingController _startingLocationController = TextEditingController();
  TextEditingController _endingLocationController = TextEditingController();
  TextEditingController _nextMantainenceController = TextEditingController();
  TextEditingController _manufacturingDate = TextEditingController();
  bool isVisible = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _nameController.value = TextEditingValue(text: this.widget.cabel.name);
    _ratingController.value =
        TextEditingValue(text: this.widget.cabel.rating.toString());
    _startingLocationController.value =
        TextEditingValue(text: this.widget.cabel.startingLocation);
    _endingLocationController.value =
        TextEditingValue(text: this.widget.cabel.endingLocation);
    _nextMantainenceController.value =
        TextEditingValue(text: this.widget.cabel.nextMant);
    _manufacturingDate.value =
        TextEditingValue(text: this.widget.cabel.yearOfManufacture.toString());
  }

  @override
  Widget build(BuildContext context) {
    return (isVisible)
        ? SingleChildScrollView(
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(5)),
              child: Center(
                  child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        // displaying properties of cable
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: Text(
                              "Cable Data",
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                          // name
                          Padding(
                            padding: const EdgeInsets.all(6),
                            child: TextField(
                              controller: _nameController,
                              decoration: InputDecoration(
                                labelText: "Name",
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5)),
                              ),
                              onChanged: (v) {
                                this.widget.cabel.name = v;
                              },
                            ),
                          ),
                          // rating
                          Padding(
                            padding: const EdgeInsets.all(6),
                            child: TextField(
                              controller: _ratingController,
                              decoration: InputDecoration(
                                labelText: "Rating",
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5)),
                              ),
                              onChanged: (v) {
                                this.widget.cabel.rating = double.parse(v);
                              },
                            ),
                          ),
                          //starting location
                          Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: TextField(
                              controller: _startingLocationController,
                              decoration: InputDecoration(
                                labelText: "Starting Location",
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5)),
                              ),
                              onChanged: (v) {
                                this.widget.cabel.startingLocation = v;
                              },
                            ),
                          ),
                          //ending location
                          Padding(
                            padding: const EdgeInsets.all(6),
                            child: TextField(
                              controller: _endingLocationController,
                              decoration: InputDecoration(
                                labelText: "Ending Location",
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5)),
                              ),
                              onChanged: (v) {
                                this.widget.cabel.endingLocation = v;
                              },
                            ),
                          ),
                          //next maintenance
                          Padding(
                            padding: const EdgeInsets.all(6),
                            child: TextField(
                              controller: _nextMantainenceController,
                              decoration: InputDecoration(
                                labelText: "Next Mantainenece",
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5)),
                              ),
                              onChanged: (v) {
                                this.widget.cabel.nextMant = v;
                              },
                            ),
                          ),
                          // year of manufacture
                          Padding(
                            padding: const EdgeInsets.all(6),
                            child: TextField(
                              controller: _manufacturingDate,
                              decoration: InputDecoration(
                                labelText: "Manufacturing Date",
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5)),
                              ),
                              onChanged: (v) {
                                this.widget.cabel.yearOfManufacture =
                                    int.parse(v);
                              },
                            ),
                          ),

                          ElevatedButton(
                              onPressed: () {
                                updateCable(this.widget.cabel);
                                setState(() {
                                  isVisible = false;
                                });
                              },
                              child: Text("Save"))
                        ],
                      ))),
            ),
          )
        : Container();
  }
}
