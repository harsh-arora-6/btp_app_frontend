import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Models/data_provider.dart';
import '../Utilities/api_calls.dart';

class ComponentForm extends StatefulWidget {
  final String childName;
  dynamic model;
  ComponentForm(this.childName, this.model, {super.key});

  @override
  State<ComponentForm> createState() => _ComponentFormState();
}

class _ComponentFormState extends State<ComponentForm> {
  int numberOfItems = 0;
  List<String> keysList = [];
  List<TextEditingController> controllers = [];
  List<dynamic> values = [];

  @override
  void initState() {
    super.initState();
    getDataAndFields();
  }

  @override
  void dispose() {
    for (var element in controllers) {
      element.dispose(); // to avoid memory leaks
    }
    super.dispose();
  }

  Future<void> fetchData() async {
    try {
      widget.model = await getComponent(widget.model.id, widget.childName);
    } catch (onError) {
      throw Exception(onError);
    }
  }

  void getFields() {
    setState(() {
      numberOfItems = widget.model.properties.length;
      keysList = widget.model.properties.keys.toList();
      values = widget.model.properties.values.toList();
      controllers =
          List.generate(2 * numberOfItems, (index) => TextEditingController());
      for (int i = 0; i < numberOfItems; i++) {
        controllers[2 * i].text = keysList[i];
        controllers[2 * i + 1].text = values[i].toString();
      }
    });
  }

  void getDataAndFields() async {
    await fetchData();
    getFields();
  }

  void addNewTextField() {
    setState(() {
      numberOfItems = numberOfItems + 1;
      controllers.add(TextEditingController());
      controllers.add(TextEditingController());
      keysList.add('Untitled');
      // Give untitled as default value
      values.add('Untitled');
      // controllers[2 * numberOfItems - 1].text = keysList[numberOfItems - 1];
      // controllers[2 * numberOfItems].text = values[numberOfItems - 1];
    });
  }

  void removeTextField(int idx) {
    setState(() {
      numberOfItems = numberOfItems - 1;
      controllers.removeAt(2 * idx);
      controllers.removeAt(2 * idx);
      keysList.removeAt(idx);
      values.removeAt(idx);
    });
  }

  Map<String, dynamic> getProps() {
    Map<String, dynamic> properties = {};
    for (int i = 0; i < numberOfItems; i++) {
      // if untitled property then don't update them in backend
      if (keysList[i] == 'Untitled' || values[i] == 'Untitled') continue;
      properties[keysList[i]] = values[i];
    }
    return properties;
  }

  Future<void> update() async {
    try {
      // String id = widget.model.id;
      widget.model.properties = getProps();
      // String parentSubstationId = widget.model.parentSubstationId;
      widget.model = await updateComponent(widget.model, widget.childName);
      // var newModel = await getComponent(id, widget.childName);
      //  newModel;
      getFields();
    } catch (onError) {
      throw Exception(onError);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DataProvider>(
      builder: (context, data, child) {
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
                    // label = ${childName} data
                    Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Text(
                        '${widget.childName} Data',
                        style: const TextStyle(fontSize: 20),
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
                                      readOnly: data.user.role != 'admin',
                                      controller: controllers[2 * index],
                                      decoration: InputDecoration(
                                        labelText:
                                            keysList[index], // property name
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                      ),
                                      onChanged: (v) {
                                        keysList[index] =
                                            controllers[2 * index].text;
                                      },
                                    ),
                                  ),
                                  // space between property name and value.
                                  const SizedBox(
                                    width: 10.0,
                                  ),
                                  // property value
                                  Expanded(
                                    child: TextField(
                                      readOnly: data.user.role != 'admin',
                                      controller: controllers[2 * index + 1],
                                      decoration: InputDecoration(
                                        // property value
                                        labelText: values[index].toString(),
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                      ),
                                      onChanged: (v) {
                                        values[index] =
                                            controllers[2 * index + 1].text;
                                      },
                                    ),
                                  ),
                                  // delete button
                                  data.user.role == 'admin'
                                      ? Expanded(
                                          child: GestureDetector(
                                            onTap: () {
                                              //remove text field
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
                                        )
                                      : Container(),
                                ],
                              ),
                            );
                          }),
                    ),
                    //Add field button
                    data.user.role == 'admin'
                        ? GestureDetector(
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
                          )
                        : Container(),
                    // save button or close button
                    data.user.role == 'admin'
                        ? ElevatedButton(
                            onPressed: () async {
                              // update the model at backend
                              await update();
                              if (widget.childName == 'cable') {
                                //todo include feeder here also as it won't have image component like substation
                                data.hideLineInfoWindow();
                                //revert polyline color to red
                                data.updatePolylineColor(
                                    widget.model.id as String);
                              } else {
                                // Navigator.pop(context);
                                // data.hideMarkerInfoWindow();
                              }
                            },
                            child: const Text("Save"),
                          )
                        : ElevatedButton(
                            onPressed: () async {
                              if (widget.childName == 'cable') {
                                data.hideLineInfoWindow();
                                //revert polyline color to red
                                data.updatePolylineColor(
                                    widget.model.id as String);
                              } else {
                                Navigator.pop(context);
                                // data.hideMarkerInfoWindow();
                              }
                            },
                            child: const Text("Close"),
                          ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
