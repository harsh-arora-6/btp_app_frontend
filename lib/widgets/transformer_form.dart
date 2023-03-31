import 'package:btp_app_mac/Models/TransformerModel.dart';
import 'package:flutter/material.dart';

class TransformerForm extends StatefulWidget {
  transformerModel transformer;
  TransformerForm(this.transformer);

  @override
  State<TransformerForm> createState() => _TransformerFormState();
}

class _TransformerFormState extends State<TransformerForm> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _ratedPowerController = TextEditingController();
  TextEditingController _impedanceController = TextEditingController();
  TextEditingController _primaryVoltageController = TextEditingController();
  TextEditingController _secondaryVoltageController = TextEditingController();
  TextEditingController _nextMantainenceController = TextEditingController();
  TextEditingController _manufacturingDate = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    transformerModel t = this.widget.transformer;
    _nameController.text = t.name;
    _ratedPowerController.text = t.ratedPower.toString();
    _impedanceController.text = t.impedance.toString();
    _primaryVoltageController.text = t.primaryVolt.toString();
    _secondaryVoltageController.text = t.secondaryVolt.toString();
    _nextMantainenceController.text = t.nextMant;
    _manufacturingDate.text = t.manYear.toString();
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
                    const Padding(
                      padding: EdgeInsets.all(6.0),
                      child: Text(
                        "Transformer Data",
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    // Name
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
                          this.widget.transformer.name = v;
                        },
                      ),
                    ),
                    // rated power
                    Padding(
                      padding: const EdgeInsets.all(6),
                      child: TextField(
                        controller: _ratedPowerController,
                        decoration: InputDecoration(
                          labelText: "Rated Power",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5)),
                        ),
                        onChanged: (v) {
                          this.widget.transformer.ratedPower = double.parse(v);
                        },
                      ),
                    ),
                    // impedance
                    Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: TextField(
                        controller: _impedanceController,
                        decoration: InputDecoration(
                          labelText: "%Impedance",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5)),
                        ),
                        onChanged: (v) {
                          this.widget.transformer.impedance = double.parse(v);
                        },
                      ),
                    ),
                    // primary voltage
                    Padding(
                      padding: const EdgeInsets.all(6),
                      child: TextField(
                        controller: _primaryVoltageController,
                        decoration: InputDecoration(
                          labelText: "Rated Primary Voltage",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5)),
                        ),
                        onChanged: (v) {
                          this.widget.transformer.primaryVolt = double.parse(v);
                        },
                      ),
                    ),
                    // secondary voltage
                    Padding(
                      padding: const EdgeInsets.all(6),
                      child: TextField(
                        controller: _secondaryVoltageController,
                        decoration: InputDecoration(
                          labelText: "Rated Secondary Voltage",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5)),
                        ),
                        onChanged: (v) {
                          this.widget.transformer.secondaryVolt =
                              double.parse(v);
                        },
                      ),
                    ),
                    // next maintenance
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
                          this.widget.transformer.nextMant = v;
                        },
                      ),
                    ),
                    // manufacturing year
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
                          this.widget.transformer.manYear = int.parse(v);
                        },
                      ),
                    ),
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
