import 'package:btp_app_mac/Models/RMUModel.dart';
import 'package:flutter/material.dart';

class RMUForm extends StatefulWidget {
  final RMUModel rmuModel;
  RMUForm(this.rmuModel);

  @override
  State<RMUForm> createState() => _RMUFormState();
}

class _RMUFormState extends State<RMUForm> {
  final TextEditingController _circuitBreakerController =
      TextEditingController();
  final TextEditingController _wayController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _circuitBreakerController.text =
        this.widget.rmuModel.cktBkrRating.toString();
    _wayController.text = this.widget.rmuModel.way.toString();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(5)),
        child: Center(
            child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    // label = RMU data
                    const Padding(
                      padding: EdgeInsets.all(6.0),
                      child: Text(
                        "RMU Data",
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    // circuit breaker rating
                    Padding(
                      padding: const EdgeInsets.all(6),
                      child: TextField(
                        controller: _circuitBreakerController,
                        decoration: InputDecoration(
                          labelText: "Circuit Breaker Rating",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5)),
                        ),
                        onChanged: (v) {
                          // this.widget.transformer.name = v;
                        },
                      ),
                    ),
                    // number of ways
                    Padding(
                      padding: const EdgeInsets.all(6),
                      child: TextField(
                        controller: _wayController,
                        decoration: InputDecoration(
                          labelText: "Way",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5)),
                        ),
                        onChanged: (v) {
                          //  this.widget.transformer.ratedPower = cas
                        },
                      ),
                    ),
                    // save button
                    ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text("Save"))
                  ],
                ))),
      ),
    );
  }
}
