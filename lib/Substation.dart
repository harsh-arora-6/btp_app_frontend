import 'package:btp_app_mac/widgets/image_gesture.dart';
import 'package:btp_app_mac/widgets/substation_child_form.dart';
import 'package:flutter/material.dart';
import 'package:btp_app_mac/Models/substation_child_model.dart';

class SubstationWidget extends StatefulWidget {
  const SubstationWidget({Key? key}) : super(key: key);

  @override
  State<SubstationWidget> createState() => _SubstationWidgetState();
}

class _SubstationWidgetState extends State<SubstationWidget> {
  List<int> transformers = [0, 1];
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Rmu gesture image
              Center(
                child: ImageGesture(
                  'assets/images/RMU.png',
                  20,
                  'RMU Information',
                  SubstationChildForm(
                    'Rmu',
                    SubstationChildModel(
                        "rmu_id", <String, dynamic>{}, "parent substation id"),
                  ),
                ),
              ),
              // list of transformers gesture image
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 120,
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: Center(
                      child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: transformers.length,
                          itemBuilder: (context, i) {
                            return ImageGesture(
                              'assets/images/transformer.png',
                              10,
                              'T1 Information',
                              SubstationChildForm(
                                'Transformer',
                                SubstationChildModel(
                                    "Transformer_id",
                                    <String, dynamic>{},
                                    "parent substation id"),
                              ),
                            );
                          }),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        //TODO: create a new transformer
                        transformers.add(1);
                        print(transformers.length);
                      });
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
                ],
              ),
              // LT panel gesture image
              ImageGesture(
                'assets/images/LT_Panel.png',
                70,
                'LT Panel Information',
                SubstationChildForm(
                  'LT Panel',
                  SubstationChildModel("LTpanel_id", <String, dynamic>{},
                      "parent substation id"),
                ),
              ),
            ],
          ),
        ));
  }
}
