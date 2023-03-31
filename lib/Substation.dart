import 'package:btp_app_mac/Models/LTModel.dart';
import 'package:btp_app_mac/Models/RMUModel.dart';
import 'package:btp_app_mac/Models/TransformerModel.dart';
import 'package:btp_app_mac/Utilities/icon_from_image.dart';
import 'package:btp_app_mac/widgets/LTpanel_form.dart';
import 'package:btp_app_mac/widgets/image_gesture.dart';
import 'package:btp_app_mac/widgets/rmu_form.dart';
import 'package:btp_app_mac/widgets/transformer_form.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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
              Center(
                  child: ImageGesture('assets/images/RMU.png', 20,
                      'RMU Information', RMUForm(RMUModel(0, 0)))),
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
                                TransformerForm(transformerModel("", "", 0, 0,
                                    "2023", 0, 0, 2021, "substation 1")));
                          }),
                    ),
                  ),
                  GestureDetector(
                      onTap: () {
                        setState(() {
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
                          )))
                ],
              ),
              ImageGesture('assets/images/LT_Panel.png', 70,
                  'LT Panel Information', LTPanelForm(LTModel(0, 0, 0, 0))),
            ],
          ),
        ));
  }
}
