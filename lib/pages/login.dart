import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../service/shared_pref.dart';
import '../service/widget_support.dart';

import 'signup.dart';
import 'bottomnav.dart';

class LogIn extends StatefulWidget {
  const LogIn({super.key});

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  String email = "", password = "";

  TextEditingController mailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  userLogin() async {
    try {
      final userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      if (user != null) {
        await SharedPreferenceHelper().saveUserId(user.uid);
        await SharedPreferenceHelper().saveUserEmail(user.email ?? '');
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => BottomNav()),
      );
    } on FirebaseAuthException catch (e) {
      String message = '';
      if (e.code == 'user-not-found') {
        message = "No user found for that email";
      } else if (e.code == 'wrong-password') {
        message = "Wrong password provided";
      } else {
        message = "An error occurred";
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message, style: TextStyle(fontSize: 18.0, color: Colors.black)),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isWide = constraints.maxWidth > 600;
        final double horizontalPadding = isWide ? 100 : 20;

        return Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                // Header container
                Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height / 2.5,
                  padding: const EdgeInsets.only(top: 30.0),
                  decoration: const BoxDecoration(
                    color: Color(0xffffefbf),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(40),
                      bottomRight: Radius.circular(40),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset("images/pan.png", height: 180, fit: BoxFit.contain),
                      const SizedBox(height: 10),
                      Image.asset("images/logo.png", width: 150, height: 50, fit: BoxFit.cover),
                    ],
                  ),
                ),

                // Login card
                Container(
                  margin: EdgeInsets.only(top: 30.0),
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 30),
                  width: double.infinity,
                  child: Material(
                    elevation: 3.0,
                    borderRadius: BorderRadius.circular(20),
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Text("Log In", style: AppWidget.HeadlineTextFeildStyle()),
                          ),
                          const SizedBox(height: 30.0),

                          Text("Email", style: AppWidget.SignUpTextFeildStyle()),
                          const SizedBox(height: 5.0),
                          Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFFececf8),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: TextField(
                              controller: mailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: "Enter Email",
                                prefixIcon: Icon(Icons.mail_outline),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20.0),

                          Text("Password", style: AppWidget.SignUpTextFeildStyle()),
                          const SizedBox(height: 5.0),
                          Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFFececf8),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: TextField(
                              controller: passwordController,
                              obscureText: true,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: "Enter Password",
                                prefixIcon: Icon(Icons.password_outlined),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10.0),

                          Align(
                            alignment: Alignment.centerRight,
                            child: Text("Forgot Password?", style: AppWidget.SimpleTextFeildStyle()),
                          ),
                          const SizedBox(height: 40.0),

                          Center(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xffef2b39),
                                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              onPressed: () {
                                if (mailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
                                  setState(() {
                                    email = mailController.text.trim();
                                    password = passwordController.text.trim();
                                  });
                                  userLogin();
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("Please fill all fields", style: TextStyle(fontSize: 16.0)),
                                      backgroundColor: Colors.redAccent,
                                    ),
                                  );
                                }
                              },
                              child: Text("Log In", style: AppWidget.boldWhiteTextFeildStyle()),
                            ),
                          ),

                          const SizedBox(height: 30.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Don't have an account?", style: AppWidget.SimpleTextFeildStyle()),
                              const SizedBox(width: 10.0),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(builder: (context) => const SignUp()),
                                  );
                                },
                                child: Text("Sign Up", style: AppWidget.boldTextFeildStyle()),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
