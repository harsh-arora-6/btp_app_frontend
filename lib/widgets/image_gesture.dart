import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ImageGesture extends StatelessWidget {
  final String asset;
  final double height;
  final String id;
  final Widget formWidget;
  // final Function getData;
  final void Function(int)? removeTransformer;
  final int? transformerIdx;
  const ImageGesture(this.asset, this.height, this.id, this.formWidget,
      this.removeTransformer, this.transformerIdx,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        //TODO:show alert for deleting if its a transformer
        if (removeTransformer != null) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("Delete Transformer?"),
                content:
                    const Text("Are you sure you want to delete this item?"),
                actions: <Widget>[
                  TextButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.red),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text("CANCEL"),
                  ),
                  TextButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.red),
                    ),
                    onPressed: () {
                      //TODO: perform delete operation here
                      Navigator.of(context).pop();
                      removeTransformer!(transformerIdx!);
                    },
                    child: const Text("DELETE"),
                  ),
                ],
              );
            },
          );
        }
      },
      onTap: () {
        if (kDebugMode) {
          print('Image Gesture');
        }
        // Make get Request
        // getData();
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
