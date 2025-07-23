import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:foodappp/pages/login.dart';
import 'package:foodappp/service/widget_support.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  Future<void> completeOnboarding() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_seen', true);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LogIn()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double screenWidth = constraints.maxWidth;

        return Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Image section
                  Image.asset(
                    "images/onboard.png",
                    width: screenWidth > 600 ? 400 : screenWidth * 0.8,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 30.0),

                  // Headline
                  Text(
                    "The Fastest\nFood Delivery",
                    textAlign: TextAlign.center,
                    style: AppWidget.HeadlineTextFeildStyle(),
                  ),
                  const SizedBox(height: 20.0),

                  // Subtitle
                  Text(
                    "Craving something delicious?\nOrder now and get your favorites\ndelivered fast!",
                    textAlign: TextAlign.center,
                    style: AppWidget.SimpleTextFeildStyle(),
                  ),
                  const SizedBox(height: 40.0),

                  // Get Started Button
                  SizedBox(
                    width: screenWidth > 600 ? 300 : screenWidth * 0.6,
                    height: 55,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xffBc592a),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: completeOnboarding,
                      child: const Text(
                        "Get Started",
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
