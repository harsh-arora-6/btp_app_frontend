import 'package:btp_app_mac/Screens/reset_screen.dart';
import 'package:btp_app_mac/Utilities/user_api.dart';
import 'package:flutter/material.dart';

class ForgetScreen extends StatefulWidget {
  const ForgetScreen({super.key});

  @override
  State<ForgetScreen> createState() => _ForgetScreenState();
}

class _ForgetScreenState extends State<ForgetScreen> {
  TextEditingController emailController = TextEditingController();
  bool isSubmitting = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("ForgetScreen Password Page"),
      ),
      body: SingleChildScrollView(
        child: Column(children: <Widget>[
          //logo
          Padding(
            padding: const EdgeInsets.only(top: 60.0),
            child: Center(
              child: Container(
                  width: 200,
                  height: 150,
                  /*decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(50.0)),*/
                  child: Image.asset('assets/images/iit-roorkee-logo.png')),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          //email field
          Padding(
            //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: TextFormField(
              controller: emailController,
              autofocus: true,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Email',
                  hintText: 'Enter valid email id as abc@gmail.com'),
              onChanged: (text) {
                // setState(() {
                //   emailController.text = text;
                // });
              },
              validator: (value) {
                // Regular expression pattern to match email format
                const pattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
                final regExp = RegExp(pattern);

                if (value == null) {
                  return 'Please enter your email';
                } else if (!regExp.hasMatch(value)) {
                  return 'Please enter a valid email address';
                }
                return null;
              },
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          //ForgetScreen password button
          Container(
            height: 50,
            width: 250,
            decoration: BoxDecoration(
                color: Colors.blue, borderRadius: BorderRadius.circular(20)),
            child: TextButton(
              onPressed: isSubmitting == false
                  ? () async {
                      setState(() {
                        isSubmitting = true;
                      });
                      String message =
                          await forgetPassword(emailController.text);

                      if (message == 'OTP sent to the specified mail') {
                        // print('hello');
                        setState(() {
                          isSubmitting = false;
                          emailController.text = "";
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(message),
                          ),
                        );
                        Navigator.pop(context);
                        await Navigator.of(context).push(MaterialPageRoute(
                            builder: (BuildContext context) =>
                                const ResetScreen()));
                      } else {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text(message),
                                actions: <Widget>[
                                  TextButton(
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Colors.red),
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text("Okay"),
                                  ),
                                ],
                              );
                            });
                        setState(() {
                          isSubmitting = false;
                          emailController.text = "";
                        });
                      }
                    }
                  : null,
              child: isSubmitting
                  ? const CircularProgressIndicator(
                      backgroundColor: Colors.white,
                    )
                  : const Text(
                      'Submit',
                      style: TextStyle(color: Colors.white, fontSize: 25),
                    ),
            ),
          ),
        ]),
      ),
    );
  }
}
