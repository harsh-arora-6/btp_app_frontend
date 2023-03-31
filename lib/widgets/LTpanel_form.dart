import 'package:btp_app_mac/Models/LTModel.dart';
import 'package:flutter/material.dart';

class LTPanelForm extends StatefulWidget {
  LTModel ltModel;
  LTPanelForm(this.ltModel);

  @override
  State<LTPanelForm> createState() => _LTPanelFormState();
}

class _LTPanelFormState extends State<LTPanelForm> {
  final TextEditingController _incomersController = TextEditingController();
  final TextEditingController _outgoingController = TextEditingController();
  final TextEditingController _incomingCurrentController =
      TextEditingController();
  final TextEditingController _outgoingCurrentController =
      TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    LTModel lt = this.widget.ltModel;
    _incomersController.text = lt.incomers.toString();
    _outgoingController.text = lt.outgoing.toString();
    _incomingCurrentController.text = lt.current_in.toString();
    _outgoingCurrentController.text = lt.current_out.toString();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(5)),
        child: Center(
            child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Text(
                        "LT Panel Data",
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(6),
                      child: TextField(
                        controller: _incomersController,
                        decoration: InputDecoration(
                          labelText: "Incomers",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5)),
                        ),
                        onChanged: (v) {
                          // this.widget.transformer.name = v;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(6),
                      child: TextField(
                        controller: _outgoingController,
                        decoration: InputDecoration(
                          labelText: "Outgoings",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5)),
                        ),
                        onChanged: (v) {
                          //  this.widget.transformer.ratedPower = cas
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: TextField(
                        controller: _incomingCurrentController,
                        decoration: InputDecoration(
                          labelText: "Incoming Current",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5)),
                        ),
                        onChanged: (v) {
                          // this.widget.transformer.name = v;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(6),
                      child: TextField(
                        controller: _outgoingCurrentController,
                        decoration: InputDecoration(
                          labelText: "Outgoing Current",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5)),
                        ),
                        onChanged: (v) {
                          // this.widget.cabel.name = v;
                        },
                      ),
                    ),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text("Save"))
                  ],
                ))),
      ),
    );
  }
}
