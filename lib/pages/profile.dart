import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../service/shared_pref.dart';
import 'login.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String? name;
  String? email;
  String? imagePath;

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    final helper = SharedPreferenceHelper();
    final fetchedName = await helper.getUserName();
    final fetchedEmail = await helper.getUserEmail();
    final fetchedImage = await helper.getUserImage();

    setState(() {
      name = fetchedName ?? "Jane Doe";
      email = fetchedEmail ?? "jane@example.com";
      imagePath = fetchedImage ?? "images/boy.jpg";
    });
  }

  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
    await SharedPreferenceHelper().clearUserData();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LogIn()),
          (route) => false,
    );
  }

  Widget sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 0, 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget menuTile({
    required IconData icon,
    required String title,
    VoidCallback? onTap,
    Widget? trailing,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.black),
      title: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      trailing: trailing ?? const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfffefefe),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text("Profile", style: TextStyle(color: Colors.black)),
        centerTitle: true,
        leading: const Icon(Icons.arrow_back, color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10),
            Column(
              children: [
                CircleAvatar(
                  radius: 45,
                  backgroundColor: Colors.orangeAccent,
                  backgroundImage: AssetImage(imagePath!),
                ),
                const SizedBox(height: 10),
                Text(
                  name ?? "",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  email ?? "",
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),

            const SizedBox(height: 25),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 10,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Column(
                children: [
                  menuTile(
                    icon: Icons.notifications,
                    title: "Notifications",
                    trailing: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: const Text(
                        "3",
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ),
                  ),
                  menuTile(icon: Icons.lock, title: "Password Update"),
                  sectionTitle("Geography"),
                  menuTile(icon: Icons.location_on, title: "Change location"),
                  menuTile(icon: Icons.language, title: "Change language"),
                  sectionTitle("Membership"),
                  menuTile(icon: Icons.card_giftcard, title: "Loyalty Cards"),
                  menuTile(icon: Icons.verified_user, title: "Membership"),
                  menuTile(icon: Icons.school, title: "Certificates"),
                ],
              ),
            ),

            const SizedBox(height: 25),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: ElevatedButton(
                onPressed: _logout,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text("Log out", style: TextStyle(fontSize: 16)),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
