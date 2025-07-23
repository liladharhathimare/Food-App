import 'package:flutter/material.dart';
import '../service/widget_support.dart';

class Wallet extends StatefulWidget {
  const Wallet({super.key});

  @override
  State<Wallet> createState() => _WalletState();
}

class _WalletState extends State<Wallet> {
  double walletBalance = 0.0;
  double? selectedAmount;

  void addMoneyToWallet() {
    if (selectedAmount != null) {
      setState(() {
        walletBalance += selectedAmount!;
        selectedAmount = null;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('₹${walletBalance.toStringAsFixed(2)} added to your wallet.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Widget buildAmountButton(double amount) {
    bool isSelected = selectedAmount == amount;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedAmount = amount;
        });
      },
      child: Container(
        height: 50,
        width: 100,
        decoration: BoxDecoration(
          color: isSelected ? Color(0xffef2b39) : Colors.white,
          border: Border.all(
            color: isSelected ? Color(0xffef2b39) : Colors.black45,
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            "₹$amount",
            style: AppWidget.priceTextFeildStyle().copyWith(
              color: isSelected ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.only(top: 40.0),
        child: Column(
          children: [
            Center(child: Text("Wallet", style: AppWidget.HeadlineTextFeildStyle())),
            const SizedBox(height: 10.0),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color(0xFFececf8),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 20.0),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Material(
                        elevation: 3.0,
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              Image.asset(
                                "images/wallet.png",
                                height: 80,
                                width: 80,
                                fit: BoxFit.cover,
                              ),
                              const SizedBox(width: 40.0),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Your Wallet", style: AppWidget.boldTextFeildStyle()),
                                  Text("₹${walletBalance.toStringAsFixed(2)}",
                                      style: AppWidget.HeadlineTextFeildStyle()),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          buildAmountButton(50),
                          buildAmountButton(100),
                          buildAmountButton(500),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30.0),
                    GestureDetector(
                      onTap: addMoneyToWallet,
                      child: Container(
                        height: 50,
                        margin: const EdgeInsets.symmetric(horizontal: 20.0),
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: Color(0xffef2b39),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text("Add Money", style: AppWidget.boldTextFeildStyle().copyWith(color: Colors.white)),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
