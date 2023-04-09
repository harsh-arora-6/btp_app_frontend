import 'package:btp_app_mac/Models/LineModel.dart';
import 'package:btp_app_mac/Utilities/api_calls.dart';
import 'package:flutter/material.dart';

class CableForm extends StatefulWidget {
  // const CableForm({Key? key}) : super(key: key);
  CableModel cable;
  CableForm(this.cable, {super.key});
  @override
  State<CableForm> createState() => _CableFormState();
}

class _CableFormState extends State<CableForm> {
  // TextEditingController _nameController = TextEditingController();
  // TextEditingController _ratingController = TextEditingController();
  // TextEditingController _startingLocationController = TextEditingController();
  // TextEditingController _endingLocationController = TextEditingController();
  // TextEditingController _nextMantainenceController = TextEditingController();
  // TextEditingController _manufacturingDate = TextEditingController();
  bool isVisible = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // _nameController.value = TextEditingValue(text: this.widget.cable.name);
    // _ratingController.value =
    //     TextEditingValue(text: this.widget.cable.rating.toString());
    // _startingLocationController.value =
    //     TextEditingValue(text: this.widget.cable.startingLocation);
    // _endingLocationController.value =
    //     TextEditingValue(text: this.widget.cable.endingLocation);
    // _nextMantainenceController.value =
    //     TextEditingValue(text: this.widget.cable.nextMant);
    // _manufacturingDate.value =
    //     TextEditingValue(text: this.widget.cable.yearOfManufacture.toString());
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
                        children: const [
                          Padding(
                            padding: EdgeInsets.all(6.0),
                            child: Text(
                              "Cable Data",
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                          // name
                          // Padding(
                          //   padding: const EdgeInsets.all(6),
                          //   child: TextField(
                          //     controller: _nameController,
                          //     decoration: InputDecoration(
                          //       labelText: "Name",
                          //       border: OutlineInputBorder(
                          //           borderRadius: BorderRadius.circular(5)),
                          //     ),
                          //     onChanged: (v) {
                          //       this.widget.cable.name = v;
                          //     },
                          //   ),
                          // ),
                          // // rating
                          // Padding(
                          //   padding: const EdgeInsets.all(6),
                          //   child: TextField(
                          //     controller: _ratingController,
                          //     decoration: InputDecoration(
                          //       labelText: "Rating",
                          //       border: OutlineInputBorder(
                          //           borderRadius: BorderRadius.circular(5)),
                          //     ),
                          //     onChanged: (v) {
                          //       this.widget.cable.rating = double.parse(v);
                          //     },
                          //   ),
                          // ),
                          // //starting location
                          // Padding(
                          //   padding: const EdgeInsets.all(6.0),
                          //   child: TextField(
                          //     controller: _startingLocationController,
                          //     decoration: InputDecoration(
                          //       labelText: "Starting Location",
                          //       border: OutlineInputBorder(
                          //           borderRadius: BorderRadius.circular(5)),
                          //     ),
                          //     onChanged: (v) {
                          //       this.widget.cable.startingLocation = v;
                          //     },
                          //   ),
                          // ),
                          // //ending location
                          // Padding(
                          //   padding: const EdgeInsets.all(6),
                          //   child: TextField(
                          //     controller: _endingLocationController,
                          //     decoration: InputDecoration(
                          //       labelText: "Ending Location",
                          //       border: OutlineInputBorder(
                          //           borderRadius: BorderRadius.circular(5)),
                          //     ),
                          //     onChanged: (v) {
                          //       this.widget.cable.endingLocation = v;
                          //     },
                          //   ),
                          // ),
                          // //next maintenance
                          // Padding(
                          //   padding: const EdgeInsets.all(6),
                          //   child: TextField(
                          //     controller: _nextMantainenceController,
                          //     decoration: InputDecoration(
                          //       labelText: "Next Mantainenece",
                          //       border: OutlineInputBorder(
                          //           borderRadius: BorderRadius.circular(5)),
                          //     ),
                          //     onChanged: (v) {
                          //       this.widget.cable.nextMant = v;
                          //     },
                          //   ),
                          // ),
                          // // year of manufacture
                          // Padding(
                          //   padding: const EdgeInsets.all(6),
                          //   child: TextField(
                          //     controller: _manufacturingDate,
                          //     decoration: InputDecoration(
                          //       labelText: "Manufacturing Date",
                          //       border: OutlineInputBorder(
                          //           borderRadius: BorderRadius.circular(5)),
                          //     ),
                          //     onChanged: (v) {
                          //       this.widget.cable.yearOfManufacture =
                          //           int.parse(v);
                          //     },
                          //   ),
                          // ),
                          // // save button
                          // ElevatedButton(
                          //     onPressed: () {
                          //       updateCable(this.widget.cable);
                          //       setState(() {
                          //         isVisible = false;
                          //       });
                          //     },
                          //     child: Text("Save"),)
                        ],
                      ))),
            ),
          )
        : Container();
  }
}
