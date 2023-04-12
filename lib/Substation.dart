import 'package:btp_app_mac/Utilities/transformer_api.dart';
import 'package:btp_app_mac/widgets/image_gesture.dart';
import 'package:btp_app_mac/widgets/substation_child_form.dart';
import 'package:flutter/material.dart';
import 'package:btp_app_mac/Models/substation_child_model.dart';
import 'package:btp_app_mac/Utilities/substation_child_api.dart';

class SubstationWidget extends StatefulWidget {
  final String substationId;
  const SubstationWidget(this.substationId, {super.key});
  @override
  State<SubstationWidget> createState() => _SubstationWidgetState();
}

class _SubstationWidgetState extends State<SubstationWidget> {
  SubstationChildModel rmu = SubstationChildModel(
      "rmu_id", <String, dynamic>{}, "parent substation id");
  SubstationChildModel ltpanel = SubstationChildModel(
      "ltpanel_id", <String, dynamic>{}, "parent substation id");
  List<SubstationChildModel> transformers = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // // second parameter is used in url.
    // getSubstationChildBasedOnSubstationId(widget.substationId, 'rmu')
    //     .then((rmuData) {
    //   rmu = rmuData;
    // }).catchError((onError) {
    //   throw Exception(onError);
    // });
    // getSubstationChildBasedOnSubstationId(widget.substationId, 'ltpanel')
    //     .then((ltpanelData) {
    //   ltpanel = ltpanelData;
    // }).catchError((onError) {
    //   throw Exception(onError);
    // });
    // getAllSubstationChild(widget.substationId, 'transformer').then((trList) {
    //   transformers = trList;
    // }).catchError((onError) {
    //   throw Exception(onError);
    // });
  }

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
                    rmu,
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
                              'T$i Information',
                              SubstationChildForm(
                                'Transformer',
                                transformers[i],
                              ),
                            );
                          }),
                    ),
                  ),
                  //TODO:transformer add button:-create new transformer
                  GestureDetector(
                    onTap: () async {
                      //TODO: create a new transformer
                      try {
                        SubstationChildModel newTransformer =
                            await createTransformer(
                                SubstationChildModel('id', <String, dynamic>{},
                                    widget.substationId),
                                'transformer');
                        setState(() {
                          transformers.add(newTransformer);
                        });
                      } catch (error) {
                        throw Exception(error);
                      }
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
                  ltpanel,
                ),
              ),
            ],
          ),
        ));
  }
}
