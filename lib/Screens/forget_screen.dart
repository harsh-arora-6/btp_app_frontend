import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Models/data_provider.dart';

class Forget extends StatefulWidget {
  const Forget({super.key});

  @override
  State<Forget> createState() => _ForgetState();
}

class _ForgetState extends State<Forget> {
  TextEditingController emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Forget Password Page"),
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

          //Forget password button
          Container(
            height: 50,
            width: 250,
            decoration: BoxDecoration(
                color: Colors.blue, borderRadius: BorderRadius.circular(20)),
            child: Consumer<DataProvider>(
              builder: (context, data, child) {
                return TextButton(
                  onPressed: () {
                    //TODO FORGOT PASSWORD SCREEN GOES HERE
                  },
                  child: const Text(
                    'Forgot Password',
                    style: TextStyle(color: Colors.blue, fontSize: 15),
                  ),
                );
              },
            ),
          ),
        ]),
      ),
    );
  }
}
