import 'package:btp_app_mac/Models/data_provider.dart';
import 'package:btp_app_mac/Utilities/cache.dart';
import 'package:btp_app_mac/Utilities/transformer_api.dart';
import 'package:btp_app_mac/widgets/image_gesture.dart';
import 'package:btp_app_mac/widgets/component_form.dart';
import 'package:flutter/material.dart';
import 'package:btp_app_mac/Models/substation_child_model.dart';
import 'package:btp_app_mac/Utilities/substation_child_api.dart';
import 'package:provider/provider.dart';

import 'Utilities/api_calls.dart';

class SubstationWidget extends StatefulWidget {
  final String substationId;
  const SubstationWidget(this.substationId, {super.key});
  @override
  State<SubstationWidget> createState() => _SubstationWidgetState();
}

class _SubstationWidgetState extends State<SubstationWidget> {
  dynamic rmu = SubstationChildModel(
      "rmu_id", <String, dynamic>{}, "parent substation id");
  dynamic ltpanel = SubstationChildModel(
      "ltpanel_id", <String, dynamic>{}, "parent substation id");
  List<dynamic> transformers = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // // second parameter is used in url.
    fetchData();
  }

  void fetchData() async {
    //todo:fetching the rmu,transformer,ltpanel from cache from substation id
    dynamic substation =
        await CacheService.getFromCache('substation', widget.substationId);
    dynamic newRmu = await CacheService.getFromCache('rmu', substation.rmu.id);
    dynamic newLtpanel =
        await CacheService.getFromCache('ltpanel', substation.lt_panel.id);
    List<dynamic> trList = [];

    for (SubstationChildModel tr in substation.trList) {
      trList.add(await CacheService.getFromCache('transformer', tr.id));
    }
    // dynamic newRmu =
    //     await getSubstationChildBasedOnSubstationId(widget.substationId, 'rmu');
    // dynamic newLtpanel = await getSubstationChildBasedOnSubstationId(
    //     widget.substationId, 'ltpanel');
    // List<dynamic> trList =
    //     await getAllSubstationChild(widget.substationId, 'transformer');
    setState(() {
      rmu = newRmu;
      ltpanel = newLtpanel;
      transformers = trList;
    });
  }

  void removeTransformer(int index) async {
    //todo:delete transformer from cache
    //key stored so that we know we need to delete this from backend
    await CacheService.putMap('delete transformer',
        transformers[index].id as String, <String, dynamic>{});
    //delete from cache
    await CacheService.deleteMap(
        'transformer', transformers[index].id as String);

    // await deleteComponent(transformers[index].id as String, 'transformer');
    setState(() {
      transformers.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DataProvider>(builder: (context, data, child) {
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
                      ComponentForm(
                        'rmu',
                        rmu,
                      ),
                      null,
                      null),
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
                                  ComponentForm(
                                    'transformer',
                                    transformers[i],
                                  ),
                                  removeTransformer,
                                  i);
                            }),
                      ),
                    ),
                    //TODO:transformer add button:-create new transformer
                    data.user.role == 'admin'
                        ? GestureDetector(
                            onTap: () async {
                              //TODO: create a new transformer
                              try {
                                SubstationChildModel newTransformer =
                                    await createTransformer(
                                        SubstationChildModel(
                                            'id',
                                            <String, dynamic>{},
                                            widget.substationId));
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
                        : Container()
                  ],
                ),
                // LT panel gesture image
                ImageGesture(
                    'assets/images/LT_Panel.png',
                    70,
                    'LT Panel Information',
                    ComponentForm(
                      'ltpanel',
                      ltpanel,
                    ),
                    null,
                    null),
              ],
            ),
          ));
    });
  }
}
