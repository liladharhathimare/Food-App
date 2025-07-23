import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

import 'home.dart';
import 'order.dart';
import 'wallet.dart';
import 'profile.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int currentTabIndex = 0;

  late final List<Widget> pages;

  @override
  void initState() {
    super.initState();
    pages = const [
      Home(),
      Order(),
      Wallet(),
      Profile(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        index: currentTabIndex,
        height: 60,
        backgroundColor: Colors.transparent,
        color: Colors.black,
        buttonBackgroundColor: Colors.black,
        animationCurve: Curves.easeInOut,
        animationDuration: const Duration(milliseconds: 400),
        onTap: (index) {
          setState(() {
            currentTabIndex = index;
          });
        },
        items: const [
          Icon(Icons.home, size: 28, color: Colors.white),
          Icon(Icons.shopping_bag_outlined, size: 28, color: Colors.white),
          Icon(Icons.account_balance_wallet, size: 28, color: Colors.white),
          Icon(Icons.person_outline, size: 28, color: Colors.white),
        ],
      ),
      body: pages[currentTabIndex],
    );
  }
}
