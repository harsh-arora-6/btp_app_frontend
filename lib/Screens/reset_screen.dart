import 'package:btp_app_mac/Models/data_provider.dart';
import 'package:btp_app_mac/main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';
import '../Models/user_model.dart';
import '../Utilities/user_api.dart';
import 'home.dart';

class ResetScreen extends StatefulWidget {
  const ResetScreen({super.key});

  @override
  _ResetScreenState createState() => _ResetScreenState();
}

class _ResetScreenState extends State<ResetScreen> {
  bool isResetting = false;
  bool isObscured1 = true;
  bool isObscured2 = true;
  TextEditingController otpController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Reset Password Page"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
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
            //otp
            Padding(
              //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: TextFormField(
                controller: otpController,
                autofocus: true,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'OTP',
                    hintText: 'Enter your otp'),
                onChanged: (text) {
                  // setState(() {
                  //   emailController.text = text;
                  // });
                },
                validator: (value) {
                  if (value == null || value.length != 6) {
                    return 'Please enter valid otp';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(
              height: 10,
            ),

            //password field
            Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 15, bottom: 0),
              //padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextFormField(
                  obscureText: isObscured1,
                  controller: passwordController,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: 'Password',
                    hintText: 'Enter secure password',
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          isObscured1 = !isObscured1;
                        });
                      },
                      icon: isObscured1
                          ? const Icon(Icons.visibility)
                          : const Icon(Icons.visibility_off),
                    ),
                  ),
                  validator: (value) {
                    if (passwordController.text.length < 8) {
                      return 'Password must be at least 8 characters long';
                    }
                    return null;
                  },
                  onChanged: (text) {}),
            ),
            //confirm password field
            Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 15, bottom: 0),
              //padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextFormField(
                  obscureText: isObscured1,
                  controller: confirmPasswordController,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: 'Confirm Password',
                    hintText: 'Enter secure password',
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          isObscured2 = !isObscured2;
                        });
                      },
                      icon: isObscured2
                          ? const Icon(Icons.visibility)
                          : const Icon(Icons.visibility_off),
                    ),
                  ),
                  validator: (value) {
                    if (confirmPasswordController.text.length < 8) {
                      return 'Password must be at least 8 characters long';
                    }
                    return null;
                  },
                  onChanged: (text) {}),
            ),
            const SizedBox(
              height: 10,
            ),
            //Reset Button
            Container(
                height: 50,
                width: 250,
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(20)),
                child: TextButton(
                  onPressed: () async {
                    setState(() {
                      isResetting = true;
                    });
                    String message = await resetPassword(
                        otpController.text,
                        passwordController.text,
                        confirmPasswordController.text);
                    if (message == 'Password Changed Successfully') {
                      setState(() {
                        isResetting = false;
                        otpController.text = "";
                        passwordController.text = "";
                        confirmPasswordController.text = "";
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(message),
                        ),
                      );
                      //return to login screen
                      Navigator.pop(context);
                    } else {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('${message}'),
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
                        isResetting = false;
                        otpController.text = "";
                        passwordController.text = "";
                        confirmPasswordController.text = "";
                      });
                    }
                  },
                  child: isResetting
                      ? const CircularProgressIndicator(
                          backgroundColor: Colors.white,
                        )
                      : const Text(
                          'Reset',
                          style: TextStyle(color: Colors.white, fontSize: 25),
                        ),
                )),
            const SizedBox(
              height: 130,
            ),
          ],
        ),
      ),
    );
  }
}
