import 'package:flutter/material.dart';
import 'package:foodappp/service/database.dart';
import 'package:foodappp/service/shared_pref.dart';
import 'package:foodappp/service/widget_support.dart';
import 'package:random_string/random_string.dart';
import 'package:foodappp/service/place_order.dart';

class DetailPage extends StatefulWidget {
  final String image;
  final String name;
  final String price;

  const DetailPage({
    super.key,
    required this.image,
    required this.name,
    required this.price,
  });

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final TextEditingController addressController = TextEditingController();
  String? name, id, email, address;
  int quantity = 1;
  int totalPrice = 0;
  bool isProcessing = false;

  @override
  void initState() {
    super.initState();
    totalPrice = int.parse(widget.price);
    getSharedPref();
  }

  Future<void> getSharedPref() async {
    name = await SharedPreferenceHelper().getUserName();
    id = await SharedPreferenceHelper().getUserId();
    email = await SharedPreferenceHelper().getUserEmail();
    address = await SharedPreferenceHelper().getUserAddress();
    setState(() {});
  }

  Future<void> fakePayment(String amount) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const AlertDialog(
        content: Row(
          children: [
            CircularProgressIndicator(),
            SizedBox(width: 20),
            Text("Processing Payment..."),
          ],
        ),
      ),
    );

    await Future.delayed(const Duration(seconds: 2));
    Navigator.pop(context);

    if (id == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("User ID not found. Please log in again.")),
      );
      return;
    }

    String orderId = randomAlphaNumeric(10);
    Map<String, dynamic> orderData = {
      "Name": name,
      "Id": id,
      "quantity": quantity.toString(),
      "Total": totalPrice.toString(),
      "Email": email,
      "FoodName": widget.name,
      "FoodImage": widget.image,
      "OrderId": orderId,
      "Status": "pending",
      "Address": address ?? addressController.text.trim(),
      "timestamp": DateTime.now(),
    };

    await DatabaseMethods().addUserOrderDetails(orderData, id!, orderId);
    await DatabaseMethods().addAdminOrderDetails(orderData, orderId);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => PlaceOrderPage(orderData: orderData)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildBackButton(),
            const SizedBox(height: 10.0),
            Center(
              child: Image.asset(
                widget.image,
                height: MediaQuery.of(context).size.height * 0.3,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 20.0),
            Text(widget.name, style: AppWidget.HeadlineTextFeildStyle()),
            Text("₹${widget.price}", style: AppWidget.priceTextFeildStyle()),
            const SizedBox(height: 20.0),
            const Text(
              "Congratulations! Your mouthwatering meal is ready to be served — made with love. Enjoy every bite!",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 30.0),
            Text("Quantity", style: AppWidget.SimpleTextFeildStyle()),
            const SizedBox(height: 10.0),
            _buildQuantitySelector(),
            const SizedBox(height: 40.0),
            _buildBottomBar(width),
          ],
        ),
      ),
    );
  }

  Widget _buildBackButton() {
    return IconButton(
      onPressed: () => Navigator.pop(context),
      icon: const Icon(Icons.arrow_back, color: Colors.white),
      style: IconButton.styleFrom(
        backgroundColor: const Color(0xffef2b39),
        padding: const EdgeInsets.all(10),
      ),
    );
  }

  Widget _buildQuantitySelector() {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            quantity++;
            totalPrice += int.parse(widget.price);
            setState(() {});
          },
          child: _qtyButton(Icons.add),
        ),
        const SizedBox(width: 20.0),
        Text(quantity.toString(), style: AppWidget.HeadlineTextFeildStyle()),
        const SizedBox(width: 20.0),
        GestureDetector(
          onTap: () {
            if (quantity > 1) {
              quantity--;
              totalPrice -= int.parse(widget.price);
              setState(() {});
            }
          },
          child: _qtyButton(Icons.remove),
        ),
      ],
    );
  }

  Widget _buildBottomBar(double width) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Material(
          elevation: 3.0,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            height: 60,
            width: width * 0.3,
            decoration: BoxDecoration(
              color: const Color(0xffef2b39),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: Text("₹$totalPrice", style: AppWidget.boldWhiteTextFeildStyle()),
            ),
          ),
        ),
        const SizedBox(width: 20.0),
        GestureDetector(
          onTap: () async {
            if (isProcessing) return;
            setState(() => isProcessing = true);

            if (address == null || address!.isEmpty) {
              _openAddressDialog();
            } else {
              await fakePayment(totalPrice.toString());
            }

            setState(() => isProcessing = false);
          },
          child: Material(
            elevation: 3.0,
            borderRadius: BorderRadius.circular(20),
            child: Container(
              height: 70,
              width: width * 0.45,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: isProcessing
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text("ORDER NOW", style: AppWidget.WhiteTextFeildStyle()),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _qtyButton(IconData icon) {
    return Material(
      elevation: 3.0,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: const Color(0xffef2b39),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: Colors.white, size: 30.0),
      ),
    );
  }

  void _openAddressDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Add Address"),
        content: TextField(
          controller: addressController,
          decoration: const InputDecoration(hintText: "Enter your address"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              if (addressController.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Please enter a valid address.")),
                );
                return;
              }
              await SharedPreferenceHelper().saveUserAddress(addressController.text.trim());
              setState(() => address = addressController.text.trim());
              Navigator.pop(context);
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }
}
