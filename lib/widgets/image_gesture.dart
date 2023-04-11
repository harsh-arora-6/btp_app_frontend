import 'package:flutter/material.dart';

class ImageGesture extends StatelessWidget {
  final String asset;
  final double height;
  final String id;
  final Widget formWidget;

  const ImageGesture(this.asset, this.height, this.id, this.formWidget,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        //TODO:show alert for deleting if its a transformer
      },
      onTap: () {
        print('Image Gesture');
        showModalBottomSheet(
            isScrollControlled: true,
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
          height: height,
        ),
      ),
    );
  }
}
