import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foodappp/service/widget_support.dart';
import 'package:intl/intl.dart';

class AllOrder extends StatefulWidget {
  const AllOrder({super.key});

  @override
  State<AllOrder> createState() => _AllOrderState();
}

class _AllOrderState extends State<AllOrder> {
  Stream<QuerySnapshot> orderStream = FirebaseFirestore.instance
      .collection("Orders")
      .orderBy("Timestamp", descending: true)
      .snapshots();

  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case "delivered":
        return Colors.green;
      case "preparing":
        return Colors.orange;
      case "cancelled":
        return Colors.red;
      case "pending":
        return Colors.blueGrey;
      default:
        return const Color(0xffef2b39);
    }
  }

  String _formatTimestamp(dynamic timestamp) {
    try {
      if (timestamp is Timestamp) {
        final DateTime date = timestamp.toDate();
        return DateFormat.yMMMd().add_jm().format(date);
      }
    } catch (_) {}
    return "N/A";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.only(top: 40.0),
        child: Column(
          children: [
            // Top Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xffef2b39),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 20.0),
                  Text("All Orders", style: AppWidget.HeadlineTextFeildStyle()),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Orders List
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
                child: StreamBuilder(
                  stream: orderStream,
                  builder: (context, AsyncSnapshot snapshot) {
                    if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

                    if (snapshot.data.docs.isEmpty) {
                      return const Center(child: Text("No orders found."));
                    }

                    return ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot ds = snapshot.data.docs[index];
                        String orderId = ds.id;
                        String? userId = ds["UserId"];
                        String status = ds["Status"] ?? "Pending";

                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                          child: Material(
                            elevation: 3.0,
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                      Image.network(
                                        ds["FoodImage"] ?? "",
                                        height: 100,
                                        width: 100,
                                        fit: BoxFit.cover,
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              ds["FoodName"] ?? "Unknown Food",
                                              style: AppWidget.boldWhiteTextFeildStyle(),
                                            ),
                                            const SizedBox(height: 5),
                                            Row(
                                              children: [
                                                const Icon(Icons.format_list_numbered, color: Color(0xffef2b39)),
                                                const SizedBox(width: 5),
                                                Text("Qty: ${ds["quantity"]}", style: AppWidget.SimpleTextFeildStyle()),
                                                const Spacer(),
                                                const Icon(Icons.monetization_on, color: Color(0xffef2b39)),
                                                const SizedBox(width: 5),
                                                Text("₹${ds["Total"]}", style: AppWidget.priceTextFeildStyle()),
                                              ],
                                            ),
                                            const SizedBox(height: 5),
                                            Text(
                                              "Ordered: ${_formatTimestamp(ds["Timestamp"])}",
                                              style: const TextStyle(fontSize: 12, color: Colors.grey),
                                            ),
                                            const SizedBox(height: 8),
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                              decoration: BoxDecoration(
                                                color: _getStatusColor(status),
                                                borderRadius: BorderRadius.circular(20),
                                              ),
                                              child: Text(
                                                status,
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 10),
                                            if (status.toLowerCase() != "delivered")
                                              Align(
                                                alignment: Alignment.centerRight,
                                                child: ElevatedButton(
                                                  onPressed: () async {
                                                    await FirebaseFirestore.instance
                                                        .collection("Orders")
                                                        .doc(orderId)
                                                        .update({"Status": "Delivered"});

                                                    if (userId != null) {
                                                      await FirebaseFirestore.instance
                                                          .collection("users")
                                                          .doc(userId)
                                                          .collection("Orders")
                                                          .doc(orderId)
                                                          .update({"Status": "Delivered"});
                                                    }

                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                      const SnackBar(content: Text("Order marked as Delivered")),
                                                    );
                                                  },
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor: Colors.green,
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(20),
                                                    ),
                                                  ),
                                                  child: const Text("Mark as Delivered"),
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
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
