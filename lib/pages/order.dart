import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foodappp/service/database.dart';
import 'package:foodappp/service/shared_pref.dart';
import 'package:foodappp/service/widget_support.dart';

class Order extends StatefulWidget {
  const Order({super.key});

  @override
  State<Order> createState() => _OrderState();
}

class _OrderState extends State<Order> {
  String? id;
  Stream? orderStream;
  final databaseMethods = DatabaseMethods();

  getSharedPref() async {
    id = await SharedPreferenceHelper().getUserId();
    if (id != null) {
      orderStream = await databaseMethods.getUserOrders(id!);
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    getSharedPref();
  }

  Widget allOrders(BoxConstraints constraints) {
    return StreamBuilder(
      stream: orderStream,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data.docs.isEmpty) {
          return const Center(child: Text("No orders placed yet."));
        }

        return ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: snapshot.data.docs.length,
          itemBuilder: (context, index) {
            DocumentSnapshot ds = snapshot.data.docs[index];

            String rawStatus = ds["Status"] ?? "Pending";
            String displayStatus = rawStatus.toString().toUpperCase() == "PENDING"
                ? "DELIVERED"
                : rawStatus.toString().toUpperCase();

            Color statusColor = displayStatus == "DELIVERED"
                ? Colors.green
                : displayStatus == "CANCELLED"
                ? Colors.grey
                : Colors.red;

            double imageSize = constraints.maxWidth < 600 ? 100 : 120;

            return Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 800),
                margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                child: Material(
                  elevation: 3.0,
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.location_on_outlined, color: Color(0xffef2b39)),
                            const SizedBox(width: 10.0),
                            Expanded(
                              child: Text(
                                ds["Address"] ?? "No address",
                                style: AppWidget.SimpleTextFeildStyle(),
                              ),
                            ),
                          ],
                        ),
                        const Divider(),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.asset(
                                ds["FoodImage"],
                                height: imageSize,
                                width: imageSize,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.broken_image, size: 100),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(ds["FoodName"], style: AppWidget.boldTextFeildStyle()),
                                  const SizedBox(height: 5),
                                  Row(
                                    children: [
                                      const Icon(Icons.format_list_numbered, color: Color(0xffef2b39), size: 18),
                                      const SizedBox(width: 5),
                                      Text("Qty: ${ds["quantity"]}", style: AppWidget.SimpleTextFeildStyle()),
                                      const Spacer(),
                                      const Icon(Icons.monetization_on, color: Color(0xffef2b39), size: 18),
                                      const SizedBox(width: 5),
                                      Text("₹${ds["Total"]}", style: AppWidget.priceTextFeildStyle()),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    displayStatus,
                                    style: TextStyle(
                                      color: statusColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            margin: const EdgeInsets.only(top: 40.0),
            child: Column(
              children: [
                Center(child: Text("Orders", style: AppWidget.HeadlineTextFeildStyle())),
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
                    padding: const EdgeInsets.all(10),
                    child: allOrders(constraints),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
