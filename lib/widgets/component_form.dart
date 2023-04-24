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
        return Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(5)),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(
                  bottom: 20, left: 10, right: 10, top: 5),
              child: Column(
                children: [
                  // label = ${childName} data
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 15, right: 10, top: 5, bottom: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${widget.childName} Data',
                          style: const TextStyle(fontSize: 20),
                        ),
                        IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.cancel,
                              size: 20,
                              color: Colors.red,
                            ))
                      ],
                    ),
                  ),
                  //List of properties
                  ConstrainedBox(
                    constraints: BoxConstraints(minHeight: 30, maxHeight: 300),
                    child: ListView.builder(
                        itemCount: numberOfItems,
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, int index) {
                          return ListTile(
                            title: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                // property name
                                Expanded(
                                  flex: 3,
                                  child: TextField(
                                    readOnly: data.user.role != 'admin',
                                    controller: controllers[2 * index],
                                    decoration: InputDecoration(
                                      labelText:
                                          'property name', // property name
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
                                  flex: 3,
                                  child: TextField(
                                    readOnly: data.user.role != 'admin',
                                    controller: controllers[2 * index + 1],
                                    decoration: InputDecoration(
                                      // property value
                                      labelText: 'property value',
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
                                          child: const Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 10.0),
                                            child: Icon(
                                              Icons.delete,
                                              color: Colors.red,
                                              size: 20,
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
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Padding(
                              padding: EdgeInsets.all(2.0),
                              child: FloatingActionButton(
                                mini: true,
                                onPressed: () {
                                  addNewTextField();
                                },
                                child: const Icon(
                                  Icons.add,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            ElevatedButton(
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
                          ],
                        )
                      : Container(),
                  // save button or close button
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
