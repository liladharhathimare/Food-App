import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodappp/pages/login.dart';
import 'package:foodappp/service/database.dart';
import 'package:foodappp/service/shared_pref.dart';
import 'package:foodappp/service/widget_support.dart';
import 'bottomnav.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isPasswordVisible = false;

  Future<void> registration() async {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text;

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text("Please fill all fields"),
        ),
      );
      return;
    }

    try {
      final userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      final user = userCredential.user;
      if (user != null) {
        final uid = user.uid;

        final userInfoMap = {
          "Name": name,
          "Email": email,
          "Id": uid,
          "Image": "images/boy.jpg",
          "Address": "Not added yet",
        };

        // Save locally
        await SharedPreferenceHelper().saveUserEmail(email);
        await SharedPreferenceHelper().saveUserName(name);
        await SharedPreferenceHelper().saveUserId(uid);
        await SharedPreferenceHelper().saveUserImage("images/boy.jpg");
        await SharedPreferenceHelper().saveUserAddress("Not added yet");

        // Save to Firestore
        await DatabaseMethods().addUserDetails(userInfoMap, uid);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.green,
            content: Text("Registered successfully"),
          ),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const BottomNav()),
        );
      }
    } on FirebaseAuthException catch (e) {
      final errorMsg = e.code == 'weak-password'
          ? "Password provided is too weak"
          : e.code == 'email-already-in-use'
          ? "Account already exists"
          : "Registration failed";

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.orangeAccent,
          content: Text(errorMsg),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(), // dismiss keyboard
        child: Stack(
          children: [
            // Top Background
            Container(
              height: screenHeight / 2.5,
              width: screenWidth,
              padding: const EdgeInsets.only(top: 30),
              decoration: const BoxDecoration(
                color: Color(0xffffefbf),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
              ),
              child: Column(
                children: [
                  Image.asset("images/pan.png", height: 180, width: 240, fit: BoxFit.fill),
                  Image.asset("images/logo.png", height: 50, width: 150, fit: BoxFit.cover),
                ],
              ),
            ),

            // Sign Up Form
            Container(
              margin: EdgeInsets.only(
                top: screenHeight / 3.2,
                left: 20,
                right: 20,
              ),
              child: Material(
                elevation: 3,
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  height: screenHeight / 1.65,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(child: Text("Sign Up", style: AppWidget.HeadlineTextFeildStyle())),
                        const SizedBox(height: 30),

                        // Name
                        Text("Name", style: AppWidget.SignUpTextFeildStyle()),
                        const SizedBox(height: 5),
                        _buildTextField(controller: nameController, hint: "Enter Name", icon: Icons.person),

                        const SizedBox(height: 20),
                        Text("Email", style: AppWidget.SignUpTextFeildStyle()),
                        const SizedBox(height: 5),
                        _buildTextField(controller: emailController, hint: "Enter Email", icon: Icons.email),

                        const SizedBox(height: 20),
                        Text("Password", style: AppWidget.SignUpTextFeildStyle()),
                        const SizedBox(height: 5),
                        _buildTextField(
                          controller: passwordController,
                          hint: "Enter Password",
                          icon: Icons.lock_outline,
                          isPassword: true,
                        ),

                        const SizedBox(height: 30),
                        Center(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xffef2b39),
                              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            onPressed: registration,
                            child: Text("Sign Up", style: AppWidget.boldWhiteTextFeildStyle()),
                          ),
                        ),

                        const SizedBox(height: 25),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Already have an account?", style: AppWidget.SimpleTextFeildStyle()),
                            const SizedBox(width: 10),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (_) => const LogIn()),
                                );
                              },
                              child: Text("Log In", style: AppWidget.boldTextFeildStyle()),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool isPassword = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFececf8),
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword && !isPasswordVisible,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hint,
          prefixIcon: Icon(icon),
          suffixIcon: isPassword
              ? IconButton(
            icon: Icon(
              isPasswordVisible ? Icons.visibility_off : Icons.visibility,
            ),
            onPressed: () {
              setState(() {
                isPasswordVisible = !isPasswordVisible;
              });
            },
          )
              : null,
        ),
      ),
    );
  }
}
