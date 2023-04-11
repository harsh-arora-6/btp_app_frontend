import 'package:flutter/foundation.dart';
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
  int numberOfItems = 0;
  List<String> keysList = [];
  List<TextEditingController> controllers = [];
  List<String> values = [];

  @override
  // void initState() {
  //   super.initState();
  //   // numberOfFields = widget.substationChildModel.properties.length * 2;
  //   // keysList = widget.substationChildModel.properties.keys.toList();
  //   // values = widget.substationChildModel.properties.values.toList();
  //   // _controllers =
  //   //     List.generate(2 * keysList.length, (index) => TextEditingController());
  // }

  // @override
  // void dispose() {
  //   for (var element in _controllers) {
  //     element.dispose(); // to avoid memory leaks
  //   }
  //   super.dispose();
  // }

  void addNewTextField() {
    setState(() {
      numberOfItems = numberOfItems + 1;
      controllers.add(TextEditingController());
      controllers.add(TextEditingController());
      keysList.add('Property Name Untitled');
      // Give untitled as default value
      values.add('Property Value Untitled');
      print(numberOfItems);
    });
  }

  void removeTextField(int idx) {
    // TODO:somehow we need to find the key associated
    setState(() {
      numberOfItems = numberOfItems - 1;
      controllers.removeAt(2 * idx);
      controllers.removeAt(2 * idx);
      keysList.removeAt(idx);
      values.removeAt(idx);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
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
                //List of properties
                SizedBox(
                  height: 80.0,
                  width: 600.0,
                  child: ListView.builder(
                      itemCount: numberOfItems,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          title: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              // property name
                              Expanded(
                                child: TextField(
                                  controller: controllers[2 * index],
                                  decoration: InputDecoration(
                                    labelText: keysList[index], // property name
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5)),
                                  ),
                                  onChanged: (v) {
                                    // this.widget.transformer.name = v;
                                  },
                                ),
                              ),
                              // space between property name and value.
                              SizedBox(
                                width: 10.0,
                              ),
                              // property value
                              Expanded(
                                child: TextField(
                                  controller: controllers[2 * index + 1],
                                  decoration: InputDecoration(
                                    // property value
                                    labelText: values[index],
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5)),
                                  ),
                                  onChanged: (v) {
                                    // this.widget.transformer.name = v;
                                  },
                                ),
                              ),
                              // delete button
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    // TODO: add text field for new property
                                    removeTextField(index);
                                  },
                                  child: Container(
                                    decoration: const BoxDecoration(
                                        color: Colors.black,
                                        shape: BoxShape.circle),
                                    child: const Padding(
                                      padding: EdgeInsets.all(2.0),
                                      child: Icon(
                                        Icons.delete,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                ),
                GestureDetector(
                  onTap: () {
                    // add new text fields.
                    addNewTextField();
                  },
                  child: Container(
                    decoration: const BoxDecoration(
                        color: Colors.black, shape: BoxShape.circle),
                    child: const Padding(
                      padding: EdgeInsets.all(2.0),
                      child: Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                // save button
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      // TODO:update the child model in backend.
                      // first query based the required child based on substation id
                      // then update it.
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
