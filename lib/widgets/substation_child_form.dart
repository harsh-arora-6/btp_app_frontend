import 'package:flutter/material.dart';

import '../Models/substation_child_model.dart';

class SubstationChildForm extends StatefulWidget {
  final String childName;
  final SubstationChildModel substationChildModel;
  SubstationChildForm(this.childName, this.substationChildModel, {super.key});

  @override
  State<SubstationChildForm> createState() => _SubstationChildFormState();
}

class _SubstationChildFormState extends State<SubstationChildForm> {
  late List<String> keysList;
  late final int numberOfFields;
  late final List<TextEditingController> _controllers;
  List<Widget> widgets = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    numberOfFields = widget.substationChildModel.properties.length;
    keysList = widget.substationChildModel.properties.keys.toList();
    _controllers =
        List.generate(numberOfFields, (index) => TextEditingController());
    for (int i = 0; i < numberOfFields; i++) {
      widgets.add(
        Padding(
          padding: const EdgeInsets.all(6),
          child: TextField(
            controller: _controllers[i],
            decoration: InputDecoration(
              labelText: keysList[i],
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
            ),
            onChanged: (v) {
              // this.widget.transformer.name = v;
            },
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    for (var element in _controllers) {
      element.dispose();
    }
    super.dispose();
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
                Padding(
                  padding: EdgeInsets.all(6.0),
                  child: Text(
                    '${widget.childName} Data',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                ...widgets,
                // save button
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Save"))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
