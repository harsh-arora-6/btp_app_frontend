import 'package:btp_app_mac/Models/TransformerModel.dart';
import 'package:btp_app_mac/widgets/transformer_form.dart';
import 'package:flutter/material.dart';

class ImageGesture extends StatelessWidget {
  String asset;
  double height;
  String id;
  var formWidget;

  ImageGesture(this.asset, this.height, this.id, this.formWidget);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
            context: context,
            builder: (context) {
              return formWidget;
              //TransformerForm(transformerModel("id", "name", 100, 20, "1 jan 2024", 100, 20, 2022, "subs"));
            });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Image.asset(
          asset,
          height: this.height,
        ),
      ),
    );
  }
}
