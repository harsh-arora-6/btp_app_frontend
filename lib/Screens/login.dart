import 'package:btp_app_mac/Models/data_provider.dart';
import 'package:btp_app_mac/Screens/signup_screen.dart';
import 'package:btp_app_mac/main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';
import '../Models/user_model.dart';
import '../Utilities/user_api.dart';
import 'forget_screen.dart';
import 'home.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isLoggingIn = false;
  bool isObscured = true;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Login Page"),
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
            //email field
            Padding(
              //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
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
              ),
            ),
            //password field
            Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 15, bottom: 0),
              //padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                  obscureText: isObscured,
                  controller: passwordController,
                  decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: 'Password',
                      hintText: 'Enter secure password',
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            isObscured = !isObscured;
                          });
                        },
                        icon: isObscured
                            ? const Icon(Icons.visibility)
                            : const Icon(Icons.visibility_off),
                      )),
                  onChanged: (text) {}),
            ),
            //Forget password button
            TextButton(
              onPressed: () {
                //TODO: FORGOT PASSWORD SCREEN GOES HERE
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ForgetScreen(),
                  ),
                );
              },
              child: const Text(
                'Forgot Password',
                style: TextStyle(color: Colors.blue, fontSize: 15),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            //Login Button
            Container(
              height: 50,
              width: 250,
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(20)),
              child: Consumer<DataProvider>(
                builder: (context, data, child) {
                  return TextButton(
                    onPressed: () async {
                      setState(() {
                        isLoggingIn = true;
                      });
                      Tuple2<UserModel, String> res = await login(
                          emailController.text, passwordController.text);
                      UserModel user = res.item1;
                      data.updateUser(user);
                      if (data.user.name != '') {
                        setState(() {
                          isLoggingIn = false;
                          isObscured = true;
                          emailController.text = "";
                          passwordController.text = "";
                        });
                        await Navigator.of(context).push(MaterialPageRoute(
                            builder: (BuildContext context) =>
                                const MyHomePage(title: 'Flutter App')));
                      } else {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('${res.item2}'),
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
                          isLoggingIn = false;
                        });
                      }
                    },
                    child: isLoggingIn
                        ? const CircularProgressIndicator(
                            backgroundColor: Colors.white,
                          )
                        : const Text(
                            'Login',
                            style: TextStyle(color: Colors.white, fontSize: 25),
                          ),
                  );
                },
              ),
            ),
            const SizedBox(
              height: 130,
            ),
            //signup button
            Container(
              height: 50,
              width: 250,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(20)),
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const SignupScreen(),
                    ),
                  );
                },
                child: const Text(
                  'New User? Just Sign up!!',
                  style: TextStyle(
                      color: Colors.blue,
                      fontSize: 18,
                      backgroundColor: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
