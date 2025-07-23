import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foodappp/service/widget_support.dart';

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

  final List<String> statusOptions = [
    "Pending",
    "Preparing",
    "Delivered",
    "Cancelled"
  ];

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

  Future<void> updateOrderStatus(String orderId, String newStatus) async {
    await FirebaseFirestore.instance
        .collection("Orders")
        .doc(orderId)
        .update({"Status": newStatus});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.only(top: 40.0),
        child: Column(
          children: [
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
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.data.docs.isEmpty) {
                      return const Center(child: Text("No orders found."));
                    }

                    return ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot ds = snapshot.data.docs[index];
                        String status = ds["Status"] ?? "Pending";
                        String orderId = ds.id;

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
                                        ds["FoodImage"],
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
                                            const SizedBox(height: 10),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
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
                                                DropdownButton<String>(
                                                  value: status,
                                                  underline: Container(),
                                                  icon: const Icon(Icons.arrow_drop_down),
                                                  style: const TextStyle(color: Colors.black),
                                                  onChanged: (String? newValue) async {
                                                    if (newValue != null && newValue != status) {
                                                      bool confirm = await showDialog(
                                                        context: context,
                                                        builder: (ctx) => AlertDialog(
                                                          title: const Text("Confirm Status Change"),
                                                          content: Text("Are you sure you want to mark this order as $newValue?"),
                                                          actions: [
                                                            TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text("No")),
                                                            TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text("Yes")),
                                                          ],
                                                        ),
                                                      );

                                                      if (confirm) {
                                                        await updateOrderStatus(orderId, newValue);
                                                        setState(() {});
                                                      }
                                                    }
                                                  },
                                                  items: statusOptions.map((String val) {
                                                    return DropdownMenuItem<String>(
                                                      value: val,
                                                      child: Text(val),
                                                    );
                                                  }).toList(),
                                                ),
                                              ],
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
